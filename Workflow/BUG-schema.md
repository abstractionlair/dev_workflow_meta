# Bug Report Ontology

## Purpose

Bug reports document defects in production code. Unlike specifications (which define new behavior), bugs describe incorrect existing behavior and guide fixes. This ontology defines the structure and validation rules for bug reports.

## Document Structure

### Required Sections

#### Title
Clear, specific description of the bug.

**Pattern:** `[Component] Brief description`

**Examples:**
- `[Validation] Empty email passes validation`
- `[Auth] SQL injection in email lookup`
- `[Session] Race condition on concurrent updates`

#### Observed Behavior
What currently happens (incorrect).

**Must include:**
- Specific symptoms
- Error messages if any
- When/where it occurs

**Example:**
```markdown
## Observed Behavior
Empty string passes email validation and causes database constraint violation downstream.
When calling `validate_email("")`, the function returns `(True, None)` instead of rejecting the input.
```

#### Expected Behavior
What should happen instead.

**Must be:**
- Clear and specific
- Based on existing specs if applicable
- Testable

**Example:**
```markdown
## Expected Behavior
Empty string should be rejected with clear error message: "Email cannot be empty"
Function should return `(False, "Email cannot be empty")`.
```

#### Steps to Reproduce
How to trigger the bug.

**Format:**
1. Action one
2. Action two
3. Observe result

**Good example:**
```markdown
## Steps to Reproduce
1. Call `validate_email("")`
2. Observe returns `(True, None)`
3. Try to save user with empty email to database
4. Database raises constraint violation error
```

**Bad example:**
```markdown
## Steps to Reproduce
Sometimes email validation fails
```

#### Impact
Why this matters and how urgent.

**Must include:**
- Severity (Critical/High/Medium/Low)
- User impact
- System impact
- Security implications if any

**Example:**
```markdown
## Impact
**Severity:** High

- Users can submit forms with empty emails
- Causes 500 errors at database layer
- Poor error messaging for users
- Affects registration and profile update flows
```

**Severity Guidelines:**
- **Critical:** System unusable, data loss, security breach
- **High:** Major feature broken, significant user impact
- **Medium:** Feature degraded, workaround exists
- **Low:** Minor issue, cosmetic, edge case

### Optional Sections (Added During Fix)

#### Root Cause
Added by Implementer after investigation.

Explains what caused the bug at the code level.

**Example:**
```markdown
## Root Cause
Email validation checked for @-symbol before checking if string was empty. 
Empty string has no @-symbol, so the function proceeded to check other format 
rules and incorrectly returned success.

Problematic code in src/utils/validation.py:
\```python
def validate_email(email: str) -> tuple[bool, Optional[str]]:
    if "@" not in email:  # Fails on empty string
        return (False, "Invalid email format")
    # Empty string bypasses this check
    return (True, None)
\```
```

#### Fix
Added by Implementer after fixing.

Documents the solution and related changes.

**Must include:**
- Summary of code changes
- Commit reference (added after commit)
- Sentinel test location
- GUIDELINES.md updates (if any)

**Example:**
```markdown
## Fix
Added empty string check as first validation step before any format checks.

**Changes:**
- `src/utils/validation.py`: Added empty/null check at function start
- `tests/regression/test_validation_empty_email.py`: Sentinel test added
- `GUIDELINES.md`: Added "Validate empty/null inputs first" pattern

**Commit:** abc123def456

**Sentinel test:** `tests/regression/test_validation_empty_email.py`

**Verification:**
- Sentinel test fails on old code ✓
- Sentinel test passes on fixed code ✓
- All other tests still pass ✓
```

## File Metadata

### Filename Convention
`<component>-<brief-description>.md`

**Rules:**
- Use kebab-case
- Be specific but concise
- Component should match module/area name

**Examples:**
- `validation-empty-email.md`
- `auth-sql-injection.md`
- `session-race-condition.md`

### Frontmatter
```yaml
---
reported: YYYY-MM-DD
reported_by: human | <agent-name>
severity: critical | high | medium | low
status: to_fix | fixing | fixed
fixed: YYYY-MM-DD  # Added when moved to fixed
---
```

## State Lifecycle

