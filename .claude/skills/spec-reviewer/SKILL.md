---
name: spec-reviewer
description: Review SPEC files for completeness, testability, and clarity before skeleton/test creation. Validates specifications against SPEC-ontology.md. Use after spec-writer produces draft SPEC.md, before skeleton-writer and test-writer begin work.
---

# Specification Reviewer

Review specifications to ensure they're complete, testable, and ready for implementation.

## When to Use

**Use when:**
- SPEC.md drafted and needs validation
- Before skeleton-writer creates interfaces
- Before test-writer creates tests

**Prerequisites:**
- Draft SPEC.md exists
- ROADMAP.md approved (for alignment check)

**Produces:** Review decision (APPROVED / NEEDS-CHANGES) with specific feedback

## Review Principles

### 1. Ontology Compliance
- All required sections present
- Interface contracts complete
- Acceptance criteria structured correctly

### 2. Testability
- Every requirement is verifiable
- Acceptance criteria can become tests
- Scenarios provide concrete examples

### 3. Clarity
- No ambiguous language
- Behavior-focused (WHAT not HOW)
- Examples concrete

### 4. Completeness
- Happy path + error cases + edge cases
- All exceptions documented
- Dependencies specified

### 5. Alignment
- Matches roadmap feature
- Interface contracts support acceptance criteria
- Scenarios match criteria

## Review Workflow

### Step 1: Load References
- Read SPEC-ontology.md (structure reference)
- Read ROADMAP.md feature entry (alignment check)

### Step 2: Check Structure

**Required sections (14 total):**
- [ ] 1. Overview
- [ ] 2. Feature Scope
- [ ] 3. User/System Perspective
- [ ] 4. Value Delivered
- [ ] 5. Interface Contract ⚠️ CRITICAL
- [ ] 6. Acceptance Criteria ⚠️ CRITICAL
- [ ] 7. Scenarios ⚠️ CRITICAL
- [ ] 8. Data Structures
- [ ] 9. Dependencies
- [ ] 10. Constraints and Limitations
- [ ] 11. Implementation Notes (optional)
- [ ] 12. Open Questions
- [ ] 13. References
- [ ] 14. Changelog

### Step 3: Review Interface Contract (CRITICAL)

**For each function/method, check:**
- [ ] Function signature with types
- [ ] All parameters documented
- [ ] Return type documented
- [ ] All exceptions documented with conditions
- [ ] Preconditions stated
- [ ] Postconditions stated
- [ ] Example usage provided

**Common issues:**
```
❌ Bad: Missing types
def process(data):
    """Process data."""

✅ Good: Complete contract
def process(data: List[int]) -> ProcessingResult:
    """
    Process list of integers.
    
    Args:
        data: Non-empty list of integers
        
    Returns:
        ProcessingResult with statistics
        
    Raises:
        ValueError: If data is empty
        TypeError: If data contains non-integers
        
    Preconditions:
        - data is not None
        
    Postconditions:
        - Result contains count, sum, average
    """
```

### Step 4: Review Acceptance Criteria (CRITICAL)

**Check criteria quality:**
- [ ] 10-20 criteria minimum
- [ ] Grouped by category (Happy/Error/Edge/Performance)
- [ ] Each criterion specific and testable
- [ ] Each criterion independent
- [ ] No vague language

**Test each criterion:**
```
Can I write a test for this?
✅ "Scans 10 specs + 20 files in <5 seconds" (YES - measurable)
❌ "System handles input appropriately" (NO - vague)
```

**Check categories:**
- [ ] Happy Path: 2-5 criteria for normal operation
- [ ] Error Handling: 3-7 criteria for exceptions
- [ ] Edge Cases: 3-7 criteria for boundaries
- [ ] Performance: Present if performance critical
- [ ] State Management: Present if stateful

**Common issues:**
```
❌ Vague: "System works correctly"
✅ Specific: "Returns UserID >0 for successful registration"

❌ Coupled: "System creates user AND sends email AND logs event"
✅ Independent: 
  1. Creates user record in database
  2. Sends welcome email to user
  3. Logs registration event to audit log
```

### Step 5: Review Scenarios (CRITICAL)

**Check scenario quality:**
- [ ] 3-7 scenarios minimum
- [ ] Cover happy path, errors, edge cases
- [ ] Given-When-Then format strictly followed
- [ ] Use concrete values (not variables)
- [ ] Each scenario maps to 1-3 acceptance criteria

**Check Given-When-Then structure:**
```markdown
### Scenario: [Descriptive Name]

**Given:**
- [Concrete precondition 1]
- [Concrete precondition 2]

**When:**
- [Single action]

**Then:**
- [Observable outcome 1]
- [Observable outcome 2]
```

**Common issues:**
```
❌ Bad: Vague values
**Given:** User exists
**When:** Login attempted
**Then:** Success

✅ Good: Concrete values
**Given:**
- User "alice@example.com" exists with password hash
- Session table is empty

**When:**
- POST /login with {"email": "alice@example.com", "password": "SecurePass123"}

**Then:**
- Returns 200 OK with session token
- Session record created in database
- User.last_login updated to current timestamp
```

### Step 6: Review Data Structures

**Check each custom type:**
- [ ] Type name defined
- [ ] Structure shown (example or schema)
- [ ] Invariants documented
- [ ] Concrete example provided

**Example check:**
```
✅ Good:
### LinkMap: Dictionary[str, LinkEntry]

Structure:
{
    "spec_id": {"code": ["file.py"], "tests": ["test.py"]}
}

Invariants:
- spec IDs are non-empty strings
- lists may be empty but never null

❌ Bad:
### LinkMap
A map of links (no structure shown)
```

