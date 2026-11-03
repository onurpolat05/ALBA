#!/bin/bash
# Runs templates/hooks/bash-validator.sh.template against tools/validator-cases.txt.
# Usage: bash tools/test-validator.sh [-v]     (-v prints every case)
# Exit 1 if any case disagrees with its expected decision. Needs jq.
#
# Commands are read from a data file on purpose: a test script that spells out
# `rm -rf /` in its own source trips command-safety checks in the tools that
# run it, even though nothing here ever executes a case - each one is only
# wrapped in JSON and piped to a script that runs grep.

cd "$(dirname "$0")/.." || exit 1
VALIDATOR="templates/hooks/bash-validator.sh.template"
CASES="tools/validator-cases.txt"
VERBOSE=0
[ "${1:-}" = "-v" ] && VERBOSE=1

if ! command -v jq >/dev/null 2>&1; then
  echo "test-validator: jq is required" >&2
  exit 1
fi

pass=0
fail=0
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in ''|'#'*) continue ;; esac
  expected="${line%%|*}"
  cmd="${line#*|}"
  NL='
'
  cmd="${cmd//<NL>/$NL}"
  out=$(jq -nc --arg c "$cmd" '{hook_event_name:"PreToolUse",tool_name:"Bash",tool_input:{command:$c}}' \
    | bash "$VALIDATOR" 2>/dev/null)
  got=$(printf '%s' "$out" | jq -r '.hookSpecificOutput.permissionDecision // empty' 2>/dev/null)
  [ -z "$got" ] && got="none"
  if [ "$got" = "$expected" ]; then
    pass=$((pass + 1))
    [ "$VERBOSE" = 1 ] && printf 'ok    %-5s %s\n' "$got" "$cmd"
  else
    fail=$((fail + 1))
    printf 'FAIL  expected %-5s got %-5s  %s\n' "$expected" "$got" "$cmd"
  fi
done < "$CASES"

echo "bash-validator: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
