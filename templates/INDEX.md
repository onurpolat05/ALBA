# ALBA Template Index

Every template file, what it becomes, and where it lands. `/setup` reads from here; you can also copy any of it by hand.

`templates/` is the single source of truth. The trees under `examples/` are generated from it — read them to see a finished setup, but don't edit them.

## `templates/claude/` → `.claude/docs/` and `CLAUDE.md`

| Template | Becomes | Holds |
|---|---|---|
| `CLAUDE.md.template` | `CLAUDE.md` (project root) | Identity, what loads when, read triggers, hook inventory. Keep under 100 lines |
| `memory-system.md.template` | `.claude/docs/memory-system.md` | Memory layout, flowing vs. permanent, data policy |
| `decision-protocol.md.template` | `.claude/docs/decision-protocol.md` | Worked examples of asking vs. acting |
| `quality-gates.md.template` | `.claude/docs/quality-gates.md` | Confidence scoring for plans and research |
| `loop-integration.md.template` | `.claude/docs/loop-integration.md` | `/loop` for recurring checks |
| `memory-compatibility.md.template` | `.claude/docs/memory-compatibility.md` | ALBA memory alongside Claude Code auto-memory |

## `templates/rules/` → `.claude/rules/`

Rule files load **unconditionally, every session**. Copy them as-is (no `.template` suffix) and keep each one short — every line costs context on every turn.

| File | Holds |
|---|---|
| `behavioral.md` | **Canonical** decision protocol, communication style, self-improvement |
| `security.md` | Secrets, safe commands, input validation, prompt injection, the hook security boundary |
| `verification.md` | What to report after a change: verified vs. not verified |

## `templates/agents/` → `.claude/agents/`

Custom subagents. Copy as-is; Claude Code discovers them by filename and reads their `description` to decide when to invoke.

| File | Purpose |
|---|---|
| `planner.md` | Breaks a multi-step goal into ordered steps with dependencies, sizes and risks |

Research has no agent file on purpose — the `/research` skill already runs forked in a subagent, and shipping both would be two doors to one room.

## `templates/memory/` → `memory/`

| Template | Becomes |
|---|---|
| `dashboard.md.template` | `memory/state/dashboard.md` |
| `todo.md.template` | `memory/state/todo.md` |
| `learnings.md.template` | `memory/knowledge/learnings.md` |
| `preferences.md.template` | `memory/knowledge/preferences.md` |
| `daily-log.md.template` | `memory/daily/YYYY-MM-DD.md` (shape reference; Claude writes these) |

`memory/knowledge/errors.md` has no template — `/setup` creates it with a header, and Claude fills it as errors get solved.

## `templates/hooks/` → `.claude/hooks/`

| Template | Event |
|---|---|
| `session-start.sh.template` | SessionStart |
| `session-end.sh.template` | SessionEnd |
| `bash-validator.sh.template` | PreToolUse (matcher: `Bash`) |
| `error-logger.sh.template` | PostToolUse (matcher: `Bash`) + PostToolUseFailure |
| `memory-check.sh.template` | Stop |
| `pre-compact.sh.template` | PreCompact |
| `post-compact.sh.template` | PostCompact |
| `agent-suggest.sh.template` | UserPromptSubmit |
| `README-hooks.md` | Reference — the stdin/stdout contract, wiring, and how to test a hook |

Hooks do nothing until they are wired into `.claude/settings.json`. A misconfigured hook fails **silently**. See `README-hooks.md`.

## `templates/skills/` — reference, not generated output

| File | Purpose |
|---|---|
| `SKILL-TEMPLATE.md` | Frontmatter and structure for a new skill |
| `research-skill-example.md` | A forked skill, annotated |
| `task-automation-example.md` | An automation skill, annotated |

The working skills already sit at `.claude/skills/` and need no copying: `/start` · `/end` · `/status` · `/setup` · `/extend` · `/reflect` · `/research` · `/weekly-review` · `/create-skill`.

## Which Settings File

Two files, and putting a value in the wrong one either leaks a secret or fails to share a fix.

| | `.claude/settings.json` | `.claude/settings.local.json` |
|---|---|---|
| Git | **Committed** — shared with everyone who clones | **Ignored** — never committed |
| Holds | Hook wiring, `permissions.ask` / `permissions.deny`, `env`, model and output-style defaults | Personal permission grants, MCP server entries, machine-specific paths, anything with a credential in it |
| Test | Would a teammate cloning this repo want it? | Is it about *your* machine, *your* accounts, *your* tolerance for prompts? |

Local settings take precedence over shared ones. Confirm `.claude/settings.local.json` is in `.gitignore` before you put anything in it — MCP entries in particular tend to carry tokens.

## Manual Install

```bash
# hooks
cp templates/hooks/*.template .claude/hooks/
cd .claude/hooks && for f in *.template; do mv "$f" "${f%.template}"; done
chmod +x .claude/hooks/*.sh

# rules and agents copy as-is, no rename
cp templates/rules/*.md .claude/rules/
mkdir -p .claude/agents && cp templates/agents/*.md .claude/agents/
```

Then wire the hooks into `.claude/settings.json` and verify it parses:

```bash
python3 -m json.tool < .claude/settings.json > /dev/null && echo "settings.json OK"
```
