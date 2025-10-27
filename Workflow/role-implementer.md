---
role: Implementer
trigger: After tests approved and failing (RED)
typical_scope: One feature implementation (GREEN phase)
dependencies: [approved tests (RED state), skeleton interfaces, SPEC from specs/doing/, SYSTEM_MAP.md, GUIDELINES.md]
outputs: [working implementation with all tests GREEN, clean maintainable code]
gatekeeper: false
---

# Implementer

*For standard role file structure, see [role-file-structure.md](patterns/role-file-structure.md).*

## Purpose

Write production code that makes approved tests pass (TDD GREEN phase). Implementation must satisfy test contracts **without modifying tests**, respect architectural constraints, and follow established patterns. You transform failing tests into working features.

## Collaboration Pattern

This is an **autonomous role** - work independently with tests as the contract.

**Responsibilities:**
- Make all tests pass (GREEN)
- Follow established patterns
- Respect architectural rules
- Keep code clean and maintainable
- **DO NOT modify tests** (tests are the contract)

**Seek human input when:**
- Tests appear incorrect or contradictory
- Unclear how to satisfy test requirement
- Need to violate architectural rule
- Performance concerns
- External service integration details needed

## Inputs

**From workflow:**
- Approved tests (RED state, failing)
- Skeleton interfaces (signatures)
- SPEC from `specs/doing/` (context)
- Feature branch (already created)

**From standing docs:**
- SYSTEM_MAP.md - Architecture, components, reusable utilities
- GUIDELINES.md - Coding patterns and constraints (what to do, what to avoid)

**From codebase:**
- Existing implementations of similar features
- Shared utilities and helpers

## Process

### 1. Verify RED State

**Before implementing:**
```bash
pytest tests/test_feature.py -v
```

**Confirm:**
- All new tests fail with NotImplementedError
- Failures expected and understood
- No test framework errors

### 2. Review Architecture

**Before writing code:**
- Read SYSTEM_MAP.md for context
- Check GUIDELINES.md for conventions
- Review GUIDELINES.md for constraints
- Look at similar existing implementations

### 3. Implement One Function at a Time

**Start with simplest function:**
1. Replace NotImplementedError with real implementation
2. Run tests after each function
3. See tests turn green one by one
4. Don't move on until current tests pass

**Example progression:**
```bash
# Start
pytest tests/test_user.py
# 5 failed: test_register, test_login, test_validate_email, etc.

# Implement validate_email()
pytest tests/test_user.py::test_validate_email
# 1 passed, 4 failed

# Implement register()
pytest tests/test_user.py::test_register
# 2 passed, 3 failed

# Continue until all pass
```

### 4. Follow RED-GREEN-REFACTOR

**TDD cycle for each function:**
1. **RED**: Verify test fails (already done by test-writer)
2. **GREEN**: Write minimal code to make test pass
3. **REFACTOR**: Improve code quality while keeping tests green
4. **REPEAT**: Move to next test

#### GREEN Phase: Make It Work

Write the simplest code that makes tests pass:

```python
# GREEN (minimal implementation)
def validate_email(email: str) -> tuple[bool, Optional[str]]:
    if not isinstance(email, str):
        raise TypeError("email must be string")
    if not email:
        return (False, "Email cannot be empty")
    if "@" not in email:
        return (False, "Missing @ symbol")
    return (True, None)
```

**Run tests:**
```bash
pytest tests/test_validation.py::test_validate_email -v
# PASS ✓
```

#### REFACTOR Phase: Make It Better

Now that tests pass, improve code quality:

```python
# REFACTOR (improve readability and structure)
def validate_email(email: str) -> tuple[bool, Optional[str]]:
    """Validate email format per RFC 5322 simplified rules.

    Args:
        email: Email address to validate

    Returns:
        Tuple of (is_valid, error_message)
        error_message is None if valid

    Raises:
        TypeError: If email is not a string
    """
    if not isinstance(email, str):
        raise TypeError("email must be string")

    # Check basic requirements
    if not email:
        return (False, "Email cannot be empty")

    if "@" not in email:
        return (False, "Missing @ symbol")

    # Validate structure
    local, _, domain = email.partition("@")
    if not local or not domain:
        return (False, "Invalid email structure")

    return (True, None)
```

