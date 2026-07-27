# Task Automation Skill - Reference Guide

> An example of an **inline** skill that reaches an external service through MCP.
> Contrast with `research-skill-example.md`, which is forked.
> Full field list: `SKILL-TEMPLATE.md` in this directory.

## Purpose

Create, update, move and organize tasks in an external task manager (Trello, Notion, Linear)
from the conversation, without switching tools.

## Frontmatter, and why each line is there

```yaml
---
name: task
description: Create, update, move or organize tasks in the connected task manager (Trello/Notion/Linear). Use when user says "add task", "create a card", "move X to done", "what's on my board", "organize my tasks". Do NOT use for ALBA's own local todo file (edit memory/state/todo.md directly) and do NOT use for bulk deletion or archiving without explicit confirmation.
context: inline
effort: low
argument-hint: "<action> <task name> [to <list>]"
allowed-tools: [Read, Write, AskUserQuestion, mcp__trello__*]
---
```

| Line | Why |
|------|-----|
| `description` | The `Do NOT use` clause is doing real work here: without it, this skill and ALBA's local `memory/state/todo.md` both look like "the place tasks go" and Claude picks one at random |
| `context: inline` | Two reasons. The operations are short — there is nothing to isolate. And it needs `AskUserQuestion` to confirm destructive changes, which a fork cannot do |
| `effort: low` | Parsing "add X to Today" and calling one MCP tool is not reasoning-heavy |
| `argument-hint` | Makes the shape of the command visible before the user types it |
| `allowed-tools` | Local file tools plus the one MCP namespace this skill needs — not every MCP server that happens to be connected |

**Why not `context: fork`?** Forking buys context isolation at the cost of interactivity. This
skill makes a couple of API calls and has to be able to stop and ask "you're about to archive 12
cards — proceed?". That trade goes the other way for research, which reads dozens of pages and
never needs to ask anything.

## When to Use

Claude should use this skill when:
- User says "add task", "create card", "move X to done", "organize my tasks"
- User asks what's on a board or list

And should **not** when:
- The user means ALBA's own `memory/state/todo.md` — that's a file edit, no MCP involved
- The operation deletes or archives in bulk without the user having confirmed

## How It Works

1. Parse the request: action, target board/list, task details
2. Resolve board and list ids — from memory if cached, otherwise look them up once and cache
3. Confirm first if the operation is destructive or touches more than a few items
4. Execute through the MCP tool
5. Report back with what changed and a link

## Input Requirements

| Input | Description | Required |
|-------|-------------|----------|
| action | create / update / move / archive | Yes |
| task_name | Name of the task | Yes |
| board or list | Where it goes | Yes for create and move |
| details | Description, due date, labels | No |

## Output Format

A short confirmation — action taken, where it landed, link if the service returns one:

```
Created: "Call John about proposal"
Board: Client Projects -> Today
https://trello.com/c/abc123
```

## Configuration

### Required

One task-management MCP server connected. This skill has no built-in fallback — unlike web
research, there is no generic way to reach someone's Trello board.

| MCP Server | Namespace |
|-----------|-----------|
| Trello | `mcp__trello__*` |
| Notion | `mcp__notion__*` |
| Linear | `mcp__linear__*` |

Set the server up in your Claude Code MCP configuration, then narrow `allowed-tools` to the one
namespace you actually use.

### Optional

Cache the default board and list ids in `memory/knowledge/preferences.md` so the skill doesn't
re-resolve them on every call.

## Notes

- Accept natural language; don't demand an exact command format
- Always confirm before bulk moves, archives or deletions — these are hard to undo from a chat
- Handle failure explicitly: board not found, permission denied, server not connected. A silent
  no-op is the worst outcome, because the user believes the task was filed
- If the MCP server isn't configured, say so and offer the local `memory/state/todo.md` instead

---

*ALBA v2.0.0*
