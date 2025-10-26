# TEST CODE Ontology

## Purpose

Test code defines **executable specifications** that verify behavioral contracts in Test-Driven Development. Well-crafted tests:
- Drive implementation through RED → GREEN → REFACTOR cycle
- Verify all acceptance criteria from specifications
- Provide living documentation of system behavior
- Enable confident refactoring through regression detection
- Isolate failures to specific behaviors

This schema defines what test code should look like across supported languages (Python with pytest, TypeScript with Jest).

---

## Document Type

**Artifact:** Test code files
**Location:** `tests/unit/test_*.{py,ts}`, `tests/integration/test_*_integration.{py,ts}`
**Format:** Test functions/methods using testing framework conventions
**Created by:** Test Writer
**Reviewed by:** Test Reviewer
**Consumed by:** Implementer (to drive implementation), CI/CD (for verification)

---

## Required Structure

### 1. File Header

```python
"""
Tests for: user_service.py
Feature: User registration and authentication
Spec: specs/done/user-authentication.md

Tests written: 2025-10-26
Test Writer: Claude Sonnet 4.5

Coverage targets:
- Line coverage: >80%
- Branch coverage: >70%
"""
```

**Required elements:**
- What's being tested (module/feature)
- Link to spec that defines behavior
- Test creation date and author
- Coverage targets

---

### 2. Imports

```python
import pytest
from datetime import datetime
from user_service import UserService, User
from user_service import UserAlreadyExistsError, InvalidCredentialsError, WeakPasswordError
```

**Import organization:**
1. Testing framework (pytest, jest)
2. Standard library
3. Module under test
4. Test doubles/fixtures (if in separate file)

---

### 3. Test Fixtures (Test Setup)

```python
@pytest.fixture
def mock_user_repository():
    """
    Mock UserRepository for testing in isolation.

    Returns in-memory implementation that doesn't require database.
    """
    class MockUserRepository:
        def __init__(self):
            self._users = {}

        def save_user(self, user: User) -> None:
            self._users[user.email] = user

        def find_by_email(self, email: str) -> User | None:
            return self._users.get(email.lower())

        def email_exists(self, email: str) -> bool:
            return email.lower() in self._users

    return MockUserRepository()


@pytest.fixture
def mock_password_hasher():
    """Mock PasswordHasher for predictable test behavior."""
    class MockPasswordHasher:
        def hash_password(self, password: str) -> str:
            return f"hashed_{password}"

        def verify_password(self, password: str, password_hash: str) -> bool:
            return password_hash == f"hashed_{password}"

    return MockPasswordHasher()


@pytest.fixture
def mock_id_generator():
    """Mock IdGenerator for deterministic IDs in tests."""
    class MockIdGenerator:
        def __init__(self):
            self._counter = 0

        def generate_id(self) -> str:
            self._counter += 1
            return f"test-id-{self._counter}"

    return MockIdGenerator()


@pytest.fixture
def user_service(mock_user_repository, mock_password_hasher, mock_id_generator):
    """
    UserService instance with all dependencies mocked.

    Use this fixture in tests to get isolated UserService instance.
    """
    return UserService(mock_user_repository, mock_password_hasher, mock_id_generator)
```

**Requirements:**
- Fixtures provide mock implementations of dependencies
- Mocks are simple, predictable (no external dependencies)
- Fixture names clearly indicate what they provide
- Docstrings explain fixture purpose

---

### 4. Test Functions (AAA Pattern)

Every test follows **Arrange-Act-Assert (AAA)** pattern:

```python
def test_register_user_creates_user_with_hashed_password(user_service):
    """
    Test: register_user() hashes password before storage.

    Acceptance criteria: AC1 - Passwords must be hashed with bcrypt
    """
    # Arrange: Set up test inputs
    email = "alice@example.com"
    password = "SecurePass123!"

    # Act: Execute the behavior being tested
    user = user_service.register_user(email, password)

    # Assert: Verify expected outcomes
    assert user.email == email
    assert user.password_hash == f"hashed_{password}"
    assert user.password_hash != password  # Not storing plain text
```

