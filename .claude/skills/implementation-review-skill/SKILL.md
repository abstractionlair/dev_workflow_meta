---
name: implementation-review
description: Guide for reviewing implementations in a test-driven development workflow. Use when implementation is complete and tests pass, to verify spec compliance, code quality, security, performance, and maintainability before merge. Supports Python and TypeScript with language-agnostic principles.
license: Complete terms in LICENSE.txt
---

# Implementation Review

This skill provides systematic guidance for reviewing implementations after tests pass, ensuring code meets specifications, maintains quality, and is ready for production.

## Review Philosophy

**Goal:** Verify implementation is correct, secure, maintainable, and ready for merge.

**When to review:** After implementation is complete and all tests pass (TDD "Green" phase complete, before or during "Refactor").

**Why review:** Passing tests don't guarantee good code. Reviews catch issues tests miss and ensure long-term maintainability.

## Workflow Position

```
Spec → Interface → Tests → Implementation → REVIEW (THIS SKILL) → Merge
                                             ↑
                                    Final quality gate
```

## Systematic Review Process

Follow this 9-step checklist in order:

### 1. Spec Compliance Verification

**Check:** Does implementation satisfy the specification?

**Questions:**
- Are all acceptance criteria met?
- Are all specified behaviors implemented?
- Are error conditions handled as specified?
- Are edge cases covered as specified?
- Are performance requirements met?

**Method:**
```
For each spec requirement:
  1. Find corresponding implementation code
  2. Verify behavior matches specification
  3. Check test exists and passes
  4. Flag any discrepancies
```

**Example review:**

**Spec says:**
```
Transfer money between accounts:
- Success: Sender balance decreased, receiver increased
- Error: InsufficientFundsError if sender balance < amount
- Performance: Complete within 200ms
```

**Implementation:**
```python
def transfer(self, sender_id: int, receiver_id: int, amount: float) -> Transaction:
    sender = self.repository.find_by_id(sender_id)
    receiver = self.repository.find_by_id(receiver_id)
    
    if sender.balance < amount:
        raise InsufficientFundsError(f"Balance {sender.balance} < {amount}")
    
    sender.balance -= amount
    receiver.balance += amount
    
    self.repository.update(sender)
    self.repository.update(receiver)
    
    return Transaction(sender_id, receiver_id, amount, datetime.now())
```

**Review feedback:**
```
✅ Spec Compliance:
  - Sender balance decreased ✓
  - Receiver balance increased ✓
  - InsufficientFundsError raised correctly ✓
  
❌ Missing from spec:
  - No AccountNotFoundError if IDs invalid (spec required)
  - No ValidationError if amount <= 0 (spec required)
  - No performance verification possible (needs profiling)
  
Action: Add missing error checks per spec
```

### 2. Test Coverage Verification

**Check:** Are all code paths tested? Any untested behavior?

**Questions:**
- Does every public method have tests?
- Are all branches (if/else) tested?
- Are all error paths tested?
- Any code that can't fail if tests pass?
- Coverage gaps?

**Method:**
```
1. Review test file alongside implementation
2. For each method, verify tests exist
3. For each branch, verify test covers it
4. For each error raise, verify test expects it
5. Check coverage report if available
```

**Example:**

**Implementation:**
```python
def withdraw(self, amount: float) -> None:
    if amount <= 0:  # Branch 1
        raise ValueError("Amount must be positive")
    
    if self.balance < amount:  # Branch 2
        raise InsufficientFundsError("Insufficient funds")
    
    self.balance -= amount  # Happy path
```

**Test file review:**
```python
def test_withdraw_with_sufficient_funds():  # ✓ Happy path
    account = Account(100)
    account.withdraw(30)
    assert account.balance == 70

def test_withdraw_insufficient_funds():  # ✓ Branch 2
    account = Account(50)
    with pytest.raises(InsufficientFundsError):
        account.withdraw(60)

# ❌ Missing: Branch 1 test (amount <= 0)
```

**Review feedback:**
```
⚠️  Test Coverage Gap:
  - Missing test for amount <= 0 (ValueError path)
  - Add: test_withdraw_negative_amount_raises_error
  - Add: test_withdraw_zero_amount_raises_error
  
✅ Otherwise complete coverage
```

### 3. Code Quality Assessment

