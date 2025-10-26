# Workflow Scripts

Scripts for orchestrating multi-role AI workflow.

## Quick Start

```bash
# Review a spec
./run-role.sh spec-reviewer specs/proposed/user-auth.md

# Start interactive spec writing session
./run-role.sh spec-writer

# Implement a feature
./run-role.sh implementer specs/doing/user-auth.md
```

## run-role.sh

Launches the appropriate AI tool with the correct model and role configuration.

### Usage

```bash
./run-role.sh <role-name> [artifact-path] [additional-context...]
```

**Arguments:**
- `role-name` (required): Name of the role to assume (e.g., `spec-writer`, `spec-reviewer`)
- `artifact-path` (optional): Path to the artifact being worked on
- `additional-context` (optional): Extra context or instructions

**Examples:**

```bash
# Interactive sessions (helpers, writers)
./run-role.sh vision-writing-helper
./run-role.sh spec-writer
./run-role.sh platform-lead

# One-shot reviews
./run-role.sh spec-reviewer specs/proposed/user-authentication.md
./run-role.sh test-reviewer specs/doing/user-authentication.md
./run-role.sh implementation-reviewer specs/doing/user-authentication.md

# Implementation with context
./run-role.sh implementer specs/doing/user-auth.md "Focus on error handling"

# List available roles
./run-role.sh
```

### How It Works

1. **Loads configuration** from `role-config.json` (role → tool/model mapping) and `tool-config.json` (tool settings)
2. **Builds initialization message** that tells the AI to:
   - Read the appropriate entry point doc (CLAUDE.md, AGENTS.md, etc.)
   - Follow the document graph to understand the project
   - Assume the specified role
3. **Launches the appropriate CLI** with correct model and parameters

### Interactive vs One-Shot

**Interactive roles** (writers, helpers):
- Launches the tool in interactive mode
- Displays the initialization message for you to paste
- Continues as interactive session

**One-shot roles** (most reviewers, implementers):
- Sends initialization message automatically
- Executes task and returns result
- Exits when complete

The `interactive` flag in `role-config.json` controls this behavior.

### Configuration

**role-config.json** - Maps roles to tools and models:
```json
{
  "spec-writer": {
    "tool": "claude",
    "model": "claude-sonnet-4-5",
    "interactive": true
  },
  "spec-reviewer": {
    "tool": "codex",
    "model": "gpt-5",
    "reasoning_effort": "high"
  }
}
```

**tool-config.json** - Tool-specific settings:
```json
{
  "claude": {
    "entry_point": "CLAUDE.md",
    "cli": "claude"
  },
  "codex": {
    "entry_point": "AGENTS.md",
    "cli": "codex"
  }
}
```

### Customizing for Concrete Projects

When copying this workflow to a concrete project:

1. **Copy the entire Workflow/ directory** to your project
2. **Adjust role-config.json** if you want different model assignments
3. **Keep tool-config.json** as-is (it references entry points that are also copied)
4. **Run scripts from anywhere** - they auto-detect the project root

### Requirements

- **jq** - Install with `brew install jq`
- **Appropriate CLIs installed** - `claude`, `codex`, `gemini`, and/or `opencode`
- **Authentication configured** for each tool you use

### Troubleshooting

**"Unknown role: X"**
- Check spelling against available roles in `role-config.json`
- Run `./run-role.sh` without arguments to see available roles

**"CLI not found"**
- Verify the tool is installed: `which claude`, `which codex`, etc.
- Check that it's in your PATH

**"Role file not found"**
- Verify `Workflow/role-<name>.md` exists
- Check you're running from the correct directory

## Future Enhancements

- **workflow-status.sh** - Scan project state and suggest next actions
- **--append-system-prompt** - Use Claude's system prompt injection for more authoritative role loading (currently roles are loaded via initial message)