**AAA sections:**
- **Arrange:** Set up inputs, mocks, expected values
- **Act:** Call the method under test (ONE action)
- **Assert:** Verify outcomes (related assertions grouped)

**Test naming:**
- Format: `test_<method>_<scenario>_<expected_result>`
- Descriptive: Reader understands what's tested without reading code
- Examples:
  - `test_register_user_raises_error_when_email_exists`
  - `test_authenticate_user_succeeds_with_valid_credentials`
  - `test_register_user_normalizes_email_to_lowercase`

---

### 5. Happy Path Tests

Test the main success scenario first:

```python
def test_register_user_succeeds_with_valid_inputs(user_service):
    """
    Test: register_user() creates user account with valid email and password.

    Acceptance criteria: AC1 - User can register with email and password
    """
    # Arrange
    email = "alice@example.com"
    password = "SecurePass123!"

    # Act
    user = user_service.register_user(email, password)

    # Assert
    assert user.id == "test-id-1"  # Predictable from mock
    assert user.email == email
    assert user.password_hash == f"hashed_{password}"
    assert user.is_active is True
    assert isinstance(user.created_at, datetime)


def test_authenticate_user_succeeds_with_valid_credentials(user_service):
    """
    Test: authenticate_user() returns user when credentials valid.

    Acceptance criteria: AC2 - User can login with email and password
    """
    # Arrange: Register a user first
    email = "alice@example.com"
    password = "SecurePass123!"
    registered_user = user_service.register_user(email, password)

    # Act: Authenticate with same credentials
    authenticated_user = user_service.authenticate_user(email, password)

    # Assert: Same user returned
    assert authenticated_user.id == registered_user.id
    assert authenticated_user.email == email
```

---

### 6. Error Case Tests

Test all error scenarios from spec:

```python
def test_register_user_raises_error_when_email_already_exists(user_service):
    """
    Test: register_user() prevents duplicate email registration.

    Acceptance criteria: AC3 - System rejects duplicate emails
    """
    # Arrange: Register user once
    email = "alice@example.com"
    password = "SecurePass123!"
    user_service.register_user(email, password)

    # Act & Assert: Second registration should fail
    with pytest.raises(UserAlreadyExistsError) as exc_info:
        user_service.register_user(email, password)

    assert exc_info.value.email == email
    assert "already exists" in str(exc_info.value).lower()


def test_register_user_raises_error_for_weak_password(user_service):
    """
    Test: register_user() enforces password strength requirements.

    Acceptance criteria: AC4 - Passwords must be 8+ chars with mixed case, digit, special
    """
    # Arrange
    email = "alice@example.com"
    weak_passwords = [
        "short",           # Too short
        "alllowercase",    # No uppercase
        "ALLUPPERCASE",    # No lowercase
        "NoDigits!",       # No digits
        "NoSpecial123",    # No special chars
    ]

    # Act & Assert: Each weak password should fail
    for weak_password in weak_passwords:
        with pytest.raises(WeakPasswordError):
            user_service.register_user(email, weak_password)


def test_authenticate_user_raises_error_for_wrong_password(user_service):
    """
    Test: authenticate_user() rejects incorrect passwords.

    Acceptance criteria: AC5 - Invalid credentials are rejected
    """
    # Arrange: Register user
    email = "alice@example.com"
    correct_password = "SecurePass123!"
    user_service.register_user(email, correct_password)

    # Act & Assert: Wrong password should fail
    wrong_password = "WrongPassword456!"
    with pytest.raises(InvalidCredentialsError):
        user_service.authenticate_user(email, wrong_password)


def test_authenticate_user_raises_error_for_nonexistent_email(user_service):
    """
    Test: authenticate_user() rejects emails that don't exist.

    Acceptance criteria: AC5 - Invalid credentials are rejected
    """
    # Arrange: No user registered

    # Act & Assert: Login with non-existent email should fail
    with pytest.raises(InvalidCredentialsError):
        user_service.authenticate_user("nobody@example.com", "AnyPassword123!")
```

