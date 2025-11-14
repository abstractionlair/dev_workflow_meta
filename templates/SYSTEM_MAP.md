# System Map - Development Workflow Meta-Project

## Purpose

This document maps the architecture of the **meta-project** itself - the project that defines the workflow system. For information about how concrete projects using this workflow should be structured, see [Workflow/LayoutAndState.md](Workflow/LayoutAndState.md).

## Project Structure

```
dev_workflow_meta/
├── Entry Points (AI agent initialization)
├── Core Documentation (project overview)
├── Workflow/ (workflow system definition)
│   ├── Core System Docs
│   ├── Role Definitions
│   ├── Schema Specifications
│   ├── Patterns (reusable templates)
│   ├── Scripts (automation)
│   └── Supporting Documents
└── Project Tracking
```

## Entry Points

**Location**: Root directory

**Purpose**: Agent-specific initialization files that route to CONTRIBUTING.md

| File | For | Purpose |
|------|-----|---------|
| CLAUDE.md | Claude (Anthropic) | Entry point for Claude Code and Claude API |
| AGENTS.md | Anthropic Agents | Entry point for agent-based tools |
| CODEX.md | GPT-5 Codex (OpenAI) | Entry point for Codex review system |
| GEMINI.md | Google Gemini | Entry point for Gemini models |
| OPENCODE.md | Open-source tools | Entry point for other AI coding assistants |

**Key Pattern**: All entry points → CONTRIBUTING.md → README.md → Workflow/

**Used by**: AI agents starting new conversations

## Core Documentation

**Location**: Root directory

### README.md
**Purpose**: Project overview - why this exists, what it is, how it works

**Contains**:
- Project motivation (forgetting problem, quality issues)
- Multi-model, artifact-driven approach explanation
- Links to major workflow components
- Status and completion overview

**Used by**: Everyone (first read for humans and AIs)

### CONTRIBUTING.md
**Purpose**: Convergence point for all agents after reading entry files

**Contains**:
- Instructions for contributors
- Warning about level confusion (meta vs concrete)
- Points to README.md for project overview

**Used by**: All AI agents after entry point, human contributors

### todo.md
**Purpose**: Meta-project task tracking and completion history

**Contains**:
- Completed work (✓ COMPLETE sections)
- Pending work
- Resolved decisions (✓ RESOLVED sections)

**Used by**: Platform Lead role when maintaining meta-project

## Workflow System Definition

**Location**: `Workflow/` directory

This is the heart of the meta-project - the workflow system that concrete projects will use.

### Core System Docs

**Location**: `Workflow/` (root level)

| File | Purpose | Primary Content |
|------|---------|-----------------|
| **Workflow.md** | Complete workflow reference | Artifact ownership matrix, consumer relationships, living docs |
| **workflow-overview.md** | High-level visual overview | Mermaid diagrams, key principles, role layers |
| **LayoutAndState.md** | File organization for concrete projects | Directory structure, state transitions, branching strategy |
| **state-transitions.md** | Detailed state machine rules | Git commands, preconditions/postconditions, who moves what |
| **RoleCatalog.md** | Index of all roles | Role layers, interactions, when to use which |
| **Ontology.md** | Index of all artifact types | Artifact relationships, schema references |

**Dependencies**:
- All role files reference workflow-overview.md and state-transitions.md
- LayoutAndState.md references state-transitions.md
- RoleCatalog.md links to all role-*.md files
- Ontology.md links to all schema-*.md files

**Used by**:
- Role files (for integration sections)
- Concrete projects (as reference documentation)
- Platform Lead (when maintaining workflow)

### Role Definitions

**Location**: `Workflow/role-*.md` (22 files)

**Purpose**: Define what each role does, when to use it, and how it works

**Organization by Type**:

**Helper Roles** (4 files):
- role-vision-writing-helper.md
- role-scope-writing-helper.md
- role-roadmap-writing-helper.md
- role-spec-writing-helper.md

**Writer Roles** (6 files):
- role-vision-writer.md
- role-scope-writer.md
- role-roadmap-writer.md
- role-spec-writer.md
- role-skeleton-writer.md
- role-test-writer.md

**Reviewer Roles** (7 files):
- role-vision-reviewer.md
- role-scope-reviewer.md
- role-roadmap-reviewer.md
- role-spec-reviewer.md
- role-skeleton-reviewer.md
- role-test-reviewer.md
- role-implementation-reviewer.md

**Implementation Roles** (3 files):
- role-implementer.md
- role-bug-recorder.md
- role-platform-lead.md

**Structure**: All follow patterns/role-file-structure.md template

