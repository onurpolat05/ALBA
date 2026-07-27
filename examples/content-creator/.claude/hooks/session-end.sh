#!/bin/bash

# ALBA - Session End Hook
# Event: SessionEnd
# Purpose: Leave a factual trace that a session happened, even when /end is
#          never run.
#
# WHY THIS EXISTS: ALBA's memory layer depends on the /end skill being invoked,
# and the one thing users reliably forget is the closing ritual. A session that
# ends without /end leaves no record at all - the next session starts blind, and
# /end has nothing to reconstruct from. This hook appends a single dated line to
# today's daily log so the gap is at least visible.
#
# It records only that a session ran and when. It does not summarize, does not
# guess what happened, and does not touch memory/state/ - writing content that
# looks curated but was produced by a shell script is exactly how a memory
# system starts lying.
#
# Field note: only `session_id` is read from the payload, which is part of the
# common hook input. No other SessionEnd-specific fields are assumed.
#
# CRITICAL: never fails, never blocks. Always exits 0.
# Cross-platform (macOS bash 3.2 + Linux + Git Bash).

trap 'exit 0' ERR EXIT

INPUT=$(cat 2>/dev/null) || true

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
DAILY_DIR="${PROJECT_DIR}/memory/daily"

# Only act inside an initialized ALBA memory layout.
[ -d "$DAILY_DIR" ] || exit 0

TODAY=$(date '+%Y-%m-%d' 2>/dev/null) || exit 0
NOW=$(date '+%H:%M' 2>/dev/null) || NOW="??:??"
DAILY_LOG="${DAILY_DIR}/${TODAY}.md"

SESSION_ID=""
if command -v jq >/dev/null 2>&1; then
  SESSION_ID=$(printf '%s' "$INPUT" | jq -r '.session_id // empty' 2>/dev/null) || true
fi
if [ -z "$SESSION_ID" ]; then
  SESSION_ID=$(printf '%s' "$INPUT" | tr '\n' ' ' \
    | grep -oE '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' \
    | head -1 \
    | sed 's/^"session_id"[[:space:]]*:[[:space:]]*"//;s/"$//') || true
fi
SHORT_ID=$(printf '%s' "${SESSION_ID:-unknown}" | cut -c1-8) || SHORT_ID="unknown"

if [ ! -f "$DAILY_LOG" ]; then
  {
    echo "# ${TODAY}"
    echo ""
    echo "## Sessions"
  } > "$DAILY_LOG" 2>/dev/null || exit 0
fi

# Ensure the section exists in a log created by /end from the template.
if ! grep -q '^## Sessions' "$DAILY_LOG" 2>/dev/null; then
  {
    echo ""
    echo "## Sessions"
  } >> "$DAILY_LOG" 2>/dev/null || true
fi

# Neutral wording on purpose: the hook cannot know whether /end was run, so it
# states only what it observed.
echo "- ${NOW} session ended (${SHORT_ID})" >> "$DAILY_LOG" 2>/dev/null || true

exit 0