**Check:** Is code readable, maintainable, and well-structured?

**Criteria:**
- **Readability:** Can another developer understand quickly?
- **Naming:** Are names clear and descriptive?
- **Function length:** Under 50 lines? (guideline, not rule)
- **Complexity:** Is logic straightforward?
- **DRY:** Is code duplicated?
- **Comments:** Necessary comments present, no obvious comments?

**Good code example:**
```python
def calculate_discount(self, order: Order) -> float:
    """Calculate discount based on customer loyalty tier.
    
    Returns discount amount (not percentage).
    """
    base_amount = order.total()
    discount_rate = self._get_loyalty_discount_rate(order.customer)
    
    return base_amount * discount_rate

def _get_loyalty_discount_rate(self, customer: Customer) -> float:
    """Get discount rate based on loyalty tier."""
    tier_rates = {
        'bronze': 0.05,
        'silver': 0.10,
        'gold': 0.15,
    }
    return tier_rates.get(customer.loyalty_tier, 0.0)
```

**Poor code example:**
```python
def calc(o):  # ❌ Unclear name, unclear parameter
    # ❌ No docstring
    amt = o.tot()  # ❌ Abbreviated variable
    if o.c.lt == 'b':  # ❌ Magic string, unclear
        d = amt * 0.05
    elif o.c.lt == 's':
        d = amt * 0.10
    elif o.c.lt == 'g':
        d = amt * 0.15
    else:
        d = 0
    return d  # ❌ Unclear what's returned
```

**Review feedback format:**
```
Code Quality Issues:

❌ calc method:
  - Rename to: calculate_discount
  - Add type hints: (order: Order) -> float
  - Add docstring explaining return value
  - Use descriptive variable names (amount, discount_rate)
  - Extract tier logic to separate method
  - Replace magic strings with constants or enum

💡 Suggestion:
  Consider using enum for loyalty tiers instead of strings
```

### 4. Code Smell Detection

**Check:** Are there common anti-patterns or design issues?

**Common smells to detect:**

**Long Method (>50 lines):**
```python
# ❌ Too long, doing too much
def process_order(self, order):
    # 100 lines of validation, calculation, database updates, 
    # email sending, logging...
```

**Fix:** Extract into smaller methods with single responsibilities.

**God Class (>500 lines or >10 public methods):**
```python
# ❌ Doing too much
class OrderManager:
    def create_order(self): ...
    def cancel_order(self): ...
    def calculate_shipping(self): ...
    def send_confirmation_email(self): ...
    def process_payment(self): ...
    def update_inventory(self): ...
    def generate_invoice(self): ...
    # 20 more methods...
```

**Fix:** Split into focused classes (OrderService, ShippingCalculator, EmailNotifier, etc.).

**Primitive Obsession:**
```python
# ❌ Using primitives for domain concepts
def create_user(email: str, age: int, country_code: str) -> User:
    # Logic with raw strings and ints
```

**Fix:** Use value objects:
```python
# ✅ Value objects for domain concepts
def create_user(email: Email, age: Age, country: Country) -> User:
    # Type safety and validation encapsulated
```

**Feature Envy:**
```python
# ❌ Method uses another object's data more than its own
def calculate_shipping(self, order: Order) -> float:
    weight = order.items.total_weight()
    destination = order.shipping_address.country
    priority = order.shipping_method.priority
    # Uses 'order' extensively, nothing from 'self'
```

**Fix:** Move method to Order class or make it a standalone function.

**Data Clumps:**
```python
# ❌ Same group of parameters appear together
def create_address(street: str, city: str, state: str, zip: str): ...
def validate_address(street: str, city: str, state: str, zip: str): ...
def format_address(street: str, city: str, state: str, zip: str): ...
```

**Fix:** Create Address class.

**See references/code-smells.md for complete catalog.**

### 5. Security Review

**Check:** Are there common security vulnerabilities?

**Critical security checks:**

**SQL Injection:**
```python
# ❌ Vulnerable
def get_user(self, user_id: str):
    query = f"SELECT * FROM users WHERE id = {user_id}"
    return self.db.execute(query)

# ✅ Safe - parameterized query
def get_user(self, user_id: str):
    query = "SELECT * FROM users WHERE id = ?"
    return self.db.execute(query, (user_id,))
```