---

### 7. Edge Case Tests

Test boundary conditions and unusual inputs:

```python
def test_register_user_normalizes_email_to_lowercase(user_service):
    """
    Test: register_user() stores emails in lowercase for consistency.

    Edge case: Mixed-case email inputs
    """
    # Arrange
    mixed_case_email = "Alice@Example.COM"
    password = "SecurePass123!"

    # Act
    user = user_service.register_user(mixed_case_email, password)

    # Assert
    assert user.email == "alice@example.com"


def test_authenticate_user_is_case_insensitive_for_email(user_service):
    """
    Test: authenticate_user() finds user regardless of email case.

    Edge case: User registers with one case, logs in with different case
    """
    # Arrange: Register with lowercase
    user_service.register_user("alice@example.com", "SecurePass123!")

    # Act: Authenticate with uppercase
    user = user_service.authenticate_user("ALICE@EXAMPLE.COM", "SecurePass123!")

    # Assert: Should find user
    assert user.email == "alice@example.com"


def test_register_user_generates_unique_ids_for_multiple_users(user_service):
    """
    Test: register_user() assigns unique IDs to different users.

    Edge case: Multiple registrations should get different IDs
    """
    # Arrange
    users_data = [
        ("alice@example.com", "Password123!"),
        ("bob@example.com", "SecurePass456!"),
        ("carol@example.com", "StrongPwd789!"),
    ]

    # Act
    users = [user_service.register_user(email, pwd) for email, pwd in users_data]

    # Assert
    ids = [user.id for user in users]
    assert len(ids) == len(set(ids))  # All IDs unique
```

---

## Quality Standards

Tests pass review if:

### 1. Coverage Completeness
✓ All acceptance criteria from spec have tests
✓ Happy paths tested
✓ All error cases tested
✓ Edge cases and boundary conditions tested
✓ Line coverage >80%, branch coverage >70%

### 2. Test Isolation
✓ Each test runs independently (no shared state)
✓ Tests can run in any order
✓ Tests use mocks/stubs for external dependencies
✓ No database, network, or filesystem dependencies in unit tests

### 3. Clarity
✓ Test names describe what's tested and expected outcome
✓ AAA pattern clearly visible
✓ Single logical assertion per test (or closely related assertions)
✓ Clear failure messages

### 4. Maintainability
✓ Tests verify behavior, not implementation details
✓ Tests don't break when code refactored (GREEN stays GREEN)
✓ Minimal duplication (DRY via fixtures)
✓ Fast execution (<1s for unit test suite)

---

## Language-Specific Guidelines

### Python (pytest)

**Test discovery:**
- Files: `test_*.py` or `*_test.py`
- Functions: `test_*`
- Classes: `Test*` with `test_*` methods

**Fixtures:**
```python
@pytest.fixture
def mock_dependency():
    return MockDependency()
```

**Assertions:**
```python
assert value == expected
assert "substring" in string
assert len(items) > 0
```

**Exceptions:**
```python
with pytest.raises(CustomError) as exc_info:
    function_that_raises()

assert exc_info.value.message == "Expected message"
```

**Parametrized tests:**
```python
@pytest.mark.parametrize("input,expected", [
    ("alice@example.com", "alice@example.com"),
    ("ALICE@EXAMPLE.COM", "alice@example.com"),
    ("Alice@Example.Com", "alice@example.com"),
])
def test_normalize_email(input, expected):
    assert normalize_email(input) == expected
```

---

### TypeScript (Jest)

**Test discovery:**
- Files: `*.test.ts` or `*.spec.ts`

