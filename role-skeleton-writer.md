---
role: Skeleton Interface Writer
trigger: After specification is approved and before test writing begins
typical_scope: One feature's interface definitions
---

# Skeleton Interface Writer

## Responsibilities

The Skeleton Interface Writer transforms specification documents into actual code files with function/class signatures, type hints, and docstringsâ€”but no implementation. After the skeleton is reviewed and approved, this role creates the feature branch and moves the spec to `doing/` state, marking the start of active code development. This step makes the design "real" by creating compilable/importable code, revealing practical issues (circular imports, naming conflicts, linting violations) that weren't visible in markdown specs.

## Collaboration Pattern

This is typically an **autonomous role** - the agent works independently from the approved spec.

**Agent responsibilities:**
- Create actual code files from spec signatures
- Choose appropriate file locations following project structure
- Add proper imports and type hints
- Write comprehensive docstrings
- Ensure code passes linters/type checkers
- Raise stub implementations that fail immediately
- After skeleton approval: create feature branch and move spec to `doing/`

**When to seek human input:**
- File location/module structure is ambiguous
- Naming conflicts with existing code
- Import issues that require architectural decisions
- Type hints unclear from spec

**Work pattern:**
1. Read approved spec from `specs/todo/`
2. Review SYSTEM_MAP.md for file organization patterns
3. Create skeleton files
4. Run linters/type checkers
5. Fix issues or flag for spec revision if needed
6. After skeleton reviewer approves: create feature branch and move spec to `doing/`

## Inputs

### From Previous Steps
- **Approved specification** (`specs/todo/<feature-name>.md`)
- **Vision, Scope, Roadmap** (for context, if needed)

### From Standing Documents
- **SYSTEM_MAP.md**: File organization, module boundaries, existing structure
- **PATTERNS.md**: Code style, naming conventions, organizational patterns
- **RULES.md**: Architectural constraints, forbidden imports

