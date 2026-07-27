# ALBA Hooks System

Hooks are shell scripts Claude Code runs automatically at specific events. They are the only part of an ALBA setup that executes without the model deciding to — which makes them the right place for guarantees, and the wrong place for suggestions you could put in a rule file.

## Two-Layer Security Model

ALBA uses defense-in-depth for dangerous-command protection:

**Layer 1 — CC-native permissions** (in `settings.json`)
- `permissions.deny`: hard blocks (e.g., `Bash(sudo:*)`, `Read(.env)`)
- `permissions.ask`: prompt before run (e.g., `Bash(git push:*)`)
- Deny rules also match commands wrapped in `env`/`sudo`/`watch`/`ionice`/`setsid`, and `find:*` no longer auto-approves `-exec`/`-delete` under a broad allow rule.
- Permission rules are evaluated **regardless of what a hook returns** — a hook cannot talk `permissions.deny` out of a block.

**Layer 2 — `bash-validator.sh`** (this hook directory)
- Detects catastrophic semantic intent that command-level rules can't see (fork bombs, disk wipes, pipe-to-shell, `DROP DATABASE`).
- Runs as `PreToolUse(Bash)` and returns `permissionDecision: "deny"` to halt execution.

**What Layer 2 deliberately does not do: approve anything.** A PreToolUse hook returning `"allow"` *skips the permission prompt*. A validator that answers `allow` for everything outside its blocklist doesn't add a security layer — it removes the one you already had, for every command it hasn't heard of. `bash-validator.sh` emits `deny` on a match, `ask` if the validator itself fails, and **no output at all** otherwise, which leaves the normal permission flow untouched.

## Included Hooks

| Hook | Event | Matcher | Purpose |
|------|-------|---------|---------|
| `session-start.sh` | SessionStart | – | Load dashboard, show priorities |
| `memory-check.sh` | Stop | – | Remind to persist state (rate-limited to 1×/6h) |
| `session-end.sh` | SessionEnd | – | Stamp today's daily log with a session record |
| `bash-validator.sh` | PreToolUse | `Bash` | Deny catastrophic commands (semantic intent) |
| `error-logger.sh` | PostToolUse + PostToolUseFailure | `Bash` on PostToolUse | Log errors from any tool, incl. `duration_ms` |
| `agent-suggest.sh` | UserPromptSubmit | – | Suggest skills/agents by keyword |
| `pre-compact.sh` | PreCompact | – | Preserve context before compaction |
| `post-compact.sh` | PostCompact | – | Remind to re-load context after compaction |

## Setup

### 1. Copy hooks to your project

```bash
mkdir -p .claude/hooks .claude/logs
cp templates/hooks/*.sh.template .claude/hooks/
# Rename: remove .template suffix
for f in .claude/hooks/*.template; do mv "$f" "${f%.template}"; done
chmod +x .claude/hooks/*.sh
```

Add `.claude/logs/` to your `.gitignore` — `error-logger.sh` and `memory-check.sh` keep machine-local runtime state there.

