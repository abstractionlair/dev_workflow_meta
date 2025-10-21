#!/usr/bin/env python3
"""
TDD Cycle Tracker - Helps you follow the Red-Green-Refactor cycle.

This script runs your tests and provides visual feedback about which
phase of the TDD cycle you're in.

Usage:
    python tdd_cycle.py [pytest|npm|jest]
    
Examples:
    python tdd_cycle.py pytest tests/
    python tdd_cycle.py npm test
"""

import subprocess
import sys
import argparse
from datetime import datetime
from pathlib import Path

# ANSI color codes
RED = '\033[91m'
GREEN = '\033[92m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
RESET = '\033[0m'
BOLD = '\033[1m'

def print_header(text, color):
    """Print a colored header."""
    width = 60
    print(f"\n{color}{BOLD}{'=' * width}")
    print(f"{text.center(width)}")
    print(f"{'=' * width}{RESET}\n")

def print_phase(phase, description):
    """Print TDD phase information."""
    phases = {
        'RED': (RED, '🔴', 'Write a failing test'),
        'GREEN': (GREEN, '🟢', 'Make the test pass'),
        'REFACTOR': (BLUE, '🔵', 'Improve the code'),
    }
    
    if phase in phases:
        color, emoji, default_desc = phases[phase]
        desc = description or default_desc
        print(f"{color}{BOLD}{emoji} {phase} PHASE{RESET}")
        print(f"{color}{desc}{RESET}")

def run_tests(command):
    """Run tests and return the result."""
    print(f"{BOLD}Running: {' '.join(command)}{RESET}\n")
    
    try:
        result = subprocess.run(
            command,
            capture_output=False,
            text=True
        )
        return result.returncode == 0
    except FileNotFoundError:
        print(f"{RED}Error: Command not found: {command[0]}{RESET}")
        print(f"Make sure {command[0]} is installed and in your PATH.")
        sys.exit(1)

def get_tdd_state():
    """Check if there's a saved TDD state."""
    state_file = Path('.tdd_state')
    if state_file.exists():
        return state_file.read_text().strip()
    return None

def save_tdd_state(state):
    """Save the current TDD state."""
    state_file = Path('.tdd_state')
    state_file.write_text(state)

def main():
    parser = argparse.ArgumentParser(
        description='TDD Cycle Tracker - Follow Red-Green-Refactor',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
TDD Cycle:
  1. RED    - Write a failing test
  2. GREEN  - Write minimal code to pass
  3. REFACTOR - Improve code quality

Examples:
  %(prog)s pytest tests/
  %(prog)s pytest tests/test_calculator.py -v
  %(prog)s npm test
  %(prog)s npm test -- --coverage
        """
    )
    parser.add_argument('command', nargs='+', help='Test command to run')
    parser.add_argument('--reset', action='store_true', help='Reset TDD cycle state')
    
    args = parser.parse_args()
    
    if args.reset:
        state_file = Path('.tdd_state')
        if state_file.exists():
            state_file.unlink()
        print(f"{GREEN}✓ TDD state reset{RESET}")
        return
    
    # Get previous state
    last_state = get_tdd_state()
    
    # Run tests
    print_header(f"TDD CYCLE TRACKER - {datetime.now().strftime('%H:%M:%S')}", BLUE)
    
    tests_passed = run_tests(args.command)
    
    # Determine current phase
    print("\n" + "─" * 60 + "\n")
    
    if tests_passed:
        if last_state == 'RED':
            # Transitioned from RED to GREEN
            print_phase('GREEN', 'Tests are passing! ✓')
            print(f"\n{GREEN}Great! You've made the tests pass.{RESET}")
            print(f"\n{YELLOW}Next step:{RESET}")
            print(f"  • Review your code for improvements")
            print(f"  • Refactor while keeping tests green")
            print(f"  • Then write the next failing test")
            save_tdd_state('GREEN')
        else:
            # Staying in GREEN or REFACTOR
            print_phase('GREEN', 'Tests are passing! ✓')
            print(f"\n{GREEN}All tests passing.{RESET}")
            print(f"\n{YELLOW}Options:{RESET}")
            print(f"  • Refactor your code (tests should stay green)")
            print(f"  • Write the next failing test (RED phase)")
            save_tdd_state('GREEN')
    else:
        # Tests failing
        if last_state == 'GREEN':
            # Just wrote a new failing test
            print_phase('RED', 'Tests are failing! ✗')
            print(f"\n{RED}Good! You have a failing test.{RESET}")
            print(f"\n{YELLOW}Next step:{RESET}")
            print(f"  • Write minimal code to make this test pass")
            print(f"  • Don't write more than necessary")
            print(f"  • Run tests again to see if they pass")
            save_tdd_state('RED')
        else:
            # Still in RED phase or tests broke
            print_phase('RED', 'Tests are failing! ✗')
            print(f"\n{RED}Tests are failing.{RESET}")
            
            if last_state == 'RED':
                print(f"\n{YELLOW}Keep going:{RESET}")
                print(f"  • Continue implementing code to pass the test")
                print(f"  • Keep it simple - just enough to pass")
            else:
                print(f"\n{YELLOW}Careful:{RESET}")
                print(f"  • If you were refactoring, revert changes")
                print(f"  • If writing new test, implement it properly")
                print(f"  • Fix the failing tests")
            save_tdd_state('RED')
    
    print("\n" + "─" * 60)
    
    # Print TDD reminder
    print(f"\n{BOLD}TDD Cycle Reminder:{RESET}")
    print(f"{RED}  1. RED{RESET}      → Write a test that fails")
    print(f"{GREEN}  2. GREEN{RESET}    → Write code to pass the test")
    print(f"{BLUE}  3. REFACTOR{RESET} → Improve code while tests stay green")
    print(f"\n{BOLD}Use --reset to start a new cycle{RESET}\n")

if __name__ == '__main__':
    main()
