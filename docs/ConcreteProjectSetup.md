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
./dev_workflow_meta/bin/init-project.sh my-project-name

# The script auto-detects and creates the project as a sibling to dev_workflow_meta
cd my-project-name
```

**Auto-Detection Features:**
- The script automatically detects if you run it from inside `dev_workflow_meta`
- When detected, it creates your project in the parent directory (avoiding nested structure)
- You can override this with `-d /path/to/custom/location`
- Clear messaging shows you where the project is being created

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

### 5. Create Initial README

Create a README.md for your project (customize from template):

```bash
cp project-meta/workflow/templates/README.md .
# Edit README.md to describe your project
```

**Note**: Don't manually create VISION.md, SCOPE.md, or ROADMAP.md. After the initial commit, use the interactive helper workflow (see "Next Steps" section below) to create these documents through guided dialogue.

### 6. Commit

```bash
git add .
git commit -m "Initial commit: Add workflow submodule and structure"
```

## Using the Workflow

### For AI Tools

Entry points tell AI tools how to navigate the workflow. The workflow is designed around **interactive helpers** that guide you through creating foundational documents via Socratic dialogue.

**Starting a new project:**

```
# For Claude Code:
"Read CLAUDE.md, then act as vision-writing-helper"

# For other AI tools:
"Read AGENTS.md (or GEMINI.md, etc.), then act as vision-writing-helper"
```

The helper will ask you questions about your project to clarify your thinking, then create VISION.md for you.

**The helper → writer → reviewer progression:**

Each planning artifact follows the same pattern:
1. **Helper role**: Interactive Socratic dialogue to clarify your thinking
2. **Writer role**: Creates the structured document from the conversation
3. **Reviewer role**: Validates document quality before you proceed

**Planning workflow progression:**

```
vision-writing-helper  →  VISION.md  →  vision-reviewer
        ↓
scope-writing-helper   →  SCOPE.md   →  scope-reviewer
        ↓
roadmap-writing-helper →  ROADMAP.md →  roadmap-reviewer
        ↓
spec-writer            →  SPEC.md    →  spec-reviewer
        ↓
skeleton-writer        →  skeleton   →  skeleton-reviewer
        ↓
test-writer            →  tests      →  test-reviewer
        ↓
