#!/usr/bin/env bash
set -euo pipefail

# run-role.sh - Launch AI tool in appropriate role
#
# Usage: ./run-role.sh <role-name> [artifact-path] [additional-context...]
#
# Examples:
#   ./run-role.sh vision-writer
#   ./run-role.sh spec-reviewer specs/proposed/user-auth.md
#   ./run-role.sh implementer specs/doing/user-auth.md "Focus on error handling"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOW_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$WORKFLOW_DIR/.." && pwd)"

# Check dependencies
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed." >&2
    echo "Install with: brew install jq" >&2
    exit 1
fi

# Parse arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 <role-name> [artifact-path] [additional-context...]" >&2
    echo "" >&2
    echo "Available roles:" >&2
    jq -r 'keys[]' "$WORKFLOW_DIR/role-config.json" | sed 's/^/  /' >&2
    exit 1
fi

ROLE_NAME="$1"
ARTIFACT_PATH="${2:-}"
shift 1
if [ -n "$ARTIFACT_PATH" ]; then
    shift 1
fi
ADDITIONAL_CONTEXT="$*"

# Load configurations
ROLE_CONFIG_FILE="$WORKFLOW_DIR/role-config.json"
TOOL_CONFIG_FILE="$WORKFLOW_DIR/tool-config.json"

if [ ! -f "$ROLE_CONFIG_FILE" ]; then
    echo "Error: Role config not found: $ROLE_CONFIG_FILE" >&2
    exit 1
fi

if [ ! -f "$TOOL_CONFIG_FILE" ]; then
    echo "Error: Tool config not found: $TOOL_CONFIG_FILE" >&2
    exit 1
fi

# Look up role configuration
ROLE_DEF=$(jq -r --arg role "$ROLE_NAME" '.[$role] // empty' "$ROLE_CONFIG_FILE")
if [ -z "$ROLE_DEF" ]; then
    echo "Error: Unknown role: $ROLE_NAME" >&2
    echo "" >&2
    echo "Available roles:" >&2
    jq -r 'keys[]' "$ROLE_CONFIG_FILE" | sed 's/^/  /' >&2
    exit 1
fi

TOOL=$(echo "$ROLE_DEF" | jq -r '.tool')
MODEL=$(echo "$ROLE_DEF" | jq -r '.model')
INTERACTIVE=$(echo "$ROLE_DEF" | jq -r '.interactive // false')
REASONING_EFFORT=$(echo "$ROLE_DEF" | jq -r '.reasoning_effort // empty')

# Look up tool configuration
TOOL_DEF=$(jq -r --arg tool "$TOOL" '.[$tool] // empty' "$TOOL_CONFIG_FILE")
if [ -z "$TOOL_DEF" ]; then
    echo "Error: Unknown tool: $TOOL" >&2
    exit 1
fi

ENTRY_POINT=$(echo "$TOOL_DEF" | jq -r '.entry_point')
CLI=$(echo "$TOOL_DEF" | jq -r '.cli')

# Verify CLI is installed
if ! command -v "$CLI" &> /dev/null; then
    echo "Error: $CLI is not installed or not in PATH" >&2
    exit 1
fi

# Build role file path
ROLE_FILE="$WORKFLOW_DIR/role-$ROLE_NAME.md"
if [ ! -f "$ROLE_FILE" ]; then
    echo "Error: Role file not found: $ROLE_FILE" >&2
    exit 1
fi

# Build initialization message
build_init_message() {
    echo "Read $ENTRY_POINT and follow the document graph to understand this project."
    echo ""
    echo "Now read and assume the role defined in Workflow/role-$ROLE_NAME.md"
    echo ""

    if [ -n "$ARTIFACT_PATH" ]; then
        echo "Artifact: $ARTIFACT_PATH"
        echo ""
    fi

    if [ -n "$ADDITIONAL_CONTEXT" ]; then
        echo "Additional context: $ADDITIONAL_CONTEXT"
        echo ""
    fi
}

# Change to project root for execution
cd "$PROJECT_ROOT"

# Execute based on tool and mode
case "$TOOL" in
    claude)
        if [ "$INTERACTIVE" = "true" ]; then
            # Interactive Claude session
            echo "=== Starting Claude in interactive mode ===" >&2
            echo "Role: $ROLE_NAME" >&2
            echo "Model: $MODEL" >&2
            echo "" >&2
            echo "Copy/paste this initialization message:" >&2
            echo "────────────────────────────────────────" >&2
            build_init_message
            echo "────────────────────────────────────────" >&2
            echo "" >&2
            exec claude --model "$MODEL"
        else
            # One-shot Claude
            build_init_message | exec claude --model "$MODEL" --print
        fi
        ;;

    codex)
        # Build codex command
        CODEX_CMD="codex exec --full-auto -m $MODEL"

        if [ -n "$REASONING_EFFORT" ]; then
            CODEX_CMD="$CODEX_CMD -c model_reasoning_effort=$REASONING_EFFORT"
        fi

        if [ "$INTERACTIVE" = "true" ]; then
            echo "Warning: Interactive mode not well-supported for codex" >&2
            echo "Starting interactive codex session..." >&2
            # For interactive, just show the init message and start codex
            echo "=== Initialization message ===" >&2
            build_init_message
            echo "==============================" >&2
            exec codex -m "$MODEL"
        else
            # One-shot codex
            build_init_message | eval exec "$CODEX_CMD"
        fi
        ;;

    gemini)
        if [ "$INTERACTIVE" = "true" ]; then
            echo "=== Starting Gemini in interactive mode ===" >&2
            echo "Role: $ROLE_NAME" >&2
            echo "Model: $MODEL" >&2
            echo "" >&2
            echo "Copy/paste this initialization message:" >&2
            echo "────────────────────────────────────────" >&2
            build_init_message
            echo "────────────────────────────────────────" >&2
            echo "" >&2
            exec gemini -m "$MODEL"
        else
            # One-shot Gemini
            INIT_MSG=$(build_init_message)
            exec gemini -m "$MODEL" -p "$INIT_MSG"
        fi
        ;;

    opencode)
        if [ "$INTERACTIVE" = "true" ]; then
            echo "=== Starting OpenCode in interactive mode ===" >&2
            echo "Role: $ROLE_NAME" >&2
            echo "Model: $MODEL" >&2
            echo "" >&2
            echo "Paste this initialization message:" >&2
            echo "────────────────────────────────────────" >&2
            build_init_message
            echo "────────────────────────────────────────" >&2
            echo "" >&2
            exec opencode -m "$MODEL"
        else
            # One-shot OpenCode
            INIT_MSG=$(build_init_message)
            exec opencode run -m "$MODEL" "$INIT_MSG"
        fi
        ;;

    *)
        echo "Error: Unsupported tool: $TOOL" >&2
        exit 1
        ;;
esac
