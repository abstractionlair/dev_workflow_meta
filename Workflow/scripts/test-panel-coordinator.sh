#!/usr/bin/env bash
set -euo pipefail

# test-panel-coordinator.sh - Basic integration tests for panel-coordinator.py
#
# Tests panel coordinator functionality without requiring multiple model CLIs.
# For full multi-model testing, use this script in a concrete project with
# multiple AI model CLIs configured.
#
# Usage: ./test-panel-coordinator.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL_COORD="$SCRIPT_DIR/panel-coordinator.py"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

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

echo "======================================"
echo "  Panel Coordinator Test Suite"
echo "======================================"
echo ""

# Test 1: Script exists and is executable
test_section "Basic Checks"

if [ -f "$PANEL_COORD" ]; then
    test_pass "panel-coordinator.py exists"
else
    test_fail "panel-coordinator.py exists"
    exit 1
fi

if [ -x "$PANEL_COORD" ]; then
    test_pass "panel-coordinator.py is executable"
else
    test_fail "panel-coordinator.py is executable"
fi

# Test 2: Python syntax
if python3 -m py_compile "$PANEL_COORD" 2>/dev/null; then
    test_pass "Valid Python syntax"
else
    test_fail "Valid Python syntax"
fi

# Test 3: Help output
test_section "Command Interface"

if "$PANEL_COORD" --help >/dev/null 2>&1; then
    test_pass "Help output works"
else
    test_fail "Help output works"
fi

# Test 4: Review command exists
if "$PANEL_COORD" review --help >/dev/null 2>&1; then
    test_pass "Review command available"
else
    test_fail "Review command available"
fi

# Test 5: Write command exists
if "$PANEL_COORD" write --help >/dev/null 2>&1; then
    test_pass "Write command available"
else
    test_fail "Write command available"
fi

# Test 6: Check-consensus command exists
if "$PANEL_COORD" check-consensus --help >/dev/null 2>&1; then
    test_pass "Check-consensus command available"
else
    test_fail "Check-consensus command available"
fi

# Test 7: Configuration loading
test_section "Configuration Tests"

CONFIG_PATH="$SCRIPT_DIR/../config/supervisor-config.json"

if [ -f "$CONFIG_PATH" ]; then
    test_pass "Configuration file exists"
else
    test_fail "Configuration file exists"
fi

# Check panels section in config
if python3 -c "import json; config = json.load(open('$CONFIG_PATH')); assert 'panels' in config" 2>/dev/null; then
    test_pass "Configuration has panels section"
else
    test_fail "Configuration has panels section"
fi

# Test 8: Panel definitions
test_section "Panel Definition Tests"

# Check for required panels
REQUIRED_PANELS=("vision-reviewer-panel" "scope-reviewer-panel" "spec-reviewer-panel")

for panel in "${REQUIRED_PANELS[@]}"; do
    if python3 -c "import json; config = json.load(open('$CONFIG_PATH')); assert '$panel' in config['panels']" 2>/dev/null; then
        test_pass "Panel defined: $panel"
    else
        test_fail "Panel defined: $panel"
    fi
done

# Test 9: Error handling
test_section "Error Handling Tests"

# Test with invalid panel name
ERROR_OUTPUT=$("$PANEL_COORD" check-consensus invalid-panel 2>&1 || true)
if echo "$ERROR_OUTPUT" | grep -q "not found"; then
    test_pass "Handles invalid panel name gracefully"
else
    test_fail "Handles invalid panel name gracefully"
fi

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
    echo ""
    echo "NOTE: Full multi-model panel testing requires:"
    echo "  - Multiple AI model CLIs (claude, gpt-5, gemini)"
    echo "  - A concrete project with workflow artifacts"
    echo "  - See docs/ConcreteProjectSetup.md for setup instructions"
    exit 1
else
    echo -e "${RED}Failed: $TESTS_FAILED${NC}"
    echo ""
    echo -e "${GREEN}All basic tests passed!${NC}"
    echo ""
    echo "Next steps for full testing:"
    echo "  1. Set up a concrete project with this workflow"
    echo "  2. Configure multiple AI model CLIs"
    echo "  3. Test panel coordination with real artifacts"
    echo "  4. See docs/ConcreteProjectSetup.md for details"
    exit 0
fi
