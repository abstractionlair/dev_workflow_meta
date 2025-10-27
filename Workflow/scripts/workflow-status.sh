#!/usr/bin/env bash
set -euo pipefail

# workflow-status.sh - Scan project state and suggest next actions
#
# Usage: ./workflow-status.sh [--verbose]
#
# Scans the project to determine:
# - What planning docs exist and their review status
# - What specs are in each state (proposed/todo/doing/done)
# - For specs in doing/, what work remains (skeleton/tests/implementation)
# - What bugs need attention
# - Suggests specific next commands to run

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOW_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$WORKFLOW_DIR/.." && pwd)"

VERBOSE=false
if [[ "${1:-}" == "--verbose" ]]; then
    VERBOSE=true
fi

cd "$PROJECT_ROOT"

# Colors for output
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    BOLD='\033[1m'
    RESET='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    CYAN=''
    BOLD=''
    RESET=''
fi

# Track suggestions
declare -a SUGGESTIONS=()

add_suggestion() {
    local priority="$1"
    local message="$2"
    local command="$3"
    SUGGESTIONS+=("$priority|$message|$command")
}

print_header() {
    echo -e "${BOLD}${BLUE}=== $1 ===${RESET}"
}

print_section() {
    echo -e "${CYAN}$1${RESET}"
}

print_item() {
    local status="$1"
    local message="$2"

    case "$status" in
        found)
            echo -e "  ${GREEN}✓${RESET} $message"
            ;;
        missing)
            echo -e "  ${RED}✗${RESET} $message"
            ;;
        needs_review)
            echo -e "  ${YELLOW}⊙${RESET} $message"
            ;;
        in_progress)
            echo -e "  ${BLUE}→${RESET} $message"
            ;;
        *)
            echo -e "  ${message}"
            ;;
    esac
}

# Check if file exists and has a review
check_artifact_review() {
    local artifact_name="$1"
    local review_subdir="$2"

    if [ ! -f "$artifact_name" ]; then
        return 1
    fi

    # Check if there's a review
    if [ -d "reviews/$review_subdir" ]; then
        local review_count=$(find "reviews/$review_subdir" -name "*.md" 2>/dev/null | wc -l)
        if [ "$review_count" -gt 0 ]; then
            return 0  # Has review
        fi
    fi
    return 2  # Exists but no review
}

# ============================================================================
# Planning Documents
# ============================================================================
check_planning_docs() {
    print_header "Planning Documents"

    # VISION.md
    if check_artifact_review "VISION.md" "vision"; then
        print_item "found" "VISION.md (reviewed)"
    elif [ -f "VISION.md" ]; then
        print_item "needs_review" "VISION.md (needs review)"
        add_suggestion "1" "Review VISION.md" "./Workflow/scripts/run-role.sh vision-reviewer VISION.md"
    else
        print_item "missing" "VISION.md (not created)"
        add_suggestion "0" "Create VISION.md" "./Workflow/scripts/run-role.sh -i vision-writing-helper"
    fi

    # SCOPE.md
    if check_artifact_review "SCOPE.md" "scope"; then
        print_item "found" "SCOPE.md (reviewed)"
    elif [ -f "SCOPE.md" ]; then
        print_item "needs_review" "SCOPE.md (needs review)"
        add_suggestion "1" "Review SCOPE.md" "./Workflow/scripts/run-role.sh scope-reviewer SCOPE.md"
    else
        if [ -f "VISION.md" ]; then
            print_item "missing" "SCOPE.md (not created)"
            add_suggestion "1" "Create SCOPE.md" "./Workflow/scripts/run-role.sh -i scope-writing-helper"
        else
            print_item "missing" "SCOPE.md (VISION.md needed first)"
        fi
    fi

    # ROADMAP.md
    if check_artifact_review "ROADMAP.md" "roadmap"; then
        print_item "found" "ROADMAP.md (reviewed)"
    elif [ -f "ROADMAP.md" ]; then
        print_item "needs_review" "ROADMAP.md (needs review)"
        add_suggestion "1" "Review ROADMAP.md" "./Workflow/scripts/run-role.sh roadmap-reviewer ROADMAP.md"
    else
        if [ -f "SCOPE.md" ]; then
            print_item "missing" "ROADMAP.md (not created)"
            add_suggestion "1" "Create ROADMAP.md" "./Workflow/scripts/run-role.sh -i roadmap-writing-helper"
        else
            print_item "missing" "ROADMAP.md (SCOPE.md needed first)"
        fi
    fi

    echo ""
}