**Test structure:**
```typescript
describe("UserService", () => {
  describe("registerUser", () => {
    it("creates user with hashed password", () => {
      // Arrange
      const service = new UserService(mockRepo, mockHasher, mockIdGen);
      const email = "alice@example.com";
      const password = "SecurePass123!";

      // Act
      const user = service.registerUser(email, password);

      // Assert
      expect(user.email).toBe(email);
      expect(user.passwordHash).toBe(`hashed_${password}`);
    });
  });
});
```

**Mocks:**
```typescript
const mockRepository: UserRepository = {
  saveUser: jest.fn(),
  findByEmail: jest.fn(),
  emailExists: jest.fn(),
};
```

**Exceptions:**
```typescript
expect(() => {
  service.registerUser(email, password);
}).toThrow(UserAlreadyExistsError);
```

---

## Complete Example: User Authentication Tests

### Python Example

```python
"""
Tests for: user_service.py
Feature: User registration and authentication
Spec: specs/done/user-authentication.md

Tests written: 2025-10-26
Test Writer: Claude Sonnet 4.5

Coverage targets:
- Line coverage: >80%
- Branch coverage: >70%
"""

import pytest
from datetime import datetime
from user_service import UserService, User
from user_service import UserAlreadyExistsError, InvalidCredentialsError, WeakPasswordError


# === Fixtures ===

@pytest.fixture
def mock_user_repository():
    """Mock UserRepository for isolated testing."""
    class MockUserRepository:
        def __init__(self):
            self._users = {}

        def save_user(self, user: User) -> None:
            self._users[user.email] = user

        def find_by_email(self, email: str) -> User | None:
            return self._users.get(email.lower())

        def email_exists(self, email: str) -> bool:
            return email.lower() in self._users

    return MockUserRepository()


@pytest.fixture
def mock_password_hasher():
    """Mock PasswordHasher for predictable hashing."""
    class MockPasswordHasher:
        def hash_password(self, password: str) -> str:
            return f"hashed_{password}"

        def verify_password(self, password: str, password_hash: str) -> bool:
            return password_hash == f"hashed_{password}"

    return MockPasswordHasher()


@pytest.fixture
def mock_id_generator():
    """Mock IdGenerator for deterministic IDs."""
    class MockIdGenerator:
        def __init__(self):
            self._counter = 0

        def generate_id(self) -> str:
            self._counter += 1
            return f"test-id-{self._counter}"

    return MockIdGenerator()


@pytest.fixture
def user_service(mock_user_repository, mock_password_hasher, mock_id_generator):
    """UserService with mocked dependencies."""
    return UserService(mock_user_repository, mock_password_hasher, mock_id_generator)


# === Happy Path Tests ===

def test_register_user_creates_user_with_valid_inputs(user_service):
    """
    Test: register_user() creates user account successfully.

    Acceptance criteria: AC1 - User can register with email and password
    """
    # Arrange
    email = "alice@example.com"
    password = "SecurePass123!"

    # Act
    user = user_service.register_user(email, password)

    # Assert
    assert user.id == "test-id-1"
    assert user.email == email
    assert user.password_hash == "hashed_SecurePass123!"
    assert user.is_active is True
    assert isinstance(user.created_at, datetime)


def test_authenticate_user_succeeds_with_valid_credentials(user_service):
    """
    Test: authenticate_user() returns user for valid credentials.

    Acceptance criteria: AC2 - User can login with email and password
    """
    # Arrange
    email = "alice@example.com"
    password = "SecurePass123!"
    registered_user = user_service.register_user(email, password)

    # Act
    authenticated_user = user_service.authenticate_user(email, password)

    # Assert
    assert authenticated_user.id == registered_user.id
    assert authenticated_user.email == email


# === Error Case Tests ===

def test_register_user_raises_error_when_email_already_exists(user_service):
    """
    Test: register_user() prevents duplicate emails.

    Acceptance criteria: AC3 - System rejects duplicate emails
    """
    # Arrange
    email = "alice@example.com"
    password = "SecurePass123!"
    user_service.register_user(email, password)

    # Act & Assert
    with pytest.raises(UserAlreadyExistsError) as exc_info:
        user_service.register_user(email, password)

    assert exc_info.value.email == email


def test_register_user_raises_error_for_weak_password(user_service):
    """
    Test: register_user() enforces password strength.

    Acceptance criteria: AC4 - Passwords must be 8+ chars, mixed case, digit, special
    """
    # Arrange
    email = "alice@example.com"

    # Act & Assert
    with pytest.raises(WeakPasswordError):
        user_service.register_user(email, "short")  # Too short


def test_authenticate_user_raises_error_for_wrong_password(user_service):
    """
    Test: authenticate_user() rejects incorrect passwords.

    Acceptance criteria: AC5 - Invalid credentials rejected
    """
    # Arrange
    email = "alice@example.com"
    user_service.register_user(email, "CorrectPass123!")

    # Act & Assert
    with pytest.raises(InvalidCredentialsError):
        user_service.authenticate_user(email, "WrongPass456!")


def test_authenticate_user_raises_error_for_nonexistent_email(user_service):
    """
    Test: authenticate_user() rejects non-existent emails.

    Acceptance criteria: AC5 - Invalid credentials rejected
    """
    # Act & Assert
    with pytest.raises(InvalidCredentialsError):
        user_service.authenticate_user("nobody@example.com", "AnyPass123!")


# === Edge Case Tests ===

def test_register_user_normalizes_email_to_lowercase(user_service):
    """
    Test: register_user() normalizes email case.

    Edge case: Mixed-case email input
    """
    # Arrange
    mixed_case_email = "Alice@Example.COM"

    # Act
    user = user_service.register_user(mixed_case_email, "SecurePass123!")

    # Assert
    assert user.email == "alice@example.com"


def test_authenticate_user_is_case_insensitive_for_email(user_service):
    """
    Test: authenticate_user() handles case-insensitive email lookup.

    Edge case: Login with different case than registration
    """
    # Arrange
    user_service.register_user("alice@example.com", "SecurePass123!")

    # Act
    user = user_service.authenticate_user("ALICE@EXAMPLE.COM", "SecurePass123!")

    # Assert
    assert user.email == "alice@example.com"


def test_register_user_generates_unique_ids_for_multiple_users(user_service):
    """
    Test: register_user() assigns unique IDs to each user.

    Edge case: Multiple registrations get different IDs
    """
    # Arrange & Act
    user1 = user_service.register_user("alice@example.com", "Pass123!")
    user2 = user_service.register_user("bob@example.com", "Pass456!")
    user3 = user_service.register_user("carol@example.com", "Pass789!")

    # Assert
    ids = {user1.id, user2.id, user3.id}
    assert len(ids) == 3  # All unique
```