Bug reports move through three states:

```
bugs/to_fix/     [Implementer starts]
    ↓
bugs/fixing/     [Implementation Reviewer approves]
    ↓
bugs/fixed/
```

### State Transitions

**to_fix → fixing:**
- Implementer moves file when starting work
- Creates bugfix branch
- Begins investigation

**fixing → fixed:**
- Implementation Reviewer moves file after approval
- Updates status to "fixed"
- Adds fixed date to frontmatter
- Merges to main

## Validation Rules

### Required for to_fix state:
- ✓ Title following `[Component] Description` pattern
- ✓ Observed Behavior (what's wrong)
- ✓ Expected Behavior (what should happen)
- ✓ Steps to Reproduce (how to trigger)
- ✓ Impact with severity

### Required before moving to fixed:
- ✓ Root Cause section (added by Implementer)
- ✓ Fix section (added by Implementer)
- ✓ Sentinel test created in tests/regression/
- ✓ Status updated to "fixed"
- ✓ Fixed date in frontmatter

## Complete Examples

### Minimal Bug Report (to_fix)

```markdown
---
reported: 2025-10-23
reported_by: human
severity: high
status: to_fix
---

# [Validation] Empty Email Passes Validation

## Observed Behavior
Empty string passes email validation and causes database constraint violation downstream.

When calling `validate_email("")`, the function returns `(True, None)` instead of 
rejecting the input. This allows forms to be submitted with empty emails, which 
later fail at the database layer with a constraint violation.

## Expected Behavior
Empty string should be rejected with clear error message.

Function should return `(False, "Email cannot be empty")`.

## Steps to Reproduce
1. Call `validate_email("")`
2. Observe returns `(True, None)`
3. Attempt to save user with empty email: `user_repo.save(User(email=""))`
4. Database raises constraint violation: `NOT NULL constraint failed: users.email`

## Impact
**Severity:** High

- Users can submit registration/update forms with empty emails
- Causes 500 errors at database layer instead of clear validation error
- Poor user experience (generic error instead of "email required")
- Affects user registration, profile updates, and email change flows
```

### Complete Bug Report (fixed)

```markdown
---
reported: 2025-10-23
reported_by: human
severity: high
status: fixed
fixed: 2025-10-24
---

# [Validation] Empty Email Passes Validation

## Observed Behavior
Empty string passes email validation and causes database constraint violation downstream.

When calling `validate_email("")`, the function returns `(True, None)` instead of 
rejecting the input. This allows forms to be submitted with empty emails, which 
later fail at the database layer with a constraint violation.

## Expected Behavior
Empty string should be rejected with clear error message.

Function should return `(False, "Email cannot be empty")`.

## Steps to Reproduce
1. Call `validate_email("")`
2. Observe returns `(True, None)`
3. Attempt to save user with empty email: `user_repo.save(User(email=""))`
4. Database raises constraint violation: `NOT NULL constraint failed: users.email`

## Impact
**Severity:** High

- Users can submit registration/update forms with empty emails
- Causes 500 errors at database layer instead of clear validation error
- Poor user experience (generic error instead of "email required")
- Affects user registration, profile updates, and email change flows

## Root Cause
Email validation in `src/utils/validation.py` checked for @-symbol presence before 
checking if the string was empty. Since empty string contains no @-symbol, the 
validation incorrectly proceeded past this check and returned success.

Problematic code:
\```python
def validate_email(email: str) -> tuple[bool, Optional[str]]:
    if "@" not in email:
        return (False, "Invalid email format")
    # Empty string has no @ but this check doesn't catch it
    # Function continues and eventually returns success
    return (True, None)
\```

The function assumed any string without @ was "invalid format" but didn't distinguish
between empty input and malformed input.

## Fix
Added explicit empty/null check as the first validation step, before any format checks.

**Changes:**
- `src/utils/validation.py`: Added empty string check at function entry
  \```python
  def validate_email(email: str) -> tuple[bool, Optional[str]]:
      if not email:  # Check empty first
          return (False, "Email cannot be empty")
      if "@" not in email:
          return (False, "Invalid email format")
      # ... rest of validation
  \```

- `tests/regression/test_validation_empty_email.py`: Added sentinel test
- `GUIDELINES.md`: Added pattern "Validate empty/null inputs first" with explanation

**Commit:** abc123def456

**Sentinel test location:** `tests/regression/test_validation_empty_email.py`

**Verification:**
- Ran sentinel test against old code: FAILED ✓
- Ran sentinel test against new code: PASSED ✓
- Ran full test suite: All tests pass ✓
- Manual verification: `validate_email("")` now returns `(False, "Email cannot be empty")` ✓
```

## Anti-Patterns

### ❌ Vague Description
```markdown
# Email Validation Bug
Email validation is broken
```
**Problem:** Not specific enough to reproduce or understand impact

**Better:**
```markdown
# [Validation] Empty Email Passes Validation
Empty strings incorrectly pass validation, causing database errors
```

### ❌ Missing Reproduction Steps
```markdown
## Steps to Reproduce
Sometimes the validation crashes when checking emails
```
**Problem:** Can't reproduce, can't fix

**Better:**
```markdown
## Steps to Reproduce
1. Call validate_email("") with empty string
2. Observe returns (True, None)
3. System allows empty email to reach database
```

### ❌ No Impact Assessment
```markdown
## Impact
This is bad and should be fixed
```
**Problem:** No severity, no urgency guidance, no scope understanding

**Better:**
```markdown
## Impact
**Severity:** High
- Affects all user registration and profile update flows
- Causes 500 errors for users
- Security concern: allows invalid data in database
```

### ❌ Premature Solutions
```markdown
## Problem
Email validation broken

## Solution Needed
We need to rewrite the entire validation module using a library
```
**Problem:** Bug report should describe problem, not prescribe solution

**Better:** Describe observed vs expected behavior, let Implementer determine solution

### ❌ Multiple Bugs in One Report
```markdown
# Various Validation Issues
1. Empty emails pass
2. Special characters break validation
3. International domains not supported
```
**Problem:** Each bug needs separate investigation, fix, and testing

**Better:** One bug report per issue

## Integration with Workflow

### Bug Discovery (Human)
1. Human notices incorrect behavior
2. Human creates bug report in `bugs/to_fix/` using this ontology as template
3. Human can use Bug Recorder role for guided bug reporting
4. Human assigns to Implementer (or just notifies them)

### Bug Investigation (Implementer)
1. Implementer reads bug report
2. Moves to `bugs/fixing/` when starting work
3. Investigates and adds Root Cause section
4. Fixes bug and adds Fix section
5. Creates sentinel test referencing bug report

### Bug Review (Implementation Reviewer)
1. Reviews bug report completeness
2. Verifies fix addresses root cause
3. Checks sentinel test quality
4. Moves to `bugs/fixed/` after approval
5. Updates status and adds fixed date

### Historical Record
- Bug reports in `bugs/fixed/` are never deleted
- They serve as institutional memory
- Sentinel tests reference them
- GUIDELINES.md may reference patterns from bugs

## Usage Notes

**For Bug Reporters:**
- Focus on observed behavior, not theories about cause
- Be specific in reproduction steps
- Assess impact honestly
- Don't prescribe solutions
- One bug per report

**For Implementers:**
- Add Root Cause only after investigation (don't guess)
- Document Fix thoroughly for future reference
- Update GUIDELINES.md if bug reveals pattern worth avoiding
- Ensure sentinel test actually catches the bug

**For Reviewers:**
- Verify bug report completeness
- Check that root cause makes sense
- Ensure fix addresses root cause (not just symptoms)
- Confirm sentinel test would have caught bug

## Relationship to Other Artifacts

**vs. SPEC files:**
- Specs define new behavior
- Bugs fix incorrect existing behavior
- Bugs are lightweight (no skeleton, simpler tests)

**vs. GUIDELINES.md:**
- Bugs are specific instances
- GUIDELINES captures patterns from multiple bugs
- Bug may lead to GUIDELINES.md update

**vs. Sentinel tests:**
- Bug report explains what/why
- Sentinel test prevents recurrence
- Test references bug report for context

**vs. Git history:**
- Bug report is structured documentation
- Git commit message links to bug report
- Together they provide complete history