**Run tests again:**
```bash
pytest tests/test_validation.py::test_validate_email -v
# PASS ✓ (still passing after refactoring)
```

### When to Refactor

**Refactor when you see:**

✓ **Duplication** - Same code in multiple places
```python
# Before refactoring
def register(req, res):
    if not email:
        return res.status(400).json({"error": {"code": "INVALID", "message": "Invalid"}})

def login(req, res):
    if not password:
        return res.status(400).json({"error": {"code": "INVALID", "message": "Invalid"}})

# After refactoring - extract common pattern
def send_error(res, code, message, status=400):
    return res.status(status).json({"error": {"code": code, "message": message}})
```

✓ **Unclear names** - Variables/functions with cryptic names
```python
# Before: Unclear
def proc(u):
    return u.e if u else None

# After: Clear intent
def get_user_email(user):
    return user.email if user else None
```

✓ **Long functions** - Function doing too many things
```python
# Before: One function doing everything (40 lines)
def register_user(email, password):
    # Validate email (10 lines)
    # Hash password (5 lines)
    # Save to database (10 lines)
    # Send welcome email (10 lines)
    # Log event (5 lines)

# After: Extract smaller functions
def register_user(email, password):
    validated_email = validate_and_normalize_email(email)
    password_hash = hash_password(password)
    user = save_user_to_database(validated_email, password_hash)
    send_welcome_email(user)
    log_registration_event(user)
    return user
```

✓ **Deep nesting** - Too many nested if/for statements
```python
# Before: Deep nesting
def process_items(items):
    for item in items:
        if item.active:
            if item.price > 0:
                if item.stock > 0:
                    # Process item

# After: Early returns
def process_items(items):
    for item in items:
        if not item.active:
            continue
        if item.price <= 0:
            continue
        if item.stock <= 0:
            continue
        # Process item
```

✓ **Magic numbers** - Unexplained constants
```python
# Before: Magic numbers
if user.age >= 18 and user.score > 500:
    grant_premium()

# After: Named constants
MINIMUM_AGE = 18
PREMIUM_SCORE_THRESHOLD = 500

if user.age >= MINIMUM_AGE and user.score > PREMIUM_SCORE_THRESHOLD:
    grant_premium()
```

✓ **Poor error messages** - Generic or unclear errors
```python
# Before: Unclear
raise ValueError("Invalid")

# After: Specific
raise ValueError(f"Email '{email}' is invalid: missing @ symbol")
```

**Don't refactor when:**

❌ **Tests aren't passing** - Get to GREEN first
❌ **Near deadline** - Document technical debt instead
❌ **Unclear improvement** - If refactoring doesn't clearly help, skip it
❌ **Working on greenfield** - Code might change significantly, wait
❌ **Major changes needed** - Might indicate spec issue, flag for review

### Refactoring Checklist

**Before refactoring:**
- [ ] All tests passing (GREEN state)
- [ ] Clear improvement identified
- [ ] Time available (not urgent deadline)

**During refactoring:**
- [ ] Make one change at a time
- [ ] Run tests after each change
- [ ] Keep changes small and focused
- [ ] Don't change behavior (tests prove this)

**After refactoring:**
- [ ] All tests still passing
- [ ] Code more readable/maintainable
- [ ] No new complexity added
- [ ] Commit with clear refactoring message

### Refactoring Patterns

#### Pattern 1: Extract Method

**When:** Function doing multiple things, hard to understand

**Before:**
```python
def process_order(order):
    # Calculate total
    total = 0
    for item in order.items:
        total += item.price * item.quantity

    # Apply discount
    if order.user.is_premium:
        total *= 0.9

    # Calculate tax
    tax = total * 0.08

    return total + tax
```

**After:**
```python
def process_order(order):
    subtotal = calculate_subtotal(order.items)
    discounted = apply_discount(subtotal, order.user)
    return add_tax(discounted)

def calculate_subtotal(items):
    return sum(item.price * item.quantity for item in items)

def apply_discount(amount, user):
    return amount * 0.9 if user.is_premium else amount

def add_tax(amount, rate=0.08):
    return amount * (1 + rate)
```

