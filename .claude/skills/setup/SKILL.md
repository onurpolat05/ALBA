---
name: setup
description: Initialize your personal ALBA agent system with interactive setup
context: inline
allowed-tools: Read, Write, Edit, Glob, AskUserQuestion
---

# ALBA Interactive Setup

Create a personalized AI agent system through collaborative discovery. Ask, don't assume.

## Phase 1: Discovery (ask ONE question at a time)

**Q1 - Role:** "Let's build your ALBA agent! What's your primary role?"
Options: Software Developer, Project Manager, Designer, Content Creator, Business/Operations, Other

**Q2 - Daily Work:** "What takes up most of your time daily?" (allow multiple)
Options: Writing/reviewing code, Managing projects, Communication, Research, Content creation, Email/calendar, Design, Other

**Q3 - Pain Points:** "What frustrates you most in your workflow?"
Options: Too many tools, Email overload, Losing track of tasks, Repetitive work, Scattered info, Losing context, Other

**Q4 - Tools:** "Which tools do you use regularly?" (allow multiple)
Options: GitHub, Trello, Notion, Gmail, Slack, Google Calendar, Linear, Obsidian, Other

**Q5 - Automation Goals:** "What would you like to automate or improve?"
Free text or: Task organization, Email categorization, Research, Content creation, Team updates, Meeting notes

**Q6 - Technical Level:** "How comfortable are you with technical setup?"
Options: Beginner (guide me), Intermediate (can edit configs), Advanced (comfortable with complex setups)

**Q7 - Setup Scope:** "How do you want to start?"
Options: Minimal (essentials only), Standard (common features), Custom (I'll pick exactly)

## Phase 2: Create Structure

**Always create (use templates from `templates/`):**

```
memory/
├── state/
│   ├── dashboard.md          # from templates/memory/dashboard.md.template
│   └── todo.md               # from templates/memory/todo.md.template
├── knowledge/
│   ├── learnings.md          # from templates/memory/learnings.md.template
│   ├── preferences.md        # from templates/memory/preferences.md.template
│   └── errors.md             # (create empty with header)
├── projects/
└── daily/

.claude/
├── docs/
│   ├── memory-system.md      # from templates/claude/memory-system.md.template
│   └── decision-protocol.md  # from templates/claude/decision-protocol.md.template
├── skills/                   # Skills go here
├── rules/                    # Rules auto-load from here
└── hooks/                    # Hook scripts here
```

**Scope-based additions:**
- **Minimal:** Core structure only. Point to /extend for later.
- **Standard:** + research skill + session hooks + behavioral rules (based on role)
- **Custom:** Show all available features from `templates/skills/`, `templates/hooks/`, `templates/rules/` and let user pick.

## Phase 3: Generate CLAUDE.md

Use `templates/claude/CLAUDE.md.template` as base. Customize from answers:

- Identity & Role → Q1, Q2
- Tools & Integrations → Q4
- Communication style → Q6 (Beginner: simple language / Advanced: concise)
- Progressive disclosure table → always include
- Self-improvement section → always include
- Skills table → based on selected features
- Hooks table → based on selected features

**Keep CLAUDE.md under 200 lines.** Details go in `.claude/docs/`.

## Phase 4: Populate Initial Data

Ask and fill:
1. "What are your top 3 priorities right now?" → `memory/state/dashboard.md`
2. "What tasks are on your plate this week?" → `memory/state/todo.md`
3. "Any preferences for how I communicate?" → `memory/knowledge/preferences.md`

## Phase 5: Test & Confirm

1. Show summary of what was created
2. Run `/start` to test
3. Ask: "Does this look good? Any adjustments?"
4. Congratulate: "Welcome to ALBA! Use /extend anytime to add features."

## Guidelines

- Ask questions ONE at a time via AskUserQuestion
- Create files progressively, show what you created after each step
- Adapt language to technical level
- If user seems confused → simplify
- If they want to skip → mark as "add later with /extend"
- Always test with /start at the end
