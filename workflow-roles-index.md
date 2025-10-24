# Software Development Workflow Roles

This document provides an overview of all roles in the AI-augmented software development workflow. Each role has a detailed description in its own file.

## Complete Role Set

The workflow consists of **multiple role definitions** organized into planning phase, coding phase, and support.

### Planning Roles

Each planning phase has Writer, Reviewer, and Helper roles, plus an ontology document defining structure.

#### Vision Phase
1. **[Vision Writer](role-vision-writer.md)** - Creates VISION.md defining project purpose, users, problems, and 2-5 year success criteria
2. **[Vision Reviewer](role-vision-reviewer.md)** - Reviews vision for clarity, feasibility, and strategic soundness
3. **[Vision Writing Helper](role-vision-writing-helper.md)** - Guides users through articulating vision via Socratic conversation
4. **[VISION-ontology.md](VISION-ontology.md)** - Defines vision document structure and validation rules

#### Scope Phase
5. **[Scope Writer](role-scope-writer.md)** - Defines project boundaries (in/out/deferred), deliverables, constraints
6. **[Scope Reviewer](role-scope-reviewer.md)** - Reviews scope for completeness, clarity, and alignment with vision
7. **[Scope Writing Helper](role-scope-writing-helper.md)** - Guides users through defining concrete scope via conversation
8. **[SCOPE-ontology.md](SCOPE-ontology.md)** - Defines scope document structure and validation rules

#### Roadmap Phase
9. **[Roadmap Writer](role-roadmap-writer.md)** - Sequences features into phased delivery plan with dependencies
10. **[Roadmap Reviewer](role-roadmap-reviewer.md)** - Reviews roadmap for sequencing logic and scope alignment
11. **[Roadmap Writing Helper](role-roadmap-writing-helper.md)** - Guides users through feature sequencing via conversation
12. **[ROADMAP-ontology.md](ROADMAP-ontology.md)** - Defines roadmap document structure and validation rules

#### Specification Phase
13. **[Spec Writer](role-spec-writer.md)** - Transforms roadmap features into detailed behavioral specifications
14. **[Spec Reviewer](role-spec-reviewer.md)** - Reviews specs for completeness and testability
15. **[Spec Writing Helper](role-spec-writing-helper.md)** - Guides users through defining specifications via conversation
16. **[SPEC-ontology.md](SPEC-ontology.md)** - Defines specification document structure and validation rules

**Pattern:** Planning roles include procedural knowledge (how to write good X). Role + ontology = information equivalence with Claude skills.

### Coding Roles

Coding roles are workflow-focused, assuming LLMs know how to code/test/review.

#### Interface/Skeleton Phase
17. **[Skeleton Writer](role-skeleton-writer.md)** - Creates interface skeletons with complete type definitions but zero implementation
18. **[Skeleton Reviewer](role-skeleton-reviewer.md)** - Reviews skeletons for testability, completeness, and correctness

#### Testing Phase (TDD RED)
19. **[Test Writer](role-test-writer.md)** - Writes comprehensive test suites before implementation (TDD RED phase)
20. **[Test Reviewer](role-test-reviewer.md)** - Reviews tests for completeness and quality before implementation

#### Implementation Phase (TDD GREEN)
21. **[Implementer](role-implementer.md)** - Writes production code to make tests pass (TDD GREEN phase)
22. **[Implementation Reviewer](role-implementation-reviewer.md)** - Reviews implementation for quality, security, and spec compliance

**Pattern:** Coding roles focus on workflow responsibilities, not teaching how to code.

### Support/Meta Roles

23. **[Platform Lead](role-platform-lead.md)** - Maintains living documentation (SYSTEM_MAP.md, GUIDELINES.md)

## Role Characteristics

### By Collaboration Style

**Collaborative** (conversation produces document):
- Vision Writer, Scope Writer, Roadmap Writer, Spec Writer
- Human and agent collaborate through dialogue
- Helper roles facilitate the conversation

**Autonomous** (agent works alone from approved inputs):
- Skeleton Writer, Test Writer, Implementer
- Work from specifications and approved artifacts
- Minimal human interaction during execution

**Independent** (separate review of work):
- Vision Reviewer, Scope Reviewer, Roadmap Reviewer, Spec Reviewer
- Skeleton Reviewer, Test Reviewer, Implementation Reviewer
- Separation prevents blind spots and ensures quality

