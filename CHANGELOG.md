# Changelog

All notable changes to ALBA will be documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Versioning Rules

- **PATCH** (x.x.1): Bugfix, typo, documentation, security fix
- **MINOR** (x.1.0): New skill, hook, example role, or non-breaking feature
- **MAJOR** (x.0.0): Breaking changes to setup flow, memory structure, or CLAUDE.md template format

---

## [1.1.0] - 2026-04-30

### Added
- **`effort` frontmatter on 8 of 9 built-in skills**: `/start` and `/status` → `low`; `/end`, `/extend`, `/reflect`, `/setup`, `/create-skill` → `medium`; `/weekly-review` → `high`. Pro/Max users on Opus 4.6 / Sonnet 4.6 default to `high` effort since CC v2.1.117 — explicit per-skill effort cuts ~3-5x token cost on lightweight skills. (`/research` deliberately left without static effort so the user's `/effort` slider applies.)
- **Two-layer security model** for dangerous-command protection:
  - Layer 1 (CC native): `permissions.deny` and `permissions.ask` blocks in `settings.json` — picks up CC v2.1.113's wrapper-match (catches `env FOO=bar rm`, `sudo rm`, `find -delete` automatically) and v2.1.121's permission-prompt skip for skill/agent/command writes.
  - Layer 2 (`bash-validator.sh`): semantic intent detection for catastrophic patterns (fork bombs, pipe-to-shell, SQL drops, etc.).
- **New `post-compact.sh` hook** (PostCompact event, CC v2.1.76+) — reminds Claude to re-load `dashboard.md` / `todo.md` / today's daily log after a compaction.
- **`error-logger.sh` extended** to also fire on `PostToolUseFailure` (Edit/Write/MCP failures, not just Bash exit codes), with `duration_ms` capture (CC v2.1.119+) and `tool_name` field for cross-tool error pattern detection.
- **Agent template hardening**: `templates/agents/planner.md` is now read-only by default (`maxTurns: 20`, `disallowedTools: [Bash, Edit, Write]`); `templates/agents/researcher.md` gets `maxTurns: 30` and an `initialPrompt` that asks the user for topic + depth.
- **`templates/hooks/README-hooks.md`** documents the two-layer security model and the role of each hook.
- **`MEMORY.md` 25KB / 200-line cap awareness** in `/end` skill and `memory-system.md` (CC v2.1.83 limit). ALBA's own `memory/` is unaffected — narrative content goes to ALBA, one-line tactical facts to CC auto-memory.

### Changed
- **`settings.json` shape** (5 examples + `/setup` Phase 2d):
  - Added `permissions` block: `deny` for `Bash(sudo:*)`, `Read(.env)`, `Write(.env)`, AWS / SSH credentials; `ask` for `git push`, `npm publish`, env-file writes.
  - Added `env: { CLAUDE_CODE_SUBPROCESS_ENV_SCRUB: "1" }` (CC v2.1.83+) — strips Anthropic / cloud credentials from subprocesses.
  - Hook entries now use the modern `{matcher, hooks: [{type, command, timeout}]}` shape with explicit `timeout` values.
- **`bash-validator.sh`**: catastrophic-pattern regexes now use `[[:space:]]+` instead of literal spaces — closes a tab-character bypass. Existing pattern coverage preserved (rm /, mkfs, dd if=, fork bomb, chmod 777 /, DROP DATABASE/TABLE, curl|bash, eval $(, sudo rm -rf, etc.).
- **`.claude/docs/loop-integration.md`** rewritten — covers dynamic (self-paced) mode, Esc-cancel (CC v2.1.113), Anthropic-Console `/schedule` for persistent recurring tasks.
- **README CC version badge**: `v2.1.71+` → `v2.1.83+` (3 languages: en, tr, de).
- **README "Requirements" line**: `v2.1.50+` → `v2.1.83+` (3 languages).
- **`pre-compact.sh` template**: comment header documents the v2.1.105 block-decision option (exit 2 or `{"decision":"block"}` halts compaction).

### Security
- `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1` now set in all example `settings.json` files (CC v2.1.83+).
- `bash-validator.sh` `[[:space:]]+` POSIX class closes tab-character pattern bypass (e.g., `rm\t-rf\t/` was previously not matched by literal-space patterns).

### Compatibility
- **Minimum Claude Code:** v2.1.83 (was v2.1.71). Tested behavior reflects v2.1.123.
- **No breaking changes** to memory layout, CLAUDE.md template, or `/setup` flow — existing v1.0.x repos can update by copying new templates over.

## [1.0.2] - 2026-03-09

### Fixed
- README-hooks.md: corrected settings.json format (added `type` field and `bash` prefix)
- Added missing `quality-gates.md` to all 5 example `.claude/docs/` directories

### Added
- Multi-language README: Turkish (README.tr.md), German (README.de.md)
- Language selector in README.md header
- CHANGELOG.md with SemVer versioning rules

## [1.0.1] - 2026-03-09

### Fixed
- bash-validator: ERR trap changed from fail-open to fail-safe (block on error)
- bash-validator: added 5 missing dangerous patterns (curl|bash, eval, sudo rm -rf, wget|sh)
- pre-compact: error log threshold corrected from 3 to 5 (accounts for header lines)
- content-creator example: "Commands" section renamed to "Skills" with consistent table format
- CONTRIBUTING.md: fixed broken `docs/` reference to `.claude/docs/`
- .gitignore: added `errors_raw.log` (auto-generated by hooks)

## [1.0.0] - 2026-03-08

### Added
- Interactive `/setup` wizard with 7-question discovery and 3 scope levels (minimal/standard/full)
- 9 built-in skills: setup, start, end, status, research, weekly-review, extend, reflect, create-skill
- 6 automated hooks: session-start, bash-validator, error-logger, memory-check, agent-suggest, pre-compact
- 3-tier memory system: hot (state), warm (knowledge), cold (projects) + daily logs
- Progressive disclosure: CLAUDE.md < 200 lines, docs lazy-loaded from .claude/docs/
- 5 example role setups: developer, project-manager, content-creator, researcher, founder
- Template system with customizable CLAUDE.md, hooks, rules, and memory files
- Self-improvement loop: auto error/learning capture, /reflect for pattern analysis
- MCP fallback chain in /research skill (Exa → Firecrawl → WebSearch → WebFetch)
- /loop integration documentation for Claude Code v2.1.71+
- ALBA mascot logo and README banner
- CONTRIBUTING.md with contribution guidelines
- MIT License
