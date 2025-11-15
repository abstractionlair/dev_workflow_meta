#!/usr/bin/env bash

# init-project.sh
# Initialize a concrete project with the workflow as a git submodule
# Uses project-meta/ and project-content/ structure

set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Script usage
usage() {
    cat <<EOF
Usage: $0 [OPTIONS] <project-name>

Initialize a concrete project with the AI-Augmented Development Workflow as a git submodule.
Creates project-meta/ and project-content/ directory structure.

OPTIONS:
    -h, --help              Show this help message
    -d, --directory         Target directory (default: ./<project-name>)
    -g, --no-git            Skip git initialization
    -r, --workflow-repo     Workflow git repository URL
                            (default: https://github.com/abstractionlair/dev_workflow_meta.git)
    -b, --branch            Workflow branch to use (default: main)

EXAMPLES:
    # Create new project with workflow
    $0 my-project

    # Create in specific directory
    $0 -d ~/projects/my-project my-project

    # Use custom workflow repository
    $0 -r https://github.com/myorg/workflow.git my-project

    # Initialize without git (just directory structure)
    $0 --no-git my-project

EOF
}

# Parse arguments
PROJECT_NAME=""
TARGET_DIR=""
INIT_GIT=1
WORKFLOW_REPO="https://github.com/abstractionlair/dev_workflow_meta.git"
WORKFLOW_BRANCH="main"

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -d|--directory)
            TARGET_DIR="$2"
            shift 2
            ;;
        -g|--no-git)
            INIT_GIT=0
            shift
            ;;
        -r|--workflow-repo)
            WORKFLOW_REPO="$2"
            shift 2
            ;;
        -b|--branch)
            WORKFLOW_BRANCH="$2"
            shift 2
            ;;
        -*)
            echo "Error: Unknown option $1"
            usage
            exit 1
            ;;
        *)
            PROJECT_NAME="$1"
            shift
            ;;
    esac
done

if [[ -z "$PROJECT_NAME" ]]; then
    echo "Error: Project name required"
    usage
    exit 1
fi

