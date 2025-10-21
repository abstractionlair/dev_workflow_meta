---
name: test-review
description: Guide for reviewing tests written in a test-driven development process before implementation. Use when users want to validate test quality, check test completeness, identify test smells, or get feedback on tests before writing production code. Supports Python and TypeScript with language-agnostic principles.
license: Complete terms in LICENSE.txt
---

# Test Review

This skill provides systematic guidance for reviewing tests written before implementation (the "Red" phase of TDD), ensuring tests are clear, complete, and maintainable before any production code is written.

## Review Philosophy

**Goal**: Ensure tests specify desired behavior clearly and completely before writing implementation.

**When to review**: After writing tests, before implementing production code (during TDD "Red" phase).

**Why review first**: Poor tests lead to poor implementation. Fixing test quality issues early prevents:
- Over-engineered solutions
- Missing edge cases
- Brittle, hard-to-maintain code
- False confidence from weak tests

## Systematic Review Process

Follow this checklist in order when reviewing tests:

### 1. Clarity & Readability

**Check:**
- Can you understand what's being tested without reading implementation?
- Are test names descriptive and follow naming conventions?
- Is the Arrange-Act-Assert structure clear?
- Are tests self-contained (no hidden dependencies)?

**Good example:**
```python
def test_withdraw_with_sufficient_funds_decreases_balance():
    # Arrange
    account = Account(balance=100)
    
    # Act
    account.withdraw(30)
    
    # Assert
    assert account.balance == 70
```

**Problematic example:**
```python
def test_withdraw():  # ❌ Vague name
    a = Account(100)  # ❌ Unclear variables
    a.withdraw(30)
    assert a.balance == 70  # ❌ Why 70? Not obvious
```

**Review feedback pattern:**
```
❌ test_withdraw: Name doesn't describe behavior or expected outcome
   Rename to: test_withdraw_with_sufficient_funds_decreases_balance

❌ Variable 'a' is unclear
   Use descriptive name: account

ℹ️  Add comments to clarify magic numbers:
   initial_balance = 100  # Starting amount
   withdrawal_amount = 30
   expected_balance = 70  # 100 - 30
```

### 2. Completeness

**Check:**
- Are happy path cases covered?
- Are edge cases tested (empty, null, zero, negative, boundary values)?
- Are error cases tested (invalid input, exceptions)?
- Are state transitions tested?
- Are boundary conditions tested?

**Completeness checklist for a method:**
```
For withdraw(amount) method:
✅ Happy path: sufficient funds
❌ Missing: insufficient funds (should raise error)
❌ Missing: exact balance withdrawal (boundary)
❌ Missing: negative amount (invalid input)
❌ Missing: zero amount (edge case)
❌ Missing: withdraw from empty account
```

**Review feedback:**
```
⚠️  Test coverage incomplete for withdraw method
   Missing critical cases:
   1. test_withdraw_with_insufficient_funds_raises_error
   2. test_withdraw_negative_amount_raises_error
   3. test_withdraw_zero_amount_returns_unchanged_balance
   4. test_withdraw_exact_balance_results_in_zero
```

### 3. Independence & Isolation

**Check:**
- Does each test run independently?
- No shared mutable state between tests?
- Tests don't depend on execution order?
- Each test creates its own fixtures?
- Tests clean up after themselves?

**Good - independent tests:**
```python
def test_first_deposit():
    account = Account(balance=0)  # Own fixture
    account.deposit(50)
    assert account.balance == 50

def test_second_deposit():
    account = Account(balance=0)  # Own fixture
    account.deposit(100)
    assert account.balance == 100
```

**Problematic - shared state:**
```python
# ❌ Shared state across tests
account = Account(balance=100)

def test_deposit():
    account.deposit(50)
    assert account.balance == 150

def test_withdraw():  # ❌ Depends on previous test
    account.withdraw(50)
    assert account.balance == 100  # ❌ Will fail if deposit didn't run
```

**Review feedback:**
```
❌ Tests share mutable state (module-level 'account' variable)
   Problem: Tests will fail if run in isolation or different order
   Fix: Create separate account instance in each test or use fixtures
   
   @pytest.fixture
   def account():
       return Account(balance=100)
   
   def test_deposit(account):
       account.deposit(50)
       assert account.balance == 150
```

### 4. Behavior vs Implementation Testing

**Check:**
- Are tests focused on behavior (what) not implementation (how)?
- Do tests specify interface contracts, not internal mechanics?
- Will tests survive refactoring?
- Are tests coupled to internal structure?

