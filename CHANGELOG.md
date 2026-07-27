# Changelog

All notable changes to ALBA will be documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Versioning Rules

- **PATCH** (x.x.1): Bugfix, typo, documentation, security fix
- **MINOR** (x.1.0): New skill, hook, example role, or non-breaking feature
- **MAJOR** (x.0.0): Breaking changes to setup flow, memory structure, or CLAUDE.md template format — or a raised minimum Claude Code version, since an unmet floor makes a working setup fail in ways that look like ALBA bugs

---

## [2.0.0] - 2026-07-27

ALBA v1.1.0 shipped on 2026-04-30 and was written against Claude Code v2.1.83. Three months of Claude Code releases later, parts of it had stopped working — not loudly, which is the problem. Hooks fail silently by design: a wrong field name, a wrong output shape, a default that flipped underneath you. The process exits 0, nothing is printed, and the feature simply never happens.

This release fixes what was broken, removes what could not be verified, and makes the silent failures detectable.

**Why MAJOR:** the minimum Claude Code version moves from v2.1.83 to v2.1.218 · the `PreToolUse` output contract changed and `bash-validator.sh` had to change with it · `examples/*/.claude/` is now generated from `templates/` and must not be hand-edited · `templates/agents/researcher.md` was removed.

### Fixed

- **`agent-suggest.sh` read a field that does not exist.** The `UserPromptSubmit` payload carries the prompt in the top-level `prompt` field; the hook parsed `.message // .user_prompt`, which always resolved to empty. It then exited 0 with no output — the correct behavior for "no suggestion," and indistinguishable from it. The hook was dead in every session since it shipped and nothing ever reported it. It now reads `.prompt`, with a matching grep fallback for machines without `jq`.
- **`agent-suggest.sh` emitted a shape no event accepts.** Its suggestions were printed as `{"message": "..."}`, which is not part of any hook output contract and would have been injected as literal JSON text. Suggestions are now plain stdout, which `UserPromptSubmit` adds to the conversation as visible context — appropriate for a tip the user should also see.
- **`bash-validator.sh` was lowering the permission floor it claimed to raise.** For any command its 20-pattern blocklist did not match, it printed `{"decision": "allow"}`. On `PreToolUse` that maps to `permissionDecision: "allow"`, whose documented effect is to **skip the permission prompt**. A hook presented as a security layer was silently auto-approving every command it had never heard of. It now emits `deny` on a match, `ask` if the validator itself fails, and **no output at all** otherwise, so the normal permission flow is left untouched. This is the reference behavior from the official example: `exit 0  # no decision; normal permission flow applies`.
- **`bash-validator.sh` patterns were unanchored and case-insensitive**, so they matched their letters anywhere in a command string rather than a command being run. `git commit -m "fix reboot handler"` was blocked. Patterns are now anchored to a command position (start of string, or after `;`, `&`, `|`, `(`), matched case-sensitively for shell verbs and case-insensitively only for SQL. A wrapper-absorbing group in the anchor keeps `sudo rm -rf ~` and `env FOO=1 rm -rf /` in command position, so absorbing wrappers does not reopen the substring hole.
- **`bash-validator.sh` fail-safe was mislabeled.** Its `ERR` trap emitted a top-level `decision: "block"`, a deprecated field on this event. A broken validator now emits `permissionDecision: "ask"` — the user is asked, rather than the validator silently becoming a no-op.
- **The `settings.json` snippet in `templates/hooks/README-hooks.md` was structurally wrong.** It flattened the handler object into the event entry, omitting the mandatory inner `hooks` array. That form is accepted without complaint and installs nothing, so anyone who copied it ended up with no hooks and no error message. Corrected, with the requirement called out explicitly.
- **Relative hook paths** (`bash .claude/hooks/x.sh`) resolve against the session's working directory and break the moment a session is opened in a subdirectory. All hook commands now use `${CLAUDE_PROJECT_DIR}`.
- **The `.env` protection rules never applied.** `settings.json` carried `deny: Write(.env)` and `ask: Write(**/*.env)` — but file permission rules are matched on `Edit(path)` only, and `Edit` already covers every file-writing tool. Claude Code accepts a `Write(path)` rule, prints a startup warning about it, and then ignores it, so the rule that was supposed to guard credential files had been inert since v1.1.0 introduced it. Both are now `Edit(...)`, the redundant `Write(memory/**)` allow entry was dropped, and `tools/doctor.sh` fails on any `Write(path)` rule. Found by running a real session rather than by reading the file — the warning only appears at startup.
- **Hook count was wrong everywhere.** READMEs and CONTRIBUTING said 6 hooks; the repository has shipped 7 since v1.1.0 added `post-compact.sh`, and now ships 8 across 9 event registrations (`error-logger.sh` is wired to both `PostToolUse` and `PostToolUseFailure`). Counts corrected in every document that states one, and made checkable — `tools/doctor.sh` greps every doc for a stated hook, skill or role count and fails if it disagrees with the files on disk. `sync-examples.sh` cannot catch this class of error, because the example role docs describe the shared config without being copies of it.
- **`templates/claude/loop-integration.md.template` and `memory-compatibility.md.template` did not exist.** `templates/INDEX.md` listed both as generated docs, so the index pointed at files nothing produced. Both templates are now present.

