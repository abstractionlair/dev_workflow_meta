---
name: tdd
description: Guide for implementing Test Driven Development (TDD). Use when users want to write tests first, follow the Red-Green-Refactor cycle, create test-driven code, or need guidance on TDD practices. Supports Python (pytest, unittest), TypeScript (Jest, Vitest), and other languages with language-agnostic principles.
license: Complete terms in LICENSE.txt
---

# Test Driven Development (TDD)

This skill provides guidance for implementing Test Driven Development, emphasizing the Red-Green-Refactor cycle and test-first development practices.

## Core TDD Workflow

Follow the Red-Green-Refactor cycle strictly:

1. **Red** - Write a failing test that defines desired behavior
2. **Green** - Write minimal code to make the test pass
3. **Refactor** - Improve code quality while keeping tests green

### Implementation Pattern

**For each new feature or behavior:**

```
1. Write the test first (it should fail)
2. Run the test to confirm it fails for the right reason
3. Write the simplest code to pass the test
4. Run the test to confirm it passes
5. Refactor if needed
6. Run all tests to ensure nothing broke
7. Commit
8. Repeat for next behavior
```

**Key principle:** Never write production code without a failing test first.

## Language-Specific Setup

### Python (Primary)

**Preferred framework:** pytest (simpler syntax, better fixtures)

**Project structure:**
```
project/
├── src/
│   └── module.py
├── tests/
│   ├── __init__.py
│   └── test_module.py
├── pyproject.toml  # or setup.py
└── requirements.txt
```

**Basic pytest test pattern:**
```python
# tests/test_calculator.py
import pytest
from src.calculator import Calculator

def test_add_two_numbers():
    calc = Calculator()
    result = calc.add(2, 3)
    assert result == 5

def test_add_negative_numbers():
    calc = Calculator()
    result = calc.add(-1, -1)
    assert result == -2

@pytest.fixture
def calculator():
    return Calculator()

def test_with_fixture(calculator):
    result = calculator.multiply(3, 4)
    assert result == 12
```

**Alternative: unittest (standard library)**
```python
import unittest
from src.calculator import Calculator

class TestCalculator(unittest.TestCase):
    def setUp(self):
        self.calc = Calculator()
    
    def test_add_two_numbers(self):
        result = self.calc.add(2, 3)
        self.assertEqual(result, 5)
```

**Running tests:**
```bash
# pytest
pytest tests/
pytest tests/test_module.py
pytest tests/test_module.py::test_specific_function
pytest -v  # verbose
pytest --cov=src  # with coverage

# unittest
python -m unittest discover tests/
python -m unittest tests.test_module.TestClass.test_method
```

### TypeScript (Secondary)

**Preferred framework:** Vitest (faster) or Jest (more established)

**Project structure:**
```
project/
├── src/
│   └── module.ts
├── tests/
│   └── module.test.ts
├── package.json
├── tsconfig.json
└── vitest.config.ts  # or jest.config.js
```

**Basic Vitest/Jest test pattern:**
```typescript
// tests/calculator.test.ts
import { describe, it, expect, beforeEach } from 'vitest'; // or from '@jest/globals'
import { Calculator } from '../src/calculator';

describe('Calculator', () => {
  let calculator: Calculator;

  beforeEach(() => {
    calculator = new Calculator();
  });

  it('should add two numbers', () => {
    const result = calculator.add(2, 3);
    expect(result).toBe(5);
  });

  it('should add negative numbers', () => {
    const result = calculator.add(-1, -1);
    expect(result).toBe(-2);
  });

  describe('multiply', () => {
    it('should multiply two numbers', () => {
      const result = calculator.multiply(3, 4);
      expect(result).toBe(12);
    });
  });
});
```

**Running tests:**
```bash
# Vitest
npm run test
npm run test -- calculator.test.ts
npm run test -- --coverage

# Jest
npm test
npm test -- calculator.test.ts
npm test -- --coverage
```

### Other Languages

TDD principles are language-agnostic. Adapt the Red-Green-Refactor cycle using language-appropriate testing frameworks:

