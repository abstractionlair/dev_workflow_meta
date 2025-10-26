# Setting Up a Concrete Project

## Purpose

Get the workflow documentation and entry point files into your project so AI tools can navigate it.

## Setup Steps

### Option A: Fork This Repository (Recommended for new projects)

```bash
# Fork dev_workflow_meta on GitHub/GitLab
# Clone your fork
git clone https://github.com/[your-org]/[your-project-name].git
cd [your-project-name]

# You now have everything: Workflow/, CLAUDE.md, CONTRIBUTING.md, etc.
```

Then customize:
- Update README.md with your project description
- Update repo name and description
- Start creating VISION.md, SCOPE.md, etc. as you use the workflow

**Pros:** Everything already set up, can contribute improvements back
**Cons:** Git history includes meta-project history

### Option B: Copy Files (Clean slate)

```bash
# Create your new project
mkdir my-project
cd my-project
git init

# Copy everything from meta-project
cp -r /path/to/dev_workflow_meta/Workflow ./Workflow/
cp /path/to/dev_workflow_meta/CLAUDE.md ./
cp /path/to/dev_workflow_meta/AGENTS.md ./
cp /path/to/dev_workflow_meta/CODEX.md ./
cp /path/to/dev_workflow_meta/OPENCODE.md ./
cp /path/to/dev_workflow_meta/GEMINI.md ./
cp /path/to/dev_workflow_meta/CONTRIBUTING.md ./
cp /path/to/dev_workflow_meta/README.md ./
cp /path/to/dev_workflow_meta/.gitignore ./

# Customize README.md for your project
# Then commit
git add .
git commit -m "Initialize from dev_workflow_meta"
```

**Pros:** Clean git history, full control
**Cons:** Manual process, won't get meta-project updates

### Option C: Use as Template (If hosted on GitHub)

Mark the meta-project repository as a template on GitHub, then use "Use this template" button.

**Pros:** One-click setup, clean history
**Cons:** Requires GitHub, setup needed in meta-project

## Directory Structure After Setup

```
project/
├── Workflow/                    # Workflow docs (don't modify)
│   ├── Workflow.md              # Complete workflow overview
│   ├── RoleCatalog.md           # All available roles
│   ├── Ontology.md              # All artifact types
│   ├── LayoutAndState.md        # File organization and state tracking
│   ├── role-*.md                # Individual role definitions
│   └── schema-*.md              # Artifact schemas
├── CLAUDE.md                    # Entry point for Claude
├── AGENTS.md                    # Entry point for Anthropic agents
├── CODEX.md                     # Entry point for Codex
├── OPENCODE.md                  # Entry point for open-source tools
├── GEMINI.md                    # Entry point for Gemini
├── CONTRIBUTING.md              # Points to Workflow/, allows project additions
├── README.md                    # Customize for your project
└── [directories created during workflow use:]
    ├── VISION.md                # Created by vision-writer
    ├── SCOPE.md                 # Created by scope-writer
    ├── ROADMAP.md               # Created by roadmap-writer
    ├── SYSTEM_MAP.md            # Created/maintained by platform-lead
    ├── GUIDELINES.md            # Created/maintained by platform-lead
    ├── bugs/
    │   ├── to_fix/
    │   ├── fixing/
    │   └── fixed/
    ├── specs/
    │   ├── proposed/
    │   ├── todo/
    │   ├── doing/
    │   └── done/
    ├── reviews/
    │   ├── vision/
    │   ├── scope/
    │   ├── roadmap/
    │   ├── specs/
    │   ├── skeletons/
    │   ├── tests/
    │   ├── implementations/
    │   └── bug-fixes/
    ├── tests/
    │   ├── unit/
    │   ├── integration/
    │   └── regression/
    └── src/
```

## Using the Workflow

### Getting Started (Recommended)

Ask your AI tool to explain the workflow:

```
"Can you explain the workflow documented in this project?"
```

For example, if using Claude Code:

```
"Read CLAUDE.md and explain how this development workflow works"
```

(For other tools, use CODEX.md, GEMINI.md, etc.)

### Starting Your First Feature

For example, if using Claude Code:

```
"Read CLAUDE.md, then act as vision-writing-helper to help me create a VISION.md"
```

(For other tools, replace CLAUDE.md with the appropriate entry point: CODEX.md, AGENTS.md, GEMINI.md, or OPENCODE.md)

### General Pattern

```
"[Read ENTRY_POINT.md and] act as [role-name] to [task]"
```

Examples:
- `"Act as vision-writing-helper to help me create VISION.md"`
- `"Act as spec-writer to create a spec for user authentication"`
- `"Act as test-writer for the spec at specs/doing/user-auth.md"`
- `"Act as implementer for the user-auth feature"`

Note: Some tools may automatically read their entry point file, so explicitly requesting it may not be necessary. However, including it ensures the agent starts from the correct context.

## Done

Your project is now set up. AI tools can navigate the documentation and take on specific roles as needed.
