#!/usr/bin/env bash
set -euo pipefail

# reviewer-daemon.sh - Continuous polling daemon for review requests
#
# Usage: ./reviewer-daemon.sh <role-name>
#
# This daemon continuously monitors for review requests and automatically
# invokes the reviewer when messages arrive. Designed for Phase 2 of the
# email integration (Lightweight Supervision).
#
# Features:
# - Continuous polling loop (configurable interval)
# - Timeout protection (10 minutes per invocation by default)
# - Activity logging to logs/daemon-${ROLE}.log
# - PID file management for daemon control
# - Graceful shutdown on SIGTERM/SIGINT
#
# Examples:
#   # Start daemon for spec-reviewer
#   ./reviewer-daemon.sh spec-reviewer
#
#   # Run in foreground for debugging
#   DEBUG=1 ./reviewer-daemon.sh spec-reviewer

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOW_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$WORKFLOW_DIR/.." && pwd)"

# Configuration
POLL_INTERVAL="${POLL_INTERVAL:-60}"  # Check every 60 seconds
TIMEOUT="${TIMEOUT:-600}"             # 10 minute timeout per invocation
MAILDIR_ROOT="${HOME}/.maildir/workflow"
LOG_DIR="${PROJECT_ROOT}/logs"
PID_DIR="${PROJECT_ROOT}/.pids"

# Parse arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 <role-name>" >&2
    echo "" >&2
    echo "Environment variables:" >&2
    echo "  POLL_INTERVAL  Seconds between checks (default: 60)" >&2
    echo "  TIMEOUT        Timeout per invocation in seconds (default: 600)" >&2
    echo "  DEBUG          Set to 1 to run in foreground with verbose output" >&2
    exit 1
fi

ROLE_NAME="$1"

# Validate role exists
ROLE_CONFIG_FILE="$WORKFLOW_DIR/role-config.json"
if [ ! -f "$ROLE_CONFIG_FILE" ]; then
    echo "Error: Role config not found: $ROLE_CONFIG_FILE" >&2
    exit 1
fi

if ! jq -e --arg role "$ROLE_NAME" '.[$role]' "$ROLE_CONFIG_FILE" > /dev/null 2>&1; then
    echo "Error: Unknown role: $ROLE_NAME" >&2
    echo "" >&2
    echo "Available roles:" >&2
    jq -r 'keys[]' "$ROLE_CONFIG_FILE" | sed 's/^/  /' >&2
    exit 1
fi

# Create necessary directories
mkdir -p "$LOG_DIR"
mkdir -p "$PID_DIR"
mkdir -p "$MAILDIR_ROOT/$ROLE_NAME"/{new,cur,tmp}

# Set up logging
LOG_FILE="$LOG_DIR/daemon-${ROLE_NAME}.log"
PID_FILE="$PID_DIR/daemon-${ROLE_NAME}.pid"

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE" >&2
}

# Signal handlers for graceful shutdown
SHUTDOWN_REQUESTED=false

handle_shutdown() {
    log "INFO" "Shutdown signal received"
    SHUTDOWN_REQUESTED=true
}

trap handle_shutdown SIGTERM SIGINT

# Write PID file
echo $$ > "$PID_FILE"
log "INFO" "Daemon started for role: $ROLE_NAME (PID: $$)"
log "INFO" "Poll interval: ${POLL_INTERVAL}s, Timeout: ${TIMEOUT}s"
log "INFO" "Maildir: $MAILDIR_ROOT/$ROLE_NAME"
log "INFO" "Log file: $LOG_FILE"

# Function to check for new review requests
check_for_review_requests() {
    local new_dir="$MAILDIR_ROOT/$ROLE_NAME/new"
    local cur_dir="$MAILDIR_ROOT/$ROLE_NAME/cur"

    # Count new messages
    local new_count=0
    if [ -d "$new_dir" ]; then
        new_count=$(find "$new_dir" -type f 2>/dev/null | wc -l | tr -d ' ')
    fi

    if [ "$new_count" -gt 0 ]; then
        log "INFO" "Found $new_count new message(s)"

        # Move messages from new/ to cur/ (mark as seen)
        find "$new_dir" -type f 2>/dev/null | while read -r msg_file; do
            local basename=$(basename "$msg_file")
            mv "$msg_file" "$cur_dir/${basename}:2,S" 2>/dev/null || true
        done

        return 0  # Has new messages
    fi

    return 1  # No new messages
}

# Function to find review-request messages
find_review_requests() {
    local cur_dir="$MAILDIR_ROOT/$ROLE_NAME/cur"

    if [ ! -d "$cur_dir" ]; then
        return 1
    fi

    # Find unprocessed review-request messages
    # Look for X-Event-Type: review-request in message headers
    find "$cur_dir" -type f 2>/dev/null | while read -r msg_file; do
        # Extract headers (everything before first blank line)
        local headers=$(sed '/^$/q' "$msg_file")

        if echo "$headers" | grep -q "^X-Event-Type: review-request"; then
            # Check if already processed (marked with :2,SR flag)
            if [[ ! "$msg_file" =~ :2,.*R ]]; then
                echo "$msg_file"
            fi
        fi
    done
}

