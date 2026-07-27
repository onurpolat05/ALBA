#!/bin/bash

# ALBA - Session Start Hook
# Event: SessionStart
# Purpose: Load context and show the daily dashboard when a session begins.
#
# Shows: date, priority items, active task count, resume info.
# Handles missing files gracefully - safe on first run, before memory/ exists.
#
# Paths resolve against ${CLAUDE_PROJECT_DIR} (the project root), not the
# current directory: a session started from a subdirectory would otherwise find
# none of these files. The `.` fallback keeps the old behaviour when the
# variable is unset.

trap 'exit 0' ERR

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

echo "=== ALBA Session ==="
echo "Date: $(date '+%Y-%m-%d %H:%M')"
echo ""

# Show priority items from dashboard
DASHBOARD="${PROJECT_DIR}/memory/state/dashboard.md"
if [ -f "$DASHBOARD" ]; then
  PRIORITIES=$(grep -iE "(HIGH|URGENT|priority|CRITICAL)" "$DASHBOARD" 2>/dev/null | head -5)
  if [ -n "$PRIORITIES" ]; then
    echo "--- Priorities ---"
    echo "$PRIORITIES"
    echo ""
  fi
fi

# Show active task count and top items
TODO="${PROJECT_DIR}/memory/state/todo.md"
if [ -f "$TODO" ]; then
  TASKS=$(grep -c "^- \[ \]" "$TODO" 2>/dev/null || echo "0")
  echo "Active tasks: $TASKS"
  if [ "$TASKS" -gt 0 ] 2>/dev/null; then
    grep "^- \[ \]" "$TODO" 2>/dev/null | head -5
  fi
  echo ""
fi

# Show resume hint if continuing today's session
TODAY=$(date '+%Y-%m-%d')
if [ -f "${PROJECT_DIR}/memory/daily/${TODAY}.md" ]; then
  echo "Resuming today's session (log exists)."
  echo ""
fi

echo "=== Ready ==="
exit 0
