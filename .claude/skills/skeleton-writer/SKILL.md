---
name: skeleton-writer
description: Create interface skeletons with complete type definitions and contracts from specifications. Produces testable code structures with dependency injection, abstract interfaces, and comprehensive docstrings but zero implementation logic. Enables TDD red-green-refactor cycle.
---

# Skeleton Writer

Create interface skeletons from specifications - code structures with complete contracts but no business logic. Skeletons define **structure and types** that tests verify and implementation fulfills.

## When to Use

**Use when:**
- SPEC file complete and reviewed
- Ready to begin TDD cycle
- Need code structure before writing tests

**Prerequisites:**
- Feature specification exists
- Spec reviewed and approved
- Project structure exists (src/, tests/)

**Produces:** Code files with interfaces, types, doc strings, `raise NotImplementedError`

## Skeleton Principles

### 1. Contracts Without Logic

❌ Bad (includes logic):
```python
def save(self, user):
    conn = psycopg2.connect(...)  # ❌ Implementation
    cursor.execute("INSERT...")  # ❌ Logic
```

✅ Good (contract only):
```python
@abstractmethod
def save(self, user: User) -> User:
    """
    Save user to storage.
    Raises: DuplicateEmailError if email exists
    """
    pass  # ✓ No implementation
```

### 2. Enable Dependency Injection

❌ Bad (hard-coded):
```python
def __init__(self):
    self.db = PostgresDB()  # ❌ Can't test
```

✅ Good (injectable):
```python
def __init__(self, db: Database):  # ✓ Interface
    self.db = db
```

### 3. Complete Type Information

❌ Bad (no types):
```python
def process(data):  # ❌ What is data?
    pass
```

✅ Good (typed):
```python
def process(data: List[int]) -> Result:
    """
    Process integers.
    Args: data - Non-empty list
    Raises: ValueError if empty
    """
    pass
```

### 4. Reveal Spec Gaps

**Skeleton creation catches missing details:**

Spec: "Store user data"  
Skeleton: `def register(...) -> ???`  
**Gap revealed:** Return type undefined → Fix spec

## Skeleton Workflow

### 1. Read Specification

Extract:
- Interface contracts → Method signatures
- Data structures → Type definitions  
- Dependencies → Constructor parameters
- Acceptance criteria → Pre/postconditions

### 2. Identify Components

From spec, create:
- Main classes/modules
- Interface abstractions (for testability)
- Data types (dataclass, TypedDict, enum)
- Exception types
- Constants

**Example:**
```
Spec: UserService.register(email, password) -> User
Components needed:
- UserService (main class)
- UserRepository (interface)
- User (dataclass)
- DuplicateEmailError (exception)
```

### 3. Apply SOLID Principles

**Single Responsibility:**
```python
# ✅ Good: Separate concerns
class UserService:
    def __init__(
        self,
        validator: Validator,
        hasher: PasswordHasher,
        repo: UserRepository,
        email: EmailService
    ):
        # Each dependency has one job
        # Service coordinates
```

**Interface Segregation:**
```python
# ✅ Good: Focused interfaces
class UserRepository(ABC):
    @abstractmethod
    def save(self, user: User) -> User: pass
    
    @abstractmethod
    def get_by_id(self, id: int) -> Optional[User]: pass
```

**Dependency Inversion:**
```python
# ✅ Good: Depend on abstractions
class UserService:
    def __init__(self, repo: UserRepository):  # Interface not concrete
        self.repo = repo
```

### 4. Create Interfaces

```python
from abc import ABC, abstractmethod

class UserRepository(ABC):
    """Abstract interface for user storage."""
    
    @abstractmethod
    def save(self, user: User) -> User:
        """
        Persist user.
        
        Args:
            user: User to save (must have email)
            
        Returns:
            User with ID assigned
            
        Raises:
            DuplicateEmailError: Email exists
            ValidationError: Invalid email format
            
        Postconditions:
            - Returned user has id != None
            - User retrievable via get_by_id
        """
        pass
```

### 5. Define Data Types

**Dataclass:**
```python
from dataclasses import dataclass
from typing import Optional
from datetime import datetime

@dataclass
class User:
    """
    User account data.
    
    Invariants:
        - email non-empty and valid
        - id is None before save, positive after
    """
    email: str
    password_hash: str
    id: Optional[int] = None
    created_at: Optional[datetime] = None
```

**TypedDict:**
```python
from typing import TypedDict, List

class LinkEntry(TypedDict):
    """Links for a spec."""
    code: List[str]  # May be empty
    tests: List[str]  # May be empty
```

**Enum:**
```python
from enum import Enum

class Status(Enum):
    ACTIVE = "active"
    SUSPENDED = "suspended"
```

### 6. Define Exceptions

