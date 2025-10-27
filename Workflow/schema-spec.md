# SPEC (Specification) Ontology

## Purpose

This document defines the canonical structure, content, and semantics of SPEC files. It serves as the authoritative reference for:
- **spec-writer** (producer): What to create
- **skeleton-writer** (consumer): What to expect
- **test-writer**: What behaviors to test
- **Spec reviewers**: What to validate

## Document Type

**Format:** Markdown (.md)  
**Producer:** spec-writer  
**Primary Consumers:** skeleton-writer, test-writer, implementer  
**Secondary Consumers:** Spec reviewers, stakeholders

## File Naming Convention

**Pattern:** `SPEC-[feature-id]-[feature-name].md` or just `[feature-name].md`

**Examples:**
- `SPEC-001-user-registration.md`
- `user-registration-spec.md`
- `context-linking-engine.md`

**Location:** `/specs/` directory in project root

*For complete directory structure and state transitions (proposed/ → todo/ → doing/ → done/), see [LayoutAndState.md](LayoutAndState.md) and [state-transitions.md](state-transitions.md).*

---

## Required Structure

### Document Header

```markdown
# Specification: [Feature Name]

**Feature ID:** [Unique identifier from roadmap]
**Version:** [Semantic version]
**Status:** [Draft | Review | Approved | Implemented]
**Created:** [Date]
**Author:** [Name or role]
```

**Field Definitions:**

#### Feature Name
- Matches feature name from ROADMAP.md
- Descriptive, 2-5 words
- Noun phrase

#### Feature ID
- Unique identifier (can be from roadmap or generated)
- Format: `feature_NNN` or custom scheme
- Used for linking and traceability

#### Version
- Semantic versioning (1.0, 1.1, 2.0)
- Increment on changes

#### Status
- **Draft:** Initial creation, work in progress
- **Review:** Ready for spec review
- **Approved:** Passed review, ready for implementation
- **Implemented:** Feature built and tests passing

#### Created / Author
- Metadata for tracking

---

## Section 1: Overview

```markdown
## Overview

[1-2 paragraphs describing what this feature enables and why it matters]
```

**Purpose:** High-level introduction to feature

**Content Requirements:**
- 1-2 paragraphs (concise but complete)
- Expands on roadmap description
- Explains what feature is and what it enables
- Provides context for detailed sections

**Source:** Derives from ROADMAP.md Description and Delivers fields

**Example:**
```
The Context Linking Engine automatically discovers and maintains relationships 
between specifications, tests, and implementation code. It analyzes the codebase 
to detect references based on naming conventions, decorators, and comments, storing 
the discovered links in SYSTEM_MAP.md for quick retrieval.

This feature eliminates the "where does this spec live in code?" problem that causes 
architecture amnesia, reducing time spent searching for related files from 5-30 
minutes to under 10 seconds.
```

---

## Section 2: Feature Scope

```markdown
## Feature Scope

### Included
- [Core capability 1]
- [Core capability 2]
- [Core capability 3]

### Excluded (Not in This Feature)
- [Related feature that's out of scope]
- [Adjacent capability not included]

### Deferred (Maybe in This Feature)
- [Optional enhancement if time allows]
- [Nice-to-have requiring core first]
```

**Purpose:** Define clear boundaries of what feature does and doesn't include

**Subsections:**

### 2.1 Included
**Content:** Core capabilities this feature provides
**Format:** Bulleted list
**Requirements:**
- Specific and concrete
- Observable behaviors
- 3-7 items typically

### 2.2 Excluded
**Content:** Related things explicitly NOT in this feature
**Format:** Bulleted list
**Purpose:** Prevent scope creep, clarify boundaries

### 2.3 Deferred
**Content:** Optional enhancements that might be included
**Format:** Bulleted list
**Condition:** Only if time allows after core complete

---

## Section 3: User/System Perspective

```markdown
## User/System Perspective

[Observable changes from user or system viewpoint]
```

**Purpose:** Describe external behavior (what changes)

