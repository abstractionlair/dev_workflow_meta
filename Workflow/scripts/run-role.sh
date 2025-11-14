#!/usr/bin/env bash
set -euo pipefail

# run-role.sh - Launch AI tool in appropriate role
#
# Usage: ./run-role.sh [OPTIONS] <role-name> [artifact-path] [additional-context...]
#
# Options:
#   -i, --interactive           Force interactive mode (default: one-shot)
#   --with-email                Enable email checking before/after work
#   --email-poll-interval SEC   Check email every SEC seconds during work
#
# Examples:
#   ./run-role.sh spec-reviewer specs/proposed/user-auth.md
#   ./run-role.sh -i spec-writer
#   ./run-role.sh --with-email spec-reviewer specs/proposed/user-auth.md
#   ./run-role.sh -i --with-email --email-poll-interval 300 implementer

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOW_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$WORKFLOW_DIR/.." && pwd)"

# Check dependencies
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed." >&2
    echo "Install with: brew install jq" >&2
    exit 1
fi

# Parse flags
INTERACTIVE=false
WITH_EMAIL=false
EMAIL_POLL_INTERVAL=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -i|--interactive)
            INTERACTIVE=true
            shift
            ;;
        --with-email)
            WITH_EMAIL=true
            shift
            ;;
        --email-poll-interval)
            EMAIL_POLL_INTERVAL="$2"
            shift 2
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

# Parse arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 [-i] <role-name> [artifact-path] [additional-context...]" >&2
    echo "" >&2
    echo "Options:" >&2
    echo "  -i, --interactive    Force interactive mode" >&2
    echo "" >&2
    echo "Available roles:" >&2
    jq -r 'keys[]' "$WORKFLOW_DIR/role-config.json" | sed 's/^/  /' >&2
    exit 1
fi

ROLE_NAME="$1"
shift

ARTIFACT_PATH=""
ADDITIONAL_CONTEXT=""

