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
| **VISION-schema.md** | Defines vision document structure | Reference |
| | | |
| **role-scope-writer.md** | Defines project boundaries (in/out/deferred) | Collaborative |
| **role-scope-reviewer.md** | Reviews scope for completeness and alignment | Independent |
| **role-scope-writing-helper.md** | Guides scope definition via conversation | Collaborative |
| **SCOPE-schema.md** | Defines scope document structure | Reference |
| | | |
| **role-roadmap-writer.md** | Sequences features into phased delivery plan | Collaborative |
| **role-roadmap-reviewer.md** | Reviews roadmap for sequencing logic | Independent |
| **role-roadmap-writing-helper.md** | Guides roadmap planning via conversation | Collaborative |
| **ROADMAP-schema.md** | Defines roadmap document structure | Reference |
| | | |
| **role-spec-writer.md** | Transforms features into behavioral specifications | Collaborative |
| **role-spec-reviewer.md** | Reviews specs, gates `proposed/` → `todo/` | Independent (Gatekeeper) |
| **role-spec-writing-helper.md** | Guides specification writing via conversation | Collaborative |
| **SPEC-schema.md** | Defines specification document structure | Reference |

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
| **role-implementation-reviewer.md** | Reviews code quality, gates `doing/` → `done/` | Independent (Gatekeeper) |

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
proposed/ → [Spec Reviewer APPROVES] → todo/
todo/ → [Skeleton approved, branch created] → doing/
doing/ → [Implementation Reviewer APPROVES] → done/
```

### Review Files

All reviews use timestamped filenames with status.

| Review Type | Directory | Creator Role | Gates |
|-------------|-----------|--------------|-------|
| Planning reviews | `reviews/planning/` | Vision/Scope/Roadmap Reviewers | Quality check |
| Spec reviews | `reviews/specs/` | Spec Reviewer | `proposed/` → `todo/` |
| Skeleton reviews | `reviews/skeletons/` | Skeleton Reviewer | Approves for test writing |
| Test reviews | `reviews/tests/` | Test Reviewer | RED → GREEN transition |
| Implementation reviews | `reviews/implementations/` | Implementation Reviewer | `doing/` → `done/` |
| Bug fix reviews | `reviews/bug-fixes/` | Implementation Reviewer | `fixing/` → `fixed/` |

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
├── VISION.md                      # Foundation - why project exists
├── SCOPE.md                       # Planning - what's in/out
├── ROADMAP.md                     # Planning - feature sequence
├── SYSTEM_MAP.md                  # Living doc - architecture
├── GUIDELINES.md                       # Living doc - constraints
├── bug reports in bugs/fixed/                 # Living doc - bug history
│
├── specs/
│   ├── proposed/                  # Awaiting spec review
│   │   └── new-feature.md
│   ├── todo/                      # Approved, not started
│   │   └── next-feature.md
│   ├── doing/                     # Active development (on feature branch)
│   │   └── active-feature.md
│   └── done/                      # Completed features
│       └── finished-feature.md
│
├── reviews/
│   ├── planning/                  # Vision/Scope/Roadmap reviews
│   │   └── 2025-10-23T10-15-30-roadmap-APPROVED.md
│   ├── specs/                     # Spec reviews
│   │   ├── 2025-10-23T09-00-15-user-auth-APPROVED.md
│   │   └── 2025-10-23T14-30-47-payment-NEEDS-CHANGES.md
│   ├── skeletons/                 # Skeleton reviews
│   │   └── 2025-10-23T10-45-22-user-auth-APPROVED.md
│   ├── tests/                     # Test reviews
│   │   └── 2025-10-23T11-20-05-user-auth-APPROVED.md
│   └── implementations/           # Implementation reviews
│       └── 2025-10-23T16-45-30-user-auth-APPROVED.md
│   └── bug-fixes/                 # Bug fix reviews
│       └── 2025-10-23T16-45-30-user-auth-invalid-chars-APPROVED.md
│
├── src/                           # Production code
│   ├── services/
│   │   └── user_service.py
│   ├── models/
│   │   └── user.py
│   └── utils/
│       └── validation.py
│
└── tests/
    ├── unit/                      # Unit tests
    │   ├── test_user_service.py
    │   └── test_validation.py
    └── integration/               # Integration tests
        └── test_user_registration_flow.py
    └── regression/               # Sentinel tests
        └── test_user_registration_flow_with_invalid_chars.py
```