**Content Requirements:**
- Focus on observable outcomes
- What can users do after feature exists?
- What changes in system behavior?
- No implementation details

**Example:**
```
Developers can query which code files implement a given spec, which tests cover 
a spec, and navigate between related artifacts without manual searching through 
the codebase. The system maintains these relationships automatically by analyzing 
code structure.
```

---

## Section 4: Value Delivered

```markdown
## Value Delivered

[Problem solved and improvement provided]
```

**Purpose:** Why this feature matters

**Content Requirements:**
- Problem being solved
- Improvement provided
- Quantified impact if possible
- Reference to VISION.md if applicable

**Source:** Derives from ROADMAP.md Delivers field

**Example:**
```
Eliminates the "where does this spec live in code?" problem that causes 
architecture amnesia. Reduces time spent searching for related files from 
5-30 minutes to under 10 seconds. Enables developers to quickly understand 
context without relying on memory or manual documentation.
```

---

## Section 5: Interface Contract

**Critical: This is what skeleton-writer and test-writer consume**

```markdown
## Interface Contract

[Full specification of functions/classes/APIs]
```

**Purpose:** Define exact signatures, parameters, returns, and error conditions

**Format:** One subsection per function/class/module

### For Functions:

```markdown
### Function: [function_name]([params]) -> [ReturnType]

**Purpose:** [One sentence describing what this does]

**Parameters:**
- param_name ([Type]): [Description]
  - Constraints: [Valid values, ranges, formats]
  - Example: [Concrete example value]
  - Default: [Default value if applicable]

**Returns:**
- [Type]: [Description of return value]
  - Structure: [Format or shape of return]
  - Example: [Concrete example]

**Raises:**
- ExceptionType: [Condition that triggers this exception]
- ExceptionType: [Another exception condition]

**Preconditions:**
- [What must be true before calling]
- [External state requirements]

**Postconditions:**
- [What is guaranteed after successful execution]
- [State changes that occur]
- [Invariants maintained]

**Example Usage:**
```python
# Concrete example showing typical usage
result = function_name(param="value")
# result == expected_output
```
```

### For Classes:

```markdown
### Class: [ClassName]

**Purpose:** [What this class represents or provides]

**Attributes:**
- attribute_name ([Type]): [Description]
  - Invariants: [Rules that must always hold]
  - Initial value: [What value starts as]

**Methods:**

#### __init__(self, param: Type) -> None
[Constructor specification following function format]

#### method_name(self, param: Type) -> ReturnType
[Method specification following function format]

**Invariants:**
- [Class-level invariant 1]
- [Class-level invariant 2]

**Example:**
```python
obj = ClassName(param="value")
result = obj.method_name(arg)
```
```

**Requirements for Interface Contract:**
- Every public function/method must be specified
- Every parameter must have type and description
- Every return must have type and description
- Every exception must be documented with trigger condition
- Preconditions and postconditions where relevant
- Concrete examples for complex interfaces

---

## Section 6: Acceptance Criteria

**Critical: This becomes test suite**

```markdown
## Acceptance Criteria

### Happy Path
1. ✓“ [Observable criterion that can be verified by test]
2. ✓“ [Another criterion for normal operation]
3. ✓“ [Performance criterion if applicable]

### Error Handling
4. ✓“ [Criterion for specific error case]
5. ✓“ [Criterion for validation failure]
6. ✓“ [Criterion for resource not found]

### Edge Cases
7. ✓“ [Criterion for boundary condition]
8. ✓“ [Criterion for empty/null input]
9. ✓“ [Criterion for maximum size input]
10. ✓“ [Criterion for special characters]

### Performance (if applicable)
11. ✓“ [Response time requirement]
12. ✓“ [Throughput requirement]
13. ✓“ [Resource usage requirement]

### State Management (if applicable)
14. ✓“ [Criterion for state persistence]
15. ✓“ [Criterion for idempotency]
```

**Purpose:** Define "done" - what tests must verify

**Format:**
- Numbered list (sequential)
- Checkboxes (`✓“` or `- [ ]`)
- Grouped by category

**Criteria Requirements:**

