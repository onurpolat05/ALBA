# Memory Compatibility

ALBA has its own memory system. Claude Code v2.1.59+ also has auto-memory. Here's how they coexist.

## Two Systems

| Aspect | ALBA Memory | Claude Auto-Memory |
|--------|-------------|-------------------|
| Location | `memory/` (in-repo) | `~/.claude/projects/<project>/memory/` |
| Control | User-managed, structured | Automatic, implicit |
| Git-tracked | Yes | No |
| Purpose | State, tasks, learnings, preferences | Build commands, code patterns, debugging |
| Persistence | Permanent (git) | Per-machine, per-project |

## How They Coexist

They serve different purposes — no conflict:

- **ALBA memory** = operational state (what you're doing, what you've learned, your priorities)
- **Auto-memory** = technical context (how things build, code conventions, common commands)

Both are loaded into context. ALBA uses progressive disclosure to keep its footprint small.

## Recommendations

1. **Keep auto-memory ON** (default) — it captures useful patterns ALBA doesn't track
2. **Don't duplicate** — if ALBA records a learning, don't manually add it to auto-memory
3. **Use `/memory`** to inspect and manage auto-memory contents
4. **If context feels slow** — review both systems for bloat and clean up

## Potential Issues

- **Context pressure**: both systems add to context window
- **Mitigation**: ALBA's progressive disclosure loads only what's needed per situation
- **Auto-memory**: Claude manages its size automatically
- **ALBA**: use `/reflect` periodically to consolidate and archive old data
