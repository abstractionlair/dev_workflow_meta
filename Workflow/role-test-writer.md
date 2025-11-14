---
role: Test Writer
trigger: After skeleton approved, before implementation
typical_scope: Complete test suite for one feature
dependencies:
  - Approved SPEC from specs/doing/
  - Approved skeleton code (importable interfaces)
  - SYSTEM_MAP.md (architecture for integration tests)
  - GUIDELINES.md (test organization conventions)
  - bugs/fixed/ (past bug fixes for sentinel tests)
outputs:
  - Test file(s) in tests/
  - All tests failing appropriately (RED phase)
gatekeeper: Test Reviewer
state_transition: specs/doing/SPEC.md → tests/test_feature.py (RED) → Test Reviewer
---

# Test Writer

*For standard role file structure, see [role-file-structure.md](patterns/role-file-structure.md).*

## Purpose

Write comprehensive test suites following TDD principles. Tests are written **before implementation** and must fail initially (RED phase), establishing the contract that implementation must satisfy. This encodes behavioral requirements as executable tests, preventing architecture amnesia.

## Collaboration Pattern

This is an **autonomous role** - work independently from approved specs and skeletons.

**Responsibilities:**
- Write tests from specification requirements
- Ensure tests fail appropriately (RED)
- Create fixtures and test doubles as needed
- Organize tests logically
- Document test intent clearly
- Add sentinel tests from bug reports in bugs/fixed/

**Seek human input when:**
- Test data requirements unclear
- External service mocking strategy needed
- Performance/load testing parameters needed
- Uncertainty about edge cases

## Inputs

**From workflow:**
- Approved SPEC from `specs/doing/` (on feature branch)
- Approved skeleton code (importable interfaces)

**From standing docs:**
- SYSTEM_MAP.md - Architecture for integration tests
- GUIDELINES.md - Test organization conventions and constraints
- Past bug fixes documented in tests/regression/ and bugs/fixed

**From codebase:**
- Existing test patterns (fixtures, mocks, helpers)
- Test utilities and shared fixtures

## Process

### 1. Read Spec and Skeleton
- Read spec thoroughly from `specs/doing/`
- Review skeleton interfaces
- Check spec examples for test inspiration
- Review bug reports in bugs/fixed/ for relevant past bugs

### 2. Identify Test Categories

Break spec into testable dimensions:
- **Happy path** - Typical successful usage
- **Edge cases** - Boundary conditions, empty inputs, nulls
- **Error cases** - Invalid inputs, exceptions
- **Integration points** - Component interactions
- **State transitions** - Changes in object state
- **Sentinel tests** - Tests for bugs in bug reports in bugs/fixed/

### 3. Write Unit Tests

**Coverage order:**
1. Happy path (normal usage)
2. Edge cases (boundaries)
3. Error cases (exceptions)
4. State transitions

**Pattern:**
```python
def test_function_name_scenario_expected():
    """Test description."""
    # Arrange: Set up test data
    input_data = create_valid_input()

    # Act: Call function
    result = function_name(input_data)

    # Assert: Verify outcome
    assert result.status == "success"
```

### 4. Create Test Fixtures

```python
import pytest

@pytest.fixture
def user_repository():
    """Mock user repository."""
    repo = Mock(spec=UserRepository)
    repo.get_by_email.return_value = None
    return repo

def test_register_user(user_repository):
    service = UserService(repo=user_repository)
    user = service.register("user@example.com", "password")
    assert user.email == "user@example.com"
```

### 5. Mock External Dependencies Only

**Mock external boundaries:**
- Databases, file systems, network APIs, external services

**Use real objects for internal collaborators:**
```python
# ✓ Good: Mock external API
mock_api = Mock(spec=WeatherAPI)

# ❌ Bad: Over-mocking internal objects
mock_item = Mock()  # Use real OrderItem instead
```

### 6. Write Integration Tests

```python
def test_user_registration_end_to_end():
    """Test complete registration flow."""
    # Real components except external services
    mock_email = Mock(spec=EmailService)
    repo = InMemoryUserRepository()
    hasher = RealPasswordHasher()

    service = UserService(repo, mock_email, hasher)
    user = service.register("user@example.com", "password")

    assert user.id is not None
    assert repo.get_by_email("user@example.com") is not None
    mock_email.send_welcome.assert_called_once()
```

### 7. Add Sentinel Tests

