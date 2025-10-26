# INTERFACE SKELETON CODE Ontology

## Purpose

Interface skeleton code defines **complete contracts** with **zero implementation logic**. Skeletons enable Test-Driven Development by establishing type signatures, docstrings, and dependency injection patterns before tests are written.

A well-crafted skeleton:
- Makes testing possible by defining testable interfaces
- Documents all behaviors through comprehensive docstrings
- Enables dependency injection through constructor parameters
- Passes type checkers and linters
- Contains no implementation logic (only NotImplementedError stubs)

This schema defines what skeleton code should look like across supported languages (Python, TypeScript).

---

## Document Type

**Artifact:** Interface skeleton code files
**Location:** `src/**/*.{py,ts}`
**Format:** Source code with complete type annotations and stub implementations
**Created by:** Skeleton Writer
**Reviewed by:** Skeleton Reviewer
**Consumed by:** Test Writer (to understand contracts), Implementer (to fill in logic)

---

## Required Structure

### 1. File Header

Every skeleton file must start with:

```python
"""
Module: user_service
Purpose: User registration and authentication operations

Created: 2025-10-26
Skeleton by: Claude Sonnet 4.5
Spec: specs/done/user-authentication.md
"""
```

**Required elements:**
- Module name
- Purpose (one-line summary)
- Creation date
- Creator attribution
- Link to spec that defines this component

---

### 2. Imports

```python
from abc import ABC, abstractmethod
from typing import Optional, Protocol
from dataclasses import dataclass
from datetime import datetime
```

**Import organization:**
1. Standard library imports (abc, typing, dataclasses)
2. Third-party imports (if needed for type hints)
3. Local project imports (domain types, errors)

**Key principle:** Import only what's needed for **type signatures**, not for implementation.

---

### 3. Data Structures

Define all data structures used in interfaces:

```python
@dataclass(frozen=True)
class User:
    """
    Immutable user entity.

    Attributes:
        id: Unique user identifier (UUID format)
        email: User's email address (normalized lowercase)
        password_hash: bcrypt hash of user's password
        created_at: UTC timestamp of account creation
        is_active: Whether account is active (False = suspended)
    """
    id: str
    email: str
    password_hash: str
    created_at: datetime
    is_active: bool = True
```

**Requirements:**
- Use `@dataclass(frozen=True)` for immutability (Python)
- Complete type annotations on all fields
- Docstring explaining purpose and field semantics
- Document constraints (e.g., "normalized lowercase", "UUID format")
- Specify default values if applicable

---

### 4. Custom Exceptions

```python
class UserAlreadyExistsError(Exception):
    """
    Raised when attempting to register email that already exists.

    Attributes:
        email: The duplicate email address
    """
    def __init__(self, email: str):
        self.email = email
        super().__init__(f"User with email {email} already exists")


class InvalidCredentialsError(Exception):
    """Raised when login credentials are invalid."""
    pass
```

**Requirements:**
- Custom exceptions for domain-specific errors
- Docstring explaining when raised
- Attributes to carry error context
- Helpful error messages

---

### 5. Abstract Interfaces (Dependencies)

```python
class UserRepository(Protocol):
    """
    Abstract interface for user persistence operations.

    This interface allows dependency injection of different storage
    backends (PostgreSQL, in-memory, etc.) without changing business logic.
    """

    def save_user(self, user: User) -> None:
        """
        Persist user to storage.

        Args:
            user: User entity to save

        Raises:
            StorageError: If persistence operation fails
        """
        ...

    def find_by_email(self, email: str) -> Optional[User]:
        """
        Find user by email address.

        Args:
            email: Email to search for (case-insensitive)

        Returns:
            User if found, None otherwise

        Raises:
            StorageError: If query operation fails
        """
        ...

    def email_exists(self, email: str) -> bool:
        """
        Check if email already exists in storage.

        Args:
            email: Email to check (case-insensitive)

        Returns:
            True if email exists, False otherwise

        Raises:
            StorageError: If query operation fails
        """
        ...
```