**XSS (Cross-Site Scripting):**
```python
# ❌ Vulnerable - no escaping
def render_comment(comment: str) -> str:
    return f"<div>{comment}</div>"

# ✅ Safe - escaped
def render_comment(comment: str) -> str:
    from html import escape
    return f"<div>{escape(comment)}</div>"
```

**Path Traversal:**
```python
# ❌ Vulnerable
def read_file(self, filename: str):
    return open(f"/uploads/{filename}").read()
    # User could pass "../../etc/passwd"

# ✅ Safe - validate path
def read_file(self, filename: str):
    from pathlib import Path
    base = Path("/uploads")
    file_path = (base / filename).resolve()
    if not file_path.is_relative_to(base):
        raise ValueError("Invalid path")
    return file_path.read_text()
```

**Hardcoded Secrets:**
```python
# ❌ Hardcoded
API_KEY = "sk-1234567890abcdef"

# ✅ Environment variable
import os
API_KEY = os.environ.get("API_KEY")
```

**Insecure Randomness:**
```python
# ❌ Predictable
import random
token = ''.join(random.choices(string.ascii_letters, k=32))

# ✅ Cryptographically secure
import secrets
token = secrets.token_urlsafe(32)
```

**Authentication/Authorization:**
```python
# ❌ Missing authorization check
def delete_user(self, user_id: int):
    self.db.delete(user_id)

# ✅ Authorization checked
def delete_user(self, user_id: int, requesting_user: User):
    if not requesting_user.is_admin:
        raise UnauthorizedError("Admin access required")
    self.db.delete(user_id)
```

**See references/security-checklist.md for comprehensive list.**

### 6. Performance Review

**Check:** Are there obvious performance issues?

**Common issues to catch:**

**N+1 Query Problem:**
```python
# ❌ N+1 queries (1 + N database calls)
def get_users_with_orders(self):
    users = self.db.query(User).all()  # 1 query
    for user in users:
        user.orders = self.db.query(Order).filter_by(user_id=user.id).all()  # N queries
    return users

# ✅ Single query with join
def get_users_with_orders(self):
    return self.db.query(User).options(joinedload(User.orders)).all()  # 1 query
```

**Inefficient Loops:**
```python
# ❌ O(n²) - quadratic
def find_duplicates(items: list[int]) -> list[int]:
    duplicates = []
    for i in items:
        for j in items:
            if i == j and i not in duplicates:
                duplicates.append(i)
    return duplicates

# ✅ O(n) - linear with set
def find_duplicates(items: list[int]) -> list[int]:
    seen = set()
    duplicates = set()
    for item in items:
        if item in seen:
            duplicates.add(item)
        seen.add(item)
    return list(duplicates)
```

**Memory Leaks:**
```python
# ❌ Loads entire file into memory
def process_large_file(filename: str):
    data = open(filename).read()  # Could be gigabytes
    return process(data)

# ✅ Streams file
def process_large_file(filename: str):
    with open(filename) as f:
        for line in f:  # Process one line at a time
            process(line)
```

**Unnecessary Computation:**
```python
# ❌ Recalculates in loop
def calculate_totals(orders: list[Order]):
    tax_rate = get_tax_rate()  # Expensive calculation
    for order in orders:
        order.total = order.subtotal * (1 + tax_rate)

# ✅ Calculate once
def calculate_totals(orders: list[Order]):
    tax_rate = get_tax_rate()  # Once before loop
    for order in orders:
        order.total = order.subtotal * (1 + tax_rate)
```

**Note:** Only flag *obvious* performance issues. Premature optimization is the root of all evil. Focus on algorithmic complexity and clear inefficiencies.

### 7. Error Handling Completeness

**Check:** Are errors handled appropriately?

**Questions:**
- Are exceptions specific (not bare `except:`)?
- Are errors logged appropriately?
- Do error messages help debugging?
- Are resources cleaned up (files, connections)?
- Are errors propagated or handled at right level?

