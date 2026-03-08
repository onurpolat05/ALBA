# Founder Example - ALBA Setup

ALBA setup for a solo founder or freelancer managing multiple clients, projects, revenue streams, and personal brand simultaneously.

## Profile

- **Role:** Founder / Solo Entrepreneur
- **Work Style:** High velocity, deadline-driven, multi-project
- **Tools:** Trello (projects), Gmail (clients), Google Calendar, GitHub
- **Technical Level:** Advanced

## What's Included

```
founder/
├── README.md
├── CLAUDE.md                         # Founder-focused agent config
├── memory/
│   ├── state/
│   │   ├── dashboard.md              # Revenue, clients, deadlines, brand
│   │   └── todo.md                   # Mixed client + biz dev tasks
│   ├── knowledge/
│   │   ├── preferences.md            # Time management, delegation style
│   │   ├── learnings.md              # Business insights
│   │   └── errors.md                 # Tool/process errors
│   └── daily/                        # Session logs
├── .claude/
│   ├── settings.json                 # Hook configuration
│   ├── rules/
│   │   ├── behavioral.md             # Business decision protocol
│   │   └── security.md               # Client data, credentials
│   └── docs/
│       ├── decision-protocol.md
│       └── memory-system.md
```

## Key Differentiators

- **Revenue tracking** in dashboard
- **Client-first prioritization** in behavioral rules
- **Multi-project context switching** with project folders
- **Deadline awareness** as core behavior
- **Personal brand** tracking alongside client work

## How to Use

```bash
cp -r examples/founder/* your-project/
cp -r examples/founder/.claude your-project/
```
