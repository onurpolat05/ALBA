# ALBA Hooks System

Hooks are shell scripts Claude Code runs automatically at specific events. They are the only part of an ALBA setup that executes without the model deciding to — which makes them the right place for guarantees, and the wrong place for suggestions you could put in a rule file.

## Two-Layer Security Model

ALBA uses defense-in-depth for dangerous-command protection:

**Layer 1 — CC-native permissions** (in `settings.json`)
- `permissions.deny`: hard blocks — `sudo`, `.env` / `.env.*` (except `.env.example`), and credential stores in your home directory (`~/.ssh`, `~/.aws`, gcloud, kube, docker, `.netrc`)
- `permissions.ask`: prompt before run — `git push`, `rm -rf`, `git reset --hard`, `git clean`, `chmod -R`, `chown -R`, `git log/diff --output`
- Optional, not shipped: `permissions.blockWritesOutsideWorkingDirectories: true` (added in Claude Code v2.1.314) makes file tools refuse paths outside the working directories. It is off in the template because a session opened in a subfolder would then be refused writes to the project-root `memory/`, which breaks `/end`. Turn it on if you always open the project root.
- Claude Code's own command parsing also applies: a prefix rule cannot approve a command wrapped in `env`/`sudo`/`watch`, or `find -exec`/`-delete`. That is Claude Code's behaviour, not a rule ALBA ships.
- Permission rules are evaluated **regardless of what a hook returns** — a hook cannot talk `permissions.deny` out of a block.

Path anchors matter: `Read(**/.ssh/id_*)` means "under the current directory", so it never matched your real `~/.ssh` — ALBA shipped exactly that until v2.1.0. Home paths need `~/`.

**Layer 2 — `bash-validator.sh`** (this hook directory)
- Pattern checks for a short list of catastrophic commands (root/home wipes, disk writes, fork bombs, pipe-to-shell, force-push of main, `DROP DATABASE`).
- Runs as `PreToolUse(Bash)` and returns `permissionDecision: "deny"` to halt execution. Registered with `"onFailure": "block"`, so a validator that crashes, times out or cannot start blocks the command instead of waving it through.
- It is a speed bump against accidents, not a boundary against a determined model: `bash -c`, `eval`, `base64 -d | sh` and friends pass straight to the normal prompt. `tools/test-validator.sh` runs it against `tools/validator-cases.txt`; add a case with every pattern you add. For a real boundary, use Claude Code's sandbox.

**What Layer 2 deliberately does not do: approve anything.** A PreToolUse hook returning `"allow"` *skips the permission prompt*. A validator that answers `allow` for everything outside its blocklist doesn't add a security layer — it removes the one you already had, for every command it hasn't heard of. `bash-validator.sh` emits `deny` on a match, `ask` if the validator itself fails, and **no output at all** otherwise, which leaves the normal permission flow untouched.

## Included Hooks

| Hook | Event | Matcher | Purpose |
|------|-------|---------|---------|
| `session-start.sh` | SessionStart | – | Load dashboard, show priorities; recovery steps when `source` is `compact` |
| `memory-check.sh` | Stop | – | Remind to persist state (rate-limited to 1×/6h), via `systemMessage` |
| `session-end.sh` | SessionEnd | – | Stamp today's daily log with a session record |
| `bash-validator.sh` | PreToolUse | `Bash` | Deny catastrophic commands |
| `error-logger.sh` | PostToolUseFailure | – | Log failed tool calls, credentials redacted |
| `agent-suggest.sh` | UserPromptSubmit | – | Suggest a skill by keyword (skips prompts that already start with `/`) |

## Where Hook Output Goes — read this before writing one

| Channel | Who sees it | Events |
|---------|-------------|--------|
| Plain stdout | **Claude**, as context | `SessionStart`, `UserPromptSubmit`, `UserPromptExpansion`, `PostModelSwitch` — **only these four** |
| Plain stdout | Nobody — the debug log | Every other event |
| `{"systemMessage": "..."}` | The user, as a notice | Most events; `PreCompact`, `PostCompact`, `Notification` and `StopFailure` discard it |
| `hookSpecificOutput.additionalContext` | Claude | Events that document it (e.g. `SessionStart`, `UserPromptSubmit`, `Stop`, `SubagentStop`) |

ALBA ≤ v2.0.0 shipped three hooks that only `echo`ed: `pre-compact.sh`, `post-compact.sh` and `memory-check.sh`. The event names were right, the wiring was right, the scripts exited 0 — and nothing they printed ever reached anyone. `tools/doctor.sh` now runs every registered hook against a fixture project and fails if a hook on a non-context event prints plain text.

