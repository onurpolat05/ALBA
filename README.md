<p align="center">
  <img src="assets/banner.png" alt="ALBA - Your routine-driven AI companion" width="100%">
</p>

<p align="center">
  <a href="README.md">English</a> | <a href="README.tr.md">Türkçe</a> | <a href="README.de.md">Deutsch</a>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
  <a href="https://docs.claude.com/en/docs/claude-code"><img src="https://img.shields.io/badge/Claude%20Code-v2.1.218+-purple.svg" alt="Claude Code minimum"></a>
  <a href="https://github.com/anthropics/claude-code/releases"><img src="https://img.shields.io/badge/Tested-v2.1.220-green.svg" alt="Tested with v2.1.220"></a>
  <a href="https://github.com/onurpolat05/ALBA/stargazers"><img src="https://img.shields.io/github/stars/onurpolat05/ALBA?style=social" alt="Stars"></a>
</p>

---

ALBA transforms Claude Code into a **personal AI agent** that remembers your priorities, learns from your mistakes, and adapts to your workflow — whether you're a developer, PM, researcher, founder, or content creator.

**10-minute interactive setup. No package manager, no build step, nothing to keep running — bash scripts and markdown files.**

<p align="center">
  <img src="assets/demo.gif" alt="ALBA /setup demo" width="100%">
</p>

## The Problem

Every new Claude Code session starts from zero. No memory of yesterday's priorities. No context about your projects. Same mistakes repeated. You re-explain your workflow every time.

## The Solution

```
you@machine:~/alba$ claude
> /setup
```

Answer 7 questions. ALBA builds a personalized agent system with persistent memory, automated workflows, and self-improving behavior — tailored to your role.

## What You Get

```
your-agent/
├── CLAUDE.md                     # Agent brain (< 200 lines)
├── memory/
│   ├── state/                    # Priorities, tasks (updated every session)
│   ├── knowledge/                # Learnings, errors, preferences (auto-updated)
│   ├── projects/                 # Per-project context
│   └── daily/                    # Session logs (auto-created)
├── .claude/
│   ├── skills/                   # 9 built-in skills
│   ├── hooks/                    # 8 automated event handlers
│   ├── agents/                   # Subagent definitions
│   ├── rules/                    # Behavioral guidelines (auto-loaded)
│   ├── docs/                     # Reference docs (lazy-loaded)
│   └── settings.json             # Hook wiring + permissions
```

## Core Features

### Persistent Memory
Three-tier file-based memory that survives across sessions. Git-tracked, human-readable, zero dependencies.

```
/start              → loads your priorities from last session
  ... work ...
/end                → saves progress, records learnings
  ... next day ...
/start              → picks up exactly where you left off
```

### 9 Built-in Skills

| Skill | Purpose |
|-------|---------|
| `/start` | Begin session — load context, show priorities |
| `/end` | End session — save state, create daily log |
| `/status` | Quick overview — tasks, blockers, last session |
| `/research` | Web research with structured output (runs as subagent) |
| `/weekly-review` | Weekly performance review and next-week planning |
| `/extend` | Add new skills, hooks, or rules anytime |
| `/reflect` | Cross-session pattern analysis |
| `/create-skill` | Guided skill creation wizard |
| `/setup` | Interactive first-time setup |

### 8 Automated Hooks

| Claude Code event | Script | What happens |
|---|---|---|
| `SessionStart` | `session-start.sh` | Dashboard loads, priorities shown |
| `UserPromptSubmit` | `agent-suggest.sh` | Relevant skill suggested for what you just typed |
| `PreToolUse` | `bash-validator.sh` | Destructive command denied before it runs |
| `PostToolUse` | `error-logger.sh` | Bash failures logged for pattern detection |
| `PostToolUseFailure` | `error-logger.sh` | Edit/Write/MCP failures logged too |
| `Stop` | `memory-check.sh` | Reminder to save state — rate-limited, not every turn |
| `SessionEnd` | `session-end.sh` | Factual trace in today's log even if you skip `/end` |
| `PreCompact` / `PostCompact` | `pre-compact.sh`, `post-compact.sh` | Priorities survive context compaction |

Nine registrations, eight scripts — `error-logger.sh` is wired to both tool-failure events.

**On the validator:** it denies a short list of genuinely destructive commands and stays silent on everything else. Silent means *silent* — no output, exit 0, normal permission flow. A `PreToolUse` hook that answers `"allow"` skips your permission prompt entirely, so a validator that approves whatever its blocklist missed is not a safety net, it is a hole. ALBA shipped that hole until v2.0.0.

### Self-Improvement