---

## Anti-Patterns

### Anti-Pattern 1: Testing Implementation Details

❌ **Problem:**
```python
def test_register_user_calls_repository_save_user():
    """Test that register_user calls save_user on repository."""
    mock_repo = Mock()
    service = UserService(mock_repo, mock_hasher, mock_id_gen)

    service.register_user("alice@example.com", "Pass123!")

    mock_repo.save_user.assert_called_once()  # Testing HOW, not WHAT
```

✓ **Fix:**
```python
def test_register_user_persists_user_to_storage(user_service, mock_user_repository):
    """Test that registered user can be retrieved from storage."""
    # Arrange
    email = "alice@example.com"

    # Act
    registered_user = user_service.register_user(email, "Pass123!")

    # Assert: Verify BEHAVIOR (user is retrievable)
    retrieved_user = mock_user_repository.find_by_email(email)
    assert retrieved_user.id == registered_user.id
```

**Why:** Testing implementation details makes tests brittle. They break when you refactor even though behavior unchanged.

---

### Anti-Pattern 2: Vague or Misleading Test Names

❌ **Problem:**
```python
def test_user_service():  # What about user service?
    # ...

def test_case_1():  # What is case 1?
    # ...

def test_register():  # Register what? Success or failure?
    # ...
```

✓ **Fix:**
```python
def test_register_user_creates_user_with_hashed_password():
    # Clear: method, scenario, expected outcome

def test_authenticate_user_raises_error_for_wrong_password():
    # Clear: method, scenario, expected outcome
```

