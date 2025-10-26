---
role: Implementation Reviewer
trigger: After implementation complete and tests pass (GREEN)
typical_scope: One feature implementation
---

# Implementation Reviewer

## Purpose

Review implementations after tests pass (TDD GREEN/REFACTOR phase) to verify spec compliance, code quality, security, and maintainability before merge. Your approval is the final quality gate. Passing tests don't guarantee good code - reviews catch what tests miss.

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
- GUIDELINES.md - Code conventions
- GUIDELINES.md - Architectural constraints
- Sentinel tests in tests/regression/

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

**For each acceptance criterion:**
- [ ] Corresponding implementation exists
- [ ] Behavior matches specification
- [ ] All edge cases handled
- [ ] All error conditions handled
- [ ] Performance requirements met (if specified)

**Check method:**
1. Read spec requirement
2. Find implementation code
3. Verify behavior matches
4. Check test exists and passes
5. Flag any discrepancies

**Example verification:**

**Spec says:**
```
Register user:
- Validates email format
- Hashes password
- Saves to repository
- Sends welcome email
- Raises DuplicateEmailError if email exists
```

**Check implementation:**
```python
✓ Email validation present
✓ Password hashing used
✓ Repository save called
✓ Welcome email sent
✓ DuplicateEmailError raised
```

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

**Check against GUIDELINES.md:**
- [ ] No forbidden imports
- [ ] Layer boundaries respected
- [ ] No global state
- [ ] Dependency injection used
- [ ] No hard-coded dependencies

**Check against GUIDELINES.md:**
- [ ] Follows naming conventions
- [ ] Uses standard utilities
- [ ] Matches organizational patterns
- [ ] Consistent with similar features

**Red flags:**
```python
# ❌ Violates GUIDELINES.md
from internal.database import PostgresConnection  # Direct DB import in service

# ❌ Ignores GUIDELINES.md
def validateEmail(email):  # Should be validate_email per conventions
```

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

**Example issues:**
```python
# ❌ N+1 query problem
for user in users:
    user.orders = db.query(f"SELECT * FROM orders WHERE user_id = {user.id}")

# ✓ Batch query
user_ids = [u.id for u in users]
orders = db.query("SELECT * FROM orders WHERE user_id IN (?)", user_ids)
```

### Step 9: Check for Duplication

**Verify:**
- [ ] No copy-pasted code
- [ ] Common logic extracted
- [ ] Uses existing utilities
- [ ] DRY principle followed

**Example issues:**
```python
# ❌ Duplicated validation
def register(email, password):
    if not email or "@" not in email:
        raise ValidationError("Invalid email")
    # ...

def update_email(user, new_email):
    if not new_email or "@" not in new_email:  # Duplicated
        raise ValidationError("Invalid email")
    # ...

# ✓ Extracted utility
def validate_email(email: str) -> None:
    if not email or "@" not in email:
        raise ValidationError("Invalid email")

def register(email, password):
    validate_email(email)
    # ...
```

### Step 10: Check for Bug-Related Updates

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
- ✓/❌ Respects GUIDELINES.md
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

## Common Issues & Solutions

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

## Best Practices

**Be specific:**
- Point to exact file:line
- Explain impact clearly
- Provide concrete fix
- Show example code

**Prioritize issues:**
- Critical: Must fix (blocks merge)
- Important: Should fix (quality)
- Minor: Nice to have (polish)

**Balance rigor with pragmatism:**
- Don't nitpick formatting (linter handles it)
- Focus on correctness and maintainability
- Allow different approaches if valid
- Recognize good solutions

**Positive reinforcement:**
- Note clean code
- Acknowledge good patterns
- Highlight clever solutions

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

### Issue 3: Missing Error Handling
- **Location:** src/services/payment.py:62
- **Problem:** No handling for insufficient funds
- **Impact:** Spec requires InsufficientFundsError
- **Fix:** Add balance check before transfer
  ```python
  if sender.balance < amount:
      raise InsufficientFundsError(f"Balance {sender.balance} < {amount}")
  ```

## Decision
NEEDS-CHANGES - Fix 3 critical issues above before merge
```

## Bug Fix Review Process (Alternative Workflow)

When reviewing bug fixes (instead of feature implementations), use this lighter process.

### Triggered By: Bugfix branch ready for review

Bug fixes are simpler than feature implementations - no spec, no skeleton, lighter testing.

### Process

#### Step 1: Read Bug Report

Read `bugs/fixing/<bug>.md` thoroughly:
- Understand observed vs expected behavior
- Check steps to reproduce
- Note severity and impact

#### Step 2: Verify Root Cause

Check Root Cause section in bug report:
- [ ] Makes sense given symptoms
- [ ] Points to specific code location
- [ ] Explains mechanism (not just symptoms)

#### Step 3: Review Fix Code

Standard code review, focused on fix:
- [ ] Fix addresses root cause directly
- [ ] Minimal changes (no scope creep)
- [ ] Follows GUIDELINES.md
- [ ] No new issues introduced

#### Step 4: Review Sentinel Test ⚠ CRITICAL

**Purpose:** Sentinel tests prevent regression. They MUST fail on old code and pass on new code, proving they catch the bug.

**Sentinel test requirements:**
- [ ] Test has detailed comment explaining bug (bug number, description, reproduction steps)
- [ ] Test is specific to THIS bug (not generic smoke test)
- [ ] Test is simple and focused (tests one thing)
- [ ] Test name references bug number (`test_bug_123_description`)

#### Verify Test FAILS on Old Code

**CRITICAL:** Must verify sentinel test would have caught the bug before fix.

**Verification steps:**

**Step 1: Identify pre-fix commit**
```bash
# Find the commit that introduced the fix
git log --oneline --grep="BUG-123" -n 5

