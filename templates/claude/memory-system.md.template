# Memory System Guide

## Overview

The memory system helps Claude remember context across sessions. It's organized into categories for efficient retrieval.

## Structure

```
memory/
├── state/              # Current state (updated frequently)
│   ├── todo.md        # Active tasks and goals
│   └── current_focus.md # Current priorities
├── knowledge/         # Long-term knowledge (updated occasionally)
│   ├── learnings.md   # Accumulated knowledge
│   ├── preferences.md # User preferences
│   └── errors.md      # Error solutions (auto-updated)
├── projects/          # Project-specific context
│   └── [project-name]/
│       ├── context.md # Project overview
│       └── ...        # Project files
└── daily/             # Daily logs (auto-created)
    └── YYYY-MM-DD.md
```

## How to Use

### State Files (Update Frequently)

**todo.md**
- Active tasks and goals
- This week's focus
- Blockers
- Update at session start/end

**current_focus.md**
- Current priorities
- Last session summary
- Next session plan
- Update during session

### Knowledge Files (Update Occasionally)

**learnings.md**
- New knowledge acquired
- Insights and patterns
- How to apply learnings
- Claude updates automatically

**preferences.md**
- How you like to work
- Communication style
- Tool preferences
- Update when preferences change

**errors.md**
- Solutions to past errors
- Troubleshooting guides
- Claude updates automatically
- Reference when similar errors occur

### Project Files (Per Project)

Each project gets its own folder with:
- `context.md` - Project overview, goals, status
- Other project-specific files as needed

### Daily Logs (Auto-created)

- Created automatically by Claude
- Summary of each session
- Tasks completed
- Learnings
- Next steps

## Best Practices

### 1. Progressive Disclosure
Don't load all memory files at once. Claude reads what's needed:
- Session start → `todo.md`, `current_focus.md`
- Error encountered → `errors.md`
- Project work → `projects/[name]/context.md`
- Learning recorded → `learnings.md`

### 2. Keep It Updated
- Update `todo.md` weekly
- Update `current_focus.md` at session end
- Let Claude auto-update `learnings.md` and `errors.md`

### 3. Use Clear Language
- Write for future you (or future Claude)
- Be specific, not vague
- Include dates for time-sensitive info

### 4. Archive When Done
- Move completed projects to `projects/archive/`
- Keep active projects in `projects/`

## Commands for Memory

| Command | What It Does |
|---------|-------------|
| `/start` | Loads current state and priorities |
| `/end` | Saves session summary to daily log |
| `/status` | Quick status from current state |

## Example Workflow

### Session Start
1. Run `/start`
2. Claude reads `todo.md` and `current_focus.md`
3. Shows priorities and tasks
4. Ready to work

### During Session
1. Work on tasks
2. Claude updates memory as needed
3. Learns from errors → `errors.md`
4. Records insights → `learnings.md`

### Session End
1. Run `/end`
2. Claude creates daily log
3. Updates `current_focus.md`
4. Summarizes accomplishments

## Tips

**For Task Management:**
- Keep `todo.md` focused on this week
- Archive old tasks regularly
- Use clear task descriptions

**For Knowledge:**
- Let Claude handle `learnings.md` - it's good at it
- Review `errors.md` when stuck
- Update `preferences.md` when workflow changes

**For Projects:**
- One folder per active project
- Keep `context.md` updated
- Archive when project completes

**For Daily Logs:**
- Auto-generated, no action needed
- Great for weekly reviews
- Reference when needed

---

Created: [Date]