### Each Criterion Must Be:
1. **Specific:** No ambiguity about what to verify
2. **Testable:** Can write automated test that checks it
3. **Observable:** Result can be measured or inspected
4. **Independent:** Can be verified in isolation
5. **Complete:** Covers both success and failure cases

### Category Definitions:

#### Happy Path
- Normal operation with valid inputs
- Primary use cases
- Expected workflows
- 2-5 criteria typically

#### Error Handling
- Invalid inputs
- Missing resources
- Permission failures
- Exceptional conditions
- 3-7 criteria typically

#### Edge Cases
- Boundary conditions (min/max values)
- Empty or null inputs
- Special characters
- Unusual but valid cases
- 3-7 criteria typically

#### Performance (Optional)
- Response time requirements
- Throughput requirements
- Resource usage limits
- Scalability requirements
- Include only if performance is critical

#### State Management (Optional)
- State persistence
- Idempotency
- Concurrent access
- Transaction boundaries
- Include only if stateful

**Example Criteria:**

✓ Good (specific, testable):
```
1. ✓“ Scanning 10 specs and 20 code files completes in <5 seconds
2. ✓“ Raises InvalidPathError with message "Project path does not exist: [path]" for missing directories
3. ✓“ Returns empty LinkMap {"spec_id": {"code": [], "tests": []}} for specs with no implementing code
```

✗ Bad (vague, untestable):
```
1. System handles input appropriately
2. Errors are clear
3. Works for large projects
```

---

## Section 7: Scenarios

```markdown
## Scenarios

### Scenario 1: [Typical Usage Name]

**Given:**
- [Precondition 1]
- [Precondition 2]
- [Initial state]

**When:**
- [Action taken]

**Then:**
- [Expected outcome 1]
- [Expected outcome 2]
- [Final state]

### Scenario 2: [Error Case Name]

**Given:**
- [Precondition leading to error]

**When:**
- [Action that triggers error]

**Then:**
- [Expected exception type]
- [Expected error message]
- [System state remains unchanged]

### Scenario 3: [Edge Case Name]

**Given:**
- [Unusual but valid precondition]

**When:**
- [Action with edge case input]

**Then:**
- [Expected handling of edge case]
```

**Purpose:** Provide concrete examples in Given-When-Then format

**Requirements:**
- 3-7 scenarios minimum
- Cover happy path, errors, and edge cases
- Use concrete values (not variables)
- Given-When-Then structure strictly followed
- Each scenario maps to 1-3 acceptance criteria

**Scenario Coverage:**
- At least 1 happy path scenario
- At least 2 error scenarios
- At least 1 edge case scenario

**Example:**
```markdown
### Scenario 1: Basic Link Detection

**Given:**
- Project with /specs/feature_001_user_login.md
- Code file /src/auth/login.py containing "# Implements: feature_001"
- Test file /tests/test_login.py with @spec("feature_001") decorator

**When:**
- LinkingEngine.scan() is called

**Then:**
- LinkMap contains entry: "feature_001" → {"code": ["src/auth/login.py"], "tests": ["tests/test_login.py"]}
- Scan completes in <5 seconds
- No warnings or errors logged
```

---

## Section 8: Data Structures

```markdown
## Data Structures

### [DataStructureName]

**Type:** [Dictionary/List/Class/TypedDict/Dataclass/etc.]

**Structure:**
```python
{
    "field1": "type and description",
    "field2": {
        "nested_field": "type and description"
    }
}
```

**Invariants:**
- [Rule that must always be true]
- [Constraint on field values]
- [Relationship between fields]

**Example:**
```python
example_instance = {
    "field1": "example_value",
    "field2": {
        "nested_field": "example_value"
    }
}
```
```

**Purpose:** Define custom types, data models, and structures

**Requirements:**
- Every custom type must be defined
- Structure must be clear (show example)
- Invariants must be explicit
- Concrete example provided

**Common Patterns:**