# ============================================================================
# Specifications
# ============================================================================
check_specs() {
    print_header "Specifications"

    if [ ! -d "specs" ]; then
        print_item "missing" "specs/ directory does not exist"
        if [ -f "ROADMAP.md" ]; then
            add_suggestion "2" "Create first spec from roadmap" "./Workflow/scripts/run-role.sh -i spec-writer"
        fi
        echo ""
        return
    fi

    # specs/proposed/
    if [ -d "specs/proposed" ]; then
        local proposed_count=$(find specs/proposed -maxdepth 1 -name "*.md" 2>/dev/null | wc -l)
        if [ "$proposed_count" -gt 0 ]; then
            print_section "Proposed (needs review):"
            find specs/proposed -maxdepth 1 -name "*.md" 2>/dev/null | while read -r spec; do
                local basename=$(basename "$spec")
                print_item "needs_review" "$basename"
                add_suggestion "2" "Review spec: $basename" "./Workflow/scripts/run-role.sh spec-reviewer specs/proposed/$basename"
            done
        else
            print_item "missing" "No specs in proposed/"
        fi
    fi

    # specs/todo/
    if [ -d "specs/todo" ]; then
        local todo_count=$(find specs/todo -maxdepth 1 -name "*.md" 2>/dev/null | wc -l)
        if [ "$todo_count" -gt 0 ]; then
            print_section "Todo (ready to start):"
            find specs/todo -maxdepth 1 -name "*.md" 2>/dev/null | while read -r spec; do
                local basename=$(basename "$spec")
                print_item "found" "$basename"
                add_suggestion "3" "Start implementing: $basename" "./Workflow/scripts/run-role.sh skeleton-writer specs/todo/$basename"
            done
        else
            print_item "missing" "No specs in todo/"
        fi
    fi

    # specs/doing/
    if [ -d "specs/doing" ]; then
        local doing_count=$(find specs/doing -maxdepth 1 -name "*.md" 2>/dev/null | wc -l)
        if [ "$doing_count" -gt 0 ]; then
            print_section "In Progress:"
            find specs/doing -maxdepth 1 -name "*.md" 2>/dev/null | while read -r spec; do
                local basename=$(basename "$spec")
                local spec_base="${basename%.md}"
                print_item "in_progress" "$basename"

                # Check for skeleton (look for common patterns)
                local has_skeleton=false
                if find src -name "${spec_base}*.py" -o -name "${spec_base}*.ts" -o -name "${spec_base}*.js" 2>/dev/null | grep -q .; then
                    has_skeleton=true
                    print_item "found" "  └─ Skeleton code exists"
                else
                    print_item "missing" "  └─ No skeleton code found"
                    add_suggestion "4" "Create skeleton: $basename" "./Workflow/scripts/run-role.sh skeleton-writer specs/doing/$basename"
                fi

                # Check for tests
                local has_tests=false
                if find tests -name "*${spec_base}*.py" -o -name "*${spec_base}*.test.ts" -o -name "*${spec_base}*.test.js" 2>/dev/null | grep -q .; then
                    has_tests=true
                    print_item "found" "  └─ Tests exist"

                    # Check if tests need review
                    if [ -d "reviews/tests" ]; then
                        if find "reviews/tests" -name "*${spec_base}*" 2>/dev/null | grep -q .; then
                            print_item "found" "      └─ Tests reviewed"
                        else
                            print_item "needs_review" "      └─ Tests need review"
                            add_suggestion "5" "Review tests: $basename" "./Workflow/scripts/run-role.sh test-reviewer specs/doing/$basename"
                        fi
                    else
                        print_item "needs_review" "      └─ Tests need review"
                        add_suggestion "5" "Review tests: $basename" "./Workflow/scripts/run-role.sh test-reviewer specs/doing/$basename"
                    fi
                else
                    print_item "missing" "  └─ No tests found"
                    if [ "$has_skeleton" = true ]; then
                        add_suggestion "5" "Write tests: $basename" "./Workflow/scripts/run-role.sh test-writer specs/doing/$basename"
                    fi
                fi

                # Check implementation status (heuristic: look for TODOs or NotImplementedError)
                if [ "$has_tests" = true ]; then
                    local has_todos=false
                    if find src -name "${spec_base}*" -exec grep -l "TODO\|NotImplementedError\|raise NotImplementedError\|throw new Error" {} \; 2>/dev/null | grep -q .; then
                        has_todos=true
                        print_item "in_progress" "  └─ Implementation incomplete (TODOs/NotImplementedError found)"
                        add_suggestion "6" "Implement: $basename" "./Workflow/scripts/run-role.sh implementer specs/doing/$basename"
                    else
                        print_item "found" "  └─ Implementation appears complete"

                        # Check if implementation reviewed
                        if [ -d "reviews/implementations" ]; then
                            if find "reviews/implementations" -name "*${spec_base}*" 2>/dev/null | grep -q .; then
                                print_item "found" "      └─ Implementation reviewed - ready to merge!"
                            else
                                print_item "needs_review" "      └─ Implementation needs review"
                                add_suggestion "7" "Review implementation: $basename" "./Workflow/scripts/run-role.sh implementation-reviewer specs/doing/$basename"
                            fi
                        else
                            print_item "needs_review" "      └─ Implementation needs review"
                            add_suggestion "7" "Review implementation: $basename" "./Workflow/scripts/run-role.sh implementation-reviewer specs/doing/$basename"
                        fi
                    fi
                fi
            done
        else
            print_item "missing" "No specs in doing/"
        fi
    fi

    # specs/done/
    if [ -d "specs/done" ]; then
        local done_count=$(find specs/done -maxdepth 1 -name "*.md" 2>/dev/null | wc -l)
        if [ "$done_count" -gt 0 ]; then
            print_section "Completed:"
            print_item "found" "$done_count spec(s) completed"
            if [ "$VERBOSE" = true ]; then
                find specs/done -maxdepth 1 -name "*.md" 2>/dev/null | while read -r spec; do
                    print_item "found" "  $(basename "$spec")"
                done
            fi
        fi
    fi

    echo ""
}

