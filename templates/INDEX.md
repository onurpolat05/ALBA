# Template Index

This folder contains template files for building your personalized agent system.

## Template Categories

### Memory Templates

Templates for the memory system:

| File | Description | Usage |
|------|-------------|-------|
| `todo.md.template` | Active tasks and goals | Updated daily/weekly |
| `current_focus.md.template` | Current priorities and focus | Updated each session |
| `learnings.md.template` | Accumulated knowledge and insights | Claude auto-updates |
| `preferences.md.template` | User preferences | Updated as needed |
| `daily-log.md.template` | Daily session summary | Claude auto-creates |

**Usage:**
```bash
cp templates/memory/todo.md.template memory/state/todo.md
# Then fill in your own information
```

---

### Skills Templates

Templates for custom capabilities:

| File | Description | Level |
|------|-------------|-------|
| `SKILL-TEMPLATE.md` | Generic skill template | Beginner |
| `research-skill-example.md` | Web research skill example | Intermediate |
| `task-automation-example.md` | Task automation skill example | Intermediate |

**Usage:**
```bash
# Create a new skill
mkdir -p .claude/skills/my-skill
cp templates/skills/SKILL-TEMPLATE.md .claude/skills/my-skill/SKILL.md
# Customize SKILL.md
```

**Learn from examples:**
- `research-skill-example.md` - Research with Exa + Firecrawl
- `task-automation-example.md` - Trello/Notion automation

---

### Hooks Templates

Hook scripts for automated workflows:

| File | Description | Requirement |
|------|-------------|-------------|
| `session-start.sh.template` | Session start hook | Basic |
| `session-stop.sh.template` | Session stop hook | Basic |
| `README-hooks.md` | Hooks system guide | Documentation |

**Usage:**
```bash
# Copy hooks
mkdir -p .claude/hooks
cp templates/hooks/session-start.sh.template .claude/hooks/session-start.sh
cp templates/hooks/session-stop.sh.template .claude/hooks/session-stop.sh

# Make executable
chmod +x .claude/hooks/*.sh

# Add to settings.json (see README-hooks.md)
```

---

### Claude Templates

Core system files:

| File | Description | Priority |
|------|-------------|----------|
| `CLAUDE.md.template` | Main instruction file | **Required** |
| `memory-system.md.template` | Memory system guide | Recommended |
| `decision-protocol.md.template` | Decision-making protocol | Recommended |

**Usage:**
```bash
# Create main file
cp templates/claude/CLAUDE.md.template CLAUDE.md
# Customize with your info (name, role, preferences)

# Create docs
mkdir -p .claude/docs
cp templates/claude/memory-system.md.template .claude/docs/memory-system.md
cp templates/claude/decision-protocol.md.template .claude/docs/decision-protocol.md
```

---

## Setup Scenarios

### Minimal Setup (5 minutes)

Just the essentials:

```bash
# 1. Main instruction
cp templates/claude/CLAUDE.md.template CLAUDE.md

# 2. Memory state
mkdir -p memory/state
cp templates/memory/todo.md.template memory/state/todo.md
cp templates/memory/current_focus.md.template memory/state/current_focus.md

# 3. Customize and test
```

### Standard Setup (15 minutes)

Full-featured system:

```bash
# 1. Claude core
cp templates/claude/CLAUDE.md.template CLAUDE.md
mkdir -p .claude/docs
cp templates/claude/*.md.template .claude/docs/

# 2. Memory structure
mkdir -p memory/{state,knowledge,projects,daily}
cp templates/memory/*.template memory/knowledge/
cp templates/memory/todo.md.template memory/state/
cp templates/memory/current_focus.md.template memory/state/

# 3. Skill (optional)
mkdir -p .claude/skills/research
cp templates/skills/research-skill-example.md .claude/skills/research/SKILL.md

# 4. Customize
```

### Advanced Setup (30 minutes)

Hooks + Skills + Full Integration:

```bash
# Standard setup +

# 1. Hooks
mkdir -p .claude/hooks
cp templates/hooks/*.sh.template .claude/hooks/
chmod +x .claude/hooks/*.sh

# 2. Multiple skills
# Copy and customize template for each skill

# 3. Configure settings.json
# 4. MCP integrations
```

---

## Template Customization Guide

### 1. Placeholders

Templates contain these placeholders:

- `[User Name]` - Your name
- `[Date]` - Today's date
- `[Role]` - Your role (PM, Developer, Designer, etc.)
- `[Tool 1]`, `[Tool 2]` - Tools you use
- `[Primary function]` - Main functions

### 2. Remove/Add

Templates are generic - delete unnecessary parts:
- Tools you don't use
- Features you don't need
- Irrelevant sections

### 3. Add Your Own Sections

Add custom sections to templates:
- Custom workflows
- Domain-specific knowledge
- Team rules

---

## Help & Support

### Template Selection by Role

- **PM** - task-automation skill + Trello integration
- **Developer** - minimal setup, git workflow
- **Designer** - asset management, feedback collection
- **Content Creator** - research skill + content skill

### Template Selection by Technical Level

- **Beginner** - Minimal setup, no hooks
- **Intermediate** - Standard setup, basic hooks
- **Advanced** - Full setup, custom skills

### FAQ

**Q: Should I use all templates?**
A: No, pick what you need. Start minimal, add over time.

**Q: How do I customize templates?**
A: Copy, replace `[placeholders]`, delete unnecessary parts, add your own.

**Q: Should I use the skill template or example?**
A: Look at the example to understand the pattern, use the template for your own skill.

**Q: Are hooks required?**
A: No, they're an advanced feature. Optional for beginners.

---

## Next Steps

1. Review templates
2. Choose your scenario (minimal/standard/advanced)
3. Copy and customize
4. Test with Claude Code
5. Extend as needed

**Ready?** Run `/setup` in Claude Code to begin!

---

Created: 2025-01-09
Based on: opAgent v1.0
