#!/bin/bash

# ALBA - Memory Check Hook
# Event: Stop
# Purpose: Remind to save session state if session was long enough
#
# Only reminds if session lasted > 30 minutes (avoids being annoying).
# Checks if dashboard was updated today.
# Cross-platform (macOS + Linux). Never exits 1.

TODAY=$(date '+%Y-%m-%d')

# Determine session duration from today's daily log
SESSION_LONG=false
if [ -f "memory/daily/${TODAY}.md" ]; then
  # Check file modification time vs creation to estimate session length
  # Portable approach: check if the file was modified more than 30 min ago
  if command -v stat >/dev/null 2>&1; then
    if [ "$(uname)" = "Darwin" ]; then
      FILE_MOD=$(stat -f %m "memory/daily/${TODAY}.md" 2>/dev/null || echo "0")
    else
      FILE_MOD=$(stat -c %Y "memory/daily/${TODAY}.md" 2>/dev/null || echo "0")
    fi
    NOW=$(date +%s)
    DIFF=$(( NOW - FILE_MOD ))
    # If file was modified recently but created > 30 min ago, session is long
    # Alternative: if daily log exists and has content, check its first timestamp
    if [ "$DIFF" -lt 1800 ] 2>/dev/null; then
      # File was modified recently - check if it's been around > 30 min
      if [ "$(uname)" = "Darwin" ]; then
        FILE_BIRTH=$(stat -f %B "memory/daily/${TODAY}.md" 2>/dev/null || echo "$FILE_MOD")
      else
        FILE_BIRTH=$(stat -c %W "memory/daily/${TODAY}.md" 2>/dev/null || echo "$FILE_MOD")
      fi
      BIRTH_DIFF=$(( NOW - FILE_BIRTH ))
      if [ "$BIRTH_DIFF" -gt 1800 ] 2>/dev/null; then
        SESSION_LONG=true
      fi
    fi
  fi
fi

# Only show reminders if session was meaningful
echo ""
echo "=== Session Ending ==="

# Remind to use /end for long sessions
if [ "$SESSION_LONG" = true ]; then
  echo ""
  echo "Long session detected (>30 min)."
  echo "Tip: Run /end to save session state, learnings, and update dashboard."
fi

# Check if dashboard was updated today
DASHBOARD_STALE=false
if [ -f "memory/state/dashboard.md" ]; then
  if command -v stat >/dev/null 2>&1; then
    if [ "$(uname)" = "Darwin" ]; then
      DASH_MOD=$(stat -f %m "memory/state/dashboard.md" 2>/dev/null || echo "0")
    else
      DASH_MOD=$(stat -c %Y "memory/state/dashboard.md" 2>/dev/null || echo "0")
    fi
    # Check if dashboard was modified today
    if [ "$(uname)" = "Darwin" ]; then
      DASH_DATE=$(date -r "$DASH_MOD" '+%Y-%m-%d' 2>/dev/null || echo "")
    else
      DASH_DATE=$(date -d "@$DASH_MOD" '+%Y-%m-%d' 2>/dev/null || echo "")
    fi
    if [ "$DASH_DATE" != "$TODAY" ]; then
      DASHBOARD_STALE=true
    fi
  fi
elif [ -d "memory/state" ]; then
  # Dashboard doesn't exist yet
  DASHBOARD_STALE=true
fi

if [ "$DASHBOARD_STALE" = true ]; then
  echo ""
  echo "Dashboard not updated today. Consider refreshing it."
fi

# Check if daily log exists
if [ ! -f "memory/daily/${TODAY}.md" ]; then
  echo ""
  echo "No daily log for today. Use /end to create one."
fi

echo ""
exit 0
