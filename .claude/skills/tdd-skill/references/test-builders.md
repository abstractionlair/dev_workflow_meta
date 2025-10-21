# Test Data Builders

Test data builders provide a fluent, maintainable way to create complex test data. They solve the problem of brittle tests that break when object constructors change.

## The Problem

**Without builders:**
```python
# Test breaks if User constructor changes
def test_user_can_post_comment():
    user = User(
        id=1,
        username="john_doe",
        email="john@example.com",
        first_name="John",
        last_name="Doe",
        is_active=True,
        is_admin=False,
        created_at=datetime.now(),
        updated_at=datetime.now(),
        preferences={"theme": "dark"},
        subscription_tier="premium"
    )
    comment = user.post_comment("Hello world")
    assert comment.author == user
```

Problems:
- Verbose and repetitive
- Test breaks if constructor changes
- Hard to see what's important for the test
- Difficult to create variations

## The Solution: Test Builders

**With builder:**
```python
def test_user_can_post_comment():
    user = UserBuilder().build()  # Creates user with sensible defaults
    comment = user.post_comment("Hello world")
    assert comment.author == user

def test_admin_can_delete_comments():
    admin = UserBuilder().as_admin().build()  # Only specify what matters
    comment = CommentBuilder().build()
    
    result = admin.delete_comment(comment)
    assert result == True
```

Benefits:
- Concise and readable
- Robust to constructor changes
- Clear test intent
- Easy to create variations

## Builder Pattern Implementation

### Python Implementation

**Basic builder:**
```python
from datetime import datetime
from typing import Optional

class UserBuilder:
    def __init__(self):
        self._id = 1
        self._username = "testuser"
        self._email = "test@example.com"
        self._first_name = "Test"
        self._last_name = "User"
        self._is_active = True
        self._is_admin = False
        self._created_at = datetime.now()
        self._updated_at = datetime.now()
        self._preferences = {}
        self._subscription_tier = "free"
    
    def with_id(self, id: int) -> 'UserBuilder':
        self._id = id
        return self
    
    def with_username(self, username: str) -> 'UserBuilder':
        self._username = username
        return self
    
    def with_email(self, email: str) -> 'UserBuilder':
        self._email = email
        return self
    
    def as_admin(self) -> 'UserBuilder':
        self._is_admin = True
        return self
    
    def as_premium(self) -> 'UserBuilder':
        self._subscription_tier = "premium"
        return self
    
    def inactive(self) -> 'UserBuilder':
        self._is_active = False
        return self
    
    def build(self) -> User:
        return User(
            id=self._id,
            username=self._username,
            email=self._email,
            first_name=self._first_name,
            last_name=self._last_name,
            is_active=self._is_active,
            is_admin=self._is_admin,
            created_at=self._created_at,
            updated_at=self._updated_at,
            preferences=self._preferences,
            subscription_tier=self._subscription_tier
        )
```

**Usage:**
```python
# Simple case - defaults
user = UserBuilder().build()

# Specific attributes
user = UserBuilder().with_username("alice").with_email("alice@example.com").build()

# Fluent chains
admin = UserBuilder().with_username("admin").as_admin().as_premium().build()

# Multiple variations
inactive_user = UserBuilder().inactive().build()
premium_user = UserBuilder().as_premium().build()
```

### TypeScript Implementation

```typescript
class UserBuilder {
  private id: number = 1;
  private username: string = 'testuser';
  private email: string = 'test@example.com';
  private firstName: string = 'Test';
  private lastName: string = 'User';
  private isActive: boolean = true;
  private isAdmin: boolean = false;
  private createdAt: Date = new Date();
  private updatedAt: Date = new Date();
  private preferences: Record<string, any> = {};
  private subscriptionTier: string = 'free';

  withId(id: number): UserBuilder {
    this.id = id;
    return this;
  }

  withUsername(username: string): UserBuilder {
    this.username = username;
    return this;
  }

  withEmail(email: string): UserBuilder {
    this.email = email;
    return this;
  }

  asAdmin(): UserBuilder {
    this.isAdmin = true;
    return this;
  }

  asPremium(): UserBuilder {
    this.subscriptionTier = 'premium';
    return this;
  }

  inactive(): UserBuilder {
    this.isActive = false;
    return this;
  }

  build(): User {
    return new User({
      id: this.id,
      username: this.username,
      email: this.email,
      firstName: this.firstName,
      lastName: this.lastName,
      isActive: this.isActive,
      isAdmin: this.isAdmin,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      preferences: this.preferences,
      subscriptionTier: this.subscriptionTier,
    });
  }
}

// Usage
const user = new UserBuilder().build();
const admin = new UserBuilder().withUsername('admin').asAdmin().build();
```

## Advanced Builder Patterns

### Nested Builders

For complex object graphs:

```python
class OrderBuilder:
    def __init__(self):
        self._items = []
        self._customer = UserBuilder().build()
        self._status = "pending"
        self._total = 0
    
    def with_customer(self, customer: User) -> 'OrderBuilder':
        self._customer = customer
        return self
    
    def with_item(self, product: str, quantity: int, price: float) -> 'OrderBuilder':
        self._items.append({
            "product": product,
            "quantity": quantity,
            "price": price
        })
        self._total += quantity * price
        return self
    
    def with_status(self, status: str) -> 'OrderBuilder':
        self._status = status
        return self
    
    def build(self) -> Order:
        return Order(
            customer=self._customer,
            items=self._items,
            status=self._status,
            total=self._total
        )

# Usage - complex object creation made simple
order = (OrderBuilder()
    .with_customer(UserBuilder().with_username("alice").build())
    .with_item("Widget", quantity=2, price=10.0)
    .with_item("Gadget", quantity=1, price=25.0)
    .with_status("confirmed")
    .build())
```

### Builder with Relationships

```python
class CommentBuilder:
    def __init__(self):
        self._id = 1
        self._author = UserBuilder().build()
        self._post = None
        self._content = "Test comment"
        self._created_at = datetime.now()
    
    def on_post(self, post: Post) -> 'CommentBuilder':
        self._post = post
        return self
    
    def by_author(self, author: User) -> 'CommentBuilder':
        self._author = author
        return self
    
    def with_content(self, content: str) -> 'CommentBuilder':
        self._content = content
        return self
    
    def build(self) -> Comment:
        return Comment(
            id=self._id,
            author=self._author,
            post=self._post,
            content=self._content,
            created_at=self._created_at
        )

# Usage
admin = UserBuilder().as_admin().build()
post = PostBuilder().build()
comment = (CommentBuilder()
    .by_author(admin)
    .on_post(post)
    .with_content("Admin comment")
    .build())
```

### Preset Configurations

Create common configurations as methods:

```python
class UserBuilder:
    # ... previous code ...
    
    @staticmethod
    def default_admin() -> User:
        return (UserBuilder()
            .with_username("admin")
            .with_email("admin@example.com")
            .as_admin()
            .as_premium()
            .build())
    
    @staticmethod
    def default_guest() -> User:
        return (UserBuilder()
            .with_username("guest")
            .inactive()
            .build())
    
    @staticmethod
    def random_user() -> User:
        import random
        import string
        random_name = ''.join(random.choices(string.ascii_lowercase, k=8))
        return (UserBuilder()
            .with_username(random_name)
            .with_email(f"{random_name}@example.com")
            .build())

# Usage
admin = UserBuilder.default_admin()
guest = UserBuilder.default_guest()
user1 = UserBuilder.random_user()
```

## Factory Functions (Simpler Alternative)

For simpler cases, factory functions work well:

```python
def create_user(
    username: str = "testuser",
    email: str = "test@example.com",
    is_admin: bool = False,
    is_active: bool = True,
    **kwargs
) -> User:
    defaults = {
        "id": 1,
        "first_name": "Test",
        "last_name": "User",
        "created_at": datetime.now(),
        "updated_at": datetime.now(),
        "preferences": {},
        "subscription_tier": "free"
    }
    defaults.update(kwargs)
    
    return User(
        username=username,
        email=email,
        is_admin=is_admin,
        is_active=is_active,
        **defaults
    )

# Usage
user = create_user()
admin = create_user(username="admin", is_admin=True)
premium = create_user(subscription_tier="premium")
```

**TypeScript:**
```typescript
function createUser(
  overrides: Partial<UserProps> = {}
): User {
  const defaults: UserProps = {
    id: 1,
    username: 'testuser',
    email: 'test@example.com',
    firstName: 'Test',
    lastName: 'User',
    isActive: true,
    isAdmin: false,
    createdAt: new Date(),
    updatedAt: new Date(),
    preferences: {},
    subscriptionTier: 'free',
  };

  return new User({ ...defaults, ...overrides });
}

// Usage
const user = createUser();
const admin = createUser({ username: 'admin', isAdmin: true });
```

## Builder Pattern with Pytest Fixtures

Combine builders with pytest fixtures:

```python
# conftest.py
import pytest

@pytest.fixture
def user_builder():
    return UserBuilder()

@pytest.fixture
def default_user(user_builder):
    return user_builder.build()

@pytest.fixture
def admin_user(user_builder):
    return user_builder.as_admin().build()

@pytest.fixture
def premium_user(user_builder):
    return user_builder.as_premium().build()

# test_user.py
def test_user_can_post_comment(default_user):
    comment = default_user.post_comment("Hello")
    assert comment.author == default_user

def test_admin_can_delete_comments(admin_user, default_user):
    comment = default_user.post_comment("Test")
    result = admin_user.delete_comment(comment)
    assert result == True

def test_premium_user_has_no_ads(premium_user):
    assert premium_user.sees_ads() == False
```

## Object Mother Pattern (Alternative)

Object Mother is similar but provides static methods:

```python
class UserMother:
    @staticmethod
    def create_default() -> User:
        return User(
            id=1,
            username="testuser",
            email="test@example.com",
            is_active=True,
            is_admin=False
        )
    
    @staticmethod
    def create_admin() -> User:
        return User(
            id=1,
            username="admin",
            email="admin@example.com",
            is_active=True,
            is_admin=True
        )
    
    @staticmethod
    def create_inactive() -> User:
        user = UserMother.create_default()
        user.is_active = False
        return user

# Usage
user = UserMother.create_default()
admin = UserMother.create_admin()
```