- **Java:** JUnit, TestNG
- **C#:** xUnit, NUnit, MSTest
- **Go:** built-in testing package
- **Ruby:** RSpec, Minitest
- **Rust:** built-in test framework

## Test Organization Principles

### Test Naming

**Pattern:** `test_<what>_<condition>_<expected_result>`

**Examples:**
```python
# Good - descriptive and clear
def test_withdraw_sufficient_funds_decreases_balance()
def test_withdraw_insufficient_funds_raises_error()
def test_empty_cart_has_zero_total()

# Avoid - too vague
def test_withdraw()
def test_cart()
```

**TypeScript/Jest style:**
```typescript
describe('when withdrawing with sufficient funds', () => {
  it('should decrease the balance', () => { ... });
});

describe('when withdrawing with insufficient funds', () => {
  it('should throw an error', () => { ... });
});
```

### Test Structure: Arrange-Act-Assert (AAA)

Structure every test with three clear sections:

```python
def test_transfer_between_accounts():
    # Arrange - set up test data and conditions
    sender = Account(balance=100)
    receiver = Account(balance=50)
    
    # Act - execute the behavior being tested
    sender.transfer(30, receiver)
    
    # Assert - verify the outcome
    assert sender.balance == 70
    assert receiver.balance == 80
```

Separate sections with blank lines for clarity.

### One Assertion Per Test (Guideline)

**Prefer:** One logical concept per test, even if multiple assertions needed

```python
# Good - testing one concept: transfer updates both accounts
def test_transfer_updates_both_account_balances():
    sender = Account(balance=100)
    receiver = Account(balance=50)
    sender.transfer(30, receiver)
    assert sender.balance == 70
    assert receiver.balance == 80

# Better split - if behaviors are truly independent
def test_transfer_decreases_sender_balance():
    sender = Account(balance=100)
    receiver = Account(balance=50)
    sender.transfer(30, receiver)
    assert sender.balance == 70

def test_transfer_increases_receiver_balance():
    sender = Account(balance=100)
    receiver = Account(balance=50)
    sender.transfer(30, receiver)
    assert receiver.balance == 80
```

## Test Types and When to Use Them

### Unit Tests (Primary Focus in TDD)

**What:** Test individual functions/methods in isolation
**When:** Most common - 70-80% of tests
**Characteristics:**
- Fast execution (milliseconds)
- No external dependencies (mock/stub them)
- Test one piece of logic

```python
def test_calculate_discount_10_percent_off():
    # Unit test - pure function, no dependencies
    result = calculate_discount(price=100, percent=10)
    assert result == 90
```

### Integration Tests

**What:** Test interaction between components
**When:** Testing modules working together, database operations, API calls
**Characteristics:**
- Slower than unit tests
- May use test database or test APIs
- Test real interactions

```python
def test_user_registration_saves_to_database(test_db):
    # Integration test - tests service + database
    service = UserService(test_db)
    user = service.register("test@example.com", "password")
    
    saved_user = test_db.query(User).filter_by(email="test@example.com").first()
    assert saved_user is not None
    assert saved_user.email == "test@example.com"
```

### Test Doubles (Mocks, Stubs, Fakes)

Use when isolating code from dependencies:

**Python (unittest.mock):**
```python
from unittest.mock import Mock, patch

def test_send_notification_calls_email_service():
    # Mock external email service
    email_service = Mock()
    notifier = Notifier(email_service)
    
    notifier.send_notification("user@example.com", "Hello")
    
    email_service.send.assert_called_once_with("user@example.com", "Hello")

@patch('requests.get')
def test_fetch_user_data(mock_get):
    # Stub HTTP request
    mock_get.return_value.json.return_value = {'name': 'John'}
    
    result = fetch_user_data(user_id=1)
    
    assert result['name'] == 'John'
```

**TypeScript (Vitest/Jest):**
```typescript
import { vi } from 'vitest';

test('should call email service', () => {
  const emailService = {
    send: vi.fn()
  };
  const notifier = new Notifier(emailService);
  
  notifier.sendNotification('user@example.com', 'Hello');
  
  expect(emailService.send).toHaveBeenCalledWith('user@example.com', 'Hello');
});
```

