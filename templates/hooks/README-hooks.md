# ALBA Hooks System

Hooks are shell scripts that run automatically at specific Claude Code events.

## Two-Layer Security Model (v1.1.0+)

ALBA uses defense-in-depth for dangerous-command protection:

**Layer 1 — CC-native permissions** (in `settings.json`)
- `permissions.deny`: hard blocks (e.g., `Bash(sudo:*)`, `Read(.env)`)
- `permissions.ask`: prompt before run (e.g., `Bash(git push:*)`)
- Since CC v2.1.113, deny rules automatically match commands wrapped in `env`/`sudo`/`watch`/`ionice`/`setsid`, and `find:*` no longer auto-approves `-exec`/`-delete` under broad allow rules.

**Layer 2 — `bash-validator.sh`** (this hook directory)
- Detects catastrophic semantic intent that command-level rules can't see (fork bombs, disk wipes, pipe-to-shell, `DROP DATABASE`, etc.)
- Runs as PreToolUse(Bash) and returns `{decision: block}` to halt execution.

Together, the two layers catch both syntactic and semantic dangerous-command patterns. Customize Layer 1 for your workflow; Layer 2 is intentionally minimal and rarely needs editing.

## Included Hooks

| Hook | Event | Matcher | Purpose |
|------|-------|---------|---------|
| `session-start.sh` | SessionStart | - | Load dashboard, show priorities |
| `memory-check.sh` | Stop | - | Remind to save state |
| `bash-validator.sh` | PreToolUse | Bash | Block dangerous commands (semantic intent) |
| `error-logger.sh` | PostToolUse + PostToolUseFailure | Bash on PostToolUse | Log errors (any tool, captures `duration_ms`) |
| `agent-suggest.sh` | UserPromptSubmit | - | Suggest agents by keyword |
| `pre-compact.sh` | PreCompact | - | Preserve context before compaction |
| `post-compact.sh` | PostCompact | - | Remind to re-load context after compaction |

## Setup

### 1. Copy hooks to your project

```bash
mkdir -p .claude/hooks
cp templates/hooks/*.sh.template .claude/hooks/
# Rename: remove .template suffix
for f in .claude/hooks/*.template; do mv "$f" "${f%.template}"; done
chmod +x .claude/hooks/*.sh
```

### 2. Configure settings.json

Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {"type": "command", "command": "bash .claude/hooks/session-start.sh"}
    ],
    "Stop": [
      {"type": "command", "command": "bash .claude/hooks/memory-check.sh"}
    ],
    "PreToolUse": [
      {"matcher": "Bash", "type": "command", "command": "bash .claude/hooks/bash-validator.sh"}
    ],
    "PostToolUse": [
      {"matcher": "Bash", "type": "command", "command": "bash .claude/hooks/error-logger.sh"}
    ],
    "UserPromptSubmit": [
      {"type": "command", "command": "bash .claude/hooks/agent-suggest.sh"}
    ],
    "PreCompact": [
      {"type": "command", "command": "bash .claude/hooks/pre-compact.sh"}
    ]
  }
}
```

## Hook Types Reference

| Event | When | Input | Output |
|-------|------|-------|--------|
| SessionStart | Session begins | - | stdout shown to Claude |
| Stop | Session ends | - | stdout shown to Claude |
| PreToolUse | Before tool runs | JSON (stdin): tool_name, tool_input | JSON: `{"decision":"allow"}` or `{"decision":"block","reason":"..."}` |
| PostToolUse | After tool runs | JSON (stdin): tool_name, tool_input, tool_output | stdout shown to Claude |
| UserPromptSubmit | User sends message | JSON (stdin): message | stdout shown to Claude |
| PreCompact | Before context compaction | - | stdout preserved in summary |

## Customization

Each hook is a standalone bash script. Customize by:
- Editing patterns in `bash-validator.sh` (add/remove blocked commands)
- Adding keyword mappings in `agent-suggest.sh`
- Changing dashboard format in `session-start.sh`
- Adjusting checklist in `memory-check.sh`

## Best Practices

1. **Keep hooks fast** - they run on every matching event
2. **Fail gracefully** - use `|| true` for non-critical operations
3. **Silent success** - only output when there's something useful to show
4. **Test manually** - run scripts directly before adding to settings.json

## Windows Compatibility

Claude Code runs natively on Windows and routes bash commands through **Git Bash** (provided by Git for Windows). ALBA's hooks therefore work on Windows without WSL — provided three things hold:

1. **Git for Windows is installed** — gives you Git Bash, the bash interpreter CC routes commands through. Install: `winget install --id Git.Git -e`.
2. **`jq` is on PATH** — every hook uses `jq` to parse the JSON event payload (with a grep fallback, but jq is much more reliable). Install: `winget install --id jqlang.jq -e`.
3. **Repo is cloned with LF line endings** — ALBA's `.gitattributes` forces `*.sh` files to LF on all platforms, so a fresh clone works. If you see `bad interpreter: bash\r`, your clone predates `.gitattributes` (re-clone) or someone edited a script with a CRLF editor (run `dos2unix` or `sed -i 's/\r$//'`).

**settings.json portability:** ALBA always uses `"command": "bash .claude/hooks/script.sh"` (explicit `bash` prefix + forward-slash path). This works identically on macOS, Linux, and Windows Git Bash — no executable bit required, no path rewriting needed.

**WSL2 alternative:** if you prefer a full Linux toolchain, install Claude Code inside your WSL2 distro and clone ALBA there. Same hooks, same setup — Git Bash and WSL2 both satisfy the bash + jq requirement.
