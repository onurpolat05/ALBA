# Initial Setup Guide - opAgent Starter

**TO CLAUDE CODE:** This guide helps you set up a personalized AI agent system with the user. This is a collaborative, interactive process.

---

## Core Philosophy

**Interactive & User-Centric:**
- Ask questions ONE at a time
- Guide, don't decide
- Build together with the user
- Adapt based on their answers

**Progressive Complexity:**
- Start minimal
- Add features as needed
- Don't overwhelm

---

## Setup Flow

### Phase 1: Discovery (5-7 questions)

Ask these questions naturally, one at a time:

#### Q1: Role & Work
```
"Let's build your personal agent system! First, what's your primary role?"

Options (use AskUserQuestion):
- Software Developer
- Project Manager / Coordinator
- Designer (UI/UX, Graphics)
- Content Creator / Writer
- Business / Operations
- Other (let them specify)
```

#### Q2: Daily Work
```
"What takes up most of your time daily?"

Options (allow multiple):
- Writing/reviewing code
- Managing projects and tasks
- Client/team communication
- Research and learning
- Content creation
- Email/calendar management
- Design work
- Other
```

#### Q3: Pain Points
```
"What frustrates you most in your current workflow?"

Options:
- Too many tools, hard to track everything
- Email/message overload
- Losing track of tasks and priorities
- Manual, repetitive work
- Information scattered everywhere
- Hard to remember context
- Other (let them describe)
```

#### Q4: Tools Currently Used
```
"Which tools do you use regularly?"

Options (allow multiple):
- Trello
- Notion
- Gmail
- Outlook
- Slack
- GitHub
- Google Calendar
- Obsidian
- Other (list them)
```

#### Q5: Automation Goals
```
"What would you like to automate or improve?"

Free text or options:
- Task organization
- Email categorization
- Research workflow
- Content creation
- Team updates
- Meeting notes
- Other
```

#### Q6: Technical Comfort
```
"How comfortable are you with technical setup?"

Options:
- Beginner (keep it simple, guide me)
- Intermediate (I can edit configs, understand basic code)
- Advanced (I'm comfortable with complex setups)
```

#### Q7: Setup Preference
```
"How do you want to start?"

Options:
- Minimal (just the essentials, I'll add more later)
- Standard (common features most people need)
- Custom (I'll pick exactly what I want)
```

---

### Phase 2: Structure Creation

Based on their answers, create the appropriate structure:

#### Step 1: Create Core Structure

**Always create:**
```
user-workspace/
├── memory/
│   ├── state/
│   │   ├── todo.md
│   │   └── current_focus.md
│   ├── knowledge/
│   │   ├── learnings.md
│   │   ├── preferences.md
│   │   └── errors.md
│   └── daily/
├── .claude/
│   ├── settings.json (basic)
│   └── docs/
│       ├── memory-system.md
│       ├── decision-protocol.md
│       └── extend-guide.md
└── CLAUDE.md
```

**Files to customize:**
- `CLAUDE.md` - Based on role, tools, preferences
- `memory/knowledge/preferences.md` - From their answers
- `.claude/settings.json` - Based on technical level

#### Step 2: Initial Content Population

Ask:
```
"Let's populate your system with initial data:

1. What are your top 3 priorities right now?"
   → Add to memory/state/current_focus.md

2. "What tasks are on your plate this week?"
   → Add to memory/state/todo.md

3. "Any specific preferences for how I should communicate?"
   → Add to memory/knowledge/preferences.md
```

#### Step 3: Optional Features (Based on Setup Preference)

**If Minimal:**
- Skip skills, hooks for now
- Add pointer in CLAUDE.md: "See extend-guide.md to add features later"

**If Standard:**
- Ask: "Want me to add a research skill?" (if they mentioned research)
- Ask: "Want automatic session context loading?" (basic hook)

**If Custom:**
- Show available features:
  - Skills (research, task automation, content creation)
  - Hooks (session start/stop, error logging)
  - MCP integrations (based on their tools)
- Let them pick

---

### Phase 3: CLAUDE.md Generation

Create personalized CLAUDE.md based on:

