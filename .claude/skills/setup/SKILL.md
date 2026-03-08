---
name: setup
description: Initialize your personal ALBA agent system with interactive setup
context: inline
allowed-tools: [Read, Write, Edit, Glob, Bash, AskUserQuestion]
---

# ALBA Interactive Setup

Create a personalized AI agent system through collaborative discovery. Ask, don't assume.

## Phase 1: Discovery (ask ONE question at a time)

Show progress with each question: "(1/7)", "(2/7)", etc.

**Q1 - Role (1/7):** "Let's build your ALBA agent! What's your primary role?"
Options: Software Developer, Project Manager, Designer, Content Creator, Researcher, Business/Founder, Other

**Q2 - Daily Work (2/7):** "What takes up most of your time daily?" (allow multiple)
Options: Writing/reviewing code, Managing projects, Communication, Research, Content creation, Email/calendar, Design, Other

**Q3 - Pain Points (3/7):** "What frustrates you most in your workflow?"
Options: Too many tools, Email overload, Losing track of tasks, Repetitive work, Scattered info, Losing context, Other

**Q4 - Tools (4/7):** "Which tools do you use regularly?" (allow multiple)
Options: GitHub, Trello, Notion, Gmail, Slack, Google Calendar, Linear, Obsidian, Other

**Q5 - Automation Goals (5/7):** "What would you like to automate or improve?"
Free text or: Task organization, Email categorization, Research, Content creation, Team updates, Meeting notes

**Q6 - Technical Level (6/7):** "How comfortable are you with technical setup?"
Options: Beginner (guide me), Intermediate (can edit configs), Advanced (full control)

**Q7 - Setup Scope (7/7):** "How do you want to start?"
Options: Minimal (essentials only), Standard (recommended), Full (everything)

## Phase 2: Create Structure

### 2a. Core Structure (always created)

Create directories and files from templates:

```
memory/
├── state/
│   ├── dashboard.md          # from templates/memory/dashboard.md.template
│   └── todo.md               # from templates/memory/todo.md.template
├── knowledge/
│   ├── learnings.md          # from templates/memory/learnings.md.template
│   ├── preferences.md        # from templates/memory/preferences.md.template
│   └── errors.md             # create with header: "# Error Patterns\n\nAuto-recorded error patterns and solutions.\n"
├── projects/                  # empty, ready for project contexts
└── daily/                     # empty, session logs go here

.claude/
├── docs/
│   ├── memory-system.md      # from templates/claude/memory-system.md.template
│   ├── decision-protocol.md  # from templates/claude/decision-protocol.md.template
│   └── quality-gates.md      # from templates/claude/quality-gates.md.template
└── rules/                    # rules auto-load from here
```

### 2b. Skills (scope-based)

**Always included** (core workflow):
- `/start` - already at `.claude/skills/start/SKILL.md`
- `/end` - already at `.claude/skills/end/SKILL.md`
- `/status` - already at `.claude/skills/status/SKILL.md`
- `/extend` - already at `.claude/skills/extend/SKILL.md`
- `/reflect` - already at `.claude/skills/reflect/SKILL.md`

**Standard adds:**
- `/research` - already at `.claude/skills/research/SKILL.md`
- `/weekly-review` - already at `.claude/skills/weekly-review/SKILL.md`

**Full adds:** all of the above + show what's available and let user pick more.

If user selected "Minimal" - note: "Core skills (/start, /end, /status) are ready. Use /extend anytime to add /research, /weekly-review, or custom skills."

### 2c. Hooks (scope-based)

Copy hook scripts from `templates/hooks/` to `.claude/hooks/` and make executable.

**Minimal hooks** (always):
- `bash-validator.sh` (PreToolUse → Bash) - blocks dangerous commands

**Standard hooks** (adds):
- `session-start.sh` (SessionStart) - load dashboard on start
- `memory-check.sh` (Stop) - remind to save state
- `error-logger.sh` (PostToolUse → Bash) - log error patterns

**Full hooks** (adds all):
- All Standard hooks plus:
- `agent-suggest.sh` (UserPromptSubmit) - suggest skills by keyword
- `pre-compact.sh` (PreCompact) - preserve context before compaction

**After copying, run:** `chmod +x .claude/hooks/*.sh`