# Detect meta project root (needed for templates and auto-detection)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
META_PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Set default target directory if not specified
if [[ -z "$TARGET_DIR" ]]; then
    # Check if current directory is inside the meta project
    CURRENT_DIR="$(pwd)"
    if [[ "$CURRENT_DIR" == "$META_PROJECT_ROOT" || "$CURRENT_DIR" == "$META_PROJECT_ROOT"/* ]]; then
        # Running from inside dev_workflow_meta - create project in parent directory
        TARGET_DIR="$META_PROJECT_ROOT/../$PROJECT_NAME"
        echo -e "${YELLOW}⧗ Detected running from inside dev_workflow_meta${NC}"
        echo -e "${YELLOW}  Creating project in parent directory: $TARGET_DIR${NC}"
        echo
    else
        # Running from outside - create in current directory
        TARGET_DIR="./$PROJECT_NAME"
    fi
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}   Initializing Project: $PROJECT_NAME${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Create and enter target directory
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# Initialize git first if requested (needed for submodule)
if [[ $INIT_GIT -eq 1 ]]; then
    echo -e "${YELLOW}Initializing git repository...${NC}"
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        git init
        echo "  ✓ Git repository initialized"
    else
        echo "  ⧗ Git repository already exists (continuing)"
    fi
    echo
fi

# Add workflow as git submodule
if [[ $INIT_GIT -eq 1 ]]; then
    echo -e "${YELLOW}Adding workflow as git submodule...${NC}"
    mkdir -p project-meta
    if ! git submodule add -b "$WORKFLOW_BRANCH" "$WORKFLOW_REPO" project-meta/workflow 2>/dev/null; then
        echo -e "${RED}  ✗ Failed to add submodule (may already exist)${NC}"
        echo "  Continuing with existing submodule..."
    else
        echo "  ✓ Workflow submodule added: project-meta/workflow/"
    fi
    echo
fi

# Create project-meta directory structure
echo -e "${YELLOW}Creating project-meta/ directory structure...${NC}"

meta_directories=(
    "project-meta/planning"
    "project-meta/architecture"
    "project-meta/specs/proposed"
    "project-meta/specs/todo"
    "project-meta/specs/doing"
    "project-meta/specs/done"
    "project-meta/bugs/to_fix"
    "project-meta/bugs/fixing"
    "project-meta/bugs/fixed"
    "project-meta/review-requests/vision"
    "project-meta/review-requests/scope"
    "project-meta/review-requests/roadmap"
    "project-meta/review-requests/specs"
    "project-meta/review-requests/skeletons"
    "project-meta/review-requests/tests"
    "project-meta/review-requests/implementations"
    "project-meta/review-requests/bug-fixes"
    "project-meta/review-requests/archived"
    "project-meta/reviews/vision"
    "project-meta/reviews/scope"
    "project-meta/reviews/roadmap"
    "project-meta/reviews/specs"
    "project-meta/reviews/skeletons"
    "project-meta/reviews/tests"
    "project-meta/reviews/implementations"
    "project-meta/reviews/bug-fixes"
)

for dir in "${meta_directories[@]}"; do
    mkdir -p "$dir"
    echo "  ✓ $dir/"
done

echo

# Create project-content directory structure
echo -e "${YELLOW}Creating project-content/ directory structure...${NC}"

content_directories=(
    "project-content/src"
    "project-content/tests/unit"
    "project-content/tests/integration"
    "project-content/tests/regression"
    "project-content/docs"
)

for dir in "${content_directories[@]}"; do
    mkdir -p "$dir"
    echo "  ✓ $dir/"
done

echo

# Copy configuration template
echo -e "${YELLOW}Creating configuration files...${NC}"

# Determine workflow path for templates
if [[ -d "project-meta/workflow/templates" ]]; then
    # Templates from workflow submodule
    WORKFLOW_TEMPLATES="project-meta/workflow/templates"
elif [[ -d "$META_PROJECT_ROOT/templates" ]]; then
    # Running from inside meta project - use templates directly
    WORKFLOW_TEMPLATES="$META_PROJECT_ROOT/templates"
else
    echo -e "${RED}  ✗ Workflow templates not found${NC}"
    echo "  Checked: project-meta/workflow/templates and $META_PROJECT_ROOT/templates"
    exit 1
fi

# Copy path configuration
if [[ -f "$WORKFLOW_TEMPLATES/project-meta.config.json" ]]; then
    cp "$WORKFLOW_TEMPLATES/project-meta.config.json" ./project-meta.config.json
    echo "  ✓ project-meta.config.json"
else
    echo -e "${YELLOW}  ⧗ project-meta.config.json template not found (skipping)${NC}"
fi

# Copy entry point files
echo -e "${YELLOW}Creating entry point files...${NC}"

entry_points=("CLAUDE.md" "AGENTS.md" "GEMINI.md" "CODEX.md" "OPENCODE.md")

for entry in "${entry_points[@]}"; do
    if [[ -f "$WORKFLOW_TEMPLATES/entry-points/$entry" ]]; then
        cp "$WORKFLOW_TEMPLATES/entry-points/$entry" "./$entry"
        echo "  ✓ $entry"
    fi
done

echo

# Copy CONTRIBUTING.md
if [[ -f "$WORKFLOW_TEMPLATES/CONTRIBUTING.md" ]]; then
    cp "$WORKFLOW_TEMPLATES/CONTRIBUTING.md" ./CONTRIBUTING.md
    echo "  ✓ CONTRIBUTING.md"
fi

# Create README.md from template
echo -e "${YELLOW}Creating README.md...${NC}"

if [[ -f "$WORKFLOW_TEMPLATES/README.md.template" ]]; then
    sed "s/\[Project Name\]/$PROJECT_NAME/g" "$WORKFLOW_TEMPLATES/README.md.template" > README.md
    echo "  ✓ README.md"
else
    # Fallback minimal README
    cat > README.md <<EOF
# $PROJECT_NAME

[Project description]

## For Contributors

This project uses the AI-Augmented Software Development Workflow.

- See CLAUDE.md, AGENTS.md, or other entry points for AI tools
- See CONTRIBUTING.md for workflow details
- See project-meta/workflow/Workflow/ for complete workflow documentation

## Project Structure

\`\`\`
project-meta/       # Planning, specs, architecture, workflow docs
project-content/    # Source code, tests, documentation
\`\`\`
EOF
    echo "  ✓ README.md (generated)"
fi

# Copy .gitignore
if [[ -f "$WORKFLOW_TEMPLATES/.gitignore" ]]; then
    cp "$WORKFLOW_TEMPLATES/.gitignore" ./.gitignore
    echo "  ✓ .gitignore"
fi

# Create planning document stubs
echo
echo -e "${YELLOW}Creating planning document stubs...${NC}"

cat > project-meta/planning/VISION.md <<EOF
# Vision: $PROJECT_NAME

## Why This Exists

[Explain the problem this project solves and why it matters]

## Who Benefits

**Primary users:**
- [User type 1]
- [User type 2]

**Secondary stakeholders:**
- [Stakeholder type]

## Success Looks Like

**6 months:**
- [Concrete milestone 1]
- [Measurable metric]

**1 year:**
- [Concrete milestone 1]
- [Measurable metric]

**3 years:**
- [Concrete milestone 1]
- [Measurable metric]

## Version

v0.1 (draft)
EOF

echo "  ✓ project-meta/planning/VISION.md"

cat > project-meta/planning/SCOPE.md <<EOF
# Scope: $PROJECT_NAME

## In Scope

**Core Functionality:**
- [Feature 1]
- [Feature 2]

**Technical Requirements:**
- [Requirement 1]

## Out of Scope

**Explicitly excluded:**
- [Out of scope item 1]

## Constraints

**Technical:**
- [Constraint 1]

**Resource:**
- Timeline: [duration]
- Team size: [size]

## Version

v0.1 (draft)
EOF

echo "  ✓ project-meta/planning/SCOPE.md"

cat > project-meta/planning/ROADMAP.md <<EOF
# Roadmap: $PROJECT_NAME

## Phase 1: Foundation

**Goal:** [Phase goal]

**Features:**
1. [Feature 1]
2. [Feature 2]

**Success criteria:**
- [Criterion 1]

## Feature Details

### Feature 1
**Priority:** P0
**Estimated effort:** [duration]
**Dependencies:** None
**Acceptance criteria:**
- [Criterion 1]

## Version

v0.1 (draft)
EOF

echo "  ✓ project-meta/planning/ROADMAP.md"

# Create architecture document stubs
cat > project-meta/architecture/SYSTEM_MAP.md <<EOF
# System Map: $PROJECT_NAME

## Architecture Overview

[High-level architecture description]

## Component Responsibilities

### Component 1
- [Responsibility 1]

## Key Design Decisions

**Decision 1:** [Description and rationale]

## Technology Stack

- **Runtime:** [e.g., Node.js, Python]
- **Framework:** [e.g., Express, FastAPI]
- **Testing:** [e.g., Jest, pytest]

## Version

v0.1 (initial)
EOF

echo "  ✓ project-meta/architecture/SYSTEM_MAP.md"

cat > project-meta/architecture/GUIDELINES.md <<EOF
# Development Guidelines: $PROJECT_NAME

## Code Organization

\`\`\`
project-content/
├── src/
│   └── [modules]
└── tests/
    ├── unit/
    ├── integration/
    └── regression/
\`\`\`

## Coding Conventions

### Style
- [Convention 1]

### Naming
- [Naming convention 1]

### Error Handling
- [Error handling pattern]

## Testing Standards

### Coverage Requirements
- Line coverage: >80%
- Branch coverage: >70%

## Version

v0.1 (initial)
EOF

echo "  ✓ project-meta/architecture/GUIDELINES.md"

# Commit if git is initialized
if [[ $INIT_GIT -eq 1 ]]; then
    echo
    echo -e "${YELLOW}Creating initial commit...${NC}"
    git add .
    git commit -m "Initial commit: Initialize $PROJECT_NAME with workflow

- Added workflow as git submodule
- Created project-meta/ and project-content/ structure
- Added entry points for AI tools
- Created planning and architecture document stubs

Generated with init-project.sh"
    echo "  ✓ Initial commit created"
fi

echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Project initialized successfully!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${GREEN}Project location:${NC} $(cd "$TARGET_DIR" && pwd)"
echo
echo -e "${YELLOW}Project structure:${NC}"
echo "  project-meta/               Meta information about the project"
echo "    ├── workflow/             Workflow documentation (git submodule)"
echo "    ├── planning/             VISION.md, SCOPE.md, ROADMAP.md"
echo "    ├── architecture/         SYSTEM_MAP.md, GUIDELINES.md"
echo "    ├── specs/                Feature specifications"
echo "    ├── bugs/                 Bug reports"
echo "    └── reviews/              Review outputs"
echo "  project-content/            Project deliverables"
echo "    ├── src/                  Source code"
echo "    ├── tests/                Test code"
echo "    └── docs/                 User documentation"
echo
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. cd $(cd "$TARGET_DIR" && pwd)"
echo "  2. Review and complete project-meta/planning/VISION.md"
echo "  3. Read CLAUDE.md (or AGENTS.md, etc.) and CONTRIBUTING.md"
echo "  4. For AI tools: 'act as vision-writing-helper' to refine vision"
echo
echo -e "${BLUE}Workflow documentation: project-meta/workflow/Workflow/${NC}"
echo
