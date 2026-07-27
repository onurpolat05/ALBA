---
name: extend
description: Add one new capability to an existing ALBA setup - skill, hook, rule, slash command or MCP integration - interactively, then wire it into CLAUDE.md and settings.json. Use when user says "add a skill", "add a hook", "I want a rule for X", "connect Trello/Gmail/Linear", "extend my agent", "can ALBA also do X". Do NOT use for first-time setup (use /setup). If the user already knows they want a skill, /create-skill goes straight to writing SKILL.md - /extend is the router for when the component type is still open.
context: inline
effort: medium
argument-hint: "[skill|hook|rule|command|mcp]"
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
   description: [what it does]. Use when user says "x", "y". Do NOT use for [z].
   context: fork          # fork = subagent (protects context), inline = main context
   background: false      # fork only: wait for the result in this turn (fork defaults to background)
   allowed-tools: [tools]
   ---
   ```
   The `description` is the only field that decides whether the skill fires at the right moment —
   a bare one-line summary will not trigger reliably. Full field reference:
   `templates/skills/SKILL-TEMPLATE.md`.
4. Add to CLAUDE.md Skills table
5. Test immediately

### Hooks

1. Identify the event. Common ones: `SessionStart`, `UserPromptSubmit`, `PreToolUse`,
   `PostToolUse`, `PostToolUseFailure`, `Stop`, `SubagentStop`, `PreCompact`, `PostCompact`,
   `SessionEnd`. Claude Code v2.1.220 defines 30 events — see `templates/hooks/README-hooks.md`
   for the full list and each one's output contract.
2. Define what should happen when triggered
3. Create `.claude/hooks/[name].sh` and make executable (`chmod +x`)
4. Add to `.claude/settings.json` — note the **nested** `hooks` array; skipping the inner level is
   the most common reason a newly added hook never runs:
   ```json
   {
     "hooks": {
       "[EventType]": [
         {
           "matcher": "Bash",
           "hooks": [
             {
               "type": "command",
               "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/[name].sh",
               "timeout": 5
             }
           ]
         }
       ]
     }
   }
   ```
   `matcher` only applies to tool events. Use `${CLAUDE_PROJECT_DIR}` rather than a relative path,
   or the hook breaks for sessions started from a subdirectory.
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
