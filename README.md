# AI-Augmented Software Development Workflow

## Managing this Project

This is a **meta-project**.

The associated **concrete** software development projects will use a **multi-model** workflow system for solo developers working with AI agents, designed to prevent architecture amnesia and maintain quality through formal process gates.

This **meta-project** designs and documents the workflow itself, not actual software that will be built in the concrete projects.
The artifacts here (role definitions, workflow diagrams, ...) mostly describe **how to run concrete development projects**.
We may develop _some_ software here, such as evaluations of different model's abilities in different roles.

Like the associated concrete projects, this meta-project is a multi-model project.
Each model or model-interface combination will or should have read its own, model-specific instruction file before reading this file, [README.md](README.md).

If you are a model reading this that is participating in the project and you haven't already read an entry point file specific to you and your current interface, please report that.

This is **very important**: Because of the similarities between this meta-project and the associated concrete projects, all participants must take great care in word and phrase choice to properly distinguish the levels.

**For a visual overview of the workflow**, see [workflow-diagram.md](workflow-diagram.md) which contains mermaid diagrams showing feature flow, branching strategy, state machines, and role interactions.

## The Content of this Project

### Temporary

This had formerly been managed in the Claude chat application using the Claude Projects feature.
Currently much useful information is in [former-claude-project-instructions.md](former-claude-project-instructions.md).
But keep in mind we are migrating away from that and it may not all be relevant.

### Multi-Model Architecture

Different AI models excel at different tasks. The workflow we are developing maps roles to models based on their strengths:

- **Collaborative roles** (planning, specs): Models good at reasoning and dialogue
- **Implementation roles**: Models strong at code generation
- **Review roles**: Models excellent at finding bugs and edge cases
- **Architecture roles**: Models with large context windows
- ...

### Core Documentation

#### Workflow Overview

- **[workflow-roles-index.md](workflow-roles-index.md)** - Complete role catalog, principles, and sequences
- **[workflow-diagram.md](workflow-diagram.md)** - Visual flow diagrams and state machines
- **[workflow-artifacts.md](workflow-artifacts.md)** - Artifact types, locations, and lifecycles

#### Role Definitions

Each role has a detailed definition file:

**Strategic/Planning Layer:**
- [role-vision-writer.md](role-vision-writer.md) - Creates foundational VISION.md
- [role-scope-writer.md](role-scope-writer.md) - Defines project boundaries
- [role-roadmap-planner.md](role-roadmap-planner.md) - Sequences features
- [role-planning-reviewer.md](role-planning-reviewer.md) - Reviews scope and roadmap

**Design/Contract Layer:**
- [role-spec-writer.md](role-spec-writer.md) - Writes feature specifications
- [role-spec-reviewer.md](role-spec-reviewer.md) - Reviews specs (gates proposed→todo)
- [role-skeleton-writer.md](role-skeleton-writer.md) - Creates code skeletons
- [role-skeleton-reviewer.md](role-skeleton-reviewer.md) - Reviews skeleton interfaces

**Test Layer:**
- [role-test-writer.md](role-test-writer.md) - Writes TDD test suites (red first)
- [role-test-reviewer.md](role-test-reviewer.md) - Reviews test coverage

**Implementation Layer:**
- [role-implementer.md](role-implementer.md) - Implements features (makes tests green)
- [role-implementation-reviewer.md](role-implementation-reviewer.md) - Reviews code (gates doing→done)

**Support/Meta Roles:**
- [role-platform-lead.md](role-platform-lead.md) - Maintains living documentation
- [role-implementation-advisor.md](role-implementation-advisor.md) - Provides debugging help

## Workflow Principles

These are based on pain points the user experienced in setups preceeding this one.
But they are not our exclusive concerns.
The workflow must be good overall for software development and this implies many implicit principals and requirements.
We are just highlighting the principles below.

