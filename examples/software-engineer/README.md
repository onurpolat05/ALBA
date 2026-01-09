# Software Engineer Setup Example

This is an example opAgent setup for a software engineer who works on multiple projects, uses GitHub and Trello for task management, and wants an AI assistant for research, task organization, and daily workflow management.

## Profile

- **Role:** Software Engineer
- **Work Style:** Fast iteration, MVP approach, multiple parallel projects
- **Tools:** GitHub, Trello, Slack, Gmail
- **Technical Level:** Advanced

## What's Included

```
software-engineer/
├── CLAUDE.md                    # Agent instructions (developer-focused)
├── memory/
│   ├── state/
│   │   └── todo.md              # Example task list
│   └── knowledge/
│       └── preferences.md       # Communication preferences
└── .claude/
    ├── commands/
    │   └── start.md             # /start command
    └── skills/
        └── research/
            └── SKILL.md         # Research skill definition
```

## Key Features

### 1. Developer-Focused CLAUDE.md
- Executive assistant role (not code writer)
- Research and planning focus
- Task organization and tracking
- Tool integrations via MCP

### 2. Research Skill
- Web research using Exa (semantic search) + Firecrawl (scraping)
- Structured output with sources
- Multiple search strategies (general, technical docs, news)

### 3. Memory System
- `state/todo.md` - Current tasks and priorities
- `knowledge/preferences.md` - How to communicate
- Progressive disclosure (load what's needed)

### 4. Commands
- `/start` - Begin session, load context, show priorities

## How to Use This Example

### Option 1: Copy to Your Setup
```bash
# After running /setup, copy specific files you want
cp examples/software-engineer/.claude/skills/research/SKILL.md .claude/skills/research/
```

### Option 2: Reference During Setup
When running `/setup`, mention you want a "developer setup" and Claude will create something similar.

### Option 3: Learn the Pattern
Read through the files to understand how skills, commands, and memory work together.

## Customization Ideas

- Add more skills (code review, PR tracking, deployment)
- Add hooks for automatic context loading
- Connect GitHub/Trello via MCP
- Add project-specific folders in `memory/projects/`

---

This example is based on a real opAgent setup, anonymized for sharing.
