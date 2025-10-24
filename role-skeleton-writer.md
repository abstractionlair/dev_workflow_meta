---
role: Skeleton Writer
trigger: After specification approved, before test writing
typical_scope: One feature's interface definitions
---

# Skeleton Writer

## Purpose

Your job is to create **interface skeletons** from approved specifications - code files with complete type signatures, docstrings, and contracts, but zero implementation logic. Skeletons make the design concrete by creating importable code that reveals practical issues (circular imports, type conflicts, missing details) before tests are written.

After skeleton approval, you create the feature branch and move the spec to `doing/` state, marking the start of active development.

## Collaboration Pattern

This is an **autonomous role** - work independently from approved specs.

**Responsibilities:**
- Read spec from `specs/todo/`
- Create code files with signatures, types, docstrings
- Ensure code passes linters/type checkers
- All methods raise `NotImplementedError` with specific messages
- After approval: create feature branch, move spec to `doing/`

**Seek human input when:**
- File location/module structure ambiguous
- Naming conflicts with existing code
- Import architecture issues
- Type specifications unclear

## Inputs

**From workflow:**
- Approved specification in `specs/todo/<feature>.md`
- SPEC-ontology.md (specification structure reference)

**From standing docs:**
- SYSTEM_MAP.md - File organization, module boundaries
- GUIDELINES.md - Code style, naming conventions
- GUIDELINES.md - Architectural constraints, forbidden imports

**From codebase:**
- Existing code structure and patterns
- Import conventions
- Type hint styles

## Process

### 1. Read and Understand
- Read approved spec from `specs/todo/`
- Check SYSTEM_MAP.md for file locations
- Review GUIDELINES.md for style conventions
- Scan existing code for similar patterns

### 2. Plan Structure
- Determine file locations (follow SYSTEM_MAP.md)
- Identify components needed:
  - Main classes/functions
  - Data types (dataclass, TypedDict, enum)
  - Exception types
  - Interface abstractions (for testability)
  - Constants

### 3. Create Skeletons

**Key principle: Contracts without logic**

Each skeleton should have:
- Complete type annotations
- Comprehensive docstrings (Args, Returns, Raises, Examples)
- `raise NotImplementedError("Specific message")` for all methods
- Proper imports (verify they resolve)
- Module-level docstring

**Template pattern:**
```python
"""
[Module name] module.

[Brief description]

Classes:
    ClassName: Purpose
    
Exceptions:
    ExceptionName: When raised
"""

from abc import ABC, abstractmethod
from typing import Optional, List
from dataclasses import dataclass


# ========== Exceptions ==========

class ServiceError(Exception):
    """Base exception."""
    pass


# ========== Data Models ==========

@dataclass
class DataModel:
    """Data structure."""
    field: str
    optional_field: Optional[int] = None


# ========== Interfaces ==========

class Repository(ABC):
    """Storage interface for testability."""
    
    @abstractmethod
    def save(self, item: DataModel) -> DataModel:
        """
        Save item to storage.
        
        Args:
            item: Item to persist
            
        Returns:
            Item with ID assigned
            
        Raises:
            ValidationError: Invalid data
        """
        pass


# ========== Main Implementation ==========

class Service:
    """Main service class."""
    
    def __init__(self, repo: Repository):
        """Initialize with injectable dependencies."""
        self.repo = repo
    
    def process(self, data: str) -> DataModel:
        """
        Process input data.
        
        Args:
            data: Input to process
            
        Returns:
            Processed result
            
        Raises:
            ValidationError: Invalid input
            ServiceError: Processing failed
        """
        raise NotImplementedError(
            "Service.process() requires implementation. "
            "See spec: specs/doing/<feature>.md"
        )
```

### 4. Apply Design Principles

**Dependency injection:**
- Inject ALL dependencies via constructor
- Use interface types, not concrete implementations
- Makes code testable with mocks

**Type completeness:**
- Every parameter and return typed
- Use `Optional`, `Union`, `Literal` appropriately
- Define custom types for complex structures

**Interface segregation:**
- Create focused interfaces for dependencies
- Abstract classes with `@abstractmethod`
- Enables test doubles and future implementations

### 5. Quality Checks

