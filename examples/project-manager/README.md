# Project Manager Setup Example

This is an example ALBA setup for a project manager who coordinates cross-functional teams, manages client relationships, and needs an AI assistant for task tracking, communication drafting, meeting prep, and resource planning.

## Profile

- **Role:** Project Manager
- **Work Style:** Organized, deadline-driven, team coordination
- **Tools:** Trello, Gmail, Google Calendar, Slack
- **Focus Areas:** Sprint management, client communication, resource allocation

## What's Included

```
project-manager/
├── CLAUDE.md                    # Agent instructions (PM-focused)
├── memory/
│   ├── state/
│   │   ├── dashboard.md         # PM dashboard with projects, meetings, deadlines
│   │   └── todo.md              # Weekly tasks with owners and due dates
│   └── knowledge/
│       ├── preferences.md       # Communication templates and PM workflow
│       ├── learnings.md         # Process insights and team patterns
│       └── errors.md            # Process mistakes and fixes
└── .claude/
    ├── skills/
    │   └── research/
    │       └── SKILL.md         # Research skill (market, competitor, best practices)
    ├── rules/
    │   ├── behavioral.md        # PM-specific decision protocol
    │   └── security.md          # Security guidelines
    └── docs/
        ├── memory-system.md     # Memory system guide
        └── decision-protocol.md # When to ask vs. act autonomously
```

## Key Features

### 1. PM-Focused CLAUDE.md
- Operations assistant role tailored for project management
- Task tracking, email triage, meeting prep, client communication
- Structured output: tables for tracking, bullets for action items
- Proactive deadline reminders and risk flagging

### 2. Rich Dashboard
- Active projects with team members, deadlines, and status
- Weekly calendar view with meetings and tasks
- Upcoming deadlines table with owners
- Last session summary for continuity

### 3. Communication Templates
- Status update format (Project > Status > Risks > Next Steps)
- Meeting notes format (Decisions > Action Items > Follow-ups)
- Escalation template (Issue > Impact > Ask > Deadline)
- All defined in `preferences.md` for consistent output

### 4. Research Skill
- Market research and competitor analysis
- Industry best practices and benchmarking
- Vendor evaluation and tool comparison
- Uses Exa + Firecrawl MCP or built-in WebSearch/WebFetch

### 5. PM Decision Protocol
- Clear rules for when to act vs. ask (client comms always need approval)
- Team coordination guidelines
- Escalation and risk management rules

## How to Use This Example

### Option 1: Copy to Your Setup
```bash
# After running /setup, copy the files you want
cp -r examples/project-manager/memory/ memory/
cp examples/project-manager/CLAUDE.md CLAUDE.md
cp -r examples/project-manager/.claude/ .claude/
```

### Option 2: Reference During Setup
When running `/setup`, mention you want a "project manager setup" and Claude will create something similar.

### Option 3: Learn the Pattern
Read through the files to understand how a PM workflow maps to the ALBA system.

## MCP Integrations (Optional)

| Integration | What It Enables | MCP Server |
|-------------|----------------|------------|
| **Trello** | Read/create/move cards, manage sprints | `mcp__trello__*` |
| **Gmail** | Draft emails, triage inbox, client comms | `mcp__claude_ai_Gmail__*` |
| **Google Calendar** | Check availability, schedule meetings | `mcp__google-calendar__*` |
| **Exa** | Semantic search for research | `mcp__exa__*` |
| **Firecrawl** | Web scraping for deep research | `mcp__firecrawl__*` |

All integrations are optional. ALBA works without any MCP servers using built-in tools.

## Customization Ideas

- Add a `/weekly-report` skill to auto-generate weekly status summaries
- Add project-specific folders in `memory/projects/` for each active project
- Connect Trello via MCP for live board management
- Add a `/meeting-prep` skill that pulls calendar events and creates agendas
- Set up hooks to auto-load the dashboard on session start

---

This example is based on a realistic PM workflow, designed to demonstrate ALBA's capabilities for non-engineering roles.