### Changed

- **Minimum Claude Code is v2.1.218** (was v2.1.83); behavior verified against v2.1.220. The floor is set by the `background` frontmatter field, which the two forked skills need.
- **`/research` and `/reflect` now set `background: false`.** Both carry `context: fork`. As of Claude Code v2.1.218, forked skills default to `background: true` — they run detached and their result arrives as a later notification rather than in the turn that invoked them. Both skills predate that release by months and changed behavior without anyone touching a line of them. Asking for research or reflection is a synchronous question, so the answer belongs in the turn that asked it.
- **All 9 skill descriptions rewritten to the trigger-plus-boundary pattern** — `<what it does>. Use when user says "x", "y". Do NOT use for <z>.` The `description` is the only text Claude reads when deciding whether to invoke a skill; ALBA's previous descriptions were one-line definitions with no trigger phrases and no negative boundary.
- **Error log moved** from `memory/knowledge/errors_raw.log` to `.claude/logs/errors_raw.log`, with rotation at 500 lines. It is machine-local runtime state, not memory content, and it previously grew unbounded inside the git-tracked memory tree. `.gitignore` now excludes `.claude/logs/` instead of the old path.
- **`memory-check.sh` is rate-limited to once per 6 hours** via a guard file, and its "session longer than 30 minutes" heuristic was **removed**. That heuristic read file birth time, which most Linux filesystems report as `0` — so on those systems the condition was always true and the hook fired on every single `Stop`, meaning after every response. A reminder that frequent is one users learn to read past. The guard replaces it, and the hook now stays silent — without burning the guard window — when it has nothing concrete to say.
- **`CLAUDE.md.template` cut from 149 to 85 lines** and `decision-protocol.md.template` from 260 to 68. The decision protocol lived in three places with three levels of detail. `templates/rules/behavioral.md` is now the single authority on when to ask and when to act — rules files are in context at the moment the decision is made, which a doc you would have to open is not. The doc keeps worked examples and phrasing, and never overrides the rule.
- **`examples/*/.claude/` is generated from `templates/`.** Every hook script, doc and settings file previously existed in six independent copies, and a fix applied to one skipped the other five. The copies remain on disk so an example is still readable on GitHub, but they are build output now. Role-specific files — `CLAUDE.md`, `README.md`, `memory/` — are never overwritten.
- **`templates/hooks/README-hooks.md` substantially expanded** — see Added.

### Added

- **`tools/sync-examples.sh`** — regenerates the shared parts of `examples/` from `templates/`. `--check` reports drift and exits non-zero without changing anything, so it works as a CI gate.
- **`tools/doctor.sh`** — health check for the failures that produce no error: hook event names that are not among the 30 real events, `settings.json` entries missing the inner `hooks` array, hook commands pointing at scripts that do not exist, relative hook paths, a `PreToolUse` hook that returns `allow`, template/example drift, broken repo-relative links, stated counts that no longer match the files, stale version claims, leaked absolute home paths, and removal residue such as strikethrough or `DEPRECATED` tombstones. It also shell-parses every script and validates every JSON file. ALBA ships configuration rather than a runnable program, so this stands in for a test suite. Run it before committing and after upgrading Claude Code.
- **`templates/settings.json.template`** — the canonical settings file, previously reconstructed by hand in each example. Includes a `permissions.allow` list for read-only operations (`git status`, `git diff`, `ls`, reads under `memory/` and `.claude/`), which ALBA had never used, alongside the existing `ask` and `deny` blocks.
- **`session-end.sh` hook** on the `SessionEnd` event. ALBA's memory layer depends on `/end` being run, and the closing ritual is what users forget. This appends one dated line to today's log so a session that ended without `/end` is at least visible. It records that a session ran and when — it does not summarize or infer, because content that looks curated but came from a shell script is how a memory system starts lying.
- **`templates/rules/verification.md`** — an auto-loaded rule covering what to report after a change: what was verified and with which command, what was not verified and how to check it, and a three-line close for multi-step runs. "I didn't verify this" is a useful sentence; a wrong "it works" costs a debugging session.
- **`templates/hooks/README-hooks.md` now documents the hook surface properly:** all 30 hook events with the decision mechanism each one uses and which ones ALBA ships a hook for; the `if` filter with its critical constraint — **`if` only works on tool events** (`PreToolUse`, `PostToolUse`, `PostToolUseFailure`, `PermissionRequest`, `PermissionDenied`), and putting it on any other event makes the hook never run and never report an error; handler types beyond `command` (`http`, `mcp_tool`, `prompt`, `agent`); and the timeout defaults (60s general, 30s `UserPromptSubmit`, 10s `MessageDisplay`).
- **`examples/*/.claude/agents/`** — the example roles now ship the agent template, which previously existed only under `templates/`.

