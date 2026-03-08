---
name: end
description: End session - save state and create daily log
context: inline
allowed-tools: [Read, Write, Edit, Glob, AskUserQuestion]
---

# /end - Session End

Close the session with a structured 3-question protocol. Save state for next session.

## Steps

### 1. Ask 3 Questions (one at a time, keep it short)

**Q1:** "What was completed this session?" *(max 3 bullets)*
**Q2:** "Any learnings or insights?" *(optional - user can skip)*
**Q3:** "What's the priority for next session?" *(1 sentence)*

### 2. Auto-Update (after answers)

**Dashboard** (`memory/state/dashboard.md`):
- Mark completed items as `[x]`
- Add next priority if mentioned
- Update any status changes

**Todo** (`memory/state/todo.md`):
- Mark completed tasks as `[x]`

**Learnings** (`memory/knowledge/learnings.md`):
- If Q2 had content, append in format:
```markdown
## [Topic] - YYYY-MM-DD
**Context:** [What prompted this learning]
**Insight:** [The learning itself]
**Application:** [When to apply this]
```

**Errors** (`memory/knowledge/errors.md`):
- Check `memory/knowledge/errors_raw.log` for new entries from this session
- If errors were resolved during the session, consolidate them into `errors.md`:
```markdown
## [Error Type] - YYYY-MM-DD
**Pattern:** [What triggers this error]
**Solution:** [How it was resolved]
**Prevention:** [How to avoid it]
```

**Daily Log** (`memory/daily/YYYY-MM-DD.md`):
- Create with session summary:
```markdown
# YYYY-MM-DD

## Completed
- [From Q1 answers]

## Learnings
- [From Q2, if any]

## Next
- [From Q3]
```

### 3. Confirm

Output a 3-line summary:
```
Session saved.
Completed: [count] items | Learnings: [count]
Next: [priority from Q3]
```

## Rules

- Keep questions SHORT - this is CLI, not a form
- If user says "nothing" or skips Q2, that's fine - don't push
- Don't read the entire dashboard - just update what changed
- If daily log already exists (multiple sessions per day), append to it
- Create memory/daily/ directory if it doesn't exist
- Never fail silently - confirm what was saved
- Respect user's language (follow dashboard/CLAUDE.md language)
