#!/bin/bash

# ALBA - Bash Validator Hook
# Event: PreToolUse
# Matcher: Bash
# Purpose: Deny a small set of genuinely catastrophic bash commands.
#
# Two-layer model:
#   Layer 1 (CC native): permissions.deny / permissions.ask in settings.json,
#                        plus Claude Code's own command parsing (it already
#                        refuses to let a prefix rule approve wrapped commands
#                        or find -exec/-delete). ALBA's shipped rules are listed
#                        in templates/settings.json.template - nothing more.
#   Layer 2 (this hook): pattern checks for a short list of catastrophic
#                        commands (root/home wipes, disk writes, fork bombs,
#                        pipe-to-shell, force-push of main, SQL drops).
#
# WHAT THIS IS NOT: a security boundary. It is a speed bump against accidents.
# A blocklist cannot enumerate every spelling - `bash -c "..."`, `eval`,
# `base64 -d | sh`, `python3 -c`, `find / -delete` all pass through it to the
# normal permission prompt. For a real boundary use Claude Code's sandbox.
#
# Register it with "onFailure": "block" (added in Claude Code v2.1.295): a validator
# that times out or cannot start then blocks the command instead of letting it
# through.
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
fail_ask() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"ALBA bash-validator could not check this command (%s). Review it manually before approving."}}\n' "$1"
  exit 0
}
trap 'fail_ask "validator error"' ERR

INPUT=$(cat 2>/dev/null) || true

# Extract the command. jq is strongly preferred. The grep fallback cannot decode
# JSON escapes: it stops at the first \" and sees a multi-line command as one
# line, so when the command itself contains an escape it would check a
# truncated command. In that case ask instead of pretending to have checked.
# Only the command value is tested - other fields (a Windows cwd is full of
# backslashes) must not turn every command into a prompt. Install jq.
COMMAND=""
if command -v jq >/dev/null 2>&1; then
  COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null) || true
else
  if printf '%s' "$INPUT" | grep -qE '"command"[[:space:]]*:[[:space:]]*"[^"]*\\'; then
    fail_ask "jq is not installed and the command contains escapes"
  fi
  COMMAND=$(printf '%s' "$INPUT" | tr '\n' ' ' \
    | grep -oE '"command"[[:space:]]*:[[:space:]]*"[^"]*"' \
    | head -1 \
    | sed 's/^"command"[[:space:]]*:[[:space:]]*"//;s/"$//') || true
fi

# No command in the payload: no decision, normal permission flow applies.
if [ -z "$COMMAND" ]; then
  exit 0
fi

# A command position: start of a line (grep is line-based, so this also covers
# each line of a multi-line command, indented or not), or right after a
# separator / subshell opener / backtick. Without this anchor every pattern
# below degrades into a substring search over arbitrary text (commit messages,
# grep needles, file names).
#
# Leading VAR=value assignments and known wrapper commands are absorbed too,
# otherwise `sudo rm -rf ~` or `env FOO=1 rm -rf /` would shift the real command
# out of command position and slip past every pattern. Only these specific
# wrapper names are absorbed - a generic "skip a few tokens" rule would let
# `git commit -m "rm -rf /"` match again.
ASSIGN='([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)*'
WRAP_ONE="(sudo|doas|env|command|time|nice|ionice|nohup|setsid|xargs|watch)[[:space:]]+${ASSIGN}((-[^[:space:]]+[[:space:]]+)([^-][^[:space:]]*[[:space:]]+)?)*"
CMD_START="(^[[:space:]]*|[[:space:]]*[;&|(\`]+[[:space:]]*)${ASSIGN}(${WRAP_ONE})*"

# End of an argument: whitespace, a separator, a subshell/backtick closer, or
# end of line. A bare ([[:space:]]|$) let `rm -rf ~;ls` and `(rm -rf ~)` through.
END='([[:space:]]|[;&|)`]|$)'

# `--` terminates grep's option parsing: a pattern starting with `-` (e.g.
# --no-preserve-root) would otherwise be read as a flag. grep exits 2 on a
# broken pattern; that must not read as "no match", or a typo in this file
# silently disables a rule.
matches() {
  printf '%s' "$COMMAND" | grep -qE -- "$1" 2>/dev/null
  rc=$?
  [ "$rc" -eq 2 ] && fail_ask "pattern error"
  return "$rc"
}

