# Extend System Guide - opAgent Starter

**TO CLAUDE CODE:** This guide helps you extend the user's agent system with new features. User is requesting to add something new - work with them interactively.

---

## When to Use This Guide

User triggers this when they say:
- "I want to add a skill"
- "Can you create a hook for..."
- "I need a new command"
- "Add integration for [tool]"
- "/extend" command

---

## Extension Philosophy

**Collaborative Building:**
- Understand what they want to achieve
- Suggest the right approach
- Build it together
- Test immediately
- Document for future

**Keep It Simple:**
- Solve their specific need
- Don't over-engineer
- Make it maintainable

---

## Extension Types

### 1. Skills (New Capabilities)

**User says:**
- "I want to add a research skill"
- "Create a skill for [X]"
- "I need to automate [Y]"

**Your Process:**

#### Step 1: Understand the Need
```
"Let me understand what you want to do:

1. What task do you want to automate?
2. What inputs will you provide?
3. What should the output be?
4. Any tools/APIs needed?"
```

#### Step 2: Check if Skill Already Exists
```
Look in:
- .claude/skills/ (user's existing skills)
- templates/skills/ (available templates)

If similar exists:
"I found a similar skill: [name]
Want to use that as a starting point or create from scratch?"
```

#### Step 3: Create Skill Structure
```
.claude/skills/[skill-name]/
├── SKILL.md           # Documentation
└── [optional files]   # Helpers, configs
```

#### Step 4: Write SKILL.md Together

Ask:
```
"Let's define your skill:

1. **Name:** What should we call it?
2. **Trigger:** What keywords should trigger it?
   Example: "research", "find info", "investigate"

3. **Process:** What steps should it take?
   Example:
   - Search web for [topic]
   - Extract key points
   - Return summary

4. **Tools needed:**
   - Rube MCP (Exa, Firecrawl)?
   - Other APIs?
   - File operations?"
```

Use template from `templates/skills/SKILL-TEMPLATE.md` and customize based on answers.

#### Step 5: Update CLAUDE.md
```
Add to Skills section:
| [skill-name] | [When to use] |
```

#### Step 6: Test
```
"Let's test your new skill:
[Demonstrate with an example]

Does this work as expected?"
```

**Example Skill Creation:**

```
User: "I want to add a competitor analysis skill"

Claude: "Great! Let me understand:
1. What do you want to analyze about competitors?"
User: "Their features, pricing, reviews"

Claude: "What will you provide as input?"
User: "Company names or URLs"

Claude: "What output format?"
User: "Comparison table"

Claude: "Which tools?"
User: "Web research, maybe their websites"

Claude: [Creates .claude/skills/competitor-analysis/SKILL.md with:]
- Trigger: "analyze competitor", "compare with"
- Process: Web search → Scrape sites → Extract data → Format table
- Tools: Rube MCP (Exa + Firecrawl)
- Output: Markdown table

[Updates CLAUDE.md]
[Tests with: "Analyze competitor: Notion"]
```

---

### 2. Hooks (Automated Workflows)

**User says:**
- "Can you automatically [X] when I [Y]?"
- "Create a hook for..."
- "I want to automate [workflow]"

**Your Process:**

#### Step 1: Identify Hook Type
```
"What event should trigger this?

Options:
- SessionStart: When Claude Code starts
- Stop: When session ends
- PreToolUse: Before any tool execution
- PostToolUse: After any tool execution
- [Custom event]"
```

#### Step 2: Define Action
```
"What should happen when triggered?

Examples:
- Load specific files
- Run a command
- Update a file
- Send a notification
- Log something"
```

#### Step 3: Check Technical Level
```
Read from memory/knowledge/preferences.md:
- Beginner → Simple hooks only
- Intermediate → Standard bash hooks
- Advanced → Complex logic OK
```

#### Step 4: Create Hook Script
```
.claude/hooks/[hook-name].sh

Based on their technical level:
- Beginner: Simple, well-commented
- Intermediate: Standard bash
- Advanced: Complex logic OK
```

#### Step 5: Update settings.json
```
Add to .claude/settings.json:
{
  "hooks": {
    "[HookType]": {
      "command": ".claude/hooks/[hook-name].sh"
    }
  }
}
```

#### Step 6: Test Hook
```
"Let's test your hook:
[Trigger the event]

Did it work as expected?"
```

**Example Hook Creation:**