**Requirements:**
- Use `Protocol` (Python) or `interface` (TypeScript) for dependencies
- Comprehensive docstrings for every method
- Document all parameters, return values, and exceptions
- Use `...` for method bodies (Python Protocol)
- Enable dependency injection through abstract interfaces

**Why Protocols?**
- Testability: Test Writer can create mock implementations
- Flexibility: Multiple storage backends without changing business logic
- Clear contracts: Explicit dependencies visible in constructor

---

### 6. Main Service Class

```python
class UserService:
    """
    Service for user registration and authentication operations.

    This service coordinates user-related business logic, delegating
    persistence to UserRepository and password hashing to PasswordHasher.

    Dependencies:
        user_repository: Storage backend for user persistence
        password_hasher: Password hashing implementation
    """

    def __init__(
        self,
        user_repository: UserRepository,
        password_hasher: PasswordHasher,
    ):
        """
        Initialize UserService with injected dependencies.

        Args:
            user_repository: Storage backend for users
            password_hasher: Password hashing implementation
        """
        self._user_repository = user_repository
        self._password_hasher = password_hasher

    def register_user(self, email: str, password: str) -> User:
        """
        Register a new user account.

        Validates email uniqueness, hashes password, creates user entity,
        and persists to storage.

        Args:
            email: User's email address (will be normalized to lowercase)
            password: Plain text password (will be hashed before storage)

        Returns:
            Created User entity with generated ID and timestamp

        Raises:
            UserAlreadyExistsError: If email already registered
            InvalidEmailError: If email format invalid
            WeakPasswordError: If password doesn't meet strength requirements
            StorageError: If persistence fails

        Example:
            >>> service.register_user("alice@example.com", "SecurePass123!")
            User(id='uuid-here', email='alice@example.com', ...)
        """
        raise NotImplementedError("UserService.register_user not yet implemented")

    def authenticate_user(self, email: str, password: str) -> User:
        """
        Authenticate user with email and password.

        Looks up user by email, verifies password hash, and returns user
        entity if credentials valid.

        Args:
            email: User's email address (case-insensitive)
            password: Plain text password to verify

        Returns:
            User entity if credentials valid

        Raises:
            InvalidCredentialsError: If email not found or password incorrect
            AccountSuspendedError: If user account is inactive
            StorageError: If query fails

        Example:
            >>> user = service.authenticate_user("alice@example.com", "SecurePass123!")
            >>> assert user.email == "alice@example.com"
        """
        raise NotImplementedError("UserService.authenticate_user not yet implemented")
```

**Requirements:**
- Class docstring explaining purpose and dependencies
- Constructor that accepts all dependencies
- Store dependencies as private attributes (`_user_repository`)
- Method docstrings with Args, Returns, Raises, Example sections
- `raise NotImplementedError("ClassName.method_name not yet implemented")` for all methods
- Document all error cases that spec defines
- Include usage examples in docstrings

---

### 7. Additional Dependencies

```python
class PasswordHasher(Protocol):
    """
    Abstract interface for password hashing operations.
    """

    def hash_password(self, password: str) -> str:
        """
        Hash password using secure algorithm.

        Args:
            password: Plain text password

        Returns:
            Hashed password (bcrypt format)

        Raises:
            ValueError: If password empty or too long
        """
        ...

    def verify_password(self, password: str, password_hash: str) -> bool:
        """
        Verify password against hash.

        Args:
            password: Plain text password to verify
            password_hash: bcrypt hash to verify against

        Returns:
            True if password matches, False otherwise
        """
        ...
```

---

## Quality Standards

A skeleton passes review if:

### 1. Type Completeness
✓ Every function parameter has type annotation
✓ Every function has return type annotation
✓ Every class attribute has type annotation
✓ Passes type checker (mypy --strict, tsc --strict)

### 2. Documentation Completeness
✓ Every module has purpose docstring
✓ Every class has purpose and dependencies docstring
✓ Every method has Args, Returns, Raises docstring
✓ Examples provided for complex methods
✓ All error cases documented