**Why:** Descriptive names:
- Document what's tested without reading code
- Help identify what broke when test fails
- Serve as executable specification

---

### Anti-Pattern 3: Multiple Unrelated Assertions

❌ **Problem:**
```python
def test_user_service_registration_and_authentication():
    """Test user registration and authentication."""
    # Test registration
    user = service.register_user("alice@example.com", "Pass123!")
    assert user.email == "alice@example.com"

    # Test authentication
    auth_user = service.authenticate_user("alice@example.com", "Pass123!")
    assert auth_user.email == "alice@example.com"

    # Test duplicate email rejection
    with pytest.raises(UserAlreadyExistsError):
        service.register_user("alice@example.com", "Pass123!")

    # Testing too many things!
```

✓ **Fix:**
```python
def test_register_user_creates_user_with_valid_inputs():
    """Test registration with valid inputs."""
    user = service.register_user("alice@example.com", "Pass123!")
    assert user.email == "alice@example.com"


def test_authenticate_user_succeeds_with_valid_credentials():
    """Test authentication with valid credentials."""
    service.register_user("alice@example.com", "Pass123!")
    auth_user = service.authenticate_user("alice@example.com", "Pass123!")
    assert auth_user.email == "alice@example.com"


def test_register_user_raises_error_when_email_already_exists():
    """Test duplicate email rejection."""
    service.register_user("alice@example.com", "Pass123!")
    with pytest.raises(UserAlreadyExistsError):
        service.register_user("alice@example.com", "Pass123!")
```

**Why:** One test per behavior:
- Clearer failure messages (know exactly what broke)
- Tests stay focused and readable
- Can run/debug individual behaviors

---

### Anti-Pattern 4: Tests with Side Effects or Order Dependencies

❌ **Problem:**
```python
# Test order dependency - FRAGILE!
user = None  # Module-level shared state

def test_register_creates_user():
    global user
    user = service.register_user("alice@example.com", "Pass123!")
    assert user is not None

def test_authenticate_uses_registered_user():
    # Depends on test_register_creates_user running first!
    global user
    auth_user = service.authenticate_user("alice@example.com", "Pass123!")
    assert auth_user.id == user.id
```

✓ **Fix:**
```python
def test_register_creates_user(user_service):
    """Test registration creates user."""
    user = user_service.register_user("alice@example.com", "Pass123!")
    assert user is not None


def test_authenticate_uses_registered_user(user_service):
    """Test authentication with registered user."""
    # Each test is self-contained
    registered_user = user_service.register_user("alice@example.com", "Pass123!")
    auth_user = user_service.authenticate_user("alice@example.com", "Pass123!")
    assert auth_user.id == registered_user.id
```

**Why:** Isolated tests:
- Can run in any order
- Can run in parallel
- Failures don't cascade

---

### Anti-Pattern 5: Missing Edge Cases

❌ **Problem:**
```python
def test_register_user():
    """Test user registration."""
    user = service.register_user("alice@example.com", "Pass123!")
    assert user.email == "alice@example.com"
    # Only tests happy path, missing:
    # - Email case normalization
    # - Duplicate email rejection
    # - Password strength validation
    # - Invalid email format
```

✓ **Fix:**
```python
def test_register_user_creates_user_with_valid_inputs():
    """Happy path."""
    user = service.register_user("alice@example.com", "Pass123!")
    assert user.email == "alice@example.com"

def test_register_user_normalizes_email_to_lowercase():
    """Edge: case normalization."""
    user = service.register_user("Alice@Example.COM", "Pass123!")
    assert user.email == "alice@example.com"

def test_register_user_raises_error_when_email_already_exists():
    """Error: duplicate email."""
    service.register_user("alice@example.com", "Pass123!")
    with pytest.raises(UserAlreadyExistsError):
        service.register_user("alice@example.com", "Pass123!")

def test_register_user_raises_error_for_weak_password():
    """Error: weak password."""
    with pytest.raises(WeakPasswordError):
        service.register_user("alice@example.com", "weak")
```