**Benefits:** Each function has single responsibility, easier to test, clearer intent

#### Pattern 2: Replace Conditionals with Polymorphism

**When:** Complex if/elif chains based on type

**Before:**
```python
def calculate_shipping(order):
    if order.shipping_method == "standard":
        return 5.00
    elif order.shipping_method == "express":
        return 15.00
    elif order.shipping_method == "overnight":
        return 30.00
    else:
        raise ValueError("Unknown method")
```

**After:**
```python
class ShippingMethod:
    def calculate_cost(self): raise NotImplementedError

class StandardShipping(ShippingMethod):
    def calculate_cost(self): return 5.00

class ExpressShipping(ShippingMethod):
    def calculate_cost(self): return 15.00

class OvernightShipping(ShippingMethod):
    def calculate_cost(self): return 30.00

def calculate_shipping(order):
    return order.shipping_method.calculate_cost()
```

**Benefits:** Open for extension, closed for modification, easier to add new methods

#### Pattern 3: Extract Configuration

**When:** Multiple constants scattered through code

**Before:**
```python
def validate_password(password):
    if len(password) < 8:
        return False
    if not any(c.isupper() for c in password):
        return False
    if not any(c.isdigit() for c in password):
        return False
    return True
```

**After:**
```python
PASSWORD_MIN_LENGTH = 8
PASSWORD_REQUIRE_UPPERCASE = True
PASSWORD_REQUIRE_DIGIT = True

def validate_password(password):
    if len(password) < PASSWORD_MIN_LENGTH:
        return False
    if PASSWORD_REQUIRE_UPPERCASE and not any(c.isupper() for c in password):
        return False
    if PASSWORD_REQUIRE_DIGIT and not any(c.isdigit() for c in password):
        return False
    return True
```

**Benefits:** Configuration centralized, easier to change, self-documenting

#### Pattern 4: Simplify Boolean Expressions

**When:** Complex boolean logic hard to read

**Before:**
```python
if not (user.is_active and user.email_verified) or user.is_banned:
    deny_access()
```

**After:**
```python
def can_access(user):
    if user.is_banned:
        return False
    return user.is_active and user.email_verified

if not can_access(user):
    deny_access()
```

**Benefits:** Named function explains intent, easier to test, more readable

### Refactoring Anti-Patterns

#### ❌ Anti-Pattern 1: Big Bang Refactoring

**Don't:** Refactor everything at once

```python
# ❌ Bad: Changing multiple functions simultaneously
# Risk: If tests fail, hard to know what broke
def register(email, password):  # Refactored
def login(email, password):     # Refactored
def validate_email(email):      # Refactored
def hash_password(password):    # Refactored
```

**Do:** Refactor incrementally

```python
# ✓ Good: One function at a time
# 1. Refactor validate_email, run tests
# 2. Refactor hash_password, run tests
# 3. Refactor register, run tests
# 4. Refactor login, run tests
```

#### ❌ Anti-Pattern 2: Premature Abstraction

**Don't:** Abstract before you understand the pattern

```python
# ❌ Bad: Creating abstraction after seeing pattern once
class ValidationRule:
    def validate(self, value): pass

class EmailValidationRule(ValidationRule):
    def validate(self, email): ...

class PasswordValidationRule(ValidationRule):
    def validate(self, password): ...

# Complexity not justified yet!
```

**Do:** Wait for 3rd occurrence (Rule of Three)

```python
# ✓ Good: Keep simple until pattern repeats
def validate_email(email): ...
def validate_password(password): ...

# After 3rd similar function, consider abstraction
```

#### ❌ Anti-Pattern 3: Refactoring Without Tests

**Don't:** Refactor when tests are failing

```bash
# ❌ Bad state
$ pytest
FAILED tests/test_user.py::test_register

# Now refactoring register() - very risky!
```

**Do:** Only refactor from GREEN state

```bash
# ✓ Good state
$ pytest
PASSED tests/test_user.py::test_register

# Safe to refactor register()
```