### 3. Testability
✓ All dependencies injected via constructor
✓ Dependencies are abstract interfaces (Protocol/interface)
✓ No hardcoded values (database URLs, file paths, etc.)
✓ No global state or singletons
✓ Pure functions where possible (no side effects)

### 4. Zero Implementation
✓ All methods raise NotImplementedError
✓ No business logic in method bodies
✓ No conditional statements, loops, or calculations
✓ Only imports needed for type signatures (not implementation)

### 5. Linting
✓ Passes linter (pylint, eslint)
✓ No unused imports
✓ Consistent naming conventions
✓ No magic numbers or hardcoded strings in docstrings

---

## Language-Specific Guidelines

### Python

**Type hints:**
```python
from typing import Optional, List, Dict, Protocol
```

**Abstract interfaces:**
```python
class Repository(Protocol):
    def save(self, entity: Entity) -> None: ...
```

**Immutable data:**
```python
from dataclasses import dataclass

@dataclass(frozen=True)
class Entity:
    id: str
    name: str
```

**Stubs:**
```python
def method(self) -> ReturnType:
    raise NotImplementedError("ClassName.method not yet implemented")
```

---

### TypeScript

**Type annotations:**
```typescript
function register(email: string, password: string): Promise<User>
```

**Abstract interfaces:**
```typescript
interface UserRepository {
  saveUser(user: User): Promise<void>;
  findByEmail(email: string): Promise<User | null>;
}
```

**Immutable data:**
```typescript
interface User {
  readonly id: string;
  readonly email: string;
  readonly createdAt: Date;
}
```

**Stubs:**
```typescript
async function register(email: string, password: string): Promise<User> {
  throw new Error("UserService.register not yet implemented");
}
```

---

## Complete Example: User Authentication Skeleton

### Python Example

```python
"""
Module: user_service
Purpose: User registration and authentication operations

Created: 2025-10-26
Skeleton by: Claude Sonnet 4.5
Spec: specs/done/user-authentication.md
"""

from abc import abstractmethod
from typing import Protocol, Optional
from dataclasses import dataclass
from datetime import datetime


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


# === Abstract Interfaces ===

class UserRepository(Protocol):
    """Abstract interface for user persistence."""

    def save_user(self, user: User) -> None:
        """
        Persist user to storage.

        Args:
            user: User entity to save

        Raises:
            StorageError: If persistence fails
        """
        ...

    def find_by_email(self, email: str) -> Optional[User]:
        """
        Find user by email (case-insensitive).

        Args:
            email: Email to search

        Returns:
            User if found, None otherwise
        """
        ...

    def email_exists(self, email: str) -> bool:
        """
        Check if email exists (case-insensitive).

        Args:
            email: Email to check

        Returns:
            True if exists, False otherwise
        """
        ...


class PasswordHasher(Protocol):
    """Abstract interface for password hashing."""

    def hash_password(self, password: str) -> str:
        """
        Hash password using bcrypt.

        Args:
            password: Plain text password

        Returns:
            bcrypt hash

        Raises:
            ValueError: If password empty
        """
        ...

    def verify_password(self, password: str, password_hash: str) -> bool:
        """
        Verify password against hash.

        Args:
            password: Plain text password
            password_hash: bcrypt hash

        Returns:
            True if matches, False otherwise
        """
        ...


class IdGenerator(Protocol):
    """Abstract interface for ID generation."""

    def generate_id(self) -> str:
        """
        Generate unique identifier.

        Returns:
            UUID v4 string
        """
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
            WeakPasswordError: If password doesn't meet requirements
            StorageError: If persistence fails

        Example:
            >>> user = service.register_user("alice@example.com", "SecurePass123!")
            >>> assert user.email == "alice@example.com"
            >>> assert user.is_active == True
        """
        raise NotImplementedError("UserService.register_user not yet implemented")

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
            StorageError: If query fails

        Example:
            >>> user = service.authenticate_user("alice@example.com", "SecurePass123!")
            >>> assert user.email == "alice@example.com"
        """
        raise NotImplementedError("UserService.authenticate_user not yet implemented")
```

