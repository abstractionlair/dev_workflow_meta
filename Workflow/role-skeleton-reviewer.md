---
role: Skeleton Reviewer
trigger: After skeleton created, before test writing
typical_scope: One feature's skeleton code
dependencies: [SPEC from specs/todo/, skeleton code files, SYSTEM_MAP.md, GUIDELINES.md, schema-interface-skeleton-code.md]
outputs: [reviews/skeletons/TIMESTAMP-FEATURE-STATUS.md]
gatekeeper: true
state_transition: Approves skeleton → test-writer begins
---

# Skeleton Reviewer

*Structure reference: [role-file-structure.md](patterns/role-file-structure.md)*

## Purpose

Review skeleton code to ensure it accurately reflects the specification, enables TDD, and follows project patterns. Approval gates progression to test writing.

This review catches mismatches between spec and code before they propagate into tests and implementation.

## Collaboration Pattern

This is an **independent role** - work separately from skeleton writer.

**Responsibilities:**
- Verify skeleton matches approved spec exactly
- Check testability (dependency injection, interfaces)
- Validate code quality (linting, types, imports)
- Confirm consistency with project patterns
- Approve or request changes

**Review flow:**
1. Skeleton writer marks code ready
2. Read spec and skeleton independently
3. Provide structured feedback
4. Writer addresses issues
5. Approve when quality bar met
6. Writer creates feature branch, moves spec to `doing/`

## Inputs

**Code under review:**
- Skeleton interface files from skeleton-writer

**References:**
- Approved SPEC from `specs/todo/`
- [schema-interface-skeleton-code.md](schema-interface-skeleton-code.md) - Quality standards
- SYSTEM_MAP.md - File organization patterns
- GUIDELINES.md - Code style conventions and architectural constraints
- Existing codebase - Consistency check

## Process

### Step 1: Load References
- Read SPEC.md from `specs/todo/`
- Locate skeleton files (usually in src/)
- Review relevant SYSTEM_MAP sections
- Note project patterns from existing code

### Step 2: Check Contract Compliance

For each function/class in spec, verify skeleton matches exactly. See [schema-interface-skeleton-code.md](schema-interface-skeleton-code.md) for complete quality standards.

**Verify:**
- [ ] Skeleton file exists
- [ ] Signature matches spec exactly
- [ ] All parameters present with correct types
- [ ] Return type matches spec
- [ ] All exceptions from spec defined
- [ ] Docstring includes Args, Returns, Raises
- [ ] Examples from spec reflected

**Template check:**
```
SPEC says: validate_email(email: str) -> tuple[bool, Optional[str]]
           Raises: TypeError

Skeleton has: validate_email(email: str) -> tuple[bool, Optional[str]]
              """...Raises: TypeError..."""
              raise NotImplementedError(...)
```

### Step 3: Check Data Types

For each data structure in spec, verify:
- [ ] Type defined in skeleton
- [ ] Structure matches spec
- [ ] Invariants documented
- [ ] Proper decorators (dataclass, etc.)
- [ ] Validation in __post_init__ if needed

**Example check:**
```python
# Spec says User has: email (str), id (Optional[int])
# Invariant: email non-empty, id None before save

✓ Good skeleton:
@dataclass
class User:
    """
    User account.
    Invariants: email non-empty, id None before save
    """
    email: str
    id: Optional[int] = None

    def __post_init__(self):
        if not self.email:
            raise ValueError("Email cannot be empty")
```

### Step 4: Check Exception Types

For each exception mentioned in spec:
- [ ] Exception class defined
- [ ] Inherits from appropriate base
- [ ] Constructor parameters sensible
- [ ] Error message format clear
- [ ] Attached to correct context

### Step 5: Check Dependency Injection (Critical for TDD)

For each class, verify:
- [ ] Dependencies passed to __init__
- [ ] No hard-coded dependencies
- [ ] Dependencies are interfaces (abstract types)
- [ ] No database connections in __init__
- [ ] No file I/O in __init__
- [ ] No API calls in __init__

