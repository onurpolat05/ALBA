#!/bin/bash

# ALBA - Bash Validator Hook
# Event: PreToolUse
# Matcher: Bash
# Purpose: Block dangerous bash commands before execution
#
# Two-layer security model (v1.1.0+):
#   Layer 1 (CC native): permissions.deny / permissions.ask in settings.json
#                        catches command-level rules, including wrapper-bypassed
#                        commands (env/sudo/watch/ionice/setsid) and
#                        find -exec/-delete since CC v2.1.113.
#   Layer 2 (this hook): semantic intent detection for catastrophic patterns
#                        that command-level rules cannot reason about
#                        (fork bombs, pipe-to-shell, SQL drops, etc).
#
# Cross-platform (macOS + Linux). Never exits 1.
# Uses jq if available, falls back to grep for JSON parsing.
# Patterns use [[:space:]]+ instead of literal spaces to close tab-bypass.

# Ensure we always output valid JSON, even on unexpected errors
trap 'echo "{\"decision\": \"block\", \"reason\": \"Validator error - blocked for safety. Review command manually.\"}"; exit 0' ERR

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

# Dangerous patterns to block (semantic intent layer)
BLOCKED_PATTERNS=(
  "rm[[:space:]]+-rf?[[:space:]]+/"
  "rm[[:space:]]+-rf?[[:space:]]+~"
  "rm[[:space:]]+-rf?[[:space:]]+\.$"
  "mkfs\."
  "dd[[:space:]]+if="
  ":\(\)[[:space:]]*\{[[:space:]]*:\|:&[[:space:]]*\}[[:space:]]*;[[:space:]]*:"
  "shutdown"
  "reboot"
  "halt"
  ">[[:space:]]*/dev/sd"
  "chmod[[:space:]]+-R[[:space:]]+0?777[[:space:]]+/"
  "DROP[[:space:]]+DATABASE"
  "DROP[[:space:]]+TABLE"
  "DELETE[[:space:]]+FROM.*WHERE[[:space:]]+1"
  "format[[:space:]]+c:"
  "curl.*\|.*bash"
  "curl.*\|.*sh"
  "wget.*-O-.*\|.*sh"
  "eval[[:space:]]+\\\$\("
  "sudo[[:space:]]+rm[[:space:]]+-rf"
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
