---
role: Implementation Reviewer
trigger: After implementation complete and tests pass (GREEN)
typical_scope: One feature implementation
dependencies: [SPEC from specs/doing/, implementation files, test files, SYSTEM_MAP.md, GUIDELINES.md, schema-implementation-code.md, bugs/fixed/]
outputs: [reviews/implementations/TIMESTAMP-FEATURE-STATUS.md]
gatekeeper: true
state_transition: doing → done (moves spec on approval)
---

# Implementation Reviewer

*Structure reference: [role-file-structure.md](patterns/role-file-structure.md)*

## Purpose

Review implementations after tests pass (TDD GREEN/REFACTOR phase) to verify spec compliance, code quality, security, and maintainability before merge. Approval is the final quality gate. Passing tests don't guarantee good code - reviews catch what tests miss.

## Collaboration Pattern

This is an **independent role** - work separately from implementer.

**Responsibilities:**
- Verify spec compliance
- Check code quality and maintainability
- Validate architectural adherence
- Ensure security best practices
- Approve or request changes
- **Gatekeeper**: Move spec from `doing/` to `done/` when approved

**Review flow:**
1. Implementer marks implementation ready
2. Read spec, tests, and implementation independently
3. Provide structured feedback
4. Implementer addresses issues
5. Approve when quality bar met
6. Move spec to `done/`, ready for merge

## Inputs

**Code under review:**
- Implementation files
- Test files (should be unmodified)

**References:**
- SPEC from `specs/doing/`
- Skeleton code (original interfaces)
- SYSTEM_MAP.md - Architecture patterns
- GUIDELINES.md - Code conventions and architectural constraints
- [schema-implementation-code.md](schema-implementation-code.md) - Implementation standards
- bugs/fixed/ - Sentinel tests in tests/regression/

## Process

### Step 1: Verify All Tests Pass

**Critical first check:**
```bash
# Run all tests
pytest tests/ -v

# Verify: All tests GREEN
```

**If any tests fail:**
❌ REJECT immediately - implementation not complete

### Step 2: Check Test Integrity

**Verify tests were not modified:**
```bash
# Compare tests to approved version
git diff origin/main tests/test_feature.py
```

**If tests modified:**
- Acceptable: Bug fixes with re-review approval
- Unacceptable: Changes to make tests pass

**Red flag:**
```diff
- assert result.status == "success"
+ assert result.status in ["success", "ok"]  # ❌ Weakened test
```

### Step 3: Verify Spec Compliance

For each acceptance criterion:
- [ ] Corresponding implementation exists
- [ ] Behavior matches specification
- [ ] All edge cases handled
- [ ] All error conditions handled
- [ ] Performance requirements met (if specified)

See [schema-implementation-code.md](schema-implementation-code.md) for complete implementation standards.

**Check method:**
1. Read spec requirement
2. Find implementation code
3. Verify behavior matches
4. Check test exists and passes
5. Flag any discrepancies

### Step 4: Check Code Quality

**Readability:**
- [ ] Clear variable and function names
- [ ] Logical code organization
- [ ] Appropriate comments (why, not what)
- [ ] Consistent formatting

**Maintainability:**
- [ ] Functions are focused (single responsibility)
- [ ] No code duplication
- [ ] Reasonable complexity
- [ ] Easy to understand and modify

**Example issues:**
```python
# ❌ Unclear names
def process(d):
    r = calc(d)
    return r

# ✓ Clear names
def calculate_discount(price: float) -> float:
    discount_amount = price * self.discount_rate
    return discount_amount
```

### Step 5: Verify Architectural Adherence

Check against GUIDELINES.md and SYSTEM_MAP.md. See [schema-implementation-code.md](schema-implementation-code.md) for architectural standards.

- [ ] No forbidden imports
- [ ] Layer boundaries respected
- [ ] No global state
- [ ] Dependency injection used
- [ ] No hard-coded dependencies
- [ ] Follows naming conventions
- [ ] Uses standard utilities
- [ ] Matches organizational patterns
- [ ] Consistent with similar features

### Step 6: Security Review

**Check for common vulnerabilities:**
- [ ] No SQL injection vectors
- [ ] No command injection vectors
- [ ] Input validation present
- [ ] Sensitive data not logged
- [ ] Passwords/secrets hashed/encrypted
- [ ] No hard-coded credentials

**Example issues:**
```python
# ❌ SQL injection
query = f"SELECT * FROM users WHERE email = '{email}'"

# ✓ Parameterized query
query = "SELECT * FROM users WHERE email = ?"
db.execute(query, (email,))

# ❌ Logging sensitive data
logger.info(f"User {email} logged in with password {password}")

# ✓ Safe logging
logger.info(f"User {email} logged in successfully")
```

