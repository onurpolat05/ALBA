# /loop Integration

`/loop` is a built-in Claude Code command that re-runs a prompt or skill on a recurring basis. ALBA uses it for passive awareness — priorities, deadlines, error patterns — not for automation.

Requires Claude Code v2.1.218 or later (ALBA's minimum). Verified against v2.1.220.

## Two Modes

### Fixed interval

```
/loop [interval] [command or prompt]
```

```
/loop 30m /status
/loop 1h check dashboard.md for approaching deadlines
/loop 2h scan errors.md for recurring patterns
```

Interval units: `s`, `m`, `h`, `d`. Omit the interval and you get the other mode.

### Self-paced

Leave the interval out and Claude chooses its own cadence:

```
/loop /status
```

Useful when "every N minutes" is the wrong shape for the job — watching a long build, waiting on an external change. Claude tightens the interval while something is actively happening and stretches it when nothing is.

## Patterns Worth Setting Up

| Loop | What it gives you |
|---|---|
| `/loop 30m /status` | Periodic priority check |
| `/loop 1h check dashboard.md for approaching deadlines` | Deadline awareness |
| `/loop 2h scan errors.md for recurring patterns` | Error pattern detection |
| `/loop /status` | Self-paced — Claude decides when to look |

## Practice

- Loop read-only things. `/status` is the right size; it reads state and reports.
- **Don't loop `/start` or `/end`.** Those are session boundaries and they write state — running them on a timer corrupts the record of what actually happened.
- Keep fixed intervals at 5 minutes or longer. Shorter is noise, and each wake-up costs tokens.
- Loops are for *surfacing*, not *deciding*. The loop tells you a deadline is close; you decide what to do about it.

Press **Esc** to cancel pending wake-ups.

## What /loop Is Not

It is scoped to the session: close the terminal and the loop is gone. It fires only while Claude is idle, so it won't interrupt work in progress, and a fire that is missed is skipped rather than queued.

For anything that must run whether or not you have a session open:

- macOS: `launchd` or `cron`
- Linux: `cron` or `systemd` timers
- CI: scheduled GitHub Actions workflows
- `/schedule` — creates a cloud routine that runs on a cron schedule independently of any local session (availability depends on your plan)

## Setup

None. `/loop` ships with Claude Code. After ALBA setup:

```
/loop 30m /status
```
