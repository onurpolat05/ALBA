#!/bin/bash
#
# ALBA - Repository health check
#
# WHY THIS EXISTS
# ---------------
# ALBA has no test suite because it ships no runnable program - it ships
# configuration that another program reads. That makes its failure mode quiet:
# a hook wired to a misspelled event, a settings.json missing its inner "hooks"
# array, a doc pointing at a file nobody generates. Nothing errors. The feature
# simply never happens, and you find out weeks later, if at all.
#
# This script checks the things that fail silently. Run it before every commit
# and after every Claude Code upgrade.
#
# Usage: tools/doctor.sh
#
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT" || exit 1

FAIL=0
WARN=0

pass() { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; FAIL=$((FAIL + 1)); }
warn() { printf '  warn  %s\n' "$1"; WARN=$((WARN + 1)); }

# Valid hook events as of Claude Code v2.1.220. A settings.json referencing an
# event outside this list is not an error Claude Code reports - the hook is
# simply never called.
VALID_EVENTS="SessionStart Setup UserPromptSubmit UserPromptExpansion PreToolUse PermissionRequest PermissionDenied PostToolUse PostToolUseFailure PostToolBatch Notification MessageDisplay SubagentStart SubagentStop TaskCreated TaskCompleted Stop StopFailure TeammateIdle InstructionsLoaded ConfigChange CwdChanged FileChanged WorktreeCreate WorktreeRemove PreCompact PostCompact Elicitation ElicitationResult SessionEnd"

echo "ALBA doctor"
echo

# ---------------------------------------------------------------------------
echo "1. Shell syntax"
for f in $(find templates tools -name '*.sh' -o -name '*.sh.template' 2>/dev/null | sort); do
  if bash -n "$f" 2>/dev/null; then
    pass "$f"
  else
    fail "$f does not parse"
  fi
done
echo

# ---------------------------------------------------------------------------
echo "2. JSON validity"
for f in $(find . -name 'settings.json' -o -name 'settings.json.template' 2>/dev/null | grep -v node_modules | sort); do
  if python3 -c "import json,sys; json.load(open('$f'))" 2>/dev/null; then
    pass "$f"
  else
    fail "$f is not valid JSON"
  fi
done
echo