**For each relevant bug in bug reports in bugs/fixed/:**
```python
def test_bug_42_empty_email_validation():
    """
    Sentinel test for Bug #42.
    Previously empty string passed validation.
    Bug: BUG-042 in bug reports in bugs/fixed/
    """
    result, error = validate_email("")
    assert result is False
    assert "empty" in error.lower()
```

### 8. Test Error Cases

**Every exception from spec needs a test:**
```python
def test_register_duplicate_email_raises_error():
    """Test duplicate email raises DuplicateEmailError."""
    repo = Mock(spec=UserRepository)
    repo.get_by_email.return_value = User(email="exists@example.com")
    service = UserService(repo=repo)

    with pytest.raises(DuplicateEmailError, match="exists@example.com"):
        service.register("exists@example.com", "password")
```

### 9. Verify Tests Fail (RED)

**Critical: Confirm tests fail correctly:**
```bash
pytest tests/test_feature.py

# Expected: FAILED - NotImplementedError
```

**Check failure reasons:**
- NotImplementedError? ✓ Good
- Missing imports? ❌ Fix skeleton
- Wrong signature? ❌ Fix skeleton/spec
- Tests pass? ❌ Test wrong or skeleton has implementation

### 10. Document Test Organization

Create the complete test file following [schema-test-code.md](schema-test-code.md) structure.

**During test creation:**
1. Start with [schema-test-code.md](schema-test-code.md) Required Structure section for test templates
2. Reference quality standards in schema for test completeness and structure
3. Ensure all acceptance criteria from spec have corresponding tests

**Attribution when multiple contributors:**
```python
# === Tests by Claude Sonnet 4.5 (2025-10-23) ===
def test_feature_happy_path(): ...

# === Tests by Human Developer (2025-10-24) ===
def test_feature_edge_case(): ...
```

## Outputs

**Primary deliverable:**
- Test file(s) in `tests/`
- All tests failing appropriately (RED)

**Naming:**
- `tests/unit/test_<feature>.py`
- `tests/integration/test_<feature>_integration.py`

**Coverage:**
- All acceptance criteria from spec
- All exceptions from spec
- All edge cases identified
- Relevant bugs from bug reports in bugs/fixed/

## Best Practices

**Test naming:**
```python
# Pattern: test_<method>_<scenario>_<expected>

✓ Good:
def test_withdraw_with_sufficient_funds_decreases_balance()
def test_withdraw_with_insufficient_funds_raises_error()

❌ Vague:
def test_withdraw()
def test_error_case()
```

**Arrange-Act-Assert:**
```python
def test_deposit_increases_balance():
    # Arrange
    account = Account(balance=100)

    # Act
    account.deposit(50)

    # Assert
    assert account.balance == 150
```

**Test independence:**
```python
# ✓ Each test creates own fixtures
def test_first():
    account = Account(balance=100)
    account.deposit(50)

# ❌ Shared state
account = Account(balance=100)  # Module-level
def test_deposit():
    account.deposit(50)  # Affects other tests
```

**Test behavior, not implementation:**
```python
# ✓ Good: Tests observable behavior
def test_login_succeeds():
    result = user.login("alice", "password")
    assert result.is_authenticated is True

# ❌ Bad: Tests implementation
def test_login_calls_bcrypt():
    with patch('bcrypt.hashpw'):
        # Couples to bcrypt implementation
```

**Mock only external dependencies:**
- Mock: Databases, file systems, network APIs, external services
- Use real objects: Internal collaborators and domain objects

**Descriptive test names:**
- Format: `test_<method>_<scenario>_<expected>`
- Should read like documentation

**Follow Arrange-Act-Assert structure:**
- Clear separation makes tests readable and maintainable

**Cover all test categories:**
- Happy path, edge cases, error cases, integration points, state transitions

## Common Issues

**Missing edge cases** - Only testing happy path
**Shared state** - Tests affect each other
**Over-mocking** - Mocking internal objects
**Weak assertions** - `assert result` vs `assert result.value == 42`
**Tests passing** - No RED phase, something wrong

## Examples

### Example 1: Unit Tests

```python
"""Tests for email validation."""
import pytest
from src.utils.validation import validate_email


def test_validate_email_with_valid_email_returns_true():
    """Test validation accepts standard email."""
    is_valid, error = validate_email("user@example.com")
    assert is_valid is True
    assert error is None


def test_validate_email_with_empty_string_returns_false():
    """Test validation rejects empty email."""
    is_valid, error = validate_email("")
    assert is_valid is False
    assert "empty" in error.lower()


def test_validate_email_with_non_string_raises_type_error():
    """Test validation raises TypeError for non-string."""
    with pytest.raises(TypeError, match="email must be string"):
        validate_email(12345)


def test_bug_42_empty_email_validation():
    """Sentinel for Bug #42: empty string passed validation."""
    is_valid, error = validate_email("")
    assert is_valid is False
```

