# IMPLEMENTATION CODE Ontology

## Purpose

Implementation code is **working production code** that fulfills behavioral contracts defined by interface skeletons and verified by tests. Well-crafted implementation:
- Makes all tests pass (achieves GREEN in TDD)
- Follows conventions and patterns from GUIDELINES.md
- Handles errors gracefully
- Remains maintainable and refactorable
- Never modifies tests to make code pass

This schema defines what implementation code should look like across supported languages (Python, TypeScript).

---

## Document Type

**Artifact:** Production implementation code
**Location:** `src/**/*.{py,ts}`
**Format:** Source code with complete working logic
**Created by:** Implementer
**Reviewed by:** Implementation Reviewer
**Consumed by:** Runtime (executes), future maintainers (modify/extend), tests (verify)

---

## Required Structure

### 1. File Header (same as skeleton)

```python
"""
Module: user_service
Purpose: User registration and authentication operations

Created: 2025-10-26
Skeleton by: Claude Sonnet 4.5
Implementation by: Claude Sonnet 4.5
Spec: specs/done/user-authentication.md
"""
```

**Required elements:**
- Module name and purpose (from skeleton)
- Skeleton creator and implementation creator attribution
- Link to spec
- Implementation should preserve all skeleton docstrings

---

### 2. Imports

```python
from abc import abstractmethod
from typing import Protocol, Optional
from dataclasses import dataclass
from datetime import datetime
import re  # Added for implementation: email validation
import uuid  # Added for implementation: ID generation
```

**Import organization:**
1. Standard library (abc, typing, dataclasses, re, uuid)
2. Third-party libraries (if needed)
3. Local project imports (domain types, errors)

**Key difference from skeleton:** May add implementation-specific imports (regex, uuid, etc.)

---

### 3. Implementation Logic

Replace `NotImplementedError` with working code:

**Before (skeleton):**
```python
def register_user(self, email: str, password: str) -> User:
    """
    Register new user account.

    Args:
        email: User's email (normalized to lowercase)
        password: Plain text password (min 8 chars)

    Returns:
        Created User entity

    Raises:
        UserAlreadyExistsError: If email already registered
        WeakPasswordError: If password doesn't meet requirements
    """
    raise NotImplementedError("UserService.register_user not yet implemented")
```

**After (implementation):**
```python
def register_user(self, email: str, password: str) -> User:
    """
    Register new user account.

    Args:
        email: User's email (normalized to lowercase)
        password: Plain text password (min 8 chars)

    Returns:
        Created User entity

    Raises:
        UserAlreadyExistsError: If email already registered
        InvalidEmailError: If email format invalid
        WeakPasswordError: If password doesn't meet requirements
        StorageError: If persistence fails
    """
    # Normalize email to lowercase
    normalized_email = email.lower().strip()

    # Validate email format
    if not self._is_valid_email(normalized_email):
        raise InvalidEmailError(f"Invalid email format: {email}")

    # Check if email already exists
    if self._user_repository.email_exists(normalized_email):
        raise UserAlreadyExistsError(normalized_email)

    # Validate password strength
    self._validate_password_strength(password)

    # Hash password
    password_hash = self._password_hasher.hash_password(password)

    # Create user entity
    user = User(
        id=self._id_generator.generate_id(),
        email=normalized_email,
        password_hash=password_hash,
        created_at=datetime.utcnow(),
        is_active=True,
    )

    # Persist to storage
    self._user_repository.save_user(user)

    return user
```

**Implementation characteristics:**
- Clear step-by-step logic
- Error checking before happy path
- Helper methods for validation (`_is_valid_email`, `_validate_password_strength`)
- Follows docstring contract exactly
- All error cases from docstring implemented

---

### 4. Helper Methods

Extract complex logic into private helper methods:

```python
def _is_valid_email(self, email: str) -> bool:
    """
    Validate email format.

    Args:
        email: Email address to validate

    Returns:
        True if valid format, False otherwise
    """
    # Basic email regex: local@domain
    email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return re.match(email_pattern, email) is not None


def _validate_password_strength(self, password: str) -> None:
    """
    Validate password meets strength requirements.

    Args:
        password: Password to validate

    Raises:
        WeakPasswordError: If password doesn't meet requirements
    """
    if len(password) < 8:
        raise WeakPasswordError("Password must be at least 8 characters")

    if not any(c.isupper() for c in password):
        raise WeakPasswordError("Password must contain uppercase letter")

    if not any(c.islower() for c in password):
        raise WeakPasswordError("Password must contain lowercase letter")

    if not any(c.isdigit() for c in password):
        raise WeakPasswordError("Password must contain digit")

    if not any(c in "!@#$%^&*()_+-=[]{}|;:,.<>?" for c in password):
        raise WeakPasswordError("Password must contain special character")
```

