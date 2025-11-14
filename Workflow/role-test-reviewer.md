---
role: Test Reviewer
trigger: After tests written, before implementation
typical_scope: Complete test suite for one feature
dependencies: [SPEC from specs/doing/, test files, skeleton code, bugs/fixed/, GUIDELINES.md, schema-test-code.md]
outputs: [reviews/tests/TIMESTAMP-FEATURE-STATUS.md]
gatekeeper: true
state_transition: Approves tests (RED) → implementer begins GREEN phase
---

# Test Reviewer

*Structure reference: [role-file-structure.md](patterns/role-file-structure.md)*

## Purpose

Review test suites to ensure they're clear, complete, and will drive correct implementation. Approval gates the TDD GREEN phase. Poor tests lead to poor implementation - catch quality issues before any production code is written.

## Collaboration Pattern

This is an **independent role** - work separately from test writer.

**Responsibilities:**
- Verify tests match spec requirements
- Check test quality and clarity
- Validate completeness (happy/edge/error cases)
- Ensure tests are maintainable
- Approve or request changes

**Review flow:**
1. Test writer marks tests ready
2. Read spec and tests independently
3. Provide structured feedback
4. Writer addresses issues
5. Approve when quality bar met
6. Implementer begins GREEN phase

## Inputs

**Code under review:**
- Test files from test-writer

**References:**
- SPEC from `specs/doing/`
- Skeleton code (understand interfaces)
- bugs/fixed/ (verify sentinel tests)
- GUIDELINES.md (test conventions)
- [schema-test-code.md](schema-test-code.md) (test quality standards)

## Process

### Step 1: Load References
- Read SPEC from `specs/doing/`
- Understand acceptance criteria
- Note all exceptions and edge cases mentioned
- Check bugs/fixed/ for required sentinels

### Step 2: Check Clarity & Readability

**Verify:**
- [ ] Test names descriptive (test_method_scenario_expected)
- [ ] Arrange-Act-Assert structure clear
- [ ] Variables have meaningful names
- [ ] Tests self-contained (no hidden dependencies)

**Good example:**
```python
def test_withdraw_with_sufficient_funds_decreases_balance():
    # Arrange
    account = Account(balance=100)
    withdrawal_amount = 30

    # Act
    account.withdraw(withdrawal_amount)

    # Assert
    assert account.balance == 70
```

**Issues:**
```python
❌ test_withdraw: Vague name
❌ Variable 'a': Unclear
❌ No comments: Hard to follow
```

### Step 3: Check Completeness

**For each method/function, verify coverage:**
- [ ] Happy path tested
- [ ] Edge cases tested (empty, null, zero, boundary)
- [ ] Error cases tested (invalid input, exceptions)
- [ ] State transitions tested (if stateful)
- [ ] All exceptions from spec tested

**Completeness checklist:**
```
For withdraw(amount) method:
✓ Happy path: sufficient funds
❌ Missing: insufficient funds error
❌ Missing: exact balance withdrawal (boundary)
❌ Missing: negative amount (invalid input)
❌ Missing: zero amount (edge case)
```

### Step 4: Check Coverage Metrics

See [schema-test-code.md](schema-test-code.md) for complete coverage requirements and standards.

**Coverage targets:**
- **Line coverage:** >80% of production code
- **Branch coverage:** >70% of decision branches
- **Edge case coverage:** All boundary conditions tested
- **Exception coverage:** All error paths tested

**Verify line and branch coverage:**
```bash
# Python (pytest-cov)
pytest tests/ --cov=src --cov-report=term-missing --cov-fail-under=80

# TypeScript (Jest)
npm test -- --coverage
```

**If coverage <80%:**
```
❌ Line coverage 72% (target: >80%)
   Uncovered lines: src/account.py:23-25, 67-70

   Missing tests:
   1. Lines 23-25: Overdraft protection logic
   2. Lines 67-70: Interest calculation for negative balance

   Required:
   - test_withdraw_with_overdraft_protection
   - test_interest_calculation_for_negative_balance
```

**Coverage report analysis:**

High-value uncovered code (critical):
- Core business logic
- Error handling paths
- Security-sensitive code
- Data validation logic

Low-value uncovered code (may be acceptable):
- Defensive assertions (should never happen)
- Logging statements
- Debug code
- Generated code

### Step 5: Check Independence & Isolation

**Verify:**
- [ ] Each test runs independently
- [ ] No shared mutable state
- [ ] Tests don't depend on execution order
- [ ] Each test creates own fixtures
- [ ] Tests clean up after themselves