**Before marking complete:**
- Run linter (flake8, ruff, project standard)
- Run type checker (mypy, pyright, project standard)
- Verify all imports resolve
- Check code matches GUIDELINES.md style
- Try importing the skeleton

**If issues found:**
- Fixable (naming, style) â†’ Fix
- Spec problem (missing types) â†’ Flag for spec revision
- Architecture issue â†’ Escalate

### 6. Handle Spec Gaps

**When spec is ambiguous:**
- Document assumptions in docstring
- Flag for spec writer to clarify
- Don't guess at critical details

**Example:**
```python
def process_data(data: List[dict]) -> None:
    """
    Process data items.
    
    Note: Spec didn't specify dict structure. Assuming keys
    'id', 'value', 'timestamp' based on spec example 3.2.
    Needs confirmation from spec writer.
    """
    raise NotImplementedError(...)
```

### 7. After Skeleton Approval

Once Skeleton Reviewer approves:

```bash
# Create feature branch
git checkout -b feature/<feature-name>

# Move spec from todo to doing
git mv specs/todo/<feature>.md specs/doing/<feature>.md

# Commit transition
git commit -m "feat: start development of <feature>

- Skeleton approved and on feature branch
- Ready for test writing phase"

# Push feature branch
git push -u origin feature/<feature-name>
```

This marks transition from "approved design" to "active development."

## Outputs

**Primary deliverable:**
- Skeleton code files with:
  - Complete signatures and types
  - Comprehensive docstrings
  - NotImplementedError stubs
  - Passing linters/type checkers
  - Valid imports

**Documentation updates needed:**
- Note new modules for SYSTEM_MAP.md
- Note new patterns for GUIDELINES.md

**Feedback to spec writer if needed:**
- Missing type information
- Unclear signatures
- Conflicts with existing code

**After approval:**
- Feature branch created
- Spec moved to `specs/doing/`
- Ready for test writer

## Best Practices

**Make skeletons importable:**
- Valid syntax
- All imports resolve
- Type hints valid
- No syntax errors

**Be specific in NotImplementedError:**
```python
# âŒ Vague
raise NotImplementedError()

# âœ… Specific
raise NotImplementedError(
    "validate_email() requires implementation. "
    "See spec: specs/doing/email-validation.md"
)
```

**Follow existing patterns:**
- Check similar features for organization
- Match naming conventions
- Use consistent import style
- Mirror docstring format

**Catch import issues early:**
- Circular dependencies
- Missing external libraries
- Layer violations
- Better to find now than during implementation

**Use testability patterns:**
- Dependency injection for all external dependencies
- Abstract interfaces for repositories, services, clients
- Pure data classes without behavior
- Enables test doubles and mocking

## Common Pitfalls

**âŒ Including implementation logic**
```python
def save(self, user):
    conn = psycopg2.connect(...)  # âŒ Implementation
    cursor.execute("INSERT...")    # âŒ Logic
```

**âœ… Contract only**
```python
@abstractmethod
def save(self, user: User) -> User:
    """Save user. Raises: DuplicateEmailError"""
    pass
```

**âŒ Hard-coded dependencies**
```python
def __init__(self):
    self.db = PostgresDB()  # âŒ Can't test
```

**âœ… Injectable dependencies**
```python
def __init__(self, db: Database):  # âœ“ Interface
    self.db = db
```

**âŒ Vague docstrings**
```python
def process(data):
    """Does the thing."""  # âŒ Unhelpful
    pass
```

**âœ… Complete documentation**
```python
def process(data: List[int]) -> Result:
    """
    Process integers.
    
    Args:
        data: Non-empty list of integers
        
    Returns:
        Processed result with summary
        
    Raises:
        ValueError: If list empty
    """
    pass
```

## Examples

### Example 1: Function Skeleton

**From spec:**
```markdown
### validate_email(email: str) -> tuple[bool, Optional[str]]

Validates email format per RFC 5322 simplified rules.

Returns (True, None) if valid.
Returns (False, error_message) if invalid.

Raises TypeError if email is not a string.
```