# Case-insensitive variant, for SQL only.
matches_sql() {
  printf '%s' "$COMMAND" | grep -qiE -- "$1" 2>/dev/null
  rc=$?
  [ "$rc" -eq 2 ] && fail_ask "pattern error"
  return "$rc"
}

# Reasons are static ASCII strings without quotes or backslashes, so they need
# no JSON escaping. Keep it that way - never interpolate $COMMAND in here.
deny() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Blocked by ALBA bash-validator: %s. If this is genuinely intended, run it yourself outside Claude Code."}}\n' "$1"
  exit 0
}

# --- Filesystem destruction ------------------------------------------------

# Recursive delete aimed at the filesystem root or the home directory, as any
# argument (`rm -rf build ~` too). The target must END there ($END), which
# keeps `rm -rf /tmp/build` and `rm -rf ~/proj` allowed. Spellings covered:
# / // /. /* ~ ~/ ~/. ~/* "/" '/' and $HOME / ${HOME} / "$HOME" with an
# optional trailing / or /*, inside or outside the quotes.
# The command word may be escaped or absolute: \rm, /bin/rm, /usr/bin/rm.
RM_WORD='(\\|/bin/|/usr/bin/)?rm'
RM_TARGET='(/|//|/\.|/\*|~|~/|~/\.|~/\*|"/"|'"'"'/'"'"'|"?\$\{?HOME\}?"?(/|/\*)?"?)'
if matches "${CMD_START}${RM_WORD}[[:space:]]+([^;&|]*[[:space:]])?${RM_TARGET}${END}"; then
  deny "recursive delete targeting the filesystem root or home directory"
fi

# --no-preserve-root exists for exactly one purpose - on an rm command line.
# Anchored to rm so a commit message that mentions the flag is not denied.
if matches "${CMD_START}${RM_WORD}[[:space:]][^;&|]*--no-preserve-root"; then
  deny "rm --no-preserve-root"
fi

# Formatting a filesystem.
if matches "${CMD_START}mkfs(\.[[:alnum:]]+)?[[:space:]]"; then
  deny "mkfs would format a filesystem"
fi

# dd writing to a disk device. `dd if=...` alone is a harmless read, and so is
# writing to /dev/null, /dev/stdout or a tty - only a disk destination matters.
DISK='/dev/(sd|hd|nvme|disk|rdisk|mmcblk|vd|xvd)'
if matches "${CMD_START}dd[[:space:]][^;&|]*of=${DISK}"; then
  deny "dd writing directly to a disk device"
fi

# Any redirect into a raw disk device.
if matches ">[[:space:]]*${DISK}"; then
  deny "redirect into a raw disk device"
fi

# Recursive world-writable permissions on the filesystem root, with the flags
# in any order (`chmod -R 777 /`, `chmod 777 -R /`, `chmod --recursive a=rwx /`).
# Checked one command segment at a time, so `chmod -R 755 x; chmod 777 y`
# cannot assemble a match out of two different commands. A heredoc, not a pipe,
# feeds the loop: deny() must exit this shell, not a subshell.
SEGMENTS=$(printf '%s' "$COMMAND" | tr ';&|' '\n\n\n')
while IFS= read -r seg; do
  case "$seg" in *chmod*) ;; *) continue ;; esac
  printf '%s' "$seg" | grep -qE "^[[:space:]]*(\(|\`)?${ASSIGN}(${WRAP_ONE})*chmod[[:space:]]" || continue
  printf '%s' "$seg" | grep -qE "[[:space:]](-[^[:space:]-]*R[^[:space:]]*|--recursive)([[:space:]]|$)" || continue
  printf '%s' "$seg" | grep -qE "[[:space:]](0?777|[ugoa]*[+=]rwx)([[:space:]]|$)" || continue
  printf '%s' "$seg" | grep -qE "[[:space:]]/([[:space:]]|[)\`]|$)" || continue
  deny "recursive chmod 777 on the filesystem root"
