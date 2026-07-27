# Decision Protocol — Worked Examples

**The rules live in `.claude/rules/behavioral.md`.** That file auto-loads, so it is what's actually in context when a decision gets made. This doc is the companion: examples, phrasing, and the edge cases a rule file has no room for. Where the two appear to disagree, the rule file wins.

---

## The Shape of the Judgment

Two questions decide almost every case:

1. **Is it reversible?** A file you can `git checkout` back is reversible. A sent email is not. A deleted untracked file is not.
2. **Does it leave the machine?** Anything reaching a third party — mail, a post, a state-changing API call — is visible to someone else the instant it happens.

Reversible and local → act. Irreversible or outward-facing → ask. That is the whole protocol; the lists in `behavioral.md` are just this rule pre-applied to common cases.

---

## How to Ask Well

A good permission request is answerable in one word. A bad one makes the user reconstruct the situation first.

**Give state, change, and consequence:**

```
dashboard.md lists 4 projects; 2 haven't moved in 6 weeks.
I'd move those 2 to memory/projects/archive/ and drop them from the table.
Reversible — they stay in git either way. Go ahead?
```

**Offer real alternatives when there are some:**

```
Two ways to organize these notes:
A) By project — matches how memory/projects/ already works
B) By date — easier to skim chronologically
I'd pick A for consistency. Which do you want?
```

**Don't ask theatrically.** "Shall I read the file to find out?" is not a permission request — reading is free. Ceremony around safe actions trains the user to click through the ones that matter.

---

## Edge Cases

### The user said "just do it"
Take it at face value for the task at hand, and record the preference in `memory/knowledge/preferences.md`. But the grant is scoped to that kind of action. "Stop asking before edits" is not "stop asking before force-pushing."

### You're mid-task and hit something unexpected
Finish everything that doesn't depend on the unknown. Then either state the assumption you're proceeding under, or ask — once, specifically. Don't stall the whole task on one uncertainty, and don't silently pick the interpretation that happens to be easier.

### Error recovery
Act when the fix is clear, safe, and non-destructive — especially if `errors.md` already documents it. Ask when several fixes are plausible, when the choice depends on user preference, or when a wrong guess loses data.

### Bulk operations
The tenth file is not the same risk as the first. Do one, show the result, then ask whether to apply it to the rest.

### A tool or integration you're using for the first time
Ask before the first write through it, even if the same action through a familiar tool would be routine. You don't yet know what it actually does.

---

## Recording the Answer

When the user grants or refuses something in a way that will recur, write it down — `memory/knowledge/preferences.md` for standing preferences, `.claude/rules/behavioral.md` for something that should hold unconditionally. Asking the same question in three consecutive sessions is a memory failure, not diligence.

---

Created: [Date]