#### ❌ Anti-Pattern 4: Changing Behavior During Refactoring

**Don't:** Add features while refactoring

```python
# ❌ Bad: Adding new validation during refactoring
def validate_email(email):
    if not email:
        return False
    if "@" not in email:
        return False
    # Adding new feature: domain validation (NOT refactoring!)
    if not email.endswith((".com", ".org", ".net")):
        return False
    return True
```

**Do:** Refactor preserves behavior exactly

```python
# ✓ Good: Only improving structure, same behavior
def validate_email(email):
    """Validate email has @ symbol."""
    if not email:
        return False
    return "@" in email

# Tests prove behavior unchanged
```

### Validating Refactoring

**Run tests after EVERY change:**

```bash
# After each refactoring step
pytest tests/test_feature.py -v

# Should see same results before and after:
# Before refactoring: 10 passed
# After refactoring:  10 passed ✓
```

**If tests fail after refactoring:**

1. **Stop immediately** - Don't continue refactoring
2. **Read failure** - What broke?
3. **Revert change** - `git checkout -- file.py`
4. **Understand why** - Was refactoring wrong? Or test exposed real issue?
5. **Try smaller step** - Break refactoring into smaller pieces
6. **Re-run tests** - Verify each small step

**Commit after successful refactoring:**

```bash
git add src/services/auth.py
git commit -m "refactor: extract error response formatting

- Extract repeated error response code to utility
- No behavior changes, all tests still passing
- Improves maintainability and consistency"
```

**Separate refactoring commits from feature commits:**

```bash
# ✓ Good: Clear progression
git log --oneline
abc123 feat: implement user registration
def456 refactor: extract validation helpers
789abc feat: implement user login

# ❌ Bad: Mixed changes
git log --oneline
abc123 feat: add login and refactor validation and fix bug
```

### Refactoring Example from WorkflowExample.md

See `Workflow/WorkflowExample.md` Step 16 for a complete refactoring example showing:
- Identifying duplication (error response formatting)
- Extracting to shared utility
- Updating multiple files consistently
- Running tests to verify no breaks
- Benefits of the refactoring

### 5. Use Existing Utilities

**Don't reinvent:**
- Check GUIDELINES.md for blessed utilities
- Use shared helpers for common tasks
- Import from established modules
- Follow project conventions

**Example:**
```python
# ❌ Don't create your own
def hash_password(password: str) -> str:
    return hashlib.sha256(password.encode()).hexdigest()

# ✓ Use project standard (from GUIDELINES.md)
from src.utils.security import hash_password
```

### 6. Handle Dependencies

**Use dependency injection (from skeleton):**
```python
class UserService:
    def __init__(
        self,
        repo: UserRepository,
        email: EmailService,
        hasher: PasswordHasher
    ):
        self.repo = repo
        self.email = email
        self.hasher = hasher
    
    def register(self, email: str, password: str) -> User:
        # Implementation uses injected dependencies
        hashed = self.hasher.hash(password)
        user = User(email=email, password_hash=hashed)
        saved_user = self.repo.save(user)
        self.email.send_welcome(email, saved_user.id)
        return saved_user
```

### 7. Respect Architectural Rules

**Check GUIDELINES.md before:**
- Importing from forbidden modules
- Creating new database connections
- Bypassing established abstractions
- Introducing new external dependencies

**Example rules:**
```
❌ Don't: Direct database imports in service layer
✓ Do: Use repository interfaces

❌ Don't: Global state or singletons
✓ Do: Pass dependencies explicitly

❌ Don't: Import from ../../../deep/path
✓ Do: Use proper package imports
```

### 8. Test Continuously

**Run tests frequently:**
```bash
# After each small change
pytest tests/test_feature.py::test_specific_case -v

# After each function complete
pytest tests/test_feature.py -v

# Before committing
pytest tests/ -v
```

**If test fails unexpectedly:**
1. Read test failure message carefully
2. Check if implementation matches test expectation
3. Verify test is correct (review test-reviewer approval)
4. If test is wrong → flag for test re-review
5. If implementation wrong → fix it