### Step 7: Check Error Handling

**Verify:**
- [ ] All exceptions from spec raised
- [ ] Error messages helpful
- [ ] Resources cleaned up (try/finally)
- [ ] No swallowed exceptions

**Example issues:**
```python
# ❌ Swallowing exceptions
try:
    process_payment(amount)
except Exception:
    pass  # Silent failure

# ✓ Proper handling
try:
    process_payment(amount)
except PaymentError as e:
    logger.error(f"Payment failed: {e}")
    raise
```

### Step 8: Performance Review

**Check for obvious inefficiencies:**
- [ ] No N+1 queries
- [ ] Appropriate data structures
- [ ] No unnecessary loops
- [ ] Database indexes considered (if applicable)

### Step 9: Check for Duplication

**Verify:**
- [ ] No copy-pasted code
- [ ] Common logic extracted
- [ ] Uses existing utilities
- [ ] DRY principle followed

### Step 10: Check Bug-Related Updates

**Check implementation avoids past bugs:**
- [ ] Known anti-patterns not used
- [ ] Historical bug patterns avoided
- [ ] Sentinel tests still passing

### Step 11: Write Review

Use structured format (see Outputs section).

## Outputs

**Review document:** `reviews/implementations/YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md`

Where STATUS ∈ {APPROVED, NEEDS-CHANGES}

**Review template:**
```markdown
# Implementation Review: [Feature Name]

**Reviewer:** [Your name/role]
**Date:** YYYY-MM-DD HH:MM:SS
**Spec:** specs/doing/[feature].md
**Implementation:** [files reviewed]
**Tests:** [All passing ✓ / Some failing ❌]
**Status:** APPROVED | NEEDS-CHANGES

## Summary
[2-3 sentence overall assessment]

## Test Verification
- ✓/❌ All tests passing
- ✓/❌ Tests unmodified (no weakening)
- ✓/❌ Test integrity maintained

## Spec Compliance
- ✓/❌ All acceptance criteria met
- ✓/❌ All edge cases handled
- ✓/❌ All error conditions handled
- ✓/❌ Performance requirements met

## Code Quality
- ✓/❌ Clear and readable
- ✓/❌ Well-organized
- ✓/❌ Maintainable
- ✓/❌ No duplication

## Architecture
- ✓/❌ Follows GUIDELINES.md
- ✓/❌ Respects SYSTEM_MAP.md
- ✓/❌ Uses dependency injection
- ✓/❌ Layer boundaries respected

## Security
- ✓/❌ Input validation present
- ✓/❌ No injection vulnerabilities
- ✓/❌ Sensitive data protected
- ✓/❌ No hard-coded secrets

## Critical Issues (if NEEDS-CHANGES)

### Issue 1: [Title]
- **Location:** [file:line]
- **Problem:** [What's wrong]
- **Impact:** [Why this matters]
- **Fix:** [Concrete solution with example]

## Minor Issues
[Non-blocking improvements]

## Positive Notes
[What's done well]

## Decision

**[APPROVED]** - Ready for merge. Implementation reviewer should now:
1. Move spec: `git mv specs/doing/[name].md specs/done/[name].md`
2. Commit spec transition
3. Approve pull request for merge to main

**[NEEDS-CHANGES]** - Address critical issues above before merge
```

## Common Issues

### Issue 1: Spec Requirement Missing
```
Problem: Spec requires ValidationError for invalid email, not implemented
Impact: Spec not fully satisfied
Fix: Add validation check with proper exception
```

### Issue 2: Test Weakened
```
Problem: Test changed from exact match to "in" check
Impact: Test less strict, implementation may be wrong
Fix: Revert test change, fix implementation properly
```

### Issue 3: Architectural Violation
```
Problem: Service layer directly imports PostgresDB
Impact: Violates GUIDELINES.md, couples to specific DB
Fix: Use repository interface from skeleton
```

### Issue 4: Security Issue
```
Problem: SQL query uses string formatting
Impact: SQL injection vulnerability
Fix: Use parameterized queries
```

### Issue 5: Performance Problem
```
Problem: N+1 query in loop
Impact: Slow performance with many records
Fix: Batch query outside loop
```

### Issue 6: Code Duplication
```
Problem: Validation logic repeated in 3 places
Impact: Hard to maintain, violates DRY
Fix: Extract to shared utility function
```

## Examples

### Example 1: APPROVED Review