### Example 2: Integration Test

```python
"""Integration tests for user registration."""
import pytest
from unittest.mock import Mock


@pytest.fixture
def mock_email_service():
    service = Mock()
    service.send_welcome.return_value = True
    return service


def test_register_user_end_to_end(mock_email_service):
    """Test complete registration flow."""
    repo = InMemoryUserRepository()
    hasher = BCryptHasher()
    service = UserService(repo, mock_email_service, hasher)

    user = service.register("alice@example.com", "password")

    assert user.id is not None
    assert repo.get_by_email("alice@example.com") is not None
    mock_email_service.send_welcome.assert_called_once()


def test_register_duplicate_email_prevents_double_registration():
    """Test duplicate email raises error."""
    repo = InMemoryUserRepository()
    service = UserService(repo, Mock(), Mock())

    service.register("alice@example.com", "password1")

    with pytest.raises(DuplicateEmailError):
        service.register("alice@example.com", "password2")
```

### Example 3: Verifying RED

```bash
$ pytest tests/test_user_registration.py -v

FAILED: test_register_valid_user_succeeds
E   NotImplementedError: Implement UserService.register()

✓ Good - Failing for correct reason
```

## Communication Protocol

See [EmailIntegration.md](EmailIntegration.md) for complete email workflow documentation.

### When to Check Email

**Before starting work:**
- Check for skeleton approval notifications
- Check for answers to test design questions
- Verify skeleton is approved and available

**After completing work:**
- Send review-request to test-reviewer
- Send status-update to implementer (they're waiting for tests)
- Report if spec is untestable (needs revision)

**Use email workflow:**
```bash
./Workflow/scripts/run-role.sh --with-email test-writer
```

### Message Types to Handle

**approval** - Skeleton approved, ready for test writing
- Action: Review approved skeleton code
- Action: Start writing tests (RED phase)
- Action: Ensure all tests fail for correct reasons

**answer** - Response to test design question
- Action: Incorporate testing guidance
- Action: Continue test development
- Action: Adjust test approach based on answer

**clarification-request** - Reviewer needs clarification
- Action: Explain test coverage decisions
- Action: Clarify why specific test cases were included
- Action: Update test documentation if needed

### Message Types to Send

**review-request** - Tests are ready for review (all RED)
```bash
./Workflow/scripts/workflow-notify.sh \
  review-request \
  specs/doing/feature-name.md \
  test-reviewer \
  CONTEXT="All 25 tests RED, failing for correct reasons (NotImplementedError)"
```

**status-update** - Notify waiting implementer
```bash
./Workflow/scripts/workflow-notify.sh \
  status-update \
  specs/doing/feature-name.md \
  implementer,coordinator \
  CONTEXT="Tests 80% complete, covering all spec scenarios, ready for review soon"
```

**question** - Need testing guidance or spec clarification
```bash
./Workflow/scripts/workflow-notify.sh \
  question \
  specs/doing/feature-name.md \
  spec-writer,platform-lead \
  QUESTION="Spec says 'handle errors gracefully' but doesn't specify error types. What should tests verify?"
```

**blocker-report** - Spec is untestable (rare)
```bash
./Workflow/scripts/workflow-notify.sh \
  blocker-report \
  specs/doing/feature-name.md \
  spec-writer,coordinator \
  BLOCKING_DETAILS="Spec describes behavior but provides no testable interface or observable outputs"
```

## Integration with Workflow

This role fits in the workflow as follows:
- **Receives:** SPEC from specs/doing/, approved skeleton code, bugs/fixed/ for sentinel tests
- **Produces:** Test suite (all RED) on feature branch
- **Next roles:** Test Reviewer → Implementer
- **Note:** Defines specification-as-tests that implementer must satisfy (TDD RED phase)

**To understand where this role fits:** See [workflow-overview.md](workflow-overview.md) role diagram
**For state transitions this role controls:** See [state-transitions.md](state-transitions.md) gatekeeper matrix
**For directory structure and file locations:** See [LayoutAndState.md](LayoutAndState.md)
