#!/usr/bin/env bash
set -euo pipefail

# workflow-notify.sh - Generate workflow event notifications
#
# Usage: ./workflow-notify.sh [OPTIONS] <event-type> <artifact-path> <recipient-role> [key=value...]
#
# Options:
#   --send              Send via email (requires email system integration)
#   --from <role>       Specify sender role (default: auto-detect from context)
#   --session <id>      Specify session ID
#   --in-reply-to <id>  Mark as reply to message ID
#   --help              Show this help message
#
# Arguments:
#   event-type          Type of event (review-request, approval, rejection, clarification-request)
#   artifact-path       Path to primary artifact
#   recipient-role      Role to receive notification (can be comma-separated list)
#   key=value           Additional template variables (e.g., CONTEXT="Focus on error handling")
#
# Examples:
#   # Generate review request
#   ./workflow-notify.sh review-request specs/proposed/user-auth.md spec-reviewer
#
#   # Generate approval with custom variables
#   ./workflow-notify.sh approval specs/todo/user-auth.md spec-writer \
#     NEXT_ROLES="skeleton-writer,test-writer" \
#     NEXT_STATE="todo"
#
#   # Generate rejection with feedback
#   ./workflow-notify.sh rejection specs/proposed/api.md spec-writer \
#     REVIEWER_COMMENTS="Missing error handling section"
#
#   # Send via email (when integrated)
#   ./workflow-notify.sh --send review-request specs/proposed/auth.md spec-reviewer

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOW_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$WORKFLOW_DIR/email-templates"

# Parse options
SEND_EMAIL=false
FROM_ROLE=""
SESSION_ID=""
IN_REPLY_TO=""
REFERENCES=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --send)
            SEND_EMAIL=true
            shift
            ;;
        --from)
            FROM_ROLE="$2"
            shift 2
            ;;
        --session)
            SESSION_ID="$2"
            shift 2
            ;;
        --in-reply-to)
            IN_REPLY_TO="$2"
            shift 2
            ;;
        --help)
            sed -n '3,28p' "$0" | sed 's/^# //' | sed 's/^#//'
            exit 0
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
            echo "Use --help for usage information" >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

