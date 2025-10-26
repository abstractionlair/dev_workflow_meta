#!/usr/bin/env bash

# workflow-status.sh
# Infer and display project state from filesystem structure

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Check if running in project with workflow structure
if [[ ! -d "Workflow" ]] && [[ ! -f "VISION.md" ]]; then
    echo "Error: Not in a workflow-managed project directory"
    echo "Expected either Workflow/ directory or VISION.md file"
    exit 1
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}           Workflow Status Report${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Function to extract version from file
get_version() {
    local file=$1
    if [[ -f "$file" ]]; then
        # Look for ## Version or **Version** markers
        version=$(grep -E "^(## Version|#+ Version|\\*\\*Version\\*\\*)" "$file" | head -1 | sed -E 's/^.*Version[^v0-9]*(v?[0-9.]+).*/\1/' || echo "")
        if [[ -z "$version" ]]; then
            # Look for version in metadata
            version=$(grep -E "^version:" "$file" | sed -E 's/^version:[[:space:]]*//' || echo "")
        fi
        echo "${version:-unknown}"
    else
        echo "missing"
    fi
}

# Function to check if document is approved (has review)
is_approved() {
    local doc_type=$1
    local review_dir="reviews/${doc_type}"

    if [[ -d "$review_dir" ]] && [[ $(find "$review_dir" -name "*.md" -type f 2>/dev/null | wc -l) -gt 0 ]]; then
        return 0
    fi
    return 1
}

# Function to count files in directory
count_files() {
    local dir=$1
    if [[ -d "$dir" ]]; then
        find "$dir" -maxdepth 1 -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' '
    else
        echo "0"
    fi
}

# Function to get current git branch
get_branch() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git branch --show-current 2>/dev/null || echo "detached"
    else
        echo "no git"
    fi
}

# Strategic Planning Documents
echo -e "${YELLOW}Strategic Planning:${NC}"

if [[ -f "VISION.md" ]]; then
    version=$(get_version "VISION.md")
    if is_approved "vision"; then
        echo -e "  VISION:   ${GREEN}✓ APPROVED${NC} ($version)"
    else
        echo -e "  VISION:   ${YELLOW}⧗ DRAFT${NC} ($version) - needs review"
    fi
else
    echo -e "  VISION:   ${RED}✗ MISSING${NC}"
fi

if [[ -f "SCOPE.md" ]]; then
    version=$(get_version "SCOPE.md")
    if is_approved "scope"; then
        echo -e "  SCOPE:    ${GREEN}✓ APPROVED${NC} ($version)"
    else
        echo -e "  SCOPE:    ${YELLOW}⧗ DRAFT${NC} ($version) - needs review"
    fi
else
    echo -e "  SCOPE:    ${GRAY}— not started${NC}"
fi

if [[ -f "ROADMAP.md" ]]; then
    version=$(get_version "ROADMAP.md")
    if is_approved "roadmap"; then
        echo -e "  ROADMAP:  ${GREEN}✓ APPROVED${NC} ($version)"
    else
        echo -e "  ROADMAP:  ${YELLOW}⧗ DRAFT${NC} ($version) - needs review"
    fi
else
    echo -e "  ROADMAP:  ${GRAY}— not started${NC}"
fi

echo

# Living Documentation
echo -e "${YELLOW}Living Documentation:${NC}"

if [[ -f "SYSTEM_MAP.md" ]]; then
    version=$(get_version "SYSTEM_MAP.md")
    echo -e "  SYSTEM_MAP:   ${GREEN}✓${NC} present ($version)"
else
    echo -e "  SYSTEM_MAP:   ${GRAY}— not created${NC}"
fi

if [[ -f "GUIDELINES.md" ]]; then
    version=$(get_version "GUIDELINES.md")
    echo -e "  GUIDELINES:   ${GREEN}✓${NC} present ($version)"
else
    echo -e "  GUIDELINES:   ${GRAY}— not created${NC}"
fi

echo

# Feature Specifications
echo -e "${YELLOW}Feature Specifications:${NC}"

proposed=$(count_files "specs/proposed")
todo=$(count_files "specs/todo")
doing=$(count_files "specs/doing")
done=$(count_files "specs/done")

total=$((proposed + todo + doing + done))

if [[ $total -eq 0 ]]; then
    echo -e "  ${GRAY}No specs yet${NC}"
else
    [[ $proposed -gt 0 ]] && echo -e "  Proposed: ${BLUE}$proposed${NC} spec(s) awaiting review"
    [[ $todo -gt 0 ]] && echo -e "  Todo:     ${BLUE}$todo${NC} spec(s) ready to implement"
    [[ $doing -gt 0 ]] && echo -e "  Doing:    ${YELLOW}$doing${NC} spec(s) in progress"
    [[ $done -gt 0 ]] && echo -e "  Done:     ${GREEN}$done${NC} spec(s) completed"
