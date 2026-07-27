#!/bin/bash
#
# ALBA - Regenerate the shared parts of examples/ from templates/
#
# WHY THIS EXISTS
# ---------------
# Every example role ships a working .claude/ tree so you can read a real setup
# instead of assembling one in your head. That is worth keeping - but it means
# each hook script, doc and settings file lived in six places at once, and a fix
# applied to one copy silently skipped the other five. That is not hypothetical:
# before v2.0.0 the example docs had drifted a full release behind their
# templates, and the example security rules were missing two sections the
# template had gained.
#
# So: templates/ is the only file you edit. This script projects it into the
# examples. Anything role-specific (CLAUDE.md, README.md, memory/) is never
# touched - that is the part an example is actually for.
#
# Usage:
#   tools/sync-examples.sh          apply
#   tools/sync-examples.sh --check  report drift, change nothing, exit 1 if any
#
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT" || exit 1

CHECK_ONLY=0
[ "${1:-}" = "--check" ] && CHECK_ONLY=1

DRIFT=0
COPIED=0

# Roles are discovered, not hardcoded: adding examples/<new-role>/ is enough.
ROLES=$(find examples -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | sort)

if [ -z "$ROLES" ]; then
  echo "No example roles found under examples/ - nothing to do."
  exit 0
fi

# Docs that /setup installs into .claude/docs/. CLAUDE.md.template is
# deliberately absent: it becomes the project's own CLAUDE.md, which each role
# writes differently.
DOC_TEMPLATES="decision-protocol memory-system quality-gates loop-integration memory-compatibility"

# sync_file <source> <destination>
sync_file() {
  src="$1"
  dst="$2"

  [ -f "$src" ] || { echo "  MISSING SOURCE: $src"; DRIFT=$((DRIFT + 1)); return; }

  if [ -f "$dst" ] && cmp -s "$src" "$dst"; then
    return
  fi

  if [ "$CHECK_ONLY" -eq 1 ]; then
    if [ -f "$dst" ]; then
      echo "  DRIFT:   $dst"
    else
      echo "  MISSING: $dst"
    fi
    DRIFT=$((DRIFT + 1))
    return
  fi

  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  COPIED=$((COPIED + 1))
}

for role in $ROLES; do
  base="examples/$role/.claude"
  echo "$role"

  # Hooks: templates/hooks/x.sh.template -> .claude/hooks/x.sh
  for tpl in templates/hooks/*.sh.template; do
    [ -e "$tpl" ] || continue
    name="$(basename "$tpl" .template)"
    sync_file "$tpl" "$base/hooks/$name"
  done

  # Docs: templates/claude/x.md.template -> .claude/docs/x.md
  for doc in $DOC_TEMPLATES; do
    sync_file "templates/claude/$doc.md.template" "$base/docs/$doc.md"
  done

  # Rules and agents ship as-is (no .template suffix).
  for rule in templates/rules/*.md; do
    [ -e "$rule" ] || continue
    sync_file "$rule" "$base/rules/$(basename "$rule")"
  done

  for agent in templates/agents/*.md; do
    [ -e "$agent" ] || continue
    sync_file "$agent" "$base/agents/$(basename "$agent")"
  done

  sync_file "templates/settings.json.template" "$base/settings.json"

  # The shipped /research skill is the canonical one. Examples used to carry a
  # stripped-down variant with different frontmatter, which is how users ended
  # up copying a skill that behaved differently from the documented one.
  sync_file ".claude/skills/research/SKILL.md" "$base/skills/research/SKILL.md"
done

# Hook scripts must stay executable after a fresh clone on POSIX systems.
if [ "$CHECK_ONLY" -eq 0 ]; then
  find examples -path '*/.claude/hooks/*.sh' -exec chmod +x {} \; 2>/dev/null
fi

echo
if [ "$CHECK_ONLY" -eq 1 ]; then
  if [ "$DRIFT" -eq 0 ]; then
    echo "examples/ is in sync with templates/"
    exit 0
  fi
  echo "$DRIFT file(s) out of sync. Run: tools/sync-examples.sh"
  exit 1
fi

echo "Synced $COPIED file(s) across $(echo "$ROLES" | wc -w | tr -d ' ') role(s)."
[ "$DRIFT" -gt 0 ] && { echo "$DRIFT source file(s) missing - see above."; exit 1; }
exit 0
