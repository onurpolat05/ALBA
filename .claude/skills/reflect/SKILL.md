---
name: reflect
description: Cross-session pattern analysis - find recurring themes, derive rules
context: fork
allowed-tools: Read, Write, Glob, Grep
---

# ALBA Reflect

Analyze recent session logs, errors, and learnings to find patterns and suggest improvements.

## When to Use

- After several work sessions (weekly recommended)
- When the same problems keep appearing
- To discover workflow improvements
- To propose new rules based on observed patterns

## Process

### Step 1: Gather Data

Read recent files (last 7 days or last 5 sessions):

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

After presenting the report, ask:
- "Want me to create any of the suggested rules?"
- "Should I build a skill for [repeated workflow]?"
- "Want me to mark resolved errors in errors.md?"

Only act with user approval.

## Constraints

- Read-only analysis unless user approves actions
- Don't modify existing memory files without permission
- Be specific in suggestions - vague advice isn't useful
- Include evidence (which sessions, which errors) for each pattern