**Ongoing/On-Demand**:
- Platform Lead (continuous maintenance)

### By Role Function

**Writers** - Create artifacts (documents, code, tests)
**Reviewers** - Validate quality and completeness  
**Helpers** - Guide through Socratic conversation  
**Gatekeepers** - Control artifact state transitions:
- Spec Reviewer: `proposed/` â†’ `todo/`
- Skeleton Writer: `todo/` â†’ `doing/` (+ creates feature branch)
- Implementation Reviewer: `doing/` â†’ `done/`

## Complete Workflow Sequence

### Phase 1: Foundation (Pre-Workflow)
```
Vision Writer + Human â†’ VISION.md
  â†“
Vision Reviewer â†’ APPROVED
```

### Phase 2: Planning
```
Scope Writer + Human â†’ SCOPE.md
  â†“
Scope Reviewer â†’ APPROVED
  â†“
Roadmap Writer + Human â†’ ROADMAP.md
  â†“
Roadmap Reviewer â†’ APPROVED
```

### Phase 3: Specification (Per Feature)
```
Spec Writer + Human â†’ specs/proposed/<feature>.md
  â†“
Spec Reviewer â†’ APPROVED â†’ moves to specs/todo/
```

### Phase 4: Interface Definition
```
Skeleton Writer â†’ creates code interfaces
  â†“
Skeleton Reviewer â†’ APPROVED
  â†“
Skeleton Writer â†’ creates feature branch + moves spec to specs/doing/
```

### Phase 5: Test-Driven Development (TDD)
```
Test Writer â†’ writes failing tests (RED)
  â†“
Test Reviewer â†’ APPROVED
  â†“
Implementer â†’ makes tests pass (GREEN)
  â†“
Implementation Reviewer â†’ APPROVED â†’ moves spec to specs/done/
  â†“
Merge to main â†’ Feature complete!
  â†“
Platform Lead â†’ updates living docs
```

## Spec State Transitions

Specifications move through four states as work progresses:

```
specs/proposed/    [Spec Reviewer approves]
  â†“
specs/todo/       [Skeleton approved, branch created]
  â†“
specs/doing/      [Implementation complete, tests pass]
  â†“
specs/done/       [Merged to main]
```

**State ownership:**
- `proposed/` - Created by Spec Writer, lives on main
- `todo/` - Approved, waiting for work, lives on main
- `doing/` - Active development, lives on feature branch
- `done/` - Complete, merged back to main

## Key Workflow Principles

### 1. Artifact-Driven State
The repository files (specs, tests, code) are the source of truth, not conversation history or external tools.