### Dictionary/Map Types:
```markdown
### LinkMap

**Type:** Dictionary[str, LinkEntry]

**Structure:**
```python
{
    "spec_id_1": {"code": ["file1.py"], "tests": ["test1.py"]},
    "spec_id_2": {"code": [], "tests": ["test2.py"]}
}
```

**Invariants:**
- All spec IDs are non-empty strings
- Code and test lists may be empty but never null
- No duplicate paths within lists
```

### Dataclass Types:
```markdown
### User

**Type:** Dataclass

**Fields:**
- email (str): User email address
- password_hash (str): Hashed password
- id (Optional[int]): User ID (None before save)
- created_at (Optional[datetime]): Creation timestamp

**Invariants:**
- email is non-empty and valid format
- id is None before save, positive integer after
- created_at set on first save
```

---

## Section 9: Dependencies

```markdown
## Dependencies

### External Dependencies
- [Library/package name and version]
- [System requirement]

### Internal Dependencies
- [Other feature/module this depends on]
- [File or configuration this requires]

### Assumptions
- [What we're assuming about the environment]
- [What we're assuming about inputs]
- [What we're assuming about usage patterns]
```

**Purpose:** Document what feature needs to function

**Subsections:**

### 9.1 External Dependencies
**Content:** Libraries, frameworks, system requirements
**Format:** Bulleted list with versions
**Example:**
```
- Python 3.9+ (uses TypedDict, pathlib features)
- No external libraries required (uses stdlib only)
```

### 9.2 Internal Dependencies
**Content:** Other features or modules required
**Format:** Bulleted list
**Source:** From ROADMAP.md "Depends on" field
**Example:**
```
- User Authentication module (for session validation)
- SYSTEM_MAP.md file must be writable
- Project must follow convention: /specs directory exists
```

### 9.3 Assumptions
**Content:** What we're assuming is true
**Format:** Bulleted list
**Purpose:** Make implicit assumptions explicit
**Example:**
```
- Project uses Git (for .gitignore handling)
- Text files are UTF-8 encoded
- Project structure is relatively flat (<10 directory levels)
```

---

## Section 10: Constraints and Limitations

```markdown
## Constraints and Limitations

### Technical Constraints
- [Limitation from technology choice]
- [Performance boundary]
- [Resource limit]

### Language/Platform Constraints
- [Language-specific limitation]
- [Platform-specific limitation]

### Known Limitations
- [What this feature doesn't handle]
- [What requires manual intervention]
- [What might fail under certain conditions]

### Out of Scope
- [Related feature explicitly excluded]
- [Future enhancement not in this version]
```

**Purpose:** Be explicit about what feature doesn't do

**Subsections:**

### 10.1 Technical Constraints
**Content:** Hard limits from design or technology
**Example:**
```
- Maximum project size: 10,000 files (memory constraint)
- Maximum spec ID length: 255 characters
- Symlink depth limit: 10 levels (prevent infinite loops)
```

### 10.2 Language/Platform Constraints
**Content:** Platform-specific limitations
**Example:**
```
- Python and TypeScript only (for @spec decorator detection)
- Markdown only for spec files (.md extension)
- Unix-style paths internally (converts Windows paths)
```

### 10.3 Known Limitations
**Content:** Things feature doesn't handle
**Purpose:** Set expectations, prevent surprises
**Example:**
```
- Does not detect implicit links (e.g., inferred from variable names)
- Does not validate that linked files are correct (just finds references)
- Does not track deleted files (requires manual SYSTEM_MAP cleanup)
```

### 10.4 Out of Scope
**Content:** Explicitly excluded capabilities
**Source:** From Feature Scope → Excluded
**Example:**
```
- Cross-repository linking (multi-repo projects)
- GUI visualization (CLI only)
- Real-time monitoring (manual trigger only)
```

---

## Section 11: Implementation Notes (Optional)

```markdown
## Implementation Notes

### Suggested Approach
[High-level guidance on implementation]

### Performance Considerations
[Optimization suggestions]

### Error Handling Strategy
[Approach to error handling]

### Testing Strategy
[How to approach testing]
```

**Purpose:** Provide helpful implementation guidance (optional)

