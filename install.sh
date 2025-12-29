#!/bin/bash

# opAgent Starter - Interactive Setup Installer
# This script helps you set up your personal AI agent system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}"
cat << "EOF"
   ___  ____  ___                    __
  / _ \/ __ \/ _ | ___ ____ ___  ___/ /_
 / // / /_/ / __ |/ _ `/ -_) _ \/ _  __/
/____/ .___/_/ |_|\_, /\__/_//_/\_,_/
    /_/          /___/

Personal AI Agent Setup
EOF
echo -e "${NC}"

echo -e "${GREEN}Welcome to opAgent Starter!${NC}"
echo ""
echo "This will help you set up your personal AI agent system."
echo "The process is interactive and takes about 5-10 minutes."
echo ""

# Check if Claude Code is available
if ! command -v claude-code &> /dev/null; then
    echo -e "${YELLOW}Warning: Claude Code CLI not found.${NC}"
    echo "Make sure Claude Code is installed and in your PATH."
    echo ""
    read -p "Continue anyway? (y/N): " continue_without_cli
    if [[ ! "$continue_without_cli" =~ ^[Yy]$ ]]; then
        echo "Please install Claude Code and try again."
        exit 1
    fi
fi

# Ask for workspace location
echo -e "${BLUE}Where do you want to set up your agent workspace?${NC}"
echo "Default: $HOME/my-agent"
read -p "Workspace path (press Enter for default): " WORKSPACE_PATH

# Use default if not provided
if [ -z "$WORKSPACE_PATH" ]; then
    WORKSPACE_PATH="$HOME/my-agent"
fi

# Expand ~ to home directory
WORKSPACE_PATH="${WORKSPACE_PATH/#\~/$HOME}"

echo ""
echo -e "Workspace location: ${GREEN}$WORKSPACE_PATH${NC}"
echo ""

# Check if directory exists
if [ -d "$WORKSPACE_PATH" ]; then
    echo -e "${YELLOW}Directory already exists.${NC}"
    read -p "Continue and use this directory? (y/N): " use_existing
    if [[ ! "$use_existing" =~ ^[Yy]$ ]]; then
        echo "Please choose a different location and try again."
        exit 1
    fi
else
    mkdir -p "$WORKSPACE_PATH"
    echo -e "${GREEN}✓ Created workspace directory${NC}"
fi

# Copy templates to workspace
echo ""
echo "Copying templates..."
cp -r "$SCRIPT_DIR/templates" "$WORKSPACE_PATH/"
echo -e "${GREEN}✓ Templates copied${NC}"

# Copy setup guides to .claude directory
echo "Copying setup guides..."
mkdir -p "$WORKSPACE_PATH/.claude/setup"
cp "$SCRIPT_DIR/setup/initial-setup.md" "$WORKSPACE_PATH/.claude/setup/"
cp "$SCRIPT_DIR/setup/extend-system.md" "$WORKSPACE_PATH/.claude/setup/"
echo -e "${GREEN}✓ Setup guides copied${NC}"

# Create initial .claude/settings.json if it doesn't exist
if [ ! -f "$WORKSPACE_PATH/.claude/settings.json" ]; then
    echo "Creating initial settings..."
    cat > "$WORKSPACE_PATH/.claude/settings.json" << 'SETTINGS_EOF'
{
  "version": "1.0",
  "workspace": "opAgent",
  "hooks": {}
}
SETTINGS_EOF
    echo -e "${GREEN}✓ Initial settings created${NC}"
fi

# Create README for the workspace
echo "Creating workspace README..."
cat > "$WORKSPACE_PATH/README.md" << 'README_EOF'
# My Personal Agent Workspace

This is your personal AI agent workspace, powered by opAgent Starter.

## Getting Started

### First Time Setup

1. Open Claude Code in this directory:
```bash
cd "$(dirname "$0")"
claude-code
```

2. Tell Claude to start the setup:
```
@.claude/setup/initial-setup.md başla ve benim için agent sistemini kur
```

3. Answer the questions and let Claude build your system

### Daily Usage

After setup is complete, start your session with:
```
/start
```

## Extending Your Agent

Want to add new features? Just tell Claude:
- "I want to add a research skill"
- "Create a hook for auto-loading context"
- "Connect my Trello account"

Claude will read `.claude/setup/extend-system.md` and guide you through it.

## Structure

```
.
├── memory/              # Your memory system (auto-created)
│   ├── state/           # Current state (todo, focus)
│   ├── knowledge/       # Long-term knowledge
│   └── daily/           # Daily logs
├── .claude/             # Claude Code configuration
│   ├── settings.json    # Settings
│   ├── setup/           # Setup guides
│   ├── skills/          # Your custom skills
│   ├── hooks/           # Automation hooks
│   └── docs/            # Documentation
├── templates/           # Template files (reference)
└── CLAUDE.md            # Your agent's instructions (created during setup)
```

## Commands

After setup, you'll have these commands:
- `/start` - Begin session, load context
- `/end` - Save session, update memory
- `/extend` - Add new features

## Need Help?

- Check `.claude/setup/` for guides
- Ask Claude: "How do I [do something]?"
- Visit: https://github.com/[your-repo]/opagent-starter

---

Built with ❤️ using opAgent Starter
README_EOF
echo -e "${GREEN}✓ README created${NC}"

# Create quick start script
echo "Creating quick start script..."
cat > "$WORKSPACE_PATH/start-claude.sh" << 'START_EOF'
#!/bin/bash
# Quick start script for Claude Code

echo "Starting Claude Code in your agent workspace..."
claude-code
START_EOF
chmod +x "$WORKSPACE_PATH/start-claude.sh"
echo -e "${GREEN}✓ Quick start script created${NC}"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}Your workspace is ready at:${NC}"
echo -e "${GREEN}$WORKSPACE_PATH${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo ""
echo "1. Navigate to your workspace:"
echo -e "   ${YELLOW}cd \"$WORKSPACE_PATH\"${NC}"
echo ""
echo "2. Start Claude Code:"
echo -e "   ${YELLOW}claude-code${NC}"
echo ""
echo "3. Begin setup (in Claude Code):"
echo -e "   ${YELLOW}@.claude/setup/initial-setup.md başla ve benim için agent sistemini kur${NC}"
echo ""
echo -e "${BLUE}Or use the quick start script:${NC}"
echo -e "   ${YELLOW}./start-claude.sh${NC}"
echo ""
echo -e "${GREEN}Happy agent building! 🚀${NC}"
echo ""