**Good - independent:**
```python
def test_first_deposit():
    account = Account(balance=0)  # Own fixture
    account.deposit(50)

def test_second_deposit():
    account = Account(balance=0)  # Own fixture
    account.deposit(100)
```

**Bad - shared state:**
```python
account = Account(balance=100)  # Module-level

def test_deposit():
    account.deposit(50)  # Modifies shared state

def test_withdraw():
    account.withdraw(50)  # Depends on previous test
```

### Step 6: Check Behavior vs Implementation

**Verify:**
- [ ] Tests focus on behavior (what) not implementation (how)
- [ ] Tests specify interface contracts
- [ ] Tests will survive refactoring
- [ ] Not coupled to internal structure

**Good - behavior:**
```python
def test_user_login_with_valid_credentials_succeeds():
    result = user.login("alice", "password")
    assert result.is_authenticated is True
```

**Bad - implementation:**
```python
def test_user_login_calls_hash_function():
    with patch('bcrypt.hashpw') as mock:
        user.login("alice", "password")
        assert mock.called  # Couples to bcrypt
```

### Step 7: Check Test Double Usage

**Verify:**
- [ ] Mocks only for external dependencies
- [ ] Internal collaborators use real objects
- [ ] Not over-mocking (smell: 5+ mocks)
- [ ] Mocks represent real interfaces

**Good - mock external:**
```python
def test_send_notification():
    email_service = Mock(spec=EmailService)  # External
    notifier = Notifier(email_service)
    notifier.send("user@example.com", "Hello")
```

**Bad - over-mocking:**
```python
def test_order_total():
    mock_item1 = Mock()  # Don't mock data objects
    mock_item1.price = 10
    # Use real OrderItem instead
```

### Step 8: Check Assertions

**Verify:**
- [ ] Assertions specific and meaningful
- [ ] Testing the right thing
- [ ] Not too few assertions (incomplete)
- [ ] Not too many assertions (testing too much)
- [ ] Using appropriate matchers

**Good assertions:**
```python
def test_divide_by_zero_raises_error():
    with pytest.raises(ZeroDivisionError, match="Cannot divide by zero"):
        calculator.divide(10, 0)
```

**Bad assertions:**
```python
def test_user_creation():
    user = create_user("alice")
    assert user  # ❌ Too vague

    # Better:
    assert isinstance(user, User)
    assert user.username == "alice"
```

### Step 9: Check Spec Alignment

**For each acceptance criterion in spec:**
- [ ] Corresponding test exists
- [ ] Test verifies the criterion
- [ ] Test will catch if criterion not met

**For each exception in spec:**
- [ ] Test verifies exception raised
- [ ] Test checks exception message/type
- [ ] Test covers the trigger condition

**Gap detection:**
```
Spec says: "Raises ValidationError if email invalid"

❌ No test found for invalid email validation
   Add: test_register_invalid_email_raises_validation_error
```

### Step 10: Check Sentinel Tests

**Verify bugs/fixed/ coverage:**
- [ ] For each relevant bug, sentinel test exists
- [ ] Test references bug number
- [ ] Test would catch the bug if reintroduced

**Example:**
```python
def test_bug_42_empty_email_validation():
    """
    Sentinel for Bug #42.
    Previously empty string passed validation.
    Bug report: bugs/fixed/BUG-042-empty-email.md
    """
    is_valid, error = validate_email("")
    assert is_valid is False
```

### Step 11: Verify RED Phase

**Critical check:**
- [ ] All tests currently failing
- [ ] Failing for correct reason (NotImplementedError)
- [ ] Not failing due to import errors
- [ ] Not failing due to wrong signatures
- [ ] Not already passing (would indicate problem)

**Run tests:**
```bash
pytest tests/test_feature.py -v

# Expected: All FAILED with NotImplementedError
```

**Red flags:**
```
❌ Tests passing: Implementation exists OR test wrong
❌ Import errors: Skeleton broken
❌ Signature errors: Skeleton/spec mismatch
✓ NotImplementedError: Correct RED phase
```

### Step 12: Write Review

Use structured format (see Outputs section).

## Outputs

**Review document:** `reviews/tests/YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md`

Where STATUS ∈ {APPROVED, NEEDS-CHANGES}

