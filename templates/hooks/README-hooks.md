# Hooks Guide

## What are Hooks?

Hooks are shell scripts that run automatically at specific events in Claude Code. They let you automate workflows.

## Available Hook Types

| Hook | When It Runs | Use Case |
|------|-------------|----------|
| `SessionStart` | Session begins | Load context, show summary |
| `Stop` | Session ends | Save state, reminders |
| `PreToolUse` | Before tool execution | Validation, safety checks |
| `PostToolUse` | After tool execution | Logging, error handling |

## Setup

1. Create `.claude/hooks/` directory
2. Add hook scripts (must be executable)
3. Configure in `.claude/settings.json`

### Example settings.json

```json
{
  "hooks": {
    "SessionStart": {
      "command": ".claude/hooks/session-start.sh"
    },
    "Stop": {
      "command": ".claude/hooks/session-stop.sh"
    }
  }
}
```

## Creating a Hook

### 1. Write the script

```bash
#!/bin/bash
# Your hook logic here
echo "Hook executed!"
```

### 2. Make it executable

```bash
chmod +x .claude/hooks/your-hook.sh
```

### 3. Add to settings.json

```json
{
  "hooks": {
    "HookType": {
      "command": ".claude/hooks/your-hook.sh"
    }
  }
}
```

## Hook Templates

### SessionStart Hook
- Load daily context
- Show current focus
- Display active tasks

### Stop Hook
- Remind to save state
- Prompt for daily log update
- Check for uncommitted changes

### PreToolUse Hook
- Validate commands (safety check)
- Prevent destructive operations
- Log tool usage

### PostToolUse Hook
- Log errors to knowledge base
- Update task status
- Track time spent

## Best Practices

1. **Keep hooks fast** - They run on every event
2. **Silent success** - Only output when necessary
3. **Fail gracefully** - Don't block Claude if hook fails
4. **Log errors** - Help debugging
5. **Use exit codes** - 0 = success, non-zero = failure

## Examples

### Simple SessionStart
```bash
#!/bin/bash
echo "=== $(date) ==="
cat memory/state/current_focus.md
```

### Validation PreToolUse
```bash
#!/bin/bash
# Prevent rm -rf in important directories
if echo "$1" | grep -q "rm -rf /"; then
  echo "ERROR: Destructive command blocked"
  exit 1
fi
exit 0
```

## Troubleshooting

**Hook not running?**
- Check file is executable: `chmod +x hook.sh`
- Check path in settings.json is correct
- Check hook script has no syntax errors

**Hook blocking Claude?**
- Make sure script exits (doesn't hang)
- Check exit codes (0 = success)
- Test script manually first

## Advanced Usage

### Conditional Hooks
```bash
#!/bin/bash
# Only run on weekdays
if [ $(date +%u) -lt 6 ]; then
  # Your logic
fi
```

### Hook with Parameters
```bash
#!/bin/bash
TOOL_NAME="$1"
echo "Tool used: $TOOL_NAME"
```

---

Created: 2025-01-09