### Step 7: Check Behavioral Focus

**Verify spec describes WHAT, not HOW:**

```
❌ Bad (implementation):
"System uses HashMap with LRU eviction, capacity 1000"

✅ Good (behavior):
"System retrieves sessions in O(1), supports 1000 concurrent, expires after 30min"
```

**Red flags:**
- Mentions specific libraries (PostgreSQL, Redis)
- Describes algorithms (bubble sort, binary search)
- Specifies data structures (HashMap, LinkedList)
- Includes code snippets (except in examples)

### Step 8: Verify Alignment

**Check against roadmap feature:**
- [ ] Feature name matches
- [ ] Description aligns
- [ ] Dependencies match
- [ ] Scope consistent

**Check references:**
- [ ] Links to ROADMAP.md correct
- [ ] Links to VISION.md correct
- [ ] Links to SCOPE.md correct

### Step 9: Assess Completeness

**Error handling:**
- [ ] All error conditions specified
- [ ] Exception types defined
- [ ] Error messages described

**Edge cases:**
- [ ] Boundaries identified (min/max values)
- [ ] Empty/null input handling
- [ ] Special characters handling
- [ ] Large input handling

**Dependencies:**
- [ ] External dependencies listed
- [ ] Internal dependencies listed
- [ ] Assumptions stated

## Review Output Format

```markdown
# Spec Review: [Feature Name]

**Reviewer:** [Your name/Claude]
**Date:** [YYYY-MM-DD]
**Spec:** [filename]
**Version:** [version]
**Status:** APPROVED | NEEDS-CHANGES

## Summary
[Overall assessment - 1-2 paragraphs]

## Ontology Compliance
- ✅/❌ All 14 sections present
- ✅/❌ Interface Contract complete
- ✅/❌ Acceptance Criteria testable
- ✅/❌ Scenarios in Given-When-Then format

## Testability Assessment
- ✅/❌ All criteria can become tests
- ✅/❌ Scenarios provide concrete examples
- ✅/❌ Happy/Error/Edge cases covered
- ✅/❌ Every requirement verifiable

## Behavioral Focus
- ✅/❌ Describes WHAT not HOW
- ✅/❌ No implementation details leaked
- ✅/❌ Observable behavior specified

## Critical Issues (if NEEDS-CHANGES)
1. **[Issue Title]**
   - Section: [Interface Contract / Acceptance Criteria / etc]
   - Problem: [What's wrong]
   - Impact: [Why this matters]
   - Fix: [How to resolve]

## Minor Issues
[Non-blocking issues that would improve quality]

## Strengths
[What the spec does well]

## Decision
[APPROVED - ready for skeleton-writer and test-writer]
[NEEDS-CHANGES - address critical issues above]
```

## Common Issues

### Issue 1: Incomplete Interface Contract
```
Problem: Function missing return type or exceptions
Impact: skeleton-writer can't create complete signature
Fix: Add missing types, exceptions, pre/postconditions
```

### Issue 2: Vague Acceptance Criteria
```
Problem: "System handles errors appropriately"
Impact: Can't write tests, ambiguous requirements
Fix: "Raises ValidationError with message 'Invalid email format' for malformed emails"
```

### Issue 3: Missing Error Cases
```
Problem: Only happy path specified
Impact: Incomplete test coverage, bugs in production
Fix: Add Error Handling section with 3-7 error criteria
```

### Issue 4: Scenarios Use Variables
```
Problem: "Given: User exists, When: Login, Then: Success"
Impact: Not concrete enough for tests
Fix: Use actual values (emails, IDs, timestamps)
```

### Issue 5: Implementation Leakage
```
Problem: "Use PostgreSQL with connection pooling"
Impact: Over-constrains implementation
Fix: "Persist user data to storage (retrieve by ID)"
```

## Best Practices

**DO:**
- Check ontology first (structure)
- Verify testability obsessively
- Ensure Given-When-Then concrete
- Confirm all exceptions documented
- Approve when ready (don't block on minor)

**DON'T:**
- Skip critical sections (Interface/Criteria/Scenarios)
- Accept vague criteria
- Allow implementation details
- Require perfection (good enough is enough)
- Review for style over substance

## Integration

**Consumes:**
- SPEC.md (draft to review)
- SPEC-ontology.md (validation reference)
- ROADMAP.md (alignment check)

**Produces:**
- Review document with decision
- Specific feedback

**Workflow Position:**
```
roadmap-planner → ROADMAP.md ✓
  ↓
spec-writer → SPEC.md (draft)
  ↓
spec-reviewer → Review SPEC.md ⬅ YOU ARE HERE
  ↓ (if APPROVED)
skeleton-writer → Code skeletons
  ↓
test-writer → Tests
```

## Critical Reminders

- Interface Contract must be complete (skeleton-writer needs it)
- Acceptance Criteria must be testable (test-writer needs it)
- Scenarios must be concrete (test-writer needs it)
- Check behavioral focus (no implementation details)
- Verify alignment with roadmap feature

**Most critical:** If spec is ambiguous, tests will be ambiguous, and implementation will be buggy. Invest time ensuring clarity!

## Related Skills

- **spec-writer**: Produces SPEC.md to review
- **skeleton-writer**: Consumes approved spec
- **test-writer**: Consumes approved spec
- **SPEC-ontology.md**: Validation reference
