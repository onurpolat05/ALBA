# Task Automation Skill Example

## Purpose

Automate common task management operations (create, update, organize tasks in Trello/Notion).

## When to Use

Claude should use this skill when:
- User says "add task to [board/list]"
- User says "update task [name]"
- User says "organize my tasks"
- Keywords: "add task", "create card", "update", "organize"

## How It Works

1. Connect to task management tool (Trello/Notion via MCP)
2. Parse user request (what action, which board/list, task details)
3. Execute task operation
4. Confirm completion with user

## Input Requirements

| Input | Description | Required |
|-------|-------------|----------|
| action | create/update/move/archive | Yes |
| task_name | Name of the task | Yes |
| board/list | Where to put it | Yes (for create/move) |
| details | Description, due date, labels | No |

## Output Format

Returns confirmation message with:
- Action taken
- Task details
- Link to task (if applicable)

Example:
```
✅ Task created: "Setup meeting with client"
📋 Board: Client Projects → Today
🔗 https://trello.com/c/abc123
```

## Configuration

### Required Settings
- Trello or Notion MCP server configured
- Default board/list IDs (stored in memory)

### MCP Options
| MCP Server | Purpose |
|-----------|---------|
| Trello MCP | `mcp__trello__*` - Board/card/list operations |
| Notion MCP | `mcp__notion__*` - Database/page operations |
| Linear MCP | `mcp__linear__*` - Issue tracking |

### Optional Settings
- Default labels
- Auto-add due dates
- Task templates

## Usage Examples

### Example 1: Create Task
```
User: "Add task: Call John about proposal to Today list"
Claude: [Uses task automation skill]
Output: ✅ Created "Call John about proposal" in Today list
```

### Example 2: Organize Tasks
```
User: "Organize my overdue tasks by priority"
Claude: [Uses skill to fetch, sort, update tasks]
Output: Moved 5 tasks, updated 3 due dates
```

## Dependencies

- **Trello/Notion/Linear MCP** - Your task management MCP server
- **Memory** - Store board/list IDs and preferences

Configure your MCP server in `.claude/settings.json` or Claude Code MCP settings.

## Notes

- Store frequently used board/list IDs in memory for quick access
- Use natural language parsing (don't require exact format)
- Confirm before bulk operations (moving/archiving many tasks)
- Handle errors gracefully (board not found, permission issues)

---

Created: 2025-01-09