# Next arg could be artifact path or additional context
if [ $# -gt 0 ]; then
    # If it looks like a file path, treat as artifact
    if [[ "$1" == *"/"* ]] || [[ "$1" == *.* ]]; then
        ARTIFACT_PATH="$1"
        shift
    fi
fi

# Everything else is additional context
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

# Build system prompt (for Claude --append-system-prompt)
build_system_prompt() {
    cat <<EOF
First, read $ENTRY_POINT and follow the document graph to understand this project.

Then assume the following role:

$(cat "$ROLE_FILE")
EOF
}

# Build task message (what to actually do)
build_task_message() {
    local message=""

    if [ -n "$ARTIFACT_PATH" ]; then
        message="Artifact: $ARTIFACT_PATH"
    fi

    if [ -n "$ADDITIONAL_CONTEXT" ]; then
        if [ -n "$message" ]; then
            message="$message

Additional context: $ADDITIONAL_CONTEXT"
        else
            message="Additional context: $ADDITIONAL_CONTEXT"
        fi
    fi

    echo "$message"
}

# Build initialization message (for tools without --append-system-prompt)
build_init_message() {
    echo "Read $ENTRY_POINT and follow the document graph to understand this project."
    echo ""
    echo "Now read and assume the role defined in Workflow/role-$ROLE_NAME.md"
    echo ""

    local task=$(build_task_message)
    if [ -n "$task" ]; then
        echo "$task"
    fi
}

# Email checking functions (Phase 1 - event-driven notifications)
check_email_inbox() {
    local role="$1"

    # TODO: Implement actual email checking when email system is integrated (Milestone 1, part 2)
    # For now, emit informative message

    if [ "$WITH_EMAIL" = "true" ]; then
        echo "=== Email Check (before work) ===" >&2
        echo "Role: $role" >&2
        echo "" >&2
        echo "Note: Email system integration pending (Milestone 1, part 2)" >&2
        echo "When integrated, would check: ~/.maildir/workflow/$role/new/" >&2
        echo "" >&2

        # Future implementation:
        # MAILDIR="${HOME}/.maildir/workflow/${role}/new"
        # if [ -d "$MAILDIR" ]; then
        #     NEW_MSGS=$(find "$MAILDIR" -type f | wc -l)
        #     if [ "$NEW_MSGS" -gt 0 ]; then
        #         echo "You have $NEW_MSGS new message(s):" >&2
        #         # Display messages filtered by relevance
        #     fi
        # fi
    fi
}

check_email_after_work() {
    local role="$1"

    if [ "$WITH_EMAIL" = "true" ]; then
        echo "" >&2
        echo "=== Email Check (after work) ===" >&2
        echo "Role: $role" >&2
        echo "" >&2
        echo "Note: Email system integration pending (Milestone 1, part 2)" >&2
        echo "When integrated, would check: ~/.maildir/workflow/$role/new/" >&2
        echo "" >&2

        # Future implementation:
        # Check for new replies received during work
        # Display any urgent messages
    fi
}

setup_email_polling() {
    local interval="$1"
    local role="$2"

    if [ -n "$interval" ]; then
        echo "Note: Email polling ($interval seconds) will be available in Milestone 1, part 2" >&2

        # Future implementation:
        # Background process that checks email every $interval seconds
        # Notifies role if urgent messages arrive
    fi
}

# Change to project root for execution
cd "$PROJECT_ROOT"

# Pre-work email check
if [ "$WITH_EMAIL" = "true" ]; then
    check_email_inbox "$ROLE_NAME"

    if [ -n "$EMAIL_POLL_INTERVAL" ]; then
        setup_email_polling "$EMAIL_POLL_INTERVAL" "$ROLE_NAME"
    fi
fi

# Execute based on tool and mode
case "$TOOL" in
    claude)
        SYSTEM_PROMPT=$(build_system_prompt)
        TASK_MSG=$(build_task_message)

        if [ "$INTERACTIVE" = "true" ]; then
            # Interactive Claude with system prompt
            if [ -n "$TASK_MSG" ]; then
                echo "=== Starting Claude in interactive mode ===" >&2
                echo "Role: $ROLE_NAME" >&2
                echo "Model: $MODEL" >&2
                echo "" >&2
                echo "Initial task: $TASK_MSG" >&2
                echo "" >&2
                claude --model "$MODEL" --append-system-prompt "$SYSTEM_PROMPT" "$TASK_MSG"
            else
                claude --model "$MODEL" --append-system-prompt "$SYSTEM_PROMPT"
            fi
        else
            # One-shot Claude
            if [ -z "$TASK_MSG" ]; then
                echo "Error: One-shot mode requires artifact-path or additional-context" >&2
                echo "Use -i for interactive mode" >&2
                exit 1
            fi
            claude --model "$MODEL" --append-system-prompt "$SYSTEM_PROMPT" --print "$TASK_MSG"
        fi
        ;;

    codex)
        INIT_MSG=$(build_init_message)

        if [ "$INTERACTIVE" = "true" ]; then
            # Interactive with initial prompt (passed as argument to preserve TTY)
            echo "=== Starting Codex in interactive mode ===" >&2
            echo "Role: $ROLE_NAME" >&2
            echo "Model: $MODEL" >&2
            echo "" >&2

            # Pass init message as positional argument (not via stdin)
            # This keeps stdin/stdout as TTYs, so codex stays interactive
            codex -m "$MODEL" "$INIT_MSG"
        else
            # One-shot codex
            CODEX_CMD="codex exec --full-auto -m $MODEL"

            if [ -n "$REASONING_EFFORT" ]; then
                CODEX_CMD="$CODEX_CMD -c model_reasoning_effort=$REASONING_EFFORT"
            fi

            build_init_message | eval "$CODEX_CMD"
        fi
        ;;

    gemini)
        INIT_MSG=$(build_init_message)

        if [ "$INTERACTIVE" = "true" ]; then
            # Interactive with initial prompt
            echo "=== Starting Gemini in interactive mode ===" >&2
            echo "Role: $ROLE_NAME" >&2
            echo "Model: $MODEL" >&2
            echo "" >&2
            gemini -m "$MODEL" -i "$INIT_MSG"
        else
            # One-shot
            gemini -m "$MODEL" -p "$INIT_MSG"
        fi
        ;;

    opencode)
        INIT_MSG=$(build_init_message)

        if [ "$INTERACTIVE" = "true" ]; then
            # Interactive with initial prompt
            echo "=== Starting OpenCode in interactive mode ===" >&2
            echo "Role: $ROLE_NAME" >&2
            echo "Model: $MODEL" >&2
            echo "" >&2
            opencode -m "$MODEL" -p "$INIT_MSG"
        else
            # One-shot
            opencode run -m "$MODEL" "$INIT_MSG"
        fi
        ;;

    *)
        echo "Error: Unsupported tool: $TOOL" >&2
        exit 1
        ;;
esac

# Post-work email check
if [ "$WITH_EMAIL" = "true" ]; then
    check_email_after_work "$ROLE_NAME"
fi