**What makes this skeleton good:**
- Complete type annotations on all parameters and returns
- Comprehensive docstrings with Args/Returns/Raises/Examples
- All dependencies injected via constructor (UserRepository, PasswordHasher, IdGenerator)
- Dependencies are abstract Protocols (testable with mocks)
- Zero implementation logic (only NotImplementedError)
- Passes mypy --strict
- Clear error cases documented

---

### TypeScript Example

```typescript
/**
 * Module: UserService
 * Purpose: User registration and authentication operations
 *
 * Created: 2025-10-26
 * Skeleton by: Claude Sonnet 4.5
 * Spec: specs/done/user-authentication.md
 */

// === Data Structures ===

interface User {
  readonly id: string;
  readonly email: string;
  readonly passwordHash: string;
  readonly createdAt: Date;
  readonly isActive: boolean;
}

// === Custom Errors ===

class UserAlreadyExistsError extends Error {
  constructor(public readonly email: string) {
    super(`User with email ${email} already exists`);
    this.name = "UserAlreadyExistsError";
  }
}

class InvalidCredentialsError extends Error {
  constructor() {
    super("Invalid email or password");
    this.name = "InvalidCredentialsError";
  }
}

class WeakPasswordError extends Error {
  constructor(public readonly reason: string) {
    super(`Password too weak: ${reason}`);
    this.name = "WeakPasswordError";
  }
}

// === Abstract Interfaces ===

interface UserRepository {
  /**
   * Persist user to storage.
   * @param user - User entity to save
   * @throws StorageError if persistence fails
   */
  saveUser(user: User): Promise<void>;

  /**
   * Find user by email (case-insensitive).
   * @param email - Email to search
   * @returns User if found, null otherwise
   */
  findByEmail(email: string): Promise<User | null>;

  /**
   * Check if email exists (case-insensitive).
   * @param email - Email to check
   * @returns true if exists, false otherwise
   */
  emailExists(email: string): Promise<boolean>;
}

interface PasswordHasher {
  /**
   * Hash password using bcrypt.
   * @param password - Plain text password
   * @returns bcrypt hash
   * @throws Error if password empty
   */
  hashPassword(password: string): Promise<string>;

  /**
   * Verify password against hash.
   * @param password - Plain text password
   * @param passwordHash - bcrypt hash
   * @returns true if matches, false otherwise
   */
  verifyPassword(password: string, passwordHash: string): Promise<boolean>;
}

interface IdGenerator {
  /**
   * Generate unique identifier.
   * @returns UUID v4 string
   */
  generateId(): string;
}

// === Main Service ===

/**
 * Service for user registration and authentication.
 *
 * Coordinates user-related business logic, delegating persistence
 * to UserRepository and password operations to PasswordHasher.
 */
class UserService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly passwordHasher: PasswordHasher,
    private readonly idGenerator: IdGenerator
  ) {}

  /**
   * Register new user account.
   *
   * Validates email uniqueness, checks password strength, hashes password,
   * creates user entity, and persists to storage.
   *
   * @param email - User's email (normalized to lowercase)
   * @param password - Plain text password (min 8 chars, requires uppercase,
   *                   lowercase, digit, special character)
   * @returns Created User entity
   * @throws UserAlreadyExistsError if email already registered
   * @throws WeakPasswordError if password doesn't meet requirements
   * @throws StorageError if persistence fails
   *
   * @example
   * const user = await service.registerUser("alice@example.com", "SecurePass123!");
   * console.log(user.email); // "alice@example.com"
   */
  async registerUser(email: string, password: string): Promise<User> {
    throw new Error("UserService.registerUser not yet implemented");
  }

  /**
   * Authenticate user with credentials.
   *
   * Looks up user by email, verifies password hash, checks account status,
   * and returns user entity if valid.
   *
   * @param email - User's email (case-insensitive)
   * @param password - Plain text password
   * @returns User entity if credentials valid
   * @throws InvalidCredentialsError if email not found or password incorrect
   * @throws StorageError if query fails
   *
   * @example
   * const user = await service.authenticateUser("alice@example.com", "SecurePass123!");
   * console.log(user.email); // "alice@example.com"
   */
  async authenticateUser(email: string, password: string): Promise<User> {
    throw new Error("UserService.authenticateUser not yet implemented");
  }
}

export { UserService, User, UserRepository, PasswordHasher, IdGenerator };
export { UserAlreadyExistsError, InvalidCredentialsError, WeakPasswordError };
```

