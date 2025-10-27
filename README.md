# AI-Augmented Software Development Workflow

A **meta-project** that defines an artifact-driven, multi-model workflow system for software development with AI.

---

## Quick Navigation

**New to this project?** → Start with [Why This Exists](#why-this-exists) below, then see [Getting Started](#getting-started)

**Using this workflow in a project?** → See [For Practitioners](#for-practitioners)

**Contributing to the meta-project?** → See [For Contributors](#for-contributors)

**Looking for specific info?** → See [Documentation Map](#documentation-map)

---

## Why This Exists

Recent experiments (circa October 2025) with Claude Code, OpenAI Codex, and similar tools followed a pattern: excellent progress when starting, but gradually degrading as projects grow.

### Key Pain Points

**Architecture Amnesia**: Models "forget" big things like utility methods or layers already built. This leads to reimplementing functionality, sometimes recreating the same bugs. Happens over days.

**Detail Loss**: Models forget specifics during context compaction. They remember the general idea ("we're writing an eval") but lose methodology details, producing basic sanity checks instead of comprehensive evaluations.

**Code Quality**: The usual imperfect implementations don't magically disappear with AI assistance.

### The Solution

**Artifact-driven workflow** addresses forgetting through persistent specifications that extend beyond implementation to vision, scope, roadmaps, specs, and contracts.

**Multi-model/multi-role** leverages different models' strengths - e.g., Claude for writing, GPT-5 for reviews led to significant quality improvements.

**Structured process** appropriate for AI agents (not burdensome for humans) because agents switch roles instantly by loading new prompts and processes can be automated.

**Conversational crystallization** preserves the value of exploratory conversations through "helper" roles that guide thinking before creating formal artifacts.

---

## What This Is

**Meta-project**: Designs and documents the workflow system itself
**Concrete projects**: Use this workflow to build actual software

This meta-project contains:
- **22 role definitions** (writers, reviewers, helpers, implementers)
- **11 comprehensive schemas** (~7,500 lines) for all artifact types
- **Automation scripts** for role launching and project status
- **Pattern templates** for consistency and maintainability
- **Complete workflow** from vision to implementation with review gates

---

## Getting Started

### For New Users (Learning the Workflow)

**1. Understand the big picture:**
   - [Workflow Overview](Workflow/workflow-overview.md) - Visual diagrams and key principles
   - [Workflow Example](Workflow/WorkflowExample.md) - Complete scenario walkthrough

**2. Explore the system:**
   - [Role Catalog](Workflow/RoleCatalog.md) - All available roles and when to use them
   - [Ontology](Workflow/Ontology.md) - All artifact types and how they relate
   - [State Transitions](Workflow/state-transitions.md) - How artifacts move through workflow

**3. See how files are organized:**
   - [Layout and State](Workflow/LayoutAndState.md) - Directory structure and state tracking

---

### For Practitioners (Using the Workflow)

**Setting up a new project:**
1. Follow [Concrete Project Setup](Workflow/ConcreteProjectSetup.md)
2. Copy `Workflow/` to your project (read-only reference)
3. Copy entry points (CLAUDE.md, AGENTS.md, etc.)

**Running the workflow:**
```bash
# Check project status
./Workflow/scripts/workflow-status.sh

# Launch a role interactively
./Workflow/scripts/run-role.sh -i vision-writing-helper

# Review an artifact
./Workflow/scripts/run-role.sh spec-reviewer specs/proposed/feature.md
```

See [Workflow/scripts/README.md](Workflow/scripts/README.md) for complete script documentation.

**Creating artifacts:**
- Each artifact type has a comprehensive schema in `Workflow/schema-*.md`
- Use helper roles for guided exploration, writer roles for direct creation
- All artifacts pass through review gates before proceeding

---

### For Contributors (Maintaining the Meta-Project)

**Meta-project documentation:**
- [SYSTEM_MAP.md](SYSTEM_MAP.md) - Architecture of this meta-project
- [GUIDELINES.md](GUIDELINES.md) - Conventions for meta-project maintenance
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contributor guidance

**Key conventions:**
- All role files follow [patterns/role-file-structure.md](Workflow/patterns/role-file-structure.md)
- Helper roles follow [patterns/helper-role-pattern.md](Workflow/patterns/helper-role-pattern.md)
- Cross-reference rather than duplicate (see GUIDELINES.md)
- Update SYSTEM_MAP.md when structure changes

**Recent optimizations:**
- ~650-700 lines of redundancy eliminated through pattern extraction
- Consistent role structure across all 22 roles
- Clear documentation hierarchy with bidirectional links

---

## Documentation Map

### Core System Documents

| Document | Purpose | Audience |
|----------|---------|----------|
| [Workflow Overview](Workflow/workflow-overview.md) | High-level visual overview with diagrams | Everyone (start here) |
| [Workflow.md](Workflow/Workflow.md) | Complete workflow reference | Detailed reference |
| [State Transitions](Workflow/state-transitions.md) | State machine rules and git commands | Implementation |
| [Layout and State](Workflow/LayoutAndState.md) | Directory structure and state tracking | Setup and implementation |

### Catalogs and Indexes

| Document | Purpose | Links To |
|----------|---------|----------|
| [Role Catalog](Workflow/RoleCatalog.md) | Index of all 22 roles | All role-*.md files |
| [Ontology](Workflow/Ontology.md) | Index of all artifact types | All schema-*.md files |

### Role Definitions (22 files)

**Location**: `Workflow/role-*.md`

- **4 Helpers**: Guide thinking through conversations (vision, scope, roadmap, spec)
- **6 Writers**: Create artifacts (vision, scope, roadmap, spec, skeleton, test)
- **7 Reviewers**: Validate artifacts (vision, scope, roadmap, spec, skeleton, test, implementation)
- **3 Implementation**: Execute work (implementer, platform-lead, bug-recorder)

See [Role Catalog](Workflow/RoleCatalog.md) for complete list and usage guide.

### Schemas (11 files)

**Location**: `Workflow/schema-*.md`

Comprehensive structure definitions (~1,000-1,600 lines each):
- Strategic planning: vision, scope, roadmap
- Living docs: system-map, guidelines
- Per-feature: spec, skeleton, tests, implementation
- Quality: reviews, bug-reports

See [Ontology](Workflow/Ontology.md) for complete list.

### Patterns (2 files)

**Location**: `Workflow/patterns/`

- [role-file-structure.md](Workflow/patterns/role-file-structure.md) - Standard role template
- [helper-role-pattern.md](Workflow/patterns/helper-role-pattern.md) - Helper role structure

### Scripts (Automation)

**Location**: `Workflow/scripts/`

- **run-role.sh** - Launch any role with proper initialization (~270 lines)
- **workflow-status.sh** - Scan project and suggest actions (~390 lines)
- **role-config.json** - Role → tool/model mappings
- **tool-config.json** - Tool CLI configurations

See [scripts/README.md](Workflow/scripts/README.md) for complete documentation.

### Supporting Documents

| Document | Purpose |
|----------|---------|
| [Concrete Project Setup](Workflow/ConcreteProjectSetup.md) | How to initialize a new project |
| [Contributing Template](Workflow/ContributingTemplate.md) | Template for concrete project CONTRIBUTING.md |
| [Workflow Example](Workflow/WorkflowExample.md) | End-to-end walkthrough |
| [Feedback Loops](Workflow/FeedbackLoops.md) | Strategic feedback (Checkpoint Review) |
| [RFC](Workflow/RFC.md) | Tactical feedback (Request for Change) |

### Meta-Project Documentation

| Document | Purpose |
|----------|---------|
| [SYSTEM_MAP.md](SYSTEM_MAP.md) | Architecture of this meta-project |
| [GUIDELINES.md](GUIDELINES.md) | Meta-project conventions |
| [todo.md](todo.md) | Task tracking and completion history |

---

## Key Features

### Cascading Refinement
Vision → Scope → Roadmap → Specs → Skeleton → Tests → Implementation

Each stage builds on previous stages with clear dependencies.

### Review Gates
Every artifact passes through a reviewer before proceeding. Gatekeepers control state transitions.

### Test-Driven Development
Strict TDD cycle: Skeleton (interfaces) → Tests (RED) → Implementation (GREEN)

### Living Documentation
SYSTEM_MAP.md and GUIDELINES.md evolve continuously, updated via feedback loops (RFC, Checkpoint Review).

### Multi-Model Orchestration
Different models for different roles based on observed strengths:
- Claude: Writing, exploration, planning
- GPT-5: Code reviews, analysis, implementation

### Automation
Scripts handle role launching, state scanning, and suggestion generation - reducing manual orchestration burden.

---

## Project Status

**Core Workflow**: ✅ Complete
- 22 role definitions
- 11 comprehensive schemas
- State machines and transitions
- Review gates and gatekeepers

**Documentation**: ✅ Comprehensive
- ~7,500 lines of schema documentation
- Pattern templates for consistency
- Complete examples and anti-patterns
- Meta-project documentation (SYSTEM_MAP, GUIDELINES)

**Automation**: ✅ Functional
- Role launching with multi-tool support
- Project status scanning
- Config-driven tool selection

**Optimization**: ✅ Recent improvements
- ~650-700 lines redundancy eliminated
- Pattern extraction (2 pattern files)
- Clear documentation hierarchy
- Cross-reference strategy

**Next Steps**: See [todo.md](todo.md) for current priorities

---

## Critical Distinction: Meta vs Concrete

| Aspect | Meta-Project (this) | Concrete Project |
|--------|---------------------|------------------|
| Purpose | Defines workflow system | Uses workflow system |
| SYSTEM_MAP.md | Maps meta-project | Maps concrete project |
| GUIDELINES.md | Meta-project conventions | Concrete project patterns |
| Workflow/ | Created here | Copied from here (read-only) |
| Role files | Defined here | Referenced from here |

Always clarify which level you're discussing to avoid confusion.

---

## Entry Points

Different AI tools start at different entry point files:

- **Claude**: [CLAUDE.md](CLAUDE.md)
- **Codex/Agents**: [AGENTS.md](AGENTS.md)
- **Gemini**: [GEMINI.md](GEMINI.md)
- **OpenCode**: [OPENCODE.md](OPENCODE.md)

All converge at [CONTRIBUTING.md](CONTRIBUTING.md) → this README → `Workflow/`

---

## License

[TBD - Specify license]

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for meta-project contribution guidelines.

For concrete project contributions, each project will have its own CONTRIBUTING.md following the [template](Workflow/ContributingTemplate.md).
