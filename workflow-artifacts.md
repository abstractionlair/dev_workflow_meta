# Workflow Artifacts Reference

Quick reference for all artifacts in the AI-augmented software development workflow. For detailed formats and creation processes, see the individual role definitions.

## Artifact Locations & Names (Canonical)

| Artifact Type | Path | Naming | Notes |
|---------------|------|--------|-------|
| Spec (proposed) | `specs/proposed/<feature>.md` | kebab-case feature name | Draft awaiting review |
| Spec (todo) | `specs/todo/<feature>.md` | same filename as proposed | Approved, not started |
| Spec (doing) | `specs/doing/<feature>.md` | same filename as proposed | Implementation underway |
| Spec (done) | `specs/done/<feature>.md` | same filename as proposed | Implementation complete |
| Planning review | `reviews/planning/` | `YYYY-MM-DDTHH-MM-SS-<topic>-<STATUS>.md` | STATUS = APPROVED\|NEEDS-CHANGES |
| Spec review | `reviews/specs/` | `YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md` | Use seconds for uniqueness |
| Skeleton review | `reviews/skeletons/` | `YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md` | Same timestamped pattern |
| Test review | `reviews/tests/` | `YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md` | All-in suite review |
| Implementation review | `reviews/implementations/` | `YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md` | Gates doing -> done |
| Unit tests | `tests/unit/test_<feature>.py` | One suite per feature | Use inline attribution if multiple contributors |
| Integration tests | `tests/integration/` | Free-form module names | Based on integration scope |

### Naming Conventions

**Feature names:** Use kebab-case (e.g., `user-authentication`, `weather-cache`)

**Review timestamps:** ISO 8601 format with seconds (e.g., `2025-01-23T14-30-47`)

**Review status:** Always one of:
- `APPROVED` - Ready to proceed
- `NEEDS-CHANGES` - Requires revision

### Directory Structure Example

```
project-root/
|- specs/
|  |- proposed/          # Awaiting spec review
|  |  |- new-feature.md
|  |- todo/             # Approved, not started
|  |  |- next-feature.md
|  |- doing/            # Implementation in progress
|  |  |- active-feature.md
|  |- done/             # Completed features
|     |- finished-feature.md
|- reviews/
|  |- planning/
|  |  |- 2025-01-20T10-15-30-roadmap-APPROVED.md
|  |- specs/
|  |  |- 2025-01-21T09-00-15-user-auth-APPROVED.md
|  |  |- 2025-01-22T14-30-47-weather-cache-NEEDS-CHANGES.md
|  |- skeletons/
|  |- tests/
|  |  |- 2025-01-23T11-20-05-user-auth-APPROVED.md
|  |- implementations/
|     |- 2025-01-24T16-45-30-user-auth-APPROVED.md
|- tests/
   |- unit/
      |- test_user_auth.py  # Single coherent suite
```


## Artifact Overview

| Artifact | Creator Role | Purpose | Primary Consumers | Status |
|----------|--------------|---------|-------------------|--------|
| VISION.md | Vision Writer | Aspirational "why" - problem, solution, success criteria | Scope Writer, Roadmap Planner | Foundation |
| SCOPE.md | Scope Writer | Project boundaries (in/out), constraints | Roadmap Planner, Spec Writer | Planning |
| ROADMAP.md | Roadmap Planner | Feature sequence, phases, dependencies | Spec Writer | Planning |
| Planning review | Planning Reviewer | Assessment of scope/roadmap quality | Scope Writer, Roadmap Planner | Review |
| specs/\*.md | Spec Writer | Detailed behavioral contracts for features | Skeleton Writer, Test Writer | Design/Contract |
| Spec review | Spec Reviewer | Assessment of spec completeness and clarity | Spec Writer | Review |
| Skeleton code | Skeleton Writer | Function/class signatures with stubs | Test Writer, Implementer | Design/Contract |
| Skeleton review | Skeleton Reviewer | Verification skeleton matches spec | Skeleton Writer | Review |
| tests/\* | Test Writer | Comprehensive test suites (TDD red) | Implementer, Implementation Reviewer | Quality Assurance |
| Test review | Test Reviewer | Assessment of test coverage and quality (all-in) | Test Writer | Review |
| src/\* | Implementer | Production code (TDD green) | Implementation Reviewer, Platform Lead | Implementation |
| Implementation review | Implementation Reviewer | Verification code quality and compliance | Implementer | Review |
| SYSTEM_MAP.md | Platform Lead | Architecture, modules, component locations | All roles (reference) | Living Memory |
| PATTERNS.md | Platform Lead | Blessed utilities, coding conventions | Skeleton Writer, Implementer | Living Memory |
| RULES.md | Platform Lead | Architectural constraints, forbidden patterns | Spec Writer, Implementer, Reviewers | Living Memory |
| BUG_LEDGER.yml | Platform Lead | Historical bugs, sentinel tests, prevention | Test Writer, Implementer, Reviewers | Living Memory |

