# AI-Augmented Software Development Workflow

> **This is a meta-project** that defines a workflow for AI-augmented development.
> Use it as a **git submodule** in your concrete projects, or fork it to customize.

## Quick Start

**To use this workflow in your project:**

```bash
# Clone this repository
git clone https://github.com/abstractionlair/dev_workflow_meta.git
cd dev_workflow_meta

# Initialize a new project with the workflow
./bin/init-project.sh my-project-name
cd my-project-name

# The workflow is now available in project-meta/workflow/
```

See [docs/ConcreteProjectSetup.md](docs/ConcreteProjectSetup.md) for detailed setup instructions.

## What This Provides

This workflow addresses common challenges in AI-augmented development:

**The Problem:**
- Models "forget" architectural decisions and reimple features
- Context limits lead to lost methodology details
- Code quality varies without systematic review
- No clear handoff between planning and implementation

**The Solution:**
- **Artifact-driven development**: VISION → SCOPE → ROADMAP → SPEC → TEST → IMPLEMENT
- **Multi-role workflow**: Different AI models/prompts for different tasks (planning vs. implementation vs. review)
- **Clear file organization**: Separate meta-information from deliverable outputs
- **State tracking through file location**: Know what's planned, in-progress, or done

## Project Structure

When used as a submodule, concrete projects are organized as:

```
your-project/
├── project-meta/           # Information ABOUT the project
│   ├── workflow/           # This repository (as git submodule)
│   ├── planning/           # VISION, SCOPE, ROADMAP
│   ├── architecture/       # SYSTEM_MAP, GUIDELINES
│   └── specs/              # Feature specifications
└── project-content/        # Deliverable OUTPUTS
    ├── src/                # Implementation code
    ├── tests/              # Test code
    └── docs/               # User documentation
```

## Workflow Documentation

This repository contains:

- **[Workflow/](Workflow/)** - Complete workflow documentation
  - [Workflow.md](Workflow/Workflow.md) - Overall workflow process
  - [RoleCatalog.md](Workflow/RoleCatalog.md) - All available AI roles
  - [LayoutAndState.md](Workflow/LayoutAndState.md) - File organization and state tracking
  - `role-*.md` - Individual role definitions
  - `schema-*.md` - Document schemas

- **[templates/](templates/)** - Files for concrete projects
  - `entry-points/` - AI tool entry points (CLAUDE.md, AGENTS.md, etc.)
  - `CONTRIBUTING.md` - Contributor guide template
  - `.gitignore` - Standard gitignore
  - `project-meta.config.json` - Path configuration

- **[bin/](bin/)** - Utility scripts
  - `init-project.sh` - Initialize a new project with this workflow
  - `workflow-status.sh` - Check project status

- **[docs/](docs/)** - Meta-project documentation
  - [ConcreteProjectSetup.md](docs/ConcreteProjectSetup.md) - How to use this in your project
  - `inspiration/` - Research and inspiration
  - `rfcs/` - Proposals for workflow improvements

## Why This Workflow

From experiments with Claude Code, OpenAI Codex, and similar tools (circa October 2024):

**Observations:**
- AI tools excel at starting projects but struggle as complexity grows
- Written specifications help, but conversational refinement is valuable
- Multi-model approaches (one model implements, another reviews) improve quality

**Design Principles:**
- Artifact-driven: Persistent documents combat "forgetting"
- Multi-role: Specialized prompts/models for different tasks
- Structured process: Appropriate for AI agents who can switch roles instantly
- Progressive refinement: Conversation → Specification → Implementation

## For Contributors

This meta-project is itself multi-model. See:
- [templates/entry-points/CLAUDE.md](templates/entry-points/CLAUDE.md) for Claude-specific entry
- [templates/entry-points/AGENTS.md](templates/entry-points/AGENTS.md) for other Anthropic agents
- [templates/CONTRIBUTING.md](templates/CONTRIBUTING.md) for general contribution guidelines

## License

[License information TBD]
