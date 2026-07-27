#!/bin/bash

# ALBA - Bash Validator Hook
# Event: PreToolUse
# Matcher: Bash
# Purpose: Deny a small set of genuinely catastrophic bash commands.
#
# Two-layer security model:
#   Layer 1 (CC native): permissions.deny / permissions.ask in settings.json.
#                        Command-level rules, including wrapper-bypassed commands
#                        (env/sudo/watch/ionice/setsid) and find -exec/-delete.
#   Layer 2 (this hook): semantic intent detection for patterns that
#                        command-level rules cannot reason about
#                        (fork bombs, pipe-to-shell, disk wipes, SQL drops).
#
# DESIGN RULE - read before adding a pattern:
#   This hook NEVER returns "allow". A PreToolUse "allow" decision *skips the
#   permission prompt*, which would silently lower the friction on every command
#   that happens not to match the blocklist. When nothing matches we produce no
#   output and exit 0, so the normal permission flow applies unchanged.
#   The only decisions this hook can emit are "deny" (a match) and "ask" (the
#   validator itself failed).
#
# Matching is case-SENSITIVE for shell commands (`REBOOT` is not a shell verb,
# and case-insensitive matching is what made the old version block
# `git commit -m "fix reboot handler"`). Only SQL patterns are matched
# case-insensitively, since SQL keywords really are case-free.
#
# Patterns are anchored at a command position via $CMD_START so they match a
# command being *run*, not the same letters appearing inside a message, a path,
# or a filename. Patterns use [[:space:]]+ rather than literal spaces so a tab
# cannot slip past them.
#
# Cross-platform (macOS bash 3.2 + Linux + Git Bash). No bash 4 features.
# `set -e` is deliberately NOT enabled: a hook that aborts halfway would emit no
# decision at all. Instead every failure path funnels into the fail-safe below.

# Fail-safe: if this validator breaks, ask the user rather than staying silent.
# Silence would mean "no decision", which is indistinguishable from "nothing
# matched" - so a broken validator would quietly become a no-op.
trap 'printf "{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"ask\",\"permissionDecisionReason\":\"ALBA bash-validator failed to run. Review this command manually before approving.\"}}\n"; exit 0' ERR

INPUT=$(cat 2>/dev/null) || true

# Extract the command. jq is strongly preferred; the grep fallback below only
# handles the common single-line payload and cannot decode JSON escapes, so on a
# machine without jq this hook degrades to best-effort. Install jq.
COMMAND=""
if command -v jq >/dev/null 2>&1; then
  COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null) || true
fi
if [ -z "$COMMAND" ]; then
  COMMAND=$(printf '%s' "$INPUT" | tr '\n' ' ' \
    | grep -oE '"command"[[:space:]]*:[[:space:]]*"[^"]*"' \
    | head -1 \
    | sed 's/^"command"[[:space:]]*:[[:space:]]*"//;s/"$//') || true
fi

# No command in the payload: no decision, normal permission flow applies.
if [ -z "$COMMAND" ]; then
  exit 0
fi

# A command position: start of string, or right after a separator / subshell
# opener. Without this anchor every pattern below degrades into a substring
# search over arbitrary text (commit messages, grep needles, file names).
#
# Leading VAR=value assignments and known wrapper commands are absorbed too,
# otherwise `sudo rm -rf ~` or `env FOO=1 rm -rf /` would shift the real command
# out of command position and slip past every pattern. Only these specific
# wrapper names are absorbed - a generic "skip a few tokens" rule would let
# `git commit -m "rm -rf /"` match again.
ASSIGN='([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)*'
WRAP_ONE="(sudo|doas|env|command|time|nice|ionice|nohup|setsid|xargs|watch)[[:space:]]+${ASSIGN}((-[^[:space:]]+[[:space:]]+)([^-][^[:space:]]*[[:space:]]+)?)*"
CMD_START="(^|[[:space:]]*[;&|(]+[[:space:]]*)${ASSIGN}(${WRAP_ONE})*"

# `--` terminates grep's option parsing: a pattern starting with `-` (e.g.
# --no-preserve-root) would otherwise be read as a flag.
matches() {
  printf '%s' "$COMMAND" | grep -qE -- "$1" 2>/dev/null
}

