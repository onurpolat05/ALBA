---
name: setup
description: One-time bootstrap of a personal ALBA agent system - asks 7 discovery questions, then generates CLAUDE.md, the memory tree, skills, hooks, rules and .claude/settings.json. Use when the user explicitly types /setup, has just cloned ALBA, and has no CLAUDE.md yet. Do NOT use to add a single skill, hook or rule to a working setup (use /extend), and never run it against an already-configured system - it rewrites CLAUDE.md, settings.json and the memory files.
context: inline
effort: medium
disable-model-invocation: true
allowed-tools: [Read, Write, Edit, Glob, Bash, AskUserQuestion]
---

# ALBA Interactive Setup

Create a personalized AI agent system through collaborative discovery. Ask, don't assume.

> **Why `disable-model-invocation: true`:** this skill overwrites `CLAUDE.md`, `.claude/settings.json`
> and the whole `memory/` tree. Nothing here should ever fire because a prompt sounded vaguely like
> "help me get set up". The flag restricts it to an explicit `/setup` from the user, and it also
> keeps the skill out of scheduled-task triggers and out of subagent preloading — both places where
> an accidental run would be invisible until the damage was done.

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
│   ├── memory-system.md        # from templates/claude/memory-system.md.template
│   ├── decision-protocol.md    # from templates/claude/decision-protocol.md.template
│   ├── quality-gates.md        # from templates/claude/quality-gates.md.template
│   ├── memory-compatibility.md # from templates/claude/memory-compatibility.md.template
│   └── loop-integration.md     # from templates/claude/loop-integration.md.template
├── agents/
│   └── planner.md              # from templates/agents/planner.md
└── rules/                      # rules auto-load from here (see 2e)
```

One doc per `*.md.template` in `templates/claude/` (excluding `CLAUDE.md.template`, which is
handled in Phase 3). Generate every one of them, and never list a doc in CLAUDE.md that has no
template behind it — `/end` links to `memory-compatibility.md`, so a setup that skips it leaves a
dead link in a skill the user runs daily. The same applies to `planner.md`: the "Plans (Planner
Agent)" section of `quality-gates.md` assumes that agent exists.

**Naming:** files under `templates/claude/` and `templates/memory/` carry a `.template` suffix that
gets dropped on copy. Files under `templates/agents/` and `templates/rules/` do not — copy those
as-is, no rename.

### 2b. Skills (scope-based)

All nine skills already ship in `.claude/skills/`. Scope decides which ones get listed in the
generated CLAUDE.md Skills table — the rest stay on disk and can be surfaced later with `/extend`.

**Minimal** (core loop): `/start`, `/end`, `/status`, `/extend`

**Standard adds:** `/research`, `/reflect`, `/weekly-review`, `/create-skill`

**Full adds:** everything above, plus walk the user through the remaining skills and any
custom ones they describe.

`/setup` itself is always present but is not listed as a day-to-day skill — it is a one-time
bootstrap.

If user selected "Minimal" - note: "Core skills (/start, /end, /status, /extend) are ready. Use /extend anytime to add /research, /reflect, /weekly-review, or custom skills."

### 2c. Hooks (scope-based)

Copy hook scripts from `templates/hooks/` to `.claude/hooks/`, dropping the `.template` suffix
(`bash-validator.sh.template` → `bash-validator.sh`), then make them executable.

**Minimal hooks** (always):
- `bash-validator.sh` (PreToolUse → Bash) - blocks dangerous commands

**Standard hooks** (adds):
- `session-start.sh` (SessionStart) - load dashboard on start
- `memory-check.sh` (Stop) - remind to save state
- `error-logger.sh` (PostToolUse → Bash + PostToolUseFailure) - log error patterns from any tool
- `pre-compact.sh` (PreCompact) - preserve context before compaction
- `session-end.sh` (SessionEnd) - leave a dated trace in today's log even when `/end` is skipped

**Full hooks** (Standard plus):
- `agent-suggest.sh` (UserPromptSubmit) - suggest skills by keyword
- `post-compact.sh` (PostCompact) - remind to re-load context after compaction

**After copying, run:** `chmod +x .claude/hooks/*.sh`

### 2d. Generate settings.json

**CRITICAL: Without this file, hooks don't work.**

**Copy `templates/settings.json.template` to `.claude/settings.json`, then delete the hook entries
that are not in the chosen scope.** Do not retype it from memory and do not compose it by hand.
That template is the canonical wiring: it carries the `permissions` blocks, the env scrub, the
`bash` command prefix and the `${CLAUDE_PROJECT_DIR}` paths, and it is the file `tools/doctor.sh`
checks against. A second hand-written copy is how the `Write(.env)` rule stayed dead through two
releases while the template had already been fixed.

Which `hooks` keys to keep:

| Scope | Keep these events |
|-------|-------------------|
| Minimal | `PreToolUse` |
| Standard | `PreToolUse`, `SessionStart`, `PostToolUse`, `PostToolUseFailure`, `Stop`, `SessionEnd`, `PreCompact` |
| Full | all of them - copy the template unchanged |

Leave `permissions` and `env` exactly as they are in the template, at every scope. If the user
named tools or paths during discovery that deserve an allow rule, add them to `permissions.allow`
rather than editing what is already there.

**Three shape rules that silently break hooks if you get them wrong:**
- Each event maps to an array of `{matcher?, hooks: [...]}` objects. The **inner** `hooks` array is
  mandatory. A flat `{"command": "..."}` parses fine and never runs.
- Use `${CLAUDE_PROJECT_DIR}` in the command path. A relative path resolves against the session's
  working directory, so the hook disappears the moment someone opens Claude Code in a subfolder.
- Keep the `bash ` prefix on the command. Without it the script has to carry its executable bit,
  which does not survive every clone - and on Windows Git Bash there is no executable bit at all.

**File permission rules use `Edit(path)`, never `Write(path)`.** Claude Code accepts a
`Write(path)` rule, prints a warning about it at startup, and then ignores it - so a
`deny: Write(.env)` looks like protection and provides none. `Edit(path)` covers every
file-editing tool, including Write.

After writing the file, verify it: `python3 -c "import json; json.load(open('.claude/settings.json'))"`
and confirm every `command` path points at a script that exists.

### 2e. Rules (scope-based)

**Standard and Full:** Copy rule files from `templates/rules/` to `.claude/rules/` (no rename — these
have no `.template` suffix):
- `behavioral.md` - decision protocol, communication style
- `security.md` - input validation, secrets, safe commands
- `verification.md` - post-change verification reporting

Customize behavioral.md based on Q1 (role) and Q6 (technical level).

## Phase 3: Generate CLAUDE.md

Use `templates/claude/CLAUDE.md.template` as base. **Fill in its sections; do not add sections it
does not have.** The template is the canonical shape, and what it leaves out, it leaves out on
purpose.

Customize from answers:

- **Identity & Role** → Q1, Q2 answers
- **Communication style** → Q6 (Beginner: friendly, explanatory / Advanced: concise, technical)
- **Hooks table** → list the hooks you actually configured in 2c
- **Active Projects** → leave as placeholder, with the one-line-per-project rule intact

Do **not** add a skills table, an agents table, or a tools/MCP table. Skills, agents and MCP tools
are discovered by the harness — their names and descriptions are already in the system prompt
before CLAUDE.md is read. Listing them again costs context on every turn and goes stale the first
time the user runs `/extend`. Hooks are the exception, and the reason the template keeps that one
table: hooks are *not* discoverable, so CLAUDE.md is their only inventory.

Do not add a self-improvement or memory-rules section either. That content lives in
`.claude/rules/behavioral.md`, which is auto-loaded on every turn — restating it in CLAUDE.md
creates two authorities that drift apart.

**CLAUDE.md must stay under 200 lines**, and the template lands around 85. Details go in
`.claude/docs/`; anything you are tempted to append is usually a sign it belongs there instead.

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
[x] Rules: behavioral.md, security.md, verification.md
[x] Agents: planner.md
[x] settings.json valid
```

Do not tick a box from memory of having written the file — check it. Hooks fail silently, so
"I created settings.json" and "the hooks will run" are different claims. At minimum, confirm the
JSON parses and that every wired `command` points at a script that is actually on disk:

```bash
python3 -c "import json; d=json.load(open('.claude/settings.json')); print(len(d['hooks']), 'events')"
ls .claude/hooks/
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
- Use /loop 30m /status for periodic reminders

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
