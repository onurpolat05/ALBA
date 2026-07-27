#!/bin/bash

# ALBA - Pre-Compact Hook
# Event: PreCompact
# Purpose: Output critical context before Claude compacts the conversation.
#
# When the context window fills up, older messages are summarized. This hook
# prints key state so it survives into the compacted summary. Keep the output
# short - every line here costs context in the very window you are trying to
# free. Cross-platform (macOS bash 3.2 + Linux + Git Bash). Never exits 1.
#
# Optional: PreCompact can halt the compaction entirely. It uses the top-level
# `decision` field (unlike PreToolUse, which moved to
# hookSpecificOutput.permissionDecision):
#   echo '{"decision":"block","reason":"..."}'; exit 0
# or write the reason to stderr and exit 2.
# By default this script only enriches the summary; it never blocks.

trap 'exit 0' ERR

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

echo "=== CRITICAL CONTEXT (preserve across compaction) ==="
echo ""

# Current date for reference
echo "Date: $(date '+%Y-%m-%d %H:%M')"

# Priority items from dashboard
DASHBOARD="${PROJECT_DIR}/memory/state/dashboard.md"
if [ -f "$DASHBOARD" ]; then
  PRIORITIES=$(grep -iE "(HIGH|URGENT|priority|CRITICAL|FOCUS)" "$DASHBOARD" 2>/dev/null | head -5)
  if [ -n "$PRIORITIES" ]; then
    echo ""
    echo "--- Priorities ---"
    echo "$PRIORITIES"
  fi
fi

# Active tasks (compact: just count + top 3)
TODO="${PROJECT_DIR}/memory/state/todo.md"
if [ -f "$TODO" ]; then
  TASK_COUNT=$(grep -c "^- \[ \]" "$TODO" 2>/dev/null || echo "0")
  if [ "$TASK_COUNT" -gt 0 ] 2>/dev/null; then
    echo ""
    echo "--- Active Tasks ($TASK_COUNT) ---"
    grep "^- \[ \]" "$TODO" 2>/dev/null | head -3
  fi
fi

# Session progress from today's log
TODAY=$(date '+%Y-%m-%d')
if [ -f "${PROJECT_DIR}/memory/daily/${TODAY}.md" ]; then
  echo ""
  echo "--- Today's Session Active ---"
fi

# Unresolved errors count (log lives in .claude/logs/, not in memory/)
ERRORS_FILE="${PROJECT_DIR}/.claude/logs/errors_raw.log"
if [ -f "$ERRORS_FILE" ]; then
  ERR_COUNT=$(grep -cv '^#' "$ERRORS_FILE" 2>/dev/null | tr -d '[:space:]') || ERR_COUNT=0
  case "$ERR_COUNT" in
    ''|*[!0-9]*) ERR_COUNT=0 ;;
  esac
  if [ "$ERR_COUNT" -gt 5 ] 2>/dev/null; then
    echo "Recent errors logged: $ERR_COUNT entries"
  fi
fi

echo ""
echo "=== END CRITICAL CONTEXT ==="
exit 0