# Parse required arguments
if [ $# -lt 3 ]; then
    echo "Error: Missing required arguments" >&2
    echo "" >&2
    echo "Usage: $0 [OPTIONS] <event-type> <artifact-path> <recipient-role> [key=value...]" >&2
    echo "Use --help for more information" >&2
    exit 1
fi

EVENT_TYPE="$1"
ARTIFACT_PATH="$2"
TO_ROLE="$3"
shift 3

# Validate event type
VALID_EVENTS="review-request approval rejection clarification-request blocker-report status-update question answer"
if [[ ! " $VALID_EVENTS " =~ " $EVENT_TYPE " ]]; then
    echo "Error: Invalid event type: $EVENT_TYPE" >&2
    echo "Valid types: $VALID_EVENTS" >&2
    exit 1
fi

# Find template file
TEMPLATE_FILE="$TEMPLATE_DIR/${EVENT_TYPE}.txt"
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template not found: $TEMPLATE_FILE" >&2
    echo "Available templates:" >&2
    ls -1 "$TEMPLATE_DIR"/*.txt 2>/dev/null | xargs -n1 basename | sed 's/^/  /' >&2
    exit 1
fi

# Auto-detect sender role from current context if not specified
if [ -z "$FROM_ROLE" ]; then
    # Try to detect from git branch or working directory
    # For now, use generic "workflow" sender
    FROM_ROLE="workflow"
fi

# Extract artifact name from path
ARTIFACT_NAME=$(basename "$ARTIFACT_PATH" | sed 's/\.[^.]*$//')

# Detect workflow state from artifact path
WORKFLOW_STATE="unknown"
if [[ "$ARTIFACT_PATH" =~ (^|/)proposed/ ]]; then
    WORKFLOW_STATE="proposed"
elif [[ "$ARTIFACT_PATH" =~ (^|/)todo/ ]]; then
    WORKFLOW_STATE="todo"
elif [[ "$ARTIFACT_PATH" =~ (^|/)doing/ ]]; then
    WORKFLOW_STATE="doing"
elif [[ "$ARTIFACT_PATH" =~ (^|/)done/ ]]; then
    WORKFLOW_STATE="done"
elif [[ "$ARTIFACT_PATH" =~ (^|/)blocked/ ]]; then
    WORKFLOW_STATE="blocked"
elif [[ "$ARTIFACT_PATH" =~ (^|/)deferred/ ]]; then
    WORKFLOW_STATE="deferred"
fi

# Detect review type from artifact path
REVIEW_TYPE="artifact"
if [[ "$ARTIFACT_PATH" =~ (^|/)specs/ ]]; then
    REVIEW_TYPE="specification"
elif [[ "$ARTIFACT_PATH" =~ (^|/)skeleton/ ]] || [[ "$ARTIFACT_PATH" =~ interface ]]; then
    REVIEW_TYPE="interface skeleton"
elif [[ "$ARTIFACT_PATH" =~ (^|/)tests/ ]] || [[ "$ARTIFACT_PATH" =~ test ]]; then
    REVIEW_TYPE="test suite"
elif [[ "$ARTIFACT_PATH" =~ (^|/)src/ ]] || [[ "$ARTIFACT_PATH" =~ implementation ]]; then
    REVIEW_TYPE="implementation"
elif [[ "$ARTIFACT_PATH" =~ VISION ]] || [[ "$ARTIFACT_PATH" =~ vision ]]; then
    REVIEW_TYPE="vision document"
elif [[ "$ARTIFACT_PATH" =~ SCOPE ]] || [[ "$ARTIFACT_PATH" =~ scope ]]; then
    REVIEW_TYPE="scope document"
elif [[ "$ARTIFACT_PATH" =~ ROADMAP ]] || [[ "$ARTIFACT_PATH" =~ roadmap ]]; then
    REVIEW_TYPE="roadmap document"
fi

# Generate timestamp and message ID
DATE=$(date -R 2>/dev/null || date "+%a, %d %b %Y %H:%M:%S %z")
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
MESSAGE_ID="<${TIMESTAMP}.${FROM_ROLE}@workflow.local>"

# Build references header if this is a reply
if [ -n "$IN_REPLY_TO" ]; then
    if [ -n "$REFERENCES" ]; then
        REFERENCES="$REFERENCES $IN_REPLY_TO"
    else
        REFERENCES="$IN_REPLY_TO"
    fi
fi

# Initialize template variables with defaults
declare -A TEMPLATE_VARS=(
    ["FROM_ROLE"]="$FROM_ROLE"
    ["TO_ROLE"]="$TO_ROLE"
    ["EVENT_TYPE"]="$EVENT_TYPE"
    ["ARTIFACT_PATH"]="$ARTIFACT_PATH"
    ["ARTIFACT_NAME"]="$ARTIFACT_NAME"
    ["WORKFLOW_STATE"]="$WORKFLOW_STATE"
    ["REVIEW_TYPE"]="$REVIEW_TYPE"
    ["DATE"]="$DATE"
    ["MESSAGE_ID"]="$MESSAGE_ID"
    ["SESSION_ID"]="$SESSION_ID"
    ["IN_REPLY_TO"]="$IN_REPLY_TO"
    ["REFERENCES"]="$REFERENCES"
    ["CONTEXT"]=""
    ["REVIEWER_COMMENTS"]=""
    ["NEXT_STATE"]=""
    ["NEXT_ROLES"]=""
    ["NEXT_ACTIONS"]=""
    ["QUESTION"]=""
    ["BLOCKING"]="no"
    ["BLOCKING_DETAILS"]=""
    ["ISSUES_FOUND"]=""
)

# Parse additional key=value arguments
for arg in "$@"; do
    if [[ "$arg" =~ ^([A-Z_]+)=(.*)$ ]]; then
        KEY="${BASH_REMATCH[1]}"
        VALUE="${BASH_REMATCH[2]}"
        TEMPLATE_VARS["$KEY"]="$VALUE"
    else
        echo "Warning: Ignoring invalid argument: $arg" >&2
    fi
done

# Function to substitute template variables
substitute_vars() {
    local content="$1"
    local result="$content"

    for key in "${!TEMPLATE_VARS[@]}"; do
        local value="${TEMPLATE_VARS[$key]}"
        # Escape special characters in value for sed
        local escaped_value=$(printf '%s\n' "$value" | sed 's/[&/\]/\\&/g')
        result=$(echo "$result" | sed "s|{{${key}}}|${escaped_value}|g")
    done

    echo "$result"
}

# Function to remove empty optional sections
clean_empty_sections() {
    local content="$1"

    # Remove lines that contain only empty variable substitutions
    echo "$content" | grep -v '{{[A-Z_]*}}$' || true

    # If last line is empty, preserve it (blank line before signature)
    # Otherwise add it
    if [[ ! "$content" =~ $'\n'$ ]]; then
        echo ""
    fi
}

# Read and process template
TEMPLATE_CONTENT=$(cat "$TEMPLATE_FILE")
MESSAGE=$(substitute_vars "$TEMPLATE_CONTENT")
MESSAGE=$(clean_empty_sections "$MESSAGE")

# Remove header lines with empty values (except mandatory headers)
# This handles optional headers like In-Reply-To when not replying
MESSAGE=$(echo "$MESSAGE" | awk '
BEGIN { in_headers = 1 }
/^$/ { in_headers = 0; print; next }
in_headers && /^(In-Reply-To|References|X-Session-Id): $/ { next }
{ print }
')

# Output or send message
if [ "$SEND_EMAIL" = true ]; then
    # Send via email_tools.py (writes to temp file to avoid escape issues)
    TEMP_MESSAGE=$(mktemp)
    echo "$MESSAGE" > "$TEMP_MESSAGE"

    # Determine maildir path (can be overridden by environment variable)
    MAILDIR_PATH="${WORKFLOW_MAILDIR:-$HOME/Maildir/workflow}"

    # Send using email_tools.py
    if "$SCRIPT_DIR/email_tools.py" send "$TEMP_MESSAGE" "$MAILDIR_PATH"; then
        rm "$TEMP_MESSAGE"
        echo "Message sent to $TO_ROLE at $MAILDIR_PATH" >&2
    else
        rm "$TEMP_MESSAGE"
        echo "Error: Failed to send email" >&2
        exit 1
    fi
else
    # Output to stdout
    echo "$MESSAGE"
fi