# Case-insensitive variant, for SQL only.
matches_sql() {
  printf '%s' "$COMMAND" | grep -qiE -- "$1" 2>/dev/null
}

# Reasons are static ASCII strings without quotes or backslashes, so they need
# no JSON escaping. Keep it that way - never interpolate $COMMAND in here.
deny() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Blocked by ALBA bash-validator: %s. If this is genuinely intended, run it yourself outside Claude Code."}}\n' "$1"
  exit 0
}

# --- Filesystem destruction ------------------------------------------------

# Recursive delete aimed at the filesystem root or the home directory.
# Trailing (space|end) keeps `rm -rf /tmp/build` and `rm -rf ~/proj` allowed.
if matches "${CMD_START}rm[[:space:]]+(-[^[:space:]]+[[:space:]]+)*(/|~|/\*|~/\*)([[:space:]]|$)"; then
  deny "recursive delete targeting the filesystem root or home directory"
fi

# --no-preserve-root exists for exactly one purpose. No anchor needed: the flag
# is distinctive enough that a substring match cannot be a false positive.
if matches '--no-preserve-root'; then
  deny "rm --no-preserve-root"
fi

# Formatting a filesystem.
if matches "${CMD_START}mkfs(\.[[:alnum:]]+)?[[:space:]]"; then
  deny "mkfs would format a filesystem"
fi

# dd writing to a raw device. `dd if=...` alone is a harmless read and is no
# longer blocked - only the destination matters.
if matches "${CMD_START}dd[[:space:]][^;&|]*of=/dev/"; then
  deny "dd writing directly to a device node"
fi

# Any redirect into a raw disk device.
if matches ">[[:space:]]*/dev/(sd|hd|nvme|disk|rdisk)"; then
  deny "redirect into a raw disk device"
fi

# Recursive world-writable permissions on the filesystem root.
if matches "${CMD_START}chmod[[:space:]]+-[^[:space:]]*R[^[:space:]]*[[:space:]]+0?777[[:space:]]+/"; then
  deny "recursive chmod 777 on the filesystem root"
fi

# --- Process / shell abuse -------------------------------------------------

# Classic fork bomb  :(){ :|:& };:
if matches ":\(\)[[:space:]]*\{[[:space:]]*:\|:&[[:space:]]*\}[[:space:]]*;[[:space:]]*:"; then
  deny "fork bomb"
fi

# Downloading a script and piping it straight into a shell. The remote content
# is unreviewable at approval time, which is what makes this different from a
# plain curl.
if matches "${CMD_START}(curl|wget)[[:space:]][^;&]*\|[[:space:]]*(sudo[[:space:]]+)?(ba|z|k|da)?sh([[:space:]]|$)"; then
  deny "piping downloaded content directly into a shell"
fi

# --- Git history destruction ----------------------------------------------

# Force-push to a shared default branch. --force-with-lease is intentionally
# NOT matched: it is the safe form and blocking it would push people toward the
# unsafe one.
if matches "${CMD_START}git[[:space:]]+push[[:space:]][^;&|]*(--force|-f)[[:space:]][^;&|]*(main|master)([[:space:]]|$)"; then
  deny "force push to main/master"
fi
if matches "${CMD_START}git[[:space:]]+push[[:space:]][^;&|]*[[:space:]](main|master)[[:space:]][^;&|]*(--force|-f)([[:space:]]|$)"; then
  deny "force push to main/master"
fi

# Rewrites every commit in the repository.
if matches "${CMD_START}git[[:space:]]+filter-branch([[:space:]]|$)"; then
  deny "git filter-branch rewrites the entire repository history"
fi

# --- SQL -------------------------------------------------------------------
# Case-insensitive here, and no command-position anchor, because these arrive
# inside a quoted argument to psql/mysql rather than at the start of a command.
# DROP TABLE is deliberately absent: it is routine in migrations and blocking it
# would train people to disable this hook.

if matches_sql "DROP[[:space:]]+(DATABASE|SCHEMA)[[:space:]]"; then
  deny "DROP DATABASE/SCHEMA"
fi

if matches_sql "TRUNCATE[[:space:]]+TABLE[[:space:]]"; then
  deny "TRUNCATE TABLE"
fi

# Nothing matched: no decision, the normal permission flow applies.
exit 0