implementer            →  code       →  implementation-reviewer
```

**Note**: Helpers are synchronous/interactive only. The writer and reviewer roles can work asynchronously via email notifications (see [Workflow/EmailIntegration.md](../Workflow/EmailIntegration.md)).

### Common Roles by Category

**Planning Helpers** (Interactive dialogue):
- `vision-writing-helper` - Guide you through articulating your vision
- `scope-writing-helper` - Help define concrete scope from vision
- `roadmap-writing-helper` - Help sequence features into phases

**Planning Writers** (Document creation):
- `vision-writer` - Create VISION.md (usually invoked by helper)
- `scope-writer` - Create SCOPE.md from VISION.md
- `roadmap-writer` - Create ROADMAP.md from SCOPE.md

**Planning Reviewers** (Quality validation):
- `vision-reviewer` - Validate VISION.md quality
- `scope-reviewer` - Validate SCOPE.md quality
- `roadmap-reviewer` - Validate ROADMAP.md quality

**Implementation Roles**:
- `spec-writer` - Write feature specifications
- `skeleton-writer` - Create interface skeletons
- `test-writer` - Write tests from specs
- `implementer` - Implement features

See [Workflow/RoleCatalog.md](../Workflow/RoleCatalog.md) for complete role list and descriptions.

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

After setting up your project structure, use the **interactive helper workflow** to create your planning documents. Don't create VISION.md, SCOPE.md, or ROADMAP.md manually - the helpers will guide you through the process and ensure you follow best practices.

### Step 1: Create Your Vision (Interactive)

Start by working with the vision-writing-helper to articulate your project vision through Socratic dialogue:

**What to do:**
```bash
# In your AI tool (Claude Code, etc.):
"Read CLAUDE.md, then act as vision-writing-helper"
```

**What happens:**
- The helper asks you questions about your project idea
- You have a conversation exploring: problem space, target users, value proposition, MVP scope, success criteria
- When clarity emerges, the helper invokes `vision-writer` to create `project-meta/planning/VISION.md`
- Optionally review with `vision-reviewer` to validate quality

**The conversation will cover:**
- What problem are you solving and why does it matter?
- Who specifically will use this?
- What's the core value proposition?
- What's in/out of MVP scope?
- How will you measure success?

**Schemas and references:**
- Document structure: [Workflow/schema-vision.md](../Workflow/schema-vision.md)
- Helper details: [Workflow/role-vision-writing-helper.md](../Workflow/role-vision-writing-helper.md)
- Writer details: [Workflow/role-vision-writer.md](../Workflow/role-vision-writer.md)

### Step 2: Define Your Scope (Interactive)

Once VISION.md exists, work with scope-writing-helper to make your vision concrete:

**What to do:**
```bash
"Act as scope-writing-helper"
```

**What happens:**
- Helper reviews your VISION.md with you
- Conversation makes abstract features concrete and specific
- Defines user capabilities, technical requirements, and boundaries
- Helper invokes `scope-writer` to create `project-meta/planning/SCOPE.md`
- Optionally review with `scope-reviewer`

**The conversation will cover:**
- What specific features deliver the vision?
- What can users actually DO after MVP?
- What technical requirements and constraints exist?
- What's explicitly OUT of scope to prevent creep?
- What are the acceptance criteria for MVP?

**Schemas and references:**
- Document structure: [Workflow/schema-scope.md](../Workflow/schema-scope.md)
- Helper details: [Workflow/role-scope-writing-helper.md](../Workflow/role-scope-writing-helper.md)
- Writer details: [Workflow/role-scope-writer.md](../Workflow/role-scope-writer.md)

### Step 3: Plan Your Roadmap (Interactive)

With VISION.md and SCOPE.md complete, sequence your features with roadmap-writing-helper:

**What to do:**
```bash
"Act as roadmap-writing-helper"
```

**What happens:**
- Helper reviews your vision and scope
- Conversation identifies risks, maps dependencies, defines phases
- Structures features to derisk early and deliver value incrementally
- Helper invokes `roadmap-writer` to create `project-meta/planning/ROADMAP.md`
- Optionally review with `roadmap-reviewer`

**The conversation will cover:**
- What are your riskiest technical assumptions?
- What features depend on other features?
- How should features be grouped into phases?
- What does Phase 1 validate and deliver?
- What are the success criteria for each phase?

**Schemas and references:**
- Document structure: [Workflow/schema-roadmap.md](../Workflow/schema-roadmap.md)
- Helper details: [Workflow/role-roadmap-writing-helper.md](../Workflow/role-roadmap-writing-helper.md)
- Writer details: [Workflow/role-roadmap-writer.md](../Workflow/role-roadmap-writer.md)

### Step 4: Begin Implementation

With planning complete (VISION, SCOPE, ROADMAP), you're ready to implement:

**The TDD workflow:**
```
For each feature in your roadmap:
1. spec-writer creates specification
2. spec-reviewer validates spec quality
3. skeleton-writer creates interface skeleton
4. skeleton-reviewer validates testability
5. test-writer writes tests (they fail - Red)
6. test-reviewer validates test quality
7. implementer writes code to pass tests (Green)
8. implementation-reviewer validates implementation
9. Refactor for quality
```

**Starting your first feature:**
```bash
# Specify the first Phase 1 feature from your roadmap:
"Act as spec-writer and create a spec for [feature name from ROADMAP.md]"
```

### Why Use Helpers Instead of Writing Documents Manually?

**Helpers provide:**
- **Guided thinking**: Socratic questions help you discover what you don't know
- **Best practices**: Built-in knowledge of what makes good vision/scope/roadmap docs
- **Quality assurance**: Documents follow proven schemas and patterns
- **Completeness**: Helpers ensure you don't skip critical sections
- **Reality checks**: Helpers challenge unrealistic assumptions and scope

**Example of helper value:**
Instead of writing "Build a productivity app" in VISION.md, the vision-writing-helper will probe:
- What specific productivity problem? For whom?
- What do they do today? Why doesn't it work?
- What will they be able to do with your solution?
- How will you know you've solved it?

This results in a concrete, actionable vision instead of vague aspirations.

### Additional Resources

- **Complete workflow example**: [Workflow/WorkflowExample.md](../Workflow/WorkflowExample.md)
- **All role descriptions**: [Workflow/RoleCatalog.md](../Workflow/RoleCatalog.md)
- **Helper pattern explanation**: [Workflow/patterns/helper-role-pattern.md](../Workflow/patterns/helper-role-pattern.md)
- **Schema relationships**: [Workflow/patterns/schema-relationship-map.md](../Workflow/patterns/schema-relationship-map.md)
- **Email integration** (for async work): [Workflow/EmailIntegration.md](../Workflow/EmailIntegration.md)

### Quick Reference: First Session Commands

```bash
# After running init-project.sh and cd'ing into your project:

# Step 1: Create vision (interactive conversation)
"Read CLAUDE.md, then act as vision-writing-helper"

# Step 2: Define scope (after VISION.md exists)
"Act as scope-writing-helper"

# Step 3: Plan roadmap (after SCOPE.md exists)
"Act as roadmap-writing-helper"

# Step 4: Start implementing first feature (after ROADMAP.md exists)
"Act as spec-writer for [first Phase 1 feature]"
```
