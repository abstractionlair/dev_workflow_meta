---
name: skeleton-reviewer
description: Review interface skeletons for testability, completeness, and correctness before test writing. Validates skeletons enable TDD and match specification contracts. Use after skeleton-writer creates code structure, before test-writer begins.
---

# Skeleton Reviewer

Review interface skeletons to ensure they're testable, complete, and ready for TDD.

## When to Use

**Use when:**
- skeleton-writer created code skeletons
- Before test-writer creates tests
- Before TDD red-green-refactor cycle begins

**Prerequisites:**
- Approved SPEC.md exists
- Skeleton code files created

**Produces:** Review decision (APPROVED / NEEDS-CHANGES) with specific feedback

## Review Principles

### 1. Contract Compliance
- Signatures match spec exactly
- All types present
- All exceptions defined

### 2. Testability
- Dependencies injectable
- Interfaces abstract
- No hard-coded dependencies

### 3. Completeness
- All methods have docstrings
- All types defined
- All exceptions created

### 4. Hollowness
- No business logic
- Only structure and types
- Raises NotImplementedError

### 5. SOLID Principles
- Single responsibility
- Interface segregation
- Dependency inversion

## Review Workflow

### Step 1: Load References
- Read SPEC.md (what skeleton should match)
- Locate skeleton files (usually in src/)

### Step 2: Check Against Spec Interface Contract

**For each function/class in spec:**
- [ ] Skeleton file exists
- [ ] Signature matches spec exactly
- [ ] All parameters present with correct types
- [ ] Return type matches spec
- [ ] All exceptions from spec are defined

**Example verification:**

**SPEC.md says:**
```markdown
### Function: detect_links(project_path: str) -> LinkMap

**Raises:**
- InvalidPathError: If path doesn't exist
- PermissionError: If unreadable
```

**Skeleton should have:**
```python
def detect_links(project_path: str) -> LinkMap:
    """
    Scan project and detect links.
    
    Raises:
        InvalidPathError: If path doesn't exist
        PermissionError: If unreadable
    """
    raise NotImplementedError("Implement in TDD green phase")
```

**Check:**
- ✅ Function name matches: `detect_links`
- ✅ Parameter matches: `project_path: str`
- ✅ Return type matches: `LinkMap`
- ✅ Exceptions documented
- ✅ Raises NotImplementedError
- ✅ No implementation logic

### Step 3: Check Data Types

**For each data structure in spec:**
- [ ] Type defined in skeleton
- [ ] Structure matches spec
- [ ] Invariants documented (in docstring or post_init)

**Example verification:**

**SPEC.md says:**
```markdown
### User: Dataclass
- email (str): User email
- id (Optional[int]): User ID (None before save)

Invariants:
- email is non-empty
- id is None before save, positive after
```

**Skeleton should have:**
```python
@dataclass
class User:
    """
    User account data.
    
    Invariants:
        - email is non-empty
        - id is None before save, positive after
    """
    email: str
    id: Optional[int] = None
    
    def __post_init__(self):
        if not self.email:
            raise ValueError("Email cannot be empty")
```

**Check:**
- ✅ Dataclass decorator
- ✅ Fields match spec
- ✅ Types correct
- ✅ Invariants documented
- ✅ Validation in __post_init__

### Step 4: Check Exception Types

**For each exception in spec:**
- [ ] Exception class defined
- [ ] Inherits from appropriate base
- [ ] Constructor parameters make sense
- [ ] Error message format clear

**Example verification:**

**SPEC.md mentions:**
```
Raises: DuplicateEmailError if email exists
```

**Skeleton should have:**
```python
class DuplicateEmailError(Exception):
    """Email already exists."""
    def __init__(self, email: str):
        self.email = email
        super().__init__(f"Email already registered: {email}")
```

**Check:**
- ✅ Exception class exists
- ✅ Descriptive docstring
- ✅ Constructor takes email
- ✅ Formatted error message

### Step 5: Check Dependency Injection

**For each class, verify:**
- [ ] Dependencies passed to __init__
- [ ] No hard-coded dependencies
- [ ] Dependencies are interfaces not concrete

