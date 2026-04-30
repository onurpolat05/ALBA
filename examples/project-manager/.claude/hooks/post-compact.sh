#!/bin/bash

# ALBA - Post-Compact Hook (v1.1.0+)
# Event: PostCompact (CC v2.1.76+)
# Purpose: Remind Claude to re-load critical context after a compaction.
#
# Compaction summarizes prior turns to free context window — but it can drop
# tool results, file paths, or in-progress plans. This hook nudges Claude to
# re-read the dashboard / todo / today's daily log so it can resume cleanly.
#
# CRITICAL: Never fails, never blocks. Always exits 0.

trap 'exit 0' ERR EXIT

DATE_TODAY=$(date '+%Y-%m-%d' 2>/dev/null) || DATE_TODAY="today"

cat <<EOF
REMINDER: Conversation was just compacted. Critical context may have been lost.

Recommended recovery:
- Re-read memory/state/dashboard.md for current priorities
- Re-read memory/state/todo.md for active tasks
- Check memory/daily/${DATE_TODAY}.md if continuing today's session

Resume from where the compaction summary left off.
EOF

exit 0
