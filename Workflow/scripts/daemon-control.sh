#!/usr/bin/env bash
set -euo pipefail

# daemon-control.sh - Manage workflow reviewer daemons
#
# Usage: ./daemon-control.sh <command> <role-name> [options]
#
# Commands:
#   start <role-name>       Start daemon in background
#   stop <role-name>        Stop running daemon
#   restart <role-name>     Restart daemon
#   status <role-name>      Check daemon status
#   logs <role-name>        Tail daemon logs
#   list                    List all running daemons
#
# Options (for start command):
#   --poll-interval SEC     Set poll interval (default: 60)
#   --timeout SEC           Set invocation timeout (default: 600)
#
# Examples:
#   # Start spec-reviewer daemon
#   ./daemon-control.sh start spec-reviewer
#
#   # Start with custom settings
#   ./daemon-control.sh start spec-reviewer --poll-interval 30 --timeout 300
#
#   # Check status
#   ./daemon-control.sh status spec-reviewer
#
#   # Stop daemon
#   ./daemon-control.sh stop spec-reviewer
#
#   # View logs
#   ./daemon-control.sh logs spec-reviewer

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOW_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$WORKFLOW_DIR/.." && pwd)"

LOG_DIR="${PROJECT_ROOT}/logs"
PID_DIR="${PROJECT_ROOT}/.pids"

# Colors for output
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    NC=''
fi

# Parse command
if [ $# -lt 1 ]; then
    echo "Usage: $0 <command> [role-name] [options]" >&2
    echo "" >&2
    echo "Commands:" >&2
    echo "  start <role-name>       Start daemon in background" >&2
    echo "  stop <role-name>        Stop running daemon" >&2
    echo "  restart <role-name>     Restart daemon" >&2
    echo "  status <role-name>      Check daemon status" >&2
    echo "  logs <role-name>        Tail daemon logs" >&2
    echo "  list                    List all running daemons" >&2
    exit 1
fi

COMMAND="$1"
shift

# Create necessary directories
mkdir -p "$LOG_DIR"
mkdir -p "$PID_DIR"

# Function to get PID file path
get_pid_file() {
    local role="$1"
    echo "$PID_DIR/daemon-${role}.pid"
}

# Function to get log file path
get_log_file() {
    local role="$1"
    echo "$LOG_DIR/daemon-${role}.log"
}

# Function to check if daemon is running
is_running() {
    local role="$1"
    local pid_file=$(get_pid_file "$role")

    if [ ! -f "$pid_file" ]; then
        return 1
    fi

    local pid=$(cat "$pid_file")

    # Check if process exists
    if kill -0 "$pid" 2>/dev/null; then
        return 0
    else
        # PID file exists but process doesn't, clean up
        rm -f "$pid_file"
        return 1
    fi
}

# Function to get daemon PID
get_pid() {
    local role="$1"
    local pid_file=$(get_pid_file "$role")

    if [ -f "$pid_file" ]; then
        cat "$pid_file"
    fi
}

# Command: start
cmd_start() {
    local role="$1"
    shift

    # Parse options
    local poll_interval=""
    local timeout=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --poll-interval)
                poll_interval="$2"
                shift 2
                ;;
            --timeout)
                timeout="$2"
                shift 2
                ;;
            *)
                echo "Error: Unknown option: $1" >&2
                exit 1
                ;;
        esac
    done

    # Check if already running
    if is_running "$role"; then
        local pid=$(get_pid "$role")
        echo -e "${YELLOW}Daemon already running${NC} for role: $role (PID: $pid)"
        return 1
    fi

    # Build environment variables
    local env_vars=""
    if [ -n "$poll_interval" ]; then
        env_vars="POLL_INTERVAL=$poll_interval"
    fi
    if [ -n "$timeout" ]; then
        env_vars="$env_vars TIMEOUT=$timeout"
    fi

    # Start daemon in background
    echo "Starting daemon for role: $role"

    local log_file=$(get_log_file "$role")

    if [ -n "$env_vars" ]; then
        env $env_vars nohup "$SCRIPT_DIR/reviewer-daemon.sh" "$role" >> "$log_file" 2>&1 &
    else
        nohup "$SCRIPT_DIR/reviewer-daemon.sh" "$role" >> "$log_file" 2>&1 &
    fi

    # Wait a moment for daemon to start
    sleep 2

    # Verify it started
    if is_running "$role"; then
        local pid=$(get_pid "$role")
        echo -e "${GREEN}✓ Daemon started successfully${NC} (PID: $pid)"
        echo "  Log file: $log_file"
        echo "  Use '$0 status $role' to check status"
        echo "  Use '$0 logs $role' to view logs"
        return 0
    else
        echo -e "${RED}✗ Failed to start daemon${NC}"
        echo "Check logs: $log_file"
        return 1
    fi
}