done <<EOF
$SEGMENTS
EOF

# --- Process / shell abuse -------------------------------------------------

# Fork bomb  :(){ :|:& };:  with any spacing.
S='[[:space:]]*'
if matches ":\(\)${S}\{${S}:${S}\|${S}:${S}&${S}\}${S};${S}:"; then
  deny "fork bomb"
fi

# Downloading a script and running it unread: piped into a shell (optionally
# via sudo with flags, env, or an absolute path), or through process
# substitution. The remote content is unreviewable at approval time, which is
# what makes this different from a plain curl.
SHELL_WORD='(/usr)?(/bin/)?(ba|z|k|da)?sh'
# A single & is allowed before the pipe (`2>&1`, `?a=1&b=2` in a URL); && and ;
# end the curl command, so a pipe after them is not fed by the download.
if matches "${CMD_START}(curl|wget)[[:space:]]([^;&]|&[^&])*\|[[:space:]]*(sudo([[:space:]]+-[^[:space:]]+)*[[:space:]]+)?(env[[:space:]]+)?${SHELL_WORD}${END}"; then
  deny "piping downloaded content directly into a shell"
fi
if matches "${CMD_START}${SHELL_WORD}[[:space:]]+<\([[:space:]]*(curl|wget)[[:space:]]"; then
  deny "running downloaded content through process substitution"
fi

# --- Git history destruction ----------------------------------------------

# Force-push to a shared default branch. --force-with-lease is intentionally
# NOT matched: it is the safe form and blocking it would push people toward the
# unsafe one. The branch must be a whole refspec side (after a space or the
# `:` of `src:dst`), so `feat/custom-domain` is not read as `main`.
BRANCH='[[:space:]:](refs/heads/)?(main|master)'
if matches "${CMD_START}git[[:space:]]+push[[:space:]]([^;&|]*[[:space:]])?(--force|-f)([[:space:]][^;&|]*)?${BRANCH}${END}"; then
  deny "force push to main/master"
fi
if matches "${CMD_START}git[[:space:]]+push[[:space:]][^;&|]*${BRANCH}[[:space:]]([^;&|]*[[:space:]])?(--force|-f)${END}"; then
  deny "force push to main/master"
fi
# A leading + on a refspec is a force push without the flag.
if matches "${CMD_START}git[[:space:]]+push[[:space:]][^;&|]*[[:space:]]\+(refs/heads/)?(main|master)${END}"; then
  deny "force push to main/master"
fi
# A bare `git push --force` with no branch is not denied here: the target is
# whatever the current branch tracks, which this hook cannot see. The shipped
# settings already route every `git push` through permissions.ask.

# Rewrites every commit in the repository.
if matches "${CMD_START}git[[:space:]]+filter-branch([[:space:]]|$)"; then
  deny "git filter-branch rewrites the entire repository history"
fi

# --- SQL -------------------------------------------------------------------
# Only when a SQL client is part of the command: without that condition these
# keywords match commit messages and grep needles ("drop schema validation",
# "truncate long titles"). Client and statement are matched separately, not on
# one line, so SQL fed through a heredoc on the next line is still caught.
# Case-insensitive, because SQL keywords are. DROP TABLE is deliberately
# absent: it is routine in migrations and blocking it would train people to
# disable this hook.
SQL_CLIENT='(^|[^[:alnum:]_-])(psql|mysql|mariadb|sqlite3|sqlcmd|duckdb|clickhouse-client|cockroach[[:space:]]+sql)([[:space:]]|$)'
if matches_sql "$SQL_CLIENT"; then
  if matches_sql "DROP[[:space:]]+(DATABASE|SCHEMA)[[:space:]]"; then
    deny "DROP DATABASE/SCHEMA"
  fi
  # TABLE is optional in SQL (`TRUNCATE users`).
  if matches_sql "TRUNCATE[[:space:]]+(TABLE[[:space:]]+)?(ONLY[[:space:]]+)?[\"A-Za-z_]"; then
    deny "TRUNCATE TABLE"
  fi
fi

# Nothing matched: no decision, the normal permission flow applies.
exit 0