## Artifact Lifecycle

```
Foundation (pre-workflow):
  VISION.md
    -

Planning Phase:
  VISION.md -> SCOPE.md + ROADMAP.md
    -
  Planning Review (approval gate)
    -

Per-Feature Flow:
  ROADMAP item selected
    -
  Spec Writer -> specs/proposed/<feature>.md
    -
  Spec Reviewer -> [APPROVED] -> move to specs/todo/<feature>.md
    -
  Skeleton Writer -> skeleton code
    -
  Skeleton Reviewer -> [APPROVED]
    -
  Implementer -> move specs/todo/<feature>.md to specs/doing/<feature>.md
  (Creates feature branch at this point)
    -
  Test Writer -> tests (red state)
    -
  Test Reviewer -> [APPROVED] (all-in review)
    -
  Implementer -> implementation (green state)
    -
  Implementation Reviewer -> [APPROVED] -> move specs/doing/<feature>.md to specs/done/<feature>.md
    -
  Merge to main

Continuous:
  Platform Lead -> maintains SYSTEM_MAP, PATTERNS, RULES, BUG_LEDGER
```

## Gatekeeper Movements

### Spec Reviewer (proposed -> todo)
**When**: After APPROVED spec review
**Action**: `git mv specs/proposed/<feature>.md specs/todo/<feature>.md`
**Review file**: `reviews/specs/YYYY-MM-DDTHH-MM-SS-<feature>-APPROVED.md`

### Implementer (todo -> doing)
**When**: Starting implementation (not a review gate)
**Action**: `git mv specs/todo/<feature>.md specs/doing/<feature>.md`
**Note**: Also time to create feature branch

### Implementation Reviewer (doing -> done)
**When**: After APPROVED implementation review
**Action**: `git mv specs/doing/<feature>.md specs/done/<feature>.md`
**Review file**: `reviews/implementations/YYYY-MM-DDTHH-MM-SS-<feature>-APPROVED.md`

## Strategic/Planning Artifacts

**VISION.md** - Aspirational document
- Why this project exists
- Problem being solved
- Success criteria
- Created before any other work

**SCOPE.md** - Boundary definition
- What's in scope
- What's out of scope  
- "Maybe later" items
- Created by Scope Writer + Human

**ROADMAP.md** - Feature sequence
- Ordered list of features
- Rough definitions (1-2 sentences each)
- Dependencies noted
- Status tracking (todo/doing/done)

**Planning review** - Assessment
- Reviews SCOPE + ROADMAP together
- Created by Planning Reviewer
- Location: `reviews/planning/`

## Design/Contract Artifacts (per feature)

**specs/\*.md** - Detailed behavioral contracts
- Interface signatures (markdown, not actual code)
- Behavioral examples (happy path, edge cases, errors)
- Dependencies and constraints
- Testing considerations
- Flows through states: `proposed/ -> todo/ -> doing/ -> done/`

**Skeleton code** - Actual code files with stubs
- Function/class signatures with type hints
- Comprehensive docstrings
- NotImplementedError raises
- Proper imports
- Location: Project source directories (e.g., `src/`)

## Quality Assurance Artifacts

**tests/\*** - Comprehensive test suites
- Unit tests (`tests/unit/test_<feature>.py`) - single file per feature
- Integration tests (`tests/integration/`)
- Fixtures and mocks (`tests/fixtures/`, `conftest.py`)
- Sentinel tests (for bugs in BUG_LEDGER)
- State: Red (failing) before implementation, Green (passing) after
- Attribution: Inline comments when multiple contributors

## Implementation Artifacts

**src/\*** - Production code
- Makes tests pass (TDD green state)
- Follows patterns from PATTERNS.md
- Respects rules from RULES.md
- References architecture from SYSTEM_MAP.md

## Living Memory Documents (maintained continuously)

**SYSTEM_MAP.md** - Architecture reference
- Module organization (directories, files)
- Component responsibilities
- Integration points
- Key abstractions and boundaries
- Where to find things