**Red flags:**
```python
❌ Hard-coded: self.db = PostgresDB()
❌ Concrete: def __init__(self, repo: PostgresRepo)
❌ Instantiated: self.cache = RedisCache("localhost")

✓ Injectable: def __init__(self, repo: UserRepository)
✓ Interface: repo: UserRepository (abstract base class)
```

### Step 6: Check Interface Abstractions

For dependencies, verify:
- [ ] Abstract base classes exist
- [ ] Use ABC and @abstractmethod (Python) or Protocol
- [ ] Interface segregation (focused, not bloated)
- [ ] Methods match what main class needs
- [ ] No extra methods (keep interfaces minimal)

See [schema-interface-skeleton-code.md](schema-interface-skeleton-code.md) Section 5 for detailed interface requirements.

### Step 7: Check Docstrings

For each public method, verify complete docstring format. See [schema-interface-skeleton-code.md](schema-interface-skeleton-code.md) Section 2 for documentation standards.

**Minimum acceptable:**
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
    raise NotImplementedError("Implement in TDD green")
```

### Step 8: Verify Hollowness (No Implementation)

**Critical check - skeleton must be hollow:**
- [ ] Every method raises NotImplementedError
- [ ] No business logic
- [ ] No database queries
- [ ] No file operations
- [ ] No calculations
- [ ] No control flow (if/else/loops)
- [ ] Only structure and types

**Violations:**
```python
❌ Has logic:
def register(self, email: str) -> User:
    if "@" not in email:  # ❌ Validation logic
        raise ValidationError("Invalid")
    user = User(email=email)  # ❌ Implementation
    return self.repo.save(user)

✓ Hollow:
def register(self, email: str) -> User:
    """Register user. Raises: ValidationError"""
    raise NotImplementedError("Implement in TDD green")
```

### Step 9: Check Type Completeness

Verify complete typing. See [schema-interface-skeleton-code.md](schema-interface-skeleton-code.md) Section 1 for type annotation requirements.

- [ ] No `Any` types (be specific)
- [ ] No missing type hints
- [ ] No missing return types
- [ ] All imports present for types
- [ ] Generic types parameterized (List[int] not List)
- [ ] Optional used for nullable
- [ ] Union used for multiple types

### Step 10: Check Module Organization

**Verify structure:**
- [ ] Logical grouping (exceptions, types, interfaces, main)
- [ ] Module docstring present
- [ ] Import order: stdlib, third-party, local
- [ ] No circular imports
- [ ] Files in correct location per SYSTEM_MAP.md

### Step 11: Run Quality Checks

**Automated verification:**
```bash
# Run linter
ruff check src/  # or flake8, pylint per project

# Run type checker
mypy src/  # or pyright per project

# Try importing
python -c "from src.module import Class"
```

**All checks must pass before approval.**

### Step 12: Write Review

Use structured format (see Outputs section).

## Outputs

**Review document:** `reviews/skeletons/YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md`

Where STATUS ∈ {APPROVED, NEEDS-CHANGES}

Use seconds for uniqueness: `2025-01-23T14-30-47-weather-cache-APPROVED.md`

**Review template:**
```markdown
# Skeleton Review: [Feature Name]

**Reviewer:** [Your name/role]
**Date:** YYYY-MM-DD HH:MM:SS
**Spec:** specs/todo/[feature].md
**Skeleton Files:** [list files reviewed]
**Status:** APPROVED | NEEDS-CHANGES

## Summary
[Overall assessment in 2-3 sentences]

## Contract Compliance
- ✓/❌ All functions from spec present
- ✓/❌ Signatures match spec exactly
- ✓/❌ All data types defined
- ✓/❌ All exceptions defined

## Testability Assessment ⚠ Critical
- ✓/❌ Dependencies injectable (no hard-coding)
- ✓/❌ Interfaces abstract (ABC + @abstractmethod)
- ✓/❌ No concrete dependencies
- ✓/❌ SOLID principles applied

