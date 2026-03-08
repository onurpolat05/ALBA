#!/bin/bash

# ALBA - Pre-Compact Hook
# Event: PreCompact
# Purpose: Output critical context before Claude compacts the conversation
#
# When Claude's context window fills up, it compacts older messages.
# This hook outputs key state so it survives in the compacted summary.
# Keeps output under 20 lines. Cross-platform (macOS + Linux). Never exits 1.

echo "=== CRITICAL CONTEXT (preserve across compaction) ==="
echo ""

# Current date for reference
echo "Date: $(date '+%Y-%m-%d %H:%M')"

# Priority items from dashboard
if [ -f "memory/state/dashboard.md" ]; then
  PRIORITIES=$(grep -iE "(HIGH|URGENT|priority|CRITICAL|FOCUS)" "memory/state/dashboard.md" 2>/dev/null | head -5)
  if [ -n "$PRIORITIES" ]; then
    echo ""
    echo "--- Priorities ---"
    echo "$PRIORITIES"
  fi
fi

# Active tasks (compact: just count + top 3)
if [ -f "memory/state/todo.md" ]; then
  TASK_COUNT=$(grep -c "^- \[ \]" "memory/state/todo.md" 2>/dev/null || echo "0")
  if [ "$TASK_COUNT" -gt 0 ]; then
    echo ""
    echo "--- Active Tasks ($TASK_COUNT) ---"
    grep "^- \[ \]" "memory/state/todo.md" 2>/dev/null | head -3
  fi
fi

# Session progress from today's log (last entry)
TODAY=$(date '+%Y-%m-%d')
if [ -f "memory/daily/${TODAY}.md" ]; then
  echo ""
  echo "--- Today's Session Active ---"
fi

# Unresolved errors count
if [ -f "memory/knowledge/errors_raw.log" ]; then
  ERR_COUNT=$(wc -l < "memory/knowledge/errors_raw.log" 2>/dev/null | tr -d ' ')
  if [ "$ERR_COUNT" -gt 3 ]; then
    echo "Recent errors logged: $ERR_COUNT entries"
  fi
fi

echo ""
echo "=== END CRITICAL CONTEXT ==="
exit 0