**PATTERNS.md** - Coding conventions
- Blessed utilities (with locations)
- Established patterns for common tasks
- Code style conventions
- Import patterns
- Examples of proper usage

**RULES.md** - Architectural constraints
- Layer boundaries (import restrictions)
- Forbidden patterns (with rationale)
- Security/compliance requirements
- Performance constraints
- Exceptions policy

**BUG_LEDGER.yml** - Bug history
- Bug descriptions with IDs
- Dates discovered and fixed
- Root causes
- Sentinel test locations
- Prevention strategies
- Searchable categories

## Artifact Flow Patterns

### Linear Flow (Planning)
```
VISION -> SCOPE -> ROADMAP -> [Planning Review]
```
Each informs the next; created sequentially.

### Feature Cycle (per feature)
```
ROADMAP item 
  -> spec (proposed) 
  -> [spec review] 
  -> spec (todo)
  -> skeleton 
  -> [skeleton review] 
  -> spec (doing) + feature branch
  -> tests (red) 
  -> [test review] 
  -> implementation (green) 
  -> [implementation review] 
  -> spec (done)
  -> merged to main
```
Reviews are approval gates; work doesn't proceed until approved.

### Continuous Maintenance
```
Any phase -> Living Memory docs (SYSTEM_MAP, PATTERNS, RULES, BUG_LEDGER)
```
Updated as project evolves; consulted by all roles.

## Validation Checklists

### Before Starting Feature Implementation
- [ ] VISION.md exists and is clear
- [ ] SCOPE.md defines project boundaries
- [ ] ROADMAP.md lists this feature
- [ ] Feature spec approved and in `specs/todo/`
- [ ] Skeleton code created and reviewed
- [ ] Tests written and in red state
- [ ] SYSTEM_MAP.md consulted for architecture
- [ ] PATTERNS.md consulted for conventions
- [ ] RULES.md consulted for constraints
- [ ] BUG_LEDGER.yml checked for relevant bugs

### Before Claiming Feature Complete
- [ ] All new tests pass (green state)
- [ ] No existing tests broken (regression check)
- [ ] Implementation reviewed and approved
- [ ] Living memory docs updated:
  - [ ] SYSTEM_MAP.md (if new modules/components)
  - [ ] PATTERNS.md (if new patterns emerged)
  - [ ] RULES.md (if new constraints discovered)
  - [ ] BUG_LEDGER.yml (if bugs found and fixed)
- [ ] Spec moved to `specs/done/`
- [ ] ROADMAP.md status updated

### Before Starting New Project
- [ ] VISION.md created
- [ ] SCOPE.md created and reviewed
- [ ] ROADMAP.md created and reviewed
- [ ] Living memory docs initialized:
  - [ ] SYSTEM_MAP.md (basic structure)
  - [ ] PATTERNS.md (initial conventions)
  - [ ] RULES.md (architectural decisions)
  - [ ] BUG_LEDGER.yml (empty, ready for entries)

## For Detailed Information

See individual role definitions for:
- **VISION.md format**: role-vision-writer.md
- **SCOPE.md format**: role-scope-writer.md
- **ROADMAP.md format**: role-roadmap-planner.md
- **Planning review format**: role-planning-reviewer.md
- **Specification format**: role-spec-writer.md
- **Spec review format**: role-spec-reviewer.md
- **Skeleton code guidelines**: role-skeleton-writer.md
- **Skeleton review format**: role-skeleton-reviewer.md
- **Test structure**: role-test-writer.md
- **Test review format**: role-test-reviewer.md
- **Implementation guidelines**: role-implementer.md
- **Implementation review format**: role-implementation-reviewer.md
- **Living docs maintenance**: role-platform-lead.md

## Quick Reference: "What Artifact Do I Need?"

**"Why are we building this?"** -> VISION.md

**"What's included in this project?"** -> SCOPE.md

**"What are we building next?"** -> ROADMAP.md

**"How should this feature behave?"** -> specs/<feature>.md

**"What's the interface look like?"** -> Skeleton code files

**"How do I test this?"** -> tests/unit/test_<feature>.py

**"Where does this component live?"** -> SYSTEM_MAP.md

**"What's the blessed way to do X?"** -> PATTERNS.md

**"What am I not allowed to do?"** -> RULES.md

**"Has this bug happened before?"** -> BUG_LEDGER.yml

**"Was my work approved?"** -> reviews/<type>/<timestamp>-<feature>-<STATUS>.md