**Good error handling:**
```python
def process_payment(self, order: Order) -> PaymentResult:
    """Process payment for order.
    
    Raises:
        PaymentDeclinedError: If payment declined by processor
        NetworkError: If unable to reach payment processor
        ValidationError: If order data invalid
    """
    try:
        self._validate_order(order)
        result = self.payment_gateway.charge(
            amount=order.total,
            card=order.payment_method
        )
        self.logger.info(f"Payment processed: order={order.id}, amount={order.total}")
        return result
        
    except InvalidCardError as e:
        self.logger.warning(f"Invalid card for order {order.id}: {e}")
        raise PaymentDeclinedError(f"Card declined: {e.message}") from e
        
    except ConnectionError as e:
        self.logger.error(f"Payment gateway unreachable for order {order.id}: {e}")
        raise NetworkError("Unable to process payment, please retry") from e
        
    except Exception as e:
        self.logger.error(f"Unexpected payment error for order {order.id}: {e}", exc_info=True)
        raise
```

**Poor error handling:**
```python
def process_payment(self, order):
    try:
        # ... logic ...
    except:  # ❌ Bare except catches everything
        return None  # ❌ Silent failure
```

**Review checklist:**
- ✓ Specific exceptions caught
- ✓ Logged with context
- ✓ Clear error messages
- ✓ Exceptions chained (`from e`)
- ✓ Documented in docstring

### 8. Documentation Completeness

**Check:** Is code properly documented?

**What needs documentation:**

**Public APIs - Always:**
```python
def transfer_money(
    self, 
    sender_id: int, 
    receiver_id: int, 
    amount: float
) -> Transaction:
    """Transfer money between accounts.
    
    Transfers the specified amount from sender to receiver account.
    This operation is atomic - either both accounts are updated or
    neither is updated.
    
    Args:
        sender_id: ID of sender account
        receiver_id: ID of receiver account
        amount: Amount to transfer (must be positive)
        
    Returns:
        Transaction record with timestamp and IDs
        
    Raises:
        InsufficientFundsError: If sender lacks sufficient funds
        AccountNotFoundError: If sender or receiver ID invalid
        ValidationError: If amount <= 0 or sender == receiver
        
    Example:
        >>> service.transfer_money(sender_id=1, receiver_id=2, amount=50.0)
        Transaction(sender=1, receiver=2, amount=50.0, timestamp=...)
    """
```

**Complex algorithms - Explain why:**
```python
def _calculate_optimal_route(self, graph: Graph) -> list[Node]:
    """Find optimal route using Dijkstra's algorithm.
    
    We use Dijkstra's instead of A* because:
    1. Graph is dense (edges > nodes * log(nodes))
    2. No good heuristic available for our domain
    3. Dijkstra's guarantees shortest path
    
    Time complexity: O(V² + E log V) with binary heap
    """
```

**Non-obvious code - Add comments:**
```python
# Sort by priority first, then timestamp (stable sort maintains order)
tasks.sort(key=lambda t: t.timestamp)
tasks.sort(key=lambda t: t.priority, reverse=True)
```

**Don't document obvious code:**
```python
# ❌ Obvious comment
# Increment counter by 1
counter += 1

# ❌ Just repeating code
# Set username to provided username
self.username = username
```

### 9. Language-Specific Best Practices

**Check:** Does code follow language idioms and conventions?

### Python Best Practices

**Use context managers:**
```python
# ❌ Manual resource management
file = open("data.txt")
data = file.read()
file.close()

# ✅ Context manager
with open("data.txt") as file:
    data = file.read()
```

**Use comprehensions when clear:**
```python
# ❌ Verbose
squares = []
for i in range(10):
    squares.append(i ** 2)

# ✅ Pythonic
squares = [i ** 2 for i in range(10)]
```

**Use type hints:**
```python
# ❌ No type information
def calculate(data, rate):
    return data * rate

# ✅ Type hints
def calculate(data: list[float], rate: float) -> list[float]:
    return [x * rate for x in data]
```

**Use dataclasses for data:**
```python
# ❌ Manual __init__
class User:
    def __init__(self, id: int, name: str, email: str):
        self.id = id
        self.name = name
        self.email = email

# ✅ Dataclass
from dataclasses import dataclass

@dataclass
class User:
    id: int
    name: str
    email: str
```

**Use enums instead of strings:**
```python
# ❌ Magic strings
if user.status == "active":
    ...

# ✅ Enum
from enum import Enum

class UserStatus(Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"
    BANNED = "banned"

if user.status == UserStatus.ACTIVE:
    ...
```

### TypeScript Best Practices