**Good - tests behavior:**
```python
def test_user_login_with_valid_credentials_succeeds():
    # Tests the behavior/outcome
    user = User(username="alice", password="secret123")
    result = user.login("alice", "secret123")
    assert result.is_authenticated == True
    assert result.user_id is not None
```

**Problematic - tests implementation:**
```python
def test_user_login_calls_hash_function():  # ❌ Tests implementation detail
    user = User(username="alice", password="secret123")
    with patch('bcrypt.hashpw') as mock_hash:
        user.login("alice", "secret123")
        assert mock_hash.called  # ❌ Couples test to bcrypt implementation
```

**Review feedback:**
```
❌ test_user_login_calls_hash_function tests implementation detail
   Problem: Test will break if you switch from bcrypt to argon2
   Solution: Test the behavior (authentication succeeds/fails)
   
   Better test:
   def test_user_login_with_correct_password_authenticates():
       user = User(username="alice", password="secret123")
       result = user.login("alice", "secret123")
       assert result.is_authenticated == True
```

### 5. Test Double Usage (Mocks/Stubs)

**Check:**
- Are mocks necessary or over-used?
- Do mocks represent real external dependencies?
- Are too many mocks a sign of poor design?
- Could integration test be better than heavily mocked unit test?

**Good - mock external dependency:**
```python
def test_send_notification_calls_email_service():
    # Mock external email service (reasonable)
    email_service = Mock(spec=EmailService)
    notifier = Notifier(email_service)
    
    notifier.send_notification("user@example.com", "Hello")
    
    email_service.send.assert_called_once_with("user@example.com", "Hello")
```

**Problematic - over-mocking:**
```python
def test_calculate_order_total():
    # ❌ Mocking internal collaborators that should be real
    mock_item1 = Mock()
    mock_item1.price = 10
    mock_item2 = Mock()
    mock_item2.price = 20
    
    order = Order([mock_item1, mock_item2])
    
    # Test becomes brittle and tests nothing meaningful
    assert order.total() == 30
```

**Review feedback:**
```
⚠️  Over-mocking detected in test_calculate_order_total
   Problem: Mocking OrderItem objects couples test to implementation
   Impact: Can't catch real bugs in OrderItem/Order interaction
   
   Solution: Use real OrderItem objects unless they have external dependencies:
   
   def test_calculate_order_total():
       item1 = OrderItem(name="Widget", price=10)
       item2 = OrderItem(name="Gadget", price=20)
       order = Order([item1, item2])
       assert order.total() == 30
```

**Smell: Too many mocks**
```python
def test_process_order():
    # ❌ 5+ mocks suggests design problem
    mock_inventory = Mock()
    mock_payment = Mock()
    mock_shipping = Mock()
    mock_email = Mock()
    mock_logger = Mock()
    mock_analytics = Mock()
    
    # If you need this many mocks, consider:
    # 1. Is this class doing too much? (SRP violation)
    # 2. Should this be an integration test instead?
    # 3. Do all these dependencies need to be injected?
```

### 6. Test Assertions

**Check:**
- Are assertions specific and meaningful?
- Do assertions test the right thing?
- Are there too few assertions (incomplete verification)?
- Are there too many assertions (testing too much at once)?
- Are assertions using appropriate matchers?

**Good assertions:**
```python
def test_divide_by_zero_raises_error():
    calculator = Calculator()
    
    # Specific exception check
    with pytest.raises(ZeroDivisionError, match="Cannot divide by zero"):
        calculator.divide(10, 0)
```

**Problematic assertions:**
```python
def test_user_creation():
    user = create_user("alice", "alice@example.com")
    
    # ❌ Too vague - what if object is wrong type?
    assert user
    
    # Better:
    assert isinstance(user, User)
    assert user.username == "alice"
    assert user.email == "alice@example.com"
    assert user.is_active == True

def test_calculation():
    result = calculate(10, 20)
    
    # ❌ Assertion doesn't verify the right thing
    assert result != None  # Too weak
    
    # Better:
    assert result == 30  # Specific expected value
```

**Review feedback:**
```
❌ test_user_creation: Assertion too weak (assert user)
   Problem: Passes even if user is wrong type or has wrong values
   Fix: Add specific assertions:
   - assert isinstance(user, User)
   - assert user.username == "alice"
   - assert user.email == "alice@example.com"

⚠️  test_calculate_total: No assertions at all
   Problem: Test doesn't verify anything
   Add: assert order.total() == expected_total
```