**Why:** Complete coverage:
- Verifies all acceptance criteria
- Catches edge case bugs
- Documents all behaviors

---

### Anti-Pattern 6: Slow or Flaky Tests

❌ **Problem:**
```python
def test_register_user():
    # Creates real database connection - SLOW!
    db = PostgreSQLDatabase("localhost:5432")
    repo = PostgreSQLUserRepository(db)
    service = UserService(repo, real_hasher, real_id_gen)

    user = service.register_user("alice@example.com", "Pass123!")
    assert user is not None
    # Slow (network/disk I/O), flaky (database must be running)
```

✓ **Fix:**
```python
def test_register_user(user_service):  # Uses mocked dependencies
    """Test registration with mocked dependencies."""
    user = user_service.register_user("alice@example.com", "Pass123!")
    assert user is not None
    # Fast (<1ms), reliable (no external dependencies)
```

**Why:** Fast, reliable tests:
- Enable rapid TDD feedback loop
- Don't fail due to external factors
- Can run hundreds in seconds

---

### Anti-Pattern 7: Unclear Failure Messages

❌ **Problem:**
```python
def test_password_strength():
    result = validate_password("weak")
    assert result  # Failure message: "AssertionError: assert False"
```

✓ **Fix:**
```python
def test_password_strength_rejects_weak_passwords():
    weak_password = "weak"
    with pytest.raises(WeakPasswordError) as exc_info:
        validate_password(weak_password)

    assert "too short" in str(exc_info.value).lower()
    # Clear failure: "WeakPasswordError: Password too weak: too short (min 8 chars)"
```

**Why:** Clear failures:
- Immediate understanding of what broke
- Faster debugging
- Better CI/CD failure reports

---

## Downstream Usage

### Test Reviewer

**Reviews tests for:**
- All acceptance criteria from spec have tests
- Coverage targets met (>80% line, >70% branch)
- AAA pattern followed
- Tests isolated (no order dependencies)
- Tests verify behavior, not implementation
- Clear test names and assertions
- Edge cases covered

**Review checklist:** See role-test-reviewer.md

---

### Implementer

**Uses tests to:**
1. **RED:** Run tests (all fail with NotImplementedError)
2. **GREEN:** Implement minimal logic to make tests pass
3. **REFACTOR:** Improve code while keeping tests green
4. **Repeat:** Next test

**Workflow:**
- Pick one failing test
- Implement just enough to make it pass
- Verify test turns GREEN
- Refactor if needed (tests stay GREEN)
- Commit
- Next test

---

### CI/CD Pipeline

**Runs tests to:**
- Verify all behaviors still work (regression detection)
- Block merges if tests fail
- Report coverage metrics
- Provide fast feedback on PRs

---

## Summary

Test code provides **executable specifications** that drive implementation and verify behavior:

**Purpose:** Enable TDD, verify acceptance criteria, prevent regressions

**Required elements:**
- AAA pattern (Arrange-Act-Assert)
- Descriptive test names (method_scenario_outcome)
- Isolated tests (mocks for dependencies, no order dependencies)
- Complete coverage (happy paths, errors, edge cases)
- Verify behavior, not implementation details

**Quality gates:**
- All acceptance criteria from spec tested
- >80% line coverage, >70% branch coverage
- Tests isolated and repeatable
- Fast execution (<1s for unit suite)
- Clear failure messages

**Consumed by:**
- Test Reviewer (validates completeness and quality)
- Implementer (drives TDD RED → GREEN → REFACTOR)
- CI/CD (regression detection, merge blocking)

Well-crafted tests enable confident refactoring, document behavior, and drive clean implementation through TDD.