**Use proper types, not 'any':**
```typescript
// ❌ Loses type safety
function process(data: any): any {
    return data.value;
}

// ✅ Specific types
function process(data: { value: number }): number {
    return data.value;
}
```

**Use readonly for immutability:**
```typescript
// ❌ Mutable
interface User {
    id: number;
    name: string;
}

// ✅ Immutable
interface User {
    readonly id: number;
    readonly name: string;
}
```

**Use const assertions:**
```typescript
// ❌ Mutable array
const colors = ['red', 'green', 'blue'];

// ✅ Readonly tuple
const colors = ['red', 'green', 'blue'] as const;
```

**Use optional chaining:**
```typescript
// ❌ Manual null checking
const country = user && user.address && user.address.country;

// ✅ Optional chaining
const country = user?.address?.country;
```

**Use nullish coalescing:**
```typescript
// ❌ Falsy values treated as null
const value = input || defaultValue; // 0, '', false become defaultValue

// ✅ Only null/undefined use default
const value = input ?? defaultValue;
```

## Review Output Structure

**Format reviews consistently:**

```
═══════════════════════════════════════════════════════
IMPLEMENTATION REVIEW: [Module/Class Name]
═══════════════════════════════════════════════════════

SUMMARY:
[2-3 line overall assessment]
Ready for merge: YES/NO/WITH CHANGES

CRITICAL ISSUES (must fix before merge):
❌ [Issue 1]
   Impact: [Why this is critical]
   Fix: [Specific action needed]

❌ [Issue 2]
   ...

IMPORTANT ISSUES (should fix):
⚠️  [Issue 1]
   Problem: [What's wrong]
   Fix: [How to fix]

⚠️  [Issue 2]
   ...

SUGGESTIONS (nice to have):
💡 [Suggestion 1]
   Benefit: [Why this would improve code]

💡 [Suggestion 2]
   ...

POSITIVE NOTES:
✅ [Good practice 1]
✅ [Good practice 2]
✅ [Good practice 3]

CHECKLIST:
✅ Spec compliance verified
✅ Test coverage complete
✅ Code quality acceptable
✅ No code smells detected
✅ Security reviewed
✅ Performance acceptable
✅ Error handling complete
✅ Documentation sufficient
✅ Language best practices followed

RECOMMENDATION: [MERGE / FIX CRITICAL / NEEDS WORK]
```

## Example Complete Review

**Implementation:**
```python
class UserService:
    def __init__(self, db):
        self.db = db
    
    def register(self, email, password):
        if self.db.find_by_email(email):
            raise Exception("Email exists")
        
        user = User(email=email, password=password)
        self.db.save(user)
        return user.id
```

**Review:**
```
═══════════════════════════════════════════════════════
IMPLEMENTATION REVIEW: UserService.register
═══════════════════════════════════════════════════════

SUMMARY:
Basic functionality present but critical security issues and missing spec
requirements. NOT ready for merge without fixes.

Ready for merge: NO

CRITICAL ISSUES (must fix before merge):
❌ Password stored in plaintext
   Impact: Massive security vulnerability - passwords exposed in data breach
   Fix: Hash password with bcrypt before storage:
   
   import bcrypt
   password_hash = bcrypt.hashpw(password.encode(), bcrypt.gensalt())
   user = User(email=email, password_hash=password_hash)

❌ No email validation
   Impact: Invalid emails accepted, spec violation
   Fix: Validate email format per spec:
   
   if not self._is_valid_email(email):
       raise ValidationError("Invalid email format")

❌ Generic Exception instead of specific error
   Impact: Hard to handle errors properly in calling code
   Fix: Use specific exception per spec:
   
   raise DuplicateEmailError(f"Email already registered: {email}")

IMPORTANT ISSUES (should fix):
⚠️  Missing type hints
   Problem: No IDE support, unclear contracts
   Fix: Add type hints to method signature:
   
   def register(self, email: str, password: str) -> int:

⚠️  No password strength validation
   Problem: Weak passwords accepted (spec requires 8+ chars)
   Fix: Add validation per spec:
   
   if len(password) < 8:
       raise ValidationError("Password must be at least 8 characters")

⚠️  No logging
   Problem: Can't debug issues or track registrations
   Fix: Add logging:
   
   self.logger.info(f"User registered: {email}")

⚠️  Database dependency not injected properly
   Problem: Hard to test, tight coupling
   Fix: Add type hint and proper interface:
   
   def __init__(self, db: UserRepository):

SUGGESTIONS (nice to have):
💡 Add docstring
   Benefit: Clearer API documentation for other developers

💡 Send welcome email after registration
   Benefit: Better user experience (may be in spec - verify)

💡 Return User object instead of just ID
   Benefit: Caller has access to full user data without extra query

POSITIVE NOTES:
✅ Checks for duplicate email before creating user
✅ Returns user ID for caller to use
✅ Simple, focused method doing one thing

CHECKLIST:
❌ Spec compliance verified - Missing password validation
❌ Test coverage complete - No tests provided for review
⚠️  Code quality acceptable - Missing types and docs
✅ No code smells detected
❌ Security reviewed - PASSWORD STORED IN PLAINTEXT
✅ Performance acceptable
⚠️  Error handling complete - Wrong exception type
⚠️  Documentation sufficient - No docstring
⚠️  Language best practices followed - Missing type hints

RECOMMENDATION: NEEDS WORK
Must fix critical security issue before any merge.
```

