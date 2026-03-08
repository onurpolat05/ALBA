# Researcher Example - ALBA Setup

ALBA setup for an academic or market researcher who does structured information gathering, source management, and synthesis.

## Profile

- **Role:** Researcher (academic/market)
- **Work Style:** Thorough, evidence-based, systematic
- **Tools:** Exa (semantic search), Firecrawl (scraping), Zotero/Obsidian (optional)
- **Technical Level:** Intermediate

## What's Included

```
researcher/
├── README.md
├── CLAUDE.md                         # Research-focused agent config
├── memory/
│   ├── state/
│   │   ├── dashboard.md              # Research topics, reading queue, deadlines
│   │   └── todo.md                   # Research tasks
│   ├── knowledge/
│   │   ├── preferences.md            # Citation format, source criteria
│   │   ├── learnings.md              # Research insights
│   │   └── errors.md                 # Search/tool errors
│   └── daily/                        # Session logs
├── .claude/
│   ├── settings.json                 # Hook configuration
│   ├── rules/
│   │   ├── behavioral.md             # Research methodology
│   │   └── security.md               # Data handling
│   └── docs/
│       └── decision-protocol.md      # When to ask vs act
```

## Key Differentiators

- **Research skill is primary** - `/research` is the most-used skill
- **Citation standards** built into behavioral rules
- **Confidence ratings** required for all findings
- **Source tracking** in dashboard
- **Heavy MCP usage** - Exa for semantic search, Firecrawl for scraping

## How to Use

```bash
cp -r examples/researcher/* your-project/
cp -r examples/researcher/.claude your-project/
```

Or cherry-pick the parts you need.
