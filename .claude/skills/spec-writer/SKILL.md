---
name: spec-writer
description: Transform roadmap features into detailed, testable behavioral specifications that enable TDD. Creates SPEC files defining what to build through acceptance criteria, interface contracts, scenarios, and edge cases. Bridges high-level planning to concrete implementation.
---

# Specification Writer

Transform roadmap features into detailed specifications that define **what** to build through observable behavior, not **how** to build it. Specifications serve as authoritative contracts for test-writing and implementation.

## When to Use

**Use when:**
- Feature selected from ROADMAP.md for implementation
- Need concrete definition before writing tests
- Translating user stories into testable requirements

**Prerequisites:**
- VISION.md, SCOPE.md, ROADMAP.md exist
- Feature sequenced and ready for implementation

**Produces:** SPEC file (Markdown) with acceptance criteria, interface contracts, scenarios

## Specification Principles

### 1. Behavior-Focused (Not Implementation)

❌ Bad: "System uses HashMap with LRU eviction, capacity 1000"
✅ Good: "System retrieves sessions in O(1), supports 1000 concurrent, expires after 30min"

### 2. Observable and Verifiable

❌ Bad: "System provides pleasant login experience"  
✅ Good: "Login form loads <200ms, validation errors appear <100ms, auth completes <500ms"

### 3. Complete Acceptance Criteria

❌ Bad: "Support user registration"
✅ Good:
```
1. Accepts email format: user@domain.tld
2. Requires password: 8+ chars, uppercase, lowercase, digit
3. Returns unique user ID on success
4. Raises DuplicateEmailError if email exists
5. Raises ValidationError for invalid input
6. Sends confirmation email
```

### 4. Explicit Error Conditions

❌ Bad: "Transfer money between accounts"
✅ Good:
```
Happy: Decreases sender, increases receiver, records transaction
Errors:
- InsufficientFundsError if balance < amount
- ValidationError if amount <= 0
- AccountNotFoundError if account invalid
```

### 5. Boundaries and Edge Cases

❌ Bad: "Validate age input"
✅ Good:
```
Valid: 0-150 (inclusive)
Boundaries: 0 valid (newborn), 150 valid (upper limit)
Invalid: Negative (ValidationError), >150 (ValidationError), non-integer (ValidationError)
Edge: "  42  " → Accept after trim, "042" → Accept, "42.0" → Reject
```

## Specification Workflow

### 1. Read Roadmap Feature

Extract: name, description, why now, value delivered, dependencies, effort

### 2. Define Feature Scope

**Included:** Core capabilities  
**Excluded:** Related but out of scope  
**Deferred:** Optional enhancements

### 3. Write Behavioral Description

**Format:**
```markdown
## Feature: [Name]

### Overview
[1-2 paragraphs: what this enables]

### User/System Perspective  
[Observable changes]

### Value Delivered
[Problem solved, improvement provided]
```

### 4. Define Interface Contract

**For functions:**
```markdown
### Function: detect_links(project_path: str) -> LinkMap

**Parameters:**
- project_path (str): Root directory, must exist
  Example: "/home/user/myproject"

**Returns:**
- LinkMap: {spec_id: [code_files], ...}

**Raises:**
- InvalidPathError: If path doesn't exist
- PermissionError: If unreadable  
- ParseError: If structure invalid

**Preconditions:** project_path exists, /specs directory present
**Postconditions:** Returns complete map, no files modified
```

**For classes:**
```markdown
### Class: LinkingEngine

**Attributes:**
- project_path (str): Root directory
- link_map (LinkMap): Discovered links

**Methods:**
- scan() -> LinkMap: Scan project for links
- find_code_for_spec(spec_id: str) -> List[str]: Get implementing files
  Raises: SpecNotFoundError if invalid
```

### 5. Write Acceptance Criteria

**Format: Numbered, testable, observable**

```markdown
## Acceptance Criteria

### Happy Path
1. ✓ Scans 10 specs + 20 files in <5 seconds
2. ✓ Detects naming convention references (spec_001.py → feature_001_*.py)
3. ✓ Detects @spec decorator references
4. ✓ Returns {spec_id: {"code": [...], "tests": [...]}}

### Error Handling  
5. ✓ Raises InvalidPathError with clear message for missing path
6. ✓ Continues gracefully if individual files unreadable (logs warning)

### Edge Cases
7. ✓ Handles specs with no code (returns empty code list)
8. ✓ Handles special characters in IDs (escapes properly)
9. ✓ Ignores hidden files (starting with .)

### Performance
10. ✓ <100 files in <1 second
11. ✓ Scales linearly O(n)
```

### 6. Enumerate Scenarios (Given-When-Then)

