# Memory System Guide

## Structure

```
memory/
├── state/              # Hot: updated every session
│   ├── dashboard.md    # Priorities, projects, deadlines
│   └── todo.md         # Active tasks
├── knowledge/          # Warm: updated occasionally
│   ├── learnings.md    # Accumulated insights
│   ├── preferences.md  # User preferences
│   └── errors.md       # Error solutions (auto-updated)
├── projects/           # Cold: per-project context
│   └── [project-name]/
│       └── context.md
└── daily/              # Logs: auto-created session summaries
    └── YYYY-MM-DD.md
```

## Usage

| Tier | When to Read | When to Update |
|------|-------------|----------------|
| State | Session start | Every session (start/end) |
| Knowledge | On relevant events | When learned (auto for errors) |
| Projects | When switching context | Per-project work |
| Daily | Weekly review, /reflect | Session end (auto) |

## Best Practices

- Progressive disclosure: read what's needed, not everything
- Let Claude auto-update errors.md and learnings.md
- Archive completed projects to projects/archive/
- Review daily logs weekly with /reflect
