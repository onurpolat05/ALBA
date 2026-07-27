#!/bin/bash

# ALBA - Memory Check Hook
# Event: Stop
# Purpose: Occasionally remind you to persist session state.
#
# IMPORTANT - what Stop actually means: it fires every time Claude finishes a
# response, NOT once when the session ends. ALBA <= v1.1.0 printed a
# "=== Session Ending ===" banner unconditionally, so a 40-turn session printed
# it 40 times. A hook that speaks on every turn stops being read.
#
# Two changes follow from that:
#   1. A time-based guard: at most one reminder per $REMIND_INTERVAL seconds.
#      State lives in .claude/logs/ (machine-local runtime state - gitignore it).
#   2. Silence when there is nothing to say. The reminder only appears when a
#      concrete condition is true (no daily log today, or a stale dashboard).
#
# The old "session longer than 30 min" heuristic was removed: it read file birth
# time via `stat -c %W`, which returns 0 on most Linux filesystems, so the check
# was effectively always true there and unreliable on macOS.
#
# Cross-platform (macOS bash 3.2 + Linux + Git Bash). Never exits non-zero.

trap 'exit 0' ERR

REMIND_INTERVAL=21600   # 6 hours

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
LOG_DIR="${PROJECT_DIR}/.claude/logs"
GUARD_FILE="${LOG_DIR}/.memory-check-last"

TODAY=$(date '+%Y-%m-%d' 2>/dev/null) || exit 0
NOW=$(date +%s 2>/dev/null) || exit 0

# --- Spam guard ------------------------------------------------------------
LAST=0
if [ -f "$GUARD_FILE" ]; then
  LAST=$(cat "$GUARD_FILE" 2>/dev/null | tr -d '[:space:]') || LAST=0
  case "$LAST" in
    ''|*[!0-9]*) LAST=0 ;;
  esac
fi
if [ "$LAST" -gt 0 ] 2>/dev/null && [ $(( NOW - LAST )) -lt "$REMIND_INTERVAL" ] 2>/dev/null; then
  exit 0
fi

# --- Conditions worth mentioning -------------------------------------------
MESSAGES=""

DAILY_LOG="${PROJECT_DIR}/memory/daily/${TODAY}.md"
if [ -d "${PROJECT_DIR}/memory/daily" ] && [ ! -f "$DAILY_LOG" ]; then
  MESSAGES="${MESSAGES}
- No daily log for today. /end creates one and records what happened."
fi

DASHBOARD="${PROJECT_DIR}/memory/state/dashboard.md"
if [ -f "$DASHBOARD" ]; then
  DASH_MOD=0
  if [ "$(uname 2>/dev/null)" = "Darwin" ]; then
    DASH_MOD=$(stat -f %m "$DASHBOARD" 2>/dev/null) || DASH_MOD=0
    DASH_DATE=$(date -r "$DASH_MOD" '+%Y-%m-%d' 2>/dev/null) || DASH_DATE=""
  else
    DASH_MOD=$(stat -c %Y "$DASHBOARD" 2>/dev/null) || DASH_MOD=0
    DASH_DATE=$(date -d "@$DASH_MOD" '+%Y-%m-%d' 2>/dev/null) || DASH_DATE=""
  fi
  if [ -n "$DASH_DATE" ] && [ "$DASH_DATE" != "$TODAY" ]; then
    MESSAGES="${MESSAGES}
- Dashboard was last updated on ${DASH_DATE}. Consider refreshing it."
  fi
elif [ -d "${PROJECT_DIR}/memory/state" ]; then
  MESSAGES="${MESSAGES}
- No dashboard yet (memory/state/dashboard.md)."
fi

# Nothing to say: stay silent and do NOT burn the guard window.
if [ -z "$MESSAGES" ]; then
  exit 0
fi

mkdir -p "$LOG_DIR" 2>/dev/null || true
echo "$NOW" > "$GUARD_FILE" 2>/dev/null || true

echo ""
echo "--- ALBA memory check ---"
echo "$MESSAGES"
echo ""
exit 0
