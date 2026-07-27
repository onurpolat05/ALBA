---
name: reflect
description: Cross-session pattern analysis - reads recent daily logs, errors and learnings to surface recurring problems, then proposes rules, skills or hooks with evidence. Runs in a forked subagent. Use when user says "reflect", "find patterns", "what keeps going wrong", "how can I improve my workflow", "analyze my sessions", "am I repeating mistakes". Do NOT use for this week's summary and next-week planning (use /weekly-review) or for closing a single session (use /end).
context: fork
agent: general-purpose
background: false
effort: medium
argument-hint: "[days to look back, default 7]"
allowed-tools: [Read, Write, Glob, Grep]
---

# ALBA Reflect

Analyze recent session logs, errors, and learnings to find patterns and suggest improvements.

## When to Use

- After several work sessions (weekly recommended)
- When the same problems keep appearing
- To discover workflow improvements
- To propose new rules based on observed patterns

## Why `background: false`

Since Claude Code v2.1.218, a skill with `context: fork` defaults to `background: true` — the fork
detaches and its report shows up later as a notification, not in the turn you asked. Reflection is
a conversation starter: the report is only useful if you can immediately say "yes, create that
rule". So this skill pins `background: false`. The fork still absorbs the cost of reading every
daily log, but the finished report comes back inline and Step 4 below happens in the main
conversation, where you can approve actions.

**Requires Claude Code v2.1.218 or later**; older versions ignore the field and already behave this way.

## Process

### Step 1: Gather Data

Read recent files. Default window is the last 7 days or last 5 sessions; if `$ARGUMENTS` holds a
number, use that many days instead.

```
memory/daily/*.md          # Session logs
memory/knowledge/errors.md # Error patterns
memory/knowledge/learnings.md # Accumulated insights
```

Use Glob to find daily logs, then read the most recent ones.

### Step 2: Analyze Patterns

Look for:

**Recurring errors:**
- Same error appearing 2+ times → needs a prevention rule
- Errors with "Status: Unresolved" → need attention

**Workflow patterns:**
- Tasks that repeat across sessions → candidate for automation (skill)
- Manual steps done every session → candidate for hook
- Decisions made repeatedly → candidate for rule

**Time sinks:**
- Topics that consumed lots of session time
- Context-switching patterns
- Blockers that persisted across sessions

**Growth areas:**
- Skills improving over time
- New tools or techniques adopted
- Knowledge gaps identified

### Step 3: Generate Report

Output format:

```markdown
# Reflection Report - [Date Range]

## Sessions Analyzed: [N]

## Recurring Patterns
1. [Pattern]: Observed [N] times. Impact: [High/Medium/Low]
2. ...

## Suggested Rules
- **Rule:** [description]
  **Reason:** [pattern that triggered this]
  **File:** `.claude/rules/[suggested-name].md`

## Suggested Skills
- **Skill:** [description]
  **Reason:** [repeated workflow]

## Unresolved Issues
- [Issue]: First seen [date], still active

## Key Insights
- [Insight 1]
- [Insight 2]

## Recommendations
1. [Action item]
2. [Action item]
```

### Step 4: Offer Actions

The fork produces the report and stops there — a forked subagent cannot hold a conversation. End
the report with an explicit "Offers" block so the main conversation can put the questions to the
user:

- "Want me to create any of the suggested rules?"
- "Should I build a skill for [repeated workflow]?"
- "Want me to mark resolved errors in errors.md?"

Nothing gets written outside `memory/` reports without the user saying yes.

## Constraints

- Read-only analysis unless user approves actions
- Don't modify existing memory files without permission
- Be specific in suggestions - vague advice isn't useful
- Include evidence (which sessions, which errors) for each pattern