ALBA learns from your work:
- **Errors** auto-recorded with solutions (never repeat the same mistake)
- **Learnings** captured as reusable patterns
- **Preferences** updated when you correct the agent
- **`/reflect`** analyzes patterns across sessions and suggests new rules

### Progressive Disclosure

CLAUDE.md stays under 200 lines. System docs lazy-load only when needed — keeping your context window efficient.

---

## Quick Start

### Option 1: GitHub Template (Recommended)

Click **"Use this template"** on GitHub, then:

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git my-agent
cd my-agent
claude
```

### Option 2: Direct Clone

```bash
git clone https://github.com/onurpolat05/ALBA.git my-agent
cd my-agent
rm -rf .git && git init
claude
```

### Then:

```
/setup
```

Answer 7 questions (~10 minutes). Your personalized agent is ready.

**Accept the trust dialog the first time you open the folder.** Until you do, Claude Code ignores the `permissions.allow` list in `settings.json` — hooks still run, but you get prompted for reads and commands that should have been silent, which reads like a broken setup rather than an untrusted one.

---

## Daily Workflow

```
Morning:
  /start                    # "Your priorities: 1. API deadline Friday  2. Review PR #42"

During work:
  "research multi-agent patterns"    # /research runs as subagent
  "what's my status?"                # /status shows quick overview

End of day:
  /end                      # Saves progress, records learnings, creates daily log

Friday:
  /weekly-review            # Analyzes the week, plans next week

Anytime:
  /extend                   # "I want a content creation skill" → builds it
  /loop 30m /status         # Periodic reminders, session-scoped
```

---

## How It Compares

| Feature | Raw Claude Code | Other Starters | ALBA |
|---------|----------------|----------------|------|
| Memory across sessions | None | Some (memory only) | 3-tier (state/knowledge/projects) |
| Setup experience | Manual config | Copy-paste | Interactive wizard (7 questions) |
| Role support | Generic | Developer-only | Any role (5 examples included) |
| Self-improvement | No | No | Auto error + learning capture |
| Hooks | Manual setup | Some templates | 8 hooks, auto-configured |
| Skills | None built-in | Varies | 9 built-in, extensible |
| Context efficiency | N/A | N/A | Progressive disclosure (< 200 lines) |
| Config health check | `/doctor` (your install) | No | `tools/doctor.sh` (the config itself) |

---

## Examples

See `examples/` for complete, working setups:

| Role | Focus |
|------|-------|
| **[Developer](examples/developer/)** | Code projects, git workflows, research |
| **[Project Manager](examples/project-manager/)** | Sprint management, stakeholder updates, team coordination |
| **[Content Creator](examples/content-creator/)** | Content calendar, research, multi-platform publishing |
| **[Researcher](examples/researcher/)** | Literature review, source management, citation tracking |
| **[Founder](examples/founder/)** | Multi-client management, revenue tracking, personal brand |

Each example includes pre-filled dashboards, sample daily logs, and working hook configurations.

---

## Architecture

### Skills

Skills are markdown files with YAML frontmatter. The `description` is not decoration — it is the only thing Claude reads when deciding whether to invoke a skill, so ALBA's descriptions state both when to fire and when not to:

```yaml
---
name: research
description: Structured web research with cited sources. Use when user says
  "research X", "look into X". Do NOT use for single-fact lookups.