### 9. Handle Test Conflicts

**If test seems wrong:**

**DO NOT modify test to make it pass.**

**Instead:**
1. Stop implementation
2. Document the concern:
   ```markdown
   ## Test Issue Found
   
   **Test:** test_register_invalid_email_raises_error
   **Problem:** Test expects ValueError but spec says ValidationError
   **Evidence:** Spec section 3.2 explicitly states ValidationError
   **Blocked:** Cannot proceed until test corrected
   ```
3. Request test re-review
4. Wait for clarification
5. Resume after test fixed

### 10. Run Full Test Suite

**Before marking complete:**
```bash
# All tests in feature
pytest tests/test_feature.py -v

# All project tests
pytest tests/ -v

# With coverage
pytest tests/ --cov=src --cov-report=term-missing
```

**All must pass before submitting for review.**

### 11. Commit Strategy

**Commit after each function works:**
```bash
git add src/services/user.py tests/test_user.py
git commit -m "feat: implement user registration validation

- Add email validation logic
- Tests: test_validate_email_* all passing
- Follows RFC 5322 simplified rules"
```

**Benefits:**
- Easy to revert if needed
- Clear progress tracking
- Reviewers see logical progression

## Outputs

**Primary deliverable:**
- Working implementation (all tests GREEN)
- Clean, maintainable code
- Following project patterns

**Verification:**
- All tests passing
- No test modifications (unless approved)
- Code follows GUIDELINES.md
- No GUIDELINES.md violations
- No new linter warnings

## Best Practices

**Make minimal changes to pass tests:**
```python
# ✓ Good: Implements exactly what test requires
def withdraw(self, amount: float) -> None:
    if amount > self.balance:
        raise InsufficientFundsError()
    self.balance -= amount

# ❌ Over-engineered: Adds features not in tests
def withdraw(self, amount: float, fee_calculator: FeeCalculator = None) -> Transaction:
    # Fee calculation not in tests
    # Transaction return not in tests
    # Adds complexity beyond requirements
```

**Keep implementation simple:**
```python
# ✓ Good: Clear and direct
def calculate_total(items: List[Item]) -> float:
    return sum(item.price for item in items)

# ❌ Unnecessarily complex
def calculate_total(items: List[Item]) -> float:
    total = 0.0
    for i in range(len(items)):
        total = total + items[i].price
    return total
```

**Follow existing patterns:**
```python
# Check how similar features are implemented
# Match their structure, naming, organization
# Use same utilities and helpers
# Maintain consistency
```

**Use good names:**
```python
# ✓ Good: Clear intent
def send_welcome_email(user: User) -> None:
    template = self.templates.get("welcome")
    self.mailer.send(user.email, template.render(user=user))

# ❌ Bad: Unclear
def process(u):
    t = self.templates.get("welcome")
    self.m.send(u.e, t.render(user=u))
```

## Common Issues

**❌ Modifying tests to make them pass**
- Tests are the contract
- If test seems wrong, flag for review
- Don't change tests without approval

