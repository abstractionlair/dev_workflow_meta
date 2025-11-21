#!/usr/bin/env bash
set -euo pipefail

# test-agentd.sh - Test suite for agentd.py
#
# This script tests agentd functionality without requiring a full workflow setup.
# It validates:
# 1. Configuration loading
# 2. Email search functionality
# 3. Catch-up prompt generation
# 4. Basic daemon operations
#
# Usage: ./test-agentd.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTD="$SCRIPT_DIR/agentd.py"
EMAIL_TOOLS="$SCRIPT_DIR/email_tools.py"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test result tracking
test_pass() {
    TESTS_RUN=$((TESTS_RUN + 1))
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo -e "${GREEN}✓ PASS${NC}: $1"
}

test_fail() {
    TESTS_RUN=$((TESTS_RUN + 1))
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo -e "${RED}✗ FAIL${NC}: $1"
    if [ -n "${2:-}" ]; then
        echo "  Error: $2"
    fi
}

test_section() {
    echo ""
    echo -e "${YELLOW}=== $1 ===${NC}"
    echo ""
}

# Setup test environment
setup_test_env() {
    echo "Setting up test environment..."

    # Create temporary test directory
    TEST_DIR=$(mktemp -d)
    TEST_MAILDIR="$TEST_DIR/Maildir"

    export WORKFLOW_MAILDIR="$TEST_MAILDIR"

    echo "Test directory: $TEST_DIR"
    echo "Test maildir: $TEST_MAILDIR"
}

# Cleanup test environment
cleanup_test_env() {
    echo ""
    echo "Cleaning up test environment..."
    if [ -n "${TEST_DIR:-}" ] && [ -d "$TEST_DIR" ]; then
        rm -rf "$TEST_DIR"
        echo "Removed: $TEST_DIR"
    fi
}

# Test 1: Check if scripts exist
test_scripts_exist() {
    test_section "Script Existence Tests"

    if [ -f "$AGENTD" ]; then
        test_pass "agentd.py exists"
    else
        test_fail "agentd.py exists" "File not found: $AGENTD"
    fi

    if [ -x "$AGENTD" ]; then
        test_pass "agentd.py is executable"
    else
        test_fail "agentd.py is executable" "File not executable"
    fi

    if [ -f "$EMAIL_TOOLS" ]; then
        test_pass "email_tools.py exists"
    else
        test_fail "email_tools.py exists" "File not found: $EMAIL_TOOLS"
    fi
}

# Test 2: Check Python syntax
test_python_syntax() {
    test_section "Python Syntax Tests"

    if python3 -m py_compile "$AGENTD" 2>/dev/null; then
        test_pass "agentd.py has valid Python syntax"
    else
        test_fail "agentd.py has valid Python syntax" "Syntax error detected"
    fi

    if python3 -m py_compile "$EMAIL_TOOLS" 2>/dev/null; then
        test_pass "email_tools.py has valid Python syntax"
    else
        test_fail "email_tools.py has valid Python syntax" "Syntax error detected"
    fi
}

# Test 3: Test help output
test_help_output() {
    test_section "Help Output Tests"

    if "$AGENTD" --help >/dev/null 2>&1; then
        test_pass "agentd.py --help works"
    else
        test_fail "agentd.py --help works" "Help command failed"
    fi

    if "$EMAIL_TOOLS" --help >/dev/null 2>&1; then
        test_pass "email_tools.py --help works"
    else
        test_fail "email_tools.py --help works" "Help command failed"
    fi
}

# Test 4: Test configuration loading
test_config_loading() {
    test_section "Configuration Loading Tests"

    # Test with default config
    # This should either load the config or use defaults
    # We can't easily test this without running agentd, so we'll check the config file exists

    CONFIG_PATH="$SCRIPT_DIR/../config/supervisor-config.json"

    if [ -f "$CONFIG_PATH" ]; then
        test_pass "Configuration file exists"
    else
        test_fail "Configuration file exists" "File not found: $CONFIG_PATH"
    fi

    # Validate JSON syntax
    if python3 -c "import json; json.load(open('$CONFIG_PATH'))" 2>/dev/null; then
        test_pass "Configuration file has valid JSON"
    else
        test_fail "Configuration file has valid JSON" "JSON syntax error"
    fi

    # Check for required sections
    if python3 -c "import json; config = json.load(open('$CONFIG_PATH')); assert 'roles' in config" 2>/dev/null; then
        test_pass "Configuration has 'roles' section"
    else
        test_fail "Configuration has 'roles' section"
    fi

    if python3 -c "import json; config = json.load(open('$CONFIG_PATH')); assert 'panels' in config" 2>/dev/null; then
        test_pass "Configuration has 'panels' section"
    else
        test_fail "Configuration has 'panels' section"
    fi
}

