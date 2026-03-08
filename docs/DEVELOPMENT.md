# ALBA - Development Guide

## Project Identity

This is **ALBA** (formerly opAgent Starter) - an open-source personal AI agent starter kit for Claude Code.

**Mascot:** Abla the cat. Cat metaphor drives design decisions.
**Tagline:** "Your routine-driven AI companion"
**License:** MIT
**Repo:** github.com/onurpolat05/alba

---

## What ALBA Is

A GitHub Template Repository that users clone and personalize via `/setup`. It creates a full personal agent system with:
- Memory system (state/knowledge/projects/daily)
- Skills 2.0 (frontmatter, context:fork, $ARGUMENTS)
- Hooks (6 patterns: SessionStart, Stop, PreToolUse, PostToolUse, UserPromptSubmit, PreCompact)
- Rules (.claude/rules/)
- Agent templates (researcher, planner)
- Progressive disclosure (lazy-load, not preload)
- Self-improvement (auto errors.md + learnings.md)

**Key principle:** Standalone first, MCP optional. Zero dependencies.

---

## Current Status: v1.0 Development ("First Light")

Full PRD: `docs/PRD.md`

### v1.0 Task List

**P0 - Completed:**
- [x] Rename opagent-starter -> alba (all references)
- [x] New README.md with ALBA branding
- [x] Update CLAUDE.md template (progressive disclosure, skills 2.0, hooks, rules)
- [x] Add hooks system (6 hook templates)
- [x] Add rules system (behavioral + security)
- [x] GitHub Template Repository setup (.gitignore, INDEX.md)
- [x] Migrate setup/ to skills (setup + extend are now `.claude/skills/`)
- [x] Move dev CLAUDE.md to docs/DEVELOPMENT.md, create user-facing CLAUDE.md

**P1 - In Progress:**
- [x] Update memory system templates (add dashboard)
- [x] Add /reflect skill (cross-session pattern analysis)
- [x] Add 3 example setups (developer, PM, content creator)
- [x] Add agent templates (researcher, planner)
- [x] Update CONTRIBUTING.md for ALBA

**P2 - Nice to have:**
- [ ] Skill creator meta-skill
- [ ] Quality gates (confidence scoring)

---

## Architecture

```
alba/                              # What users clone (Approach B: Generator)
├── CLAUDE.md                      # Minimal: "Run /setup" pointer
├── README.md                      # Project README
├── LICENSE                        # MIT
├── CONTRIBUTING.md                # How to contribute
├── .gitignore                     # Ignore user-generated content
├── docs/
│   ├── PRD.md                     # Product requirements
│   └── DEVELOPMENT.md             # THIS FILE (dev guide)
├── .claude/
│   └── skills/
│       ├── setup/SKILL.md         # /setup - Interactive setup
│       └── extend/SKILL.md        # /extend - Feature addition
├── templates/
│   ├── INDEX.md                   # Template reference
│   ├── claude/                    # CLAUDE.md + docs templates
│   ├── memory/                    # Memory file templates
│   ├── skills/                    # Skill templates + examples
│   ├── hooks/                     # Hook script templates
│   ├── rules/                     # Rule file templates
│   └── agents/                    # Agent definition templates (P1)
└── examples/
    ├── developer/                 # Developer setup (P1: rename from software-engineer)
    ├── project-manager/           # PM setup (P1)
    └── content-creator/           # Creator setup (P1)
```

**After /setup runs, user gets:**
```
user-workspace/
├── CLAUDE.md                      # Personalized agent brain
├── memory/
│   ├── state/dashboard.md, todo.md
│   ├── knowledge/learnings.md, errors.md, preferences.md
│   ├── projects/
│   └── daily/
├── .claude/
│   ├── skills/setup/, extend/, [custom]/
│   ├── hooks/*.sh
│   ├── rules/behavioral.md, security.md
│   └── docs/memory-system.md, decision-protocol.md
└── templates/                     # Kept as reference
```

---

## Development Rules

- **English-first** for all content (README, templates, docs)
- **No personal data** in templates - only [placeholders]
- **MCP-agnostic** - never hardcode a specific MCP provider
- **Standalone first** - everything should work without MCP servers
- **Keep templates concise** - CLAUDE.md template < 200 lines
- **Test setup flow** - /setup must work end-to-end after changes
- **Cat metaphor** - use it in branding, not in code/templates (keep professional)

---

## Key References

| What | Where |
|------|-------|
| Full PRD | `docs/PRD.md` |
| Current templates | `templates/INDEX.md` |
| Setup flow | `.claude/skills/setup/SKILL.md` |
| Extend system | `.claude/skills/extend/SKILL.md` |
| Developer example | `examples/developer/` |
| Contribution guide | `CONTRIBUTING.md` |

---

## Decisions Log

| Decision | Choice | Date |
|----------|--------|------|
| Repo name | `alba` | 2026-03-07 |
| Distribution | GitHub Template Repository | 2026-03-07 |
| Language | English-first | 2026-03-07 |
| MCP | Standalone, MCP optional | 2026-03-07 |
| License | MIT (full open source) | 2026-03-07 |
| Branding | Cat mascot (Abla), alba = dawn | 2026-03-07 |
| Setup architecture | Approach B: Generator (/setup creates structure) | 2026-03-08 |
| Setup/extend location | .claude/skills/ (not setup/ or .claude/commands/) | 2026-03-08 |

---

*This file is for ALBA development. The user-facing CLAUDE.md is the minimal pointer at repo root.*
