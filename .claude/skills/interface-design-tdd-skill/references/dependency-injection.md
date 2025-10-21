# Dependency Injection for Testing

Comprehensive guide to dependency injection patterns that enable testability in TDD.

## Core Principle

**Don't create dependencies - receive them as parameters.**

This allows tests to inject test doubles (mocks, stubs, fakes) instead of real dependencies.

## Constructor Injection (Recommended)

Pass dependencies through the constructor.

### Python

```python
# ✅ Good: Dependencies injected
class UserService:
    def __init__(self, 
                 user_repository: UserRepository,
                 email_service: EmailService,
                 password_hasher: PasswordHasher):
        self.user_repository = user_repository
        self.email_service = email_service
        self.password_hasher = password_hasher
    
    def register(self, email: str, password: str) -> User:
        hashed_password = self.password_hasher.hash(password)
        user = User(email, hashed_password)
        saved_user = self.user_repository.save(user)
        self.email_service.send_welcome(email)
        return saved_user

# Easy testing
def test_user_registration():
    # Inject test doubles
    repo = InMemoryUserRepository()
    email = MockEmailService()
    hasher = PlainTextHasher()
    
    service = UserService(repo, email, hasher)
    user = service.register("test@example.com", "password")
    
    assert user.email == "test@example.com"
    assert email.sent_count == 1
```