### 7. Test Performance

**Check:**
- Are tests fast enough to run frequently?
- Any unnecessary sleeps or waits?
- Are expensive operations mocked when appropriate?
- Database operations in unit tests? (should be integration tests)

**Fast test:**
```python
def test_validate_email():
    # Pure logic, no I/O - runs in microseconds
    assert validate_email("user@example.com") == True
    assert validate_email("invalid") == False
```

**Slow test:**
```python
def test_process_data():
    # ❌ Actual database operation in unit test
    db = Database("postgresql://...")
    result = process_data_from_db(db, query="SELECT * FROM large_table")
    assert len(result) > 0
    
    # Should be:
    # 1. Mock the database for unit test, OR
    # 2. Move to integration tests with test database
```

**Review feedback:**
```
⚠️  test_process_data likely too slow for unit test
   Issue: Uses real database connection
   Impact: Slows down test suite, may fail if DB unavailable
   
   Options:
   1. Mock database for unit test:
      mock_db = Mock(spec=Database)
      mock_db.query.return_value = [...]
   
   2. Move to integration tests:
      Mark with @pytest.mark.integration
      Run separately from fast unit tests
```

## Language-Specific Review Patterns

### Python Specific

**pytest best practices:**
```python
# ✅ Good: Using fixtures
@pytest.fixture
def user():
    return User(username="test")

def test_user_can_login(user):
    assert user.login("password") == True

# ✅ Good: Parametrized tests for multiple cases
@pytest.mark.parametrize("email,valid", [
    ("user@example.com", True),
    ("invalid", False),
    ("@example.com", False),
])
def test_email_validation(email, valid):
    assert validate_email(email) == valid

# ❌ Avoid: setUp/tearDown (use fixtures instead)
class TestUser:
    def setUp(self):  # Old unittest style
        self.user = User()
    
    # Use pytest fixtures instead
```

**Common Python test smells:**
```python
# ❌ Using assert without pytest's rich assertions
def test_something():
    try:
        risky_operation()
        assert False, "Should have raised"
    except ValueError:
        pass
    
# ✅ Better: pytest.raises
def test_something():
    with pytest.raises(ValueError):
        risky_operation()
```

### TypeScript Specific

**Jest/Vitest best practices:**
```typescript
// ✅ Good: Descriptive describe blocks
describe('UserService', () => {
  describe('when user is authenticated', () => {
    it('should return user profile', () => {
      // test code
    });
  });
});

// ✅ Good: Using proper matchers
expect(result).toBe(true);  // For primitives
expect(obj).toEqual(expected);  // For objects
expect(array).toContain(item);  // For arrays
expect(() => dangerousOp()).toThrow(Error);  // For exceptions

// ❌ Avoid: Weak assertions
expect(result).toBeTruthy();  // Too vague
expect(result).not.toBeUndefined();  // Why not check actual value?

// ✅ Better: Specific assertions
expect(result).toBe(42);
expect(user.name).toBe('Alice');
```

**Common TypeScript test smells:**
```typescript
// ❌ Type assertions that hide problems
test('should work', () => {
  const result = someFunction() as any;  // ❌ Loses type safety
  expect(result.value).toBe(10);
});

// ✅ Better: Proper typing
test('should work', () => {
  const result: Result = someFunction();
  expect(result.value).toBe(10);
});

// ❌ Not testing async properly
test('fetches data', () => {
  fetchData().then(data => {
    expect(data).toBeDefined();  // ❌ May not execute
  });
});

// ✅ Better: Use async/await
test('fetches data', async () => {
  const data = await fetchData();
  expect(data).toBeDefined();
});
```

## Common Test Smells Catalog

See `references/test-smells.md` for comprehensive catalog of test smells and how to fix them.

**Quick reference - Top 10 test smells:**

1. **Unclear test name** - Can't tell what's being tested
2. **Missing edge cases** - Only happy path tested
3. **Shared state** - Tests affect each other
4. **Testing implementation** - Coupled to internal structure
5. **Over-mocking** - Too many mocks, tests become meaningless
6. **Weak assertions** - `assert something` instead of specific checks
7. **No error case tests** - Forgot to test failures
8. **Slow tests** - Database/network calls in unit tests
9. **Multiple concepts** - One test verifying too many things
10. **Hidden dependencies** - Test relies on external state/order

## Review Feedback Templates

Use these templates when providing feedback:

**Positive feedback:**
```
✅ test_name: Clear, follows naming convention
✅ Good use of Arrange-Act-Assert structure
✅ Comprehensive edge case coverage
✅ Tests behavior not implementation
```

**Issues to fix:**
```
❌ test_name: [specific problem]
   Impact: [why this matters]
   Fix: [concrete solution]
   
   Example:
   [code showing better approach]
```

**Suggestions:**
```
⚠️  test_name: [potential issue]
   Consider: [alternative approach]
   Benefit: [why this might be better]
```

**Missing coverage:**
```
📋 Missing test cases for [feature]:
   1. test_[scenario_1]
   2. test_[scenario_2]
   3. test_[scenario_3]
```

## Review Output Structure

When reviewing a test file, provide:

1. **Summary** (2-3 lines)
   - Overall quality assessment
   - Major issues count
   - Readiness for implementation

2. **Critical Issues** (must fix before implementing)
   - Missing essential test cases
   - Tests that will produce wrong implementation
   - Independence/isolation problems

3. **Important Issues** (should fix)
   - Clarity problems
   - Weak assertions
   - Missing edge cases

4. **Suggestions** (nice to have)
   - Naming improvements
   - Refactoring opportunities
   - Better patterns

5. **Positive Notes** (what's done well)
   - Good patterns to reinforce
   - Comprehensive coverage areas

## Example Review

**Test file:**
```python
def test_transfer():
    account1 = Account(100)
    account2 = Account(50)
    account1.transfer(30, account2)
    assert account1.balance == 70
```

**Review output:**
```
Summary: Test covers basic happy path but has clarity and completeness issues. 
Not ready for implementation - critical cases missing.

Critical Issues:
❌ test_transfer: Name doesn't specify behavior
   Fix: Rename to test_transfer_with_sufficient_funds_updates_both_balances

❌ Missing critical test case: insufficient funds scenario
   Add: test_transfer_with_insufficient_funds_raises_error
   
   def test_transfer_with_insufficient_funds_raises_error():
       sender = Account(balance=50)
       receiver = Account(balance=100)
       with pytest.raises(InsufficientFundsError):
           sender.transfer(60, receiver)

Important Issues:
⚠️  Incomplete assertion - only checks sender balance
   Also verify: assert account2.balance == 80
   
⚠️  Variable names unclear (account1, account2)
   Better: sender, receiver (makes transfer direction obvious)

Missing Coverage:
📋 Add tests for:
   1. test_transfer_zero_amount_leaves_balances_unchanged
   2. test_transfer_negative_amount_raises_error
   3. test_transfer_exact_balance_results_in_zero

Suggestions:
💡 Consider using descriptive variable names in Arrange:
   initial_sender_balance = 100
   initial_receiver_balance = 50
   transfer_amount = 30

Positive:
✅ Uses clear Arrange-Act-Assert structure
✅ Tests an important behavior
```

## Integration with TDD Workflow

**When to use this skill:**
1. After writing tests (TDD Red phase)
2. Before implementing production code
3. During code review of test changes
4. When tests feel "off" but you're not sure why

**Workflow:**
```
1. Write tests (TDD Red)
2. Review tests (THIS SKILL) ← Quality gate
3. Revise tests based on review
4. Implement code (TDD Green)
5. Refactor (TDD Refactor)
```

## Quick Review Checklist

Use this checklist for fast reviews:

```
Clarity:
□ Test names are descriptive
□ AAA structure is clear
□ Variables have meaningful names

Completeness:
□ Happy path covered
□ Edge cases covered
□ Error cases covered
□ Boundary conditions tested

Independence:
□ No shared state
□ Tests run in any order
□ Each test has own fixtures

Quality:
□ Tests behavior not implementation
□ Minimal mocking
□ Specific assertions
□ Fast execution (<100ms for unit tests)

Coverage:
□ All public methods tested
□ State transitions tested
□ Integration points tested
```

## Key Principles

1. **Tests are specifications** - They define what code should do
2. **Review before implementing** - Bad tests lead to bad code
3. **Behavior over implementation** - Tests should survive refactoring
4. **Completeness matters** - Missing tests = missing requirements
5. **Independence is essential** - Tests must run in isolation
6. **Clarity is king** - Tests are documentation
7. **Fast tests are run often** - Slow tests are skipped
8. **Good tests enable refactoring** - Bad tests prevent it

## Additional Resources

For deeper dives:
- **Test smells catalog**: references/test-smells.md
- **Review examples**: references/review-examples.md