## TDD Best Practices

### Start with the Simplest Test

Begin with the easiest behavior, often edge cases:

```python
# Start here - simplest case
def test_empty_string_has_zero_word_count():
    assert word_count("") == 0

# Then build up
def test_single_word_has_count_one():
    assert word_count("hello") == 1

def test_multiple_words_separated_by_spaces():
    assert word_count("hello world") == 2
```

### Write the Test You Wish You Had

Write tests that express intent clearly, as if the API already exists:

```python
# Write this test first - even though Calculator doesn't exist yet
def test_calculator_adds_numbers():
    calc = Calculator()
    result = calc.add(2, 3)
    assert result == 5

# This drives the API design - then create the minimal Calculator class
```

### Triangulation: Add Tests to Drive Generalization

Start with specific cases, add tests to force generalizations:

```python
# Test 1 - could be solved with return 5
def test_add_2_and_3():
    assert add(2, 3) == 5

# Test 2 - now must implement actual addition logic
def test_add_1_and_1():
    assert add(1, 1) == 2

# Test 3 - handle edge cases
def test_add_negative_numbers():
    assert add(-1, -1) == -2
```

### Test Behavior, Not Implementation

Focus on what the code does, not how:

```python
# Good - tests behavior
def test_user_registration_creates_active_user():
    user = register_user("test@example.com")
    assert user.is_active == True

# Avoid - tests implementation details
def test_user_registration_calls_database_insert():
    # This test breaks if you refactor how data is saved
    register_user("test@example.com")
    assert mock_db.insert.called
```

### Keep Tests Independent

Each test should run in isolation:

```python
# Good - each test creates its own data
def test_account_deposit():
    account = Account(balance=100)
    account.deposit(50)
    assert account.balance == 150

def test_account_withdraw():
    account = Account(balance=100)
    account.withdraw(30)
    assert account.balance == 70

# Avoid - tests depending on execution order
balance = 100  # shared state
def test_deposit():
    global balance
    balance += 50
    assert balance == 150

def test_withdraw():  # Fails if deposit didn't run first
    global balance
    balance -= 30
    assert balance == 120
```

### Test Error Cases

Don't just test the happy path:

```python
def test_withdraw_with_sufficient_funds_succeeds():
    account = Account(balance=100)
    account.withdraw(50)
    assert account.balance == 50

def test_withdraw_with_insufficient_funds_raises_error():
    account = Account(balance=100)
    with pytest.raises(InsufficientFundsError):
        account.withdraw(150)

def test_withdraw_negative_amount_raises_error():
    account = Account(balance=100)
    with pytest.raises(ValueError, match="Amount must be positive"):
        account.withdraw(-10)
```

**TypeScript:**
```typescript
test('should throw error for insufficient funds', () => {
  const account = new Account(100);
  expect(() => account.withdraw(150)).toThrow(InsufficientFundsError);
});
```

### Refactor Only When Tests Are Green

Never refactor while tests are failing:

1. Get tests passing first (green)
2. Then refactor production code
3. Run tests after each refactoring step
4. If tests fail, revert and try different refactoring

## Common TDD Patterns

### Outside-In TDD (Feature-Level)

Start with acceptance/integration test, then unit tests:

```python
# 1. Start with high-level integration test (will fail)
def test_user_can_transfer_money_between_accounts():
    service = BankingService(database)
    
    sender_id = service.create_account(balance=100)
    receiver_id = service.create_account(balance=50)
    
    service.transfer(sender_id, receiver_id, amount=30)
    
    assert service.get_balance(sender_id) == 70
    assert service.get_balance(receiver_id) == 80

# 2. Drop down to unit tests for each component
def test_account_validates_sufficient_funds():
    account = Account(balance=100)
    assert account.can_withdraw(50) == True
    assert account.can_withdraw(150) == False

def test_transfer_updates_both_accounts():
    # ... unit test for transfer logic
```

### Inside-Out TDD (Component-Level)