### 2d. Generate settings.json

**CRITICAL: Without this file, hooks don't work.**

Create `.claude/settings.json` with hook configuration matching selected scope.

**Minimal settings.json:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "type": "command",
        "command": "bash .claude/hooks/bash-validator.sh"
      }
    ]
  }
}
```

**Standard settings.json:**
```json
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "bash .claude/hooks/session-start.sh"
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "type": "command",
        "command": "bash .claude/hooks/bash-validator.sh"
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash",
        "type": "command",
        "command": "bash .claude/hooks/error-logger.sh"
      }
    ],
    "Stop": [
      {
        "type": "command",
        "command": "bash .claude/hooks/memory-check.sh"
      }
    ]
  }
}
```

**Full settings.json:**
```json
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "bash .claude/hooks/session-start.sh"
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "type": "command",
        "command": "bash .claude/hooks/bash-validator.sh"
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash",
        "type": "command",
        "command": "bash .claude/hooks/error-logger.sh"
      }
    ],
    "Stop": [
      {
        "type": "command",
        "command": "bash .claude/hooks/memory-check.sh"
      }
    ],
    "UserPromptSubmit": [
      {
        "type": "command",
        "command": "bash .claude/hooks/agent-suggest.sh"
      }
    ],
    "PreCompact": [
      {
        "type": "command",
        "command": "bash .claude/hooks/pre-compact.sh"
      }
    ]
  }
}
```

### 2e. Rules (scope-based)

**Standard and Full:** Copy rule files from `templates/rules/` to `.claude/rules/`:
- `behavioral.md` - decision protocol, communication style
- `security.md` - input validation, secrets, safe commands

Customize behavioral.md based on Q1 (role) and Q6 (technical level).

## Phase 3: Generate CLAUDE.md

Use `templates/claude/CLAUDE.md.template` as base. Customize from answers:

- **Identity & Role** → Q1, Q2 answers
- **Tools & Integrations** → Q4 (list selected tools, note MCP availability)
- **Communication style** → Q6 (Beginner: friendly, explanatory / Advanced: concise, technical)
- **Progressive disclosure table** → always include
- **Self-improvement section** → always include
- **Skills table** → only list skills that were installed
- **Hooks table** → only list hooks that were configured
- **Active Projects** → leave as placeholder

**CLAUDE.md must stay under 200 lines.** Details go in `.claude/docs/`.

## Phase 4: Populate Initial Data

Ask and fill (one at a time):

1. "What are your top 3 priorities right now?" → fill `memory/state/dashboard.md`
2. "What tasks are on your plate this week?" → fill `memory/state/todo.md`
3. "Any preferences for how I communicate? (tone, language, format)" → fill `memory/knowledge/preferences.md`

## Phase 5: Verify & Confirm

### 5a. Verification Checklist

Run a quick check and report:

```
Setup Verification:
[x] CLAUDE.md created (XXX lines)
[x] Memory files: dashboard.md, todo.md, learnings.md, preferences.md, errors.md
[x] Skills: /start, /end, /status [+ /research, /weekly-review if Standard+]
[x] Hooks: X configured in settings.json
[x] Rules: behavioral.md, security.md
[x] settings.json valid
```

Report any issues found. If all good, proceed.

### 5b. Test

Run `/start` to test the session start workflow. Confirm it shows the priorities from Phase 4.

### 5c. Welcome

```
ALBA is ready!

Your agent system:
- X skills available (/start, /end, /status, ...)
- X hooks active (bash safety, error logging, ...)
- Memory initialized with your priorities

Next steps:
- Use /start to begin each session
- Use /end to close sessions and save progress
- Use /extend to add new features anytime
- Use /loop 30m /status for periodic reminders (Claude Code v2.1.71+)

Welcome to ALBA!
```

## Guidelines

- Ask questions ONE at a time via AskUserQuestion
- Show progress ("Step X/7") with each question
- Create files progressively, show brief confirmation after each phase
- Adapt language to technical level (Q6)
- If user seems confused → simplify and use Beginner language
- If user wants to skip a question → use sensible defaults
- If they want to skip setup entirely → offer "Quick setup: Standard scope with defaults"
- Always verify with /start at the end
- Total setup time target: under 10 minutes
