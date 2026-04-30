# /loop Integration

Claude Code's `/loop` runs a prompt or skill on a recurring schedule. ALBA uses it for passive monitoring (priorities, deadlines, error patterns).

> **Compatibility note:** This doc reflects CC v2.1.123 behavior. ALBA requires CC v2.1.83+.

## Two Modes

### Static interval mode

```
/loop [interval] [command or prompt]
```

Examples:
```
/loop 30m /status
/loop 1h check dashboard.md for approaching deadlines
/loop 2h scan errors.md for recurring patterns
```

Intervals: `s` (seconds), `m` (minutes), `h` (hours), `d` (days). Default if omitted: 10 minutes.

### Dynamic (self-paced) mode

Omit the interval to let Claude decide its own cadence. Useful when "every N minutes" is the wrong abstraction (e.g., "watch this long build, but don't burn cache").

```
/loop /status
```

Claude self-paces — typically 60–270s when actively watching, 1200–1800s for idle ticks. The 5-minute Anthropic prompt cache TTL informs the choice (sleeping 300s+ pays a cache miss, so picks usually fall below 270s or above 1200s).

## ALBA Usage Patterns

| Pattern | Purpose |
|---------|---------|
| `/loop 30m /status` | Periodic priority check |
| `/loop 1h check dashboard.md for approaching deadlines` | Deadline awareness |
| `/loop 2h scan errors.md for recurring patterns` | Error pattern detection |
| `/loop 4h remind me to save progress` | Session persistence nudge |
| `/loop /status` | Dynamic mode — Claude paces itself |

## Best Practices

- Use with `/status` for passive monitoring — lightweight, read-only.
- Don't loop `/start` or `/end` — those are session boundaries.
- Static intervals: keep ≥ 5 minutes (shorter = noisy).
- Dynamic mode: trust Claude's pacing; intervene with Esc if it's checking too often.
- Use loops for *awareness*, not *automation* — loops surface, you decide.

## Cancelling

Press **Esc** (since CC v2.1.113) to cancel pending wakeups. The cancellation is immediate.

## Limitations

- **Session-scoped:** stops when the terminal closes.
- **Idle-only:** fires only when Claude is idle (not mid-task).
- **No catch-up:** missed fires are skipped.
- **Max 50** scheduled tasks per session.
- **3-day expiry:** auto-cleans forgotten loops.

## For Persistent Scheduling

`/loop` is ephemeral. For reliable recurring tasks across sessions:
- macOS: `launchd` or `cron`
- Linux: `cron` or `systemd timers`
- CI/CD: GitHub Actions scheduled workflows
- Anthropic Console (if available on your plan): `/schedule` creates a remote routine that runs on a cron schedule independent of any local session.

## Setup

No configuration needed — `/loop` is a built-in Claude Code command. After ALBA setup, try:
```
/loop 30m /status
```
