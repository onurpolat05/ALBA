# Decision Protocol

## When Claude Should Ask vs. Act

This guide helps Claude decide when to ask for permission vs. proceed autonomously.

---

## ✅ Act Autonomously (No Permission Needed)

Claude can proceed without asking when:

### 1. Reading Files
- Any file in the workspace
- Documentation, code, configs
- Exception: None (always OK to read)

### 2. Information Gathering
- Web search
- Research
- File exploration
- Tool documentation lookup

### 3. Memory Updates (Specific Files)
- `memory/knowledge/learnings.md` - Record new learnings
- `memory/knowledge/errors.md` - Log error solutions
- `memory/daily/YYYY-MM-DD.md` - Create/update daily logs
- `memory/state/dashboard.md` - Update session context

### 4. Analysis & Suggestions
- Code review
- Recommendations
- Problem diagnosis
- Optimization suggestions

### 5. Non-Destructive Operations
- Searching codebase
- Running read-only commands
- Checking git status
- Listing files

---

## ❓ Ask First (Permission Required)

Claude must ask before:

### 1. Creating New Files/Folders
- New skill definitions
- New hooks
- New project folders
- New documentation
- Exception: Daily logs in `memory/daily/`

### 2. Modifying Core Files
- `CLAUDE.md`
- `.claude/settings.json`
- `.claude/docs/*.md`
- User's core workflow files

### 3. Destructive Operations
- Deleting files
- Overwriting existing work
- Force pushing to git
- Removing configurations

### 4. External Actions
- Sending emails
- Creating tasks in Trello/Notion
- Posting to Slack/social media
- Making API calls that change state

### 5. Significant Decisions
- Architecture choices
- Tool selection (when multiple options)
- Workflow changes
- Priority changes

### 6. Bulk Operations
- Processing many files
- Mass updates
- Batch API calls
- Large-scale refactoring

---

## How to Ask

When asking for permission:

### Use AskUserQuestion for Choices
```
Options:
A) Option 1 (Recommended)
B) Option 2
C) Let me decide
```

### Explain the Why
```
I want to [action] because [reason].
This will [impact].
Should I proceed?
```

### Provide Context
```
Current state: [X]
Proposed change: [Y]
Expected result: [Z]
```

### Offer Alternatives
```
Option A: [Safe, slower]
Option B: [Faster, more risk]
Option C: [Manual approach]
```

---

## Special Cases

### 1. Error Recovery
**Ask when:**
- Multiple solutions possible
- User preference needed
- Risk of data loss

**Act when:**
- Clear, safe fix available
- Documented in `errors.md`
- Non-destructive retry

### 2. Workflow Changes
**Ask when:**
- Changing established patterns
- Introducing new tools
- Modifying core process

**Act when:**
- Minor optimization
- Fixing bugs
- Following user's explicit instructions

### 3. File Operations
**Ask when:**
- Creating new structure
- Moving important files
- Changing file organization

**Act when:**
- Creating daily logs
- Updating memory/knowledge
- Temporary work files

### 4. External Integrations
**Ask when:**
- First time using a tool
- Sending messages to others
- Creating public content

**Act when:**
- Fetching data (read-only)
- Searching/querying
- Internal operations

---

## Examples

### ✅ No Need to Ask

```
User: "What tasks do I have?"
Claude: [Reads todo.md, shows tasks]
```

```
User: "Research AI agents"
Claude: [Uses research skill, returns findings]
```

```
User: "Fix this bug"
Claude: [Diagnoses, implements clear fix]
```

### ❓ Must Ask First

```
User: "Set up a new project"
Claude: "I'll create a project folder and context files.
Should I use the standard template or do you have specific requirements?"
```

```
User: "Send update to the team"
Claude: "I'll post to Slack. Here's a draft:
[Message]
Look good?"
```

```
User: "Organize these files"
Claude: "I see multiple ways to organize:
A) By date
B) By project
C) By type
Which would you prefer?"
```

---

## Decision Tree

```
Is this a read operation or info gathering?
├─ Yes → Act autonomously
└─ No → Continue

Is this updating memory/knowledge files?
├─ Yes (learnings.md, errors.md, daily logs) → Act autonomously
└─ No → Continue

Is this creating new files/folders?
├─ Yes → Ask first
└─ No → Continue

Is this modifying core files (CLAUDE.md, settings)?
├─ Yes → Ask first
└─ No → Continue

Is this a destructive operation?
├─ Yes → Ask first
└─ No → Continue

Is this an external action (email, Slack, etc)?
├─ Yes → Ask first
└─ No → Continue

Multiple valid approaches?
├─ Yes → Ask for preference
└─ No → Act autonomously if safe and clear
```

---

## Guidelines

1. **When in doubt, ask** - Better safe than sorry
2. **Be specific** - Explain what and why
3. **Offer options** - Give user choice
4. **Explain impact** - What will change
5. **Default to safe** - Prefer non-destructive
6. **Learn from feedback** - User says "just do it"? Remember for next time

---

Created: [Date]
