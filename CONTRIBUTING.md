# Contributing to ALBA

Thank you for your interest in contributing! This project thrives on community contributions.

## Project Structure

```
alba/
├── CLAUDE.md                  # Minimal starter (replaced by /setup)
├── .claude/skills/            # setup/ and extend/ skills
├── templates/                 # Source templates
│   ├── claude/                # CLAUDE.md + docs templates
│   ├── memory/                # Memory templates
│   ├── hooks/                 # Hook script templates (6)
│   ├── rules/                 # Rule templates (2)
│   ├── skills/                # Skill templates
│   └── agents/                # Agent definition templates
├── examples/                  # Role-based example setups
└── docs/                      # PRD, development guide
```

## Contribution Types

### 1. Skill Templates

Add new skill templates under `templates/skills/`. Use frontmatter format:

```yaml
---
name: skill-name
description: What this skill does
context: When to use it
allowed-tools: [Read, Write, Bash, etc.]
---
```

Follow `templates/skills/SKILL-TEMPLATE.md` for the full structure.

### 2. Hook Recipes

Bash scripts for Claude Code events. Add under `templates/hooks/`.

- Test thoroughly before submitting
- Add comments explaining what it does
- Follow existing hook patterns (see `templates/hooks/README-hooks.md`)

### 3. Rule Templates

Auto-loaded files for `.claude/rules/`. Add under `templates/rules/`.

- Keep rules focused and actionable
- Follow existing format in `templates/rules/`

### 4. Example Setups

Role-based complete configurations under `examples/`:

```
examples/
└── [your-role]/
    ├── README.md           # How you use it
    ├── CLAUDE.md           # Your CLAUDE.md (anonymized)
    └── ...                 # Custom skills, memory, etc.
```

**What to include:**
- Your role (PM, Developer, Designer, etc.)
- Tools you integrated
- Custom skills you created
- Workflows that work well
- Tips and tricks

### 5. Agent Definitions

Agent templates under `templates/agents/`. Define reusable agent personas with clear roles and capabilities.

### 6. Documentation Improvements

- Fill gaps in documentation
- Add tutorials and walkthroughs
- Improve existing guides in `docs/`

---

## Development Setup

### Prerequisites

- Git
- Claude Code CLI (`claude`)

### Local Development

1. Fork the repository

2. Clone your fork:
```bash
git clone https://github.com/your-username/alba.git
cd alba
```

3. Test the setup flow:
```bash
claude
# Run /setup to test the full flow
```

4. Make your changes

5. Verify your changes:
```bash
# After modifying templates, run /setup again
# to confirm the flow still works correctly
claude
# /setup
```

6. Commit and push:
```bash
git add .
git commit -m "feat: description of your changes"
git push origin your-branch
```

7. Create a Pull Request against [onurpolat05/alba](https://github.com/onurpolat05/alba)

---

## Contribution Guidelines

### Code Style

**Markdown:**
- Use clear headings
- Include code examples
- Keep lines under 100 characters

**Bash Scripts:**
- Use shellcheck for validation
- Add comments for complex logic
- Include error handling
- Test on multiple systems

**Documentation:**
- Write for beginners
- Use examples
- Keep it concise
- Link to related docs

### Commit Messages

Use conventional commits:

```
feat: add new skill template for email automation
fix: correct template path issue
docs: improve setup flow documentation
chore: update dependencies
```

Types:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation only
- `style:` Formatting, no code change
- `refactor:` Code restructuring
- `test:` Adding tests
- `chore:` Maintenance

### Pull Request Process

1. **Update documentation** if needed
2. **Add examples** if adding features
3. **Test thoroughly** - run `/setup` after template changes
4. **Keep PRs focused** - one feature/fix per PR
5. **Respond to feedback** promptly

### What Makes a Good PR

**Good:**
- Solves a specific problem
- Includes documentation
- Has examples
- Well-tested
- Clear commit messages

**Avoid:**
- Multiple unrelated changes
- Breaking existing functionality
- No documentation
- Untested changes

---

## Areas Needing Help

### High Priority

1. **Example Setups**
   - Real-world use cases
   - Different roles and workflows
   - Integration examples

2. **Skill Templates**
   - Email automation
   - Calendar management
   - Data analysis
   - Content generation

3. **Documentation**
   - Tutorials
   - Setup walkthroughs
   - Troubleshooting guides

### Medium Priority

1. **Testing**
   - Template validation
   - Cross-platform testing

2. **Tooling**
   - NPM package
   - Web template gallery

3. **Community**
   - Discord server setup
   - Showcase examples

---

## Community Guidelines

### Be Respectful

- Treat everyone with respect
- No harassment or discrimination
- Constructive feedback only
- Help beginners

### Be Collaborative

- Share knowledge
- Give credit
- Build on others' work
- Ask for help when needed

### Be Patient

- Remember everyone's learning
- Maintainers are volunteers
- Reviews take time
- Progress over perfection

---

## Questions?

- **Issues:** [github.com/onurpolat05/alba/issues](https://github.com/onurpolat05/alba/issues)
- **Discussions:** [github.com/onurpolat05/alba/discussions](https://github.com/onurpolat05/alba/discussions)

---

## Recognition

Contributors will be:
- Listed in README
- Credited in releases
- Featured in community showcases

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for making ALBA better!