## Integration with TDD Workflow

**When to use this skill:**
1. After implementation complete
2. After all tests pass
3. Before merge/pull request
4. As final quality gate

**Typical flow:**
```
Implement → Tests pass → Review (THIS SKILL) → Fix issues → Tests still pass → Merge
```

## Quick Review Checklist

Use for fast reviews:

```
Spec Compliance:
□ All acceptance criteria met
□ All behaviors implemented
□ All error conditions handled
□ Edge cases covered
□ Performance requirements met

Test Coverage:
□ All public methods tested
□ All branches tested
□ All error paths tested
□ No untested code paths

Code Quality:
□ Code is readable
□ Names are clear
□ Functions are focused (<50 lines)
□ No duplication
□ Appropriate comments

Security:
□ No SQL injection risk
□ No XSS risk
□ No path traversal risk
□ No hardcoded secrets
□ Authorization checked

Performance:
□ No N+1 queries
□ No quadratic algorithms
□ No memory leaks
□ Reasonable complexity

Error Handling:
□ Specific exceptions
□ Proper logging
□ Clear error messages
□ Resources cleaned up

Documentation:
□ Public APIs documented
□ Complex logic explained
□ Docstrings present

Language Best Practices:
□ Follows language idioms
□ Uses appropriate patterns
□ Type hints present (Python/TS)
```

## Common Review Patterns

**Pattern: "Passes tests but wrong implementation"**
```python
# Test expects list of even numbers
def test_get_even_numbers():
    assert get_even_numbers([1, 2, 3, 4]) == [2, 4]

# ❌ Passes test but wrong
def get_even_numbers(numbers):
    return [2, 4]  # Hardcoded!

# Catch this in spec compliance check
```

**Pattern: "Works but insecure"**
```python
# ❌ Works, tests pass, but SQL injection vulnerability
def get_user(self, email):
    return self.db.execute(f"SELECT * FROM users WHERE email = '{email}'")

# Catch this in security review
```

**Pattern: "Correct but inefficient"**
```python
# ❌ Works, tests pass, but O(n²)
def has_duplicates(items):
    for i in range(len(items)):
        for j in range(i + 1, len(items)):
            if items[i] == items[j]:
                return True
    return False

# Catch this in performance review
```

## Additional Resources

For detailed guidance:
- **Code smells catalog**: references/code-smells.md
- **Security checklist**: references/security-checklist.md
- **Performance patterns**: references/performance-patterns.md

## Key Principles

1. **Tests passing ≠ good code** - Reviews catch what tests miss
2. **Security is not optional** - Always review for vulnerabilities
3. **Spec compliance first** - Does it do what was asked?
4. **Maintainability matters** - Code is read more than written
5. **Be specific** - "Fix this" not "improve code"
6. **Balance** - Don't let perfect be enemy of good
7. **Positive feedback** - Reinforce good practices
8. **Final gate** - Last chance before production

## When NOT to Review

**Skip review if:**
- Code is throwaway prototype
- Spike/experiment (not production)
- Tests are the implementation (property-based testing library)

**Always review:**
- Production code
- Library/framework code
- Code that handles user data
- Code that handles money/payments
- Security-sensitive code
