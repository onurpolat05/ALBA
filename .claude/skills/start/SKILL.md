---
name: start
description: Open a work session - reads dashboard and todo, checks for a resumable daily log, prints today's top priorities in under 10 lines. Use when user says "start", "let's begin", "good morning", "what am I working on today", "open the session", or types /start at the top of a session. Do NOT use for a mid-session check (use /status, which is read-only and does not look for a resume point), and do NOT use to close a session (use /end).
context: inline
effort: low
allowed-tools: [Read, Glob]
---

# /start - Session Start

Load context and show today's focus. Keep output under 10 lines.

## Steps

1. **Read dashboard** (silent): `memory/state/dashboard.md`
2. **Read todo** (silent): `memory/state/todo.md`
3. **Check for resume**: Look for `memory/daily/YYYY-MM-DD.md` (today's date)

## Output Format

```
Session: YYYY-MM-DD HH:MM
[If resuming: "Resuming - previous session logged"]

Priorities:
- [TOP priority from dashboard - most urgent/important item]
- [Secondary priority]
- [Next actionable step]

Tasks: X active | Y completed today
```

## Rules

- Maximum 10 lines of output
- If dashboard doesn't exist yet, say: "No dashboard found. Run /setup first or create memory/state/dashboard.md"
- If todo doesn't exist, skip task count
- Don't read errors.md or learnings.md at start (save context window)
- Don't ask questions - this is a pure read-and-display command
- Use the user's language preference from CLAUDE.md (default: follow dashboard language)
- Show priorities by importance, not by file order
