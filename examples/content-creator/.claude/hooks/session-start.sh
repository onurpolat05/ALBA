#!/bin/bash

# ALBA - Session Start Hook
# Event: SessionStart
# Purpose: Load context and show daily dashboard on session begin
#
# Shows: date, priority items, active task count, resume info
# Handles missing files gracefully - safe for first run

echo "=== ALBA Session ==="
echo "Date: $(date '+%Y-%m-%d %H:%M')"
echo ""

# Show priority items from dashboard
if [ -f "memory/state/dashboard.md" ]; then
  PRIORITIES=$(grep -iE "(HIGH|URGENT|priority|CRITICAL)" "memory/state/dashboard.md" 2>/dev/null | head -5)
  if [ -n "$PRIORITIES" ]; then
    echo "--- Priorities ---"
    echo "$PRIORITIES"
    echo ""
  fi
fi

# Show active task count and top items
if [ -f "memory/state/todo.md" ]; then
  TASKS=$(grep -c "^- \[ \]" "memory/state/todo.md" 2>/dev/null || echo "0")
  echo "Active tasks: $TASKS"
  if [ "$TASKS" -gt 0 ]; then
    grep "^- \[ \]" "memory/state/todo.md" 2>/dev/null | head -5
  fi
  echo ""
fi

# Show resume hint if continuing today's session
TODAY=$(date '+%Y-%m-%d')
if [ -f "memory/daily/${TODAY}.md" ]; then
  echo "Resuming today's session (log exists)."
  echo ""
fi

echo "=== Ready ==="