**Helper method guidelines:**
- Private methods (prefix with `_`)
- Single responsibility
- Well-documented
- Testable through public methods
- DRY (Don't Repeat Yourself)

---

### 5. Error Handling

Handle all error cases from spec:

```python
def authenticate_user(self, email: str, password: str) -> User:
    """
    Authenticate user with credentials.

    Args:
        email: User's email (case-insensitive)
        password: Plain text password

    Returns:
        User entity if credentials valid

    Raises:
        InvalidCredentialsError: If email not found or password incorrect
        StorageError: If query fails
    """
    # Normalize email
    normalized_email = email.lower().strip()

    # Find user by email
    user = self._user_repository.find_by_email(normalized_email)

    # User not found - return generic error (security: don't reveal if email exists)
    if user is None:
        raise InvalidCredentialsError("Invalid email or password")

    # Verify password
    password_valid = self._password_hasher.verify_password(password, user.password_hash)

    # Invalid password - return same generic error
    if not password_valid:
        raise InvalidCredentialsError("Invalid email or password")

    # Check if account active
    if not user.is_active:
        raise AccountSuspendedError("Account has been suspended")

    return user
```

**Error handling principles:**
- Check errors before happy path (fail fast)
- Specific error types (UserAlreadyExistsError, WeakPasswordError)
- Helpful error messages
- Security considerations (don't reveal user existence)
- All docstring error cases implemented

---

## Quality Standards

Implementation passes review if:

### 1. Test Compliance
✓ All tests pass (GREEN)
✓ No tests modified to make implementation pass
✓ Meets coverage targets (>80% line, >70% branch)

### 2. Contract Compliance
✓ Implements all methods from skeleton
✓ Matches method signatures exactly
✓ Raises all documented error types
✓ Returns correct types
✓ Preserves skeleton docstrings

### 3. Guidelines Compliance
✓ Follows GUIDELINES.md naming conventions
✓ Follows GUIDELINES.md coding patterns
✓ Follows GUIDELINES.md architectural constraints
✓ Respects GUIDELINES.md error handling patterns

### 4. Code Quality
✓ No long functions (prefer <50 lines)
✓ No deep nesting (prefer <4 levels)
✓ No code duplication (DRY)
✓ Clear variable names (no cryptic abbreviations)
✓ Single responsibility per function/class

### 5. Linting and Type Checking
✓ Passes linter (pylint, eslint)
✓ Passes type checker (mypy --strict, tsc --strict)
✓ No warnings or errors

---

## Complete Example: User Service Implementation

### Python Example

```python
"""
Module: user_service
Purpose: User registration and authentication operations

Created: 2025-10-26
Skeleton by: Claude Sonnet 4.5
Implementation by: Claude Sonnet 4.5
Spec: specs/done/user-authentication.md
"""

from typing import Protocol, Optional
from dataclasses import dataclass
from datetime import datetime
import re


# === Data Structures ===

@dataclass(frozen=True)
class User:
    """
    Immutable user entity.

    Attributes:
        id: Unique identifier (UUID v4)
        email: Normalized email (lowercase)
        password_hash: bcrypt hash
        created_at: Account creation timestamp (UTC)
        is_active: Account status
    """
    id: str
    email: str
    password_hash: str
    created_at: datetime
    is_active: bool = True


# === Custom Exceptions ===

class UserAlreadyExistsError(Exception):
    """Raised when registering duplicate email."""
    def __init__(self, email: str):
        self.email = email
        super().__init__(f"User with email {email} already exists")


class InvalidCredentialsError(Exception):
    """Raised when authentication fails."""
    pass


class WeakPasswordError(Exception):
    """Raised when password doesn't meet strength requirements."""
    def __init__(self, reason: str):
        self.reason = reason
        super().__init__(f"Password too weak: {reason}")


class InvalidEmailError(Exception):
    """Raised when email format is invalid."""
    pass


class AccountSuspendedError(Exception):
    """Raised when account is inactive."""
    pass


# === Abstract Interfaces ===

class UserRepository(Protocol):
    """Abstract interface for user persistence."""

    def save_user(self, user: User) -> None:
        """Persist user to storage."""
        ...

    def find_by_email(self, email: str) -> Optional[User]:
        """Find user by email (case-insensitive)."""
        ...

    def email_exists(self, email: str) -> bool:
        """Check if email exists (case-insensitive)."""
        ...


class PasswordHasher(Protocol):
    """Abstract interface for password hashing."""

    def hash_password(self, password: str) -> str:
        """Hash password using bcrypt."""
        ...

    def verify_password(self, password: str, password_hash: str) -> bool:
        """Verify password against hash."""
        ...


class IdGenerator(Protocol):
    """Abstract interface for ID generation."""

    def generate_id(self) -> str:
        """Generate unique identifier."""
        ...


# === Main Service ===

class UserService:
    """
    Service for user registration and authentication.

    Coordinates user-related business logic, delegating persistence
    to UserRepository and password operations to PasswordHasher.

    Dependencies:
        user_repository: User persistence backend
        password_hasher: Password hashing implementation
        id_generator: Unique ID generation
    """

    def __init__(
        self,
        user_repository: UserRepository,
        password_hasher: PasswordHasher,
        id_generator: IdGenerator,
    ):
        """
        Initialize with injected dependencies.

        Args:
            user_repository: User persistence backend
            password_hasher: Password hashing implementation
            id_generator: Unique ID generator
        """
        self._user_repository = user_repository
        self._password_hasher = password_hasher
        self._id_generator = id_generator

    def register_user(self, email: str, password: str) -> User:
        """
        Register new user account.

        Validates email uniqueness, checks password strength, hashes
        password, creates user entity, and persists to storage.

        Args:
            email: User's email (normalized to lowercase)
            password: Plain text password (min 8 chars, requires uppercase,
                     lowercase, digit, special character)

        Returns:
            Created User entity

        Raises:
            UserAlreadyExistsError: If email already registered
            InvalidEmailError: If email format invalid
            WeakPasswordError: If password doesn't meet requirements
            StorageError: If persistence fails

        Example:
            >>> user = service.register_user("alice@example.com", "SecurePass123!")
            >>> assert user.email == "alice@example.com"
            >>> assert user.is_active == True
        """
        # Normalize email to lowercase
        normalized_email = email.lower().strip()

        # Validate email format
        if not self._is_valid_email(normalized_email):
            raise InvalidEmailError(f"Invalid email format: {email}")

        # Check if email already exists
        if self._user_repository.email_exists(normalized_email):
            raise UserAlreadyExistsError(normalized_email)

        # Validate password strength
        self._validate_password_strength(password)

        # Hash password
        password_hash = self._password_hasher.hash_password(password)

        # Create user entity
        user = User(
            id=self._id_generator.generate_id(),
            email=normalized_email,
            password_hash=password_hash,
            created_at=datetime.utcnow(),
            is_active=True,
        )

        # Persist to storage
        self._user_repository.save_user(user)

        return user

    def authenticate_user(self, email: str, password: str) -> User:
        """
        Authenticate user with credentials.

        Looks up user by email, verifies password hash, checks account
        status, and returns user entity if valid.

        Args:
            email: User's email (case-insensitive)
            password: Plain text password

        Returns:
            User entity if credentials valid

        Raises:
            InvalidCredentialsError: If email not found or password incorrect
            AccountSuspendedError: If account inactive
            StorageError: If query fails

        Example:
            >>> user = service.authenticate_user("alice@example.com", "SecurePass123!")
            >>> assert user.email == "alice@example.com"
        """
        # Normalize email
        normalized_email = email.lower().strip()

        # Find user by email
        user = self._user_repository.find_by_email(normalized_email)

        # User not found - generic error (security: don't reveal email existence)
        if user is None:
            raise InvalidCredentialsError("Invalid email or password")

        # Verify password
        password_valid = self._password_hasher.verify_password(password, user.password_hash)

        # Invalid password - same generic error
        if not password_valid:
            raise InvalidCredentialsError("Invalid email or password")

        # Check if account active
        if not user.is_active:
            raise AccountSuspendedError("Account has been suspended")

        return user

    # === Helper Methods ===

    def _is_valid_email(self, email: str) -> bool:
        """
        Validate email format.

        Args:
            email: Email address to validate

        Returns:
            True if valid format, False otherwise
        """
        # Basic email regex: local@domain.tld
        email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return re.match(email_pattern, email) is not None

    def _validate_password_strength(self, password: str) -> None:
        """
        Validate password meets strength requirements.

        Args:
            password: Password to validate

        Raises:
            WeakPasswordError: If password doesn't meet requirements
        """
        if len(password) < 8:
            raise WeakPasswordError("Password must be at least 8 characters")

        if not any(c.isupper() for c in password):
            raise WeakPasswordError("Password must contain uppercase letter")

        if not any(c.islower() for c in password):
            raise WeakPasswordError("Password must contain lowercase letter")

        if not any(c.isdigit() for c in password):
            raise WeakPasswordError("Password must contain digit")

        if not any(c in "!@#$%^&*()_+-=[]{}|;:,.<>?" for c in password):
            raise WeakPasswordError("Password must contain special character")
```

**What makes this implementation good:**
- All tests pass (GREEN)
- Follows skeleton contracts exactly
- Clear, step-by-step logic with comments
- Error checking before happy path (fail fast)
- Helper methods for complex logic
- Security conscious (generic error messages)
- DRY (no duplication)
- Proper type hints maintained

---

## Anti-Patterns

### Anti-Pattern 1: Modifying Tests to Make Code Pass

❌ **Problem:**
```python
# Implementation doesn't normalize email
def register_user(self, email: str, password: str) -> User:
    user = User(id=gen_id(), email=email, ...)  # Doesn't lowercase!
    self._repo.save_user(user)
    return user

# Then modify test to match broken implementation:
def test_register_user_normalizes_email_to_lowercase(user_service):
    user = user_service.register_user("Alice@Example.COM", "Pass123!")
    assert user.email == "Alice@Example.COM"  # Changed expectation!
```

✓ **Fix:**
```python
# Fix implementation to match test expectation
def register_user(self, email: str, password: str) -> User:
    normalized_email = email.lower().strip()  # Normalize as tests expect
    user = User(id=gen_id(), email=normalized_email, ...)
    self._repo.save_user(user)
    return user

# Keep test unchanged
def test_register_user_normalizes_email_to_lowercase(user_service):
    user = user_service.register_user("Alice@Example.COM", "Pass123!")
    assert user.email == "alice@example.com"  # Correct expectation
```

**Why:** Tests define contracts. Implementation must conform, not vice versa.

---

### Anti-Pattern 2: Code Duplication

❌ **Problem:**
```python
def register_user(self, email: str, password: str) -> User:
    # Validate email format - duplicated logic
    email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    if not re.match(email_pattern, email):
        raise InvalidEmailError(f"Invalid: {email}")

    # ... registration logic

def update_email(self, user_id: str, new_email: str) -> User:
    # Same validation duplicated!
    email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    if not re.match(email_pattern, new_email):
        raise InvalidEmailError(f"Invalid: {new_email}")

    # ... update logic
```

✓ **Fix:**
```python
def _is_valid_email(self, email: str) -> bool:
    """Validate email format (DRY)."""
    email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return re.match(email_pattern, email) is not None

def register_user(self, email: str, password: str) -> User:
    if not self._is_valid_email(email):
        raise InvalidEmailError(f"Invalid: {email}")
    # ... registration logic

def update_email(self, user_id: str, new_email: str) -> User:
    if not self._is_valid_email(new_email):
        raise InvalidEmailError(f"Invalid: {new_email}")
    # ... update logic
```

**Why:** DRY (Don't Repeat Yourself):
- Single source of truth
- Easier to maintain (change once)
- Less likely to have bugs from inconsistencies

---

### Anti-Pattern 3: Long Functions

❌ **Problem:**
```python
def register_user(self, email: str, password: str) -> User:
    # 100+ lines of validation, normalization, hashing, persistence...
    normalized_email = email.lower().strip()
    email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    if not re.match(email_pattern, normalized_email):
        raise InvalidEmailError(f"Invalid: {email}")
    if self._repo.email_exists(normalized_email):
        raise UserAlreadyExistsError(normalized_email)
    if len(password) < 8:
        raise WeakPasswordError("Too short")
    if not any(c.isupper() for c in password):
        raise WeakPasswordError("Need uppercase")
    # ... 80 more lines
```

✓ **Fix:**
```python
def register_user(self, email: str, password: str) -> User:
    normalized_email = email.lower().strip()
    self._validate_email(normalized_email)
    self._check_email_uniqueness(normalized_email)
    self._validate_password_strength(password)
    password_hash = self._password_hasher.hash_password(password)
    user = self._create_user(normalized_email, password_hash)
    self._user_repository.save_user(user)
    return user

def _validate_email(self, email: str) -> None:
    """Validate email format."""
    if not self._is_valid_email(email):
        raise InvalidEmailError(f"Invalid: {email}")

def _check_email_uniqueness(self, email: str) -> None:
    """Check email doesn't already exist."""
    if self._user_repository.email_exists(email):
        raise UserAlreadyExistsError(email)

# ... other helper methods
```

**Why:** Short functions:
- Easier to understand
- Easier to test
- Easier to refactor
- Self-documenting through method names

---

### Anti-Pattern 4: Poor Error Messages

❌ **Problem:**
```python
def register_user(self, email: str, password: str) -> User:
    if len(password) < 8:
        raise WeakPasswordError("Invalid")  # Unhelpful!

    if not any(c.isupper() for c in password):
        raise WeakPasswordError("Invalid")  # Same message for different error!
```

✓ **Fix:**
```python
def register_user(self, email: str, password: str) -> User:
    if len(password) < 8:
        raise WeakPasswordError("Password must be at least 8 characters")

    if not any(c.isupper() for c in password):
        raise WeakPasswordError("Password must contain uppercase letter")
```

**Why:** Clear error messages:
- Help users understand what's wrong
- Make debugging easier
- Improve user experience

---

### Anti-Pattern 5: Premature Optimization

❌ **Problem:**
```python
def register_user(self, email: str, password: str) -> User:
    # Premature optimization: caching before profiling
    cache_key = f"email_exists:{email}"
    if cache_key in self._cache:
        exists = self._cache[cache_key]
    else:
        exists = self._repo.email_exists(email)
        self._cache[cache_key] = exists

    if exists:
        raise UserAlreadyExistsError(email)

    # ... rest of registration
    # Added complexity without measuring if it's needed!
```

✓ **Fix:**
```python
def register_user(self, email: str, password: str) -> User:
    # Simple, clear implementation first (GREEN)
    if self._repo.email_exists(email):
        raise UserAlreadyExistsError(email)

    # ... rest of registration
    # Optimize later if profiling shows this is a bottleneck
```

**Why:** Follow TDD:
- RED: Tests fail
- GREEN: Make tests pass (simplest way)
- REFACTOR: Improve code while keeping tests green
- Optimize only after measuring (not guessing)

---

### Anti-Pattern 6: Ignoring GUIDELINES.md

❌ **Problem:**
```python
# GUIDELINES.md says: "Validate empty/null before other checks"
def register_user(self, email: str, password: str) -> User:
    # But implementation checks format first:
    if not self._is_valid_email(email):  # Crashes if email is None!
        raise InvalidEmailError(f"Invalid: {email}")

    if email is None or email.strip() == "":  # Should be first!
        raise ValueError("Email required")
```

✓ **Fix:**
```python
# Follow GUIDELINES.md pattern
def register_user(self, email: str, password: str) -> User:
    # Check empty/null first (as per GUIDELINES.md)
    if email is None or email.strip() == "":
        raise ValueError("Email required")

    if password is None or password.strip() == "":
        raise ValueError("Password required")

    # Then other validations
    if not self._is_valid_email(email):
        raise InvalidEmailError(f"Invalid: {email}")
```

**Why:** GUIDELINES.md ensures:
- Consistency across codebase
- Patterns are proven to work
- Easier for other developers to understand

---

### Anti-Pattern 7: Tight Coupling to Concrete Dependencies

❌ **Problem:**
```python
class UserService:
    def __init__(self):
        # Hardcoded concrete dependencies!
        self._repo = PostgreSQLUserRepository("localhost:5432")
        self._hasher = BcryptPasswordHasher()
        self._id_gen = UUIDGenerator()
```

✓ **Fix:**
```python
class UserService:
    def __init__(
        self,
        user_repository: UserRepository,  # Abstract Protocol
        password_hasher: PasswordHasher,  # Abstract Protocol
        id_generator: IdGenerator,        # Abstract Protocol
    ):
        self._user_repository = user_repository
        self._password_hasher = password_hasher
        self._id_generator = id_generator
```

**Why:** Dependency injection:
- Follows skeleton's design
- Enables testing with mocks
- Allows swapping implementations
- Reduces coupling

---

## Downstream Usage

### Implementation Reviewer

**Reviews implementation for:**
- All tests pass (GREEN)
- No tests modified
- Follows skeleton contracts
- Follows GUIDELINES.md patterns
- Code quality (no long functions, duplication, deep nesting)
- Proper error handling
- Clear variable names
- Passes linters and type checkers

**Review checklist:** See role-implementation-reviewer.md

---

### Future Maintainers

**Use implementation to:**
- Understand how feature works
- Modify behavior (with tests protecting against regressions)
- Extend functionality
- Fix bugs (add sentinel tests, then fix)
- Refactor (improve code while keeping tests green)

---

### Runtime

**Executes implementation** to provide application functionality

---

## TDD Workflow Integration

### RED → GREEN → REFACTOR

**RED (tests fail):**
```python
def register_user(self, email: str, password: str) -> User:
    raise NotImplementedError("not yet implemented")  # All tests fail
```

**GREEN (make tests pass):**
```python
def register_user(self, email: str, password: str) -> User:
    # Minimal implementation to make tests pass
    normalized_email = email.lower().strip()

    if self._user_repository.email_exists(normalized_email):
        raise UserAlreadyExistsError(normalized_email)

    # Quick password check (just length for now)
    if len(password) < 8:
        raise WeakPasswordError("Too short")

    password_hash = self._password_hasher.hash_password(password)
    user = User(
        id=self._id_generator.generate_id(),
        email=normalized_email,
        password_hash=password_hash,
        created_at=datetime.utcnow(),
        is_active=True,
    )
    self._user_repository.save_user(user)
    return user
```

**REFACTOR (improve while keeping GREEN):**
```python
def register_user(self, email: str, password: str) -> User:
    # Refactored: extracted validation helpers
    normalized_email = email.lower().strip()

    self._validate_email(normalized_email)
    self._check_email_uniqueness(normalized_email)
    self._validate_password_strength(password)  # Now comprehensive

    password_hash = self._password_hasher.hash_password(password)
    user = self._create_user(normalized_email, password_hash)
    self._user_repository.save_user(user)

    return user

# Extracted helper methods
def _validate_email(self, email: str) -> None:
    if not self._is_valid_email(email):
        raise InvalidEmailError(f"Invalid: {email}")

def _check_email_uniqueness(self, email: str) -> None:
    if self._user_repository.email_exists(email):
        raise UserAlreadyExistsError(email)

def _validate_password_strength(self, password: str) -> None:
    # Comprehensive validation (all checks)
    if len(password) < 8:
        raise WeakPasswordError("Password must be at least 8 characters")
    if not any(c.isupper() for c in password):
        raise WeakPasswordError("Password must contain uppercase letter")
    if not any(c.islower() for c in password):
        raise WeakPasswordError("Password must contain lowercase letter")
    if not any(c.isdigit() for c in password):
        raise WeakPasswordError("Password must contain digit")
    if not any(c in "!@#$%^&*" for c in password):
        raise WeakPasswordError("Password must contain special character")

def _create_user(self, email: str, password_hash: str) -> User:
    return User(
        id=self._id_generator.generate_id(),
        email=email,
        password_hash=password_hash,
        created_at=datetime.utcnow(),
        is_active=True,
    )
```

**Tests remain GREEN throughout refactoring!**

---

## Summary

Implementation code is **working production code** that fulfills contracts and passes tests:

**Purpose:** Make tests pass (GREEN), follow conventions, remain maintainable

**Required elements:**
- All tests pass
- Follows skeleton contracts exactly
- Follows GUIDELINES.md patterns
- Clear, maintainable code (DRY, short functions, clear names)
- Proper error handling
- Never modifies tests

**Quality gates:**
- All tests pass (GREEN)
- Passes linters and type checkers
- Follows GUIDELINES.md conventions
- No code smells (duplication, long functions, deep nesting)
- Proper error messages

**Consumed by:**
- Implementation Reviewer (validates quality and compliance)
- Future maintainers (modify and extend)
- Runtime (executes functionality)
- Tests (verify correctness)

**TDD cycle:**
1. RED: Tests fail (NotImplementedError)
2. GREEN: Make tests pass (minimal implementation)
3. REFACTOR: Improve code (tests stay green)

Well-crafted implementation makes tests pass, follows established patterns, and remains maintainable for future changes.
