# Memory System Guide

How ALBA remembers things between sessions, and — more importantly — how it avoids remembering everything.

## Structure

```
memory/
├── state/              # Now. Rewritten constantly.
│   ├── dashboard.md    # Priorities, active projects, deadlines
│   └── todo.md         # This week's tasks, blockers
├── knowledge/          # Durable. Accumulates.
│   ├── learnings.md    # Reusable insights (Claude appends)
│   ├── errors.md       # Error → cause → fix (Claude appends)
│   └── preferences.md  # How you want to be worked with
├── projects/           # Per project
│   └── [project-name]/
│       └── context.md  # Goal, status, decisions, next step
└── daily/              # One file per session
    └── YYYY-MM-DD.md
```

## Flowing vs. Permanent

This is the single rule that keeps memory from turning into a landfill. Every file is one of two kinds:

| Kind | Files | Rule |
|---|---|---|
| **Flowing** | `state/dashboard.md`, `state/todo.md`, `daily/*` | Overwritten, consumed, and superseded. Once an item is done or absorbed into a project's `context.md`, **delete the line** — don't strike it through, don't mark it DONE and leave it. |
| **Permanent** | `knowledge/*`, `projects/*/context.md` | Grows on purpose. Entries are written to be read months later, and edited in place when they turn out to be wrong. |

Two consequences worth internalizing:

- **A flowing file is a queue, not an archive.** If `todo.md` only ever gains lines, it has stopped being a todo list.
- **Wrong information is worse than missing information.** A stale entry that contradicts reality costs more than the entry was ever worth. Delete outdated content outright — the history is in git if you need it. Never leave `~~strikethrough~~`, "DEPRECATED", or "no longer true" markers behind in an active file.

## What Does Not Go In Memory

`memory/` is git-tracked, plain text, and loaded into a model's context. Treat it accordingly.

- **No secrets.** No API keys, tokens, passwords, connection strings — not even "temporarily".
- **No personal data about other people.** Names, contact details, health or financial information about third parties don't belong in a file that will be committed and re-read for months. Refer to people by role ("the client", "the reviewer") where the identity isn't the point.
- **No confidential client or employer material.** Contract terms, pricing, unreleased plans. If it would need an NDA to email, it needs one to commit.
- **No binaries or dumps.** No images, PDFs, database exports, or log dumps. Memory is text you will read; store artifacts elsewhere and link to them by path.
- **Size:** if a single memory file passes ~500 lines, split it by topic or archive the resolved parts. If one entry passes ~50 lines, it is a project document, not a memory entry.

## Reading, Not Preloading

Memory is lazy — nothing under `memory/` is in context until something reads it. Read on the trigger, not in advance:

| Trigger | Read |
|---|---|
| Session start | `state/dashboard.md`, `state/todo.md` |
| Error encountered | `knowledge/errors.md` |
| Working on a project | `projects/[name]/context.md` |
| About to record an insight | `knowledge/learnings.md` |

## Recording

Claude appends to `knowledge/errors.md` and `knowledge/learnings.md` on its own, and writes `daily/YYYY-MM-DD.md` at `/end`. The bar for an entry:

- **learnings.md** — reusable, non-obvious, and it cost something to find out. Not "React uses hooks."
- **errors.md** — took real time to solve and could plausibly recur. Message, root cause, fix, prevention.
- **A project's `context.md`** — decisions and their *reasons*. The reason is the part that isn't recoverable from the code later.

## Archiving

Finished project → move the folder to `memory/projects/archive/`. Resolved sections of a long knowledge file → move to `memory/knowledge/archive/`. Use `/reflect` to spot what has gone cold.

---

## Size Limits, and Claude Code's Own Memory

ALBA memory has **no size cap** — the limits above are editorial discipline, not enforcement.

Claude Code has a separate, automatic memory at `~/.claude/projects/<encoded-project-path>/memory/`. Its index file `MEMORY.md` **is capped, at 25KB / 200 lines** — content past the cap is truncated. ALBA's `memory/` lives in your project and is unaffected by that cap.

Split the work between them:

- **ALBA memory** — narrative and structured content: learnings, error write-ups, project context, priorities.
- **Claude Code auto-memory** — one-line tactical facts: build commands, code conventions, tool quirks.

Full coexistence model: [memory-compatibility.md](memory-compatibility.md)

---

Created: [Date]