---

## Anti-Patterns

### Anti-Pattern 1: Missing Type Annotations

❌ **Problem:**
```python
def register_user(email, password):  # Missing types
    raise NotImplementedError()
```

✓ **Fix:**
```python
def register_user(self, email: str, password: str) -> User:
    raise NotImplementedError("UserService.register_user not yet implemented")
```

**Why:** Type annotations enable:
- Type checking to catch errors before tests run
- IDE autocomplete for Test Writer and Implementer
- Clear contracts without reading implementation

---

### Anti-Pattern 2: Hardcoded Dependencies

❌ **Problem:**
```python
class UserService:
    def __init__(self):
        self._db = PostgreSQLDatabase("localhost:5432")  # Hardcoded!
```

✓ **Fix:**
```python
class UserService:
    def __init__(self, user_repository: UserRepository):
        self._user_repository = user_repository  # Injected abstract interface
```

**Why:** Hardcoded dependencies prevent:
- Testing with mock implementations
- Switching storage backends
- Running tests without database

---

### Anti-Pattern 3: Incomplete Docstrings

❌ **Problem:**
```python
def register_user(self, email: str, password: str) -> User:
    """Register a user."""  # Too vague, missing error cases
    raise NotImplementedError()
```

✓ **Fix:**
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

    Example:
        >>> user = service.register_user("alice@example.com", "SecurePass123!")
    """
    raise NotImplementedError("UserService.register_user not yet implemented")
```

**Why:** Complete docstrings enable:
- Test Writer to understand all error cases to test
- Implementer to know exactly what to build
- API consumers to use the service correctly

---

### Anti-Pattern 4: Leaking Implementation Details

❌ **Problem:**
```python
def register_user(self, email: str, password: str) -> User:
    """
    Register user. First check database, then hash with bcrypt rounds=12,
    then insert into users table with SQL INSERT statement.
    """
    raise NotImplementedError()
```

✓ **Fix:**
```python
def register_user(self, email: str, password: str) -> User:
    """
    Register new user account.

    Validates email uniqueness, hashes password, and persists user.
    """
    raise NotImplementedError("UserService.register_user not yet implemented")
```

**Why:** Skeleton defines **what**, not **how**. Implementation details:
- Constrain implementer unnecessarily
- Make refactoring harder
- Distract from behavioral contract

---

### Anti-Pattern 5: Implementation Logic in Skeleton

❌ **Problem:**
```python
def register_user(self, email: str, password: str) -> User:
    # Normalize email
    email = email.lower().strip()

    # Validate email format
    if "@" not in email:
        raise InvalidEmailError("Email must contain @")

    raise NotImplementedError()  # This is too much implementation!
```

✓ **Fix:**
```python
def register_user(self, email: str, password: str) -> User:
    """
    Register new user account.

    Args:
        email: User's email (normalized to lowercase)
        password: Plain text password

    Returns:
        Created User entity

    Raises:
        UserAlreadyExistsError: If email already registered
        InvalidEmailError: If email format invalid
        WeakPasswordError: If password doesn't meet requirements
    """
    raise NotImplementedError("UserService.register_user not yet implemented")
```

**Why:** Skeleton should have **zero logic**:
- Test Writer needs clean slate to write tests against contract
- Logic in skeleton tempts implementer to keep it (skipping TDD)
- Violates single responsibility (skeleton = contract, not implementation)

---

### Anti-Pattern 6: Concrete Dependencies Instead of Abstract

❌ **Problem:**
```python
class UserRepository(Protocol):
    def save_user(self, user: User) -> None: ...

class PostgreSQLUserRepository:  # Concrete implementation
    def save_user(self, user: User) -> None:
        # ... PostgreSQL-specific code

class UserService:
    def __init__(self, user_repository: PostgreSQLUserRepository):  # Depends on concrete!
        self._user_repository = user_repository
```

✓ **Fix:**
```python
class UserRepository(Protocol):
    def save_user(self, user: User) -> None: ...

class UserService:
    def __init__(self, user_repository: UserRepository):  # Depends on abstract Protocol
        self._user_repository = user_repository
```

**Why:** Depending on abstractions:
- Enables testing with mock implementations
- Allows multiple storage backends
- Follows Dependency Inversion Principle

---

### Anti-Pattern 7: Missing Examples in Complex Methods

❌ **Problem:**
```python
def authenticate_user(self, email: str, password: str) -> User:
    """
    Authenticate user with credentials.

    Args:
        email: Email
        password: Password

    Returns:
        User
    """
    raise NotImplementedError()
```

✓ **Fix:**
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

    Example:
        >>> user = service.authenticate_user("alice@example.com", "SecurePass123!")
        >>> assert user.email == "alice@example.com"
    """
    raise NotImplementedError("UserService.authenticate_user not yet implemented")