```
User: "Can you automatically load my project context when I start?"

Claude: "Sure! This is a SessionStart hook.
What should it load?"
User: "Show me current focus and active projects"

Claude: "Any specific format?"
User: "Just a summary, keep it brief"

Claude: [Creates .claude/hooks/project-context.sh:]
#!/bin/bash
echo "=== Today's Focus ==="
head -10 memory/state/current_focus.md
echo ""
echo "=== Active Projects ==="
grep "Status: Active" memory/projects/*/context.md

[Updates .claude/settings.json]
[Tests by restarting session]

"Did you see your project context load?"
```

---

### 3. Commands (Custom Shortcuts)

**User says:**
- "I want a /[command] shortcut"
- "Can I create a custom command?"
- "Add a quick command for [X]"

**Your Process:**

#### Step 1: Define Command
```
"Let's create your command:

1. **Name:** What should the command be called?
   Example: /standup, /review, /sync

2. **Purpose:** What should it do?
   Example: Generate daily standup report

3. **Inputs:** Any parameters needed?
   Example: /sync [project-name]
   Or just: /standup (no params)"
```

#### Step 2: Define Action
```
"What should happen when you run /[command]?

Options:
- Read specific files → format → output
- Run a workflow → return result
- Create/update files
- Trigger a skill
- Combination of above"
```

#### Step 3: Implement as Command File
```
Create .claude/commands/[command].md:

---
description: [What this command does]
---

[Instructions for Claude when command is run]
```

**Example Command Creation:**

```
User: "I want a /standup command"

Claude: "Great! What should /standup do?"
User: "Show yesterday's work and today's plan"

Claude: "Where should I get that info from?"
User: "Yesterday's daily log and current_focus.md"

Claude: "Any specific format?"
User: "Just bullet points"

Claude: [Creates .claude/commands/standup.md:]
---
description: Generate daily standup report
---

Generate a standup report:
1. Read yesterday's daily log (memory/daily/YYYY-MM-DD.md)
2. Read current_focus.md
3. Format as:
   **Yesterday:**
   - [Completed tasks]

   **Today:**
   - [Priorities]

   **Blockers:**
   - [If any]

[Tests: "/standup"]
"Here's your standup report. Looks good?"
```

---

### 4. MCP Integrations (Tool Connections)

**User says:**
- "I want to connect [tool]"
- "Add integration for [service]"
- "Can you access my [Trello/Gmail/etc]?"

**Your Process:**

#### Step 1: Check if MCP Available
```
Common tools:
- Trello, Notion → Rube MCP
- Gmail, Outlook → Rube MCP
- Slack → Rube MCP
- GitHub → Rube MCP (may need connection)
- Firecrawl, Exa → Rube MCP
- Others → Check available MCPs
```

#### Step 2: Connection Setup
```
"To connect [tool], I need to:
1. Check if MCP is configured
2. Create connection (may need auth)
3. Store connection details
4. Test connection

This will open a browser for authentication. Ready?"
```

#### Step 3: Use RUBE_MANAGE_CONNECTIONS
```
- Call RUBE_MANAGE_CONNECTIONS for the toolkit
- Get redirect URL
- Show user: "Please visit [URL] to authorize"
- Wait for confirmation
```

#### Step 4: Add to CLAUDE.md
```
## Tools & Integrations
| [Tool] | [Purpose] | [Access via MCP] |
```

#### Step 5: Create Helper Patterns
```
"Now that [tool] is connected, what do you want to do with it?

Common patterns:
- Fetch data (read tasks, emails, etc)
- Create items (new task, send email)
- Update items
- Search/filter

I can create a skill for common operations."
```

**Example Integration:**

```
User: "I want to connect my Trello"

Claude: "Great! What do you want to do with Trello?"
User: "Fetch my tasks and add new ones"

Claude: [Calls RUBE_SEARCH_TOOLS for Trello]
[Gets Trello tools available]
[Calls RUBE_MANAGE_CONNECTIONS for trello]

"I found Trello integration via Rube MCP.
Please visit this URL to authorize:
[redirect_url]

Let me know when you've authorized."

User: "Done"

Claude: [Tests connection with RUBE_MULTI_EXECUTE_TOOL]
"Trello connected! I can now:
- Fetch your boards and cards
- Create new cards
- Update existing cards

Want me to create a skill for common Trello operations?"

User: "Yes, create a 'fetch today's tasks' skill"

Claude: [Creates .claude/skills/trello-today/SKILL.md]
[Adds to CLAUDE.md]
```

---

### 5. Rules (Behavioral Guidelines)

**User says:**
- "Always [do X] when [Y]"
- "Never [do X]"
- "I prefer [X] over [Y]"
- "Add a rule for..."

**Your Process:**

#### Step 1: Understand the Rule
```
"Let me understand your rule:

1. **When:** What triggers this rule?
   Example: "When I ask for code review"

2. **Do:** What should I do/not do?
   Example: "Always check for security issues"

3. **Why:** Why is this important?
   Example: "We had security vulnerabilities before""
```