**Common issues:**

```python
❌ Bad: Hard-coded dependency
class UserService:
    def __init__(self):
        self.db = PostgresDatabase()  # Can't test!

✅ Good: Injected interface
class UserService:
    def __init__(self, repo: UserRepository):  # Interface
        self.repo = repo
```

**Check constructor:**
- ✅ All dependencies from spec are parameters
- ✅ Parameters are abstract types (interfaces)
- ✅ No concrete implementations instantiated
- ✅ No database connections
- ✅ No file I/O
- ✅ No external API calls

### Step 6: Check Interface Abstractions

**For dependencies, verify:**
- [ ] Abstract base classes exist
- [ ] Use ABC and @abstractmethod
- [ ] Interface segregation (focused interfaces)
- [ ] Methods match what main class needs

**Example verification:**

**Main class uses:**
```python
class UserService:
    def __init__(self, repo: UserRepository):
        self.repo = repo
    
    def register(self, email: str) -> User:
        # Will call: repo.save(), repo.get_by_email()
        raise NotImplementedError()
```

**Interface should exist:**
```python
class UserRepository(ABC):
    @abstractmethod
    def save(self, user: User) -> User:
        pass
    
    @abstractmethod
    def get_by_email(self, email: str) -> Optional[User]:
        pass
```

**Check:**
- ✅ ABC inheritance
- ✅ @abstractmethod decorators
- ✅ Methods main class will call
- ✅ No extra methods (interface segregation)

### Step 7: Check Docstrings

**For each public method, verify:**
- [ ] Purpose stated (one line)
- [ ] Args documented with types
- [ ] Returns documented with type
- [ ] Raises documented with conditions
- [ ] Preconditions stated (if from spec)
- [ ] Postconditions stated (if from spec)

**Minimum docstring:**
```python
def method(param: Type) -> ReturnType:
    """
    [Purpose in one sentence.]
    
    Args:
        param: [Description]
        
    Returns:
        [What gets returned]
        
    Raises:
        ExceptionType: [When raised]
    """
    raise NotImplementedError()
```

### Step 8: Check No Implementation

**Critical: Verify skeleton is hollow:**
- [ ] Every method raises NotImplementedError
- [ ] No business logic
- [ ] No database queries
- [ ] No file I/O
- [ ] No calculations
- [ ] No if/else logic
- [ ] Only structure and types

**Red flags:**
```python
❌ Has logic:
def register(self, email: str) -> User:
    if "@" not in email:  # ❌ Validation logic
        raise ValidationError("Invalid email")
    user = User(email=email)
    return self.repo.save(user)  # ❌ Implementation

✅ Hollow:
def register(self, email: str) -> User:
    """Register user. Raises: ValidationError, DuplicateEmailError"""
    raise NotImplementedError("Implement in TDD green phase")
```

### Step 9: Check Type Completeness

**Verify no missing types:**
- [ ] No `Any` types (should be specific)
- [ ] No missing type hints
- [ ] No missing return types
- [ ] Import statements for all types
- [ ] Generic types parameterized (List[int] not List)

**Example:**
```python
❌ Missing types:
def process(data):  # No param type
    pass  # No return type

✅ Complete types:
def process(data: List[int]) -> ProcessingResult:
    raise NotImplementedError()
```

### Step 10: Check Module Organization

**Verify file structure:**
- [ ] Logical grouping (exceptions, types, interfaces, main)
- [ ] Module docstring present
- [ ] Import order: stdlib, third-party, local
- [ ] No circular imports

**Module docstring example:**
```python
"""
User management module.

Classes:
    UserService: Main service for user operations
    UserRepository: Abstract interface for user storage
    User: User data model

Exceptions:
    DuplicateEmailError: Email already exists
    ValidationError: Invalid user input
"""
```

## Review Output Format