**Note:** This section is guidance, not requirements. Implementation is free to differ.

**Content:**
- Suggested algorithms or approaches
- Performance tips
- Error handling patterns
- Testing strategies

**Example:**
```markdown
### Suggested Approach
1. Use pathlib.Path for cross-platform file handling
2. Implement as generator for memory efficiency on large projects
3. Use regex for detecting comment patterns: r'#\s*(?:Implements|Spec):\s*(\w+)'

### Performance Considerations
- Read files lazily (only when needed)
- Skip binary files (check extension whitelist)
- Parallelize scan if >1000 files (use multiprocessing)
```

---

## Section 12: Open Questions

```markdown
## Open Questions

- [ ] [Question needing clarification before implementation]
- [ ] [Decision point requiring stakeholder input]
- [ ] [Technical detail to be determined]
```

**Purpose:** Track unresolved issues

**Format:** Checklist

**Content:** Questions that need answers before or during implementation

**Example:**
```
- [ ] Should we support recursive symlinks or limit depth?
- [ ] What's the exact format for spec IDs in decorators?
- [ ] Do we cache parse results between scans?
```

**Note:** Should be resolved and removed as answers found

---

## Section 13: References

```markdown
## References

- **VISION.md** - [Link to relevant section explaining why this exists]
- **SCOPE.md** - [Link to scope section this implements]
- **ROADMAP.md** - Feature [X] - [Link to roadmap entry]
- **Related Specs** - [Links to related specifications]
- **SYSTEM_MAP.md** - [Link if feature affects existing system components]
- **GUIDELINES.md** - [Link if feature uses established patterns]
```

**Purpose:** Connect spec to other documents

**Required Links:**
- ROADMAP.md (source feature)
- VISION.md (strategic context)
- SCOPE.md (boundary context)

**Optional Links:**
- Related specs
- System documentation
- Design patterns
- External references

---

## Section Ordering

**Required order:**
1. Overview
2. Feature Scope
3. User/System Perspective
4. Value Delivered
5. Interface Contract
6. Acceptance Criteria
7. Scenarios
8. Data Structures
9. Dependencies
10. Constraints and Limitations
11. Implementation Notes (optional)
12. Open Questions
13. References

**Rationale:** Flows from high-level (what/why) to detailed (how) to governance (tracking)

---

## Quality Standards

Before requesting spec review, verify completeness with [checklist-SPEC.md](checklists/checklist-SPEC.md).

### Completeness Checklist

**Document level:**
- [ ] All required sections present (1-10, 12-14)
- [ ] Header metadata complete
- [ ] Status reflects current state

**Interface Contract:**
- [ ] Every public function/method specified
- [ ] All parameters have types and descriptions
- [ ] All returns have types and descriptions
- [ ] All exceptions documented with conditions
- [ ] Examples provided for complex interfaces

**Acceptance Criteria:**
- [ ] 10-20 criteria covering happy/error/edge/performance
- [ ] Each criterion specific and testable
- [ ] Grouped by category
- [ ] Independent (no coupled criteria)

**Scenarios:**
- [ ] 3-7 scenarios minimum
- [ ] Cover happy path, errors, edges
- [ ] Given-When-Then format strictly followed
- [ ] Use concrete values

### Behavioral Focus

**MUST:**
- Describe observable behavior
- Focus on WHAT, not HOW
- Use domain language
- Include error conditions

**MUST NOT:**
- Prescribe implementation (algorithms, data structures)
- Include code snippets (except examples in Interface Contract)
- Be vague or ambiguous
- Omit error handling

### Testability

**Every acceptance criterion must:**
- Be verifiable by automated test
- Have clear pass/fail condition
- Be independent of other criteria
- Be specific enough to implement

**Scenarios must:**
- Map to acceptance criteria
- Provide concrete test cases
- Cover representative examples

---

## Common Issues

### Issue 1: Vague Acceptance Criteria
**Problem:** "System handles input appropriately"
**Impact:** Can't write tests, unclear what "appropriate" means
**Fix:** "System trims whitespace from input, converts to lowercase, rejects special characters"