```python
class UserServiceError(Exception):
    """Base exception."""
    pass

class DuplicateEmailError(UserServiceError):
    """Email already exists."""
    def __init__(self, email: str):
        self.email = email
        super().__init__(f"Email exists: {email}")
```

### 7. Create Main Class

```python
class UserService:
    """User registration service."""
    
    def __init__(
        self,
        repo: UserRepository,
        email_svc: EmailService,
        hasher: PasswordHasher
    ):
        """Initialize with dependencies."""
        self.repo = repo
        self.email_svc = email_svc
        self.hasher = hasher
    
    def register(self, email: str, password: str) -> User:
        """
        Register new user.
        
        Args:
            email: Valid email format
            password: Meets strength requirements
            
        Returns:
            Registered user with ID
            
        Raises:
            DuplicateEmailError: Email exists
            ValidationError: Invalid input
            
        Postconditions:
            - User saved to repository
            - Welcome email sent
            - User has id and created_at
        """
        raise NotImplementedError("Implement in TDD green phase")
```

## Complete Skeleton Example

```python
"""
User registration module.

Classes:
    UserService: Registration service
    UserRepository: Storage interface
    User: User data model

Exceptions:
    DuplicateEmailError
    ValidationError
"""

from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Optional
from datetime import datetime


# ========== Exceptions ==========

class UserServiceError(Exception):
    """Base exception."""
    pass

class DuplicateEmailError(UserServiceError):
    """Email exists."""
    def __init__(self, email: str):
        self.email = email
        super().__init__(f"Email exists: {email}")


# ========== Data Models ==========

@dataclass
class User:
    """User account."""
    email: str
    password_hash: str
    id: Optional[int] = None
    created_at: Optional[datetime] = None


# ========== Interfaces ==========

class UserRepository(ABC):
    """User storage interface."""
    
    @abstractmethod
    def save(self, user: User) -> User:
        """Save user. Raises: DuplicateEmailError"""
        pass
    
    @abstractmethod
    def get_by_email(self, email: str) -> Optional[User]:
        """Find by email."""
        pass


class EmailService(ABC):
    """Email operations."""
    
    @abstractmethod
    def send_welcome(self, email: str, user_id: int) -> None:
        """Send welcome email."""
        pass


# ========== Main Service ==========

class UserService:
    """User registration service."""
    
    def __init__(
        self,
        repo: UserRepository,
        email_svc: EmailService,
        hasher: PasswordHasher
    ):
        self.repo = repo
        self.email_svc = email_svc
        self.hasher = hasher
    
    def register(self, email: str, password: str) -> User:
        """
        Register user.
        Raises: DuplicateEmailError, ValidationError
        """
        raise NotImplementedError("Implement after writing tests")
```

## Language Patterns

**Python:**
- `from abc import ABC, abstractmethod`
- `from typing import List, Optional, Dict`
- `from dataclasses import dataclass`
- `raise NotImplementedError("message")`

**TypeScript:**
- `interface UserRepository { ... }`
- `type User = { email: string; ... }`
- `throw new Error("Not implemented")`

## Best Practices

**DO:**
- Create interfaces for all dependencies
- Use complete type hints
- Write thorough docstrings (Args, Returns, Raises)
- Include preconditions/postconditions
- Raise NotImplementedError (not `pass`)
- Apply SOLID principles
- Keep hollow (no logic)

**DON'T:**
- Include business logic
- Hard-code dependencies
- Skip types or docstrings
- Mention specific tech (PostgreSQL, Redis) in interfaces
- Write implementations (that's TDD green)

**Module docstring template:**
```python
"""
[Module name] module.

[Brief description of what module provides]

Classes:
    [ClassName]: [Purpose]

Exceptions:
    [ExceptionName]: [When raised]

Example:
    >>> [Usage example]
"""
```

## Integration

**Consumes:** SPEC file (interface contracts, data structures, acceptance criteria)
**Produces:** Code skeletons for test-writer and implementer
**Validates:** Spec completeness (gaps revealed during skeleton creation)

**Workflow:**
```
SPEC → skeleton-writer → skeleton files → test-writer (RED) → implementer (GREEN)
```

## Critical Reminders

- Skeletons are contracts, not implementations
- Testability is primary goal
- If skeleton hard to test → refactor before tests
- Skeleton quality determines test quality
- Good skeletons make TDD straightforward
- Use `raise NotImplementedError`, not `pass`
- Every public method needs complete docstring
- Inject ALL dependencies via constructor

## Related Skills

- **spec-writer**: Provides SPEC files consumed by this skill
- **interface-design-tdd**: Detailed SOLID principles and patterns
- **tdd**: Implements skeletons in red-green-refactor cycle
- **test-review**: Validates skeleton testability