```markdown
# Implementation Review: User Registration

**Status:** APPROVED

## Summary
Excellent implementation. Spec fully satisfied, clean code, proper architecture.
All tests passing, no security issues. Ready for merge.

## Spec Compliance
- ✓ Email validation implemented
- ✓ Password hashing used (bcrypt)
- ✓ DuplicateEmailError raised correctly
- ✓ Welcome email sent

## Code Quality
- ✓ Clear variable names
- ✓ Proper error handling
- ✓ No duplication

## Architecture
- ✓ Dependency injection used
- ✓ Repository pattern followed
- ✓ Layer boundaries respected

## Positive Notes
- Excellent use of existing utilities
- Clean separation of concerns
- Comprehensive error messages

## Decision
APPROVED - Move spec to done/, merge to main
```

### Example 2: NEEDS-CHANGES Review

```markdown
# Implementation Review: Payment Processing

**Status:** NEEDS-CHANGES

## Summary
Core logic correct but has critical security issue and architectural violation.
Tests passing but implementation needs fixes before merge.

## Critical Issues

### Issue 1: SQL Injection Vulnerability
- **Location:** src/services/payment.py:45
- **Problem:** Using string formatting for SQL query
  ```python
  query = f"UPDATE accounts SET balance = {new_balance} WHERE id = {account_id}"
  ```
- **Impact:** Critical security vulnerability
- **Fix:** Use parameterized query
  ```python
  query = "UPDATE accounts SET balance = ? WHERE id = ?"
  db.execute(query, (new_balance, account_id))
  ```

### Issue 2: Direct Database Import
- **Location:** src/services/payment.py:5
- **Problem:** `from internal.db import PostgresDB`
- **Impact:** Violates GUIDELINES.md, couples to Postgres
- **Fix:** Use repository interface from skeleton
  ```python
  # Constructor should inject repository
  def __init__(self, account_repo: AccountRepository):
      self.account_repo = account_repo
  ```

## Decision
NEEDS-CHANGES - Fix 2 critical issues above before merge
```

## Bug Fix Review Process (Alternative Workflow)

When reviewing bug fixes (instead of feature implementations), use this lighter process.

### Triggered By: Bugfix branch ready for review

Bug fixes are simpler than feature implementations - no spec, no skeleton, lighter testing.

### Process

#### Step 1: Read Bug Report
Read `bugs/fixing/<bug>.md` thoroughly to understand observed vs expected behavior, reproduction steps, and severity.

#### Step 2: Verify Root Cause
Check Root Cause section makes sense, points to specific code location, and explains mechanism (not just symptoms).

#### Step 3: Review Fix Code
Standard code review focused on fix:
- [ ] Fix addresses root cause directly
- [ ] Minimal changes (no scope creep)
- [ ] Follows GUIDELINES.md
- [ ] No new issues introduced

#### Step 4: Review Sentinel Test ⚠ CRITICAL

**Purpose:** Sentinel tests prevent regression. They MUST fail on old code and pass on new code, proving they catch the bug.

**Sentinel test requirements:**
- [ ] Test has detailed comment explaining bug (number, description, reproduction)
- [ ] Test is specific to THIS bug (not generic smoke test)
- [ ] Test is simple and focused
- [ ] Test name references bug number (`test_bug_123_description`)

**Verify Test FAILS on Old Code:**
```bash
# Find parent of fix commit
FIX_COMMIT=$(git log --oneline --grep="BUG-123" -n 1 | awk '{print $1}')
PARENT_COMMIT=$(git rev-parse $FIX_COMMIT^)

# Checkout pre-fix code and run sentinel test (should FAIL)
git checkout $PARENT_COMMIT
pytest tests/regression/test_bug_123.py -v
# Expected: FAILED with specific assertion error
```

**If test PASSES on old code:**
```
❌ CRITICAL: Sentinel test doesn't catch the bug
   Possible causes:
   1. Test doesn't trigger bug condition
   2. Test assertion too weak
   3. Test mocks away the bug
   Fix: Update test to specifically catch this bug
```

**Verify Test PASSES on New Code:**
```bash
# Checkout fix commit and run sentinel test (should PASS)
git checkout $FIX_COMMIT
pytest tests/regression/test_bug_123.py -v
# Expected: PASSED
```

**Good sentinel test example:**
```python
def test_bug_123_empty_email_validation():
    """
    Sentinel for BUG-123: Empty email bypassed validation.

    Bug: validate_email("") returned (True, None) instead of
    (False, "Email cannot be empty").

    Steps to reproduce:
    1. Call validate_email with empty string
    2. Observed: validation passed
    3. Expected: validation failed with specific error

    Fix: Added explicit empty string check before regex validation.

    Bug report: bugs/fixed/BUG-123-empty-email-validation.md
    """
    is_valid, error = validate_email("")

    # Specific assertions that catch this exact bug
    assert is_valid is False, "Empty email should be invalid"
    assert error == "Email cannot be empty", f"Expected specific error, got: {error}"
```