# ---------------------------------------------------------------------------
echo "3. Hook wiring"
for f in $(find . -name 'settings.json' -o -name 'settings.json.template' 2>/dev/null | grep -v node_modules | sort); do
  # Event names must exist.
  events=$(python3 -c "
import json
d = json.load(open('$f'))
print(' '.join(d.get('hooks', {}).keys()))
" 2>/dev/null)

  for ev in $events; do
    case " $VALID_EVENTS " in
      *" $ev "*) ;;
      *) fail "$f: unknown hook event '$ev' - it will never fire" ;;
    esac
  done

  # Every registration needs the inner "hooks" array. Without it Claude Code
  # ignores the entry; this exact mistake shipped in ALBA's own hook docs.
  bad_shape=$(python3 -c "
import json
d = json.load(open('$f'))
bad = []
for ev, entries in d.get('hooks', {}).items():
    for e in entries:
        if 'hooks' not in e or not isinstance(e['hooks'], list):
            bad.append(ev)
print(' '.join(sorted(set(bad))))
" 2>/dev/null)
  [ -n "$bad_shape" ] && fail "$f: missing inner 'hooks' array for: $bad_shape"

  # Referenced scripts must exist relative to the config's own .claude/ dir.
  missing=$(python3 -c "
import json, os, re
f = '$f'
d = json.load(open(f))
root = os.path.dirname(os.path.dirname(f)) or '.'
if f.endswith('.template'):
    raise SystemExit(0)
miss = []
for entries in d.get('hooks', {}).values():
    for e in entries:
        for h in e.get('hooks', []):
            cmd = h.get('command', '')
            m = re.search(r'\.claude/hooks/([\w.-]+)', cmd)
            if m and not os.path.isfile(os.path.join(root, '.claude', 'hooks', m.group(1))):
                miss.append(m.group(1))
print(' '.join(sorted(set(miss))))
" 2>/dev/null)
  [ -n "$missing" ] && fail "$f: wired to missing script(s): $missing"

  # Relative hook paths break the moment a session opens in a subdirectory.
  if grep -q '"command": *"bash \.claude/' "$f" 2>/dev/null; then
    fail "$f: relative hook path - use \${CLAUDE_PROJECT_DIR}"
  fi

  # File permission rules are matched on Edit(path) only; a Write(path) rule is
  # accepted, printed back as a startup warning, and then ignored. ALBA shipped
  # a dead Write(.env) deny rule from v1.1.0 until a live run surfaced it.
  if grep -qE '"Write\([^)]*\)"' "$f" 2>/dev/null; then
    fail "$f: Write(path) permission rule is ignored - use Edit(path), which covers all file-editing tools"
  fi
done
[ "$FAIL" -eq 0 ] && pass "all hook registrations well-formed"
echo

# ---------------------------------------------------------------------------
echo "4. No auto-approving PreToolUse hooks"
# A PreToolUse hook that prints permissionDecision "allow" (or the deprecated
# decision "allow"/"approve") skips the permission prompt. A validator that
# does this on its default path silently approves everything its blocklist
# misses - which is the opposite of what a validator is for.
for f in $(find templates/hooks examples -name 'bash-validator.sh*' 2>/dev/null | sort); do
  if grep -qE '"(permissionDecision|decision)": *"(allow|approve)"' "$f" 2>/dev/null; then
    fail "$f returns an allow decision - this skips the permission prompt"
  else
    pass "$(basename "$f") never auto-approves"
  fi
done
echo

# ---------------------------------------------------------------------------
echo "5. examples/ in sync with templates/"
if ./tools/sync-examples.sh --check >/dev/null 2>&1; then
  pass "no drift"
else
  fail "examples/ drifted - run tools/sync-examples.sh"
fi
echo

# ---------------------------------------------------------------------------
echo "6. Internal links resolve"
broken=0
while IFS= read -r line; do
  src="${line%%:*}"
  target="${line#*:}"
  dir="$(dirname "$src")"
  # Only check repo-relative links; user-project paths (.claude/rules/ inside a
  # generated setup) legitimately do not exist here.
  clean="${target%%#*}"
  case "$target" in
    http*|\#*|'') continue ;;
  esac
  # Skip prose placeholders: a real path has a slash or an extension.
  case "$clean" in
    *[/.]*) ;;
    *) continue ;;
  esac
  [ -z "$clean" ] && continue
  # A .md.template links to the name it will have once generated, so accept
  # either the literal target or its .template twin.
  if [ -e "$dir/$clean" ] || [ -e "$clean" ] \
     || [ -e "$dir/$clean.template" ] || [ -e "$clean.template" ]; then
    continue
  fi
  fail "$src -> $target"
  broken=$((broken + 1))
done < <(grep -rnoE '\]\([^)]+\)' --include='*.md' --include='*.md.template' . 2>/dev/null \
         | grep -v node_modules \
         | sed -E 's/^\.\/([^:]+):[0-9]+:\]\((.*)\)$/\1:\2/')
[ "$broken" -eq 0 ] && pass "no broken repo-relative links"
echo

# ---------------------------------------------------------------------------
echo "7. Stale support claims"
# Citing an old version as a fact ("added in v2.1.198") is fine and often
# necessary. What goes stale is ALBA's own claim about what it supports and
# what it was tested against - so only those are checked.
BASELINE="v2.1.218"
TESTED="v2.1.220"
stale=$(grep -rnE "(minimum|requires?|tested|supported).{0,40}v2\.1\.[0-9]+|v2\.1\.[0-9]+\+" \
        --include='*.md' --include='*.template' . 2>/dev/null \
        | grep -v node_modules | grep -v '^\./CHANGELOG.md' \
        | grep -vE "$BASELINE|$TESTED" \
        | cut -d: -f1 | sort -u)