fi

echo

# Bug Reports
echo -e "${YELLOW}Bugs:${NC}"

to_fix=$(count_files "bugs/to_fix")
fixing=$(count_files "bugs/fixing")
fixed=$(count_files "bugs/fixed")

bug_total=$((to_fix + fixing + fixed))

if [[ $bug_total -eq 0 ]]; then
    echo -e "  ${GREEN}No bugs reported${NC}"
else
    [[ $to_fix -gt 0 ]] && echo -e "  To Fix:   ${RED}$to_fix${NC} bug(s) awaiting fix"
    [[ $fixing -gt 0 ]] && echo -e "  Fixing:   ${YELLOW}$fixing${NC} bug(s) being worked"
    [[ $fixed -gt 0 ]] && echo -e "  Fixed:    ${GREEN}$fixed${NC} bug(s) resolved"
fi

echo

# Current Work
echo -e "${YELLOW}Current Work:${NC}"

branch=$(get_branch)
if [[ "$branch" == "main" ]] || [[ "$branch" == "master" ]]; then
    echo -e "  Branch: ${GREEN}$branch${NC}"
else
    echo -e "  Branch: ${BLUE}$branch${NC}"
fi

# Show what's currently being worked on
if [[ $doing -gt 0 ]]; then
    echo -e "  ${YELLOW}Active specs:${NC}"
    while IFS= read -r spec_file; do
        spec_name=$(basename "$spec_file" .md)
        echo -e "    • $spec_name (specs/doing/$(basename "$spec_file"))"
    done < <(find "specs/doing" -maxdepth 1 -name "*.md" -type f 2>/dev/null)
fi

if [[ $fixing -gt 0 ]]; then
    echo -e "  ${YELLOW}Active bug fixes:${NC}"
    while IFS= read -r bug_file; do
        bug_name=$(basename "$bug_file" .md)
        echo -e "    • $bug_name (bugs/fixing/$(basename "$bug_file"))"
    done < <(find "bugs/fixing" -maxdepth 1 -name "*.md" -type f 2>/dev/null)
fi

if [[ $doing -eq 0 ]] && [[ $fixing -eq 0 ]]; then
    echo -e "  ${GRAY}No active work${NC}"
fi

echo

# Next Actions
echo -e "${YELLOW}Next Actions:${NC}"

suggested=0

# Strategic planning suggestions
if [[ ! -f "VISION.md" ]]; then
    echo -e "  ${BLUE}→${NC} Create VISION.md (act as vision-writing-helper)"
    suggested=1
elif [[ ! -f "SCOPE.md" ]] && is_approved "vision"; then
    echo -e "  ${BLUE}→${NC} Create SCOPE.md (act as scope-writer)"
    suggested=1
elif [[ ! -f "ROADMAP.md" ]] && is_approved "scope"; then
    echo -e "  ${BLUE}→${NC} Create ROADMAP.md (act as roadmap-writer)"
    suggested=1
fi

# Living docs suggestions
if [[ -f "ROADMAP.md" ]] && is_approved "roadmap"; then
    if [[ ! -f "SYSTEM_MAP.md" ]]; then
        echo -e "  ${BLUE}→${NC} Create SYSTEM_MAP.md (act as platform-lead)"
        suggested=1
    fi
    if [[ ! -f "GUIDELINES.md" ]]; then
        echo -e "  ${BLUE}→${NC} Create GUIDELINES.md (act as platform-lead)"
        suggested=1
    fi
fi

# Feature work suggestions
if [[ $todo -gt 0 ]]; then
    echo -e "  ${BLUE}→${NC} $todo spec(s) ready to implement (act as skeleton-writer)"
    suggested=1
fi

if [[ $proposed -gt 0 ]]; then
    echo -e "  ${BLUE}→${NC} $proposed spec(s) need review (act as spec-reviewer)"
    suggested=1
fi

if [[ $to_fix -gt 0 ]]; then
    echo -e "  ${BLUE}→${NC} $to_fix bug(s) need fixing (act as implementer)"
    suggested=1
fi

# New feature suggestion
if [[ -f "ROADMAP.md" ]] && is_approved "roadmap" && [[ $proposed -eq 0 ]] && [[ $todo -eq 0 ]] && [[ $doing -eq 0 ]]; then
    echo -e "  ${BLUE}→${NC} Ready to start new feature from roadmap (act as spec-writer)"
    suggested=1
fi

if [[ $suggested -eq 0 ]]; then
    if [[ $doing -gt 0 ]] || [[ $fixing -gt 0 ]]; then
        echo -e "  ${GREEN}Continue current work${NC}"
    else
        echo -e "  ${GREEN}All caught up!${NC}"
    fi
fi

echo
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
