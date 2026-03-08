# Content Creator Setup Example

This is an example ALBA setup for a content creator who writes across multiple platforms (blog, newsletter, LinkedIn, X), uses AI for research and writing assistance, and wants an agent to help manage the content pipeline.

## Profile

- **Role:** Content Creator / Writer
- **Work Style:** Research-heavy, creative, multi-platform publishing
- **Tools:** Obsidian (notes), Buffer (scheduling), Substack (newsletter), Exa (research)
- **Content Focus:** AI tools and productivity for creators

## What's Included

```
content-creator/
├── CLAUDE.md                        # Agent instructions (content-creator focused)
├── README.md                        # This file
├── memory/
│   ├── state/
│   │   ├── dashboard.md             # Content calendar, metrics, ideas backlog
│   │   └── todo.md                  # Weekly task list
│   └── knowledge/
│       ├── preferences.md           # Tone guidelines, platform rules, content standards
│       ├── learnings.md             # Accumulated content insights
│       └── errors.md               # Past mistakes and how to avoid them
└── .claude/
    ├── skills/
    │   └── research/
    │       └── SKILL.md             # Research skill for content (trends, sources, data)
    ├── rules/
    │   ├── behavioral.md            # Decision rules + content quality standards
    │   └── security.md              # Safety rules + content security
    └── docs/
        ├── memory-system.md         # How memory works
        └── decision-protocol.md     # When to act vs ask
```

## Key Features

### 1. Content-Focused CLAUDE.md
- Executive assistant role for content creation
- Research and writing support (not ghostwriting)
- Content calendar awareness
- Multi-platform tone management
- All 6 hooks listed for full lifecycle support

### 2. Content Calendar Dashboard
- `dashboard.md` serves as a living content calendar
- Tracks posts across platforms with status
- Performance metrics snapshot
- Ideas backlog with priority levels
- Active projects overview

### 3. Research Skill (Content-Optimized)
- Customized for content research workflows
- Search strategies for different content types (blog, newsletter, thread)
- Trend analysis and competitor content analysis
- Source finding with statistics and data points
- Outputs include suggested content angles, not just raw data

### 4. Platform-Specific Preferences
- `preferences.md` defines tone for each platform (LinkedIn, X, Blog, Newsletter)
- Content structure templates per format
- Research depth guidelines per content type
- Hard rules: no clickbait, no unsourced claims, always cite

### 5. Content Quality Rules
- Source attribution requirements in `behavioral.md`
- Originality checks
- Platform appropriateness validation

## How to Use This Example

### Option 1: Copy to Your Setup
```bash
# After running /setup, copy specific files you want
cp -r examples/content-creator/.claude/skills/research/ .claude/skills/research/
cp examples/content-creator/memory/state/dashboard.md memory/state/
cp examples/content-creator/memory/knowledge/preferences.md memory/knowledge/
```

### Option 2: Reference During Setup
When running `/setup`, mention you want a "content creator setup" and Claude will create something similar.

### Option 3: Learn the Pattern
Read through the files to understand how a content workflow maps to ALBA's structure:
- **Dashboard** = Content calendar + metrics + ideas
- **Preferences** = Platform tone guides + content rules
- **Research skill** = Customized for content research, not general web research

## Customization Ideas

- **Different niche:** Change the example topics and audience in preferences.md
- **More platforms:** Add YouTube, TikTok, or podcast sections to dashboard and preferences
- **Team workflow:** Add review/approval steps in behavioral.md
- **SEO focus:** Add SEO checklist to rules, keyword research to the research skill
- **Client work:** Add project folders per client in memory/projects/

## Optional Tools (MCP)

| Tool | What It Adds |
|------|-------------|
| **Exa** | Semantic search - find relevant articles by meaning, not just keywords |
| **Firecrawl** | Full-page scraping - get complete article content for analysis |
| **Trello** | Visual content calendar with Kanban board |
| **Gmail** | Newsletter subscriber outreach, sponsor communication |

Without MCP servers, the agent still works using built-in WebSearch and WebFetch.

---

This example is based on a realistic content creation workflow, designed to show how ALBA adapts to non-technical use cases.