# Function to extract artifact path from message
extract_artifact_path() {
    local msg_file="$1"

    # Extract X-Artifacts header
    local artifact=$(grep "^X-Artifacts:" "$msg_file" | head -1 | cut -d' ' -f2- | tr -d '\r')

    # If it's a glob pattern, resolve it
    if [[ "$artifact" == *"*"* ]]; then
        # Find first match
        local resolved=$(find "$PROJECT_ROOT" -path "*/$artifact" 2>/dev/null | head -1)
        if [ -n "$resolved" ]; then
            # Make relative to project root
            artifact="${resolved#$PROJECT_ROOT/}"
        fi
    fi

    echo "$artifact"
}

# Function to extract additional context from message
extract_context() {
    local msg_file="$1"

    # Extract body (everything after first blank line)
    local body=$(sed '1,/^$/d' "$msg_file")

    # Extract context if present
    local context=$(echo "$body" | grep "^Context:" | head -1 | cut -d: -f2- | sed 's/^ *//')

    echo "$context"
}

# Function to mark message as processed
mark_message_processed() {
    local msg_file="$1"
    local basename=$(basename "$msg_file")
    local dirname=$(dirname "$msg_file")

    # Add 'R' flag (replied/processed)
    if [[ "$basename" =~ :2, ]]; then
        # Already has flags, add R if not present
        if [[ ! "$basename" =~ R ]]; then
            local new_basename="${basename}R"
            mv "$msg_file" "$dirname/$new_basename" 2>/dev/null || true
        fi
    else
        # No flags yet, add :2,SR
        mv "$msg_file" "$dirname/${basename}:2,SR" 2>/dev/null || true
    fi
}

# Function to invoke reviewer with timeout
invoke_reviewer() {
    local artifact_path="$1"
    local context="$2"

    log "INFO" "Invoking reviewer for: $artifact_path"
    if [ -n "$context" ]; then
        log "INFO" "Context: $context"
    fi

    # Build command
    local cmd="$SCRIPT_DIR/run-role.sh $ROLE_NAME"

    if [ -n "$artifact_path" ]; then
        cmd="$cmd \"$artifact_path\""
    fi

    if [ -n "$context" ]; then
        cmd="$cmd \"$context\""
    fi

    # Run with timeout
    local start_time=$(date +%s)
    local temp_log=$(mktemp)

    if timeout "$TIMEOUT" bash -c "$cmd" > "$temp_log" 2>&1; then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        log "INFO" "Review completed successfully in ${duration}s"

        # Log output if in debug mode
        if [ "${DEBUG:-0}" = "1" ]; then
            log "DEBUG" "Review output:"
            cat "$temp_log" | tee -a "$LOG_FILE" >&2
        fi

        rm -f "$temp_log"
        return 0
    else
        local exit_code=$?
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))

        if [ $exit_code -eq 124 ]; then
            log "ERROR" "Review timed out after ${TIMEOUT}s"
        else
            log "ERROR" "Review failed with exit code $exit_code after ${duration}s"
        fi

        # Log error output
        log "ERROR" "Review output:"
        cat "$temp_log" | tee -a "$LOG_FILE" >&2

        rm -f "$temp_log"
        return $exit_code
    fi
}

# Main polling loop
log "INFO" "Starting polling loop"

while [ "$SHUTDOWN_REQUESTED" = "false" ]; do
    # Check for new messages
    if check_for_review_requests; then
        # Find and process review requests
        local requests=$(find_review_requests)

        if [ -n "$requests" ]; then
            local request_count=$(echo "$requests" | wc -l | tr -d ' ')
            log "INFO" "Processing $request_count review request(s)"

            echo "$requests" | while read -r msg_file; do
                if [ "$SHUTDOWN_REQUESTED" = "true" ]; then
                    log "INFO" "Shutdown requested, stopping processing"
                    break
                fi

                log "INFO" "Processing message: $(basename "$msg_file")"

                # Extract information from message
                local artifact_path=$(extract_artifact_path "$msg_file")
                local context=$(extract_context "$msg_file")

                # Invoke reviewer
                if invoke_reviewer "$artifact_path" "$context"; then
                    mark_message_processed "$msg_file"
                    log "INFO" "Message processed successfully"
                else
                    log "ERROR" "Failed to process message, leaving unprocessed for retry"
                fi
            done
        fi
    fi

    # Sleep until next poll, but check for shutdown every second
    local remaining=$POLL_INTERVAL
    while [ $remaining -gt 0 ] && [ "$SHUTDOWN_REQUESTED" = "false" ]; do
        sleep 1
        remaining=$((remaining - 1))
    done
done

# Cleanup
log "INFO" "Daemon shutting down"
rm -f "$PID_FILE"
log "INFO" "Daemon stopped"

exit 0