### 2. Persistent Memory Through Living Docs
- **SYSTEM_MAP.md** - Architecture, components, module boundaries
- **GUIDELINES.md** - Coding conventions, blessed utilities, design patterns, architectural constraints, forbidden patterns
- **bug reports in bugs/fixed/** - Past bugs with sentinel tests to prevent regression

These prevent architecture amnesia as projects grow.

### 3. Role-Based Specialization
Each role has specific responsibilities and triggers. Different agents or models can fill different roles, enabling:
- Specialized expertise per role
- Concurrent work on different features
- Scalable team expansion

### 4. Formal, Independent Review
The creator of an artifact is never the reviewer. This separation:
- Prevents blind spots
- Catches errors before propagation
- Ensures quality standards
- Provides multiple perspectives

### 5. Immutable TDD Contract
Tests define the implementation contract and must not be modified to make them pass:
- Tests written first (RED)
- Implementation makes tests pass (GREEN)
- Refactoring improves code while keeping tests green
- If tests seem wrong, flag for test re-review

### 6. Human-as-Manager
Human acts as product manager and architect:
- Approves review gates
- Makes strategic decisions
- Provides product context
- Agents execute defined roles

### 7. Programmatic Anti-Regression
**bug reports in bugs/fixed/** + **Sentinel Tests** ensure bugs never repeat:
- Every bug gets a ledger entry
- Test Writer adds sentinel test
- Test prevents regression
- Pattern learned and documented

### 8. Process Enforcement
Workflow integrity maintained through:
- Git branch strategy
- Review gates with APPROVED/NEEDS-CHANGES
- Spec state transitions
- Test immutability
- CI checks and git hooks

## Branching Strategy

### Main Branch Contains
- Planning docs (VISION, SCOPE, ROADMAP)
- Living docs (SYSTEM_MAP.md, GUIDELINES.md)
- Review records (reviews/*)
- Specs in `proposed/` and `todo/` states
- Specs in `done/` state (after merge)

### Feature Branches Created When
- Skeleton Writer moves spec from `todo/` to `doing/`
- This marks transition from design to active development
- Branch naming: `feature/<feature-name>`

### Feature Branches Contain
- Spec in `doing/` state
- Skeleton code (interfaces)
- Test files (tests/*)
- Implementation code (src/*)

### Merge to Main When
- All tests passing (GREEN)
- Implementation reviewed and APPROVED
- Implementation Reviewer moves spec to `done/`
- No GUIDELINES.md violations
- Code quality standards met

## Review Conventions

### File Naming
All reviews use timestamped filenames with status:
```
YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md
```

**Status values:** APPROVED | NEEDS-CHANGES

**Examples:**
- `2025-10-23T14-30-47-user-registration-APPROVED.md`
- `2025-10-23T15-22-13-payment-gateway-NEEDS-CHANGES.md`

Use seconds precision to avoid collisions.

### Directory Structure
```
reviews/
â”œâ”€â”€ planning/           # Vision, Scope, Roadmap reviews
â”œâ”€â”€ specs/             # Spec Reviewer outputs
â”œâ”€â”€ skeletons/         # Skeleton Reviewer outputs
â”œâ”€â”€ tests/             # Test Reviewer outputs
â””â”€â”€ implementations/   # Implementation Reviewer outputs
```

### Status Meanings

**APPROVED:**
- Work ready for next stage
- Gatekeeper (if applicable) moves artifacts
- No further action required
- Progress continues

**NEEDS-CHANGES:**
- Work must be revised
- Specific action items in review
- Re-review required after changes
- Progress blocked until approved

## Test Conventions

### Single Suite Per Feature
Prefer one coherent test file per feature:
- `tests/unit/test_<feature>.py` - Unit tests
- `tests/integration/test_<feature>_integration.py` - Integration tests

### Multiple Contributor Attribution
When multiple people edit same test file, use inline comments:
```python
# === Tests by Claude Sonnet 4.5 (2025-10-23) ===

def test_feature_happy_path():
    """Test typical usage."""
    assert calculate(10) == 20

def test_feature_edge_case():
    """Test boundary condition."""
    assert calculate(0) == 0

# === Tests by Human Developer (2025-10-24) ===

def test_feature_error_handling():
    """Test exception case."""
    with pytest.raises(ValueError):
        calculate(-1)
```

### All-In Test Reviews
Test Reviewer reviews the **complete suite** as a single unit:
- Not per contributor
- Approval applies to entire suite
- Ensures comprehensive coverage
- Validates overall quality

### Test Immutability Principle
**Implementers MUST NOT modify tests to make them pass.**

If a test seems wrong:
1. **Stop** implementation immediately
2. **Document** the concern with evidence
3. **Request** test re-review
4. **Wait** for clarification
5. **Resume** after tests are fixed

Tests are the contract. Changing tests invalidates the contract.

## Living Documentation

### SYSTEM_MAP.md
**Purpose:** Architecture overview and module boundaries

**Contains:**
- High-level architecture diagram
- Module organization
- Component responsibilities
- Integration points
- File organization patterns

**Updated by:** Platform Lead after features merge

### GUIDELINES.md
**Purpose:** Coding conventions and blessed utilities

**Contains:**
- Naming conventions
- Code organization patterns
- Standard utilities to use
- Import patterns
- Docstring styles
- Forbidden imports
- Layer boundaries
- Dependency rules
- Security requirements
- Performance constraints

**Updated by:** Platform Lead when rules established

### bug reports in bugs/fixed/
**Purpose:** Historical bug database

**Structure:**
```yaml
bugs:
  - id: BUG-042
    date: "2025-10-15"
    description: Empty string passed email validation
    root_cause: Missing empty string check
    fix: Added validation for empty input
    sentinel_test: test_bug_42_empty_email_validation
    lessons_learned: Always validate empty/null inputs first
```

**Updated by:** Platform Lead when bugs fixed

## Helper Roles Explained

Helper roles facilitate planning phases through Socratic conversation:

**Pattern:** Ask questions â†’ Explore thinking â†’ Guide decisions â†’ Call writer role

**Vision Writing Helper:**
- Helps articulate why project exists
- Explores user problems and value
- Guides defining success criteria
- Calls Vision Writer when ready

**Scope Writing Helper:**
- Helps translate vision to boundaries
- Explores what's in/out/deferred
- Guides defining deliverables
- Calls Scope Writer when ready

**Roadmap Writing Helper:**
- Helps sequence features
- Explores dependencies and risks
- Guides phasing decisions
- Calls Roadmap Writer when ready

**Spec Writing Helper:**
- Helps define acceptance criteria
- Explores edge cases and errors
- Guides interface design
- Calls Spec Writer when ready

Helpers are optional but useful for:
- First-time users
- Complex decisions
- Unclear requirements
- Exploratory thinking

## Quick Reference

**"Where do I start?"**  
â†’ Create VISION.md using Vision Writer (or Vision Writing Helper)

**"How do I define what's in scope?"**  
â†’ Use Scope Writer (or Scope Writing Helper) after vision complete

**"How do I plan feature order?"**  
â†’ Use Roadmap Writer (or Roadmap Writing Helper) after scope complete

**"Where do I create a new spec?"**  
â†’ `specs/proposed/<feature>.md` using Spec Writer

**"Who moves specs between states?"**  
â†’ Spec Reviewer: `proposed/` â†’ `todo/`  
â†’ Skeleton Writer: `todo/` â†’ `doing/` (+ creates branch)  
â†’ Implementation Reviewer: `doing/` â†’ `done/`

**"When do I create a feature branch?"**  
â†’ Skeleton Writer creates it after skeleton approval

**"Can I change a test to make it pass?"**  
â†’ **NO.** Request test re-review instead.

**"What if multiple people write tests?"**  
â†’ Use inline attribution comments in single file

**"How do I name review files?"**  
â†’ `YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md`

**"What are the living docs?"**  
â†’ SYSTEM_MAP.md, GUIDELINES.md

**"Who updates living docs?"**  
â†’ Platform Lead (continuously)

## Workflow Philosophy

This workflow is designed to:

1. **Prevent architecture amnesia** as projects grow
2. **Maintain consistency** through documented patterns
3. **Prevent regression** through comprehensive testing and sentinel tests
4. **Support solo developers** working with AI agents
5. **Enable team collaboration** with clear role boundaries
6. **Enforce quality** through formal review gates
7. **Maintain clarity** through artifact-driven state
8. **Scale naturally** from solo to team projects

### Design Inspirations

- **TDD principles** - Tests first, implementation second
- **Anthropic Skills framework** - Procedural knowledge in focused documents
- **Living documentation** - Docs that evolve with code
- **Architecture Decision Records** - Persistent memory of decisions
- **Formal methods** - Contracts and specifications
- **Separation of concerns** - Writers â‰  Reviewers

### Workflow Adaptability

The workflow is designed to be adopted incrementally:

**Minimal adoption:**
- Spec Writer â†’ Tests â†’ Implementation
- Skip helpers if requirements clear
- Minimal reviews for low-risk features

**Full adoption:**
- Complete planning phase (Vision â†’ Scope â†’ Roadmap)
- All review gates
- Helper roles for complex decisions
- Living docs maintained continuously

**Team adoption:**
- Distribute roles across team members
- Different agents/models for different roles
- Concurrent feature development
- Formal handoffs between roles

Start with the roles that match your current need. Add more as the project grows.

## File Exports

All role definitions and ontologies are ready to export:

**Planning Roles:**
- Vision: role-vision-{writer,reviewer,writing-helper}.md + VISION-ontology.md
- Scope: role-scope-{writer,reviewer,writing-helper}.md + SCOPE-ontology.md
- Roadmap: role-roadmap-{writer,reviewer,writing-helper}.md + ROADMAP-ontology.md
- Spec: role-spec-{writer,reviewer,writing-helper}.md + SPEC-ontology.md

**Coding Roles:**
- Skeleton: role-skeleton-{writer,reviewer}.md
- Test: role-test-{writer,reviewer}.md
- Implementation: role-{implementer,implementation-reviewer}.md

**Support Roles:**
- role-platform-lead.md
