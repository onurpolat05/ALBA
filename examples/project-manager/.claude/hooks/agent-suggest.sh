#!/bin/bash

# ALBA - Agent Suggest Hook
# Event: UserPromptSubmit
# Purpose: Suggest relevant skills/agents based on keywords in user prompt
#
# Hook input: JSON on stdin with user prompt text
# Hook output: JSON with optional "message" field for suggestions
#
# Only suggests when keyword match confidence is high.
# Cross-platform (macOS + Linux). Never exits 1.

# Always output valid JSON on error
trap 'exit 0' ERR

INPUT=$(cat 2>/dev/null) || true

# Extract prompt text - try jq first, fallback to grep
PROMPT=""
if command -v jq >/dev/null 2>&1; then
  PROMPT=$(echo "$INPUT" | jq -r '.message // .user_prompt // empty' 2>/dev/null) || true
fi
if [ -z "$PROMPT" ]; then
  PROMPT=$(echo "$INPUT" | tr '\n' ' ' | grep -oE '"message"\s*:\s*"[^"]*"' | head -1 | sed 's/^"message"\s*:\s*"//;s/"$//') || true
fi

# No prompt found - silent exit
if [ -z "$PROMPT" ]; then
  exit 0
fi

# Lowercase for matching
PROMPT_LOWER=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# Keyword -> suggestion mapping
# Only suggest when multiple keywords match or a very specific keyword is found
# This keeps noise low - single generic words won't trigger suggestions

# Research/investigation (Turkish: arastir/araştır)
if echo "$PROMPT_LOWER" | grep -qE "ara[sş]t[iı]r|research|investigate|deep.?dive"; then
  echo "{\"message\": \"Tip: /research skill available for deep investigation.\"}"
  exit 0
fi

# Planning (Turkish: planla)
if echo "$PROMPT_LOWER" | grep -qE "planla|plan.*(break|task|step)|architect.*system|design.*system"; then
  echo "{\"message\": \"Tip: Consider /plan for task breakdown and architecture.\"}"
  exit 0
fi

# Code review
if echo "$PROMPT_LOWER" | grep -qE "review.*(code|pr|quality)|audit.*(security|code)|check.*quality"; then
  echo "{\"message\": \"Tip: Consider a code-reviewer agent for thorough analysis.\"}"
  exit 0
fi

# No match - silent exit (no output)
exit 0