## Artifact Lifecycle

### Foundation Phase

```
Vision Writer + Human → VISION.md
  ↓
Vision Reviewer → APPROVED
```

### Planning Phase

```
VISION.md
  ↓
Scope Writer + Human → SCOPE.md
  ↓
Scope Reviewer → APPROVED
  ↓
Roadmap Writer + Human → ROADMAP.md
  ↓
Roadmap Reviewer → APPROVED
```

### Per-Feature Development

```
Roadmap item selected
  ↓
Spec Writer + Human → specs/proposed/<feature>.md
  ↓
Spec Reviewer → APPROVED → moves to specs/todo/<feature>.md
  ↓
Skeleton Writer → creates interface files
  ↓
Skeleton Reviewer → APPROVED
  ↓
Skeleton Writer → creates feature branch + moves spec to specs/doing/<feature>.md
  ↓
Test Writer → writes test suite (all tests RED)
  ↓
Test Reviewer → APPROVED (verifies RED state)
  ↓
Implementer → writes code (makes tests GREEN)
  ↓
Implementation Reviewer → APPROVED → moves spec to specs/done/<feature>.md
  ↓
Merge feature branch to main
  ↓
Platform Lead → updates SYSTEM_MAP.md, GUIDELINES.md as needed
```

## Artifact Ownership Matrix

| Artifact | Created By | Approved By | Moved By | Lives On |
|----------|------------|-------------|----------|----------|
| VISION.md | Vision Writer | Vision Reviewer | - | Main |
| SCOPE.md | Scope Writer | Scope Reviewer | - | Main |
| ROADMAP.md | Roadmap Writer | Roadmap Reviewer | - | Main |
| specs/proposed/ | Spec Writer | - | - | Main |
| specs/todo/ | - | Spec Reviewer | Spec Reviewer ★ | Main |
| specs/doing/ | - | Skeleton Reviewer | Skeleton Writer | Feature branch |
| specs/done/ | - | Implementation Reviewer | Implementation Reviewer ★ | Main (after merge) |
| Skeleton code | Skeleton Writer | Skeleton Reviewer | - | Feature branch |
| Tests | Test Writer | Test Reviewer | - | Feature branch |
| Implementation | Implementer | Implementation Reviewer | - | Feature branch |
| Living docs | Platform Lead | - | - | Main |
| Reviews | Various Reviewers | - | - | Main |

★ = Gatekeeper role (controls state transitions)

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
- ✓ `user-authentication`, `weather-cache`, `payment-processing`
- ❌ `UserAuthentication`, `weather_cache`, `PaymentProcessing`

**Review timestamps:** ISO 8601 with seconds
- ✓ `2025-10-23T14-30-47`
- ❌ `2025-10-23T14-30`, `20251023T143047`

**Review status:** Uppercase
- ✓ `APPROVED`, `NEEDS-CHANGES`
- ❌ `approved`, `Needs-Changes`, `needs_changes`

**Test files:** snake_case with test_ prefix
- ✓ `test_user_authentication.py`, `test_weather_cache.py`
- ❌ `user_authentication_test.py`, `testWeatherCache.py`

**Source files:** snake_case
- ✓ `user_service.py`, `weather_cache.py`
- ❌ `UserService.py`, `weatherCache.py`

## Quick Reference

**"Where do I start?"**  
→ Create VISION.md (foundation)

**"Where do I put a new spec?"**  
→ `specs/proposed/<feature>.md`

**"Who moves specs between states?"**  
→ Spec Reviewer (proposed → todo)  
→ Skeleton Writer (todo → doing, + creates branch)  
→ Implementation Reviewer (doing → done)

**"Where do tests go?"**  
→ `tests/unit/test_<feature>.py` (one file per feature preferred)

**"Where do review files go?"**  
→ `reviews/<type>/YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md`

**"What are the living docs?"**  
→ SYSTEM_MAP.md, GUIDELINES.md

**"When are living docs updated?"**  
→ After feature merges (by Platform Lead)

**"Can I modify a test to make it pass?"**  
→ NO. Request test re-review instead.

---