# Or find commits in bugfix branch
git log --oneline main..bugfix/BUG-123

# Note the commit BEFORE the fix (parent of fix commit)
git log --oneline -n 2 <fix-commit>
# Example output:
# abc1234 Fix BUG-123: Handle empty email validation  <-- fix commit
# def5678 Add user registration feature               <-- parent (before fix)
```

**Step 2: Checkout pre-fix code**
```bash
# Checkout commit before fix
git checkout <parent-commit>

# Example:
git checkout def5678
```

**Step 3: Run sentinel test (should FAIL)**
```bash
# Python
pytest tests/regression/test_bug_123.py -v

# TypeScript
npm test tests/regression/bug-123.test.ts

# Expected output: FAILED
# ❌ test_bug_123_empty_email_validation FAILED
```

**Step 4: Verify failure is for correct reason**
```bash
# Check failure output carefully

# Good failure (catches bug):
# AssertionError: assert is_valid == False
# Expected empty email to be invalid, but was valid

# Bad failure (test broken):
# ImportError: cannot import validate_email
# NameError: 'validator' is not defined
```

**If test PASSES on old code:**
```
❌ CRITICAL: Sentinel test passes on pre-fix code

This means test does NOT catch the bug. Possible causes:
1. Test doesn't trigger bug condition
2. Test assertion too weak
3. Test mocks away the bug
4. Wrong commit checked out

MUST FIX before approving.

Example fix:
# Current (doesn't catch bug):
def test_bug_123():
    result = validate_email("")
    assert result is not None  # Too weak - passes even with bug

# Fixed (catches bug):
def test_bug_123_empty_email_validation():
    is_valid, error = validate_email("")
    assert is_valid is False
    assert error == "Email cannot be empty"
```

**Step 5: Return to fix commit**
```bash
git checkout <bugfix-branch>
# or
git checkout -  # if was last checkout
```

#### Verify Test PASSES on New Code

**Verification steps:**

**Step 1: Run sentinel test with fix (should PASS)**
```bash
# Python
pytest tests/regression/test_bug_123.py -v

# TypeScript
npm test tests/regression/bug-123.test.ts

# Expected output: PASSED
# ✓ test_bug_123_empty_email_validation PASSED
```

**If test FAILS on new code:**
```
❌ CRITICAL: Sentinel test fails with fix applied

Fix is incomplete or test incorrect. Investigate:
1. Does fix actually solve the bug?
2. Is test assertion correct?
3. Did fix introduce new bug?

Example:
# Test fails:
test_bug_123_empty_email_validation FAILED
AssertionError: assert is_valid == False
Expected: is_valid = False, error = "Email cannot be empty"
Actual: is_valid = False, error = "Invalid email format"

Issue: Fix returns wrong error message. Update fix.
```

#### Verify Test Specificity

**Sentinel test MUST be specific to bug, not generic smoke test.**

**Good sentinel test (specific):**
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

**Bad sentinel test (too generic):**
```python
def test_bug_123():
    """Bug 123 fix."""  # ❌ No explanation

    # ❌ Too generic - this is a smoke test, not sentinel
    result = validate_email("user@example.com")
    assert result is not None

    # Won't catch the BUG-123 regression (empty email)
```

**Specificity checklist:**
- [ ] Test directly exercises bug condition (empty email, not valid email)
- [ ] Test assertions verify EXACT bug symptoms
- [ ] Test would catch ONLY this bug (not other issues)
- [ ] Test comment explains bug in detail
- [ ] Test name describes specific bug scenario

#### Verification Command Summary

**Complete verification sequence:**
```bash
# 1. Find parent of fix commit
FIX_COMMIT=$(git log --oneline --grep="BUG-123" -n 1 | awk '{print $1}')
PARENT_COMMIT=$(git log --oneline -n 2 $FIX_COMMIT | tail -1 | awk '{print $1}')

echo "Fix commit: $FIX_COMMIT"
echo "Parent (before fix): $PARENT_COMMIT"