Start with core units, build up:

```python
# 1. Start with simple unit
def test_account_stores_balance():
    account = Account(balance=100)
    assert account.balance == 100

# 2. Add behavior
def test_account_withdraw_decreases_balance():
    account = Account(balance=100)
    account.withdraw(30)
    assert account.balance == 70

# 3. Build up to service
def test_transfer_service_uses_accounts():
    # Integrate the units you built
```

## Practical TDD Session Example

**Requirement:** Create a function to validate email addresses

```python
# Step 1: RED - Write first test (simple case)
def test_valid_email_returns_true():
    assert is_valid_email("user@example.com") == True

# Step 2: GREEN - Minimal implementation
def is_valid_email(email):
    return True  # Simplest thing that passes

# Step 3: RED - Add test to force real logic
def test_email_without_at_returns_false():
    assert is_valid_email("userexample.com") == False

# Step 4: GREEN - Implement check
def is_valid_email(email):
    return "@" in email

# Step 5: RED - Add test for domain
def test_email_without_domain_returns_false():
    assert is_valid_email("user@") == False

# Step 6: GREEN - Add domain check
def is_valid_email(email):
    if "@" not in email:
        return False
    parts = email.split("@")
    return len(parts) == 2 and len(parts[1]) > 0

# Step 7: REFACTOR - Clean up
def is_valid_email(email):
    if "@" not in email:
        return False
    local, domain = email.split("@", 1)
    return bool(local and domain)

# Continue adding tests for edge cases...
```

## Quick Reference Commands

**Python (pytest):**
```bash
pytest                          # Run all tests
pytest -v                       # Verbose output
pytest -k "test_name"          # Run specific test by name
pytest --cov=src --cov-report=html  # Coverage report
pytest --lf                     # Run last failed tests
pytest -x                       # Stop on first failure
pytest --pdb                    # Drop into debugger on failure
```

**TypeScript (Vitest):**
```bash
npm run test                    # Run all tests
npm run test -- --reporter=verbose  # Verbose output
npm run test -- calculator      # Run matching tests
npm run test -- --coverage      # Coverage report
npm run test -- --watch         # Watch mode
```

**TypeScript (Jest):**
```bash
npm test                        # Run all tests
npm test -- --verbose           # Verbose output
npm test -- calculator          # Run matching tests
npm test -- --coverage          # Coverage report
npm test -- --watch             # Watch mode
```

## When NOT to Use Pure TDD

TDD isn't always the best approach:

- **Exploratory coding:** When you're not sure what the solution looks like
- **Spike solutions:** Quick prototypes to test feasibility
- **UI/visual design:** When you need to see visual results to iterate
- **Legacy code:** Often need to refactor first to make code testable

In these cases: explore first, then add tests, then refactor with TDD.

## Helpful Scripts

The skill includes utility scripts to streamline TDD workflow:

**Generate test templates:**
```bash
python scripts/generate_test_template.py <module_name> [--language python|typescript]
```
Creates a test file template with TDD structure, fixtures, and examples. Saves time and ensures consistency.

**Track TDD cycle:**
```bash
python scripts/tdd_cycle.py pytest tests/
python scripts/tdd_cycle.py npm test
```
Runs tests and provides visual feedback about Red-Green-Refactor phases. Helpful for learning TDD discipline.

## Advanced Topics Reference

For advanced TDD topics, see:
- **Property-based testing:** references/property-based-testing.md (Hypothesis for Python, fast-check for TypeScript)
- **Mutation testing:** references/mutation-testing.md (mutmut for Python, Stryker for TypeScript)
- **Test data builders:** references/test-builders.md (Factory patterns for complex test data)

## Key Reminders

1. **Write the test first** - No exceptions for production code
2. **Make it fail first** - Confirm the test fails for the right reason
3. **Write minimal code** - Just enough to pass the current test
4. **Refactor fearlessly** - Tests give you confidence
5. **Keep tests fast** - Slow tests won't be run
6. **One behavior at a time** - Small steps lead to better design
7. **Test the interface, not implementation** - Tests should survive refactoring