**Review template:**
```markdown
# Test Review: [Feature Name]

**Reviewer:** [Your name/role]
**Date:** YYYY-MM-DD HH:MM:SS
**Spec:** specs/doing/[feature].md
**Test Files:** [list files reviewed]
**Status:** APPROVED | NEEDS-CHANGES

## Summary
[2-3 sentence overall assessment]

## Clarity & Readability
- ✓/❌ Test names descriptive
- ✓/❌ AAA structure clear
- ✓/❌ Variables meaningful
- ✓/❌ Self-contained tests

## Completeness ⚠ Critical
- ✓/❌ Happy path covered
- ✓/❌ Edge cases covered
- ✓/❌ Error cases covered
- ✓/❌ All spec exceptions tested
- ✓/❌ Sentinel tests present

## Coverage Metrics ⚠ Critical
- ✓/❌ Line coverage ≥80%
- ✓/❌ Branch coverage ≥70%
- ✓/❌ All public methods covered
- ✓/❌ All error paths covered
- ✓/❌ Critical business logic covered

## Independence
- ✓/❌ No shared state
- ✓/❌ Tests run in any order
- ✓/❌ Each test has own fixtures

## Quality
- ✓/❌ Tests behavior not implementation
- ✓/❌ Minimal mocking
- ✓/❌ Specific assertions
- ✓/❌ Spec alignment verified

## RED Phase Verification
- ✓/❌ All tests failing
- ✓/❌ Failing with NotImplementedError
- ✓/❌ No import/signature errors

## Critical Issues (if NEEDS-CHANGES)

### Issue 1: [Title]
- **Location:** [file:line or test name]
- **Problem:** [What's wrong]
- **Impact:** [Why this matters]
- **Fix:** [Concrete solution with example]

## Missing Test Cases
[List required tests not present]

## Minor Issues
[Non-blocking improvements]

## Positive Notes
[What's done well]

## Decision

**[APPROVED]** - Ready for implementation (GREEN phase)

**[NEEDS-CHANGES]** - Address critical issues above
```

## Common Issues

### Issue 1: Incomplete Coverage
```
Problem: Only happy path tested
Impact: Edge cases and errors unhandled in implementation
Fix: Add tests for all edge/error cases from spec
```

### Issue 2: Shared State
```
Problem: Module-level variables shared between tests
Impact: Tests fail in isolation or when order changes
Fix: Use fixtures or create instances in each test
```

### Issue 3: Over-Mocking
```
Problem: Mocking internal data objects
Impact: Tests meaningless, won't catch real bugs
Fix: Use real objects, mock only external boundaries
```

### Issue 4: Testing Implementation
```
Problem: Tests coupled to internal structure
Impact: Refactoring breaks tests
Fix: Test observable behavior instead
```

### Issue 5: Weak Assertions
```
Problem: assert result (too vague)
Impact: Test passes with wrong values
Fix: assert result.value == expected_value
```

### Issue 6: Missing Sentinel Tests
```
Problem: No tests for bugs in bugs/fixed/
Impact: Regressions not caught
Fix: Add sentinel tests referencing bug numbers
```

## Examples

### Example 1: APPROVED Review

```markdown
# Test Review: Email Validation

**Status:** APPROVED

## Summary
Comprehensive test coverage with clear names and proper AAA structure.
All spec requirements covered, tests failing correctly. Ready for GREEN phase.

## Completeness
- ✓ Happy path: valid email
- ✓ Edge cases: empty, plus-addressing
- ✓ Error cases: missing @, non-string type
- ✓ Sentinel: Bug #42 (empty email)

## Coverage Metrics
- ✓ Line coverage: 100%
- ✓ Branch coverage: 100%

## RED Phase
- ✓ All tests failing with NotImplementedError
- ✓ No import/signature errors

## Positive Notes
- Excellent test naming (test_validate_email_with_empty_string_returns_false)
- Clear AAA structure throughout
- Good edge case coverage

## Decision
APPROVED - Ready for implementer (GREEN phase)
```

### Example 2: NEEDS-CHANGES Review

