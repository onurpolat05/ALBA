# opAgent Starter

**Build your own AI personal assistant with Claude Code**

An interactive setup system that creates a customized AI agent workspace tailored to your role, workflow, and tools.

---

## What is opAgent?

opAgent Starter is an open-source template for building personalized AI agent systems powered by Claude Code. Instead of a one-size-fits-all solution, it asks you questions about your work and builds a system specifically for you.

### What makes it different?

- **Interactive Setup:** Answer 5-7 questions, get a personalized agent
- **User-Centric:** You're involved in every decision, no black boxes
- **Extensible:** Easily add skills, hooks, and integrations after setup
- **Dynamic but Simple:** Adapts to your needs without overwhelming complexity

---

## Perfect For

| Role | What You Get |
|------|--------------|
| **Project Managers** | Task tracking, email categorization, client updates, Trello/Notion integration |
| **Developers** | Code organization, PR tracking, GitHub integration, development workflows |
| **Designers** | Asset management, feedback collection, design system workflows |
| **Content Creators** | Research automation, content generation, social media scheduling |
| **Anyone** | Customized to your specific workflow and tools |

---

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/onurpolat05/opagent-starter.git my-agent
cd my-agent
```

### 2. Open Claude Code

```bash
claude
```

### 3. Run Setup

```
/setup
```

### 4. Answer Questions & Done!

The setup asks about your role, tools, and preferences, then builds your personalized agent system.

---

## Features

### Core System

- **Memory System:** Tracks your tasks, priorities, learnings, and preferences
- **Progressive Disclosure:** Loads only what's needed, when needed
- **Self-Improving:** Learns from errors and records insights automatically
- **Customizable:** Every aspect can be tailored to your workflow

### What Gets Created

After setup, you'll have:

```
your-workspace/
├── memory/
│   ├── state/              # Current tasks and focus
│   ├── knowledge/          # Learnings and preferences
│   └── daily/              # Session logs
├── .claude/
│   ├── commands/           # Custom commands (/start, /end, etc.)
│   ├── skills/             # Custom capabilities
│   ├── hooks/              # Automation workflows
│   └── docs/               # Documentation
└── CLAUDE.md               # Your agent's core instructions
```

### Extensibility

Add new features anytime:

```
"I want to add a research skill"
→ Claude guides you through creating it

"Create a hook to auto-load context"
→ Built together, step by step

"Connect my Trello account"
→ Interactive MCP setup
```

---

## How It Works

### Phase 1: Discovery (5-7 questions)

```
1. What's your role? (PM, Developer, Designer, etc.)
2. What takes up your time daily?
3. What frustrates you most?
4. Which tools do you use?
5. What do you want to automate?
6. Technical comfort level?
7. Setup preference? (Minimal/Standard/Custom)
```

### Phase 2: Build Together

Based on your answers, Claude creates:
- Personalized CLAUDE.md (your agent's instructions)
- Memory system structure
- Initial content (your tasks, priorities)
- Optional features (skills, hooks, integrations)

### Phase 3: Test & Confirm

- Run `/start` to test
- Verify everything works
- Make adjustments
- You're ready to go!

### Phase 4: Extend Anytime

After setup:
- `/start` - Begin daily session
- `/end` - Save session summary
- `/status` - Quick status check
- `/extend` - Add new features

---

## Examples

See the `examples/` directory for real-world setups:

- **software-engineer/** - Developer-focused setup with research skills and task management

### Example: Developer Setup

```
User: "I'm a software developer"
→ What takes up your time? "Writing code, reviewing PRs, research"
→ Tools? "GitHub, Notion, Slack"
→ Automate? "Research workflow, task organization"
→ Tech level? "Advanced"

Result:
✓ Developer-focused CLAUDE.md
✓ GitHub integration guidance
✓ Task automation skill
✓ Research skill for technical docs
✓ Session hooks for context loading
```

---

## Architecture

### Two-Phase System

**1. Initial Setup** (`setup/initial-setup.md`)
- Interactive question flow
- Structure creation
- Personalized CLAUDE.md generation
- First-run testing

**2. Extension System** (`setup/extend-system.md`)
- Add skills (new capabilities)
- Create hooks (automation)
- Add commands (shortcuts)
- Connect tools (MCP integrations)
- Define rules (behavioral guidelines)

### Key Design Principles

1. **User Involvement:** Never decide alone, always collaborate
2. **Progressive Complexity:** Start simple, grow as needed
3. **Maintainability:** Simple over clever, well-documented
4. **Adaptability:** Works for any role, workflow, or tool set

---

## Documentation

| Document | Purpose |
|----------|---------|
| `setup/initial-setup.md` | Interactive first-time setup guide |
| `setup/extend-system.md` | Adding features after setup |
| `templates/` | All template files (memory, skills, hooks) |
| `templates/INDEX.md` | Template reference and guide |
| `examples/` | Real-world setup examples |

---

## Requirements

- **Claude Code** (CLI) - [Install here](https://docs.anthropic.com/en/docs/claude-code)
- **Git** (for cloning)

---

## Contributing

Contributions welcome! Here's how:

### Adding Templates

- New skill templates → `templates/skills/`
- New hook examples → `templates/hooks/`
- New docs → `templates/claude/`

### Sharing Use Cases

- Add to `examples/` directory
- Share your setup config
- Document what works for your role

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## Roadmap

- [ ] More example setups (PM, Designer, Content Creator)
- [ ] Web-based template gallery
- [ ] Video tutorials
- [ ] Community skill library
- [ ] VS Code extension integration

---

## Inspiration

This project was inspired by:
- Personal productivity systems (GTD, PARA, Zettelkasten)
- CLI setup tools (create-react-app, vue-cli)
- The need for personalized AI workflows
- The power of Claude Code for agent building

---

## License

MIT License - see [LICENSE](LICENSE) for details

---

## Community

- **Issues:** [GitHub Issues](https://github.com/onurpolat05/opagent-starter/issues)
- **Discussions:** [GitHub Discussions](https://github.com/onurpolat05/opagent-starter/discussions)
- **Examples:** Share your setup in the `examples/` directory

---

## FAQ

### Do I need technical knowledge?

No! The system adapts to your technical level. Beginners get simple setups with lots of guidance.

### Can I use this with my existing Claude Code setup?

Yes! Clone to a new directory and run `/setup`.

### What if I want to change something after setup?

Everything is customizable. Edit CLAUDE.md, memory files, or use `/extend` to add features.

### Can I share my setup with my team?

Yes! You can share your config and templates.

---

## Get Started

```bash
git clone https://github.com/onurpolat05/opagent-starter.git my-agent
cd my-agent
claude
```

Then run `/setup` and follow the prompts.

**Build your personalized AI agent in under 10 minutes.**

---

**Made with care by the opAgent community**

[Star on GitHub](https://github.com/onurpolat05/opagent-starter) | [Discussions](https://github.com/onurpolat05/opagent-starter/discussions)
