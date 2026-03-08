# /loop Integration

Claude Code v2.1.71+ includes `/loop` — session-scoped scheduled tasks.

## Syntax

```
/loop [interval] [command or prompt]
/loop 30m /status
/loop 1h check dashboard for approaching deadlines
/loop check the build          # default: every 10 minutes
```

**Intervals:** `s` (seconds), `m` (minutes), `h` (hours), `d` (days)

## ALBA Usage Patterns

| Pattern | Purpose |
|---------|---------|
| `/loop 30m /status` | Periodic priority check |
| `/loop 1h check dashboard.md for approaching deadlines` | Deadline awareness |
| `/loop 2h scan errors.md for recurring patterns` | Error pattern detection |
| `/loop 4h remind me to save progress` | Session persistence |

## Best Practices

- Use with `/status` for passive monitoring — lightweight, read-only
- Don't loop `/start` or `/end` — those are session boundaries
- Keep intervals >= 5 minutes (shorter = noisy)
- Use for awareness, not automation — loops suggest, you decide

## Limitations

- **Session-scoped**: stops when terminal closes
- **Idle-only**: fires only when Claude is idle (not mid-task)
- **No catch-up**: missed fires are skipped
- **Max 50** scheduled tasks per session
- **3-day expiry**: auto-cleans forgotten loops

## For Persistent Scheduling

`/loop` is ephemeral. For reliable recurring tasks:
- macOS: `launchd` or `cron`
- Linux: `cron` or `systemd timers`
- CI/CD: GitHub Actions scheduled workflows

## Setup

No configuration needed — `/loop` is a built-in Claude Code command.
After ALBA setup, try: `/loop 30m /status`