**Template Structure:**
```markdown
# [Name]'s Personal Agent

## Identity & Role
You are [Name]'s personal AI assistant - [executive/development/creative] assistant.

[Role-specific context from Q1]

## Your Job
[Based on Q2 and Q5 - their daily work and automation goals]

## Core Principles
[Based on Q6 - technical level affects communication style]

## Tools & Integrations
[From Q4 - their current tools]

## Memory System
Progressive disclosure - read what's needed:
- Session start → memory/state/
- Errors → memory/knowledge/errors.md
- Learning → memory/knowledge/learnings.md

## Commands
/start - Begin session, load context
/end - Save session, update memory
/extend - Add new features (reads extend-guide.md)

[If they selected features in Phase 2, list them here]

## Extending Your Agent
To add skills, hooks, or new features:
Say "/extend" or "I want to add [feature]"
I'll guide you through it step by step.
```

**Key Customizations:**
- **Beginner:** Simple language, lots of explanations
- **Intermediate:** Technical terms OK, brief explanations
- **Advanced:** Concise, assume knowledge

---

### Phase 4: First Run Test

After structure is created:

1. **Show summary:**
```
"Your agent system is ready! Here's what we set up:

Structure:
- Memory system (tracks tasks, learnings, preferences)
- [Features if any]

Initial data:
- [X] priorities in current_focus.md
- [Y] tasks in todo.md

Next steps:
1. Test it: type '/start'
2. Try a task: [suggest based on their role]
3. Extend anytime: type '/extend'

Ready to try?"
```

2. **Run test:**
```
/start
```

3. **Confirm:**
```
"Does this look good?
- Is the context loaded correctly?
- Does the communication style work for you?
- Any adjustments needed?"
```

---

## Example Flows

**Developer Setup:**
```
User: "I'm a software developer"
Claude: "Great! What takes up most of your time daily?"
User: "Writing code, reviewing PRs, managing tasks"
Claude: "What frustrates you most?"
User: "Losing track of tasks and context switching"
Claude: "Which tools do you use?"
User: "GitHub, Trello, Slack"
Claude: "What would you like to automate?"
User: "Task organization and PR tracking"
Claude: "How comfortable are you with technical setup?"
User: "Advanced"
Claude: "How do you want to start?"
User: "Standard setup"

→ Claude creates:
  - Memory structure
  - CLAUDE.md (developer-focused)
  - GitHub integration guidance
  - Task automation skill
  - Basic hooks
  - Populates with user's tasks

→ Tests with /start
→ User confirms, ready to go
```

**PM Setup:**
```
User: "I'm a project manager"
Claude: "Great! What takes up most of your time?"
User: "Managing projects, client communication, team coordination"
Claude: "What frustrates you?"
User: "Too many tools, hard to track everything"
Claude: "Which tools?"
User: "Trello, Gmail, Slack"
Claude: "Automate what?"
User: "Email categorization, task tracking, client updates"
Claude: "Technical comfort?"
User: "Intermediate"
Claude: "Setup preference?"
User: "Standard"

→ Claude creates:
  - Memory structure (project-focused)
  - CLAUDE.md (PM-focused, client/team oriented)
  - Trello integration
  - Email categorization skill
  - Client communication templates
  - Session hooks

→ Tests /start
→ Confirms, done
```

---

## Key Guidelines

### Communication Style
- **Beginner:** "I'll create a memory system to help you track tasks..."
- **Intermediate:** "Setting up memory/ with state and knowledge folders..."
- **Advanced:** "mkdir memory/{state,knowledge,daily}..."

### File Creation
- Create files progressively (not all at once)
- Show what you created after each step
- Ask for feedback before moving on

### Error Handling
- If user seems confused → simplify
- If they ask for changes → adapt quickly
- If they want to skip something → mark as "can add later"

### Success Markers
- User understands the structure
- User has working CLAUDE.md
- User can run /start successfully
- User knows how to extend later (/extend)

---

## After Setup Complete

Point user to:
1. `.claude/docs/extend-guide.md` - How to add features
2. `memory/knowledge/preferences.md` - Update preferences
3. `/start` command - Begin daily work

**Congratulate them:**
```
"Your personal agent is ready! You can now:
- Use /start to begin sessions
- Add new features with /extend anytime
- Customize in memory/knowledge/preferences.md

Welcome to opAgent!"
```

---

**Remember:** This is collaborative. User is always involved in decisions. Guide, don't dictate.
