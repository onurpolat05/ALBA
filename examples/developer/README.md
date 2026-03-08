# Developer Example - ALBA Setup

This is an example ALBA setup for a software developer who works on multiple projects, uses GitHub and Trello for task management, and wants an AI assistant for research, task organization, and daily workflow management.

## Profile

- **Role:** Software Developer
- **Work Style:** Fast iteration, MVP approach, multiple parallel projects
- **Tools:** GitHub, Trello (MCP), Slack (MCP)
- **Technical Level:** Advanced

## What's Included

```
developer/
├── README.md                         # This file
├── CLAUDE.md                         # Agent instructions (ALBA template format)
├── memory/
│   ├── state/
│   │   ├── dashboard.md              # Example developer dashboard
│   │   └── todo.md                   # Example task list
│   └── knowledge/
│       ├── preferences.md            # Communication preferences
│       ├── learnings.md              # Empty template (auto-updated)
│       └── errors.md                 # Empty template (auto-updated)
└── .claude/
    ├── skills/
    │   └── research/
    │       └── SKILL.md              # Research skill (Exa + Firecrawl)
    ├── rules/
    │   ├── behavioral.md             # Decision protocol, communication, self-improvement
    │   └── security.md               # Input validation, secrets, safe commands
    └── docs/
        ├── memory-system.md          # Memory system guide
        └── decision-protocol.md      # When to ask vs. act autonomously
```

## Key Features

### 1. ALBA Template Format (CLAUDE.md)
- Skills 2.0 with frontmatter format (`name`, `description`, `context`, `allowed-tools`)
- Hooks table (6 automated event handlers)
- Rules auto-loaded from `.claude/rules/`
- Progressive disclosure for efficient context loading
- Three-tier memory system (hot/warm/cold)

### 2. Skills (`.claude/skills/`)
Skills replace the old `.claude/commands/` pattern. Each skill has:
- A `SKILL.md` file with YAML frontmatter
- `context: fork` (runs as subagent) or `context: inline` (runs in main context)
- `allowed-tools` to restrict tool access

Available skills in this example:
| Skill | Purpose |
|-------|---------|
| `/research` | Web research using Exa + Firecrawl MCP |
| `/start` | Begin session, load dashboard |
| `/end` | End session, save state |
| `/status` | Quick status overview |
| `/extend` | Add new features interactively |
| `/reflect` | Cross-session pattern analysis |

### 3. Rules (`.claude/rules/`)
Rules auto-load when Claude starts. No need to reference them in CLAUDE.md.
- `behavioral.md` - How Claude should communicate, decide, and self-improve
- `security.md` - Safe command execution, secrets protection, input validation

### 4. Hooks
Automated scripts that respond to Claude Code events:
| Event | Purpose |
|-------|---------|
| SessionStart | Load context, show dashboard |
| Stop | Remind to save state |
| PreToolUse | Block dangerous commands |
| PostToolUse | Log error patterns |
| UserPromptSubmit | Suggest relevant agents |
| PreCompact | Preserve critical context |

### 5. Memory System
- `state/dashboard.md` - Current priorities, active projects, deadlines
- `state/todo.md` - Weekly task breakdown
- `knowledge/preferences.md` - Communication and work style preferences
- `knowledge/learnings.md` - Auto-updated knowledge base
- `knowledge/errors.md` - Auto-updated error solutions

### 6. Docs (`.claude/docs/`)
Reference documents loaded on-demand via progressive disclosure:
- `memory-system.md` - How the memory system works
- `decision-protocol.md` - When to ask vs. act autonomously

## How to Use This Example

### Option 1: Copy to Your Setup
```bash
# Copy the entire example to your project
cp -r examples/developer/* your-project/
cp -r examples/developer/.claude your-project/
```

### Option 2: Cherry-Pick
```bash
# Copy specific parts you need
cp examples/developer/.claude/skills/research/SKILL.md .claude/skills/research/
cp examples/developer/.claude/rules/behavioral.md .claude/rules/
```

### Option 3: Learn the Pattern
Read through the files to understand how skills, hooks, rules, and memory work together in ALBA.

## Customization Ideas

- Add more skills (code review, PR tracking, deployment)
- Add hooks for automatic context loading
- Connect GitHub/Trello/Slack via MCP
- Add project-specific folders in `memory/projects/`
- Create custom rules for your workflow

---

This example is based on a real ALBA setup, anonymized for sharing.