## Completeness
- ✓/❌ All methods have docstrings
- ✓/❌ All types have hints (no Any)
- ✓/❌ All exceptions created
- ✓/❌ Module docstrings present

## Hollowness Verification
- ✓/❌ No business logic
- ✓/❌ All methods raise NotImplementedError
- ✓/❌ No database/file/network operations

## Quality Checks
- ✓/❌ Linter passes
- ✓/❌ Type checker passes
- ✓/❌ Imports valid
- ✓/❌ Code follows GUIDELINES.md

## Critical Issues (if NEEDS-CHANGES)

### Issue 1: [Title]
- **File:** [filename:line]
- **Problem:** [What's wrong]
- **Impact:** [Why this blocks testing/implementation]
- **Fix:** [Specific action needed]

## Minor Issues
[Non-blocking improvements, if any]

## Testability Score
- Dependency injection: [Pass/Fail + explanation]
- Interface abstractions: [Pass/Fail + explanation]
- Type completeness: [Pass/Fail + explanation]

## Decision

**[APPROVED]** - Ready for test-writer. Skeleton writer should now:
1. Create feature branch: `git checkout -b feature/[name]`
2. Move spec: `git mv specs/todo/[name].md specs/doing/[name].md`
3. Commit and push

**[NEEDS-CHANGES]** - Address critical issues above before test writing.
```

## Common Issues

### Issue 1: Hard-Coded Dependencies
```
Problem: self.db = PostgresDB() in __init__
Impact: Can't inject test doubles
Fix: Add repo: UserRepository parameter
```

### Issue 2: Missing Type Hints
```
Problem: def process(data) with no types
Impact: Unclear interface, can't validate tests
Fix: def process(data: List[int]) -> Result
```

### Issue 3: Implementation Logic Present
```
Problem: Method has if/else business logic
Impact: Not a skeleton, confuses TDD cycle
Fix: Remove logic, raise NotImplementedError
```

### Issue 4: Concrete Dependencies
```
Problem: Depends on PostgresRepository (concrete)
Impact: Can't substitute test doubles
Fix: Create abstract UserRepository interface
```

### Issue 5: Missing Exceptions
```
Problem: Spec says "Raises ValidationError" but not defined
Impact: Can't write tests for error cases
Fix: Create ValidationError exception class
```

### Issue 6: Incomplete Docstrings
```
Problem: Missing Args, Returns, or Raises sections
Impact: Unclear contract for test writers
Fix: Add complete docstring with all sections
```

### Issue 7: Circular Imports
```
Problem: Module A imports B, B imports A
Impact: Import errors, can't run tests
Fix: Restructure dependencies or use TYPE_CHECKING
```

## Examples

### Example 1: APPROVED Review

```markdown
# Skeleton Review: Email Validation

**Status:** APPROVED

## Summary
Skeleton accurately reflects spec, properly typed, fully testable.
All quality checks pass. Ready for test writer.

## Contract Compliance
- ✓ validate_email() present with correct signature
- ✓ Return type tuple[bool, Optional[str]] matches spec
- ✓ TypeError exception documented

## Testability Assessment
- ✓ No dependencies (pure function)
- ✓ Type hints complete
- ✓ Ready for unit tests

## Quality Checks
- ✓ mypy passes
- ✓ ruff passes
- ✓ Import successful

## Decision
APPROVED - Ready for test-writer.
```

### Example 2: NEEDS-CHANGES Review

```markdown
# Skeleton Review: User Registration

**Status:** NEEDS-CHANGES

## Summary
Skeleton structure good but has critical testability issues.
Hard-coded dependencies prevent test double injection.

## Critical Issues

### Issue 1: Hard-Coded Database
- **File:** src/services/user.py:15
- **Problem:** `self.db = PostgresDB()` in __init__
- **Impact:** Can't inject mock for testing
- **Fix:**
  ```python
  def __init__(self, repo: UserRepository):
      self.repo = repo
  ```

### Issue 2: Missing Interface
- **File:** src/services/user.py
- **Problem:** No UserRepository interface defined
- **Impact:** Can't create test doubles
- **Fix:** Create abstract UserRepository with save() and get_by_email()

### Issue 3: Implementation in Skeleton
- **File:** src/services/user.py:25
- **Problem:** Has email validation logic in register()
- **Impact:** Skeleton should be hollow
- **Fix:** Remove all logic, just raise NotImplementedError

## Decision
NEEDS-CHANGES - Address 3 critical issues above.
```

## When to Adjust Rigor

**Reduce rigor for:**
- Internal utilities with single consumer
- Exploratory prototypes (marked experimental)
- Simple bug fixes (may document inline)

**Never skip:**
- Vision/Scope alignment check
- Testability verification
- Interface specification review

Goal: Ensure skeleton enables TDD, not achieve perfection.

## Communication Protocol

See [EmailIntegration.md](EmailIntegration.md) for complete email workflow documentation.

### When to Check Email

**Before starting work:**
- Check for skeleton review-request messages
- Check for answers to clarification questions

**After completing work:**
- Send approval or rejection message
- Send clarification-request if skeleton is unclear

**Use email workflow:**
```bash
./Workflow/scripts/run-role.sh --with-email skeleton-reviewer
```

### Message Types to Send

**approval** - Skeleton is approved
```bash
./Workflow/scripts/workflow-notify.sh \
  approval \
  specs/doing/feature-name.md \
  skeleton-writer,test-writer \
  NEXT_ROLES="test-writer" \
  CONTEXT="Skeleton approved, ready for test development"
```

**rejection** - Skeleton needs revision
```bash
./Workflow/scripts/workflow-notify.sh \
  rejection \
  specs/doing/feature-name.md \
  skeleton-writer \
  REVIEWER_COMMENTS="Type annotations incomplete, dependency injection not testable"
```

**clarification-request** - Need clarification
```bash
./Workflow/scripts/workflow-notify.sh \
  --in-reply-to "<review-request-message-id>" \
  clarification-request \
  specs/doing/feature-name.md \
  skeleton-writer \
  QUESTION="Should CacheInterface support async operations?" \
  BLOCKING="no"
```

## Integration with Workflow

**Receives:** Skeleton code on feature branch, SPEC from specs/doing/
**Produces:** Review in reviews/skeletons/
**Next:** Test Writer (if approved), Skeleton Writer (if needs changes)
**Gatekeeper:** Approves before test writing begins

**To understand where this role fits:** See [workflow-overview.md](workflow-overview.md) role diagram
**For state transitions this role controls:** See [state-transitions.md](state-transitions.md) gatekeeper matrix
**For directory structure and file locations:** See [LayoutAndState.md](LayoutAndState.md)

**Workflow position:**
```
spec-writer → SPEC ✓
  ↓
spec-reviewer → APPROVED ✓
  ↓
skeleton-writer → skeleton code
  ↓
skeleton-reviewer → APPROVED ⬅ YOU ARE HERE
  ↓
[skeleton-writer creates feature branch, moves spec to doing/]
  ↓
test-writer → tests (TDD RED)
  ↓
implementer → implementation (TDD GREEN)
```

Your approval is the gate before active development begins.

## Critical Reminders

**DO:**
- Check against spec meticulously
- Verify dependency injection (testability critical)
- Ensure complete type hints
- Confirm hollowness (no logic)
- Validate interfaces are abstract
- Run linter and type checker
- Provide specific, actionable feedback with file:line locations
- Reference [schema-interface-skeleton-code.md](schema-interface-skeleton-code.md) for detailed standards

**DON'T:**
- Allow hard-coded dependencies
- Accept missing types or Any types
- Permit implementation logic
- Skip SOLID principle check
- Overlook missing exceptions
- Approve without running quality checks
- Give vague feedback without concrete fixes
- Rewrite skeleton yourself (return to writer with specific feedback)

**Most critical:** If skeleton isn't testable, TDD won't work. Dependency injection is non-negotiable.
