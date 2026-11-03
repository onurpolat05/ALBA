# Security Policy

ALBA ships configuration that runs on your machine: shell hooks, permission rules and skills that Claude Code loads. A flaw in any of them is a flaw on every machine that copied it, so reports are welcome and taken seriously.

## Reporting a vulnerability

Please **do not open a public issue.** Use GitHub's private reporting instead: **Security** tab → **Report a vulnerability**. Include the file, the payload or setup that triggers the problem, and what happens versus what should happen.

You can expect an acknowledgement within a week. Fixes ship in the next release and are listed under **Security** in `CHANGELOG.md`, with credit if you want it.

## What counts

- A hook that can be made to run, write or leak something it should not (command injection, writes through symlinks, secrets reaching a log or a git-tracked file)
- A permission rule in `templates/settings.json.template` that does not do what its comment or the docs claim
- A shipped hook that fails **open** - stops checking without telling anyone
- A skill whose `allowed-tools` pre-approves more than it needs

## What does not

`bash-validator.sh` is a blocklist, and a blocklist cannot enumerate every spelling of a command. `bash -c "..."`, `eval`, `base64 -d | sh` and similar pass through it to the normal permission prompt by design; its header lists them. A new bypass of that kind is useful as a test case (`tools/validator-cases.txt`) and is welcome as a regular pull request. A pattern that **claims** to block something and does not is a bug worth reporting.

For a real boundary against a determined model, use Claude Code's sandbox; ALBA's hooks are a speed bump against accidents.

## Supported versions

Only the latest release receives fixes. Re-copy the hook scripts and `settings.json` from `templates/` after upgrading - fixes in a template do not reach a setup that was generated before them.
