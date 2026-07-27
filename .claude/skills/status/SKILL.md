---
name: status
description: Read-only snapshot of the current focus, active/completed task counts and blockers, in under 8 lines. Use when user says "status", "where are we", "what's left", "any blockers", "quick check", or wants a mid-session pulse without changing anything. Do NOT use to open a session (use /start, which also looks for a resumable daily log) and do NOT use for week-level analysis (use /weekly-review).
context: inline
effort: low
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

## Optional: pin a cheaper model

This skill reads two files, counts checkboxes and prints eight lines, and it is the skill people
run most often — nothing here needs a frontier model. Adding a `model:` line to the frontmatter
routes it to a smaller one and cuts the cost of every `/status` you ever run.

ALBA does not ship that pin, on purpose. A model id is a moving target: pin a dated one and you
keep running last year's model long after a better and cheaper one exists, and you break outright
if that id is ever retired. Check the [model list](https://docs.claude.com/en/docs/about-claude/models)
for the current id, add the line yourself, and treat it as something you re-check — not as
configuration that stays correct on its own.