context: fork              # runs in a subagent, main context stays clean
agent: general-purpose     # which subagent type the fork uses
background: false          # wait for the result in this turn (see below)
effort: medium
argument-hint: <topic> [deep]
allowed-tools: [Read, Write, Glob, Grep, WebSearch, WebFetch]
---
```

`context: fork` = heavy tasks run as subagents. `context: inline` = quick tasks in the main conversation.

**The `background` trap.** Since Claude Code v2.1.218, `context: fork` defaults to `background: true` — the subagent runs detached and its result does not come back in the turn that invoked it. Any fork skill written before that version changed behaviour without changing a single line. ALBA's `/research` and `/reflect` set `background: false` explicitly, because you asked a question and expect the answer now. This is also why ALBA's minimum is v2.1.218.

Full frontmatter reference: [`templates/skills/SKILL-TEMPLATE.md`](templates/skills/SKILL-TEMPLATE.md).

### Memory System

```
HOT  (every session)  →  memory/state/dashboard.md, todo.md
WARM (when learned)   →  memory/knowledge/learnings.md, errors.md, preferences.md
COLD (per-project)    →  memory/projects/[name]/context.md
LOGS (auto-created)   →  memory/daily/YYYY-MM-DD.md
```

### Hook System

Hooks are bash scripts triggered by Claude Code events, wired in `.claude/settings.json`. They run automatically — no manual invocation needed. Claude Code exposes 30 hook events; ALBA uses nine and documents all of them in [`templates/hooks/README-hooks.md`](templates/hooks/README-hooks.md).

Hooks fail quietly. A misspelled event name, a missing inner `hooks` array, a relative path that breaks when you open a session in a subdirectory — none of these produce an error. The feature just never happens. That is what `tools/doctor.sh` is for.

### Subagents

`.claude/agents/` holds subagent definitions — named roles Claude can delegate to. ALBA ships one, `planner.md`, and keeps it deliberately thin. Frontmatter fields that claim to restrict an agent's tools could not be shown to actually enforce anything, so the constraint is written as instruction rather than dressed up as configuration. If you need a hard limit, put it in `permissions.deny`: deny rules are evaluated regardless of what an agent or hook asks for.

### Single Source of Truth

`templates/` is the only place you edit. The `.claude/` tree inside each example role is generated from it:

```bash
tools/sync-examples.sh          # regenerate examples/ from templates/
tools/sync-examples.sh --check  # report drift without changing anything
tools/doctor.sh                 # full health check, run before committing
```

Role-specific files — `CLAUDE.md`, `README.md`, `memory/` — are never overwritten; those are what an example is actually for. Before v2.0.0 every hook script lived in six places at once, and the example docs had drifted a full release behind their templates.

### Compatibility

- **Claude Code auto-memory**: coexists without conflict ([details](.claude/docs/memory-compatibility.md))
- **`/loop` scheduling**: session-scoped periodic tasks ([details](.claude/docs/loop-integration.md))
- **MCP servers**: optional (Trello, Gmail, Calendar, Exa, Firecrawl) — ALBA works standalone

---

## Extending ALBA

After setup, add features anytime:

```
/extend
```

Or just ask naturally:
- "I want a skill for drafting emails"
- "Add a hook that auto-commits on session end"
- "Create a rule for code review standards"
- "Connect my Trello board"

---

## Requirements

- **Claude Code v2.1.218 or later.** Verified against v2.1.220. [Install](https://docs.claude.com/en/docs/claude-code). The floor is not arbitrary: `background` on forked skills landed in v2.1.218, and without it `/research` and `/reflect` return their answers to a background task instead of to you.
- **Git**
- **jq** — used by the hooks to parse event JSON. Every hook degrades to a grep fallback without it, but installing jq is one command.

MCP servers are optional enhancements — ALBA works fully standalone.

Upgrading Claude Code? Run `tools/doctor.sh`. It checks the things that break silently across versions: hook event names, settings schema, dead script paths.

---

## Windows Setup

ALBA's hooks are bash scripts. Claude Code runs natively on Windows (no WSL required) and routes bash commands through Git Bash automatically — but you need a couple of prerequisites:

```powershell
# 1. Install Git for Windows (provides Git Bash)
winget install --id Git.Git -e

# 2. Install jq (used by hooks for JSON parsing)
winget install --id jqlang.jq -e

# 3. Install Claude Code
irm https://claude.ai/install.ps1 | iex
```

Then clone ALBA and run `claude` from the repo root — Git Bash handles the rest.

**Why this works:** ALBA's `.gitattributes` forces `*.sh` files to LF line endings, preventing the `bad interpreter: bash\r` error that breaks bash scripts under Windows' default CRLF setting.

**Alternative:** WSL2 also works (same install steps inside the Linux distro). Use WSL2 if you prefer a full Linux toolchain.

**Troubleshooting:** if hooks fail with `command not found: jq`, install jq with the command above. If you see `bad interpreter`, your clone predates `.gitattributes` — re-clone the repo.

---

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md).

**Most valuable contributions:**
- Example setups for new roles
- Custom skill templates
- Hook recipes
- Integration guides

Edit `templates/`, never `examples/` — then run `tools/sync-examples.sh` and `tools/doctor.sh` before opening a PR.

---

## License

MIT License — see [LICENSE](LICENSE)

---

## Community

- [GitHub Issues](https://github.com/onurpolat05/alba/issues) — Bug reports & feature requests
- [GitHub Discussions](https://github.com/onurpolat05/alba/discussions) — Questions & ideas

---

*ALBA — Consistent. Independent. Always learning.*

> Named after Abla the cat. *Alba* means "dawn" in Latin — a new beginning for your AI workflow.

## Star History

<a href="https://star-history.com/#onurpolat05/ALBA&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=onurpolat05/ALBA&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=onurpolat05/ALBA&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=onurpolat05/ALBA&type=Date" />
 </picture>
</a>
