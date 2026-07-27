# Memory Compatibility

Claude Code has its own automatic memory. ALBA has `memory/`. They are separate systems that happen to share a word, and they do not conflict — but knowing which one a given fact belongs in is what keeps both useful.

Verified against Claude Code v2.1.220.

## Two Systems

| | ALBA memory | Claude Code auto-memory |
|---|---|---|
| Location | `memory/` in your project | `~/.claude/projects/<encoded-project-path>/memory/` |
| Written by | You and Claude, deliberately | Claude, on its own initiative |
| Structure | Directories you designed | Flat files plus a `MEMORY.md` index |
| Git | Tracked, shared, reviewable | Not tracked, per-machine |
| Size limit | None enforced | `MEMORY.md` capped at **25KB / 200 lines** |
| Holds | State, priorities, learnings, project context | One-line tactical facts |

## Which Fact Goes Where

The split follows from the size cap. Auto-memory's index is capped, so entries past the cap are truncated — it is built for short facts, and long narrative content crowds out things you'd rather keep.

- **ALBA memory** — anything with a shape: an error write-up with cause and fix, a project's context and the reasoning behind its decisions, this week's priorities, an accumulated learning. Content you will read as prose later.
- **Auto-memory** — the one-liners: which command builds this project, a convention the codebase follows, a tool that behaves unexpectedly. Facts that fit on a line and stay true.

The test: if the entry needs a heading, it belongs in ALBA memory.

## Practice

1. **Leave auto-memory on.** It catches operational detail ALBA was never designed to track, at no cost to you.
2. **Don't mirror.** A learning recorded in `memory/knowledge/learnings.md` should not be copied into auto-memory. Two copies means one of them will eventually be the wrong one, and you won't know which.
3. **Inspect it directly.** Auto-memory is plain files — read and edit them at the path above like any other file. Delete entries that turn out to be wrong; a stale memory is worse than an absent one, because it gets applied confidently.
4. **Watch git.** ALBA memory is committed. Auto-memory is not, which also means it isn't backed up and isn't shared with a teammate cloning your repo.

## The Privacy Consequence

ALBA memory is **git-tracked**. Anything written there is committed, pushed, and readable by anyone with repo access — permanently, since removing a file later doesn't remove it from history.

So the data policy in `memory-system.md` applies with force here: no secrets, no third-party personal data, no confidential client material in `memory/`. If something genuinely must be remembered but must not be committed, add its path to `.gitignore` first, and know that you have traded away the backup and the review trail in exchange.

## Context Pressure

Both systems consume context. Auto-memory manages its own size via the cap. ALBA relies on progressive disclosure — nothing under `memory/` loads until something reads it, which is why the read triggers in `memory-system.md` matter more than they look like they do.

If sessions start feeling heavy, the usual culprit is a `state/` file that has been accumulating instead of flowing. Run `/reflect` and prune.