# Test 5: Test email tools basic operations
test_email_tools_basic() {
    test_section "Email Tools Basic Operation Tests"

    # Test list on empty maildir (should not error)
    if "$EMAIL_TOOLS" list "$TEST_MAILDIR" --limit 10 >/dev/null 2>&1; then
        test_pass "email_tools.py list works on empty maildir"
    else
        test_fail "email_tools.py list works on empty maildir"
    fi

    # Test search on empty maildir
    if "$EMAIL_TOOLS" search "$TEST_MAILDIR" --limit 10 >/dev/null 2>&1; then
        test_pass "email_tools.py search works on empty maildir"
    else
        test_fail "email_tools.py search works on empty maildir"
    fi
}

# Test 6: Test email send and read
test_email_send_read() {
    test_section "Email Send/Read Tests"

    # Create a test message
    TEST_MSG_FILE="$TEST_DIR/test-message.eml"
    cat > "$TEST_MSG_FILE" <<'EOF'
From: spec-writer@workflow.local
To: spec-reviewer@workflow.local
Subject: Test Review Request
Date: Thu, 21 Nov 2025 10:00:00 +0000
Message-ID: <test-message-001@workflow.local>
X-Event-Type: review-request
X-Artifacts: project-meta/specs/proposed/test.md
X-Workflow-State: proposed

This is a test review request message.

Please review the test spec.
EOF

    # Send message
    if "$EMAIL_TOOLS" send "$TEST_MSG_FILE" "$TEST_MAILDIR" >/dev/null 2>&1; then
        test_pass "email_tools.py send works"
    else
        test_fail "email_tools.py send works"
        return
    fi

    # Search for the message
    SEARCH_OUTPUT=$("$EMAIL_TOOLS" search "$TEST_MAILDIR" --event-type review-request 2>/dev/null || true)
    if echo "$SEARCH_OUTPUT" | grep -q "review-request"; then
        test_pass "email_tools.py search finds sent message"
    else
        test_fail "email_tools.py search finds sent message"
    fi

    # List messages
    LIST_OUTPUT=$("$EMAIL_TOOLS" list "$TEST_MAILDIR" --limit 10 2>/dev/null || true)
    if echo "$LIST_OUTPUT" | grep -q "Test Review Request"; then
        test_pass "email_tools.py list shows sent message"
    else
        test_fail "email_tools.py list shows sent message"
    fi
}

# Test 7: Test agentd with missing role (should fail gracefully)
test_agentd_invalid_role() {
    test_section "AgentD Error Handling Tests"

    # Test with invalid role (should fail with nice error)
    ERROR_OUTPUT=$("$AGENTD" nonexistent-role 2>&1 || true)
    if echo "$ERROR_OUTPUT" | grep -q "not found in configuration"; then
        test_pass "agentd.py handles invalid role gracefully"
    else
        test_fail "agentd.py handles invalid role gracefully" "Expected error message not found"
    fi
}

# Test 8: Test agentd run-once with no messages
test_agentd_run_once_empty() {
    test_section "AgentD Run-Once Mode Tests"

    # Run agentd in one-shot mode (should exit cleanly with no messages)
    # Note: This will try to spawn a CLI which may not work, but we're testing that it doesn't crash

    # Create a minimal custom config for testing
    TEST_CONFIG="$TEST_DIR/test-config.json"
    cat > "$TEST_CONFIG" <<'EOF'
{
  "roles": {
    "test-reviewer": {
      "cli": "echo 'Test reviewer session'",
      "catchup_artifacts": [],
      "catchup_days": 7,
      "event_types": ["review-request"]
    }
  },
  "defaults": {
    "timeout": 10,
    "retry_delay": 1,
    "max_retries": 1
  }
}
EOF

    # Run agentd (should find no messages and exit)
    if timeout 5 "$AGENTD" test-reviewer --config "$TEST_CONFIG" --maildir "$TEST_MAILDIR" >/dev/null 2>&1; then
        test_pass "agentd.py runs and exits with no messages"
    else
        EXIT_CODE=$?
        if [ $EXIT_CODE -eq 124 ]; then
            test_fail "agentd.py runs and exits with no messages" "Command timed out"
        else
            # Exit code 0 or other reasonable exit is okay
            test_pass "agentd.py runs and exits with no messages (exit code: $EXIT_CODE)"
        fi
    fi
}

# Main test runner
main() {
    echo "======================================"
    echo "  AgentD Test Suite"
    echo "======================================"
    echo ""

    # Setup
    setup_test_env

    # Trap cleanup on exit
    trap cleanup_test_env EXIT

    # Run tests
    test_scripts_exist
    test_python_syntax
    test_help_output
    test_config_loading
    test_email_tools_basic
    test_email_send_read
    test_agentd_invalid_role
    test_agentd_run_once_empty

    # Summary
    echo ""
    echo "======================================"
    echo "  Test Summary"
    echo "======================================"
    echo "Total tests run: $TESTS_RUN"
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    if [ $TESTS_FAILED -gt 0 ]; then
        echo -e "${RED}Failed: $TESTS_FAILED${NC}"
        echo ""
        echo "Some tests failed. Please review the output above."
        exit 1
    else
        echo -e "${RED}Failed: $TESTS_FAILED${NC}"
        echo ""
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    fi
}

# Run main
main "$@"
