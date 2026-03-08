---
name: status
description: Quick status overview - priorities, tasks, blockers
context: inline
allowed-tools: [Read, Glob]
---

# /status - Quick Status

Display current state in under 10 lines. No questions, pure read-only.

## Steps

1. **Read** `memory/state/dashboard.md` (silent)
2. **Read** `memory/state/todo.md` (silent)
3. **Check** `memory/daily/` for last session date

## Output Format

```
Status: YYYY-MM-DD

Focus: [Current top priority from dashboard]

Tasks: X active | Y completed
[If blockers exist: "Blocked: [blocker description]"]

Last session: YYYY-MM-DD
```

## Rules

- Maximum 8 lines of output
- If dashboard doesn't exist: "No dashboard. Run /setup or create memory/state/dashboard.md"
- If no daily logs exist: omit "Last session" line
- Count active tasks: grep `- [ ]` in todo.md
- Count completed: grep `- [x]` in todo.md
- Extract blockers: look for "block", "wait", "stuck" keywords in dashboard
- Don't load errors.md, learnings.md, or any .claude/docs/ files
- This must be FAST - minimal file reads