### 2. Configure settings.json

Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {"type": "command", "command": "bash ${CLAUDE_PROJECT_DIR}/.claude/hooks/session-start.sh"}
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {"type": "command", "command": "bash ${CLAUDE_PROJECT_DIR}/.claude/hooks/agent-suggest.sh"}
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {"type": "command", "command": "bash ${CLAUDE_PROJECT_DIR}/.claude/hooks/bash-validator.sh"}
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {"type": "command", "command": "bash ${CLAUDE_PROJECT_DIR}/.claude/hooks/error-logger.sh"}
        ]
      }
    ],
    "PostToolUseFailure": [
      {
        "hooks": [
          {"type": "command", "command": "bash ${CLAUDE_PROJECT_DIR}/.claude/hooks/error-logger.sh"}
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {"type": "command", "command": "bash ${CLAUDE_PROJECT_DIR}/.claude/hooks/memory-check.sh"}
        ]
      }
    ],
    "SessionEnd": [
      {
        "hooks": [
          {"type": "command", "command": "bash ${CLAUDE_PROJECT_DIR}/.claude/hooks/session-end.sh"}
        ]
      }
    ],
    "PreCompact": [
      {
        "hooks": [
          {"type": "command", "command": "bash ${CLAUDE_PROJECT_DIR}/.claude/hooks/pre-compact.sh"}
        ]
      }
    ],
    "PostCompact": [
      {
        "hooks": [
          {"type": "command", "command": "bash ${CLAUDE_PROJECT_DIR}/.claude/hooks/post-compact.sh"}
        ]
      }
    ]
  }
}
```

**Two things in that snippet are load-bearing:**

1. **The inner `"hooks"` array is mandatory.** Each entry under an event name is `{matcher?, hooks: [...]}` — the handler objects live one level deeper. Flattening it (`{"matcher": "Bash", "type": "command", ...}`) is silently accepted and installs nothing. ALBA ≤ v1.1.0 documented the flat form, so anyone who copied it had no hooks at all.
2. **`${CLAUDE_PROJECT_DIR}` in the command path.** A bare relative path (`bash .claude/hooks/x.sh`) resolves against the session's working directory, so it breaks the moment someone opens Claude Code in a subdirectory.

### 3. Optional: narrow a hook with `if`

```json
{"type": "command", "if": "Bash(rm *)", "command": "..."}
```

`if` takes permission-rule syntax and acts as a second filter after `matcher`.

> **`if` only works on tool events** — `PreToolUse`, `PostToolUse`, `PostToolUseFailure`, `PermissionRequest`, `PermissionDenied`. Put it on any other event and the hook **never runs and never reports an error**. If a hook mysteriously does nothing, check for a stray `if` first.

## Hook Reference

### Handler types

| Type | What it does |
|------|--------------|
| `command` | Runs a shell command (everything in ALBA) |
| `http` | POSTs the event payload to a URL |
| `mcp_tool` | Invokes an MCP tool |
| `prompt` | Asks the model; expects `{"ok": true\|false, "reason": "..."}` |
| `agent` | Runs a validation subagent |

Additional handler fields: `args: string[]`, `continueOnBlock`, `terminalSequence`, `async` + `asyncRewake`, `shell: powershell`, `statusMessage` (custom spinner text).

**Timeouts:** 60s by default · `UserPromptSubmit` 30s · `MessageDisplay` 10s. A hook that exceeds its timeout is killed — keep them fast.

### Events

All 30 events, with the mechanism each one uses to influence the session. ALBA ships a hook for the ones marked **●**.

| Event | Fires when | Decision mechanism |
|-------|-----------|--------------------|
| **●** `SessionStart` | A session starts or is resumed | Context injection only (`hookSpecificOutput.additionalContext`) |
| `Setup` | `--init-only`, or `--init`/`--maintenance` under `-p`. One-time prep in CI/scripts | Context injection only |
| **●** `UserPromptSubmit` | A prompt is submitted, before Claude processes it | Top-level `decision: "block"`; plain stdout or `additionalContext` to add context |
| `UserPromptExpansion` | A typed command expands into a prompt, before it reaches Claude | Top-level `decision: "block"` (can block the expansion) |
| **●** `PreToolUse` | Before a tool call | `hookSpecificOutput.permissionDecision` + `permissionDecisionReason` |
| `PermissionRequest` | A permission dialog is about to appear | `hookSpecificOutput.decision.behavior` (allow/deny) |
| `PermissionDenied` | Auto-mode classifier rejected a tool call | `hookSpecificOutput.retry: true` tells the model it may retry |
| **●** `PostToolUse` | A tool call succeeded | Top-level `decision: "block"` |
| **●** `PostToolUseFailure` | A tool call failed | Top-level `decision: "block"` |
| `PostToolBatch` | All parallel tool calls resolved, before the next model call | Top-level `decision: "block"` |
| `Notification` | Claude Code sends a notification | No documented decision channel — side effects only |
| `MessageDisplay` | Assistant message text is being displayed | `hookSpecificOutput.displayContent` (10s timeout) |
| `SubagentStart` | A subagent is spawned | Context injection only |
| `SubagentStop` | A subagent finishes | Top-level `decision: "block"`; also accepts `additionalContext` |
| `TaskCreated` | A task is created via `TaskCreate` | Exit 2 or `{"continue": false, "stopReason": "..."}` |
| `TaskCompleted` | A task is marked complete | Exit 2 or `{"continue": false, "stopReason": "..."}` |
| **●** `Stop` | Claude finishes a response — **every turn, not once per session** | Top-level `decision: "block"`; also accepts `additionalContext` |
| `StopFailure` | A turn ended with an API error | Output and exit code are **ignored** (side effects only) |
| `TeammateIdle` | An agent-team teammate is about to go idle | Exit 2 or `{"continue": false, "stopReason": "..."}` |
| `InstructionsLoaded` | `CLAUDE.md` or `.claude/rules/*.md` is loaded into context (session start and lazy loads) | No documented decision channel |
| `ConfigChange` | A config file changes mid-session | Top-level `decision: "block"` |
| `CwdChanged` | The working directory changes (e.g. Claude runs `cd`) — for reactive env tools like direnv | No documented decision channel |
| `FileChanged` | A watched file changes on disk; `matcher` selects filenames | No documented decision channel |
| `WorktreeCreate` | A worktree is created (`--worktree`, `isolation: "worktree"`, background session) | Prints a path to stdout; replaces default git behaviour |
| `WorktreeRemove` | A worktree is removed (session exit, subagent finish, background session deleted) | No documented decision channel |
| **●** `PreCompact` | Before context compaction | Top-level `decision: "block"`; stdout is preserved into the summary |
| **●** `PostCompact` | After compaction completes | No documented decision channel; ALBA uses its stdout as a recovery reminder |
| `Elicitation` | An MCP server tool asks for user input | No documented decision channel |
| `ElicitationResult` | After the user answers an MCP elicitation, before the answer reaches the server | No documented decision channel |
| **●** `SessionEnd` | The session terminates | No documented decision channel — side effects only |

### Output formats — the part that bites

There are two different decision shapes, and using the wrong one fails silently.

**`PreToolUse` — `hookSpecificOutput`:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Destructive command blocked by hook"
  }
}
```

| Value | Meaning |
|-------|---------|
| `allow` | **Skips the permission prompt.** The user is never asked. |
| `deny` | Blocks the call; the reason is shown to Claude. |
| `ask` | Prompts the user for confirmation. |
| `defer` | Exits gracefully to be resumed later (Agent SDK / `claude -p`). |

If several PreToolUse hooks disagree, precedence is `deny` > `defer` > `ask` > `allow`.

To make no decision, produce **no output** and `exit 0` — the normal permission flow then applies. `exit 2` is also valid and blocks the call, sending stderr to Claude as feedback; the JSON form is preferred because the reason reaches Claude more cleanly.

Top-level `decision`/`reason` are **deprecated for PreToolUse** (the old `"approve"`/`"block"` values map to `"allow"`/`"deny"`).

**Every other event — top-level `decision`:**

```json
{"decision": "block", "reason": "..."}
```

`"block"` is the only meaningful value. To allow, omit `decision` entirely or produce no output. The deprecation above applies to `PreToolUse` **only** — `PostToolUse`, `Stop`, `PreCompact`, `UserPromptSubmit` and the rest still use top-level `decision`, and "modernizing" them to `permissionDecision` breaks them.

## Customization

Each hook is a standalone bash script. Customize by:
- Editing patterns in `bash-validator.sh` (see the design rule in its header before adding one)
- Adding keyword mappings in `agent-suggest.sh`
- Changing the dashboard format in `session-start.sh`
- Adjusting the reminder interval in `memory-check.sh`

## Best Practices

1. **Keep hooks fast** — they run on every matching event, under a hard timeout.
2. **Fail gracefully** — use `|| true` for non-critical operations; a hook must never break a session.
3. **Silent success** — output only when there is something worth saying. `Stop` fires every turn; an unconditional banner there is noise by the third response.
4. **Never auto-approve** — a hook that returns `allow` is spending the user's safety budget on their behalf.
5. **Test manually** — pipe a real JSON payload into the script before wiring it up:
   ```bash
   echo '{"tool_name":"Bash","tool_input":{"command":"rm -rf /"}}' | bash .claude/hooks/bash-validator.sh
   ```

## Windows Compatibility

Claude Code runs natively on Windows and routes bash commands through **Git Bash** (provided by Git for Windows). ALBA's hooks therefore work on Windows without WSL — provided three things hold:

1. **Git for Windows is installed** — gives you Git Bash, the interpreter CC routes commands through. Install: `winget install --id Git.Git -e`.
2. **`jq` is on PATH** — every hook uses `jq` to parse the JSON event payload (there is a grep fallback, but it cannot decode JSON escapes). Install: `winget install --id jqlang.jq -e`.
3. **Repo is cloned with LF line endings** — ALBA's `.gitattributes` forces `*.sh` to LF on all platforms, so a fresh clone works. If you see `bad interpreter: bash\r`, your clone predates `.gitattributes` (re-clone) or a CRLF editor touched a script (`dos2unix`, or `sed -i 's/\r$//'`).

All hooks are written for **bash 3.2** (the version macOS ships) and avoid bash 4 features such as `mapfile` and associative arrays, so the same scripts run on macOS, Linux and Git Bash unchanged.

**settings.json portability:** ALBA always uses `"command": "bash ${CLAUDE_PROJECT_DIR}/.claude/hooks/script.sh"` — explicit `bash` prefix, forward-slash path, project-root anchored. This works identically on macOS, Linux and Windows Git Bash: no executable bit required, no path rewriting.

**WSL2 alternative:** if you prefer a full Linux toolchain, install Claude Code inside your WSL2 distro and clone ALBA there. Same hooks, same setup.