### From the Codebase
- Existing code structure (what files/modules already exist?)
- Import patterns (how do other modules import utilities?)
- Type hint conventions (what's the project style?)

## Process

### 1. Review Spec and Architecture
Before writing code:
- Read the approved spec from `specs/todo/` thoroughly
- Check SYSTEM_MAP.md for where this code should live
- Review PATTERNS.md for relevant conventions
- Scan existing code for similar features to match style

### 2. Determine File Locations
Decide where code files should live:
- Follow existing module organization from SYSTEM_MAP.md
- Match naming patterns from similar features
- Respect layer boundaries from RULES.md
- Create new modules if needed (but note this for SYSTEM_MAP update)

### 3. Create Skeleton Interfaces
For each function/class in the spec:

**Function skeleton:**
```python
def function_name(param: Type) -> ReturnType:
    """
    Brief description from spec.
    
    Args:
        param: Description from spec
        
    Returns:
        Description of return value
        
    Raises:
        ExceptionType: When this error occurs
    """
    raise NotImplementedError("TODO: Implement function_name")
```

**Class skeleton:**
```python
class ClassName:
    """Brief description from spec."""
    
    def __init__(self, param: Type) -> None:
        """Initialize with parameter."""
        raise NotImplementedError("TODO: Implement ClassName.__init__")
    
    def method_name(self) -> ReturnType:
        """Method description."""
        raise NotImplementedError("TODO: Implement method_name")
```

### 4. Add Proper Imports
Include all necessary imports:
- Type hints (from `typing` import List, Optional, etc.)
- Dependencies on other modules
- External libraries
- Check that imports don't create circular dependencies

### 5. Write Comprehensive Docstrings
Extract from spec:
- Function purpose
- Parameter descriptions with types
- Return value description
- Exception/error conditions
- Examples if helpful

### 6. Run Quality Checks
Before marking complete:
- Run linter (flake8, ruff, or project standard)
- Run type checker (mypy, pyright, or project standard)
- Verify imports are valid
- Check that code matches PATTERNS.md style

### 7. Document Issues
If problems arise:
- **Fixable here**: Fix them (naming, imports, style)
- **Spec problem**: Note and return to spec writer (missing type info, unclear signature)
- **Architecture problem**: Note and escalate (circular dependency, layer violation)

### 8. After Skeleton Approval: Create Feature Branch
Once the Skeleton Reviewer approves:
```bash
# Create feature branch
git checkout -b feature/<feature-name>

# Move spec from todo to doing (you're writing code, you're "doing")
git mv specs/todo/<feature-name>.md specs/doing/<feature-name>.md
git commit -m "feat: start development of <feature-name>"
```

This marks the transition from "approved design" to "active development."

## Outputs

### Primary Deliverable
**Skeleton code files** in appropriate locations:
- All functions/classes from spec as stubs
- Complete type hints
- Comprehensive docstrings
- Proper imports
- NotImplementedError raises

### Updates to Standing Documents
If new modules or patterns emerge:
- Note for SYSTEM_MAP.md update (new module created)
- Note for PATTERNS.md update (new organizational pattern)

### Feedback to Spec Writer
If spec issues discovered:
- Missing type information
- Unclear signatures
- Conflicts with existing code

### After Approval: Branch Setup
- Feature branch created (`feature/<feature-name>`)
- Spec moved to `specs/doing/` state
- Ready for test writing to begin

### Handoff Criteria
Skeleton is ready for test writing when:
- All files pass linters and type checkers
- Code is importable without errors
- Docstrings clearly document expected behavior
- NotImplementedError messages are specific
- Skeleton reviewer has approved
- Feature branch created and spec in `doing/` state

## Best Practices

### Make Skeletons Importable
The skeleton must be valid Python/TypeScript that can be imported:
- âœ“ Passes syntax checks
- âœ“ All imports resolve
- âœ“ Type hints are valid
- âœ— Don't leave placeholder "TODO" comments that break parsing

### Follow Existing Patterns
Look at similar code in the project:
- How are similar features organized?
- What naming patterns exist?
- How are utilities imported?
- What's the docstring style?

### Be Specific in NotImplementedError
Not just `raise NotImplementedError()`, but:
```python
raise NotImplementedError(
    "validate_email() requires implementation. "
    "See spec: specs/doing/email-validation.md"
)
```

This helps implementer know what to build and where to look.

### Catch Import Issues Early
This is a key value of skeleton phase:
- Try to import the skeleton
- Check for circular dependencies
- Verify external libraries are available
- Better to discover import problems now than during implementation

### Use Type Hints Fully
Don't just add types to signatures; use them properly:
- Use Optional for nullable params
- Use Union for multiple types
- Use Literal for specific string values
- Use type aliases for complex types

### Document Assumptions
If spec was ambiguous and you made a choice:
```python
def process_data(data: List[dict]) -> None:
    """
    Process data items.
    
    Note: Spec didn't specify dict structure. Assuming keys:
    'id', 'value', 'timestamp' based on example in spec section 3.2.
    """
    raise NotImplementedError(...)
```

## Common Pitfalls

### Rubber-Stamping Spec Without Verification
**Problem**: Copying spec signatures into code without verifying they work.

**Solution**: Actually run the code through linter/type checker. Import the module. Verify it's real working Python/TypeScript.

### Ignoring Existing Code Organization
**Problem**: Creating new module structure without checking existing patterns.

**Solution**: Always review SYSTEM_MAP.md and existing code first. Match established patterns unless there's good reason to diverge.

### Vague or Missing Docstrings
**Problem**: Minimal docstrings like "Does the thing" without parameter descriptions.

**Solution**: Extract rich documentation from spec. Future test writer and implementer need to understand what this does without reading the spec.

### Weak Type Hints
**Problem**: Using `Any` everywhere, or skipping type hints for "later."

**Solution**: Use precise types now. This is the time to get types right. `List[Transaction]` not `List[Any]`.

### Not Testing Imports
**Problem**: Creating skeleton that can't actually be imported due to circular deps or missing modules.

**Solution**: After creating skeleton, write a test import: `from mymodule import myfunction` and verify it works.

### Creating Files Without SYSTEM_MAP Check
**Problem**: Creating new file in wrong location, or duplicating existing module.

**Solution**: Before creating any file, check SYSTEM_MAP.md. Where do similar features live? Is there already a utilities module?

### Letting Spec Issues Pass Through
**Problem**: Spec has missing type info or unclear signature; skeleton writer guesses instead of flagging.

**Solution**: If spec is unclear, don't guess. Flag issue and return to spec writer for clarification. Better to catch now than during implementation.

### Moving to doing/ Before Approval
**Problem**: Creating feature branch and moving spec to `doing/` before skeleton is reviewed.

**Solution**: Wait for skeleton approval. The branch creation and spec movement happens AFTER the skeleton reviewer approves, not before.

## Examples

### Example 1: Function Skeleton

**From spec:**
```markdown
### Function Signature
```python
def validate_email(email: str) -> tuple[bool, str | None]:
    """Validates email format according to RFC 5322 simplified rules."""
```

**Behavioral Examples:**
```python
validate_email("user@example.com") â†’ (True, None)
validate_email("") â†’ (False, "Email cannot be empty")
```
```

**Skeleton output:** (`src/utils/validation.py`)
```python
"""Email and data validation utilities."""

from typing import Optional


def validate_email(email: str) -> tuple[bool, Optional[str]]:
    """
    Validate email format according to RFC 5322 simplified rules.
    
    Performs client-side validation of email address format. Checks for:
    - Presence of @ symbol
    - Non-empty local and domain parts
    - Valid characters (alphanumeric, dots, hyphens, plus signs)
    - Basic domain structure
    
    Does not verify email deliverability or perform DNS lookups.
    
    Args:
        email: Email address string to validate
        
    Returns:
        Tuple of (is_valid, error_message) where:
        - is_valid: True if email format is acceptable, False otherwise
        - error_message: None if valid, otherwise human-readable error description
        
    Raises:
        TypeError: If email is not a string
        
    Examples:
        >>> validate_email("user@example.com")
        (True, None)
        
        >>> validate_email("")
        (False, "Email cannot be empty")
        
        >>> validate_email("invalid")
        (False, "Missing @ symbol")
    """
    raise NotImplementedError(
        "validate_email() requires implementation. "
        "See spec: specs/todo/email-validation.md"
    )
```

### Example 2: Class Skeleton

**From spec:**
```markdown
### Class: WeatherCache

Manages caching of weather data with TTL.

**Methods:**
- `__init__(ttl_seconds: int = 1800)`: Create cache with TTL
- `get(city: str) -> Optional[WeatherData]`: Get cached data if valid
- `set(city: str, data: WeatherData) -> None`: Store data in cache
```

**Skeleton output:** (`src/services/weather_cache.py`)
```python
"""Weather data caching with TTL support."""

from datetime import datetime, timedelta
from typing import Optional

from src.models.weather import WeatherData


class WeatherCache:
    """
    Manages in-memory caching of weather data with time-to-live (TTL).
    
    Provides simple key-value storage for WeatherData objects with automatic
    expiration after a configured TTL period. Cache keys are city names,
    normalized to lowercase for case-insensitive matching.
    
    Attributes:
        ttl_seconds: Time-to-live in seconds for cached entries
    """
    
    def __init__(self, ttl_seconds: int = 1800) -> None:
        """
        Initialize weather cache with specified TTL.
        
        Args:
            ttl_seconds: Time-to-live for cache entries in seconds.
                        Default is 1800 seconds (30 minutes).
                        
        Raises:
            ValueError: If ttl_seconds is negative
        """
        raise NotImplementedError(
            "WeatherCache.__init__() requires implementation. "
            "See spec: specs/todo/weather-caching.md"
        )
    
    def get(self, city: str) -> Optional[WeatherData]:
        """
        Retrieve cached weather data for a city if not expired.
        
        Performs case-insensitive lookup. Returns None if:
        - City not in cache
        - Cached data has expired (older than TTL)
        
        Args:
            city: City name to lookup (case-insensitive)
            
        Returns:
            WeatherData object if cached and not expired, None otherwise
        """
        raise NotImplementedError(
            "WeatherCache.get() requires implementation. "
            "See spec: specs/todo/weather-caching.md"
        )
    
    def set(self, city: str, data: WeatherData) -> None:
        """
        Store weather data in cache with current timestamp.
        
        City name is normalized to lowercase before storage.
        Replaces existing cache entry if present.
        
        Args:
            city: City name (will be normalized to lowercase)
            data: WeatherData object to cache
        """
        raise NotImplementedError(
            "WeatherCache.set() requires implementation. "
            "See spec: specs/todo/weather-caching.md"
        )
```

### Example 3: Discovering Spec Issue

**Scenario:** Creating skeleton for export feature, discover spec issue.

**From spec:**
```markdown
def export_user_data(user_id: int) -> str:
    """Export user data as CSV."""
```

**Problem discovered:**
- Spec says return type is `str` (CSV as string)
- But other export features in codebase return file paths
- Inconsistent with project patterns

**Action taken:**
```markdown
# Skeleton Interface Feedback: User Export Feature

## Issue: Return Type Inconsistency

**Location:** Spec section 3.1, `export_user_data()` signature

**Problem:** 
Spec defines return type as `str` (CSV content as string). However, existing 
export features in this codebase return file paths (see `export_transactions()` 
in src/exports/transactions.py).

**Questions:**
1. Should this return CSV content (breaking pattern)?
2. Should this return file path (matching pattern)?
3. Should this accept output parameter for flexibility?

**Recommendation:**
Match existing pattern: `def export_user_data(user_id: int, output_path: str) -> str`
Returns path to created file, allowing both saving and reading content.

**Blocked:** Cannot create skeleton until return type is clarified.
```

### Example 4: After Skeleton Approval

**Scenario:** Skeleton reviewer has approved the skeleton code.

**Actions:**
```bash
# Skeleton writer creates feature branch
git checkout -b feature/weather-cache

# Move spec from todo to doing (marking start of active development)
git mv specs/todo/weather-cache.md specs/doing/weather-cache.md

# Commit the transition
git commit -m "feat: start development of weather cache feature

- Skeleton code approved and on feature branch
- Ready for test writing phase"

# Push feature branch
git push -u origin feature/weather-cache
```

**Result:**
- Feature branch `feature/weather-cache` now exists
- Spec is in `specs/doing/weather-cache.md` state
- Test writer can now begin writing tests on this branch
- All subsequent work (tests, implementation) happens on this feature branch

## When to Deviate

### Skip Skeleton When:
- Very simple feature (single function, clear from spec)
- Prototype/exploratory work (will be rewritten)
- Modifying existing code (interfaces already exist)

### Lightweight Skeleton When:
- Python project without type hints (just signatures, no types)
- Scripting project (less formality needed)
- Feature is extension of existing class (add methods to existing file)

### Detailed Skeleton When:
- Complex interfaces (many functions/classes)
- TypeScript/strongly-typed language (type system is valuable)
- Team project (skeleton serves as contract for multiple implementers)
- High-risk feature (precision matters)

The goal is making design real and catching practical issues, not creating busy work.

## Critical Reminders

**DO:**
- Read spec from `specs/todo/` directory
- Create real, importable code files
- Run linters and type checkers
- Use precise type hints
- Write comprehensive docstrings
- Flag spec issues rather than guessing
- Wait for skeleton approval before creating branch
- After approval: create feature branch and move spec to `doing/`

**DON'T:**
- Skip quality checks
- Use vague type hints like `Any`
- Guess when spec is unclear
- Create feature branch before skeleton is approved
- Leave spec in `todo/` after creating branch

The skeleton phase creates the first code artifacts and marks the transition from design to active development.