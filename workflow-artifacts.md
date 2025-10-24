# Workflow Artifacts Reference

Complete reference for all artifacts in the AI-augmented software development workflow, including role definitions, ontologies, planning documents, specifications, code, tests, and living documentation.

## Quick Navigation

- [Role Definitions & Ontologies](#role-definitions--ontologies)
- [Planning Documents](#planning-documents)
- [Specification & Review Files](#specification--review-files)
- [Code & Test Files](#code--test-files)
- [Living Documentation](#living-documentation)
- [Directory Structure](#directory-structure-example)
- [Artifact Lifecycle](#artifact-lifecycle)

## Role Definitions & Ontologies

### Planning Role Sets

Each planning phase has Writer, Reviewer, and Helper roles, plus an ontology document.

| Role File | Purpose | Collaboration Style |
|-----------|---------|---------------------|
| **role-vision-writer.md** | Creates VISION.md defining project purpose | Collaborative |
| **role-vision-reviewer.md** | Reviews vision for clarity and feasibility | Independent |
| **role-vision-writing-helper.md** | Guides vision creation via Socratic conversation | Collaborative |
| **VISION-ontology.md** | Defines vision document structure | Reference |
| | | |
| **role-scope-writer.md** | Defines project boundaries (in/out/deferred) | Collaborative |
| **role-scope-reviewer.md** | Reviews scope for completeness and alignment | Independent |
| **role-scope-writing-helper.md** | Guides scope definition via conversation | Collaborative |
| **SCOPE-ontology.md** | Defines scope document structure | Reference |
| | | |
| **role-roadmap-writer.md** | Sequences features into phased delivery plan | Collaborative |
| **role-roadmap-reviewer.md** | Reviews roadmap for sequencing logic | Independent |
| **role-roadmap-writing-helper.md** | Guides roadmap planning via conversation | Collaborative |
| **ROADMAP-ontology.md** | Defines roadmap document structure | Reference |
| | | |
| **role-spec-writer.md** | Transforms features into behavioral specifications | Collaborative |
| **role-spec-reviewer.md** | Reviews specs, gates `proposed/` â†’ `todo/` | Independent (Gatekeeper) |
| **role-spec-writing-helper.md** | Guides specification writing via conversation | Collaborative |
| **SPEC-ontology.md** | Defines specification document structure | Reference |

**Pattern:** Planning roles + ontologies = information equivalence with Claude skills

### Coding Role Sets

Coding roles are workflow-focused, assuming LLMs know how to code/test.

| Role File | Purpose | Collaboration Style |
|-----------|---------|---------------------|
| **role-skeleton-writer.md** | Creates interface skeletons, creates feature branch | Autonomous |
| **role-skeleton-reviewer.md** | Reviews skeletons for testability | Independent |
| | | |
| **role-test-writer.md** | Writes comprehensive test suites (TDD RED) | Autonomous |
| **role-test-reviewer.md** | Reviews tests for completeness (TDD RED verification) | Independent |
| | | |
| **role-implementer.md** | Makes tests pass (TDD GREEN) | Autonomous |
| **role-implementation-reviewer.md** | Reviews code quality, gates `doing/` â†’ `done/` | Independent (Gatekeeper) |

### Support Roles

| Role File | Purpose | Collaboration Style |
|-----------|---------|---------------------|
| **role-platform-lead.md** | Maintains living documentation | Ongoing |

## Planning Documents

Planning documents define project direction and scope.

| Document | Path | Created By | Reviewed By | Lifecycle |
|----------|------|------------|-------------|-----------|
| **VISION.md** | Project root | Vision Writer | Vision Reviewer | Foundation (pre-workflow) |
| **SCOPE.md** | Project root | Scope Writer | Scope Reviewer | Planning phase |
| **ROADMAP.md** | Project root | Roadmap Writer | Roadmap Reviewer | Planning phase |

**Purpose:**
- **VISION**: Why project exists, 2-5 year success criteria
- **SCOPE**: What's in/out/deferred, boundaries, constraints
- **ROADMAP**: Feature sequence, phases, dependencies

**Created once**, updated as project evolves.

## Specification & Review Files

### Specification Files

Specifications move through four states:

| State | Path | Meaning | Controlled By |
|-------|------|---------|---------------|
| **proposed** | `specs/proposed/<feature>.md` | Draft awaiting review | Spec Writer creates |
| **todo** | `specs/todo/<feature>.md` | Approved, ready for work | Spec Reviewer moves (gatekeeper) |
| **doing** | `specs/doing/<feature>.md` | Active development | Skeleton Writer moves (+ creates branch) |
| **done** | `specs/done/<feature>.md` | Complete, merged | Implementation Reviewer moves (gatekeeper) |

**Naming:** Use kebab-case feature names (e.g., `user-authentication.md`, `weather-cache.md`)

**State transitions:**
```
proposed/ â†’ [Spec Reviewer APPROVES] â†’ todo/
todo/ â†’ [Skeleton approved, branch created] â†’ doing/
doing/ â†’ [Implementation Reviewer APPROVES] â†’ done/
```

### Review Files

All reviews use timestamped filenames with status.

| Review Type | Directory | Creator Role | Gates |
|-------------|-----------|--------------|-------|
| Planning reviews | `reviews/planning/` | Vision/Scope/Roadmap Reviewers | Quality check |
| Spec reviews | `reviews/specs/` | Spec Reviewer | `proposed/` â†’ `todo/` |
| Skeleton reviews | `reviews/skeletons/` | Skeleton Reviewer | Approves for test writing |
| Test reviews | `reviews/tests/` | Test Reviewer | RED â†’ GREEN transition |
| Implementation reviews | `reviews/implementations/` | Implementation Reviewer | `doing/` â†’ `done/` |

**Naming pattern:** `YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md`

**Status values:**
- `APPROVED` - Ready to proceed to next stage
- `NEEDS-CHANGES` - Requires revision before proceeding

**Examples:**
- `2025-10-23T14-30-47-user-registration-APPROVED.md`
- `2025-10-23T15-22-13-payment-gateway-NEEDS-CHANGES.md`

**Use seconds precision** to avoid filename collisions.

## Code & Test Files

### Skeleton Code (Interfaces)

| Artifact | Location | Purpose | Created By |
|----------|----------|---------|------------|
| Interface skeletons | `src/**/*.py` | Complete type signatures, NotImplementedError stubs | Skeleton Writer |

**Characteristics:**
- Complete type annotations
- Comprehensive docstrings
- Zero implementation logic
- Dependency injection enabled
- Passes linters and type checkers

### Test Files

| Artifact | Location | Purpose | Created By |
|----------|----------|---------|------------|
| Unit tests | `tests/unit/test_<feature>.py` | Isolated component tests | Test Writer |
| Integration tests | `tests/integration/test_<feature>_integration.py` | Component interaction tests | Test Writer |

**Naming:** One coherent test file per feature preferred

**Attribution:** When multiple contributors edit same file, use inline comments:
```python
# === Tests by Claude Sonnet 4.5 (2025-10-23) ===
def test_feature_happy_path(): ...

# === Tests by Human Developer (2025-10-24) ===
def test_feature_edge_case(): ...
```

**Critical:** Test Reviewer reviews **entire suite** as single unit (all-in review)

### Implementation Code

| Artifact | Location | Purpose | Created By |
|----------|----------|---------|------------|
| Production code | `src/**/*.py` | Working implementation | Implementer |

**Characteristics:**
- Makes all tests pass (GREEN)
- Follows GUIDELINES.md conventions
- Respects GUIDELINES.md constraints
- Never modifies tests

## Living Documentation

Living docs prevent architecture amnesia and maintain institutional memory.

| Document | Path | Maintained By | Purpose |
|----------|------|---------------|---------|
| **SYSTEM_MAP.md** | Project root | Platform Lead | Architecture overview, module boundaries, component locations |
| **GUIDELINES.md** | Project root | Platform Lead | Coding conventions, blessed utilities, design patterns, architectural constraints, forbidden patterns, security requirements |
| **bug reports in bugs/fixed/** | Project root | Platform Lead | Historical bugs with root causes, fixes, sentinel tests, lessons learned |

### SYSTEM_MAP.md

**Contains:**
- High-level architecture diagram
- Module organization and responsibilities
- Component boundaries
- Integration points
- File organization patterns

**Updated:** After features merge with architecture changes

**Used by:** All roles for architectural context

### GUIDELINES.md

**Contains:**
- Naming conventions (functions, classes, files)
- Code organization patterns
- Standard utilities to use (blessed libraries)
- Import patterns
- Docstring styles
- Forbidden imports (e.g., no direct database imports in services)
- Layer boundaries (e.g., services can't import from controllers)
- Dependency rules
- Security requirements
- Performance constraints

**Updated:** When new architectural constraints established

**Used by:** Spec Writer, Implementer, Reviewers

### bug reports in bugs/fixed/

**Structure:**
```yaml
bugs:
  - id: BUG-042
    date: "2025-10-15"
    description: Empty string passed email validation
    root_cause: Missing empty string check in validation logic
    fix: Added empty string validation as first check
    sentinel_test: test_bug_42_empty_email_validation
    lessons_learned: Always validate empty/null inputs before other checks
    affected_files:
      - src/utils/validation.py
      - tests/unit/test_validation.py
```

**Updated:** When bugs are fixed (Platform Lead adds entry)

**Used by:** Test Writer (adds sentinel tests), Implementer (avoids patterns), Reviewers (checks compliance)

## Directory Structure Example

Complete project structure showing all artifact locations:

```
project-root/
â”œâ”€â”€ VISION.md                      # Foundation - why project exists
â”œâ”€â”€ SCOPE.md                       # Planning - what's in/out
â”œâ”€â”€ ROADMAP.md                     # Planning - feature sequence
â”œâ”€â”€ SYSTEM_MAP.md                  # Living doc - architecture
â”œâ”€â”€ GUIDELINES.md                       # Living doc - constraints
â”œâ”€â”€ bug reports in bugs/fixed/                 # Living doc - bug history
â”‚
â”œâ”€â”€ specs/
â”‚   â”œâ”€â”€ proposed/                  # Awaiting spec review
â”‚   â”‚   â””â”€â”€ new-feature.md
â”‚   â”œâ”€â”€ todo/                      # Approved, not started
â”‚   â”‚   â””â”€â”€ next-feature.md
â”‚   â”œâ”€â”€ doing/                     # Active development (on feature branch)
â”‚   â”‚   â””â”€â”€ active-feature.md
â”‚   â””â”€â”€ done/                      # Completed features
â”‚       â””â”€â”€ finished-feature.md
â”‚
â”œâ”€â”€ reviews/
â”‚   â”œâ”€â”€ planning/                  # Vision/Scope/Roadmap reviews
â”‚   â”‚   â””â”€â”€ 2025-10-23T10-15-30-roadmap-APPROVED.md
â”‚   â”œâ”€â”€ specs/                     # Spec reviews
â”‚   â”‚   â”œâ”€â”€ 2025-10-23T09-00-15-user-auth-APPROVED.md
â”‚   â”‚   â””â”€â”€ 2025-10-23T14-30-47-payment-NEEDS-CHANGES.md
â”‚   â”œâ”€â”€ skeletons/                 # Skeleton reviews
â”‚   â”‚   â””â”€â”€ 2025-10-23T10-45-22-user-auth-APPROVED.md
â”‚   â”œâ”€â”€ tests/                     # Test reviews
â”‚   â”‚   â””â”€â”€ 2025-10-23T11-20-05-user-auth-APPROVED.md
â”‚   â””â”€â”€ implementations/           # Implementation reviews
â”‚       â””â”€â”€ 2025-10-23T16-45-30-user-auth-APPROVED.md
â”‚
â”œâ”€â”€ src/                           # Production code
â”‚   â”œâ”€â”€ services/
â”‚   â”‚   â””â”€â”€ user_service.py
â”‚   â”œâ”€â”€ models/
â”‚   â”‚   â””â”€â”€ user.py
â”‚   â””â”€â”€ utils/
â”‚       â””â”€â”€ validation.py
â”‚
â””â”€â”€ tests/
    â”œâ”€â”€ unit/                      # Unit tests
    â”‚   â”œâ”€â”€ test_user_service.py
    â”‚   â””â”€â”€ test_validation.py
    â””â”€â”€ integration/               # Integration tests
        â””â”€â”€ test_user_registration_flow.py
```

## Artifact Lifecycle

### Foundation Phase

```
Vision Writer + Human â†’ VISION.md
  â†“
Vision Reviewer â†’ APPROVED
```

### Planning Phase

```
VISION.md
  â†“
Scope Writer + Human â†’ SCOPE.md
  â†“
Scope Reviewer â†’ APPROVED
  â†“
Roadmap Writer + Human â†’ ROADMAP.md
  â†“
Roadmap Reviewer â†’ APPROVED
```

### Per-Feature Development

```
Roadmap item selected
  â†“
Spec Writer + Human â†’ specs/proposed/<feature>.md
  â†“
Spec Reviewer â†’ APPROVED â†’ moves to specs/todo/<feature>.md
  â†“
Skeleton Writer â†’ creates interface files
  â†“
Skeleton Reviewer â†’ APPROVED
  â†“
Skeleton Writer â†’ creates feature branch + moves spec to specs/doing/<feature>.md
  â†“
Test Writer â†’ writes test suite (all tests RED)
  â†“
Test Reviewer â†’ APPROVED (verifies RED state)
  â†“
Implementer â†’ writes code (makes tests GREEN)
  â†“
Implementation Reviewer â†’ APPROVED â†’ moves spec to specs/done/<feature>.md
  â†“
Merge feature branch to main
  â†“
Platform Lead â†’ updates SYSTEM_MAP.md, GUIDELINES.md as needed
```

## Artifact Ownership Matrix

| Artifact | Created By | Approved By | Moved By | Lives On |
|----------|------------|-------------|----------|----------|
| VISION.md | Vision Writer | Vision Reviewer | - | Main |
| SCOPE.md | Scope Writer | Scope Reviewer | - | Main |
| ROADMAP.md | Roadmap Writer | Roadmap Reviewer | - | Main |
| specs/proposed/ | Spec Writer | - | - | Main |
| specs/todo/ | - | Spec Reviewer | Spec Reviewer â˜… | Main |
| specs/doing/ | - | Skeleton Reviewer | Skeleton Writer | Feature branch |
| specs/done/ | - | Implementation Reviewer | Implementation Reviewer â˜… | Main (after merge) |
| Skeleton code | Skeleton Writer | Skeleton Reviewer | - | Feature branch |
| Tests | Test Writer | Test Reviewer | - | Feature branch |
| Implementation | Implementer | Implementation Reviewer | - | Feature branch |
| Living docs | Platform Lead | - | - | Main |
| Reviews | Various Reviewers | - | - | Main |

â˜… = Gatekeeper role (controls state transitions)

## Artifact Consumers

| Artifact | Primary Consumers | Usage |
|----------|-------------------|-------|
| VISION.md | Scope Writer, Roadmap Writer, Spec Writer | Strategic context, alignment |
| SCOPE.md | Roadmap Writer, Spec Writer | Boundaries, constraints |
| ROADMAP.md | Spec Writer | Feature prioritization |
| SPEC files | Skeleton Writer, Test Writer, Implementer | Implementation contract |
| Skeleton code | Test Writer, Implementer | Interface definitions |
| Tests | Implementer, Implementation Reviewer | Contract verification |
| Implementation | Implementation Reviewer, Platform Lead | Quality check, doc updates |
| SYSTEM_MAP.md | All roles | Architecture reference |
| GUIDELINES.md | Skeleton Writer, Implementer, Spec Writer, Implementer, Reviewers | Coding conventions |
| bug reports in bugs/fixed/ | Test Writer, Implementer, Reviewers | Regression prevention |

## Artifact State Tracking

### Planning Documents (Persistent)

Planning documents are created once and updated as needed:

- **VISION.md** - Updated when strategic direction changes
- **SCOPE.md** - Updated when boundaries change
- **ROADMAP.md** - Updated when sequencing changes

### Specification Files (Stateful)

Specifications flow through states as development progresses:

- **proposed/** - Created, awaiting review
- **todo/** - Approved, queued for development
- **doing/** - In active development
- **done/** - Complete, shipped

### Living Documentation (Continuous)

Living docs are continuously updated:

- **SYSTEM_MAP.md** - After architecture changes
- **GUIDELINES.md** - When patterns emerge or constraints added
- **bug reports in bugs/fixed/** - When bugs fixed

### Review Records (Immutable)

Review files are timestamped records, never modified after creation:

- Permanent audit trail
- Historical decision records
- Learning resource

## Naming Conventions Summary

**Feature names:** kebab-case
- âœ… `user-authentication`, `weather-cache`, `payment-processing`
- âŒ `UserAuthentication`, `weather_cache`, `PaymentProcessing`

**Review timestamps:** ISO 8601 with seconds
- âœ… `2025-10-23T14-30-47`
- âŒ `2025-10-23T14-30`, `20251023T143047`

**Review status:** Uppercase
- âœ… `APPROVED`, `NEEDS-CHANGES`
- âŒ `approved`, `Needs-Changes`, `needs_changes`

**Test files:** snake_case with test_ prefix
- âœ… `test_user_authentication.py`, `test_weather_cache.py`
- âŒ `user_authentication_test.py`, `testWeatherCache.py`

**Source files:** snake_case
- âœ… `user_service.py`, `weather_cache.py`
- âŒ `UserService.py`, `weatherCache.py`

## Quick Reference

**"Where do I start?"**  
â†’ Create VISION.md (foundation)

**"Where do I put a new spec?"**  
â†’ `specs/proposed/<feature>.md`

**"Who moves specs between states?"**  
â†’ Spec Reviewer (proposed â†’ todo)  
â†’ Skeleton Writer (todo â†’ doing, + creates branch)  
â†’ Implementation Reviewer (doing â†’ done)

**"Where do tests go?"**  
â†’ `tests/unit/test_<feature>.py` (one file per feature preferred)

**"Where do review files go?"**  
â†’ `reviews/<type>/YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md`

**"What are the living docs?"**  
â†’ SYSTEM_MAP.md, GUIDELINES.md

**"When are living docs updated?"**  
â†’ After feature merges (by Platform Lead)

**"Can I modify a test to make it pass?"**  
â†’ NO. Request test re-review instead.

---
