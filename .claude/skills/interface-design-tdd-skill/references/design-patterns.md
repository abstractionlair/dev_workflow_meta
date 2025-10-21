# Testable Design Patterns

Common design patterns that enable easy testing in TDD.

## Repository Pattern

Separates data access logic from business logic, enabling easy testing with in-memory implementations.

### Problem
```python
# ❌ Tight coupling to database
class UserService:
    def create_user(self, email, password):
        conn = psycopg2.connect("postgresql://prod")
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users...")  # Hard to test
```

### Solution
```python
# Repository interface
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

# Service uses interface
class UserService:
    def __init__(self, repo: UserRepository):
        self.repo = repo
    
    def create_user(self, email: str, password: str) -> User:
        if self.repo.find_by_email(email):
            raise DuplicateEmailError()
        user = User(email, password)
        return self.repo.save(user)

# Easy testing
def test_create_user():
    repo = InMemoryUserRepository()  # No database needed
    service = UserService(repo)
    user = service.create_user("test@example.com", "password")
    assert user.email == "test@example.com"
```

## Strategy Pattern

Make algorithms swappable for testing.

### Problem
```python
# ❌ Hard-coded algorithm
class UserService:
    def hash_password(self, password):
        return bcrypt.hashpw(password, bcrypt.gensalt())  # Slow in tests
```

### Solution
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
class PlainTextHasher(PasswordHasher):
    def hash(self, password: str) -> str:
        return f"hashed_{password}"

# Service uses strategy
class UserService:
    def __init__(self, hasher: PasswordHasher):
        self.hasher = hasher
    
    def create_user(self, email, password):
        hashed = self.hasher.hash(password)
        return User(email, hashed)

# Fast testing
def test_user_creation():
    hasher = PlainTextHasher()  # Fast, no bcrypt delays
    service = UserService(hasher)
    user = service.create_user("test@example.com", "password")
    assert user.password_hash == "hashed_password"
```

## Factory Pattern

Control object creation for testing.

### Problem
```python
# ❌ Creates dependencies internally
class OrderService:
    def process_order(self, order):
        payment = StripePayment()  # Can't inject test double
        payment.charge(order.total)
```

### Solution
```python
# Factory interface
class PaymentFactory(ABC):
    @abstractmethod
    def create_payment_processor(self) -> PaymentProcessor:
        pass

# Test factory
class MockPaymentFactory(PaymentFactory):
    def create_payment_processor(self) -> PaymentProcessor:
        return MockPaymentProcessor()

# Service uses factory
class OrderService:
    def __init__(self, payment_factory: PaymentFactory):
        self.payment_factory = payment_factory
    
    def process_order(self, order: Order):
        payment = self.payment_factory.create_payment_processor()
        payment.charge(order.total)

# Testable
def test_order_processing():
    factory = MockPaymentFactory()
    service = OrderService(factory)
    order = Order(total=100)
    service.process_order(order)  # Uses mock payment
```

## Builder Pattern (for Test Data)

Simplify test data creation.

```python
# Test data builder
class UserBuilder:
    def __init__(self):
        self._email = "test@example.com"
        self._password = "password"
        self._is_admin = False
    
    def with_email(self, email: str):
        self._email = email
        return self
    
    def as_admin(self):
        self._is_admin = True
        return self
    
    def build(self) -> User:
        return User(self._email, self._password, self._is_admin)

# Clean tests
def test_admin_can_delete_users():
    admin = UserBuilder().as_admin().build()
    user = UserBuilder().build()
    
    result = admin.delete_user(user)
    assert result == True
```

## Adapter Pattern

Adapt external interfaces for testing.

### Problem
```python
# ❌ Directly uses third-party API
class NotificationService:
    def send(self, user, message):
        twilio_client = TwilioClient(account_sid, auth_token)
        twilio_client.messages.create(to=user.phone, body=message)
```

### Solution
```python
# Adapter interface
class SmsService(ABC):
    @abstractmethod
    def send_sms(self, phone: str, message: str):
        pass

# Production adapter
class TwilioAdapter(SmsService):
    def __init__(self, client: TwilioClient):
        self.client = client
    
    def send_sms(self, phone: str, message: str):
        self.client.messages.create(to=phone, body=message)

# Test adapter
class MockSmsService(SmsService):
    def __init__(self):
        self.sent_messages = []
    
    def send_sms(self, phone: str, message: str):
        self.sent_messages.append((phone, message))

# Service uses adapter
class NotificationService:
    def __init__(self, sms_service: SmsService):
        self.sms_service = sms_service
    
    def send(self, user: User, message: str):
        self.sms_service.send_sms(user.phone, message)

# Testable
def test_notification():
    sms = MockSmsService()
    service = NotificationService(sms)
    user = User(phone="+1234567890")
    
    service.send(user, "Hello")
    
    assert len(sms.sent_messages) == 1
    assert sms.sent_messages[0] == ("+1234567890", "Hello")
```

## Observer Pattern (Event-Driven)

Decouple components with events.

```python
# Event interface
class Event:
    pass

class UserRegisteredEvent(Event):
    def __init__(self, user: User):
        self.user = user

# Observer interface
class EventHandler(ABC):
    @abstractmethod
    def handle(self, event: Event):
        pass

# Concrete handler
class SendWelcomeEmailHandler(EventHandler):
    def __init__(self, email_service: EmailService):
        self.email_service = email_service
    
    def handle(self, event: UserRegisteredEvent):
        self.email_service.send_welcome(event.user.email)

# Event dispatcher
class EventDispatcher:
    def __init__(self):
        self.handlers = []
    
    def register(self, handler: EventHandler):
        self.handlers.append(handler)
    
    def dispatch(self, event: Event):
        for handler in self.handlers:
            handler.handle(event)

# Service publishes events
class UserService:
    def __init__(self, repo: UserRepository, dispatcher: EventDispatcher):
        self.repo = repo
        self.dispatcher = dispatcher
    
    def register(self, email, password):
        user = User(email, password)
        saved_user = self.repo.save(user)
        self.dispatcher.dispatch(UserRegisteredEvent(saved_user))
        return saved_user

# Test without side effects
def test_user_registration():
    repo = InMemoryUserRepository()
    dispatcher = EventDispatcher()  # No handlers registered
    service = UserService(repo, dispatcher)
    
    user = service.register("test@example.com", "password")
    
    assert user.email == "test@example.com"
    # No email sent during test
```

## Key Principles

1. **Depend on abstractions** - Interfaces, not concrete classes
2. **Inject dependencies** - Don't create them internally
3. **Single responsibility** - One reason to change
4. **Open/closed** - Open for extension, closed for modification
5. **Interface segregation** - Small, focused interfaces
