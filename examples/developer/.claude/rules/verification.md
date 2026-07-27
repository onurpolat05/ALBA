# Verification Rules

Auto-loads from `.claude/rules/`. Covers one thing: what you owe the user *after* a change.

---

## Say what you checked

After changing code, config, or a hook — without being asked — state both halves:

- **Verified:** what you ran (test, build, lint, the actual command) and what it printed
- **Not verified:** which part of the change nobody has exercised yet, and how to exercise it

If runnable behavior changed, run it. A passing lint is not evidence that a feature works.

**Never say "done" or "working" without saying which of the two it is.** "I didn't verify this" is a useful sentence. A wrong "it works" costs the user a debugging session.

---

## Close a multi-step run with three lines

Any run of three or more actions ends with:

- **Did:** what changed, in one or two lines
- **Open:** what is unverified or risky
- **Next:** the sensible next step

The point is that the user should never have to ask "so what happened?"

---

## Hooks and settings need real evidence

A hook that is misconfigured fails **silently** — no error, no output, it simply never runs. So a hook is not verified until you have seen it fire:

```bash
echo '{"hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"ls"}}' \
  | bash .claude/hooks/bash-validator.sh; echo "exit=$?"
```

Same for `.claude/settings.json`: confirm it parses (`python3 -m json.tool < .claude/settings.json`) before calling the change done.

---

## Scope

Applies to work that touches two or more files, changes runnable behavior, or runs three or more actions autonomously. Skip it for a one-line answer — the ceremony would cost more than it returns.
