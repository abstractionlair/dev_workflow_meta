---
name: interface-design-tdd
description: Guide for designing testable specifications and interface skeletons in test-driven development. Use when users need to translate requirements into testable specs, create interface skeletons before tests, design for dependency injection, or ensure interfaces enable easy testing. Covers specification writing, interface design principles, and language-specific patterns for Python and TypeScript.
license: Complete terms in LICENSE.txt
---

# Interface Design for TDD

This skill guides the design of testable specifications and interface skeletons that enable effective test-driven development. Use before writing tests to ensure your design supports testability.

## Overview

**Goal:** Create specifications and interfaces that make testing straightforward, not an afterthought.

**Workflow position:**
```
Requirement → Specification → Interface Skeleton → Tests → Implementation
              ↑______________ THIS SKILL ______________↑
```

**Key principle:** Design decisions made during specification and skeleton phases determine how easy or hard testing will be.

## Part 1: Writing Testable Specifications

Specifications define **what** to build. Good specs lead to clear tests and implementations.

### Characteristics of Testable Specifications

**1. Behavior-focused (not implementation-focused)**

```
❌ Bad (implementation-focused):
"The system shall use a HashMap to store user data with email as key"

✅ Good (behavior-focused):
"The system shall retrieve user data by email address in O(1) time"
```

