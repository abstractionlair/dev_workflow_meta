# Software Development Workflow Roles

This document provides an overview of all roles in the AI-augmented software development workflow. Each role has a detailed description in its own file.

For visual representation of these roles in action, see **[workflow-diagram.md](workflow-diagram.md)**.

## Role Index

### Strategic/Planning Layer

1. **[Scope Writer](role-scope-writer.md)**
   - Defines project boundaries (what's in/out)
   - Creates SCOPE.md document
   - Collaborative role with human

2. **[Roadmap Planner](role-roadmap-planner.md)**
   - Sequences features and phases
   - Creates ROADMAP.md document
   - Collaborative role with human

3. **[Planning Reviewer](role-planning-reviewer.md)**
   - Reviews scope and roadmap documents
   - Independent review role
   - Checks clarity, completeness, consistency

### Design/Contract Layer

4. **[Specification Writer](role-spec-writer.md)**
   - Writes detailed feature specifications
   - Creates specs in `specs/proposed/`
   - Collaborative role with human
   - Concrete about behavior, flexible about implementation

5. **[Specification Reviewer](role-spec-reviewer.md)**
   - Reviews specification documents
   - Independent review role
   - Verifies completeness and clarity
   - **Gatekeeper**: Moves approved specs `proposed/` -> `todo/`

6. **[Skeleton Interface Writer](role-skeleton-writer.md)**
   - Creates code files with signatures, no implementation
   - Autonomous role following spec
   - Reveals practical issues (imports, linting)
   - After approval: creates feature branch and moves spec to `doing/`

7. **[Skeleton Interface Reviewer](role-skeleton-reviewer.md)**
   - Reviews skeleton code against spec
   - Independent review role
   - Verifies spec-to-code accuracy

### Test Layer

8. **[Test Writer](role-test-writer.md)**
   - Writes comprehensive test suites (TDD red-first)
   - Autonomous role following spec and skeleton
   - Creates unit, integration, and sentinel tests
   - Single file per feature with inline attribution

9. **[Test Reviewer](role-test-reviewer.md)**
   - Reviews test coverage and quality (all-in)
   - Independent review role
   - Verifies all spec requirements tested

### Implementation Layer

10. **[Feature Implementer](role-implementer.md)**
    - Writes production code to make tests pass
    - Autonomous role following tests
    - MUST NOT modify tests
    - Follows patterns and architectural rules

11. **[Implementation Reviewer](role-implementation-reviewer.md)**
    - Reviews production code
    - Independent review role
    - Checks quality, architecture compliance, test integrity
    - **Gatekeeper**: Moves approved specs `doing/` -> `done/`

### Support/Meta Roles

12. **[Platform Lead](role-platform-lead.md)**
    - Maintains architectural documentation
    - Updates SYSTEM_MAP.md, PATTERNS.md, RULES.md, BUG_LEDGER.yml
    - Ongoing role, triggered by events
    - Prevents architecture amnesia

13. **[Implementation Advisor](role-implementation-advisor.md)**
    - Provides ad-hoc debugging help
    - On-demand during active development
    - Not formal review, just unsticking progress

## Role Characteristics

### Collaborative vs. Autonomous vs. Independent

**Collaborative** (conversation produces document):
- Scope Writer
- Roadmap Planner
- Specification Writer

**Autonomous** (agent works alone from approved inputs):
- Skeleton Interface Writer
- Test Writer
- Feature Implementer

**Independent** (separate review of work):
- Planning Reviewer
- Specification Reviewer (NEW - gates proposed -> todo)
- Skeleton Interface Reviewer  
- Test Reviewer
- Implementation Reviewer (gates doing -> done)

**Ongoing/On-Demand**:
- Platform Lead (continuous maintenance)
- Implementation Advisor (called when stuck)

## Role Sequence (Operational)

Typical flow for a single feature:

```
1. Vision Writer -> VISION.md (foundation, pre-workflow)

2. Scope Writer + Human -> SCOPE.md
3. Roadmap Planner + Human -> ROADMAP.md
4. Planning Reviewer -> approves scope + roadmap

5. Specification Writer + Human -> specs/proposed/<feature>.md
6. Specification Reviewer -> approves, moves proposed -> todo

7. Skeleton Interface Writer -> creates code stubs
8. Skeleton Interface Reviewer -> approves skeleton

9. Feature Implementer -> moves todo -> doing (starts implementation)

10. Test Writer -> writes failing tests (red)
11. Test Reviewer -> approves tests (all-in review)

12. Feature Implementer -> makes tests pass (green)
    (Implementation Advisor available if stuck)
13. Implementation Reviewer -> approves, moves doing -> done

14. Platform Lead -> updates docs (SYSTEM_MAP, PATTERNS, etc.)

Feature complete! Merge to main.
```

### Spec State Transitions

```
specs/proposed/ -> [Spec Reviewer approves] -> specs/todo/
specs/todo/ -> [Implementer starts work] -> specs/doing/
specs/doing/ -> [Implementation Reviewer approves] -> specs/done/
```

**Gatekeeper Responsibilities:**
- **Spec Reviewer**: Moves `proposed/` -> `todo/`
- **Implementer**: Moves `todo/` -> `doing/` (not a gate, just marking work start)
- **Implementation Reviewer**: Moves `doing/` -> `done/`

## Key Principles

### 1. Artifact-Driven State
The repository files (specs, tests, code) are the source of truth, not conversation history.

### 2. Persistent, Enforceable Memory  
SYSTEM_MAP.md, PATTERNS.md, RULES.md, and BUG_LEDGER.yml prevent architecture amnesia.

### 3. Role-Based Specialization
Each role has specific responsibilities and triggers. Different agents/models can fill different roles.

### 4. Formal, Adversarial Review
The creator of an artifact is not the reviewer. Separation prevents blind spots.

### 5. Immutable TDD
Tests define the contract. Implementation must satisfy tests without modifying them.

### 6. Human-as-Manager
Human acts as PM/architect, approving gates and making decisions. Agents execute.

### 7. Programmatic Anti-Regression
BUG_LEDGER.yml and sentinel tests ensure bugs never repeat.

### 8. Process Enforcement
CI checks, git hooks, and review gates enforce the workflow.

## Branching Strategy

**Main branch holds:**
- Planning docs (VISION, SCOPE, ROADMAP)
- Living docs (SYSTEM_MAP, PATTERNS, RULES, BUG_LEDGER)
- Review records (reviews/*)
- Specs in `proposed/` and `todo/` states

**Feature branches created when:**
- Skeleton Writer moves spec from `todo/` to `doing/` (after skeleton approval)
- This marks the start of actual code development

**Feature branches hold:**
- Specs in `doing/` state
- Test files (tests/*)
- Implementation code (src/*)

**Merge to main when:**
- Implementation reviewed and approved
- Spec moved to `done/`
- All tests passing

## Review Conventions

### Review File Naming
All reviews use timestamped filenames with status:
```
YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md
```

Where STATUS is one of {APPROVED, NEEDS-CHANGES}

Use seconds precision to avoid collisions (e.g., `2025-01-23T14-30-47-weather-cache-APPROVED.md`)

### Review Directory Structure
```
reviews/
|- planning/           # Planning Reviewer outputs
|- specs/             # Spec Reviewer outputs
|- skeletons/         # Skeleton Reviewer outputs
|- tests/             # Test Reviewer outputs
|- implementations/   # Implementation Reviewer outputs
```


### Review Status Meanings

**APPROVED:**
- Work is ready to proceed to next stage
- Gatekeeper (if applicable) moves artifacts
- No further action needed

**NEEDS-CHANGES:**
- Work must be revised before proceeding
- Specific action items provided in review
- Re-review required after changes

## Test Conventions

### Single Suite Per Feature
Prefer one coherent test file: `tests/unit/test_<feature>.py`

### Attribution in Tests
When multiple contributors edit same test file, use inline section comments:
```python
# === Tests by Claude Sonnet 4.5 (2025-01-23) ===

def test_feature_happy_path():
    ...

# === Tests by Human Developer (2025-01-24) ===

def test_feature_edge_case():
    ...
```

### All-In Test Reviews
Test Reviewer reviews the **complete suite** as a single unit, not per contributor. Approval applies to entire suite.

### Test Immutability
Implementers MUST NOT modify tests to make them pass. If test seems wrong:
1. Stop implementation
2. Document the concern
3. Request test re-review
4. Wait for clarification
5. Resume after tests are fixed

## Quick Reference

**"Where do I create a new spec?"** -> `specs/proposed/<feature>.md`

**"Who moves specs to todo?"** -> Spec Reviewer (after APPROVED review)

**"When do I create a feature branch?"** -> When moving spec from `todo/` to `doing/`

**"Who moves specs to done?"** -> Implementation Reviewer (after APPROVED review)

**"Can I change a test to make it pass?"** -> NO. Request test re-review instead.

**"What if multiple people write tests?"** -> Use inline attribution comments in single file.

**"How do I name review files?"** -> `YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md`

## Workflow Philosophy

This workflow is designed to:
1. Prevent architecture amnesia as projects grow
2. Maintain consistency through documented patterns
3. Prevent regression through comprehensive testing
4. Support solo or small team development
5. Work with AI agents as team members
6. Enforce quality through formal review gates
7. Maintain clear artifact-driven state

Start with the role descriptions that match your current need. The workflow is designed to be adopted incrementally.