if [ -z "$stale" ]; then
  pass "support claims match the $BASELINE baseline / $TESTED tested version"
else
  for f in $stale; do warn "$f claims support for a version other than $BASELINE/$TESTED"; done
fi
if grep -rqiE '\((latest|neueste|en yeni)[^)]*\)' --include='README*.md' . 2>/dev/null; then
  warn "a README calls a pinned version 'latest' - that expires on its own"
fi
echo

# ---------------------------------------------------------------------------
echo "8. Counts match reality"
# Prose that counts things drifts from the things it counts. This is not
# theoretical: v1.1.0 added a hook and left "6 hooks" in eight files, and the
# example role docs describe the shared config without being copies of it, so
# tools/sync-examples.sh cannot catch them.
HOOK_COUNT=$(find templates/hooks -name '*.sh.template' 2>/dev/null | wc -l | tr -d ' ')
SKILL_COUNT=$(find .claude/skills -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
ROLE_COUNT=$(find examples -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')

check_count() {
  label="$1"; actual="$2"; pattern="$3"
  wrong=$(grep -rniE "$pattern" --include='*.md' --include='*.template' . 2>/dev/null \
          | grep -v node_modules | grep -v CHANGELOG.md \
          | grep -viE "\b$actual\b" | cut -d: -f1 | sort -u)
  if [ -z "$wrong" ]; then
    pass "$label count ($actual) consistent"
  else
    for f in $wrong; do fail "$f states a $label count other than $actual"; done
  fi
}

# Plural only, so "Claude Code exposes 30 hook events" is not mistaken for a
# claim about how many hooks ALBA ships.
check_count "hook"  "$HOOK_COUNT"  "[0-9]+ (automated |standard |built-in )?hooks\b"
check_count "skill" "$SKILL_COUNT" "[0-9]+ (built-in |included )?skills\b"
check_count "role"  "$ROLE_COUNT"  "[0-9]+ (example )?roles\b"
echo

# ---------------------------------------------------------------------------
echo "9. No leaked absolute paths"
leaked=$(grep -rlE '/(Users|home)/[a-z]' --include='*.md' --include='*.sh' \
         --include='*.template' --include='*.json' . 2>/dev/null \
         | grep -v node_modules | sort)
if [ -z "$leaked" ]; then
  pass "no machine-specific paths"
else
  for f in $leaked; do fail "$f contains an absolute home path"; done
fi
echo

# ---------------------------------------------------------------------------
echo "10. Removal residue"
# Deleted rules should be deleted, not tombstoned. A file that still explains
# what used to be true is how a config starts lying.
# Lines that *prohibit* tombstones are not tombstones, and neither is this
# script's own pattern list - both are excluded so the check stays actionable.
residue=$(grep -rnE '(~~[^~]+~~|\bDEPRECATED\b|TODO remove|commented out)' \
          --include='*.md' --include='*.sh' --include='*.template' . 2>/dev/null \
          | grep -v node_modules | grep -v CHANGELOG.md \
          | grep -v 'tools/doctor.sh' \
          | grep -viE '(never|do not|don.t|avoid|instead of|rather than|no strikethrough)' \
          | cut -d: -f1 | sort -u)
if [ -z "$residue" ]; then
  pass "no strikethrough or tombstone markers"
else
  for f in $residue; do warn "$f may contain removal residue"; done
fi
echo

# ---------------------------------------------------------------------------
echo "----"
if [ "$FAIL" -eq 0 ] && [ "$WARN" -eq 0 ]; then
  echo "All checks passed."
  exit 0
fi
echo "$FAIL failure(s), $WARN warning(s)."
[ "$FAIL" -gt 0 ] && exit 1
exit 0