```markdown
# Skeleton Review: [Feature Name]

**Reviewer:** [Your name/Claude]
**Date:** [YYYY-MM-DD]
**Spec:** [spec filename]
**Skeleton Files:** [list of files reviewed]
**Status:** APPROVED | NEEDS-CHANGES

## Summary
[Overall assessment - testability, completeness, correctness]

## Contract Compliance
- ✅/❌ All functions from spec present
- ✅/❌ Signatures match spec exactly
- ✅/❌ All data types defined
- ✅/❌ All exceptions defined

## Testability Assessment
- ✅/❌ Dependencies injectable
- ✅/❌ Interfaces abstract (ABC + @abstractmethod)
- ✅/❌ No hard-coded dependencies
- ✅/❌ SOLID principles applied

## Completeness
- ✅/❌ All methods have docstrings
- ✅/❌ All types have hints
- ✅/❌ All exceptions created
- ✅/❌ Module docstrings present

## Hollowness Verification
- ✅/❌ No business logic
- ✅/❌ All methods raise NotImplementedError
- ✅/❌ No database/file/network operations

## Critical Issues (if NEEDS-CHANGES)
1. **[Issue Title]**
   - File: [filename:line]
   - Problem: [What's wrong]
   - Impact: [Why this blocks testing]
   - Fix: [How to resolve]

## Minor Issues
[Non-blocking improvements]

## Testability Score
[How easy will it be to write tests?]
- Dependency injection: ✅/❌
- Interface abstractions: ✅/❌
- Type completeness: ✅/❌

## Decision
[APPROVED - ready for test-writer]
[NEEDS-CHANGES - address critical issues]
```

## Common Issues

### Issue 1: Hard-Coded Dependencies
```
Problem: self.db = PostgresDB() in __init__
Impact: Can't inject test doubles
Fix: Add repo: UserRepository parameter, inject dependency
```

### Issue 2: Missing Type Hints
```
Problem: def process(data) with no types
Impact: Unclear interface, can't validate tests
Fix: def process(data: List[int]) -> ProcessingResult
```

### Issue 3: Implementation Logic Present
```
Problem: Method has if/else business logic
Impact: Not a skeleton, will confuse TDD
Fix: Remove logic, raise NotImplementedError
```

### Issue 4: Concrete Dependencies
```
Problem: Depends on PostgresRepository (concrete class)
Impact: Can't substitute test doubles
Fix: Create UserRepository interface, depend on that
```

### Issue 5: Missing Exceptions
```
Problem: Spec says "Raises ValidationError" but exception not defined
Impact: Can't write tests for error cases
Fix: Create ValidationError exception class
```

### Issue 6: Incomplete Docstrings
```
Problem: Missing Args, Returns, or Raises in docstring
Impact: Unclear contract for test writers
Fix: Add complete docstring with all sections
```

## Best Practices

**DO:**
- Check against spec meticulously
- Verify dependency injection
- Ensure complete type hints
- Confirm hollowness (no logic)
- Validate interfaces are abstract

**DON'T:**
- Allow hard-coded dependencies
- Accept missing types
- Permit implementation logic
- Skip SOLID principle check
- Overlook missing exceptions

## Integration

**Consumes:**
- SPEC.md (contract reference)
- Skeleton code files (to review)

**Produces:**
- Review document with decision
- Specific feedback

**Workflow Position:**
```
spec-writer → SPEC.md ✓
  ↓
spec-reviewer → Review SPEC ✓
  ↓
skeleton-writer → Code skeletons
  ↓
skeleton-reviewer → Review skeletons ⬅ YOU ARE HERE
  ↓ (if APPROVED)
test-writer → Tests (TDD RED)
  ↓
implementer → Implementation (TDD GREEN)
```

## Critical Reminders

- Skeleton must match spec exactly (contract compliance)
- Dependencies must be injectable (testability)
- No business logic allowed (hollowness)
- All types must be complete (no Any, no missing hints)
- Interfaces must be abstract (ABC + @abstractmethod)

**Most critical:** If skeleton isn't testable, TDD won't work. Verify dependency injection obsessively!

## Related Skills

- **skeleton-writer**: Produces skeletons to review
- **spec-reviewer**: Validates spec before skeleton creation
- **test-writer**: Consumes approved skeletons
- **interface-design-tdd**: Reference for SOLID principles