**❌ Over-engineering**
- Add only what tests require
- YAGNI (You Aren't Gonna Need It)
- Simple solutions first

**❌ Ignoring architectural rules**
- Check GUIDELINES.md before deviating
- Follow established patterns
- Ask before violating constraints

**❌ Not running tests frequently**
- Run after each small change
- Catch breaks immediately
- Faster feedback loop

**❌ Premature optimization**
- Make it work (GREEN)
- Make it right (REFACTOR)
- Make it fast (only if needed)

**Most critical:** Tests define the contract. If tests and spec conflict, flag for review. Never modify tests to make implementation easier.

## Examples

### Example 1: Simple Implementation

**Test (RED):**
```python
def test_calculate_discount_for_premium_user():
    calculator = PriceCalculator()
    assert calculator.calculate_discount(100, is_premium=True) == 20
```

**Implementation (GREEN):**
```python
def calculate_discount(self, price: float, is_premium: bool) -> float:
    """Calculate discount amount."""
    if is_premium:
        return price * 0.20  # 20% discount
    return 0.0
```

**Tests pass? ✓ Done.**

### Example 2: With Dependencies

**Test (RED):**
```python
def test_register_user_saves_to_repository():
    repo = Mock(spec=UserRepository)
    service = UserService(repo=repo)
    
    user = service.register("alice@example.com", "password")
    
    repo.save.assert_called_once()
```

**Implementation (GREEN):**
```python
def register(self, email: str, password: str) -> User:
    """Register new user."""
    # Create user object
    user = User(
        email=email,
        password_hash=self.hasher.hash(password)
    )
    
    # Save via repository
    saved_user = self.repo.save(user)
    
    return saved_user
```

### Example 3: Error Handling

**Test (RED):**
```python
def test_register_duplicate_email_raises_error():
    repo = Mock(spec=UserRepository)
    repo.get_by_email.return_value = User(email="exists@example.com")
    service = UserService(repo=repo)
    
    with pytest.raises(DuplicateEmailError):
        service.register("exists@example.com", "password")
```

**Implementation (GREEN):**
```python
def register(self, email: str, password: str) -> User:
    """Register new user."""
    # Check if email exists
    existing = self.repo.get_by_email(email)
    if existing:
        raise DuplicateEmailError(email)
    
    # Create and save user
    user = User(email=email, password_hash=self.hasher.hash(password))
    return self.repo.save(user)
```

### Example 4: Test Conflict (DO NOT MODIFY TEST)

**Situation:** Test expects `ValueError` but spec says `ValidationError`.

**❌ Wrong approach:**
```python
# Don't modify test to match your implementation!
# Don't change ValidationError to ValueError!
```

**✓ Correct approach:**
```markdown
## Test Issue: Exception Type Mismatch

**Test:** test_register_invalid_email_raises_error
**Line:** tests/test_user.py:45
**Problem:** Test expects ValueError but spec says ValidationError
**Evidence:** Spec section 3.2: "Raises ValidationError if email invalid"

**Status:** Blocked - cannot implement until test corrected
**Action Needed:** Test re-review to fix exception type
```

## Bug Fix Process (Alternative Workflow)

When fixing bugs (instead of implementing features from specs), use this lighter-weight process.

### Triggered By: Bug report in bugs/to_fix/

**Bug fixes skip:** Spec phase, skeleton phase, test writer phase  
**Bug fixes include:** Direct fix + sentinel test + lighter review

### Process

1. **Move bug report to bugs/fixing/**
   ```bash
   git mv bugs/to_fix/validation-empty-email.md bugs/fixing/
   git commit -m "bugs: start fixing validation-empty-email"
   ```

2. **Create bugfix branch**
   ```bash
   git checkout -b bugfix/validation-empty-email
   ```

3. **Read bug report thoroughly**
   - Understand observed vs expected behavior
   - Study reproduction steps
   - Note severity and impact

4. **Investigate and add Root Cause**
   Edit bug report in `bugs/fixing/`:
   ```markdown
   ## Root Cause
   Email validation in src/utils/validation.py checked for @-symbol 
   before checking for empty string. Empty string bypassed the check.
   
   Problematic code:
   \```python
   if "@" not in email:
       return (False, "Invalid format")
   # Empty string has no @ so check fails incorrectly
   \```
   ```

5. **Fix the bug**
   - Make minimal changes to fix the issue
   - Follow GUIDELINES.md patterns
   - Respect SYSTEM_MAP.md architecture
   - Don't add features beyond fixing the bug

6. **Add sentinel test**
   Create `tests/regression/test_<component>_<description>.py`:
   
   ```python
   """
   Regression test for bug: Empty email passes validation
   
   Bug report: bugs/fixing/validation-empty-email.md
   Discovered: 2025-10-23
   
   ISSUE:
   Empty string passed email validation, causing database constraint
   violation downstream.
   
   ROOT CAUSE:
   Validation checked format (@-symbol) before checking for empty string.
   
   FIX:
   Added empty string check as first validation step.
   
   This sentinel test ensures the bug cannot recur.
   """
   
   def test_validation_empty_email():
       """Empty email should be rejected with clear error."""
       is_valid, error = validate_email("")
       
       assert is_valid is False
       assert "empty" in error.lower()
   ```

7. **Verify sentinel test works**
   ```bash
   # Test should FAIL on old code (before fix)
   git stash  # Temporarily remove fix
   pytest tests/regression/test_validation_empty_email.py  # Should FAIL
   git stash pop  # Restore fix
   
   # Test should PASS on new code (after fix)
   pytest tests/regression/test_validation_empty_email.py  # Should PASS
   ```

8. **Update bug report with Fix section**
   Edit bug report in `bugs/fixing/`:
   ```markdown
   ## Fix
   Added empty string check as first validation step before format checks.
   
   **Changes:**
   - src/utils/validation.py: Added empty check at function entry
   - tests/regression/test_validation_empty_email.py: Sentinel test added
   - GUIDELINES.md: Added "Validate empty/null inputs first" pattern
   
   **Commit:** (will add after commit)
   **Sentinel test:** tests/regression/test_validation_empty_email.py
   
   **Verification:**
   - Sentinel test fails on old code ✓
   - Sentinel test passes on new code ✓
   - All other tests still pass ✓
   ```

9. **Update GUIDELINES.md (if bug reveals pattern)**
   Only if bug represents a pattern worth documenting:
   
   ```markdown
   ## Validation Patterns
   
   ### Validate Empty/Null First
   ✓ Check for empty/null before format validation
   ❌ Don't check format on potentially empty input
   
   Example:
   \```python
   # ✓ Good: Check empty first
   def validate_email(email: str) -> tuple[bool, Optional[str]]:
       if not email:  # Empty check first
           return (False, "Email cannot be empty")
       if "@" not in email:
           return (False, "Invalid email format")
   
   # ❌ Bad: Format check on empty input
   def validate_email(email: str) -> tuple[bool, Optional[str]]:
       if "@" not in email:  # Crashes on empty!
           return (False, "Invalid email format")
   \```
   
   **Why:** Empty input checks prevent confusing errors and crashes.
   
   **Related bug:** bugs/fixed/validation-empty-email.md
   ```

10. **Commit with clear message**
    ```bash
    git add src/utils/validation.py tests/regression/ bugs/fixing/ GUIDELINES.md
    git commit -m "fix: reject empty emails in validation
    
    Bug: Empty strings passed validation causing DB errors
    Root cause: Checked format before empty
    
    - Added empty string check as first validation
    - Sentinel test: tests/regression/test_validation_empty_email.py
    - Updated GUIDELINES: validate empty/null first
    
    Fixes: bugs/fixing/validation-empty-email.md"
    ```

11. **Update bug report with commit hash**
    After committing, update Fix section:
    ```markdown
    **Commit:** abc123def456
    ```

12. **Mark ready for review**
    Bug fix is ready when:
    - Bug report has Root Cause section
    - Bug report has Fix section with commit reference
    - Sentinel test exists and passes
    - GUIDELINES.md updated if pattern emerged
    - All other tests still pass

### Bug Fix vs Feature Implementation

**Bug fixes are simpler:**
- No spec phase (bug report instead)
- No skeleton phase (code structure exists)
- No test writer (you write sentinel test)
- No test reviewer (implementation reviewer checks sentinel)
- Lighter weight overall

**Bug fixes still require:**
- Investigation (root cause analysis)
- Quality fix (not just patching symptoms)
- Sentinel test (prevent recurrence)
- Documentation (GUIDELINES.md if pattern)
- Review (implementation reviewer)

## Integration with Workflow

This role fits in the workflow as follows:
- **Receives:** Approved tests (RED), skeleton code, SPEC from specs/doing/
- **Produces:** Working implementation (all tests GREEN) on feature branch
- **Next roles:** Implementation Reviewer
- **Note:** TDD GREEN phase - make tests pass without modifying them

**To understand where this role fits:** See [workflow-overview.md](workflow-overview.md) role diagram
**For state transitions this role controls:** See [state-transitions.md](state-transitions.md) gatekeeper matrix
**For directory structure and file locations:** See [LayoutAndState.md](LayoutAndState.md)
