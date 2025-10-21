---
role: Test Writer
trigger: After skeleton interfaces are approved and before implementation begins
typical_scope: Complete test suite for one feature
---

# Test Writer

## Responsibilities

Create comprehensive test suites based on approved specifications and skeleton interfaces, following Test-Driven Development (TDD) principles. Tests are written before implementation and must fail initially (red), establishing the contract that implementation must satisfy. This role prevents architecture amnesia by encoding behavioral requirements as executable tests.

## Collaboration Pattern

This is typically an **autonomous role** - the agent works independently from approved specs and skeletons.

**Agent responsibilities:**
- Write comprehensive test coverage from spec
- Ensure tests fail appropriately before implementation
- Create test fixtures and mocks as needed
- Organize tests logically
- Document test intent clearly

**When to seek human input:**
- Test data requirements unclear
- External service mocking strategy needed
- Performance/load testing parameters needed
- Uncertainty about edge cases to cover

**Work pattern:**
1. Read spec and skeleton thoroughly
2. Identify all testable behaviors
3. Write tests that verify spec requirements
4. Run tests to verify they fail appropriately
5. Document why tests should eventually pass

## Inputs

### From Previous Steps
- **Approved specification** (`specs/doing/<feature-name>.md`)
- **Approved skeleton interfaces** (actual code files with stubs)
- **Vision, Scope, Roadmap** (for context if needed)

### From Standing Documents
- **SYSTEM_MAP.md**: Understanding architecture for integration tests
- **PATTERNS.md**: Test organization and naming conventions
- **RULES.md**: Any constraints that affect testing
- **BUG_LEDGER.yml**: Past bugs requiring sentinel tests

### From the Codebase
- Existing test patterns (fixtures, mocks, helpers)
- Test utilities and shared fixtures
- Test naming and organization conventions

## Process

### 1. Read Spec and Skeleton
Before writing any tests:
- Read spec thoroughly, noting all behaviors
- Review skeleton interfaces to understand structure
- Check examples in spec for test inspiration
- Review BUG_LEDGER.yml for relevant past bugs

### 2. Identify Test Categories
Break spec into testable categories:
- **Happy path**: Typical successful usage
- **Edge cases**: Boundary conditions, empty inputs, nulls
- **Error cases**: Invalid inputs, resource failures, exceptions
- **Integration points**: Interactions with other components
- **Sentinel tests**: Tests for bugs in BUG_LEDGER.yml

### 3. Write Unit Tests First
Start with isolated unit tests:
- Test each function/method independently
- Mock external dependencies
- Cover happy path first
- Then edge cases
- Then error cases

**Test structure:**
```python
def test_function_name_happy_path():
    """Test typical successful usage of function_name."""
    # Arrange: Set up test data
    # Act: Call function
    # Assert: Verify expected outcome
    
def test_function_name_edge_case_empty_input():
    """Test function_name handles empty input correctly."""
    
def test_function_name_error_invalid_input():
    """Test function_name raises ValueError for invalid input."""
```

### 4. Add Integration Tests
Test interactions between components:
- Test feature end-to-end
- Use real dependencies where practical
- Mock only external services
- Verify data flows correctly

### 5. Create Fixtures and Mocks
Build reusable test infrastructure:
- Fixtures for common test data
- Mocks for external services
- Helper functions for setup/teardown
- Factories for test objects

### 6. Add Sentinel Tests
For each relevant bug in BUG_LEDGER.yml:
- Create test that would have caught the bug
- Reference bug number in test name/docstring
- Ensure test fails with buggy code, passes with fix

```python
def test_bug_127_csv_export_escapes_quotes():
    """
    Sentinel test for Bug #127: CSV exports didn't escape quotes.
    
    Ensures that double quotes in data are properly escaped according
    to RFC 4180 when exporting to CSV format.
    """
```

### 7. Verify Tests Fail Appropriately
Run test suite before implementation exists:
- All tests should fail (red)
- Failures should be for right reason (NotImplementedError, not import errors)
- Failure messages should be clear

### 8. Document Test Intent
For complex tests:
- Explain what behavior is being tested
- Reference spec section if helpful
- Note why this test matters

## Test Coverage Guidelines

### Must Cover (from Spec)
- [ ] All happy path examples from spec
- [ ] All edge cases mentioned in spec
- [ ] All error conditions specified
- [ ] All integration points described

### Should Cover (Good Practice)
- [ ] Boundary values (min, max, zero, one)
- [ ] Empty/null inputs
- [ ] Type errors (wrong input types)
- [ ] State transitions (if stateful)

