---
name: create-skill
description: Create one new skill end to end - asks about purpose, trigger phrases, tools and context, then writes .claude/skills/<name>/SKILL.md with valid frontmatter and registers it in CLAUDE.md. Use when user says "create a skill", "make a slash command for this", "turn this workflow into a skill", "new skill for X". Do NOT use for hooks, rules or MCP integrations (use /extend), and do NOT use to change an existing skill - edit that SKILL.md directly.
context: inline
effort: medium
argument-hint: "[skill-name]"
allowed-tools: [Read, Write, Edit, AskUserQuestion]
---

# ALBA Skill Creator

Interactively create a new skill with proper frontmatter and structure.

## Process

### Step 1: Understand the Skill

Ask these questions (one at a time):

1. **"What should this skill do?"** - Core purpose in one sentence
2. **"What exact phrases should trigger it?"** - Push for the words the user actually types, not
   abstract categories. "research", "look into X", "find info on" beats "information gathering".
3. **"When should it NOT fire?"** - The nearest existing skill it could be confused with. This
   answer becomes the `Do NOT use for ...` clause and is what stops two skills fighting over the
   same prompt.
4. **"What inputs does it need?"** - What the user provides
5. **"What output should it produce?"** - Format, structure
6. **"Does it need web access or just local files?"** - Determines tools and context

### Step 2: Determine Configuration

Based on answers, decide:

**Context:**
- `inline` - Quick operations that need conversation context (< 1 min), or anything that asks the
  user a question
- `fork` - Heavy operations that should run as a subagent (research, log analysis, wide file
  sweeps). A fork keeps its own reading out of the main context window.

**If you choose `fork`, you must also decide `background`.** Forked skills default to
`background: true` — they detach and report back later. Set `background: false` when the user is
waiting for the answer in the same turn, which is the normal case for an interactive skill. Leave
the default only for genuinely fire-and-forget work. (`background` needs Claude Code v2.1.218+.)

**Tools:** Pick from:
- Read, Write, Edit, Glob, Grep (file operations)
- WebSearch, WebFetch (web access)
- Bash (system commands)
- AskUserQuestion (user interaction - only works with `inline`; a fork has no one to ask)

**Optional fields worth considering:** `argument-hint` if the skill takes arguments,
`disable-model-invocation: true` if firing it by accident would damage something,
`model` if the work is mechanical enough to run on a cheaper model. Full reference with every
valid field: `templates/skills/SKILL-TEMPLATE.md`.

### Step 3: Generate SKILL.md

Create `.claude/skills/[name]/SKILL.md`:

```markdown
---
name: [skill-name]
description: [what it does]. Use when user says "[phrase]", "[phrase]", "[phrase]". Do NOT use for [nearest neighbour / wrong trigger].
context: [inline or fork]
background: false        # fork only - drop this line for inline skills
effort: [low|medium|high]
allowed-tools: [Read, Write, ...]
---

# [Skill Name]

[Purpose description]

## When to Use

- [Trigger 1]
- [Trigger 2]

## Process

1. [Step 1]
2. [Step 2]
3. [Step 3]

## Output Format

[Expected output structure]

## Tools

- [Tool]: [what it's used for]
```

**The `description` is the whole ballgame.** It is the only thing Claude reads when deciding
whether to invoke the skill — the body is loaded *after* the decision is made. A description like
"Create weekly reports" will not fire; one that names the phrases and the boundary will.
`description` and `when_to_use` together are capped at **1,536 characters**.

### Step 4: Update CLAUDE.md

Add entry to the Skills table in CLAUDE.md:

```markdown
| /[name] | [Description] | [inline/fork] |
```

### Step 5: Test

Run the new skill with a test input and verify it works.

## Guidelines

- Keep skill names short and descriptive (1-2 words)
- Each skill does ONE thing well
- Use `context: fork` for anything that reads lots of files or does web research — and pair it
  with `background: false` unless the user really is meant to walk away
- Write the `Do NOT use for` clause even when nothing seems to conflict; the next skill added will
- Always include a clear output format section
- Reference `templates/skills/SKILL-TEMPLATE.md` for the full field reference
