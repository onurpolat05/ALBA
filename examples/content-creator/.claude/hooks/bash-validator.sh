#!/bin/bash

# ALBA - Bash Validator Hook
# Event: PreToolUse
# Matcher: Bash
# Purpose: Block dangerous bash commands before execution
#
# Hook input: JSON on stdin with tool_name and tool_input
# Hook output: JSON with decision (allow/block)
#
# Cross-platform (macOS + Linux). Never exits 1.
# Uses jq if available, falls back to grep for JSON parsing.

# Ensure we always output valid JSON, even on unexpected errors
trap 'echo "{\"decision\": \"allow\"}"; exit 0' ERR

INPUT=$(cat)

# Extract command - try jq first, fallback to grep
COMMAND=""
if command -v jq >/dev/null 2>&1; then
  COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
fi

# Fallback: grep-based extraction (handles single-line JSON)
if [ -z "$COMMAND" ]; then
  COMMAND=$(echo "$INPUT" | tr '\n' ' ' | grep -oE '"command"\s*:\s*"[^"]*"' | head -1 | sed 's/^"command"\s*:\s*"//;s/"$//')
fi

# If no command found, allow
if [ -z "$COMMAND" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Dangerous patterns to block
BLOCKED_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \.$"
  "mkfs\."
  "dd if="
  ":(){:|:&};:"
  "shutdown"
  "reboot"
  "halt"
  "> /dev/sda"
  "chmod -R 777 /"
  "DROP DATABASE"
  "DROP TABLE"
  "DELETE FROM.*WHERE 1"
  "format c:"
)

for PATTERN in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qiE "$PATTERN" 2>/dev/null; then
    # Sanitize the pattern for JSON output (escape quotes and backslashes)
    SAFE_PATTERN=$(echo "$PATTERN" | sed 's/\\/\\\\/g; s/"/\\"/g')
    echo "{\"decision\": \"block\", \"reason\": \"Dangerous command blocked: matches pattern '$SAFE_PATTERN'. Ask user for confirmation before running.\"}"
    exit 0
  fi
done

# Allow everything else
echo '{"decision": "allow"}'
exit 0
