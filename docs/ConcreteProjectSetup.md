# Setting Up a Concrete Project

## Purpose

Integrate the AI-Augmented Development Workflow into your project as a git submodule.
This creates a clean separation between meta-information (planning, specs, workflow) and deliverable outputs (code, tests, docs).

## Quick Start

The fastest way to get started:

```bash
# Clone or download this repository
git clone https://github.com/abstractionlair/dev_workflow_meta.git

# Run the initialization script
cd dev_workflow_meta
./bin/init-project.sh my-project-name

# Your new project is created in ./my-project-name/
cd my-project-name
```

## What Gets Created

The initialization script creates this structure:

```
my-project-name/
├── CLAUDE.md                        # Entry point for Claude Code
├── AGENTS.md                        # Entry point for other Anthropic agents
├── GEMINI.md                        # Entry point for Gemini
├── CODEX.md                         # Entry point for Codex
├── OPENCODE.md                      # Entry point for OpenCode
├── README.md                        # About your project
├── CONTRIBUTING.md                  # How to contribute
├── project-meta.config.json         # Path configuration (optional)
├── project-meta/                    # Information ABOUT the project
│   ├── workflow/                    # Git submodule -> dev_workflow_meta
│   ├── planning/
│   │   ├── VISION.md                # Why this project exists
│   │   ├── SCOPE.md                 # What's in/out
│   │   └── ROADMAP.md               # Feature sequence
│   ├── architecture/
│   │   ├── SYSTEM_MAP.md            # Architecture reference
│   │   └── GUIDELINES.md            # Coding conventions
│   ├── specs/
│   ├── bugs/
│   ├── reviews/
│   └── review-requests/
└── project-content/                 # Deliverable OUTPUTS
    ├── src/                         # Source code
    ├── tests/                       # Test code
    └── docs/                        # User documentation
```

## Manual Setup

If you prefer to set up manually:

### 1. Create Your Project

```bash
mkdir my-project
cd my-project
git init
```

### 2. Add Workflow as Submodule

```bash
mkdir project-meta
git submodule add https://github.com/abstractionlair/dev_workflow_meta.git project-meta/workflow
git submodule update --init --recursive
```

### 3. Create Directory Structure

```bash
# Meta directories
mkdir -p project-meta/{planning,architecture}
mkdir -p project-meta/specs/{proposed,todo,doing,done}
mkdir -p project-meta/bugs/{to_fix,fixing,fixed}
mkdir -p project-meta/reviews/{vision,scope,roadmap,specs,skeletons,tests,implementations,bug-fixes}
mkdir -p project-meta/review-requests/{vision,scope,roadmap,specs,skeletons,tests,implementations,bug-fixes,archived}

# Content directories
mkdir -p project-content/src
mkdir -p project-content/tests/{unit,integration,regression}
mkdir -p project-content/docs
```

### 4. Copy Template Files

```bash
# Entry points
cp project-meta/workflow/templates/entry-points/*.md .

# Contributing guide
cp project-meta/workflow/templates/CONTRIBUTING.md .

# .gitignore
cp project-meta/workflow/templates/.gitignore .

# Configuration (optional)
cp project-meta/workflow/templates/project-meta.config.json .
```

### 5. Create Initial Files

Create stubs for planning documents:

```bash
# VISION.md
cat > project-meta/planning/VISION.md <<EOF
# Vision: My Project

## Why This Exists
[Your vision here]

## Who Benefits
- [Primary users]

## Success Looks Like
**6 months:**
- [Milestone]

## Version
v0.1 (draft)
EOF

# SCOPE.md and ROADMAP.md similarly
```

Create a README.md for your project (customize from template).

### 6. Commit

```bash
git add .
git commit -m "Initial commit: Add workflow submodule and structure"
```

## Using the Workflow

### For AI Tools

Entry points tell AI tools how to navigate the workflow:

```
# For Claude Code:
"Read CLAUDE.md, then act as vision-writing-helper to help me create a vision"

# For other tools:
"Read AGENTS.md (or GEMINI.md, etc.), then act as [role-name]"
```

Common roles:
- `vision-writing-helper` - Help create VISION.md
- `scope-writer` - Create SCOPE.md from VISION.md
- `roadmap-writer` - Create ROADMAP.md from SCOPE.md
- `spec-writer` - Write feature specifications
- `test-writer` - Write tests from specs
- `implementer` - Implement features

See [Workflow/RoleCatalog.md](../Workflow/RoleCatalog.md) for all roles.

### Directory Organization

**Root directory:** Only navigational files
- Entry points (CLAUDE.md, AGENTS.md, etc.)
- README.md (about the project)
- CONTRIBUTING.md (how to work here)

**project-meta/:** Information *about* the project
- Planning documents (VISION, SCOPE, ROADMAP)
- Architecture docs (SYSTEM_MAP, GUIDELINES)
- Specifications (what to build)
- Bug reports (what to fix)
- Review artifacts (quality gates)

**project-content/:** Deliverable *outputs*
- src/ - Implementation code
- tests/ - Test code
- docs/ - User-facing documentation

This separation maintains conceptual clarity: the root is purely navigational, meta is about the project, content is the project's outputs.

## Updating the Workflow

To get updates to the workflow documentation:

```bash
cd project-meta/workflow
git pull origin main
cd ../..
git add project-meta/workflow
git commit -m "Update workflow submodule"
```

## Path Configuration (Advanced)

If you need to customize directory paths, edit `project-meta.config.json`:

```json
{
  "meta_root": "project-meta",
  "specs_dir": "project-meta/specs",
  "bugs_dir": "project-meta/bugs",

  "content_root": "project-content",
  "src_dir": "project-content/src",
  "tests_dir": "project-content/tests",
  "docs_dir": "project-content/docs"
}
```

Most projects won't need to customize this.

## Alternative: Fork Instead of Submodule

If you prefer to fork rather than use a submodule:

```bash
# Fork dev_workflow_meta on GitHub
# Clone your fork
git clone https://github.com/your-org/your-project.git
cd your-project

# Remove meta-project specific files
rm -rf docs/inspiration docs/rfcs
mv templates/* .
rmdir templates

# Customize for your project
# Edit README.md, etc.
```

**Pros:** Full control, simpler git operations
**Cons:** No easy workflow updates, git history includes meta-project

## Next Steps

1. **Complete VISION.md**: Define why your project exists
2. **Read workflow docs**: See `project-meta/workflow/Workflow/`
3. **Start with a helper**: Ask AI to "act as vision-writing-helper"
4. **Follow the workflow**: VISION → SCOPE → ROADMAP → SPEC → TEST → IMPLEMENT

See [Workflow/WorkflowExample.md](../Workflow/WorkflowExample.md) for a complete walkthrough.