# 2. Verify test FAILS on old code
echo "=== Testing on OLD code (should FAIL) ==="
git checkout $PARENT_COMMIT
pytest tests/regression/test_bug_123.py -v
# Expect: FAILED

# 3. Verify test PASSES on new code
echo "=== Testing on NEW code (should PASS) ==="
git checkout $FIX_COMMIT
pytest tests/regression/test_bug_123.py -v
# Expect: PASSED

# 4. Return to review branch
git checkout <bugfix-branch>
```

**Automated verification script** (optional):
```bash
#!/bin/bash
# verify-sentinel.sh BUG-123 test_bug_123

BUG_ID=$1
TEST_NAME=$2

FIX_COMMIT=$(git log --oneline --grep="$BUG_ID" -n 1 | awk '{print $1}')
PARENT_COMMIT=$(git rev-parse $FIX_COMMIT^)

echo "Verifying sentinel test for $BUG_ID"
echo "Fix: $FIX_COMMIT | Parent: $PARENT_COMMIT"

# Test on old code
git checkout $PARENT_COMMIT 2>/dev/null
echo "Testing on OLD code..."
pytest tests/regression/$TEST_NAME.py -v > /tmp/old_test.log 2>&1

if grep -q "PASSED" /tmp/old_test.log; then
    echo "❌ FAIL: Test PASSED on old code (should FAIL)"
    git checkout -
    exit 1
fi

# Test on new code
git checkout $FIX_COMMIT 2>/dev/null
echo "Testing on NEW code..."
pytest tests/regression/$TEST_NAME.py -v > /tmp/new_test.log 2>&1

if grep -q "FAILED" /tmp/new_test.log; then
    echo "❌ FAIL: Test FAILED on new code (should PASS)"
    git checkout -
    exit 1
fi

git checkout -
echo "✓ Sentinel test verified successfully"
```

#### Common Sentinel Test Issues

**Issue 1: Test too generic**
```
❌ Problem: test_user_validation() tests general validation
   Impact: Won't catch specific BUG-123 (empty email)
   Fix: Make test specific to empty email case
```

**Issue 2: Test mocks away bug**
```
❌ Problem: Test mocks validate_email()
   Impact: Never exercises actual buggy code
   Fix: Remove mock, test real function
```

**Issue 3: Weak assertions**
```
❌ Problem: assert result is not None
   Impact: Passes even with bug present
   Fix: assert result.is_valid is False
```

**Issue 4: Wrong test location**
```
❌ Problem: Sentinel in tests/unit/ instead of tests/regression/
   Impact: Organizational issue, harder to track
   Fix: Move to tests/regression/test_bug_123.py
```

**Issue 5: Test doesn't reproduce bug**
```
❌ Problem: Test uses valid email, bug was about empty email
   Impact: Doesn't catch regression
   Fix: Update test to use empty email (actual bug condition)
```

#### Step 5: Check GUIDELINES.md Updates (if any)

If GUIDELINES.md updated:
- [ ] Update appropriate (bug reveals pattern)
- [ ] Example included
- [ ] Explains why pattern matters

#### Step 6: Verify Bug Report Completeness

Bug report should have:
- [ ] Root Cause section
- [ ] Fix section with commit reference
- [ ] Sentinel test location

#### Step 7: Decide and Document

**If APPROVED:**

1. Update bug report:
   ```yaml
   status: fixed
   fixed: YYYY-MM-DD
   ```

2. Create review: `reviews/bug-fixes/YYYY-MM-DDTHH-MM-SS-<bug>-APPROVED.md`

3. Move bug report:
   ```bash
   git mv bugs/fixing/<bug>.md bugs/fixed/<bug>.md
   ```

**If NEEDS-CHANGES:**

Create review with specific feedback, leave in `bugs/fixing/`.

## Critical Reminders

**DO:**
- Verify all tests pass first
- Check test integrity (no modifications)
- Verify spec compliance thoroughly
- Check architectural adherence
- Review security carefully
- Provide specific, actionable feedback
- Balance rigor with pragmatism
- Note positive aspects

**DON'T:**
- Approve if tests failing
- Approve if tests weakened
- Allow architectural violations
- Ignore security issues
- Give vague feedback
- Nitpick minor style issues
- Block on personal preferences

**Most critical:** You are the final quality gate. Tests passing is necessary but not sufficient. Ensure code is correct, secure, and maintainable.

**Gatekeeper responsibility:** After APPROVED, move spec from `doing/` to `done/`:
```bash
git mv specs/doing/feature.md specs/done/feature.md
git commit -m "feat: complete feature implementation

Implementation reviewed and approved.
All acceptance criteria met."
```

## Integration

**Consumes:**
- Implementation code (tests GREEN)
- Tests (should be unmodified)
- SPEC from `specs/doing/`
- Architecture docs

**Produces:**
- Review with APPROVED / NEEDS-CHANGES
- Specific feedback

**Gates:**
- Approval required for merge
- Moves spec from `doing/` to `done/`
- Final quality gate before production

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
