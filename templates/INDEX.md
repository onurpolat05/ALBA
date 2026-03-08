# ALBA Template Index

Reference for all template files used during `/setup`.

## Claude Templates

| File | Description |
|------|-------------|
| `claude/CLAUDE.md.template` | Main agent instruction file (< 200 lines) |
| `claude/memory-system.md.template` | Memory system documentation |
| `claude/decision-protocol.md.template` | Decision-making protocol |
| `claude/quality-gates.md.template` | Confidence scoring for plans and research |

## Memory Templates

| File | Description |
|------|-------------|
| `memory/todo.md.template` | Active tasks and goals |
| `memory/dashboard.md.template` | Daily dashboard / priorities / deadlines |
| `memory/learnings.md.template` | Accumulated insights (auto-updated) |
| `memory/preferences.md.template` | User preferences |
| `memory/daily-log.md.template` | Daily session summary |

## Skill Templates

| File | Description |
|------|-------------|
| `skills/SKILL-TEMPLATE.md` | Generic skill template |
| `skills/research-skill-example.md` | Web research skill example |
| `skills/task-automation-example.md` | Task automation skill example |

## Hook Templates

| File | Event | Description |
|------|-------|-------------|
| `hooks/session-start.sh.template` | SessionStart | Load dashboard |
| `hooks/memory-check.sh.template` | Stop | Save state reminder |
| `hooks/bash-validator.sh.template` | PreToolUse | Block dangerous commands |
| `hooks/error-logger.sh.template` | PostToolUse | Log error patterns |
| `hooks/agent-suggest.sh.template` | UserPromptSubmit | Agent suggestions |
| `hooks/pre-compact.sh.template` | PreCompact | Preserve context |
| `hooks/README-hooks.md` | - | Hooks system documentation |

## Rule Templates

| File | Description |
|------|-------------|
| `rules/behavioral.md` | Decision protocol, communication, self-improvement |
| `rules/security.md` | Input validation, secrets, safe commands |

## Usage

Templates are used by `/setup` to create personalized files. They can also be copied manually:

```bash
# Example: add research skill
mkdir -p .claude/skills/research
cp templates/skills/research-skill-example.md .claude/skills/research/SKILL.md
```

---

*ALBA v1.0*