Why better: Tests verify behavior (can retrieve by email), not implementation (doesn't test HashMap specifically).

**2. Observable and verifiable**

```
❌ Bad (not observable):
"The system shall be user-friendly"

✅ Good (observable):
"The system shall display validation errors within 100ms of invalid input"
```

Why better: Can write concrete test that measures response time.

**3. Includes acceptance criteria**

```
❌ Bad (vague):
"Support user registration"

✅ Good (clear criteria):
"User registration shall:
- Accept email and password
- Validate email format (user@domain.tld)
- Require password minimum 8 characters
- Return unique user ID on success
- Raise DuplicateEmailError if email exists
- Raise ValidationError for invalid input"
```

Why better: Each criterion becomes a test case.

**4. Specifies error conditions**

```
❌ Bad (only happy path):
"Transfer money between accounts"

✅ Good (includes errors):
"Transfer money between accounts:
- Success: Decreases sender balance, increases receiver balance
- Error: InsufficientFundsError if sender balance < amount
- Error: ValidationError if amount <= 0
- Error: AccountNotFoundError if sender or receiver invalid"
```

Why better: Error tests are explicit, not discovered later.

**5. Defines boundaries and edge cases**

```
❌ Bad (no boundaries):
"Validate age input"

✅ Good (boundaries specified):
"Age validation:
- Accept: 0 to 150 (inclusive)
- Reject: Negative numbers
- Reject: Numbers > 150
- Reject: Non-integer values
- Boundary: 0 is valid (newborn)
- Boundary: 150 is valid (upper realistic limit)"
```

Why better: Boundaries are explicit, tests cover them systematically.

### Specification Template

Use this template for testable specs:

```
Feature: [Name]

Purpose: [Why this exists]

Behavior:
- Given [precondition]
- When [action]
- Then [expected result]

Acceptance Criteria:
1. [Happy path criteria]
2. [Edge case criteria]
3. [Error case criteria]

Error Conditions:
- [Error type]: [When it occurs] → [Expected behavior]

Constraints:
- Performance: [Requirements]
- Boundaries: [Valid input ranges]

Examples:
- Input: [Example] → Output: [Example]
- Input: [Edge case] → Output: [Result]
- Input: [Invalid] → Error: [Type]
```

### Complete Specification Example

```
Feature: Bank Account Withdrawal

Purpose: Allow users to withdraw money from their account

Behavior:
- Given an account with a balance
- When user withdraws an amount
- Then balance decreases by that amount

Acceptance Criteria:
1. Withdrawal with sufficient funds decreases balance by withdrawn amount
2. Withdrawal returns remaining balance
3. Withdrawal with exact balance results in zero balance
4. Multiple consecutive withdrawals work correctly
5. Withdrawal amount must be positive
6. Withdrawal cannot exceed available balance

Error Conditions:
- InsufficientFundsError: When withdrawal > balance → Balance unchanged
- ValidationError: When amount <= 0 → Balance unchanged
- ValidationError: When amount is not a number → Balance unchanged

Constraints:
- Performance: Complete within 100ms
- Boundaries: Amount must be 0.01 to 1,000,000 (inclusive)
- Precision: Handle cents (2 decimal places)

Examples:
- Balance: 100, Withdraw: 30 → New balance: 70
- Balance: 50, Withdraw: 50 → New balance: 0
- Balance: 50, Withdraw: 60 → InsufficientFundsError
- Balance: 100, Withdraw: -10 → ValidationError
- Balance: 100, Withdraw: 0 → ValidationError
```

**This spec enables clear tests:**
- 6 acceptance criteria = 6 test functions minimum
- 3 error conditions = 3 error tests
- 5 examples = potential parametrized tests

## Part 2: Creating Testable Interface Skeletons

Interface skeletons define **how** to structure code. Good skeletons make testing straightforward.

### Core Principles of Testable Design

**1. Dependency Injection**

Enable test doubles by accepting dependencies as parameters.

```python
# ❌ Bad: Hard-coded dependencies
class UserService:
    def __init__(self):
        self.db = PostgresDatabase()  # Can't inject test double
        self.email = SmtpEmailService()  # Can't mock

# ✅ Good: Inject dependencies
class UserService:
    def __init__(self, db: Database, email_service: EmailService):
        self.db = db  # Can inject InMemoryDatabase for tests
        self.email_service = email_service  # Can inject MockEmailService
```

**TypeScript:**
```typescript
// ❌ Bad: Hard-coded
class UserService {
  private db = new PostgresDatabase();
  private email = new SmtpEmailService();
}

// ✅ Good: Inject
class UserService {
  constructor(
    private db: Database,
    private emailService: EmailService
  ) {}
}
```

**2. Clear Contracts and Types**

Define what methods expect and return.

```python
# ❌ Bad: Unclear contract
def process(data):
    # What is data? What does it return?
    pass

# ✅ Good: Clear contract
def process(data: List[int]) -> List[int]:
    """
    Double each value in the list.
    
    Args:
        data: List of integers to process
        
    Returns:
        New list with each value doubled
        
    Raises:
        ValueError: If list contains non-integer values
        
    Examples:
        >>> process([1, 2, 3])
        [2, 4, 6]
    """
    pass
```

**3. Single Responsibility**

Each class/function should have one reason to change.

```python
# ❌ Bad: Multiple responsibilities
class UserService:
    def register(self, email, password):
        # Validates
        # Hashes password
        # Saves to database
        # Sends email
        # Logs event
        # Updates analytics
        pass  # Too much - hard to test

# ✅ Good: Separated concerns
class UserService:
    def __init__(self, db: Database, email: EmailService, validator: Validator):
        self.db = db
        self.email = email
        self.validator = validator
    
    def register(self, email: str, password: str) -> User:
        """Register new user. Focus on coordination."""
        user = self.validator.validate_registration(email, password)
        saved_user = self.db.save_user(user)
        self.email.send_welcome(saved_user.email)
        return saved_user

# Each component testable independently:
# - Validator (test validation logic)
# - Database (test storage)
# - EmailService (test notifications)
# - UserService (test coordination with mocks)
```

**4. Interface Segregation**

Depend on specific interfaces, not large ones.

```python
# ❌ Bad: Fat interface
class Database:
    def save_user(self, user): pass
    def get_user(self, id): pass
    def delete_user(self, id): pass
    def save_product(self, product): pass
    def get_product(self, id): pass
    # 50 more methods...

class UserService:
    def __init__(self, db: Database):  # Depends on entire Database
        self.db = db

# ✅ Good: Focused interfaces
class UserRepository:
    def save(self, user: User) -> User: pass
    def get(self, id: int) -> User: pass
    def find_by_email(self, email: str) -> Optional[User]: pass

class UserService:
    def __init__(self, user_repo: UserRepository):  # Only what it needs
        self.user_repo = user_repo
```

**5. Avoid Concrete Dependencies**

Depend on abstractions, not concrete implementations.

```python
# ❌ Bad: Concrete dependency
class UserService:
    def __init__(self, db: PostgresDatabase):  # Concrete class
        self.db = db

# ✅ Good: Abstract dependency
from abc import ABC, abstractmethod

class Database(ABC):
    @abstractmethod
    def save_user(self, user: User) -> User:
        pass

class UserService:
    def __init__(self, db: Database):  # Abstract interface
        self.db = db

# Tests can use InMemoryDatabase(Database)
# Production uses PostgresDatabase(Database)
```

### Translating Specification to Skeleton

**Step-by-step process:**

1. **Identify main entities** from spec
2. **Extract behaviors** (methods)
3. **Define interfaces** for dependencies
4. **Add type hints** for contracts
5. **Document with docstrings**
6. **Leave implementation empty**

**Example translation:**

**Specification:**
```
Feature: Shopping Cart

Behaviors:
- Add item to cart
- Remove item from cart
- Calculate total price
- Apply discount code

Error Conditions:
- InvalidItemError: Item doesn't exist
- EmptyCartError: Cart has no items
```

**Skeleton (Python):**
```python
from abc import ABC, abstractmethod
from typing import List, Optional
from decimal import Decimal

# Entities
class Item:
    """Represents a product that can be added to cart."""
    def __init__(self, id: int, name: str, price: Decimal):
        self.id = id
        self.name = name
        self.price = price

class CartItem:
    """Item in cart with quantity."""
    def __init__(self, item: Item, quantity: int):
        self.item = item
        self.quantity = quantity

# Custom exceptions
class InvalidItemError(Exception):
    """Raised when item doesn't exist."""
    pass

class EmptyCartError(Exception):
    """Raised when operation requires items but cart is empty."""
    pass

# Interfaces for dependencies
class ItemRepository(ABC):
    """Interface for retrieving items."""
    
    @abstractmethod
    def get_item(self, item_id: int) -> Optional[Item]:
        """Get item by ID. Returns None if not found."""
        pass

class DiscountService(ABC):
    """Interface for applying discounts."""
    
    @abstractmethod
    def get_discount(self, code: str) -> Decimal:
        """Get discount percentage for code (0.0 to 1.0)."""
        pass

# Main class
class ShoppingCart:
    """
    Shopping cart for managing items and calculating total.
    
    Behaviors:
    - Add items with quantity
    - Remove items
    - Calculate total with optional discount
    """
    
    def __init__(self, item_repository: ItemRepository):
        """
        Initialize cart.
        
        Args:
            item_repository: Repository for retrieving item details
        """
        self.item_repository = item_repository
        self.items: List[CartItem] = []
    
    def add_item(self, item_id: int, quantity: int = 1) -> None:
        """
        Add item to cart.
        
        Args:
            item_id: ID of item to add
            quantity: Number of items to add (default 1)
            
        Raises:
            InvalidItemError: If item_id doesn't exist
            ValueError: If quantity <= 0
        """
        pass
    
    def remove_item(self, item_id: int) -> None:
        """
        Remove item from cart.
        
        Args:
            item_id: ID of item to remove
            
        Raises:
            InvalidItemError: If item not in cart
        """
        pass
    
    def calculate_total(self, discount_code: Optional[str] = None) -> Decimal:
        """
        Calculate total price of items in cart.
        
        Args:
            discount_code: Optional discount code to apply
            
        Returns:
            Total price after any discount
            
        Raises:
            EmptyCartError: If cart has no items
        """
        pass
    
    def get_item_count(self) -> int:
        """Get total number of items in cart."""
        pass
    
    def is_empty(self) -> bool:
        """Check if cart is empty."""
        pass
```

**Skeleton (TypeScript):**
```typescript
// Entities
interface Item {
  id: number;
  name: string;
  price: number;
}

interface CartItem {
  item: Item;
  quantity: number;
}

// Custom errors
class InvalidItemError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'InvalidItemError';
  }
}

class EmptyCartError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'EmptyCartError';
  }
}

// Interfaces for dependencies
interface ItemRepository {
  /**
   * Get item by ID.
   * @returns Item or null if not found
   */
  getItem(itemId: number): Promise<Item | null>;
}

interface DiscountService {
  /**
   * Get discount for code.
   * @returns Discount as decimal (0.0 to 1.0)
   */
  getDiscount(code: string): Promise<number>;
}

// Main class
class ShoppingCart {
  private items: CartItem[] = [];
  
  constructor(private itemRepository: ItemRepository) {}
  
  /**
   * Add item to cart.
   * @throws InvalidItemError if item doesn't exist
   * @throws Error if quantity <= 0
   */
  async addItem(itemId: number, quantity: number = 1): Promise<void> {
    throw new Error('Not implemented');
  }
  
  /**
   * Remove item from cart.
   * @throws InvalidItemError if item not in cart
   */
  removeItem(itemId: number): void {
    throw new Error('Not implemented');
  }
  
  /**
   * Calculate total price.
   * @throws EmptyCartError if cart is empty
   */
  async calculateTotal(discountCode?: string): Promise<number> {
    throw new Error('Not implemented');
  }
  
  /**
   * Get total number of items.
   */
  getItemCount(): number {
    throw new Error('Not implemented');
  }
  
  /**
   * Check if cart is empty.
   */
  isEmpty(): boolean {
    throw new Error('Not implemented');
  }
}
```

## Design Patterns for Testability

### Pattern 1: Repository Pattern

Separate data access from business logic.

```python
# Interface
class UserRepository(ABC):
    @abstractmethod
    def save(self, user: User) -> User:
        pass
    
    @abstractmethod
    def find_by_email(self, email: str) -> Optional[User]:
        pass

# Test implementation
class InMemoryUserRepository(UserRepository):
    def __init__(self):
        self.users = {}
    
    def save(self, user: User) -> User:
        self.users[user.email] = user
        return user
    
    def find_by_email(self, email: str) -> Optional[User]:
        return self.users.get(email)

# Production implementation
class PostgresUserRepository(UserRepository):
    def save(self, user: User) -> User:
        # Actual database logic
        pass

# Service uses interface
class UserService:
    def __init__(self, repo: UserRepository):
        self.repo = repo  # Can be either implementation
```

### Pattern 2: Strategy Pattern

Make algorithms swappable for testing.

```python
# Strategy interface
class PasswordHasher(ABC):
    @abstractmethod
    def hash(self, password: str) -> str:
        pass

# Production strategy
class BcryptHasher(PasswordHasher):
    def hash(self, password: str) -> str:
        return bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()

# Test strategy (fast, predictable)
class SimpleHasher(PasswordHasher):
    def hash(self, password: str) -> str:
        return f"hashed_{password}"

# Service uses strategy
class UserService:
    def __init__(self, hasher: PasswordHasher):
        self.hasher = hasher
```

### Pattern 3: Factory Pattern

Create objects without specifying exact classes.

```python
# Factory interface
class EmailServiceFactory(ABC):
    @abstractmethod
    def create_email_service(self) -> EmailService:
        pass

# Production factory
class ProductionEmailFactory(EmailServiceFactory):
    def create_email_service(self) -> EmailService:
        return SmtpEmailService(config)

# Test factory
class MockEmailFactory(EmailServiceFactory):
    def create_email_service(self) -> EmailService:
        return MockEmailService()
```

## Language-Specific Patterns

### Python: ABC vs Protocol

**Use ABC for explicit inheritance:**
```python
from abc import ABC, abstractmethod

class PaymentProcessor(ABC):
    @abstractmethod
    def process_payment(self, amount: Decimal) -> bool:
        pass

class StripeProcessor(PaymentProcessor):  # Must implement
    def process_payment(self, amount: Decimal) -> bool:
        # Implementation
        pass
```

**Use Protocol for structural typing:**
```python
from typing import Protocol

class Drawable(Protocol):
    def draw(self) -> None:
        ...

# Any class with draw() method is Drawable
class Circle:
    def draw(self) -> None:
        pass

class Square:
    def draw(self) -> None:
        pass

def render(shape: Drawable):  # Accepts any Drawable
    shape.draw()
```

**When to use which:**
- **ABC**: Explicit interface contracts, want runtime checking
- **Protocol**: Duck typing, third-party compatibility, less coupling

### TypeScript: Interface vs Abstract Class

**Use Interface for contracts only:**
```typescript
interface Repository<T> {
  save(entity: T): Promise<T>;
  findById(id: number): Promise<T | null>;
}

class UserRepository implements Repository<User> {
  async save(user: User): Promise<User> {
    // Implementation
  }
  
  async findById(id: number): Promise<User | null> {
    // Implementation
  }
}
```

**Use Abstract Class for shared implementation:**
```typescript
abstract class BaseRepository<T> {
  protected abstract tableName: string;
  
  // Shared implementation
  async findById(id: number): Promise<T | null> {
    return db.query(`SELECT * FROM ${this.tableName} WHERE id = ?`, [id]);
  }
  
  // Abstract method to implement
  abstract save(entity: T): Promise<T>;
}

class UserRepository extends BaseRepository<User> {
  protected tableName = 'users';
  
  async save(user: User): Promise<User> {
    // User-specific save logic
  }
}
```

**When to use which:**
- **Interface**: Pure contracts, multiple implementations, testing flexibility
- **Abstract Class**: Shared code, template method pattern, less duplication

## Common Design Mistakes

### Mistake 1: Concrete Dependencies

```python
# ❌ Problem
class OrderService:
    def __init__(self):
        self.email = SmtpEmailService()  # Can't test without SMTP
        self.db = PostgresDatabase()     # Can't test without database

# ✅ Solution: Inject abstractions
class OrderService:
    def __init__(self, email: EmailService, db: Database):
        self.email = email
        self.db = db

# Test with mocks
service = OrderService(MockEmailService(), InMemoryDatabase())
```

### Mistake 2: God Classes

```python
# ❌ Problem: Does everything
class UserManager:
    def register(self): pass
    def login(self): pass
    def update_profile(self): pass
    def send_email(self): pass
    def validate_email(self): pass
    def hash_password(self): pass
    def save_to_db(self): pass
    def generate_token(self): pass
    # 20 more methods...

# ✅ Solution: Separate concerns
class UserService:
    def __init__(self, repo: UserRepository, auth: AuthService, validator: Validator):
        self.repo = repo
        self.auth = auth
        self.validator = validator
    
    def register(self, email: str, password: str) -> User:
        self.validator.validate_email(email)
        self.validator.validate_password(password)
        user = self.repo.save(User(email, password))
        self.auth.generate_token(user)
        return user
```

### Mistake 3: Hidden Dependencies

```python
# ❌ Problem: Uses global state
class UserService:
    def register(self, email, password):
        # Hidden dependency on global
        send_email(email, "Welcome!")  # Where is this from?

# ✅ Solution: Explicit dependencies
class UserService:
    def __init__(self, email_service: EmailService):
        self.email_service = email_service
    
    def register(self, email, password):
        self.email_service.send(email, "Welcome!")
```

### Mistake 4: Tight Coupling

```python
# ❌ Problem: Knows too much about implementation
class OrderService:
    def process_order(self, order):
        # Directly accesses database implementation details
        conn = psycopg2.connect("postgresql://...")
        cursor = conn.cursor()
        cursor.execute("INSERT INTO orders...")
        conn.commit()

# ✅ Solution: Use abstraction
class OrderService:
    def __init__(self, order_repo: OrderRepository):
        self.order_repo = order_repo
    
    def process_order(self, order: Order):
        self.order_repo.save(order)
```

### Mistake 5: Leaking Implementation

```python
# ❌ Problem: Public API reveals internals
class Cart:
    def __init__(self):
        self.items = []  # Public mutable list - dangerous!
    
    def add(self, item):
        self.items.append(item)

# Tests (or users) can break invariants:
cart = Cart()
cart.items = None  # Breaks everything!

# ✅ Solution: Encapsulate properly
class Cart:
    def __init__(self):
        self._items: List[CartItem] = []  # Private
    
    def add(self, item: Item) -> None:
        self._items.append(CartItem(item))
    
    def get_items(self) -> List[CartItem]:
        return self._items.copy()  # Return copy, not internal list
```

## Testability Checklist

Use this checklist when designing interfaces:

**Dependencies:**
- [ ] All external dependencies injected (not instantiated internally)
- [ ] Dependencies are interfaces/protocols, not concrete classes
- [ ] No global state or singletons
- [ ] No hard-coded configuration

**Interfaces:**
- [ ] Clear contracts (type hints, return types)
- [ ] Single responsibility per class
- [ ] Methods do one thing
- [ ] Public API is minimal (principle of least privilege)

**Error Handling:**
- [ ] Error conditions specified in docstrings
- [ ] Custom exceptions defined where appropriate
- [ ] Errors don't leak implementation details

**Documentation:**
- [ ] Every public method has docstring
- [ ] Parameters and return types documented
- [ ] Raises section lists exceptions
- [ ] Examples provided for complex methods

**Testability:**
- [ ] Can inject test doubles for dependencies
- [ ] Observable behavior (returns values or changes state)
- [ ] No side effects in constructors
- [ ] Synchronous by default (async only when needed)

## Quick Reference

### Specification Red Flags

⚠️ "Uses HashMap" → Too specific, use "retrieves in O(1)"
⚠️ "User-friendly" → Not measurable, specify concrete criteria
⚠️ "Handles errors" → Vague, list specific error conditions
⚠️ Only happy path → Missing error and edge cases
⚠️ "Works correctly" → Tautology, define correct behavior

### Design Red Flags

⚠️ `__init__` creates dependencies → Should inject
⚠️ Class has >10 methods → Probably doing too much
⚠️ Method has >3 parameters → Consider parameter object
⚠️ Uses `global` or singletons → Hidden dependencies
⚠️ No interfaces, only concrete classes → Hard to test

## Integration with TDD Workflow

```
1. Requirements
   ↓
2. Write Testable Specification (THIS SKILL)
   ↓
3. Create Interface Skeletons (THIS SKILL)
   ↓
4. Generate Test Template (TDD Skill)
   ↓
5. Write Tests from Spec + Interface (TDD Skill)
   ↓
6. Review Tests (Test Review Skill)
   ↓
7. Implement (TDD Skill)
```

**Key insight:** Good design here makes steps 5-7 easy. Poor design makes them painful.

## Summary

**Testable Specifications:**
- Focus on behavior, not implementation
- Include acceptance criteria, errors, boundaries
- Make everything observable and verifiable

**Testable Interfaces:**
- Inject dependencies (don't instantiate)
- Depend on abstractions (not concrete classes)
- Single responsibility per component
- Clear contracts with types and docs
- Minimal public API

**Result:** Tests are easy to write, implementation is clear, refactoring is safe.