#### Step 5: Decide and Document

**If APPROVED:**
1. Update bug report: `status: fixed, fixed: YYYY-MM-DD`
2. Create review: `reviews/bug-fixes/YYYY-MM-DDTHH-MM-SS-<bug>-APPROVED.md`
3. Move bug report: `git mv bugs/fixing/<bug>.md bugs/fixed/<bug>.md`

**If NEEDS-CHANGES:**
Create review with specific feedback, leave in `bugs/fixing/`.

## Communication Protocol

See [EmailIntegration.md](EmailIntegration.md) for complete email workflow documentation.

### When to Check Email

**Before starting work:**
- Check for implementation review-request messages
- Check for answers to clarification questions

**After completing work:**
- Send approval message (feature complete!)
- Send rejection if implementation has issues
- Notify coordinator when feature is merged

**Use email workflow:**
```bash
./Workflow/scripts/run-role.sh --with-email implementation-reviewer
```

### Message Types to Send

**approval** - Implementation approved, feature complete!
```bash
# First: Merge feature branch, move spec to done
git checkout main
git merge feature-name
git push origin main
git mv specs/doing/feature-name.md specs/done/feature-name.md
git commit -m "implementation-reviewer: Approve feature-name implementation"
git push

# Then: Send approval notification
./Workflow/scripts/workflow-notify.sh \
  approval \
  specs/done/feature-name.md \
  implementer,coordinator \
  NEXT_STATE="done" \
  CONTEXT="Feature complete, merged to main, all tests passing"
```

**rejection** - Implementation needs revision
```bash
./Workflow/scripts/workflow-notify.sh \
  rejection \
  specs/doing/feature-name.md \
  implementer \
  REVIEWER_COMMENTS="Security vulnerability in line 42, performance issue in loop (spec requires <100ms)"
```

**clarification-request** - Need clarification
```bash
./Workflow/scripts/workflow-notify.sh \
  --in-reply-to "<review-request-message-id>" \
  clarification-request \
  specs/doing/feature-name.md \
  implementer \
  QUESTION="Why did you deviate from the recommended caching approach in spec?" \
  BLOCKING="no"
```

## Integration with Workflow

**Receives:** Implementation (all tests GREEN) on feature branch, SPEC from specs/doing/
**Produces:** Review in reviews/implementations/, merges feature branch, moves spec to specs/done/
**Next:** Platform Lead (if living docs updated), next feature planning
**Gatekeeper:** Controls merge to main and spec transition from doing → done

**To understand where this role fits:** See [workflow-overview.md](workflow-overview.md) role diagram
**For state transitions this role controls:** See [state-transitions.md](state-transitions.md) gatekeeper matrix
**For directory structure and file locations:** See [LayoutAndState.md](LayoutAndState.md)

**Workflow position:**
```
implementer → implementation (GREEN) ✓
  ↓
implementation-reviewer → APPROVED ⬅ YOU ARE HERE
  ↓
[move spec to done/]
  ↓
merge to main
  ↓
platform-lead updates docs
```

You are the final quality gate. Ensure everything is correct before merge.

**Gatekeeper responsibility:** After APPROVED, move spec from `doing/` to `done/`:
```bash
git mv specs/doing/feature.md specs/done/feature.md
git commit -m "feat: complete feature implementation

Implementation reviewed and approved.
All acceptance criteria met."
```

## Critical Reminders

**DO:**
- Verify all tests pass first
- Check test integrity (no modifications)
- Verify spec compliance thoroughly
- Check architectural adherence to GUIDELINES.md and SYSTEM_MAP.md
- Review security carefully (input validation, no injection, secrets protected)
- Provide specific, actionable feedback with file:line locations
- Balance rigor with pragmatism
- Note positive aspects
- Reference [schema-implementation-code.md](schema-implementation-code.md) for standards
- For bug fixes: Verify sentinel test FAILS on old code and PASSES on new code

**DON'T:**
- Approve if tests failing
- Approve if tests weakened
- Allow architectural violations
- Ignore security issues
- Give vague feedback without concrete examples
- Nitpick minor style issues (linter handles it)
- Block on personal preferences
- For bug fixes: Approve sentinel test that doesn't catch the bug

**Most critical:** You are the final quality gate. Tests passing is necessary but not sufficient. Ensure code is correct, secure, and maintainable. For bug fixes, sentinel test MUST prove it catches the regression.
