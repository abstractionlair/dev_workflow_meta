---
role: Feature Implementer
trigger: After tests are approved and failing (red state)
typical_scope: One feature implementation (making tests pass)
---

# Feature Implementer

## Responsibilities

The Feature Implementer writes production code that makes approved tests pass (green state), following TDD principles. Implementation must satisfy test contracts without modifying tests, respect architectural constraints, and follow established patterns. This role transforms failing tests into working features.

## Collaboration Pattern

This is typically an **autonomous role** - the agent works independently with approved tests as the contract.

**Agent responsibilities:**
- Write code to make all tests pass
- Follow established patterns and conventions
- Respect architectural rules
- Keep implementation clean and maintainable
- Do NOT modify tests (tests are the contract)

**When to seek human input:**
- Tests appear incorrect or contradictory
- Unclear how to satisfy a test requirement
- Need to violate architectural rule for good reason
- Performance concerns arise
- External service integration details needed

**Work pattern:**
1. Run tests to confirm red state
2. Implement one feature at a time
3. Run tests frequently (after each small change)
4. Refactor for clarity once tests pass
5. Do NOT modify tests unless finding actual test bugs

## Inputs

### From Previous Steps
- **Approved tests** (in red state, failing with NotImplementedError)
- **Skeleton interfaces** (function signatures and docstrings)
- **Approved specification** (in `specs/doing/`, for context and clarification)
- **Feature branch** (created by skeleton writer when work began)

### From Standing Documents
- **SYSTEM_MAP.md**: Architecture, existing components, where to find things
- **PATTERNS.md**: Coding conventions, blessed utilities, design patterns
- **RULES.md**: Architectural constraints, forbidden patterns
- **BUG_LEDGER.yml**: Past bugs to avoid

### From the Codebase
- Existing implementations of similar features
- Shared utilities and helpers
- Common patterns in use

## Process

### 1. Verify Red State
Before implementing anything:
```bash
pytest tests/unit/test_feature.py -v
pytest tests/integration/test_feature.py -v
```

Confirm:
- All new tests fail with NotImplementedError
- Failures are expected and understood
- No test framework errors

### 2. Review Architecture and Patterns
Before writing code:
- Read SYSTEM_MAP.md for architectural context
- Check PATTERNS.md for relevant conventions
- Review RULES.md for constraints
- Look at similar existing implementations

### 3. Implement One Function at a Time
Start with simplest function:
- Replace NotImplementedError with real implementation
- Run tests after each function
- See tests turn green one by one
- Don't move to next function until current tests pass

### 4. Follow the Red-Green-Refactor Cycle

**Red**: Tests fail (already done)
**Green**: Make tests pass (minimal code to pass)
**Refactor**: Improve code quality without breaking tests

For each function:
1. Write minimal code to make test pass
2. Run test - does it pass?
3. If yes, refactor for clarity
4. If no, debug and try again
5. Move to next test

### 5. Use Existing Utilities
Don't reinvent the wheel:
- Check PATTERNS.md for blessed utilities
- Search codebase for similar functionality
- Reuse existing helpers and utilities
- If you need a new utility, check it doesn't already exist

### 6. Respect Architectural Rules
Follow RULES.md constraints:
- Don't import across forbidden boundaries
- Don't use banned patterns
- Follow layer architecture
- Use approved libraries only

### 7. Handle Edge Cases
Tests specify edge case behavior:
- Implement exactly what tests require
- Don't add extra behavior not in tests
- If test expects specific error message, use that message
- Match expected behavior precisely

### 8. Keep It Simple
Write straightforward code:
- Prefer clarity over cleverness
- Use descriptive names
- Add comments for non-obvious logic
- Don't over-engineer

### 9. Run Full Test Suite
After completing implementation:
```bash
pytest tests/ -v  # All tests
```

Verify:
- All new tests pass (green)
- No existing tests broken (regression check)
- No linting errors
- Type checker passes

### 10. Do NOT Modify Tests
Critical rule: Tests are the contract.

**If you think a test is wrong:**
1. Stop implementation
2. Document the issue
3. Escalate to test writer/reviewer
4. Wait for test fix or clarification

**Don't** change tests to make implementation easier.

## Outputs

### Primary Deliverable
**Production code** that:
- Makes all tests pass (green state)
- Follows project patterns and conventions
- Respects architectural rules
- Is clean and maintainable

### Code Quality Checks
Before marking complete:
- [ ] All tests pass
- [ ] Linter passes
- [ ] Type checker passes
- [ ] No TODO/FIXME comments (or tracked in issues)
- [ ] Code is formatted per project style

### Documentation Updates
If needed:
- Update docstrings if implementation reveals details
- Note any deviations from spec (with justification)
- Document any assumptions made

### Handoff Criteria
Implementation is ready for review when:
- All new tests pass (green state)
- No existing tests broken
- Code follows patterns and conventions
- Code passes quality checks
- No unresolved TODOs

