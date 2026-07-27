#!/bin/bash

# ALBA - Agent Suggest Hook
# Event: UserPromptSubmit
# Purpose: Suggest a relevant skill/agent based on keywords in the user prompt.
#
# INPUT CONTRACT: the prompt text lives in the top-level `prompt` field.
#   {"session_id":"...","cwd":"...","hook_event_name":"UserPromptSubmit",
#    "prompt":"Write a function to ..."}
# There is no `message` or `user_prompt` field. ALBA <= v1.1.0 read
# `.message // .user_prompt`, which always resolved to empty - the hook was
# dead in every session it ever ran in.
#
# OUTPUT CONTRACT: on exit 0, plain stdout text is added to the conversation as
# context and is visible in the transcript, so the user sees the tip too. (JSON
# `hookSpecificOutput.additionalContext` is the alternative - it reaches Claude
# as a system reminder but stays invisible to the user. For a suggestion, being
# visible is the point.) Emitting a bare `{"message": ...}` object, as ALBA
# <= v1.1.0 did, is not part of any contract - it would be injected as literal
# JSON text.
#
# Only fires on high-confidence keyword matches; a hook that talks constantly
# stops being read. Cross-platform (macOS bash 3.2 + Linux + Git Bash).
# Note: UserPromptSubmit hooks have a 30s timeout (shorter than the 60s default).

trap 'exit 0' ERR

INPUT=$(cat 2>/dev/null) || true

# Extract prompt text - jq first, grep fallback.
PROMPT=""
if command -v jq >/dev/null 2>&1; then
  PROMPT=$(printf '%s' "$INPUT" | jq -r '.prompt // empty' 2>/dev/null) || true
fi
if [ -z "$PROMPT" ]; then
  PROMPT=$(printf '%s' "$INPUT" | tr '\n' ' ' \
    | grep -oE '"prompt"[[:space:]]*:[[:space:]]*"[^"]*"' \
    | head -1 \
    | sed 's/^"prompt"[[:space:]]*:[[:space:]]*"//;s/"$//') || true
fi

# No prompt found - silent exit
if [ -z "$PROMPT" ]; then
  exit 0
fi

# Lowercase for matching. Note: tr does not fold Turkish I/i correctly, so the
# patterns below spell out both variants where it matters.
PROMPT_LOWER=$(printf '%s' "$PROMPT" | tr '[:upper:]' '[:lower:]')

# Research/investigation (Turkish: arastir/araştır)
if printf '%s' "$PROMPT_LOWER" | grep -qE "ara[sş]t[iı]r|research|investigate|deep.?dive"; then
  echo "Tip: the /research skill is available for deep investigation."
  exit 0
fi

# Planning (Turkish: planla)
if printf '%s' "$PROMPT_LOWER" | grep -qE "planla|plan.*(break|task|step)|architect.*system|design.*system"; then
  echo "Tip: consider /plan for task breakdown and architecture."
  exit 0
fi

# Code review
if printf '%s' "$PROMPT_LOWER" | grep -qE "review.*(code|pr|quality)|audit.*(security|code)|check.*quality"; then
  echo "Tip: consider a code-reviewer agent for a thorough pass."
  exit 0
fi

# No match - silent exit (no output)
exit 0