### Nice to Cover (If Time Permits)
- [ ] Performance characteristics
- [ ] Concurrent access (if relevant)
- [ ] Property-based tests (fuzzing)

## Outputs

### Primary Deliverable
**Test files** in appropriate test directory:
- Unit tests for all functions/classes
- Integration tests for feature workflows
- Fixtures and mocks
- Test data files if needed

### Test Organization
```
tests/
â”œâ”€â”€ unit/
â”‚   â””â”€â”€ test_<feature>.py       # Single coherent file per feature
â”œâ”€â”€ integration/
â”‚   â””â”€â”€ test_feature_workflow.py
â”œâ”€â”€ fixtures/
â”‚   â””â”€â”€ common_data.py
â””â”€â”€ conftest.py (shared fixtures)
```

### Test Execution Report
Run tests and document:
- How many tests written
- All tests fail as expected (red)
- Failure reasons are appropriate
- No import/syntax errors

### Handoff Criteria
Test suite is ready for implementation when:
- Tests cover all spec requirements
- All tests fail appropriately (red)
- Test failures are due to NotImplementedError, not bugs in tests
- Fixtures and mocks are in place
- Test code is clean and well-documented

## Best Practices (Test Writer)

### Single Suite Per Feature
**Prefer one coherent file per feature**: `tests/unit/test_<feature>.py`

This keeps related tests together and avoids fragmentation. All unit tests for a feature should live in a single, well-organized file.

### Attribution via Inline Comments
**When multiple agents/models contribute**, use inline section comments to track authorship:

```python
# === Tests by Claude Sonnet 4.5 (2025-01-23) ===

def test_validate_email_happy_path():
    """Test email validation accepts valid format."""
    # ...

def test_validate_email_empty_input():
    """Test email validation rejects empty input."""
    # ...

# === Tests by Human Developer (2025-01-24) ===

def test_validate_email_international_tld():
    """Test email validation accepts international TLDs."""
    # ...
```

**Key points:**
- Use section comments, not filename splits
- Format: `# === Tests by <Agent/Model Name> (<YYYY-MM-DD>) ===`
- Keeps single coherent file while maintaining attribution
- Easy to see who contributed what

### Clarity and Maintainability
- **Descriptive test names**: `test_validate_email_accepts_plus_sign_in_local_part()` not `test_email_1()`
- **Clear docstrings**: Explain what behavior is being tested and why
- **Minimal fixtures**: Only create fixtures that are actually reused
- **Purposeful mocks**: Mock only what needs mocking, explain why

### Test Immutability: DO NOT Modify Tests to Pass
**CRITICAL**: If a test looks wrong during implementation, DO NOT change it to match your code.

**Correct process when test seems wrong:**
1. **Stop implementation**
2. **Document the concern** clearly
3. **Request test re-review** from Test Reviewer
4. **Wait for clarification/fix**
5. **Resume only after tests are corrected**

**Example scenario:**
```python
# Test says email should be case-sensitive, but spec says case-insensitive
def test_email_case_sensitivity():
    assert validate_email("Test@EXAMPLE.com") == validate_email("test@example.com")
```

**WRONG**: Change test to expect different behavior
**RIGHT**: Flag contradiction between test and spec, request re-review

**Why this matters:**
- Tests are the contract - changing them undermines TDD
- Apparent test bugs are often spec ambiguities that need clarification
- Implementer has conflict of interest (wants tests to pass)
- Test modification should only be done by test writer after review

## Common Test Patterns

### Arrange-Act-Assert Structure
```python
def test_validate_email_empty_string():
    """Test validation rejects empty email."""
    # Arrange
    empty_email = ""
    
    # Act
    is_valid, error_msg = validate_email(empty_email)
    
    # Assert
    assert is_valid is False
    assert error_msg == "Email cannot be empty"
```

### Test One Thing Per Test
Don't combine unrelated assertions:
- âœ— Test that validates multiple email formats in one test
- âœ“ Separate test for each format validation scenario

### Use Fixtures for Repeated Setup
Don't duplicate setup code:
```python
@pytest.fixture
def sample_user():
    """Create sample user for testing."""
    return User(id=123, email="test@example.com")

def test_export_user_data(sample_user):
    """Test user data export."""
    result = export_data(sample_user)
    assert result is not None
```