```markdown
# Test Review: User Registration

**Status:** NEEDS-CHANGES

## Summary
Good start but critical gaps in error case coverage and independence issues.
Tests share state which will cause intermittent failures.

## Critical Issues

### Issue 1: Missing Error Cases
- **Problem:** No test for duplicate email scenario
- **Impact:** Spec says "Raises DuplicateEmailError" but not tested
- **Fix:**
  ```python
  def test_register_duplicate_email_raises_error():
      repo = Mock(spec=UserRepository)
      repo.get_by_email.return_value = User(email="exists@example.com")
      service = UserService(repo=repo)

      with pytest.raises(DuplicateEmailError):
          service.register("exists@example.com", "password")
  ```

### Issue 2: Shared State
- **Location:** test_user_registration.py:15
- **Problem:** Module-level `repository = InMemoryUserRepository()`
- **Impact:** Tests affect each other, order-dependent
- **Fix:** Use fixture instead:
  ```python
  @pytest.fixture
  def repository():
      return InMemoryUserRepository()

  def test_register(repository):
      service = UserService(repository)
      ...
  ```

### Issue 3: Missing Sentinel
- **Problem:** Bug #67 from bugs/fixed/ not covered by sentinel test
- **Impact:** Regression not caught
- **Fix:** Add test_bug_67_sql_injection_in_email_field()

### Issue 4: Low Coverage
- **Problem:** Line coverage 68% (target: >80%)
- **Impact:** Critical validation logic untested
- **Fix:** Add tests for uncovered lines 45-52 (password strength validation)

## Missing Test Cases
1. test_register_with_weak_password_raises_error
2. test_register_with_invalid_email_format_raises_error
3. test_register_duplicate_email_raises_error

## Decision
NEEDS-CHANGES - Address 4 critical issues and add 3 missing tests
```

## Communication Protocol

See [EmailIntegration.md](EmailIntegration.md) for complete email workflow documentation.

### When to Check Email

**Before starting work:**
- Check for test review-request messages
- Check for answers to clarification questions

**After completing work:**
- Send approval or rejection message
- Send clarification-request if tests are unclear

**Use email workflow:**
```bash
./Workflow/scripts/run-role.sh --with-email test-reviewer
```

### Message Types to Send

**approval** - Tests are approved
```bash
./Workflow/scripts/workflow-notify.sh \
  approval \
  specs/doing/feature-name.md \
  test-writer,implementer \
  NEXT_ROLES="implementer" \
  CONTEXT="All tests RED for correct reasons, ready for implementation"
```

**rejection** - Tests need revision
```bash
./Workflow/scripts/workflow-notify.sh \
  rejection \
  specs/doing/feature-name.md \
  test-writer \
  REVIEWER_COMMENTS="Missing edge cases, test coverage 68% (need 80%+)"
```

**clarification-request** - Need clarification
```bash
./Workflow/scripts/workflow-notify.sh \
  --in-reply-to "<review-request-message-id>" \
  clarification-request \
  specs/doing/feature-name.md \
  test-writer \
  QUESTION="Why no tests for error condition described in spec section 4.2?" \
  BLOCKING="no"
```

## Integration with Workflow

**Receives:** Test suite (all RED) on feature branch, SPEC from specs/doing/
**Produces:** Review in reviews/tests/
**Next:** Implementer (if approved), Test Writer (if needs changes)
**Gatekeeper:** Approves before implementation begins

**To understand where this role fits:** See [workflow-overview.md](workflow-overview.md) role diagram
**For state transitions this role controls:** See [state-transitions.md](state-transitions.md) gatekeeper matrix
**For directory structure and file locations:** See [LayoutAndState.md](LayoutAndState.md)

**Workflow position:**
```
test-writer → tests (RED)
  ↓
test-reviewer → APPROVED ⬅ YOU ARE HERE
  ↓
implementer → make tests pass (GREEN)
  ↓
implementation-reviewer → APPROVED
```

Your approval gates the TDD GREEN phase. Ensure tests will drive correct implementation.

## Critical Reminders

**DO:**
- Check against spec meticulously
- Verify all spec requirements covered
- Ensure tests independent
- Confirm tests failing correctly (RED)
- Check sentinel tests present for relevant bugs
- Provide specific, actionable feedback with file:line locations
- Run tests to verify RED phase
- Verify coverage metrics meet targets (>80% line, >70% branch)
- Reference [schema-test-code.md](schema-test-code.md) for detailed standards
- Focus on completeness (covers all spec requirements)
- Focus on independence (tests don't interfere)
- Focus on behavior (not implementation details)

**DON'T:**
- Approve incomplete coverage (<80% line, <70% branch)
- Allow shared state between tests
- Accept tests of implementation details
- Approve tests that already pass
- Give vague feedback without concrete examples
- Skip checking bugs/fixed/ for required sentinels
- Approve without running coverage metrics
- Accept over-mocking (5+ mocks suggests design issue)
- Permit weak or vague assertions

**Most critical:** Tests must be failing correctly (NotImplementedError). If passing, something is wrong. Incomplete coverage = incomplete implementation.
