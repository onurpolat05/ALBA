# Memory System

## Structure

```
memory/
├── state/          # Current state (updated frequently)
│   ├── todo.md
│   └── current_focus.md
├── knowledge/      # Long-term (updated occasionally)
│   ├── learnings.md
│   ├── preferences.md
│   └── errors.md
├── projects/       # Project-specific context
└── daily/          # Daily session logs
```

## Usage

- **Session start:** Read `state/` files
- **Error solved:** Update `knowledge/errors.md`
- **New insight:** Update `knowledge/learnings.md`
- **Session end:** Create daily log in `daily/`

## Progressive Disclosure

Don't load everything. Read what's needed, when needed.

---

*Last updated: 2025-01-09*