**When to use Object Mother vs Builder:**
- **Object Mother:** Simpler, good for small number of variations
- **Builder:** More flexible, better for complex objects with many attributes

## Testing with Random Data

Use builders with random data for property-based style tests:

```python
import random
import string

class UserBuilder:
    # ... previous code ...
    
    def with_random_username(self) -> 'UserBuilder':
        self._username = ''.join(random.choices(string.ascii_lowercase, k=10))
        return self
    
    def with_random_email(self) -> 'UserBuilder':
        username = ''.join(random.choices(string.ascii_lowercase, k=8))
        domain = random.choice(['example.com', 'test.org', 'mail.net'])
        self._email = f"{username}@{domain}"
        return self
    
    def randomize(self) -> 'UserBuilder':
        return self.with_random_username().with_random_email()

# Usage in tests
def test_username_normalization():
    for _ in range(100):  # Test with 100 random users
        user = UserBuilder().with_random_username().build()
        assert user.normalized_username() == user.username.lower()
```

## Builder Inheritance

For related entities:

```python
class PersonBuilder:
    def __init__(self):
        self._first_name = "Test"
        self._last_name = "Person"
        self._email = "test@example.com"
    
    def with_first_name(self, name: str) -> 'PersonBuilder':
        self._first_name = name
        return self
    
    def with_last_name(self, name: str) -> 'PersonBuilder':
        self._last_name = name
        return self
    
    def with_email(self, email: str) -> 'PersonBuilder':
        self._email = email
        return self

class CustomerBuilder(PersonBuilder):
    def __init__(self):
        super().__init__()
        self._customer_id = 1
        self._loyalty_points = 0
    
    def with_customer_id(self, id: int) -> 'CustomerBuilder':
        self._customer_id = id
        return self
    
    def with_loyalty_points(self, points: int) -> 'CustomerBuilder':
        self._loyalty_points = points
        return self
    
    def build(self) -> Customer:
        return Customer(
            customer_id=self._customer_id,
            first_name=self._first_name,
            last_name=self._last_name,
            email=self._email,
            loyalty_points=self._loyalty_points
        )

# Usage
customer = (CustomerBuilder()
    .with_first_name("Alice")
    .with_email("alice@example.com")
    .with_loyalty_points(1000)
    .build())
```

## Best Practices

### 1. Provide Sensible Defaults

```python
# Good - can create valid object with no configuration
user = UserBuilder().build()

# Avoid - requiring configuration for basic object
user = UserBuilder().with_username("test").with_email("test@example.com").build()
```

### 2. Use Descriptive Method Names

```python
# Good - clear intent
user = UserBuilder().as_admin().inactive().build()

# Avoid - unclear
user = UserBuilder().set_flag1(True).set_flag2(False).build()
```

### 3. Keep Builders in Test Code

Don't use builders in production code:
```
tests/
├── builders/
│   ├── __init__.py
│   ├── user_builder.py
│   └── order_builder.py
└── test_users.py
```

### 4. One Builder Per Domain Concept

Don't create builders for every class - focus on domain entities:

```python
# Good - builders for domain entities
UserBuilder()
OrderBuilder()
ProductBuilder()

# Avoid - builders for simple value objects
AddressBuilder()  # Probably overkill
PhoneNumberBuilder()  # Probably overkill
```

### 5. Return Self for Fluent Interface

```python
# Good - enables chaining
def with_username(self, username: str) -> 'UserBuilder':
    self._username = username
    return self

# Avoid - breaks chaining
def with_username(self, username: str) -> None:
    self._username = username
```

## When to Use Builders

**Good fit:**
- Complex objects with many attributes
- Objects used across many tests
- When constructor changes frequently
- When creating object variations
- Integration tests with rich domain objects

**Less suitable:**
- Simple objects with 2-3 attributes
- Objects used in single test
- Value objects (strings, numbers, dates)
- DTOs with no behavior

## Builder Pattern vs Other Approaches

**Comparison:**

```python
# 1. Direct construction - simple but brittle
user = User(id=1, username="test", email="test@example.com", ...)

# 2. Factory function - simple and good for basic needs
user = create_user(username="test", is_admin=True)

# 3. Object Mother - good for finite set of variations
user = UserMother.create_admin()

# 4. Builder - most flexible for complex scenarios
user = UserBuilder().with_username("test").as_admin().build()
```

Choose based on complexity and needs.

## Key Takeaways

1. Builders create test data in a maintainable way
2. Provide sensible defaults, override only what matters
3. Use fluent interface for readability
4. Keep builders simple - don't over-engineer
5. Combine with fixtures for pytest/Jest
6. Focus on domain entities, not every class
7. Keep builders in test code only
8. Consider simpler factory functions for basic needs
9. Use preset configurations for common scenarios
10. Make tests readable by expressing intent clearly
