# ALBA

**Your routine-driven AI companion** | Built on Claude Code

ALBA transforms Claude Code from a developer tool into a **personal AI agent** that adapts to any role - developer, PM, designer, content creator, founder, or anyone who wants an organized, self-improving AI workflow.

> Named after Abla the cat. *Alba* means "dawn" in Latin - a new beginning for your AI workflow.

---

## What ALBA Does

- Interactive setup that builds a personalized agent in ~10 minutes
- Persistent memory system that learns and grows across sessions
- Extensible skills, hooks, and rules architecture
- Self-improvement: automatically learns from errors and records insights
- Works for any profession, not just developers

## What Makes ALBA Different

| Feature | Generic AI | Other CC Tools | ALBA |
|---------|-----------|----------------|------|
| Memory across sessions | No | Some (memory only) | Full system (state/knowledge/projects) |
| Role support | Generic | Developer-only | Any role |
| Setup experience | None | Copy-paste config | Interactive, collaborative |
| Self-improvement | No | No | Auto error+learning capture |
| Extensibility | No | Limited | Skills + Hooks + Rules + Agents |

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
git clone https://github.com/onurpolat05/alba.git my-agent
cd my-agent
rm -rf .git && git init
claude
```

### Then Run Setup

```
/setup
```

Answer 7 questions about your role, tools, and preferences. ALBA builds your personalized agent system.

---

## Architecture

After `/setup`, your workspace looks like:

```
your-agent/
├── CLAUDE.md                     # Agent brain (< 200 lines, progressive disclosure)
├── memory/
│   ├── state/                    # Hot: dashboard, tasks (updated every session)
│   ├── knowledge/                # Warm: learnings, errors, preferences
│   ├── projects/                 # Cold: per-project context
│   └── daily/                    # Logs: auto-created session summaries
├── .claude/
│   ├── skills/                   # Custom capabilities
│   │   ├── setup/SKILL.md        # /setup - interactive setup
│   │   ├── extend/SKILL.md       # /extend - add features
│   │   └── research/SKILL.md     # /research - web research
│   ├── hooks/                    # Event automation (6 hooks)
│   ├── rules/                    # Behavioral rules (auto-loaded)
│   └── docs/                     # System docs (lazy-loaded)
└── templates/                    # Reference templates
```

### Core Systems

**Memory** - Three-tier file-based memory. Human-readable markdown, git-trackable, zero dependencies.

**Skills 2.0** - Capabilities with frontmatter (`context: fork`, `allowed-tools`). Run as slash commands.

**Hooks** - 6 automated event responses: session start/stop, bash safety, error logging, agent suggestions, context preservation.

**Rules** - Behavioral guidelines that auto-load from `.claude/rules/`. Decision protocol + security defaults included.

**Progressive Disclosure** - CLAUDE.md stays under 200 lines. Details lazy-load from `.claude/docs/` when needed.

---

## Perfect For

| Role | What You Get |
|------|--------------|
| **Developers** | Research skills, task tracking, git workflows, code organization |
| **Project Managers** | Task management, email triage, team updates, meeting prep |
| **Content Creators** | Research automation, content planning, multi-platform publishing |
| **Founders** | Executive assistant, prioritization, delegation, investor prep |
| **Anyone** | Customized to your specific workflow and tools |

---

## Skills & Commands

| Command | Description |
|---------|-------------|
| `/setup` | Interactive first-time setup |
| `/start` | Begin session, load context |
| `/end` | End session, save state |
| `/status` | Quick overview |
| `/extend` | Add new features |
| `/reflect` | Cross-session pattern analysis |
| `/research` | Web research with structured output |

---

## Hooks

| Hook | Event | Purpose |
|------|-------|---------|
| `session-start.sh` | SessionStart | Load dashboard, show priorities |
| `memory-check.sh` | Stop | Remind to save state |
| `bash-validator.sh` | PreToolUse | Block dangerous commands |
| `error-logger.sh` | PostToolUse | Auto-log errors |
| `agent-suggest.sh` | UserPromptSubmit | Suggest agents by keyword |
| `pre-compact.sh` | PreCompact | Preserve context before compaction |

---

## Examples

See `examples/` for complete setups:

- **developer/** - Software engineer with research, task management, and git workflows
- **project-manager/** - PM with task tracking, email triage, and team coordination
- **content-creator/** - Writer with content calendar, research, and multi-platform publishing

---

## Extending ALBA

After setup, add features anytime:

```
/extend
```

Or just ask:
- "I want to add a content creation skill"
- "Create a hook to auto-commit on session end"
- "Add a rule for code review standards"
- "Connect my Trello board"

ALBA guides you through it step by step.

---

## Requirements

- **Claude Code CLI** v2.1.50+ ([Install](https://docs.anthropic.com/en/docs/claude-code))
- **Git**

MCP servers (Trello, Gmail, Calendar, etc.) are optional enhancements - ALBA works standalone.

---

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

**Most valuable contributions:**
- Example setups for different roles
- Custom skill templates
- Hook recipes
- Integration guides

---

## License

MIT License - see [LICENSE](LICENSE)

---

## Community

- [GitHub Issues](https://github.com/onurpolat05/alba/issues) - Bug reports & feature requests
- [GitHub Discussions](https://github.com/onurpolat05/alba/discussions) - Questions & ideas

---

*Powered by ALBA - Consistent. Independent. Always learning.*
