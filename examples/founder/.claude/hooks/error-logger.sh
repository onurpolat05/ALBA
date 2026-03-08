#!/bin/bash

# ALBA - Error Logger Hook
# Event: PostToolUse
# Matcher: Bash
# Purpose: Log bash errors (non-zero exit codes) for pattern learning
#
# Captures: timestamp | command | exit_code | stderr (first line)
# Writes to: memory/knowledge/errors_raw.log
# CRITICAL: Never fails, never blocks. Always exits 0.
# Cross-platform (macOS + Linux).

# Absolutely never fail
trap 'exit 0' ERR EXIT

INPUT=$(cat 2>/dev/null) || true

# Extract exit code - try jq first, fallback to grep
EXIT_CODE=""
if command -v jq >/dev/null 2>&1; then
  EXIT_CODE=$(echo "$INPUT" | jq -r '.tool_result.exit_code // .tool_output.exit_code // empty' 2>/dev/null) || true
fi
if [ -z "$EXIT_CODE" ]; then
  EXIT_CODE=$(echo "$INPUT" | tr '\n' ' ' | grep -oE '"exit_code"\s*:\s*[0-9]+' | head -1 | grep -oE '[0-9]+$') || true
fi

# Only log errors (non-zero exit code)
if [ -z "$EXIT_CODE" ] || [ "$EXIT_CODE" = "0" ]; then
  exit 0
fi

# Extract command
COMMAND=""
if command -v jq >/dev/null 2>&1; then
  COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null) || true
fi
if [ -z "$COMMAND" ]; then
  COMMAND=$(echo "$INPUT" | tr '\n' ' ' | grep -oE '"command"\s*:\s*"[^"]*"' | head -1 | sed 's/^"command"\s*:\s*"//;s/"$//') || true
fi

# Extract first line of stderr
STDERR_LINE=""
if command -v jq >/dev/null 2>&1; then
  STDERR_LINE=$(echo "$INPUT" | jq -r '.tool_result.stderr // .tool_output.stderr // empty' 2>/dev/null | head -1) || true
fi
if [ -z "$STDERR_LINE" ]; then
  STDERR_LINE=$(echo "$INPUT" | tr '\n' ' ' | grep -oE '"stderr"\s*:\s*"[^"]*"' | head -1 | sed 's/^"stderr"\s*:\s*"//;s/"$//' | head -1) || true
fi

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S' 2>/dev/null) || TIMESTAMP="unknown"
ERRORS_FILE="memory/knowledge/errors_raw.log"

# Create directory and file if missing
mkdir -p "$(dirname "$ERRORS_FILE")" 2>/dev/null || true

if [ ! -f "$ERRORS_FILE" ]; then
  echo "# ALBA Error Log (auto-captured)" > "$ERRORS_FILE" 2>/dev/null || true
  echo "# Format: timestamp | command | exit_code | stderr" >> "$ERRORS_FILE" 2>/dev/null || true
  echo "" >> "$ERRORS_FILE" 2>/dev/null || true
fi

# Truncate long command/stderr for log readability
COMMAND_SHORT=$(echo "$COMMAND" | head -1 | cut -c1-200) || true
STDERR_SHORT=$(echo "$STDERR_LINE" | cut -c1-200) || true

# Append error entry
echo "${TIMESTAMP} | ${COMMAND_SHORT} | exit:${EXIT_CODE} | ${STDERR_SHORT}" >> "$ERRORS_FILE" 2>/dev/null || true

exit 0