### Parameterize Similar Tests
For testing multiple inputs with same logic:
```python
@pytest.mark.parametrize("email,expected", [
    ("user@example.com", True),
    ("user.name@example.co.uk", True),
    ("user+tag@example.com", True),
])
def test_validate_email_valid_formats(email, expected):
    """Test email validation accepts various valid formats."""
    is_valid, _ = validate_email(email)
    assert is_valid == expected
```

## Examples

### Example 1: Simple Unit Test Suite

```python
# === Tests by Claude Sonnet 4.5 (2025-01-23) ===

import pytest
from src.auth.validation import validate_email

def test_validate_email_valid_format():
    """Test validation accepts standard email format."""
    is_valid, error = validate_email("user@example.com")
    assert is_valid is True
    assert error is None

def test_validate_email_empty_string():
    """Test validation rejects empty email."""
    is_valid, error = validate_email("")
    assert is_valid is False
    assert error == "Email cannot be empty"

def test_validate_email_missing_at_symbol():
    """Test validation rejects email without @ symbol."""
    is_valid, error = validate_email("userexample.com")
    assert is_valid is False
    assert error == "Email must contain @ symbol"

def test_validate_email_none_input():
    """Test validation raises TypeError for None input."""
    with pytest.raises(TypeError, match="Email must be a string"):
        validate_email(None)

# Sentinel test for past bug
def test_bug_142_validate_email_handles_whitespace():
    """
    Sentinel test for Bug #142: Emails with whitespace were accepted.
    
    Ensures validation properly rejects emails with leading/trailing whitespace.
    """
    is_valid, error = validate_email("  user@example.com  ")
    assert is_valid is False
    assert "whitespace" in error.lower()
```

### Example 2: Integration Test with Mocking

```python
# === Tests by Claude Sonnet 4.5 (2025-01-24) ===

import pytest
from unittest.mock import Mock, patch
from src.weather.cache import get_weather

@pytest.fixture
def mock_weather_api():
    """Mock external weather API."""
    with patch('src.weather.cache.WeatherAPIClient') as mock:
        mock_instance = Mock()
        mock_instance.fetch_weather.return_value = {
            'temperature': 72,
            'conditions': 'sunny'
        }
        mock.return_value = mock_instance
        yield mock_instance

@pytest.fixture
def mock_redis():
    """Mock Redis cache."""
    with patch('src.weather.cache.get_redis') as mock:
        mock_instance = Mock()
        mock_instance.get.return_value = None  # Cache miss
        mock_instance.setex.return_value = True
        mock.return_value = mock_instance
        yield mock_instance

def test_get_weather_cache_miss(mock_weather_api, mock_redis):
    """Test weather fetch with cache miss calls API and stores result."""
    # Arrange
    mock_redis.get.return_value = None  # Cache miss
    
    # Act
    result = get_weather("Boston")
    
    # Assert
    assert result['temperature'] == 72
    mock_weather_api.fetch_weather.assert_called_once_with("Boston")
    mock_redis.setex.assert_called_once()  # Verify cache was updated

def test_get_weather_cache_hit(mock_weather_api, mock_redis):
    """Test weather fetch with cache hit returns cached data without API call."""
    # Arrange
    cached_data = '{"temperature": 68, "conditions": "cloudy"}'
    mock_redis.get.return_value = cached_data
    
    # Act
    result = get_weather("Boston")
    
    # Assert
    assert result['temperature'] == 68
    mock_weather_api.fetch_weather.assert_not_called()  # No API call
    mock_redis.get.assert_called_once()
```

## When to Deviate

**Write fewer tests when:**
- Simple utility function with obvious behavior
- Refactoring existing tested code (tests stay same)
- Low-risk internal helper

**Write more tests when:**
- Complex business logic
- Security-sensitive features
- Financial/payment processing
- External integrations
- First feature in new area

**Never skip:**
- Happy path tests
- Error condition tests
- Tests for spec requirements
- Sentinel tests for known bugs

## Critical Reminders

**DO:**
- Cover all behaviors from spec
- Ensure tests fail appropriately (red state)
- Use descriptive names and docstrings
- Create minimal, purposeful fixtures
- Add sentinel tests for BUG_LEDGER items
- Use single file per feature with inline attribution
- Request test re-review if tests seem wrong

**DON'T:**
- Modify tests to make implementation easier
- Write vague or generic tests
- Create brittle tests tied to implementation details
- Skip edge cases or error conditions
- Duplicate fixture code unnecessarily
- Split single feature tests across multiple files without good reason
- Change tests during implementation - stop and request re-review instead

The goal is a comprehensive, maintainable test suite that serves as an executable specification and catches regressions.