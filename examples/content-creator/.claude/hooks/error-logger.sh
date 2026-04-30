#!/bin/bash

# ALBA - Error Logger Hook
# Events: PostToolUse(Bash) + PostToolUseFailure (any tool)
# Purpose: Log error patterns and slow tool calls for pattern learning
#
# Captures: timestamp | tool | command (Bash) or error | exit_code | duration_ms
# Writes to: memory/knowledge/errors_raw.log
# CRITICAL: Never fails, never blocks. Always exits 0.
# Cross-platform (macOS + Linux). Uses jq if available, falls back to grep.
#
# duration_ms field is available since CC v2.1.119 (PostToolUse + PostToolUseFailure).

# Absolutely never fail
trap 'exit 0' ERR EXIT

INPUT=$(cat 2>/dev/null) || true

# Extract fields - jq first, grep fallback
TOOL_NAME=""
EXIT_CODE=""
ERROR_MSG=""
DURATION_MS=""
COMMAND=""

if command -v jq >/dev/null 2>&1; then
  TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"' 2>/dev/null) || true
  EXIT_CODE=$(echo "$INPUT" | jq -r '.tool_result.exit_code // .tool_output.exit_code // .tool_response.exit_code // empty' 2>/dev/null) || true
  ERROR_MSG=$(echo "$INPUT" | jq -r '.tool_response.error // .error // .tool_result.stderr // .tool_output.stderr // empty' 2>/dev/null | head -1) || true
  DURATION_MS=$(echo "$INPUT" | jq -r '.duration_ms // empty' 2>/dev/null) || true
  COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null) || true
fi

# Grep fallbacks if jq missing or fields empty
if [ -z "$TOOL_NAME" ] || [ "$TOOL_NAME" = "unknown" ]; then
  TOOL_NAME_FB=$(echo "$INPUT" | tr '\n' ' ' | grep -oE '"tool_name"\s*:\s*"[^"]*"' | head -1 | sed 's/^"tool_name"\s*:\s*"//;s/"$//') || true
  [ -n "$TOOL_NAME_FB" ] && TOOL_NAME="$TOOL_NAME_FB"
fi
if [ -z "$EXIT_CODE" ]; then
  EXIT_CODE=$(echo "$INPUT" | tr '\n' ' ' | grep -oE '"exit_code"\s*:\s*[0-9]+' | head -1 | grep -oE '[0-9]+$') || true
fi
if [ -z "$ERROR_MSG" ]; then
  ERROR_MSG=$(echo "$INPUT" | tr '\n' ' ' | grep -oE '"(error|stderr)"\s*:\s*"[^"]*"' | head -1 | sed 's/^"[a-z]*"\s*:\s*"//;s/"$//') || true
fi
if [ -z "$COMMAND" ]; then
  COMMAND=$(echo "$INPUT" | tr '\n' ' ' | grep -oE '"command"\s*:\s*"[^"]*"' | head -1 | sed 's/^"command"\s*:\s*"//;s/"$//') || true
fi

# Skip silent successes: no error AND (exit_code missing or zero)
HAS_ERROR=0
[ -n "$ERROR_MSG" ] && HAS_ERROR=1
[ -n "$EXIT_CODE" ] && [ "$EXIT_CODE" != "0" ] && HAS_ERROR=1
if [ "$HAS_ERROR" = "0" ]; then
  exit 0
fi

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S' 2>/dev/null) || TIMESTAMP="unknown"
ERRORS_FILE="memory/knowledge/errors_raw.log"

mkdir -p "$(dirname "$ERRORS_FILE")" 2>/dev/null || true

if [ ! -f "$ERRORS_FILE" ]; then
  echo "# ALBA Error Log (auto-captured)" > "$ERRORS_FILE" 2>/dev/null || true
  echo "# Format: timestamp | tool | detail | exit_code | duration_ms" >> "$ERRORS_FILE" 2>/dev/null || true
  echo "" >> "$ERRORS_FILE" 2>/dev/null || true
fi

# Build detail field: command for Bash, error message for everything else
DETAIL=""
if [ -n "$COMMAND" ]; then
  DETAIL=$(echo "$COMMAND" | head -1 | cut -c1-200) || true
elif [ -n "$ERROR_MSG" ]; then
  DETAIL=$(echo "$ERROR_MSG" | tr -d '\n' | cut -c1-200) || true
fi

EXIT_FIELD="${EXIT_CODE:-n/a}"
DURATION_FIELD="${DURATION_MS:-n/a}"
TOOL_FIELD="${TOOL_NAME:-unknown}"

echo "${TIMESTAMP} | ${TOOL_FIELD} | ${DETAIL} | exit:${EXIT_FIELD} | duration_ms:${DURATION_FIELD}" >> "$ERRORS_FILE" 2>/dev/null || true

exit 0
