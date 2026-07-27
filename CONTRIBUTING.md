# Contributing to ALBA

Thank you for your interest in contributing! This project thrives on community contributions.

## Project Structure

```
alba/
├── CLAUDE.md                  # Entry point (replaced by /setup)
├── README.md                  # + README.tr.md, README.de.md
├── CHANGELOG.md
├── .claude/                   # ALBA's own setup
│   ├── skills/                # Pre-built skills (9 total)
│   │   ├── setup/             # /setup - interactive setup wizard
│   │   ├── start/             # /start - session start
│   │   ├── end/               # /end - session end
│   │   ├── status/            # /status - quick overview
│   │   ├── research/          # /research - web research (fork)
│   │   ├── weekly-review/     # /weekly-review - weekly performance review
│   │   ├── extend/            # /extend - add features
│   │   ├── reflect/           # /reflect - pattern analysis
│   │   └── create-skill/      # /create-skill - skill creation wizard
│   └── docs/                  # Reference docs (lazy-loaded)
├── templates/                 # SINGLE SOURCE OF TRUTH - edit here
│   ├── INDEX.md               # Which template generates which file
│   ├── settings.json.template # Canonical hook wiring + permissions
│   ├── claude/                # CLAUDE.md + doc templates (6)
│   ├── memory/                # Memory file templates (5)
│   ├── hooks/                 # Hook script templates (8) + README-hooks.md
│   ├── rules/                 # Rule templates (3)
│   ├── agents/                # Agent templates (1)
│   └── skills/                # Skill reference guides (3)
├── tools/
│   ├── sync-examples.sh       # Regenerate examples/ from templates/
│   └── doctor.sh              # Health check - run before every PR
├── examples/                  # Role-based example setups (5)
│   └── [role]/
│       ├── CLAUDE.md          # role-specific, hand-written
│       ├── README.md          # role-specific, hand-written
│       ├── memory/            # role-specific, hand-written
│       └── .claude/           # GENERATED from templates/ - do not edit
└── assets/                    # Logo, banner, social preview
```

The `.claude/hooks/` and `.claude/rules/` directories do not exist at the repository root — `/setup` creates them in *your* project from `templates/`.

---

## The One Rule: `templates/` Is the Only Place You Edit

Everything under `examples/*/.claude/` is generated. Never edit it by hand.

**Why:** each hook script, doc and settings file used to exist in six independent copies — once in `templates/` and once per example role. A fix applied to one copy silently skipped the other five. This is not hypothetical: by v1.1.0 the example docs had drifted a full release behind their templates, and the example security rules were missing two sections the template had gained. Nobody noticed, because nothing errors when documentation is quietly wrong.

Before opening a PR:

```bash
tools/sync-examples.sh        # project templates/ into examples/
tools/doctor.sh               # health check - must pass
```

`tools/sync-examples.sh --check` reports drift without changing anything and exits non-zero if it finds any, so it also works as a CI gate.

Role-specific files — an example's `CLAUDE.md`, `README.md` and `memory/` — are never overwritten by the sync. Those are what an example is actually for.

## Contribution Types

### 1. Skill Templates

Add new skill templates under `templates/skills/`. Use frontmatter format:

```yaml
---
name: skill-name
description: What it does. Use when user says "x", "y". Do NOT use for z.
context: fork              # fork = subagent, inline = main conversation
background: false          # fork only - wait for the result in this turn
allowed-tools: [Read, Write, Bash]
---
```

`description` is the only text Claude reads when deciding whether to invoke your skill, so it must carry both trigger phrases and a negative boundary. A one-line definition of what the skill does will not fire reliably.

If you set `context: fork` and expect the answer in the same turn, you must also set `background: false` — forked skills default to running detached.

Follow `templates/skills/SKILL-TEMPLATE.md` for the full frontmatter reference.

### 2. Hook Recipes

Bash scripts for Claude Code events. Add under `templates/hooks/`.

Hooks are the only part of an ALBA setup that runs without the model deciding to, and they fail **silently** — a broken hook exits 0, prints nothing, and the feature simply never happens. Everything below exists because one of these mistakes shipped in ALBA itself.

**Hard requirements:**

- **The event name must be one of the 30 real hook events.** A misspelled or invented event name is accepted without complaint and never fires. The full list is in `templates/hooks/README-hooks.md`; `tools/doctor.sh` checks yours against it.
- **Use `${CLAUDE_PROJECT_DIR}` in the command path.** A relative path (`bash .claude/hooks/x.sh`) resolves against the session's working directory and breaks the moment someone opens Claude Code in a subdirectory.
- **Keep the inner `hooks` array.** Each entry under an event name is `{matcher?, hooks: [...]}`. Flattening it installs nothing, silently.
- **Never return `allow` from a `PreToolUse` hook.** `permissionDecision: "allow"` *skips the user's permission prompt*. A validator that approves whatever its blocklist missed does not add a safety layer — it removes the one that was already there. Emit `deny` on a match, and **no output at all** otherwise, so the normal permission flow applies unchanged. `tools/doctor.sh` fails the build on an `allow`.
- **Read the documented input field.** Field names differ per event and are not guessable — `UserPromptSubmit` carries the prompt in `prompt`, not `message`. Check `README-hooks.md` before parsing a payload.
- **`if` only works on tool events** (`PreToolUse`, `PostToolUse`, `PostToolUseFailure`, `PermissionRequest`, `PermissionDenied`). On any other event the hook never runs and never reports an error.

**Style:**

- Target bash 3.2 (what macOS ships) — no `mapfile`, no associative arrays
- Exit 0 on every path unless you specifically intend to block
- Use `jq` for JSON, with a grep fallback for machines without it
- Comment *why* the hook exists and what breaks without it, not what each line does
- Test on macOS and Linux; note it in the PR if you could not

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
- Improve existing guides in `.claude/docs/`

---

## Development Setup

### Prerequisites

- Git
- Claude Code CLI (`claude`) — **v2.1.218 or later**, the version ALBA requires
- `jq` — the hooks parse event JSON with it
- `bash` 3.2 or later (macOS ships 3.2; do not use bash 4 features)

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
tools/sync-examples.sh        # propagate templates/ into examples/
tools/doctor.sh               # must pass before you commit

# Then confirm the setup flow still works end to end:
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

1. **Edit `templates/`, never `examples/`**
2. **Run `tools/sync-examples.sh`** to propagate your change into the examples
3. **Run `tools/doctor.sh`** — it must pass. This is the closest thing ALBA has to a test suite
4. **Update documentation** if needed, including any count you changed (hooks, skills, rules)
5. **Test thoroughly** - run `/setup` after template changes
6. **Keep PRs focused** - one feature/fix per PR
7. **Respond to feedback** promptly

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