```markdown
## Scenarios

### Scenario 1: Basic Detection

**Given:**
- /specs/feature_001_login.md
- /src/auth/login.py with "# Implements: feature_001"
- /tests/test_login.py with @spec("feature_001")

**When:** scan() called

**Then:** LinkMap contains "feature_001" → {"code": ["src/auth/login.py"], "tests": ["tests/test_login.py"]}

### Scenario 2: Error Case

**Given:** Path "/nonexistent" doesn't exist

**When:** LinkingEngine("/nonexistent").scan() called

**Then:** Raises InvalidPathError("Project path does not exist: /nonexistent")
```

### 7. Define Data Structures

```markdown
## Data Structures

### LinkMap: Dictionary[str, LinkEntry]

Structure:
{
    "spec_id": {
        "code": ["path/file.py"],
        "tests": ["path/test.py"]
    }
}

Invariants:
- spec IDs non-empty
- paths relative to project root
- lists may be empty but never null
```

### 8. Specify Dependencies

```markdown
## Dependencies

**External:** Python 3.9+ (no libraries)
**Internal:** SYSTEM_MAP.md writable, /specs directory exists
**Assumptions:** UTF-8 encoding, <10 directory levels
```

### 9. Document Constraints

```markdown
## Constraints and Limitations

**Technical:**
- Max 10,000 files (memory)
- Max 255 char spec IDs
- Symlink depth 10 levels

**Platform:** Python/TypeScript only, Markdown specs, Unix paths

**Known Limitations:**
- No implicit link detection
- No validation of correctness
- No tracking of deleted files
```

## Spec Template

```markdown
# Specification: [Feature Name]

**ID:** [roadmap-feature-id]
**Version:** 1.0
**Status:** Draft
**Created:** [date]

## Overview
[1-2 paragraphs]

## Feature Scope
### Included
- [item]
### Excluded
- [item]
### Deferred
- [item]

## User/System Perspective
[Observable behavior]

## Value Delivered
[Problem solved]

## Interface Contract
[Functions/Classes with full signatures]

## Acceptance Criteria
### Happy Path
1. ✓ [criterion]
### Error Handling
[criteria]
### Edge Cases
[criteria]
### Performance
[criteria if applicable]

## Scenarios
### Scenario 1: [Name]
**Given:** [preconditions]
**When:** [action]
**Then:** [outcome]

## Data Structures
[Custom types]

## Dependencies
**External:** [deps]
**Internal:** [deps]
**Assumptions:** [assumptions]

## Constraints and Limitations
**Technical:** [constraints]
**Known Limitations:** [limitations]

## Implementation Notes
[Guidance for implementers - optional]

## References
- ROADMAP.md - Feature [X]
- VISION.md - [section]
- SCOPE.md - [section]
```

## Best Practices

**DO:**
- Focus on observable behavior, not implementation
- Write specific, testable acceptance criteria
- Include all error cases and edge cases
- Use domain language from vision/scope
- Provide concrete Given-When-Then examples
- Define interfaces with pre/postconditions
- Quantify performance requirements ("< 100ms" not "fast")
- Leave implementation flexible

**DON'T:**
- Prescribe algorithms or data structures
- Use vague language ("user-friendly", "reliable")
- Omit error handling
- Forget boundaries and edge cases
- Write coupled criteria (split into independent)
- Assume readers know domain terms
- Over-specify (too detailed = inflexible)

## Common Pitfalls

**Vague Language:**
```
❌ "System should be user-friendly"
✅ "Display errors <100ms, require ≤3 clicks for primary workflows"
```

**Over-Specification:**
```
❌ "Call validator.validate_email(), if False create ValidationError code 400..."
✅ "Validate email format, raise ValidationError if invalid"
```

**Missing Error Cases:**
```
❌ "Upload files to server"  
✅ "Upload ≤10MB files. Errors: FileTooLargeError >10MB, InvalidFileTypeError, InsufficientStorageError"
```

**Ambiguous Criteria:**
```
❌ "System handles input appropriately"
✅ "Trim whitespace, convert to lowercase, reject special characters (!@#$%)"
```

## Integration

**Consumes:** ROADMAP.md (feature description, dependencies, effort)
**Produces:** SPEC file for skeleton-writer and test-writer
**Validates:** Spec completeness before skeleton creation

**Workflow:**
```
ROADMAP → spec-writer → SPEC → skeleton-writer → test-writer → implementer
```

## Critical Reminders

- Spec quality determines test and implementation quality
- Ambiguous specs → ambiguous tests → buggy code
- Time invested in clear specs pays off in faster implementation
- Specs are contracts: precise, testable, complete
- If unsure about detail, err on side of behavior-focused, not implementation-focused

## Related Skills

- **roadmap-planner**: Provides features to spec
- **skeleton-writer**: Consumes specs to create interfaces
- **test-review**: Uses specs to verify test completeness
- **tdd**: Implements based on spec contracts