#### Step 2: Classify Rule Type
```
Types:
- Behavioral (how to communicate)
- Process (workflow steps)
- Decision (when to ask vs act)
- Quality (code standards, output format)
- Restriction (what not to do)
```

#### Step 3: Add to Appropriate Place

**Behavioral/Communication → memory/knowledge/preferences.md:**
```
## Communication Rules
- [Rule description]
- [When it applies]
```

**Process/Workflow → CLAUDE.md:**
```
## Workflow Rules
### [Rule Name]
When: [Trigger]
Do: [Action]
Why: [Reason]
```

**Decision Rules → .claude/docs/decision-protocol.md:**
```
## Custom Decision Rules
- [Rule]: [When to ask vs act]
```

**Quality Standards → .claude/rules/ (create if needed):**
```
.claude/rules/
├── code-review.md
├── content-creation.md
└── research-standards.md
```

#### Step 4: Update CLAUDE.md Reference
```
Add pointer in relevant section:
"See .claude/rules/[rule-file].md for details"
```

**Example Rule Creation:**

```
User: "Always check for TypeScript errors before committing code"

Claude: "Got it! Let me add this rule.
When should I check?"
User: "Whenever I ask you to commit changes"

Claude: "Should I block the commit if errors found?"
User: "Yes, show me the errors first"

Claude: [Creates .claude/rules/pre-commit.md:]
# Pre-Commit Rules

## TypeScript Error Check
**When:** User requests git commit
**Do:**
1. Run `tsc --noEmit` to check for TypeScript errors
2. If errors found:
   - List all errors
   - Ask user to fix before committing
   - Do NOT proceed with commit
3. If no errors:
   - Proceed with commit

**Why:** Prevent TypeScript errors in repository

[Updates CLAUDE.md:]
## Workflow Rules
- Before commits: Check .claude/rules/pre-commit.md

[Tests with: "Commit my changes"]
"I'll check for TypeScript errors first..."
```

---

## General Extension Guidelines

### Before Creating Anything

1. **Check if it exists:**
   - Look in user's .claude/ folder
   - Check templates/ for similar features
   - Ask: "Want to use existing or create new?"

2. **Understand the need:**
   - What problem are you solving?
   - What's the desired outcome?
   - Any constraints or preferences?

3. **Propose approach:**
   - "Here's how I suggest we do this..."
   - "Alternative: [other approach]..."
   - "Which do you prefer?"

### During Creation

1. **Show, don't hide:**
   - Show what you're creating
   - Explain why you're doing it this way
   - Ask for feedback

2. **Test immediately:**
   - Don't wait until the end
   - Test each component
   - Fix issues on the spot

3. **Document as you go:**
   - Update CLAUDE.md
   - Add comments in code
   - Create usage examples

### After Creation

1. **Verify it works:**
   - Run a real-world test
   - Ask user to try it
   - Fix any issues

2. **Update documentation:**
   - CLAUDE.md (if new capability)
   - memory/knowledge/ (if new pattern)
   - .claude/docs/ (if complex feature)

3. **Suggest next steps:**
   - Related features they might want
   - How to customize further
   - Where to find documentation

---

## Extension Templates

Quick reference for common requests:

### "Add research skill"
→ Use `templates/skills/research-skill-example.md`
→ Customize for their use case
→ Requires Rube MCP (Exa + Firecrawl)

### "Add task automation"
→ Use `templates/skills/task-automation-example.md`
→ Connect to their tool (Trello/Notion)
→ Requires Rube MCP

### "Auto-load context on start"
→ Use `templates/hooks/session-start.sh.template`
→ Customize what to load
→ Update settings.json

### "Connect my [tool]"
→ Check if Rube MCP supports it
→ Use RUBE_MANAGE_CONNECTIONS
→ Create helper skill if needed

### "Always do [X]"
→ Classify as rule type
→ Add to appropriate location
→ Update CLAUDE.md reference

---

## Success Criteria

Extension is complete when:
- User understands what was added
- It works as expected (tested)
- Documented (CLAUDE.md or docs/)
- User knows how to use it
- User can modify it later if needed

---

## Remember

**User is in control:**
- Guide, don't impose
- Explain tradeoffs
- Let them decide

**Keep it maintainable:**
- Simple over clever
- Well-documented
- Easy to modify

**Build iteratively:**
- Start small
- Test often
- Expand as needed

**This is their system:**
- Adapt to their style
- Follow their preferences
- Empower them to customize

---

**Ready to extend! Let's build together.**
