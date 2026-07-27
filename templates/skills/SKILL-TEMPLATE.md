# SKILL.md Reference

Everything a skill file can declare, what each field is for, and the two mistakes that cost the
most. Copy the [starting point](#starting-point) at the bottom and delete what you don't need.

Verified against Claude Code **v2.1.220**.

---

## 1. The one field that decides everything

`description` is the only part of a skill Claude reads when deciding whether to invoke it. The
body below the frontmatter is loaded *after* that decision. A skill with a perfect body and a
lazy description simply never fires.

Write it in three parts:

```
<what it does>. Use when user says "x", "y", "z". Do NOT use for <nearest neighbour>.
```

| Part | Purpose |
|------|---------|
| what it does | Enough for Claude to know the skill's output, in one clause |
| Use when user says | The **literal phrases a user types** — not abstract categories. "look into X" beats "information gathering tasks" |
| Do NOT use for | The boundary against the skill most likely to be confused with this one |

The `Do NOT use` clause matters more as the collection grows. Two skills that both sound like
"summarise my work" will fight over every prompt until one of them says which case it declines.
Write the clause even when nothing conflicts yet — something will.

**Capacity limit:** `description` and `when_to_use` together may not exceed **1,536 characters**.

---

## 2. Frontmatter fields

### Identity

| Field | Value | Notes |
|-------|-------|-------|
| `name` | string | Skill name; also the `/slash` command |
| `description` | string | See above. The trigger surface |
| `when_to_use` | string | Optional second field for trigger conditions, if you'd rather keep them out of `description`. Shares the 1,536-character budget with it. Using `description` alone is simpler |
| `argument-hint` | string | Shown in autocomplete, e.g. `<topic> [deep]`. Add it whenever the skill reads `$ARGUMENTS` |
| `arguments` | structured | Fuller argument definition when a hint isn't enough |

### Where it runs

| Field | Value | Notes |
|-------|-------|-------|
| `context` | `inline` \| `fork` | `inline` runs in the main conversation. `fork` runs in a subagent so its file reads and search noise never enter your context window |
| `background` | `true` \| `false` | **Only meaningful with `context: fork`.** See §3 — read it before shipping any fork skill |
| `agent` | `Explore` \| `Plan` \| `general-purpose` | Which agent type the fork runs as. `Explore` is read-only and tuned for search; `Plan` for design work; `general-purpose` when the fork needs to write files |
| `model` | model id | Pin a specific model, usually to run a mechanical skill more cheaply. Use current ids: `claude-opus-5`, `claude-sonnet-5`, `claude-fable-5`, `claude-haiku-4-5-20251001` |
| `effort` | `low` \| `medium` \| `high` | Reasoning budget. Readable inside the skill as `${CLAUDE_EFFORT}` |
| `shell` | shell name | Which shell the skill's commands run under |

### What it may touch

| Field | Value | Notes |
|-------|-------|-------|
| `allowed-tools` | list | Allowlist while the skill is active. `AskUserQuestion` only works with `context: inline` — a fork has nobody to ask |
| `disallowed-tools` | list | Explicit denylist |
| `paths` | glob list | Skill is only active when the files in play match one of these globs. Good for language- or directory-specific skills |

### How it gets invoked

| Field | Value | Notes |
|-------|-------|-------|
| `user-invocable` | bool | Whether the user can call it with `/name` |
| `disable-model-invocation` | `true` | Claude will never invoke it on its own — user's `/` only. See §4 |
| `hooks` | object | Hooks scoped to this skill; they exist only while it is running |

---

## 3. `context: fork` and `background` — the trap

Since **Claude Code v2.1.218**, a skill with `context: fork` defaults to `background: true`. The
official wording:

> Only applies with `context: fork`. Set to `false` to wait for the forked subagent's result in
> the turn that invoked the skill, instead of running it in the background. Default: `true`.
> Requires Claude Code v2.1.218 or later.

Read what that means for a skill written before v2.1.218: it did not change, but its behaviour
did. A `/research` skill that used to return its report in the same turn now detaches, and the
user gets an acknowledgement instead of an answer. Nothing errors. The file still looks correct.

**The rule:** if the user is waiting for the result, set `background: false` explicitly. That is
the normal case for anything invoked by a human in conversation. You still get the context
isolation of a fork — the searching and file reading stay out of your window — you just also get
the answer back inline.

Leave the `true` default only for work that is genuinely fire-and-forget: a scheduled job, a long
crawl whose output lands in a file, something kicked off deliberately to be collected later.

Two more consequences of forking, unrelated to `background`:

- A fork cannot use `AskUserQuestion`. If your skill needs to ask something, either make it
  `inline`, or have the fork end its report with an explicit "offers" block that the main
  conversation turns into questions.
- Subagents in general have defaulted to running in the background since v2.1.198, so this is the
  same shift showing up in two places.

---

## 4. `disable-model-invocation`

Set it to `true` when an accidental invocation would do damage that is hard to notice or hard to
undo — a bootstrap that overwrites config, anything that rewrites files wholesale. The skill then
runs only when the user types `/name`.

It has two side effects worth knowing:

- **Scheduled tasks can no longer trigger it.** If you want a cron-driven run, don't set this.
- **The skill is not preloaded into subagents**, which also keeps it out of their context budget.

Don't reach for it on merely *interactive* skills. A skill that asks three questions before
writing anything is already guarded by the questions.

---

## 5. Variables available inside a skill

| Variable | Resolves to |
|----------|-------------|
| `$ARGUMENTS` | Everything the user typed after the command |
| `$0`, `$1`, `$2`… | Positional arguments |
| `$name` | A named argument |
| `${CLAUDE_SKILL_DIR}` | This skill's own directory — use it to reference bundled scripts or reference files |
| `${CLAUDE_PROJECT_DIR}` | Project root. Use this instead of relative paths |
| `${CLAUDE_SESSION_ID}` | Current session id, e.g. for naming an output file |
| `${CLAUDE_EFFORT}` | The effort level in force, so the skill body can scale its own depth |
| `` !`command` `` | Runs the shell command and injects its output into the skill at load time |

Dynamic injection is the interesting one. `` Today is !`date +%Y-%m-%d`. `` puts the real date in
front of Claude without a tool call, which is how you stop a skill from guessing at dates.

---

## 6. Starting point

```markdown
---
name: my-skill
description: <what it does>. Use when user says "<phrase>", "<phrase>", "<phrase>". Do NOT use for <the nearest skill this could be confused with>.
context: inline          # or: fork
# background: false      # fork only — set false when the user waits for the result
# agent: general-purpose # fork only — Explore | Plan | general-purpose
effort: medium
allowed-tools: [Read, Write, Glob, Grep]
# argument-hint: "<topic> [deep]"
# disable-model-invocation: true
---

# My Skill

One paragraph: what this produces and for whom.

## When to Use

- Trigger condition 1
- Trigger condition 2

## Process

1. Step one
2. Step two
3. Step three

## Output Format

What the skill returns. Show a short example — a skill that describes its output in prose
produces a different shape every time.

## Rules

- Constraints, length limits, what not to do
- What to do when the expected input is missing
```

---

## 7. Checklist before you ship

- [ ] `description` names literal trigger phrases *and* a `Do NOT use for` boundary
- [ ] `description` + `when_to_use` under 1,536 characters
- [ ] If `context: fork`: `background` decided on purpose, not left to default
- [ ] If `context: fork`: no `AskUserQuestion` in `allowed-tools`
- [ ] `allowed-tools` is the minimum set that actually works
- [ ] Any `model` pin uses a current model id
- [ ] Frontmatter parses as valid YAML
- [ ] Invoked once with a real input and the output matched the documented format

---

*ALBA v2.0.0*
