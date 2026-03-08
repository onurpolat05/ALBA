---
name: extend
description: Add new features to your ALBA agent system
context: inline
allowed-tools: [Read, Write, Edit, Glob, Grep, AskUserQuestion]
---

# ALBA Extend

Add new capabilities to the agent system. Interactive and collaborative.

## Step 1: Identify

Ask: "What would you like to add to your agent?"

Types:
1. **Skill** - New capability (research, content creation, task automation...)
2. **Hook** - Automated event response (session start, error logging...)
3. **Rule** - Behavioral guideline (code standards, communication style...)
4. **Command** - Custom /slash command
5. **MCP Integration** - Connect external tool (Trello, Gmail, Calendar...)

## Step 2: Build

### Skills

1. Understand: What task? What inputs/outputs? What tools?
2. Check `templates/skills/` for existing templates
3. Create `.claude/skills/[name]/SKILL.md` with frontmatter:
   ```yaml
   ---
   name: [skill-name]
   description: [what it does]
   context: fork          # fork = subagent (protects context), inline = main context
   allowed-tools: [tools]
   ---
   ```
4. Add to CLAUDE.md Skills table
5. Test immediately

### Hooks

1. Identify event type: SessionStart, Stop, PreToolUse, PostToolUse, UserPromptSubmit, PreCompact
2. Define what should happen when triggered
3. Create `.claude/hooks/[name].sh` and make executable (`chmod +x`)
4. Add to `.claude/settings.json`:
   ```json
   {
     "hooks": {
       "[EventType]": [{ "command": ".claude/hooks/[name].sh" }]
     }
   }
   ```
5. Test by triggering the event

See `templates/hooks/` for examples.

### Rules

1. Understand: When does this apply? What to do/not do? Why?
2. Classify: behavioral, security, process, quality, restriction
3. Create `.claude/rules/[name].md`
4. Rules auto-load from `.claude/rules/` - no CLAUDE.md update needed
5. Verify rule is followed

See `templates/rules/` for examples.

### Commands

1. Define: name, purpose, parameters
2. Create `.claude/commands/[name].md` with description frontmatter
3. Test with /[name]

### MCP Integrations

1. Check if MCP server is already configured (try listing tools)
2. If not configured: guide through authentication setup
3. Create helper skill for common operations
4. Add to CLAUDE.md Tools & Integrations table
5. Test the connection

## Step 3: Verify

- Does it work as expected? (test with real example)
- Is CLAUDE.md updated if needed?
- Does user understand how to use it?

## Guidelines

- Check existing skills/hooks/rules before creating new ones
- Use `templates/` as starting points when available
- Keep it simple - solve the specific need, don't over-engineer
- Test each component immediately after creation
