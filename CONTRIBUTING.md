# Contributing to opAgent Starter

Thank you for your interest in contributing! This project thrives on community contributions.

## How to Contribute

### 1. Share Your Setup

The most valuable contribution is sharing how YOU use opAgent:

**Create an example in `examples/`:**

```
examples/
└── [your-role]-setup/
    ├── README.md           # How you use it
    ├── CLAUDE.md           # Your CLAUDE.md (anonymized)
    ├── sample-workflow.md  # Example workflows
    └── skills/             # Your custom skills
```

**What to include:**
- Your role (PM, Developer, Designer, etc.)
- Tools you integrated
- Custom skills you created
- Workflows that work well
- Tips and tricks

### 2. Improve Templates

**Add new skill templates:**
- Research existing skills first
- Follow `templates/skills/SKILL-TEMPLATE.md` structure
- Include clear documentation
- Add usage examples

**Add new hook templates:**
- Test thoroughly before submitting
- Add comments explaining what it does
- Include installation instructions

**Add new docs:**
- Fill gaps in documentation
- Add tutorials
- Create video walkthroughs

### 3. Enhance Setup Flow

**Improve questions:**
- Make discovery questions clearer
- Add new question types for better customization
- Improve role-specific recommendations

**Better onboarding:**
- Simplify initial setup
- Add more guidance for beginners
- Improve error messages

### 4. Fix Bugs

- Check existing issues first
- Create a new issue describing the bug
- Submit a PR with the fix
- Include tests if applicable

### 5. Add Features

**Before adding a feature:**
1. Open an issue to discuss
2. Get feedback from maintainers
3. Ensure it aligns with project goals
4. Keep it simple and user-friendly

---

## Development Setup

### Prerequisites

- Git
- Claude Code CLI
- Bash (for install script)
- Optional: Node.js (for future npm package)

### Local Development

1. Fork the repository
2. Clone your fork:
```bash
git clone https://github.com/your-username/opagent-starter.git
cd opagent-starter
```

3. Create a test workspace:
```bash
./install.sh
# Use a test directory for development
```

4. Make your changes

5. Test thoroughly:
```bash
# Test install script
./install.sh

# Test setup flow
cd test-workspace
claude-code
# Run through setup process
```

6. Commit and push:
```bash
git add .
git commit -m "feat: description of your changes"
git push origin your-branch
```

7. Create a Pull Request

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
fix: correct install script path issue
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
3. **Test thoroughly** on clean install
4. **Keep PRs focused** - one feature/fix per PR
5. **Respond to feedback** promptly

### What Makes a Good PR

✅ **Good:**
- Solves a specific problem
- Includes documentation
- Has examples
- Well-tested
- Clear commit messages

❌ **Avoid:**
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
   - Video tutorials
   - Setup walkthroughs
   - Troubleshooting guides

### Medium Priority

1. **Testing**
   - Automated install tests
   - Template validation
   - Cross-platform testing

2. **Tooling**
   - NPM package
   - VS Code extension
   - Web template gallery

3. **Community**
   - Discord server setup
   - Regular Q&A sessions
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

- **Issues:** For bugs and feature requests
- **Discussions:** For questions and ideas
- **Discord:** [Coming soon]

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

Thank you for making opAgent better! 🚀