# ============================================================================
# Bugs
# ============================================================================
check_bugs() {
    print_header "Bugs"

    if [ ! -d "bugs" ]; then
        print_item "found" "No bugs/ directory (no bugs reported)"
        echo ""
        return
    fi

    # bugs/to_fix/
    if [ -d "bugs/to_fix" ]; then
        local to_fix_count=$(find bugs/to_fix -maxdepth 1 -name "*.md" 2>/dev/null | wc -l)
        if [ "$to_fix_count" -gt 0 ]; then
            print_section "To Fix:"
            find bugs/to_fix -maxdepth 1 -name "*.md" 2>/dev/null | while read -r bug; do
                local basename=$(basename "$bug")
                print_item "needs_review" "$basename"
                add_suggestion "8" "Start fixing bug: $basename" "./Workflow/scripts/run-role.sh -i implementer bugs/to_fix/$basename"
            done
        fi
    fi

    # bugs/fixing/
    if [ -d "bugs/fixing" ]; then
        local fixing_count=$(find bugs/fixing -maxdepth 1 -name "*.md" 2>/dev/null | wc -l)
        if [ "$fixing_count" -gt 0 ]; then
            print_section "In Progress:"
            find bugs/fixing -maxdepth 1 -name "*.md" 2>/dev/null | while read -r bug; do
                local basename=$(basename "$bug")
                print_item "in_progress" "$basename"
            done
        fi
    fi

    # bugs/fixed/
    if [ -d "bugs/fixed" ]; then
        local fixed_count=$(find bugs/fixed -maxdepth 1 -name "*.md" 2>/dev/null | wc -l)
        if [ "$fixed_count" -gt 0 ]; then
            print_section "Fixed:"
            print_item "found" "$fixed_count bug(s) fixed"
        fi
    fi

    echo ""
}

# ============================================================================
# Living Documentation
# ============================================================================
check_living_docs() {
    print_header "Living Documentation"

    if [ -f "SYSTEM_MAP.md" ]; then
        print_item "found" "SYSTEM_MAP.md"
    else
        print_item "missing" "SYSTEM_MAP.md (create when architecture emerges)"
    fi

    if [ -f "GUIDELINES.md" ]; then
        print_item "found" "GUIDELINES.md"
    else
        print_item "missing" "GUIDELINES.md (create when patterns emerge)"
    fi

    echo ""
}

# ============================================================================
# Git Branch Status
# ============================================================================
check_git_status() {
    print_header "Git Status"

    if [ -d ".git" ]; then
        local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
        local has_changes=$(git status --porcelain 2>/dev/null | wc -l)

        if [ "$current_branch" = "main" ] || [ "$current_branch" = "master" ]; then
            print_item "found" "On main branch"
        else
            print_item "in_progress" "On feature branch: $current_branch"
        fi

        if [ "$has_changes" -gt 0 ]; then
            print_item "in_progress" "$has_changes uncommitted change(s)"
        else
            print_item "found" "Working tree clean"
        fi
    else
        print_item "missing" "Not a git repository"
    fi

    echo ""
}

# ============================================================================
# Suggestions
# ============================================================================
print_suggestions() {
    print_header "Suggested Next Actions"

    if [ ${#SUGGESTIONS[@]} -eq 0 ]; then
        echo -e "${GREEN}All caught up! No immediate actions needed.${RESET}"
        echo ""
        return
    fi

    # Sort suggestions by priority
    IFS=$'\n' sorted_suggestions=($(sort <<<"${SUGGESTIONS[*]}"))
    unset IFS

    local count=1
    for suggestion in "${sorted_suggestions[@]}"; do
        local priority=$(echo "$suggestion" | cut -d'|' -f1)
        local message=$(echo "$suggestion" | cut -d'|' -f2)
        local command=$(echo "$suggestion" | cut -d'|' -f3)

        echo -e "${BOLD}$count.${RESET} ${YELLOW}$message${RESET}"
        echo -e "   ${CYAN}$command${RESET}"
        echo ""
        ((count++))
    done
}

# ============================================================================
# Main
# ============================================================================
main() {
    echo ""
    print_header "Workflow Status Report"
    echo "Project: $(basename "$PROJECT_ROOT")"
    echo "Path: $PROJECT_ROOT"
    echo ""

    check_planning_docs
    check_specs
    check_bugs
    check_living_docs
    check_git_status
    print_suggestions
}

main