# Command: stop
cmd_stop() {
    local role="$1"

    if ! is_running "$role"; then
        echo -e "${YELLOW}Daemon not running${NC} for role: $role"
        return 1
    fi

    local pid=$(get_pid "$role")
    echo "Stopping daemon for role: $role (PID: $pid)"

    # Send SIGTERM for graceful shutdown
    kill -TERM "$pid" 2>/dev/null || true

    # Wait up to 10 seconds for graceful shutdown
    local wait_count=0
    while is_running "$role" && [ $wait_count -lt 10 ]; do
        sleep 1
        wait_count=$((wait_count + 1))
    done

    # If still running, force kill
    if is_running "$role"; then
        echo "Daemon did not stop gracefully, forcing..."
        kill -KILL "$pid" 2>/dev/null || true
        sleep 1
    fi

    # Verify stopped
    if ! is_running "$role"; then
        echo -e "${GREEN}✓ Daemon stopped${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to stop daemon${NC}"
        return 1
    fi
}

# Command: restart
cmd_restart() {
    local role="$1"
    shift

    echo "Restarting daemon for role: $role"

    if is_running "$role"; then
        cmd_stop "$role"
    fi

    sleep 1
    cmd_start "$role" "$@"
}

# Command: status
cmd_status() {
    local role="$1"

    echo "Daemon status for role: $role"
    echo ""

    if is_running "$role"; then
        local pid=$(get_pid "$role")
        local log_file=$(get_log_file "$role")

        echo -e "  Status: ${GREEN}RUNNING${NC}"
        echo "  PID: $pid"
        echo "  Log file: $log_file"

        # Show recent log entries
        if [ -f "$log_file" ]; then
            echo ""
            echo "Recent activity:"
            tail -5 "$log_file" | sed 's/^/    /'
        fi
    else
        local log_file=$(get_log_file "$role")

        echo -e "  Status: ${RED}NOT RUNNING${NC}"
        echo "  Log file: $log_file"

        # Show last error if log exists
        if [ -f "$log_file" ]; then
            local last_error=$(grep "\[ERROR\]" "$log_file" | tail -1)
            if [ -n "$last_error" ]; then
                echo ""
                echo "Last error:"
                echo "    $last_error"
            fi
        fi
    fi
}

# Command: logs
cmd_logs() {
    local role="$1"
    local log_file=$(get_log_file "$role")

    if [ ! -f "$log_file" ]; then
        echo "No log file found: $log_file"
        return 1
    fi

    echo "Tailing logs for role: $role"
    echo "Log file: $log_file"
    echo ""
    echo "Press Ctrl+C to stop"
    echo "---"

    tail -f "$log_file"
}

# Command: list
cmd_list() {
    echo "Running daemons:"
    echo ""

    local found_any=false

    # Check all PID files
    if [ -d "$PID_DIR" ]; then
        for pid_file in "$PID_DIR"/daemon-*.pid; do
            if [ -f "$pid_file" ]; then
                local basename=$(basename "$pid_file" .pid)
                local role="${basename#daemon-}"

                if is_running "$role"; then
                    local pid=$(get_pid "$role")
                    echo -e "  ${GREEN}●${NC} $role (PID: $pid)"
                    found_any=true
                else
                    # Clean up stale PID file
                    rm -f "$pid_file"
                fi
            fi
        done
    fi

    if [ "$found_any" = "false" ]; then
        echo "  (none)"
    fi

    echo ""
    echo "Use '$0 status <role-name>' for detailed status"
}

# Execute command
case "$COMMAND" in
    start)
        if [ $# -lt 1 ]; then
            echo "Error: start command requires role-name" >&2
            exit 1
        fi
        cmd_start "$@"
        ;;

    stop)
        if [ $# -lt 1 ]; then
            echo "Error: stop command requires role-name" >&2
            exit 1
        fi
        cmd_stop "$@"
        ;;

    restart)
        if [ $# -lt 1 ]; then
            echo "Error: restart command requires role-name" >&2
            exit 1
        fi
        cmd_restart "$@"
        ;;

    status)
        if [ $# -lt 1 ]; then
            echo "Error: status command requires role-name" >&2
            exit 1
        fi
        cmd_status "$@"
        ;;

    logs)
        if [ $# -lt 1 ]; then
            echo "Error: logs command requires role-name" >&2
            exit 1
        fi
        cmd_logs "$@"
        ;;

    list)
        cmd_list
        ;;

    *)
        echo "Error: Unknown command: $COMMAND" >&2
        echo "" >&2
        echo "Valid commands: start, stop, restart, status, logs, list" >&2
        exit 1
        ;;
esac