1. **Prevent Architecture Amnesia**: Living docs (SYSTEM_MAP, PATTERNS, RULES, BUG_LEDGER) maintain memory
2. **Artifact-Driven State**: Repository files are truth, not conversation history
3. **Role-Based Specialization**: Each role has specific responsibilities
4. **Formal Review Gates**: Creator ≠ reviewer (adversarial reviews)
5. **Test-Driven Development**: Specs → Tests (red) → Implementation (green)
6. **Multi-Model Optimization**: Use best model for each role
7. **Human-as-Manager**: Human approves gates, agents execute

### Typical Feature Flow

```
1. Scope Writer + Roadmap Planner → Planning docs
2. Planning Reviewer → Approves

3. Spec Writer → specs/proposed/feature.md
4. Spec Reviewer → Approves, moves to specs/todo/

5. Skeleton Writer → Code stubs
6. Skeleton Reviewer → Approves
7. Skeleton Writer → Creates feature branch, moves spec to specs/doing/

8. Test Writer → Comprehensive test suite (red)
9. Test Reviewer → Approves tests

10. Implementer → Makes tests pass (green)
11. Implementation Reviewer → Approves, moves spec to specs/done/, merges

12. Platform Lead → Updates living docs
```

### Artifact Structure (Concrete Projects)

When using this workflow in actual projects:

```
project/
├── VISION.md              # Why this project exists
├── SCOPE.md               # What's in/out
├── ROADMAP.md             # Feature sequence
├── SYSTEM_MAP.md          # Architecture reference
├── PATTERNS.md            # Coding conventions
├── RULES.md               # Architectural constraints
├── BUG_LEDGER.yml         # Bug history and prevention
├── specs/
│   ├── proposed/          # Awaiting review
│   ├── todo/              # Approved, not started
│   ├── doing/             # In progress (on feature branch)
│   └── done/              # Completed (merged to main)
├── reviews/
│   ├── planning/
│   ├── specs/
│   ├── skeletons/
│   ├── tests/
│   └── implementations/
├── tests/
│   ├── unit/
│   └── integration/
└── src/                   # Implementation code
```

### Branching Strategy

- **Main branch**: Planning docs, living docs, specs in `proposed/` and `todo/` states
- **Feature branches**: Created when spec moves to `doing/`, contains tests and implementation
- **Merge trigger**: Implementation reviewer approves, spec moves to `done/`

### Getting Started

In concrete projects, models would typically do the following.

1. **Choose your role**: See [workflow-roles-index.md](workflow-roles-index.md) for role descriptions
2. **Read role definition**: Find the relevant `role-*.md` file
3. **Follow role process**: Each role has clear inputs, process, and outputs
4. **Use appropriate model**: Check model-to-role mapping for optimal results
5. **Maintain artifacts**: Keep living docs updated to prevent amnesia

### Model-to-Role Mapping

*(To be developed based on benchmarking and experience)*

Initial, tentative, hypothesis based on 2025 research:
- **GPT-5**: Planning, scope, roadmap writing
- **Claude Sonnet 4.5**: Code review, specs, test review, implementation review
- **GPT-5-Codex**: Skeleton writing, implementation
- **Gemini 2.5 Pro**: Skeleton review (architectural analysis)
- **Grok 4**: Test review (algorithmic depth)

This mapping will evolve as the workflow matures.

### Design Inspiration

Current role definitions took inspiration from principles in Anthropic's Skills framework, adapted for multi-model workflow documentation.
It is unclear yet if this is helpful for models other than Claude.
For models other than Claude, you can look at them in the [.claude/skills](./claude/skille) subdirectory.

### Questions?

- For workflow design principles: See [workflow-roles-index.md](workflow-roles-index.md)
- For specific role details: See individual `role-*.md` files
- For artifact formats: See [workflow-artifacts.md](workflow-artifacts.md)
- For visual flow: See [workflow-diagram.md](workflow-diagram.md)
