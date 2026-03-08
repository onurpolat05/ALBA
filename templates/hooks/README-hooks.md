# ALBA Hooks System

Hooks are shell scripts that run automatically at specific Claude Code events.

## Included Hooks

| Hook | Event | Matcher | Purpose |
|------|-------|---------|---------|
| `session-start.sh` | SessionStart | - | Load dashboard, show priorities |
| `memory-check.sh` | Stop | - | Remind to save state |
| `bash-validator.sh` | PreToolUse | Bash | Block dangerous commands |
| `error-logger.sh` | PostToolUse | Bash | Log errors to errors.md |
| `agent-suggest.sh` | UserPromptSubmit | - | Suggest agents by keyword |
| `pre-compact.sh` | PreCompact | - | Preserve context before compaction |

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
      { "command": ".claude/hooks/session-start.sh" }
    ],
    "Stop": [
      { "command": ".claude/hooks/memory-check.sh" }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "command": ".claude/hooks/bash-validator.sh"
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash",
        "command": ".claude/hooks/error-logger.sh"
      }
    ],
    "UserPromptSubmit": [
      { "command": ".claude/hooks/agent-suggest.sh" }
    ],
    "PreCompact": [
      { "command": ".claude/hooks/pre-compact.sh" }
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