### Issue 2: Missing Error Conditions
**Problem:** Only happy path specified
**Impact:** Error handling not tested
**Fix:** Add Error Handling section with 3-7 error criteria

### Issue 3: Implementation in Interface Contract
**Problem:** Specifies algorithms or data structures
**Impact:** Over-constrains implementation
**Fix:** Describe behavior (inputs/outputs/errors) not implementation

### Issue 4: Coupled Acceptance Criteria
**Problem:** "System creates user AND sends email AND logs event"
**Impact:** Can't test individually
**Fix:** Split into 3 independent criteria

### Issue 5: Missing Data Structure Definitions
**Problem:** Uses custom types without defining them
**Impact:** skeleton-writer can't create types
**Fix:** Add Data Structures section with complete definitions

---

## Downstream Usage

### skeleton-writer Consumption

**Reads from SPEC:**
- Interface Contract → Method signatures and types
- Data Structures → Type definitions
- Acceptance Criteria → Preconditions/postconditions for docstrings
- Dependencies → Constructor parameters
- Exceptions (from Interface Contract → Raises) → Custom exception types

**Creates:**
- Interface files with abstract methods
- Data type definitions (dataclass, TypedDict, etc.)
- Exception class definitions
- Main class skeletons with dependency injection

### test-writer Consumption

**Reads from SPEC:**
- Acceptance Criteria → Test cases (one test per criterion)
- Scenarios → Concrete test implementations (Given-When-Then → Arrange-Act-Assert)
- Interface Contract → Expected signatures to test against
- Data Structures → Test fixtures and mock data

**Creates:**
- Test suite with tests for all acceptance criteria
- Scenario tests matching Given-When-Then
- Edge case tests
- Error condition tests

### implementer Consumption

**Reads from SPEC:**
- Interface Contract → What to implement
- Acceptance Criteria → Definition of "done"
- Constraints and Limitations → Implementation boundaries
- Implementation Notes → Helpful guidance

**Uses:**
- Tests (from test-writer) to guide TDD
- Skeletons (from skeleton-writer) as structure

---

## Version Control

**Spec lifecycle:**
1. **Draft:** spec-writer creates initial version
2. **Review:** Spec reviewer validates completeness
3. **Approved:** Ready for skeleton/test writing
4. **Implemented:** Code complete, tests passing
5. **Updated:** Changes tracked in version control

**Update triggers:**
- Implementation reveals missing acceptance criteria
- Tests uncover spec ambiguity
- Requirements change
- Bugs reveal incomplete error handling

---

## Related Schemas

**When creating this artifact:**
- Read [schema-roadmap.md](schema-roadmap.md) for feature entry details
- Reference [schema-vision.md](schema-vision.md) for alignment and boundaries
- Reference [schema-scope.md](schema-scope.md) for scope boundaries
- Reference [schema-system-map.md](schema-system-map.md) for architectural context

**After creating this artifact:**
- Next: [schema-interface-skeleton-code.md](schema-interface-skeleton-code.md) implements interface structure
- Next: [schema-test-code.md](schema-test-code.md) verifies acceptance criteria
- Implementation: [schema-implementation-code.md](schema-implementation-code.md) satisfies tests
- Quality gate: [schema-review.md](schema-review.md) evaluates before approval

For complete schema workflow, see [schema-relationship-map.md](patterns/schema-relationship-map.md).

---

## Summary

SPEC files are behavioral contracts that define WHAT to build through:
- **Observable behavior** (not implementation)
- **Testable acceptance criteria** (definition of done)
- **Concrete scenarios** (examples in Given-When-Then)
- **Complete interfaces** (signatures, types, errors)

**Most critical for downstream:**
- Interface Contract enables skeleton-writer to create code structure
- Acceptance Criteria enables test-writer to create test suite
- Scenarios enable test-writer to create concrete test cases

**Quality principle:** If spec is ambiguous, tests will be ambiguous, and implementation will be buggy. Invest time in clear, complete, testable specifications.
