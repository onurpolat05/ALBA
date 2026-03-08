---
name: weekly-review
description: Weekly performance review - analyze progress, extract patterns, plan next week
context: inline
allowed-tools: [Read, Write, Edit, Glob, Grep, AskUserQuestion]
---

# /weekly-review - Weekly Performance Review

Structured weekly review: gather data, present summary, ask questions, save review.

## Process

### 1. Gather Data (silent - don't show raw data)

Read these files:
- `memory/state/dashboard.md` - current priorities and status
- `memory/state/todo.md` - task completion
- `memory/knowledge/learnings.md` - this week's entries (by date)
- `memory/knowledge/errors.md` - this week's errors (by date)
- `memory/daily/` - scan for this week's session logs (Mon-Sun)

Extract:
- Tasks completed: count `[x]` items from dailies + todo
- Tasks added: count new `[ ]` items
- Learnings recorded this week
- Errors encountered and resolved
- Open blockers from dashboard

### 2. Present Draft

Show a concise draft:

```
Week Review: YYYY-Www (Mon DD - Sun DD)

Completed: X tasks
- [top 3-5 completed items]

Learnings: Y new
- [list if any]

Errors: Z encountered, W resolved
- [list if any]

Open Blockers:
- [from dashboard, if any]
```

### 3. Ask 3 Questions (one at a time)

**Q1:** "Does this look right? Anything to add or fix?"
**Q2:** "What went well this week?"
**Q3:** "Top 3 priorities for next week?"

Keep questions short. Accept brief answers.

### 4. Save Review

Write to `memory/state/weekly-reviews/YYYY-Www.md`:

```markdown
# Week YYYY-Www

## Summary
- Days active: [count from daily logs]
- Tasks completed: [count]
- New learnings: [count]

## Completed
- [Items from draft + Q1 corrections]

## What Went Well
- [From Q2]

## Learnings
- [This week's entries]

## Blockers
- [Open items]

## Next Week Priorities
1. [From Q3]
2. [From Q3]
3. [From Q3]
```

### 5. Update Dashboard

- Replace/update priority section in `memory/state/dashboard.md` with next week's priorities from Q3
- Keep existing project info, only update priorities

### 6. Archive Check

If `memory/state/weekly-reviews/` has more than 4 review files:
- Suggest: "You have [N] weekly reviews. Archive older ones? (I'll move them to memory/state/weekly-reviews/archive/)"
- Only archive if user agrees

## Output

End with a 3-line confirmation:

```
Review saved: memory/state/weekly-reviews/YYYY-Www.md
Dashboard updated with next week priorities.
[If archive suggested: "Consider archiving old reviews with /extend"]
```

## Rules

- Keep the review file under 60 lines
- Don't generate fake data - if no daily logs exist, say "No session logs found for this week"
- Use ISO week numbers (W01-W52)
- Create `memory/state/weekly-reviews/` directory if it doesn't exist
- Match the user's language from CLAUDE.md
- This is a reflection tool, not a performance evaluation - keep tone neutral and constructive