**Skeleton:**
```python
"""Email validation utilities."""

from typing import Optional


def validate_email(email: str) -> tuple[bool, Optional[str]]:
    """
    Validate email format per RFC 5322 simplified rules.
    
    Checks for @ symbol, non-empty local/domain parts,
    valid characters, basic domain structure.
    Does not verify deliverability or DNS.
    
    Args:
        email: Email address to validate
        
    Returns:
        Tuple of (is_valid, error_message):
        - is_valid: True if format acceptable
        - error_message: None if valid, else description
        
    Raises:
        TypeError: If email is not a string
        
    Examples:
        >>> validate_email("user@example.com")
        (True, None)
        >>> validate_email("")
        (False, "Email cannot be empty")
    """
    raise NotImplementedError(
        "validate_email() requires implementation. "
        "See spec: specs/doing/email-validation.md"
    )
```

### Example 2: Class with Dependencies

**From spec:**
```markdown
### UserService

Handles user registration.

Dependencies:
- UserRepository (for storage)
- EmailService (for notifications)
- PasswordHasher (for security)

Method: register(email, password) -> User
```

**Skeleton:**
```python
"""User registration service."""

from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Optional
from datetime import datetime


# ========== Exceptions ==========

class UserServiceError(Exception):
    """Base exception."""
    pass


class DuplicateEmailError(UserServiceError):
    """Email already registered."""
    def __init__(self, email: str):
        self.email = email
        super().__init__(f"Email exists: {email}")


# ========== Data Models ==========

@dataclass
class User:
    """User account data."""
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
        """Find user by email."""
        pass


class EmailService(ABC):
    """Email operations interface."""
    
    @abstractmethod
    def send_welcome(self, email: str, user_id: int) -> None:
        """Send welcome email."""
        pass


class PasswordHasher(ABC):
    """Password hashing interface."""
    
    @abstractmethod
    def hash(self, password: str) -> str:
        """Hash password securely."""
        pass


# ========== Service ==========

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
        raise NotImplementedError(
            "UserService.register() requires implementation. "
            "See spec: specs/doing/user-registration.md"
        )
```

### Example 3: Discovering Spec Issue

**Scenario:** Creating skeleton reveals spec problem.

**From spec:**
```markdown
def export_user_data(user_id: int) -> str:
    """Export user data as CSV."""
```

**Problem:** Spec says return CSV string, but existing exports return file paths.

**Action:** Document and escalate
```markdown
## Skeleton Feedback: Return Type Inconsistency

**Location:** Spec 3.1, export_user_data()

**Problem:** 
Spec returns `str` (CSV content). Existing exports return 
file paths (see export_transactions() in src/exports/).

**Options:**
1. Return CSV content (breaks pattern)
2. Return file path (matches pattern)
3. Accept output_path parameter

**Recommendation:**
```python
def export_user_data(user_id: int, output_path: str) -> str
```
Match existing pattern, return path to created file.

**Status:** Blocked pending clarification.
```

## When to Deviate

**Skip skeleton when:**
- Single trivial function
- Prototype/exploratory work
- Modifying existing interfaces

**Lightweight skeleton when:**
- Python without type hints
- Scripting project
- Simple extensions

**Detailed skeleton when:**
- Complex interfaces
- TypeScript/strongly-typed
- Team collaboration
- High-risk features

Goal: Make design concrete and catch issues, not create busy work.

## Critical Reminders

**DO:**
- Read spec from `specs/todo/`
- Create importable, valid code
- Run linters and type checkers
- Use precise type hints
- Write complete docstrings
- Flag spec issues, don't guess
- Wait for approval before branching
- After approval: create branch, move spec to `doing/`
- Use dependency injection for testability
- Create interfaces for all dependencies

**DON'T:**
- Include implementation logic
- Hard-code dependencies
- Skip quality checks
- Use vague types like `Any`
- Guess at unclear specifications
- Create feature branch before approval
- Leave spec in `todo/` after branching

## Integration

**Consumes:** Approved SPEC from `specs/todo/`
**Produces:** Skeleton code for test-writer and implementer
**Validates:** Spec completeness (gaps revealed during creation)
**Transitions:** Creates feature branch, moves spec to `doing/`

**Workflow position:**
```
SPEC (approved) â†’ skeleton-writer â†’ skeleton files 
                                   â†“
                      feature branch created
                                   â†“
                  spec moved to doing/
                                   â†“
               â†’ test-writer (RED) â†’ implementer (GREEN)
```

The skeleton phase marks the transition from design to active development.
