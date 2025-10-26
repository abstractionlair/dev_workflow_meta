#!/usr/bin/env bash

# workflow-init.sh
# Bootstrap a new project with workflow structure and template artifacts

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

Bootstrap a new project with workflow structure and template artifacts.

OPTIONS:
    -h, --help          Show this help message
    -d, --directory     Target directory (default: current directory)
    -g, --no-git        Skip git initialization
    -w, --workflow-path Path to workflow documentation (default: ./Workflow)

EXAMPLES:
    # Initialize in current directory
    $0 my-project

    # Initialize in specific directory
    $0 -d ~/projects/my-project my-project

    # Initialize without git
    $0 --no-git my-project

EOF
}

# Parse arguments
PROJECT_NAME=""
TARGET_DIR="."
INIT_GIT=1
WORKFLOW_PATH="./Workflow"

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
        -w|--workflow-path)
            WORKFLOW_PATH="$2"
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

# Create target directory if needed
if [[ "$TARGET_DIR" != "." ]]; then
    mkdir -p "$TARGET_DIR"
    cd "$TARGET_DIR"
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}   Initializing Workflow for: $PROJECT_NAME${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Create directory structure
echo -e "${YELLOW}Creating directory structure...${NC}"

directories=(
    "specs/proposed"
    "specs/todo"
    "specs/doing"
    "specs/done"
    "bugs/to_fix"
    "bugs/fixing"
    "bugs/fixed"
    "reviews/vision"
    "reviews/scope"
    "reviews/roadmap"
    "reviews/specs"
    "reviews/skeletons"
    "reviews/tests"
    "reviews/implementations"
    "reviews/bug-fixes"
    "tests/unit"
    "tests/integration"
    "tests/regression"
    "src"
)

for dir in "${directories[@]}"; do
    mkdir -p "$dir"
    echo "  ✓ $dir/"
done

echo

# Create VISION.md template
echo -e "${YELLOW}Creating VISION.md template...${NC}"
cat > VISION.md <<'EOF'
# Vision: PROJECT_NAME

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
- [Concrete milestone 2]
- [Measurable metric]

**1 year:**
- [Concrete milestone 1]
- [Concrete milestone 2]
- [Measurable metric]

**3 years:**
- [Concrete milestone 1]
- [Concrete milestone 2]
- [Measurable metric]

## Version

v0.1 (draft)
EOF

# Replace placeholder
sed -i.bak "s/PROJECT_NAME/$PROJECT_NAME/g" VISION.md && rm VISION.md.bak 2>/dev/null || sed -i '' "s/PROJECT_NAME/$PROJECT_NAME/g" VISION.md 2>/dev/null || true

echo "  ✓ VISION.md"

# Create SCOPE.md stub
echo -e "${YELLOW}Creating SCOPE.md stub...${NC}"
cat > SCOPE.md <<'EOF'
# Scope: PROJECT_NAME

## In Scope

**Core Functionality:**
- [Feature 1]
- [Feature 2]

**Technical Requirements:**
- [Requirement 1]
- [Requirement 2]

## Out of Scope

**Explicitly excluded:**
- [Out of scope item 1]
- [Out of scope item 2]

## Constraints

**Technical:**
- [Constraint 1]
- [Constraint 2]

**Resource:**
- Timeline: [duration]
- Team size: [size]
- Budget: [budget]

## Non-Functional Requirements

- [NFR 1]
- [NFR 2]

## Version

v0.1 (draft)
EOF

sed -i.bak "s/PROJECT_NAME/$PROJECT_NAME/g" SCOPE.md && rm SCOPE.md.bak 2>/dev/null || sed -i '' "s/PROJECT_NAME/$PROJECT_NAME/g" SCOPE.md 2>/dev/null || true

echo "  ✓ SCOPE.md"

# Create ROADMAP.md stub
echo -e "${YELLOW}Creating ROADMAP.md stub...${NC}"
cat > ROADMAP.md <<'EOF'
# Roadmap: PROJECT_NAME

## Phase 1: Foundation

**Goal:** [Phase goal]

**Features:**
1. [Feature 1]
2. [Feature 2]

**Success criteria:**
- [Criterion 1]
- [Criterion 2]

## Phase 2: Enhancement

**Goal:** [Phase goal]

**Features:**
1. [Feature 3]
2. [Feature 4]

**Success criteria:**
- [Criterion 1]
- [Criterion 2]

## Feature Details

### Feature 1
**Priority:** P0
**Estimated effort:** [duration]
**Dependencies:** None
**Acceptance criteria:**
- [Criterion 1]
- [Criterion 2]

## Version

v0.1 (draft)
EOF

sed -i.bak "s/PROJECT_NAME/$PROJECT_NAME/g" ROADMAP.md && rm ROADMAP.md.bak 2>/dev/null || sed -i '' "s/PROJECT_NAME/$PROJECT_NAME/g" ROADMAP.md 2>/dev/null || true

echo "  ✓ ROADMAP.md"

# Create SYSTEM_MAP.md stub
echo -e "${YELLOW}Creating SYSTEM_MAP.md stub...${NC}"
cat > SYSTEM_MAP.md <<'EOF'
# System Map: PROJECT_NAME

## Architecture Overview

[High-level architecture description]

```
[ASCII diagram of system components]
```

## Component Responsibilities

### Component 1
- [Responsibility 1]
- [Responsibility 2]

### Component 2
- [Responsibility 1]
- [Responsibility 2]

## Key Design Decisions

**Decision 1:** [Description and rationale]

**Decision 2:** [Description and rationale]

## Technology Stack

- **Runtime:** [e.g., Node.js, Python]
- **Framework:** [e.g., Express, FastAPI]
- **Database:** [e.g., PostgreSQL]
- **Testing:** [e.g., Jest, pytest]

## Version

v0.1 (initial)
EOF

sed -i.bak "s/PROJECT_NAME/$PROJECT_NAME/g" SYSTEM_MAP.md && rm SYSTEM_MAP.md.bak 2>/dev/null || sed -i '' "s/PROJECT_NAME/$PROJECT_NAME/g" SYSTEM_MAP.md 2>/dev/null || true

echo "  ✓ SYSTEM_MAP.md"

# Create GUIDELINES.md stub
echo -e "${YELLOW}Creating GUIDELINES.md stub...${NC}"
cat > GUIDELINES.md <<'EOF'
# Development Guidelines: PROJECT_NAME

## Code Organization

```
src/
├── [directory structure]
tests/
├── unit/
├── integration/
└── regression/
```

## Coding Conventions

### Style
- [Convention 1]
- [Convention 2]

### Naming
- [Naming convention 1]
- [Naming convention 2]

### Error Handling
- [Error handling pattern]

## Testing Standards

### Coverage Requirements
- Line coverage: >80%
- Branch coverage: >70%

### Test Structure
[Example test structure]

## Patterns

### Pattern 1
✓ Do: [Description]
❌ Don't: [Description]

### Pattern 2
✓ Do: [Description]
❌ Don't: [Description]

## Version

v0.1 (initial)
EOF

sed -i.bak "s/PROJECT_NAME/$PROJECT_NAME/g" GUIDELINES.md && rm GUIDELINES.md.bak 2>/dev/null || sed -i '' "s/PROJECT_NAME/$PROJECT_NAME/g" GUIDELINES.md 2>/dev/null || true

echo "  ✓ GUIDELINES.md"

# Create .gitignore
echo -e "${YELLOW}Creating .gitignore...${NC}"
cat > .gitignore <<'EOF'
# Environment
.env
.env.local

# Dependencies
node_modules/
__pycache__/
*.pyc
venv/
.venv/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Build outputs
dist/
build/
*.egg-info/

# Test coverage
.coverage
htmlcov/
coverage/
.pytest_cache/

# Logs
*.log
logs/
EOF

echo "  ✓ .gitignore"

# Create README.md
echo -e "${YELLOW}Creating README.md...${NC}"
cat > README.md <<EOF
# $PROJECT_NAME

[Project description]

## Documentation

This project uses an artifact-driven development workflow.

**Getting started:**
- Read [VISION.md](VISION.md) to understand project goals
- See [CONTRIBUTING.md](CONTRIBUTING.md) for workflow details

**Key documents:**
- [VISION.md](VISION.md) - Project vision and success criteria
- [SCOPE.md](SCOPE.md) - Project boundaries and constraints
- [ROADMAP.md](ROADMAP.md) - Feature sequence and timeline
- [SYSTEM_MAP.md](SYSTEM_MAP.md) - Architecture overview
- [GUIDELINES.md](GUIDELINES.md) - Coding conventions

**Workflow documentation:**
See [$WORKFLOW_PATH]($WORKFLOW_PATH) for complete workflow details.

## Quick Start

[Installation and setup instructions]

## Development

Check project status:
\`\`\`bash
./bin/workflow-status.sh
\`\`\`

## License

[License information]
EOF

echo "  ✓ README.md"

# Create CONTRIBUTING.md
echo -e "${YELLOW}Creating CONTRIBUTING.md...${NC}"
cat > CONTRIBUTING.md <<EOF
# How to Contribute

## About this File

This is the contribution guide for contributors (both human and AI) to this project.

## Workflow Documentation

This project uses an artifact-driven, multi-model development workflow.

**Key documents:**
- [$WORKFLOW_PATH/Workflow.md]($WORKFLOW_PATH/Workflow.md) - Complete workflow overview
- [$WORKFLOW_PATH/RoleCatalog.md]($WORKFLOW_PATH/RoleCatalog.md) - All available roles
- [$WORKFLOW_PATH/Ontology.md]($WORKFLOW_PATH/Ontology.md) - All artifact types
- [$WORKFLOW_PATH/LayoutAndState.md]($WORKFLOW_PATH/LayoutAndState.md) - File organization

## For AI Agents

You will be told what role you should play, either explicitly or implicitly based on context.

**To take on a role:**
1. Read the corresponding role file from \`$WORKFLOW_PATH/role-*.md\`
2. Read any schema files it references from \`$WORKFLOW_PATH/schema-*.md\`
3. Read the relevant project documents (VISION.md, SCOPE.md, ROADMAP.md, SYSTEM_MAP.md, GUIDELINES.md)
4. Follow the instructions in the role file

**Common starting roles:**
- [$WORKFLOW_PATH/role-vision-writing-helper.md]($WORKFLOW_PATH/role-vision-writing-helper.md) - Help create VISION.md
- [$WORKFLOW_PATH/role-spec-writer.md]($WORKFLOW_PATH/role-spec-writer.md) - Write feature specifications
- [$WORKFLOW_PATH/role-implementer.md]($WORKFLOW_PATH/role-implementer.md) - Implement features

## For Human Contributors

See [$WORKFLOW_PATH/WorkflowExample.md]($WORKFLOW_PATH/WorkflowExample.md) for a complete walkthrough example.

**Check status:**
\`\`\`bash
./bin/workflow-status.sh
\`\`\`
EOF

echo "  ✓ CONTRIBUTING.md"

# Create CLAUDE.md for Claude Code
echo -e "${YELLOW}Creating AI tool entry point files...${NC}"
cat > CLAUDE.md <<'EOF'
# About this File

This file's purpose is to contain instructions and documentation for new conversations/contexts in Claude Code.

# Instructions

Read **[CONTRIBUTING.md](CONTRIBUTING.md)** next.
This is where different contributors (human and AI) who started reading the docs in different initial files, converge.
EOF

echo "  ✓ CLAUDE.md"

# Initialize git if requested
if [[ $INIT_GIT -eq 1 ]]; then
    echo
    echo -e "${YELLOW}Initializing git repository...${NC}"
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        git init
        git add .
        git commit -m "Initial commit: Bootstrap workflow structure

Generated with workflow-init.sh

Project: $PROJECT_NAME"
        echo "  ✓ Git repository initialized"
    else
        echo "  ⧗ Git repository already exists (skipping)"
    fi
fi

echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Workflow initialized successfully!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Review and complete VISION.md"
echo "  2. Run: ./bin/workflow-status.sh"
echo "  3. For AI tools: act as vision-writing-helper"
echo
echo -e "${BLUE}Workflow documentation: $WORKFLOW_PATH/${NC}"
echo
