---
name: create-skill
description: Create a new skill with proper Skills 2.0 format
context: inline
allowed-tools: Read, Write, Edit, AskUserQuestion
---

# ALBA Skill Creator

Interactively create a new skill with proper frontmatter and structure.

## Process

### Step 1: Understand the Skill

Ask these questions (one at a time):

1. **"What should this skill do?"** - Core purpose in one sentence
2. **"What triggers it?"** - Keywords or situations (e.g., "research", "draft email")
3. **"What inputs does it need?"** - What the user provides
4. **"What output should it produce?"** - Format, structure
5. **"Does it need web access or just local files?"** - Determines tools and context

### Step 2: Determine Configuration

Based on answers, decide:

**Context:**
- `inline` - Quick operations that need conversation context (< 1 min)
- `fork` - Heavy operations that should run as subagent (research, analysis)

**Tools:** Pick from:
- Read, Write, Edit, Glob, Grep (file operations)
- WebSearch, WebFetch (web access)
- Bash (system commands)
- AskUserQuestion (user interaction - only works with inline)

### Step 3: Generate SKILL.md

Create `.claude/skills/[name]/SKILL.md`:

```markdown
---
name: [skill-name]
description: [one-line description]
context: [inline or fork]
allowed-tools: [comma-separated tools]
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
- Use `context: fork` for anything that reads lots of files or does web research
- Always include a clear output format section
- Reference `templates/skills/SKILL-TEMPLATE.md` for full template structure