**Key Sections**:
- Purpose and collaboration pattern
- Process (role-specific, detailed)
- Examples (role-specific)
- Integration with workflow (brief, links to workflow-overview.md)
- Critical reminders (role-specific DO/DON'T)

**Used by**:
- AI agents assuming roles
- scripts/run-role.sh (loaded via --append-system-prompt)
- Humans understanding workflow

### Schema Specifications

**Location**: `Workflow/schema-*.md` (11 files)

**Purpose**: Define structure and requirements for each artifact type

| Schema | Defines | Typical Size |
|--------|---------|--------------|
| schema-vision.md | VISION.md format | Strategic planning doc |
| schema-scope.md | SCOPE.md format | Strategic planning doc |
| schema-roadmap.md | ROADMAP.md format | Strategic planning doc |
| schema-system-map.md | SYSTEM_MAP.md format | Living doc (~1,460 lines) |
| schema-guidelines.md | GUIDELINES.md format | Living doc (~1,625 lines) |
| schema-spec.md | Feature SPEC files | Per-feature doc |
| schema-interface-skeleton-code.md | Skeleton code structure | Code artifact (~1,173 lines) |
| schema-test-code.md | Test code structure | Code artifact (~1,050 lines) |
| schema-implementation-code.md | Implementation code | Code artifact (~1,029 lines) |
| schema-review.md | Review documents | Quality gate (~1,175 lines) |
| schema-review-request.md | Review request format | Review input (~1,324 lines) |
| schema-bug-report.md | Bug report format | Defect tracking |

**Total schema documentation**: ~7,500 lines of comprehensive guidance

**Used by**:
- Writer roles (when creating artifacts)
- Reviewer roles (when evaluating artifacts)
- Role files (referenced in process sections)

**Cross-references**: Each schema links to LayoutAndState.md for directory structure

### Patterns (Reusable Templates)

**Location**: `Workflow/patterns/` (2 files)

**Purpose**: Extract common boilerplate from role files to single source of truth

| Pattern File | Purpose | Lines | Used By |
|--------------|---------|-------|---------|
| helper-role-pattern.md | Common helper role structure | ~441 | 4 helper role files |
| role-file-structure.md | Standard role file template | ~426 | All 22 role files |

**Impact**: Eliminated ~650-700 lines of redundancy across role files

**Key Sections in Patterns**:
- Standard structures
- Integration templates
- Usage guidelines
- Before/after examples

**Used by**:
- Role files (via references)
- Developers creating new roles
- Platform Lead when maintaining consistency

### Scripts (Automation)

**Location**: `Workflow/scripts/` (4 files)

**Purpose**: Automate role launching and workflow state scanning

| Script | Purpose | Lines | Key Features |
|--------|---------|-------|--------------|
| run-role.sh | Launch any role with initialization | ~270 | Config-driven, multi-tool support, interactive mode |
| workflow-status.sh | Scan project and suggest next actions | ~390 | State detection, color output, prioritized suggestions |
| role-config.json | Role → tool/model mapping | Config | Maps roles to recommended tools |
| tool-config.json | Tool CLI arguments | Config | How to invoke each tool |

**Total automation**: ~660 lines

**Supported Tools**:
- Claude (--append-system-prompt)
- Codex (positional argument preserves TTY)
- Gemini (-i/--prompt-interactive)
- OpenCode (-p/--prompt)

**Usage**:
```bash
# Launch role interactively
./Workflow/scripts/run-role.sh -i scope-writer

# Check project status
./Workflow/scripts/workflow-status.sh

# Verbose status with suggestions
./Workflow/scripts/workflow-status.sh --verbose
```

**Documentation**: See [scripts/README.md](Workflow/scripts/README.md)

**Used by**: Developers orchestrating workflow manually

### Supporting Documents

**Location**: `Workflow/` (root level)

| File | Purpose | Size |
|------|---------|------|
| ConcreteProjectSetup.md | How to initialize a new concrete project | Setup guide |
| ContributingTemplate.md | Template for concrete project CONTRIBUTING.md | Template |
| WorkflowExample.md | End-to-end workflow walkthrough | Example scenario |
| FeedbackLoops.md | Strategic feedback (Checkpoint Review) | Process doc |
| RFC.md | Tactical feedback (Request for Change) | Process doc |
| feedback-loops-diagram.md | Visual feedback process diagrams | Mermaid diagrams |
| workflow-diagram.svg | Comprehensive visual workflow | SVG diagram (not actively maintained) |
| workflow-diagram.drawio | Source for workflow-diagram.svg | Draw.io source |

**Used by**:
- Concrete projects (ConcreteProjectSetup.md)
- Developers learning workflow (WorkflowExample.md)
- All roles when handling changes (FeedbackLoops.md, RFC.md)

## Component Dependencies

### Documentation Hierarchy

```
Entry Point (CLAUDE.md, etc.)
    ↓
CONTRIBUTING.md
    ↓
README.md
    ↓
Workflow/
    ├── workflow-overview.md ←─────┐
    ├── state-transitions.md ←─────┤
    │                              │
    ├── RoleCatalog.md             │
    │   ↓                          │
    ├── role-*.md ─────────────────┘ (reference workflow docs)
    │   ↓
    ├── patterns/
    │   ├── helper-role-pattern.md ← (referenced by helper roles)
    │   └── role-file-structure.md ← (referenced by all roles)
    │
    ├── Ontology.md
    │   ↓
    └── schema-*.md ───────────────→ LayoutAndState.md (directory structure)
```

### Automation Dependencies

```
scripts/run-role.sh
    ├── role-config.json    (which tool for which role)
    ├── tool-config.json    (how to invoke tool)
    └── role-*.md           (loaded into tool)

scripts/workflow-status.sh
    ├── LayoutAndState.md   (understands directory structure)
    └── state-transitions.md (understands state rules)
```

## Integration Points

### Meta-Project → Concrete Projects

**Copy Operations** (ConcreteProjectSetup.md):
- Entire `Workflow/` directory → concrete project (read-only reference)
- Entry points (CLAUDE.md, etc.) → concrete project root
- CONTRIBUTING.md → concrete project root

**Concrete projects create** (following schemas):
- VISION.md, SCOPE.md, ROADMAP.md
- SYSTEM_MAP.md, GUIDELINES.md (their own, not meta-project's)
- specs/, bugs/, tests/, src/ (following LayoutAndState.md)

### Scripts → Workflow System

**run-role.sh**:
- Reads: role-config.json, tool-config.json
- Loads: role-*.md files into AI tools
- Respects: Entry points (CLAUDE.md routes properly)

**workflow-status.sh**:
- Reads: specs/, bugs/, src/, tests/ directories
- Applies: state-transitions.md rules
- Suggests: Next role to run with exact command

### Role Files → Core Docs

All role files link to:
- **workflow-overview.md** - for "complete workflow context"
- **state-transitions.md** - for "state transition rules"
- **schema-*.md** - for artifact structure requirements
- **patterns/*.md** - for common structures (if applicable)

## Key Abstractions

### Role
**Definition**: A set of responsibilities, inputs, outputs, and process steps for one stage of workflow

**Types**: Helper, Writer, Reviewer, Implementer

**Interface**: Markdown file following patterns/role-file-structure.md

**Implementation**: 22 role files in Workflow/

**Used by**: AI agents (loaded by scripts/run-role.sh or manually)

### Schema
**Definition**: Structure and requirements specification for one artifact type

**Types**: Planning docs, living docs, per-feature docs, quality docs

**Interface**: Markdown file with structure, requirements, examples

**Implementation**: 11 schema files in Workflow/

**Used by**: Writer roles (creation), Reviewer roles (validation)

### Pattern
**Definition**: Reusable template extracted from common boilerplate

**Types**: Role structure, helper conversation flow

**Interface**: Markdown file with template and usage guidelines

**Implementation**: 2 pattern files in Workflow/patterns/

**Used by**: Role files (via references), Platform Lead (maintenance)

### State Transition
**Definition**: Rule for moving artifacts between directories/branches

**Interface**: Documented in state-transitions.md with preconditions/postconditions

**Implementation**: Git operations executed by designated roles

**Used by**: Skeleton Writer, Spec Reviewer, Implementation Reviewer (gatekeepers)

## Where to Find Things

| Need to... | Check... |
|------------|----------|
| Understand workflow at high level | README.md → Workflow/workflow-overview.md |
| See all available roles | Workflow/RoleCatalog.md |
| Learn what a specific role does | Workflow/role-[name].md |
| Understand artifact structure | Workflow/Ontology.md → Workflow/schema-[type].md |
| Set up a new concrete project | Workflow/ConcreteProjectSetup.md |
| See workflow in action | Workflow/WorkflowExample.md |
| Understand state transitions | Workflow/state-transitions.md |
| Learn file organization | Workflow/LayoutAndState.md |
| Handle spec changes | Workflow/RFC.md |
| Handle strategic replanning | Workflow/FeedbackLoops.md |
| Run a role with automation | Workflow/scripts/run-role.sh |
| Check project status | Workflow/scripts/workflow-status.sh |
| Understand role file structure | Workflow/patterns/role-file-structure.md |
| Understand helper roles | Workflow/patterns/helper-role-pattern.md |
| Contribute to meta-project | CONTRIBUTING.md |
| Track meta-project status | todo.md |
| Follow meta-project conventions | GUIDELINES.md |

## Living Documentation Updates

This meta-project follows its own advice about living documentation:

**SYSTEM_MAP.md** (this file):
- Updated when Workflow/ structure changes
- Updated when new patterns added
- Updated when scripts added/modified
- Updated when major refactoring occurs

**GUIDELINES.md**:
- Updated when conventions emerge
- Updated when anti-patterns discovered
- Updated when blessed utilities created

**Platform Lead role maintains both**, reviewing changes as meta-project evolves.

## Meta-Project vs Concrete Project

**Critical distinction**:

| Aspect | Meta-Project (this) | Concrete Project |
|--------|---------------------|------------------|
| Purpose | Defines workflow system | Uses workflow system |
| SYSTEM_MAP.md | This file (maps meta-project) | Maps concrete project architecture |
| GUIDELINES.md | Meta-project conventions | Concrete project coding patterns |
| Workflow/ | Created here | Copied from here (read-only) |
| Role files | Defined here | Referenced from here |
| Schemas | Specified here | Followed there |
| Entry points | Route to workflow docs | Route to workflow docs |

**In conversations**: Always clarify which level is being discussed to avoid confusion.