**Benefits:**
- Dependencies explicit and visible
- Easy to test with mocks
- Dependencies required (can't forget)
- Immutable after construction

### TypeScript

```typescript
class UserService {
  constructor(
    private userRepository: UserRepository,
    private emailService: EmailService,
    private passwordHasher: PasswordHasher
  ) {}
  
  async register(email: string, password: string): Promise<User> {
    const hashedPassword = await this.passwordHasher.hash(password);
    const user = new User(email, hashedPassword);
    const savedUser = await this.userRepository.save(user);
    await this.emailService.sendWelcome(email);
    return savedUser;
  }
}

// Testing
const service = new UserService(
  new InMemoryUserRepository(),
  new MockEmailService(),
  new PlainTextHasher()
);
```

## Method Injection

Pass dependencies to specific methods (less common).

```python
# When dependency only needed for one method
class ReportGenerator:
    def generate_report(self, data: List[Data], formatter: ReportFormatter):
        formatted = formatter.format(data)
        return formatted

# Testing
def test_report_generation():
    generator = ReportGenerator()
    formatter = JsonFormatter()  # Inject specific formatter
    
    report = generator.generate_report(data, formatter)
    assert report.format == "json"
```

**Use when:**
- Dependency varies per method call
- Not all methods need the dependency
- Want to make dependency choice explicit at call site

## Property Injection (Avoid in TDD)

Setting dependencies after construction (not recommended for testing).

```python
# ❌ Avoid: Dependency can be forgotten
class UserService:
    def __init__(self):
        self.email_service = None  # Optional, might be forgotten
    
    def register(self, email, password):
        if self.email_service:  # Defensive check needed
            self.email_service.send_welcome(email)

# Testing is fragile
def test_registration():
    service = UserService()
    service.email_service = MockEmailService()  # Easy to forget
    # ...
```

**Why avoid:**
- Dependencies not obvious
- Easy to forget in tests
- Requires defensive null checks
- Object might be in invalid state

## Interface Segregation with DI

Use focused interfaces for each dependency.

```python
# ❌ Bad: Fat interface dependency
class Database:
    def save_user(self, user): pass
    def get_user(self, id): pass
    def save_product(self, product): pass
    def get_product(self, id): pass
    # 50 more methods...

class UserService:
    def __init__(self, db: Database):
        self.db = db  # Depends on entire database

# ✅ Good: Focused interface
class UserRepository:
    def save(self, user: User) -> User: pass
    def get(self, id: int) -> User: pass
    def find_by_email(self, email: str) -> Optional[User]: pass

class UserService:
    def __init__(self, user_repo: UserRepository):
        self.user_repo = user_repo  # Only what it needs
```

**Benefits:**
- Tests mock only what's needed
- Clear which data service uses
- Changes to unrelated parts don't affect tests

## Dependency Inversion Principle

Depend on abstractions, not concretions.

```python
# ❌ Bad: Depends on concrete class
class UserService:
    def __init__(self, db: PostgresDatabase):  # Concrete
        self.db = db

# ✅ Good: Depends on abstraction
class UserService:
    def __init__(self, db: Database):  # Abstract
        self.db = db

# Can inject any Database implementation
service = UserService(PostgresDatabase())  # Production
service = UserService(InMemoryDatabase())  # Testing
```

## DI Container Pattern (Optional)

For complex applications with many dependencies.

### Simple DI Container

```python
class Container:
    def __init__(self):
        self._services = {}
    
    def register(self, interface, implementation):
        self._services[interface] = implementation
    
    def resolve(self, interface):
        return self._services[interface]

# Setup
container = Container()
container.register(UserRepository, InMemoryUserRepository())
container.register(EmailService, MockEmailService())
container.register(PasswordHasher, PlainTextHasher())

# Resolve dependencies
repo = container.resolve(UserRepository)
email = container.resolve(EmailService)
hasher = container.resolve(PasswordHasher)

service = UserService(repo, email, hasher)
```

### Factory Pattern with DI

```python
class ServiceFactory:
    def __init__(self, 
                 user_repo: UserRepository,
                 email_service: EmailService):
        self.user_repo = user_repo
        self.email_service = email_service
    
    def create_user_service(self) -> UserService:
        hasher = BcryptHasher()  # Created here
        return UserService(self.user_repo, self.email_service, hasher)

# Production
factory = ServiceFactory(
    PostgresUserRepository(),
    SmtpEmailService()
)
service = factory.create_user_service()

# Testing
factory = ServiceFactory(
    InMemoryUserRepository(),
    MockEmailService()
)
service = factory.create_user_service()
```

## Circular Dependencies

Avoid circular dependencies between components.

### Problem

```python
# ❌ Circular dependency
class UserService:
    def __init__(self, order_service: OrderService):
        self.order_service = order_service

class OrderService:
    def __init__(self, user_service: UserService):
        self.user_service = user_service
# Can't create either!
```

### Solution 1: Extract Shared Logic

```python
# ✅ Extract what both need
class UserValidator:
    def validate(self, user): pass

class UserService:
    def __init__(self, validator: UserValidator):
        self.validator = validator

class OrderService:
    def __init__(self, validator: UserValidator):
        self.validator = validator

# Both depend on validator, not each other
```

### Solution 2: Event-Based Decoupling

```python
# ✅ Use events instead of direct dependency
class UserService:
    def __init__(self, event_bus: EventBus):
        self.event_bus = event_bus
    
    def create_user(self, email):
        user = User(email)
        self.event_bus.publish(UserCreatedEvent(user))
        return user

class OrderService:
    def __init__(self, event_bus: EventBus):
        event_bus.subscribe(UserCreatedEvent, self.on_user_created)
    
    def on_user_created(self, event: UserCreatedEvent):
        # React to user creation
        pass
```

## Testing Strategies with DI

### In-Memory Implementations

```python
# Production
class PostgresUserRepository(UserRepository):
    def __init__(self, connection_string: str):
        self.db = connect(connection_string)
    
    def save(self, user: User) -> User:
        # Real database operations
        pass

# Testing
class InMemoryUserRepository(UserRepository):
    def __init__(self):
        self.users = {}
    
    def save(self, user: User) -> User:
        self.users[user.id] = user
        return user

# Fast, no database needed
def test_user_service():
    repo = InMemoryUserRepository()
    service = UserService(repo)
    # ...
```

### Mock Objects

```python
from unittest.mock import Mock

def test_user_registration_sends_email():
    repo = InMemoryUserRepository()
    email_service = Mock(spec=EmailService)
    hasher = PlainTextHasher()
    
    service = UserService(repo, email_service, hasher)
    service.register("test@example.com", "password")
    
    # Verify email was sent
    email_service.send_welcome.assert_called_once_with("test@example.com")
```

### Test Doubles Hierarchy

**Dummy**: Passed but never used
```python
dummy_email = Mock(spec=EmailService)  # Never called in this test
service = UserService(repo, dummy_email, hasher)
```

**Stub**: Returns canned responses
```python
class StubEmailService(EmailService):
    def send_welcome(self, email: str):
        pass  # Does nothing, just satisfies interface
```

**Fake**: Working implementation, simplified
```python
class InMemoryDatabase(Database):
    # Real logic, just in-memory instead of persistent
    pass
```

**Mock**: Expects specific calls, verifies interactions
```python
mock_email = Mock(spec=EmailService)
service.register("test@example.com", "password")
mock_email.send_welcome.assert_called_once()
```

## DI Best Practices

1. **Constructor injection for required dependencies**
2. **Method injection for optional/varying dependencies**
3. **Depend on abstractions (interfaces)**
4. **Keep interfaces small and focused**
5. **Avoid property injection**
6. **Avoid circular dependencies**
7. **Use in-memory implementations for fast tests**
8. **Mock only external boundaries**

## Common Pitfalls

### Too Many Dependencies (God Object)

```python
# ❌ Too many dependencies = doing too much
class UserService:
    def __init__(self, 
                 repo, email, sms, push, logger, 
                 analytics, cache, queue, validator):
        # 9 dependencies = code smell
        pass

# ✅ Break into smaller services
class UserRegistrationService:
    def __init__(self, repo, email, validator):
        # Focused responsibility
        pass

class UserNotificationService:
    def __init__(self, email, sms, push):
        # Focused responsibility
        pass
```

### Optional Dependencies as None

```python
# ❌ Avoid optional dependencies
class UserService:
    def __init__(self, 
                 repo: UserRepository,
                 email: Optional[EmailService] = None):
        self.repo = repo
        self.email = email
    
    def register(self, user):
        self.repo.save(user)
        if self.email:  # Defensive check
            self.email.send_welcome(user.email)

# ✅ Make dependencies explicit
class UserService:
    def __init__(self, 
                 repo: UserRepository,
                 email: EmailService):  # Required
        self.repo = repo
        self.email = email

# Use null object pattern if needed
class NoOpEmailService(EmailService):
    def send_welcome(self, email: str):
        pass  # Does nothing

# Clear intent
service = UserService(repo, NoOpEmailService())
```

## Summary

**Key Principles:**
- Inject dependencies, don't create them
- Use constructor injection for required dependencies
- Depend on abstractions (interfaces/protocols)
- Keep interfaces focused and small
- Avoid circular dependencies

**Testing Benefits:**
- Easy to inject test doubles
- Fast tests (no real I/O)
- Isolated tests (no side effects)
- Clear dependencies (visible in constructor)

**Result:** Testable, maintainable, flexible code.