```

**Why:** Examples:
- Clarify expected behavior for Test Writer
- Serve as usage documentation
- Reduce ambiguity in contracts

---

## Downstream Usage

### Test Writer

**Reads skeleton to:**
- Understand method contracts (inputs, outputs, errors)
- Identify all error cases to test
- Create mock implementations of abstract dependencies
- Write tests that match docstring examples

**Example:**
```python
# Test Writer sees PasswordHasher Protocol in skeleton
class MockPasswordHasher:  # Create test double
    def hash_password(self, password: str) -> str:
        return f"hashed_{password}"

    def verify_password(self, password: str, password_hash: str) -> bool:
        return password_hash == f"hashed_{password}"

# Use mock in tests
def test_register_user_hashes_password():
    mock_hasher = MockPasswordHasher()
    service = UserService(mock_repo, mock_hasher, mock_id_gen)

    user = service.register_user("alice@example.com", "SecurePass123!")

    assert user.password_hash == "hashed_SecurePass123!"
```

---

### Implementer

**Reads skeleton to:**
- Understand what to implement (method contracts)
- See which dependencies are available
- Know which errors to raise in which conditions
- Replace NotImplementedError with working logic

**Workflow:**
1. Run tests (they fail because NotImplementedError)
2. Pick one test to make pass
3. Replace NotImplementedError with minimal logic
4. Run tests (should turn GREEN)
5. Refactor if needed
6. Repeat for next test

---

### Skeleton Reviewer

**Checks skeleton for:**
- Type completeness (all annotations present, passes type checker)
- Documentation completeness (Args/Returns/Raises/Examples)
- Dependency injection (all dependencies via constructor)
- Abstract dependencies (Protocol, not concrete types)
- Zero implementation logic (only NotImplementedError)
- Alignment with spec (all acceptance criteria covered)

**Review checklist:** See role-skeleton-reviewer.md

---

## Summary

Interface skeleton code establishes **complete contracts with zero implementation**:

**Purpose:** Enable TDD by defining testable interfaces before tests written

**Required elements:**
- Complete type annotations (passes type checker)
- Comprehensive docstrings (Args/Returns/Raises/Examples)
- Dependency injection via constructor
- Abstract interfaces for all dependencies
- NotImplementedError stubs for all methods
- No implementation logic

**Quality gates:**
- Passes type checker (mypy --strict, tsc --strict)
- Passes linter
- All dependencies injected and abstract
- All error cases documented
- Examples provided for complex methods

**Consumed by:**
- Test Writer (to understand contracts and write tests)
- Implementer (to fill in logic following TDD)
- Skeleton Reviewer (to verify completeness and testability)

A well-crafted skeleton makes testing possible, documents all behaviors, and enables clean TDD workflow.
