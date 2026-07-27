#!/bin/bash

# ALBA - Error Logger Hook
# Events: PostToolUse (matcher: Bash) + PostToolUseFailure (any tool)
# Purpose: Log error patterns and slow tool calls so /reflect has raw material.
#
# Captures: timestamp | tool | command (Bash) or error | exit_code | duration_ms
#
# Writes to: .claude/logs/errors_raw.log
#   NOTE FOR SETUP: add `.claude/logs/` to your .gitignore. This is machine-local
#   runtime noise - it should not be committed, and it must not sit inside
#   memory/, which is curated knowledge Claude reads. ALBA <= v1.1.0 wrote it to
#   memory/knowledge/errors_raw.log, where it grew without bound in the middle
#   of the knowledge base.
#
# Rotation: the file is trimmed to the last $MAX_LINES entries. A log that grows
# forever is a log nobody reads and a repo nobody clones.
#
# CRITICAL: never fails, never blocks. Always exits 0.
# Cross-platform (macOS bash 3.2 + Linux + Git Bash). Uses jq if available.

# Absolutely never fail
trap 'exit 0' ERR EXIT

MAX_LINES=500

INPUT=$(cat 2>/dev/null) || true

# ${CLAUDE_PROJECT_DIR} is the project root regardless of which subdirectory the
# session was started from. Falling back to "." preserves the old behaviour on
# older versions / unusual launch paths.
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

# Extract fields - jq first, grep fallback
TOOL_NAME=""
EXIT_CODE=""
ERROR_MSG=""
DURATION_MS=""
COMMAND=""

if command -v jq >/dev/null 2>&1; then
  TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // "unknown"' 2>/dev/null) || true
  EXIT_CODE=$(printf '%s' "$INPUT" | jq -r '.tool_result.exit_code // .tool_output.exit_code // .tool_response.exit_code // empty' 2>/dev/null) || true
  ERROR_MSG=$(printf '%s' "$INPUT" | jq -r '.tool_response.error // .error // .tool_result.stderr // .tool_output.stderr // empty' 2>/dev/null | head -1) || true
  DURATION_MS=$(printf '%s' "$INPUT" | jq -r '.duration_ms // empty' 2>/dev/null) || true
  COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null) || true
fi

# Grep fallbacks if jq missing or fields empty
if [ -z "$TOOL_NAME" ] || [ "$TOOL_NAME" = "unknown" ]; then
  TOOL_NAME_FB=$(printf '%s' "$INPUT" | tr '\n' ' ' | grep -oE '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/^"tool_name"[[:space:]]*:[[:space:]]*"//;s/"$//') || true
  [ -n "$TOOL_NAME_FB" ] && TOOL_NAME="$TOOL_NAME_FB"
fi
if [ -z "$EXIT_CODE" ]; then
  EXIT_CODE=$(printf '%s' "$INPUT" | tr '\n' ' ' | grep -oE '"exit_code"[[:space:]]*:[[:space:]]*[0-9]+' | head -1 | grep -oE '[0-9]+$') || true
fi
if [ -z "$ERROR_MSG" ]; then
  ERROR_MSG=$(printf '%s' "$INPUT" | tr '\n' ' ' | grep -oE '"(error|stderr)"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/^"[a-z]*"[[:space:]]*:[[:space:]]*"//;s/"$//') || true
fi
if [ -z "$COMMAND" ]; then
  COMMAND=$(printf '%s' "$INPUT" | tr '\n' ' ' | grep -oE '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/^"command"[[:space:]]*:[[:space:]]*"//;s/"$//') || true
fi

# Skip silent successes: no error AND (exit_code missing or zero)
HAS_ERROR=0
[ -n "$ERROR_MSG" ] && HAS_ERROR=1
[ -n "$EXIT_CODE" ] && [ "$EXIT_CODE" != "0" ] && HAS_ERROR=1
if [ "$HAS_ERROR" = "0" ]; then
  exit 0
fi

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S' 2>/dev/null) || TIMESTAMP="unknown"
LOG_DIR="${PROJECT_DIR}/.claude/logs"
ERRORS_FILE="${LOG_DIR}/errors_raw.log"
HEADER_1="# ALBA Error Log (auto-captured, rotated at ${MAX_LINES} lines)"
HEADER_2="# Format: timestamp | tool | detail | exit_code | duration_ms"

mkdir -p "$LOG_DIR" 2>/dev/null || true

if [ ! -f "$ERRORS_FILE" ]; then
  {
    echo "$HEADER_1"
    echo "$HEADER_2"
    echo ""
  } > "$ERRORS_FILE" 2>/dev/null || true
fi

# Build detail field: command for Bash, error message for everything else
DETAIL=""
if [ -n "$COMMAND" ]; then
  DETAIL=$(printf '%s' "$COMMAND" | head -1 | cut -c1-200) || true
elif [ -n "$ERROR_MSG" ]; then
  DETAIL=$(printf '%s' "$ERROR_MSG" | tr -d '\n' | cut -c1-200) || true
fi

EXIT_FIELD="${EXIT_CODE:-n/a}"
DURATION_FIELD="${DURATION_MS:-n/a}"
TOOL_FIELD="${TOOL_NAME:-unknown}"

echo "${TIMESTAMP} | ${TOOL_FIELD} | ${DETAIL} | exit:${EXIT_FIELD} | duration_ms:${DURATION_FIELD}" >> "$ERRORS_FILE" 2>/dev/null || true

# Rotate: keep the header plus the newest $MAX_LINES entries. Write to a temp
# file and move it into place so a crash mid-rotation cannot truncate the log.
LINE_COUNT=$(wc -l < "$ERRORS_FILE" 2>/dev/null | tr -d '[:space:]') || LINE_COUNT=0
case "$LINE_COUNT" in
  ''|*[!0-9]*) LINE_COUNT=0 ;;
esac
if [ "$LINE_COUNT" -gt "$MAX_LINES" ] 2>/dev/null; then
  TMP_FILE="${ERRORS_FILE}.tmp.$$"
  {
    echo "$HEADER_1"
    echo "$HEADER_2"
    echo ""
    grep -v '^#' "$ERRORS_FILE" 2>/dev/null | tail -n "$MAX_LINES"
  } > "$TMP_FILE" 2>/dev/null && mv "$TMP_FILE" "$ERRORS_FILE" 2>/dev/null
  rm -f "$TMP_FILE" 2>/dev/null || true
fi

exit 0