Compaction recovery is the instructive case. `PreCompact` cannot add anything to the summary (it can only block compaction), and `PostCompact` output is discarded. What works: after a compaction Claude Code fires `SessionStart` again with `"source": "compact"` (matcher value `compact`), and SessionStart stdout does reach Claude.

## Setup

### 1. Copy hooks to your project

```bash
mkdir -p .claude/hooks .claude/logs
cp templates/hooks/*.sh.template .claude/hooks/
# Rename: remove .template suffix
for f in .claude/hooks/*.template; do mv "$f" "${f%.template}"; done
chmod +x .claude/hooks/*.sh
```

Add `.claude/logs/` to your `.gitignore` — `error-logger.sh` and `memory-check.sh` keep machine-local runtime state there. `/setup` does this for you.

### 2. Configure settings.json

Copy `templates/settings.json.template` to `.claude/settings.json` and delete what you don't want. Don't retype it: that file is the one `tools/doctor.sh` checks, and every hand-made copy of it ALBA has ever shipped drifted. One registration, for reference:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {"type": "command", "command": "bash \"${CLAUDE_PROJECT_DIR}\"/.claude/hooks/bash-validator.sh", "timeout": 5, "onFailure": "block"}
        ]
      }
    ]
  }
}
```

**Three things in that snippet are load-bearing:**

1. **The inner `"hooks"` array is mandatory.** Each entry under an event name is `{matcher?, hooks: [...]}` — the handler objects live one level deeper. Flattening it (`{"matcher": "Bash", "type": "command", ...}`) is silently accepted and installs nothing. ALBA ≤ v1.1.0 documented the flat form, so anyone who copied it had no hooks at all.
2. **`${CLAUDE_PROJECT_DIR}` in the command path.** A bare relative path (`bash .claude/hooks/x.sh`) resolves against the session's working directory, so it breaks the moment someone opens Claude Code in a subdirectory.
3. **Double quotes around `${CLAUDE_PROJECT_DIR}`.** Unquoted, a project path with a space (`~/My Agent`, an iCloud folder) splits into two words, bash exits 127, and Claude Code treats that as a non-blocking error: the hook silently stops running. For a validator that means every command goes through unchecked. ALBA ≤ v2.0.0 shipped every hook unquoted.

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

All 33 events (hooks reference, checked against v2.1.317), with the mechanism each one uses to influence the session. ALBA ships a hook for the ones marked **●**. Plain stdout reaches Claude only on the four events named in [Where Hook Output Goes](#where-hook-output-goes--read-this-before-writing-one).

| Event | Fires when | Decision mechanism |
|-------|-----------|--------------------|
| **●** `SessionStart` | A session starts, resumes, is cleared, or **was just compacted** (matcher: `startup`, `resume`, `clear`, `compact`, `fork`) | Context injection: plain stdout or `additionalContext` |
| `Setup` | `--init-only`, or `--init`/`--maintenance` under `-p`. One-time prep in CI/scripts | Context injection only |
| **●** `UserPromptSubmit` | A prompt is submitted, before Claude processes it | Top-level `decision: "block"`; plain stdout or `additionalContext` to add context |
| `UserPromptExpansion` | A typed command expands into a prompt, before it reaches Claude | Top-level `decision: "block"` (can block the expansion) |
| **●** `PreToolUse` | Before a tool call | `hookSpecificOutput.permissionDecision` + `permissionDecisionReason` |
| `PermissionRequest` | A permission dialog is about to appear | `hookSpecificOutput.decision.behavior` (allow/deny) |
| `PermissionDenied` | Auto-mode classifier rejected a tool call | `hookSpecificOutput.retry: true` tells the model it may retry |
| `PostToolUse` | A tool call succeeded | Top-level `decision: "block"` |
| **●** `PostToolUseFailure` | A tool call failed | Top-level `decision: "block"` |
| `PostToolBatch` | All parallel tool calls resolved, before the next model call | Top-level `decision: "block"` |
| `Notification` | Claude Code sends a notification | No documented decision channel — side effects only |
| `MessageDisplay` | Assistant message text is being displayed | `hookSpecificOutput.displayContent` (10s timeout) |
| `SubagentStart` | A subagent is spawned | Context injection only |
| `SubagentStop` | A subagent finishes | Top-level `decision: "block"`; also accepts `additionalContext` |
| `TaskCreated` | A task is created via `TaskCreate` — never fires in sessions without the Task tools | Exit 2 or `{"continue": false, "stopReason": "..."}` |
| `TaskCompleted` | A task is marked complete — same caveat | Exit 2 or `{"continue": false, "stopReason": "..."}` |
| **●** `Stop` | Claude finishes a response — **every turn, not once per session** | Top-level `decision: "block"`; `additionalContext` (Claude takes another turn); `systemMessage` to tell the user. Plain stdout is discarded |
| `StopFailure` | A turn ended with an API error | Output and exit code are **ignored** (side effects only) |
| `TeammateIdle` | An agent-team teammate is about to go idle | Exit 2 or `{"continue": false, "stopReason": "..."}` |
| `InstructionsLoaded` | `CLAUDE.md` or `.claude/rules/*.md` is loaded into context (session start and lazy loads) | No documented decision channel |
| `ConfigChange` | A config file changes mid-session | Top-level `decision: "block"` |
| `CwdChanged` | The working directory changes (e.g. Claude runs `cd`) — for reactive env tools like direnv | No documented decision channel |
| `FileChanged` | A watched file changes on disk; `matcher` selects filenames | No documented decision channel |
| `WorktreeCreate` | A worktree is created (`--worktree`, `isolation: "worktree"`, background session) | Prints a path to stdout; replaces default git behaviour |
| `WorktreeRemove` | A worktree is removed (session exit, subagent finish, background session deleted) | No documented decision channel |
| `PreCompact` | Before context compaction | Top-level `decision: "block"` (or exit 2) to stop the compaction. Cannot add to the summary; stdout and `systemMessage` are discarded |
| `PostCompact` | After compaction completes | Side effects only (input carries `compact_summary`); stdout and `systemMessage` are discarded. Use `SessionStart` + matcher `compact` to give Claude context |
| `Elicitation` | An MCP server tool asks for user input | No documented decision channel |
| `ElicitationResult` | After the user answers an MCP elicitation, before the answer reaches the server | No documented decision channel |
| **●** `SessionEnd` | The session terminates | No documented decision channel — side effects only |
| `DirectoryAdded` | A working directory is added mid-session (`/add-dir`) | Side effects only — e.g. prepare the new repository |
| `PreModelSwitch` | Before a requested model switch is applied (since v2.1.251) | Can block the switch or require confirmation |
| `PostModelSwitch` | After the session's model changed (since v2.1.251) | Cannot block; plain stdout reaches Claude as context |

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

1. **Check where the output goes** — see the table above. Plain stdout on most events is discarded without a trace.
2. **Keep hooks fast** — they run on every matching event, under a hard timeout.
3. **Fail gracefully** — use `|| true` for non-critical operations; a hook must never break a session. The exception is a hook that guards something: give it `"onFailure": "block"`.
4. **Silent success** — output only when there is something worth saying. `Stop` fires every turn; an unconditional banner there is noise by the third response.
5. **Never auto-approve** — a hook that returns `allow` is spending the user's safety budget on their behalf.
6. **Never write through a symlink** — check `[ -L "$file" ]` before appending to a log; a planted link turns an append into a write anywhere.
7. **Test manually** — pipe a real JSON payload into the script before wiring it up:
   ```bash
   echo '{"tool_name":"Bash","tool_input":{"command":"rm -rf /"}}' | bash .claude/hooks/bash-validator.sh
   ```

## Windows Compatibility

Claude Code runs natively on Windows and routes bash commands through **Git Bash** (provided by Git for Windows). ALBA's hooks therefore work on Windows without WSL — provided three things hold:

1. **Git for Windows is installed** — gives you Git Bash, the interpreter CC routes commands through. Install: `winget install --id Git.Git -e`.
2. **`jq` is on PATH** — every hook uses `jq` to parse the JSON event payload (there is a grep fallback, but it cannot decode JSON escapes). Install: `winget install --id jqlang.jq -e`.
3. **Repo is cloned with LF line endings** — ALBA's `.gitattributes` forces `*.sh` to LF on all platforms, so a fresh clone works. If you see `bad interpreter: bash\r`, your clone predates `.gitattributes` (re-clone) or a CRLF editor touched a script (`dos2unix`, or `sed -i 's/\r$//'`).

All hooks are written for **bash 3.2** (the version macOS ships) and avoid bash 4 features such as `mapfile` and associative arrays, so the same scripts run on macOS, Linux and Git Bash unchanged.

**settings.json portability:** ALBA always uses `"command": "bash \"${CLAUDE_PROJECT_DIR}\"/.claude/hooks/script.sh"` — explicit `bash` prefix, quoted project-root anchor, forward-slash path. This works identically on macOS, Linux and Windows Git Bash: no executable bit required, no path rewriting, and spaces in the path are safe.

**WSL2 alternative:** if you prefer a full Linux toolchain, install Claude Code inside your WSL2 distro and clone ALBA there. Same hooks, same setup.