### Removed

- **`templates/agents/researcher.md`.** The `/research` skill already runs as a forked subagent doing the same job, so the repository offered two doors to one room with nothing to tell you which to use. The skill is the documented path.
- **`maxTurns`, `disallowedTools` and `initialPrompt` from agent frontmatter.** v1.1.0 introduced these as "agent template hardening," but their enforcement could not be confirmed against current documentation — a constraint you cannot verify is not a constraint, and presenting one as a safety property is worse than not having it. For a hard restriction, `permissions.deny` in `settings.json` is the mechanism that is actually enforced.
- **Unverifiable version attributions.** Hook comments credited specific releases for specific behaviors (`v2.1.76+`, `v2.1.105`, `v2.1.113`, `v2.1.119`). The behaviors are real; the version numbers could not be confirmed. Version numbers now appear only where they were verified, which in this release means v2.1.218 and v2.1.220.
- **`memory/knowledge/errors_raw.log` from `.gitignore`** — superseded by `.claude/logs/`.

### Security

- `bash-validator.sh` no longer returns `allow`. This is the single most consequential change in the release: the previous behavior removed the permission prompt for every command outside a 20-pattern blocklist, which is strictly worse than having no hook at all.
- `permissions.allow` in the shipped settings template is scoped to read-only commands and to paths inside the agent's own workspace. Nothing that writes outside `memory/`, nothing that leaves the machine.

### Migration from v1.x

Existing setups keep working in the sense that nothing crashes — but the fixes above only take effect once the templates are re-copied. In order:

1. **Upgrade Claude Code to v2.1.218 or later.** On an older version, `background: false` is ignored and `/research` and `/reflect` run detached.
2. **Re-copy the hook scripts** from `templates/hooks/` into your `.claude/hooks/`. The `agent-suggest.sh` and `bash-validator.sh` fixes are in the scripts themselves; nothing else picks them up.
3. **Rewrite hook paths in `.claude/settings.json` to `${CLAUDE_PROJECT_DIR}`.** Copy `templates/settings.json.template` if your settings file has no local customizations. Register the new `SessionEnd` hook while you are in there.
4. **Add `.claude/logs/` to `.gitignore`** and remove the `memory/knowledge/errors_raw.log` line. The old log file can be deleted, or moved to `.claude/logs/errors_raw.log` if you want to keep its history. It is read by the `/end` skill and by `pre-compact.sh`, both of which now look in the new location only.
5. **Add `background: false`** to any of your own skills that use `context: fork` and are expected to answer in the same turn.
6. **Run `tools/doctor.sh`** to confirm the wiring.

If you have edited files under `examples/`, move those edits into `templates/` before running `tools/sync-examples.sh` — it will overwrite them.

## [1.1.0] - 2026-04-30

### Added
- **Windows compatibility**: new `.gitattributes` forces `*.sh` / `*.sh.template` files to LF line endings on all platforms — closes the `bad interpreter: bash\r` failure that broke all 7 hooks under Windows' default `core.autocrlf=true`. New "Windows Setup" section in README (en/tr/de) covers Git for Windows + jq prerequisites; `templates/hooks/README-hooks.md` documents the bash/jq requirements and WSL2 alternative. ALBA now works on Windows native Claude Code (via Git Bash routing) without WSL.
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