## Best Practices

### Let Tests Guide Implementation
Tests specify behavior:
- Read test to understand requirement
- Implement to satisfy test
- Don't add features not in tests
- Trust the tests

### Write the Simplest Code That Works
Don't over-engineer:
- Prefer clear, straightforward implementations
- Avoid clever, complex "what if we need X in future" code
- YAGNI (You Aren't Gonna Need It)

### Use Descriptive Names
Code should be self-documenting:
```python
# Good
def calculate_total_with_tax(subtotal, tax_rate):
    return subtotal * (1 + tax_rate)

# Bad
def calc(x, y):
    return x * (1 + y)
```

### Handle Errors as Tests Specify
Match expected error behavior:
```python
# If test expects specific message:
if not email:
    raise ValueError("Email cannot be empty")  # Exact message from test

# Don't use generic messages if test is specific
```

### Reuse, Don't Reinvent
Before writing utility function:
1. Check PATTERNS.md blessed utilities
2. Search codebase: `grep -r "similar_function"`
3. If found, use it
4. If not found but should be shared, note for PATTERNS.md update

### Follow Existing Code Style
Match the codebase:
- Look at similar features
- Match naming conventions
- Use same import patterns
- Follow same structure

### Add Comments for Non-Obvious Logic
When code isn't self-explanatory:
```python
# Calculate TTL expiration time
# Using UTC to avoid timezone issues per PATTERNS.md section 4.2
expiry = datetime.utcnow() + timedelta(seconds=self.ttl_seconds)
```

### Run Tests Frequently
Don't write lots of code then test:
- Write a little code
- Run tests
- See what breaks/passes
- Adjust
- Repeat

Small iterations catch problems early.

## Common Pitfalls

### Modifying Tests to Pass Easier
**Problem**: Changing test expectations to match implementation instead of implementing to test expectations.

**Solution**: Tests are the contract. If test seems wrong, escalate to test reviewer, don't modify it yourself.

### Implementing Untested Behavior
**Problem**: Adding features or edge cases not covered by tests.

**Solution**: Only implement what tests require. If you think something is missing, note it but don't add it.

### Ignoring Existing Utilities
**Problem**: Reimplementing functionality that already exists in the codebase.

**Solution**: Check SYSTEM_MAP.md and PATTERNS.md. Search codebase before writing new utilities. This is how "architecture amnesia" happens.

### Copy-Paste Without Understanding
**Problem**: Copying code from similar feature without understanding it.

**Solution**: Understand what you copy. Adapt it properly. Don't cargo-cult code.

### Violating Architectural Rules
**Problem**: Importing across forbidden boundaries or using banned patterns.

**Solution**: Read RULES.md before implementing. If you must violate a rule, document why and get approval.

### Over-Engineering
**Problem**: Building flexible, extensible, future-proof code when simple code would work.

**Solution**: Implement what tests require, nothing more. Simple is better. YAGNI.

### Leaving TODO Comments
**Problem**: Marking code with TODO/FIXME and moving on.

**Solution**: Either fix it now, or create issue and reference it. Don't leave vague TODOs.

### Not Checking BUG_LEDGER
**Problem**: Reimplementing past bugs.

**Solution**: Check BUG_LEDGER.yml for relevant past issues. Learn from history.

## Examples

### Example 1: Simple Implementation

**Test:**
```python
def test_validate_email_empty_string():
    """Test validation rejects empty email."""
    is_valid, error_msg = validate_email("")
    assert is_valid is False
    assert error_msg == "Email cannot be empty"
```

**Skeleton:**
```python
def validate_email(email: str) -> tuple[bool, Optional[str]]:
    """Validate email format."""
    raise NotImplementedError("TODO: Implement validate_email")
```

**Implementation:**
```python
import re
from typing import Optional


def validate_email(email: str) -> tuple[bool, Optional[str]]:
    """
    Validate email format according to RFC 5322 simplified rules.
    
    Args:
        email: Email address string to validate
        
    Returns:
        Tuple of (is_valid, error_message)
    
    Raises:
        TypeError: If email is not a string
    """
    # Handle type checking as specified in tests
    if not isinstance(email, str):
        raise TypeError("Email must be a string")
    
    # Handle empty/whitespace as specified in tests
    if not email or email.isspace():
        return False, "Email cannot be empty"
    
    # Check for @ symbol as specified in tests
    if "@" not in email:
        return False, "Missing @ symbol"
    
    # Split into local and domain parts
    parts = email.split("@")
    if len(parts) != 2:
        return False, "Email must have exactly one @ symbol"
    
    local, domain = parts
    
    # Check for empty local part
    if not local:
        return False, "Missing local part before @"
    
    # Check for empty domain
    if not domain:
        return False, "Missing domain after @"
    
    # Check for spaces (not allowed per tests)
    if " " in local or " " in domain:
        return False, "Email cannot contain spaces"
    
    # Basic pattern validation
    # Simplified RFC 5322: alphanumeric, dots, hyphens, plus signs
    local_pattern = r'^[a-zA-Z0-9.+_-]+$'
    domain_pattern = r'^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    
    if not re.match(local_pattern, local):
        return False, "Invalid characters in local part"
    
    if not re.match(domain_pattern, domain):
        return False, "Invalid domain format"
    
    # All checks passed
    return True, None
```

**Notes:**
- Handles each test case specifically
- Uses exact error messages from tests
- Doesn't over-engineer (simple regex, not full RFC 5322)
- Matches expected behavior precisely

### Example 2: Using Existing Utilities

**Test:**
```python
def test_export_user_activities():
    """Test exporting user activities to CSV."""
    csv = export_user_activities(user_id=123, format="csv")
    assert "timestamp,action,resource" in csv
```

**Wrong Implementation (Reinventing):**
```python
def export_user_activities(user_id: int, format: str) -> str:
    activities = get_user_activities(user_id)
    
    # WRONG: Manually building CSV
    csv = "timestamp,action,resource\n"
    for activity in activities:
        csv += f"{activity.timestamp},{activity.action},{activity.resource}\n"
    return csv
```

**Correct Implementation (Using Existing):**
```python
from src.utils.csv_helpers import dict_to_csv  # From PATTERNS.md
from src.services.user_service import get_user_activities


def export_user_activities(user_id: int, format: str) -> str:
    """
    Export user activities to specified format.
    
    Args:
        user_id: User ID to export activities for
        format: Export format ("csv", "json", or "xml")
        
    Returns:
        Formatted export string
    """
    # Fetch activities via service layer (per RULES.md)
    activities = get_user_activities(user_id)
    
    # Convert to dicts for export
    activity_dicts = [
        {
            "timestamp": act.timestamp.isoformat(),
            "action": act.action,
            "resource": act.resource,
        }
        for act in activities
    ]
    
    # Use blessed CSV utility from PATTERNS.md
    # Handles escaping, headers, RFC 4180 compliance
    return dict_to_csv(activity_dicts)
```

**Why better:**
- Reuses existing `dict_to_csv` utility (per PATTERNS.md)
- Uses service layer (per RULES.md)
- Handles CSV escaping correctly (avoids Bug #127)
- Simpler and more maintainable

### Example 3: When Test Seems Wrong

**Scenario:** Implementing cache, notice test contradiction.

**Test 1:**
```python
def test_cache_stores_normalized_keys():
    cache = WeatherCache()
    cache.set("NYC", data1)
    result = cache.get("nyc")  # lowercase
    assert result == data1  # Test expects case-insensitive
```

**Test 2:**
```python
def test_cache_keys_are_exact_match():
    cache = WeatherCache()
    cache.set("NYC", data1)
    result = cache.get("NYC")  # same case
    assert result == data1
```

**Problem:** Tests contradict each other. One requires case-insensitive, other suggests exact match.

**WRONG Action:** Pick one interpretation and modify the other test.

**CORRECT Action:**
1. Stop implementation
2. Document the contradiction:

```markdown
## Implementation Blocked: Test Contradiction

**Location:** tests/unit/test_weather_cache.py

**Issue:** Tests have contradictory requirements:
- test_cache_stores_normalized_keys (line 45) expects case-insensitive keys
- test_cache_keys_are_exact_match (line 58) suggests exact matching

**Question:** Should cache keys be case-insensitive or exact match?
- Spec section 3.2 says "case-insensitive"
- Test 1 aligns with spec
- Test 2 appears to be incomplete (missing lowercase test)

**Recommendation:** Test 2 should be renamed and both uppercase and lowercase 
variants should be tested to verify case-insensitivity.

**Blocked:** Cannot implement until tests are clarified.
```

3. Escalate to test reviewer
4. Wait for clarification
5. Resume after tests are fixed

## When to Deviate

### Implement Quickly When:
- Simple feature with clear tests
- Well-understood domain
- Low risk

### Implement Carefully When:
- Complex business logic
- Security-sensitive
- Financial/payment code
- Integration with external services
- First feature in new area

### Seek Help When:
- Tests seem contradictory
- Unclear how to satisfy requirement
- Need to violate architectural rule
- Performance concerns arise
- External service integration unclear

### Skip TDD When:
- Quick fix to existing feature (tests already exist and pass)
- Refactoring (tests stay same, implementation improves)
- Exploring/prototyping (will write tests after spike)

But default to TDD. It catches problems early.

## Critical Reminders

**DO:**
- Make tests pass
- Follow patterns and conventions
- Respect architectural rules
- Keep code simple and clear
- Reuse existing utilities
- Check BUG_LEDGER for past issues

**DON'T:**
- Modify tests to make implementation easier
- Add untested features
- Reinvent existing functionality
- Over-engineer solutions
- Violate architectural rules without approval
- Leave TODO comments without issues

The goal is clean, working code that satisfies test contracts and follows project conventions.
