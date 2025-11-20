#!/usr/bin/env bash
set -euo pipefail

# email-helper.sh - Model-friendly email interface
#
# This script provides convenient commands for AI models to interact with email.
# Uses email-tools.py for efficient operations without reading entire maildir.
#
# Usage: ./email-helper.sh <command> [args...]
#
# Commands:
#   check-new                       Check for new messages (unread)
#   find-reviews [artifact]         Find review requests for artifact
#   find-approvals [artifact]       Find approval messages
#   find-clarifications [artifact]  Find clarification requests
#   find-blockers                   Find blocker reports
#   recent [days]                   Show recent messages (default: 7 days)
#   read <key>                      Read full message by key
#   thread <message-id>             Show entire thread
#   list [event-type]               List messages by type
#
# Examples:
#   ./email-helper.sh check-new
#   ./email-helper.sh find-reviews auth.md
#   ./email-helper.sh recent 3
#   ./email-helper.sh read 1234567890.12345_1.host
#   ./email-helper.sh thread "<20251120120000.spec-writer@workflow.local>"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EMAIL_TOOLS="$SCRIPT_DIR/email-tools.py"

# Get maildir path from environment or use default
MAILDIR_PATH="${WORKFLOW_MAILDIR:-$HOME/Maildir/workflow}"

# Check if email-tools.py exists
if [ ! -f "$EMAIL_TOOLS" ]; then
    echo "Error: email-tools.py not found at $EMAIL_TOOLS" >&2
    exit 1
fi

# Check if maildir exists
if [ ! -d "$MAILDIR_PATH" ]; then
    echo "Notice: Maildir does not exist yet: $MAILDIR_PATH" >&2
    echo "It will be created when the first email is sent." >&2
fi

COMMAND="${1:-help}"
shift || true

case "$COMMAND" in
    check-new)
        echo "Checking for new messages in $MAILDIR_PATH..."
        echo ""
        # List recent messages from last 24 hours
        "$EMAIL_TOOLS" list "$MAILDIR_PATH" --limit 10
        ;;

    find-reviews)
        ARTIFACT="${1:-}"
        echo "Finding review requests${ARTIFACT:+ for $ARTIFACT}..."
        echo ""
        if [ -n "$ARTIFACT" ]; then
            "$EMAIL_TOOLS" search "$MAILDIR_PATH" --event-type review-request --artifact "$ARTIFACT" --limit 20
        else
            "$EMAIL_TOOLS" search "$MAILDIR_PATH" --event-type review-request --limit 20
        fi
        ;;

    find-approvals)
        ARTIFACT="${1:-}"
        echo "Finding approval messages${ARTIFACT:+ for $ARTIFACT}..."
        echo ""
        if [ -n "$ARTIFACT" ]; then
            "$EMAIL_TOOLS" search "$MAILDIR_PATH" --event-type approval --artifact "$ARTIFACT" --limit 20
        else
            "$EMAIL_TOOLS" search "$MAILDIR_PATH" --event-type approval --limit 20
        fi
        ;;

    find-clarifications)
        ARTIFACT="${1:-}"
        echo "Finding clarification requests${ARTIFACT:+ for $ARTIFACT}..."
        echo ""
        if [ -n "$ARTIFACT" ]; then
            "$EMAIL_TOOLS" search "$MAILDIR_PATH" --event-type clarification-request --artifact "$ARTIFACT" --limit 20
        else
            "$EMAIL_TOOLS" search "$MAILDIR_PATH" --event-type clarification-request --limit 20
        fi
        ;;

    find-blockers)
        echo "Finding blocker reports..."
        echo ""
        "$EMAIL_TOOLS" search "$MAILDIR_PATH" --event-type blocker-report --limit 20
        ;;

    recent)
        DAYS="${1:-7}"
        echo "Showing messages from last $DAYS days..."
        echo ""
        "$EMAIL_TOOLS" search "$MAILDIR_PATH" --since "${DAYS}d" --limit 50
        ;;

    read)
        if [ $# -lt 1 ]; then
            echo "Error: Message key required" >&2
            echo "Usage: $0 read <message-key>" >&2
            exit 1
        fi
        MESSAGE_KEY="$1"

        # Construct full path from key
        # Try cur/ first, then new/
        MESSAGE_PATH=""
        if [ -f "$MAILDIR_PATH/cur/$MESSAGE_KEY" ]; then
            MESSAGE_PATH="$MAILDIR_PATH/cur/$MESSAGE_KEY"
        elif [ -f "$MAILDIR_PATH/new/$MESSAGE_KEY" ]; then
            MESSAGE_PATH="$MAILDIR_PATH/new/$MESSAGE_KEY"
        else
            echo "Error: Message not found: $MESSAGE_KEY" >&2
            echo "Tried:" >&2
            echo "  $MAILDIR_PATH/cur/$MESSAGE_KEY" >&2
            echo "  $MAILDIR_PATH/new/$MESSAGE_KEY" >&2
            exit 1
        fi

        "$EMAIL_TOOLS" read "$MESSAGE_PATH"
        ;;

    thread)
        if [ $# -lt 1 ]; then
            echo "Error: Message-ID required" >&2
            echo "Usage: $0 thread <message-id>" >&2
            exit 1
        fi
        MESSAGE_ID="$1"
        echo "Finding thread for $MESSAGE_ID..."
        echo ""
        "$EMAIL_TOOLS" thread "$MAILDIR_PATH" "$MESSAGE_ID"
        ;;

    list)
        EVENT_TYPE="${1:-}"
        if [ -n "$EVENT_TYPE" ]; then
            echo "Listing $EVENT_TYPE messages..."
            echo ""
            "$EMAIL_TOOLS" list "$MAILDIR_PATH" --event-type "$EVENT_TYPE" --limit 20
        else
            echo "Listing all messages..."
            echo ""
            "$EMAIL_TOOLS" list "$MAILDIR_PATH" --limit 20
        fi
        ;;

    help|--help|-h)
        sed -n '3,19p' "$0" | sed 's/^# //' | sed 's/^#//'
        echo ""
        echo "Maildir location: $MAILDIR_PATH"
        echo "(Override with WORKFLOW_MAILDIR environment variable)"
        ;;

    *)
        echo "Error: Unknown command: $COMMAND" >&2
        echo "" >&2
        echo "Use '$0 help' for usage information" >&2
        exit 1
        ;;
esac
