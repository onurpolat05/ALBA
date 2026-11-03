"""Hook-wiring checks for tools/doctor.sh.

Usage: python3 tools/lib/hook_scripts.py <missing|silent> <settings.json>

missing  Print the hook scripts a settings file is wired to that do not exist
         next to it. Skipped for the template, which has no .claude/ beside it.
silent   Print EVENT:script for every hook registered on an event that discards
         plain stdout, when running the script prints something that is not
         JSON. That text goes to the debug log; Claude and the user never see it.

The silent check runs each script for real, in a throwaway fixture project
with a stale dashboard and no daily log, so reminder-style hooks have
something to say. Reading the source instead is not reliable: a comment that
mentions `exit 2`, or an unrelated file write, makes a no-op look effective.

Lives in its own file so doctor.sh passes paths as arguments instead of
splicing them into Python source.
"""
import json
import os
import re
import subprocess
import sys
import tempfile

# Events whose plain stdout Claude Code adds to the conversation
# (hooks reference: "For most events, Claude Code writes stdout to the debug log").
CONTEXT_EVENTS = {"SessionStart", "UserPromptSubmit", "UserPromptExpansion", "PostModelSwitch"}
SCRIPT = re.compile(r"\.claude/hooks/([\w.-]+)")


def fixture(d):
    for sub in ("memory/state", "memory/daily", ".claude/logs"):
        os.makedirs(os.path.join(d, sub))
    dash = os.path.join(d, "memory/state/dashboard.md")
    with open(dash, "w") as fh:
        fh.write("# Dashboard\n- HIGH: fixture priority\n")
    os.utime(dash, (0, 0))
    with open(os.path.join(d, "memory/state/todo.md"), "w") as fh:
        fh.write("- [ ] fixture task\n")


def prints_plain_text(script, event):
    payload = json.dumps({"hook_event_name": event, "session_id": "doctor"})
    with tempfile.TemporaryDirectory(prefix="alba-doctor-") as d:
        fixture(d)
        env = dict(os.environ, CLAUDE_PROJECT_DIR=d)
        try:
            out = subprocess.run(["bash", script], input=payload, capture_output=True,
                                 text=True, env=env, timeout=10).stdout.strip()
        except subprocess.TimeoutExpired:
            return False
    if not out:
        return False
    try:
        json.loads(out)
        return False
    except ValueError:
        return True


def registrations(settings):
    for event, entries in settings.get("hooks", {}).items():
        for entry in entries:
            for hook in entry.get("hooks", []):
                m = SCRIPT.search(hook.get("command", ""))
                if m:
                    yield event, m.group(1)


def main():
    mode, path = sys.argv[1], sys.argv[2]
    settings = json.load(open(path))
    root = os.path.dirname(os.path.dirname(path)) or "."
    out = set()
    for event, name in registrations(settings):
        local = os.path.join(root, ".claude", "hooks", name)
        if mode == "missing":
            if not path.endswith(".template") and not os.path.isfile(local):
                out.add(name)
        elif mode == "silent" and event not in CONTEXT_EVENTS:
            candidates = [local, os.path.join("templates", "hooks", name + ".template")]
            src = next((c for c in candidates if os.path.isfile(c)), None)
            if src and prints_plain_text(src, event):
                out.add(f"{event}:{name}")
    print(" ".join(sorted(out)))


if __name__ == "__main__":
    main()
