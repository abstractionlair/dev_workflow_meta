# Code Smells Catalog

A comprehensive guide to identifying and fixing common code smells during implementation review.

## Table of Contents

1. [Bloaters](#bloaters)
2. [Object-Orientation Abusers](#object-orientation-abusers)
3. [Change Preventers](#change-preventers)
4. [Dispensables](#dispensables)
5. [Couplers](#couplers)

---

## Bloaters

Code that has grown too large or complex.

### Long Method

**Description:** Method has too many lines (>50 guideline).

**Example:**
```python
def process_order(self, order):
    # Validate order (20 lines)
    if not order.items:
        raise ValueError("Empty order")
    for item in order.items:
        if item.quantity <= 0:
            raise ValueError("Invalid quantity")
    # ... more validation
    
    # Calculate totals (30 lines)
    subtotal = 0
    for item in order.items:
        subtotal += item.price * item.quantity
    # ... tax, shipping, discounts
    
    # Save to database (20 lines)
    # Send email (20 lines)
    # Update inventory (20 lines)
    # Log transaction (10 lines)
    # Total: 120 lines
```

**Fix:** Extract methods
```python
def process_order(self, order):
    self._validate_order(order)
    totals = self._calculate_totals(order)
    self._save_order(order, totals)
    self._send_confirmation(order)
    self._update_inventory(order)
    self._log_transaction(order)

def _validate_order(self, order):
    # 20 lines

def _calculate_totals(self, order):
    # 30 lines
    
# Each method focused and testable
```

### Large Class

**Description:** Class has too many responsibilities (>500 lines or >10 public methods).

**Example:**
```python
class UserManager:
    # Authentication (100 lines)
    def login(self): ...
    def logout(self): ...
    def reset_password(self): ...
    
    # Profile management (100 lines)
    def update_profile(self): ...
    def upload_avatar(self): ...
    
    # Notification preferences (100 lines)
    def set_email_preferences(self): ...
    def set_push_preferences(self): ...
    
    # Billing (100 lines)
    def process_payment(self): ...
    def update_subscription(self): ...
    
    # Total: 10+ methods, 400+ lines
```

**Fix:** Split into focused classes
```python
class AuthService:
    def login(self): ...
    def logout(self): ...
    def reset_password(self): ...

class ProfileService:
    def update_profile(self): ...
    def upload_avatar(self): ...

class NotificationService:
    def set_email_preferences(self): ...
    
class BillingService:
    def process_payment(self): ...
```

### Long Parameter List

**Description:** Method has too many parameters (>4 guideline).

**Example:**
```python
def create_user(
    username: str,
    email: str,
    first_name: str,
    last_name: str,
    age: int,
    country: str,
    phone: str,
    address: str,
    preferences: dict
):
    # 9 parameters - hard to call correctly
```

**Fix:** Use parameter object
```python
@dataclass
class UserRegistration:
    username: str
    email: str
    first_name: str
    last_name: str
    age: int
    country: str
    phone: str
    address: str
    preferences: dict

def create_user(self, registration: UserRegistration):
    # Single parameter, clear structure
```

### Primitive Obsession

**Description:** Using primitives instead of domain objects.

**Example:**
```python
def send_email(
    to: str,  # Just a string - could be invalid
    subject: str,
    body: str,
    priority: int  # Magic numbers: 1=low, 2=normal, 3=high
):
    if priority < 1 or priority > 3:
        raise ValueError("Invalid priority")
    # ...
```

**Fix:** Use value objects
```python
from enum import Enum

class Email:
    def __init__(self, address: str):
        if '@' not in address:
            raise ValueError("Invalid email")
        self.address = address

class Priority(Enum):
    LOW = 1
    NORMAL = 2
    HIGH = 3

def send_email(
    to: Email,
    subject: str,
    body: str,
    priority: Priority
):
    # Type-safe, validated
```

### Data Clumps

**Description:** Same group of data items appear together repeatedly.

**Example:**
```python
def create_address(street: str, city: str, state: str, zip: str): ...
def validate_address(street: str, city: str, state: str, zip: str): ...
def format_address(street: str, city: str, state: str, zip: str): ...
def geocode_address(street: str, city: str, state: str, zip: str): ...
```

**Fix:** Create class for the group
```python
@dataclass
class Address:
    street: str
    city: str
    state: str
    zip: str
    
    def validate(self) -> bool: ...
    def format(self) -> str: ...
    def geocode(self) -> tuple[float, float]: ...
```

---

## Object-Orientation Abusers

Incorrect or incomplete application of OO principles.

### Switch Statements

**Description:** Complex switch/if-elif chains that should be polymorphic.

**Example:**
```python
def calculate_shipping(self, order: Order) -> float:
    if order.shipping_method == "standard":
        return order.weight * 0.5
    elif order.shipping_method == "express":
        return order.weight * 1.5
    elif order.shipping_method == "overnight":
        return order.weight * 3.0
    elif order.shipping_method == "international":
        return order.weight * 5.0
    else:
        raise ValueError("Unknown method")
```

**Fix:** Use strategy pattern
```python
class ShippingStrategy(ABC):
    @abstractmethod
    def calculate(self, order: Order) -> float:
        pass

class StandardShipping(ShippingStrategy):
    def calculate(self, order: Order) -> float:
        return order.weight * 0.5

class ExpressShipping(ShippingStrategy):
    def calculate(self, order: Order) -> float:
        return order.weight * 1.5

# In Order class:
def calculate_shipping(self, strategy: ShippingStrategy) -> float:
    return strategy.calculate(self)
```

### Refused Bequest

**Description:** Subclass doesn't use inherited methods.

**Example:**
```python
class Rectangle:
    def __init__(self, width, height):
        self.width = width
        self.height = height
    
    def set_width(self, width):
        self.width = width
    
    def set_height(self, height):
        self.height = height

class Square(Rectangle):
    # ❌ Square can't use set_width/set_height independently
    def set_width(self, width):
        self.width = width
        self.height = width  # Breaks LSP
```

**Fix:** Use composition or correct hierarchy
```python
class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        pass

class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height
    
    def area(self) -> float:
        return self.width * self.height

class Square(Shape):
    def __init__(self, side):
        self.side = side
    
    def area(self) -> float:
        return self.side ** 2
```

### Temporary Field

**Description:** Instance variables only used in certain cases.

**Example:**
```python
class Calculator:
    def __init__(self):
        self.temp_result = None  # Only used during calculation
        self.debug_info = None   # Only used in debug mode
    
    def calculate(self, x, y):
        self.temp_result = x + y
        if self.debug_mode:
            self.debug_info = f"Added {x} and {y}"
        return self.temp_result
```

**Fix:** Use local variables or separate class
```python
class Calculator:
    def calculate(self, x, y) -> float:
        result = x + y  # Local variable
        if self.debug_mode:
            self._log_debug(f"Added {x} and {y}")
        return result
```

---

## Change Preventers

Code structure makes changes difficult.

### Divergent Change

**Description:** One class changes for multiple different reasons.

**Example:**
```python
class Product:
    def __init__(self, name, price):
        self.name = name
        self.price = price
    
    # Changes when pricing rules change
    def calculate_discount(self):
        if self.price > 100:
            return self.price * 0.1
        return 0
    
    # Changes when tax rules change
    def calculate_tax(self):
        return self.price * 0.08
    
    # Changes when display format changes
    def display(self):
        return f"{self.name}: ${self.price}"
```

**Fix:** Separate concerns
```python
class Product:
    def __init__(self, name, price):
        self.name = name
        self.price = price

class PricingService:
    def calculate_discount(self, product: Product) -> float:
        if product.price > 100:
            return product.price * 0.1
        return 0

class TaxService:
    def calculate_tax(self, product: Product) -> float:
        return product.price * 0.08

class ProductFormatter:
    def display(self, product: Product) -> str:
        return f"{product.name}: ${product.price}"
```

### Shotgun Surgery

**Description:** One change requires many small changes across multiple classes.

**Example:**
```python
# Adding a new field "email" requires changes in:
class UserRepository:
    def save(self, user):
        # Add email to INSERT query

class UserValidator:
    def validate(self, user):
        # Add email validation

class UserFormatter:
    def format(self, user):
        # Add email to output

class UserDTO:
    def __init__(self):
        # Add email field

# 4+ files need changes for one field
```

**Fix:** Centralize related behavior
```python
class User:
    """Centralized user management."""
    
    def __init__(self, name: str, email: str):
        self.name = name
        self.email = self._validate_email(email)
    
    def _validate_email(self, email: str) -> str:
        if '@' not in email:
            raise ValueError("Invalid email")
        return email
    
    def to_dict(self) -> dict:
        return {"name": self.name, "email": self.email}
    
    @classmethod
    def from_dict(cls, data: dict) -> 'User':
        return cls(data["name"], data["email"])

# Now adding a field only requires changes in User class
```

---

## Dispensables

Code that could be removed without losing functionality.

### Dead Code

**Description:** Code that is never executed.

**Example:**
```python
def process_order(self, order):
    # This was used in old version, never called now
    def validate_old_format(order):
        # ...
        pass
    
    # New validation
    self._validate(order)
    self._save(order)
```

**Fix:** Delete it
```python
def process_order(self, order):
    self._validate(order)
    self._save(order)
```

### Speculative Generality

**Description:** Code designed for future use that never comes.

**Example:**
```python
class User:
    def __init__(self, name):
        self.name = name
        self.plugins = []  # For future plugin system that never materializes
        self.hooks = {}    # For future hook system
        self.metadata = {} # For future extensibility
    
    def register_plugin(self, plugin):
        # Never called
        self.plugins.append(plugin)
```

**Fix:** YAGNI - You Aren't Gonna Need It
```python
class User:
    def __init__(self, name):
        self.name = name
    # Add extensibility when actually needed
```

### Duplicate Code

**Description:** Same code structure in multiple places.

**Example:**
```python
def process_payment_credit_card(self, card_number, amount):
    self.logger.info(f"Processing payment: {amount}")
    result = self.gateway.charge(card_number, amount)
    self.logger.info(f"Payment result: {result}")
    return result

def process_payment_paypal(self, paypal_email, amount):
    self.logger.info(f"Processing payment: {amount}")
    result = self.paypal.charge(paypal_email, amount)
    self.logger.info(f"Payment result: {result}")
    return result
```

**Fix:** Extract common code
```python
def _process_payment(self, charge_func, identifier, amount):
    self.logger.info(f"Processing payment: {amount}")
    result = charge_func(identifier, amount)
    self.logger.info(f"Payment result: {result}")
    return result

def process_payment_credit_card(self, card_number, amount):
    return self._process_payment(self.gateway.charge, card_number, amount)

def process_payment_paypal(self, paypal_email, amount):
    return self._process_payment(self.paypal.charge, paypal_email, amount)
```

### Lazy Class

**Description:** Class that doesn't do enough to justify existence.

**Example:**
```python
class EmailAddress:
    def __init__(self, address: str):
        self.address = address
    
    def get_address(self):
        return self.address
    
# That's it - just a wrapper
```

**Fix:** Inline or add more value
```python
# Option 1: Just use string
def send_email(to: str, subject: str, body: str):
    ...

# Option 2: Add validation/behavior
class EmailAddress:
    def __init__(self, address: str):
        if '@' not in address:
            raise ValueError("Invalid email")
        self.address = address
    
    def domain(self) -> str:
        return self.address.split('@')[1]
    
    def is_corporate(self) -> bool:
        return self.domain() not in ['gmail.com', 'yahoo.com']
```

---

## Couplers

Code with too much coupling between classes.

### Feature Envy

**Description:** Method uses another object's data more than its own.

**Example:**
```python
class Order:
    def __init__(self, items: list[Item]):
        self.items = items

class ShippingCalculator:
    def calculate(self, order: Order) -> float:
        # Uses order.items extensively, nothing from self
        total_weight = sum(item.weight for item in order.items)
        total_volume = sum(item.volume for item in order.items)
        is_fragile = any(item.fragile for item in order.items)
        
        base_cost = total_weight * 0.5
        if total_volume > 1000:
            base_cost *= 1.5
        if is_fragile:
            base_cost *= 1.2
        
        return base_cost
```

**Fix:** Move method to the class it uses
```python
class Order:
    def __init__(self, items: list[Item]):
        self.items = items
    
    def calculate_shipping(self) -> float:
        total_weight = sum(item.weight for item in self.items)
        total_volume = sum(item.volume for item in self.items)
        is_fragile = any(item.fragile for item in self.items)
        
        base_cost = total_weight * 0.5
        if total_volume > 1000:
            base_cost *= 1.5
        if is_fragile:
            base_cost *= 1.2
        
        return base_cost
```

### Inappropriate Intimacy

**Description:** Classes know too much about each other's internals.

**Example:**
```python
class Order:
    def __init__(self):
        self._items = []
        self._discount_rate = 0.0
    
    def apply_discount(self, calculator):
        # Calculator knows Order's internal structure
        calculator._apply_to_order(self._items, self._discount_rate)

class DiscountCalculator:
    def _apply_to_order(self, items, discount_rate):
        # Directly manipulates Order internals
        for item in items:
            item.price *= (1 - discount_rate)
```

**Fix:** Use proper interface
```python
class Order:
    def __init__(self):
        self._items = []
        self._discount_rate = 0.0
    
    def apply_discount(self, calculator: DiscountCalculator):
        new_total = calculator.calculate(self.total(), self._discount_rate)
        self._apply_discount_to_items(new_total)
    
    def total(self) -> float:
        return sum(item.price for item in self._items)

class DiscountCalculator:
    def calculate(self, total: float, rate: float) -> float:
        return total * (1 - rate)
```

### Message Chains

**Description:** Client calls a chain of methods to get to object.

**Example:**
```python
# Client code
country = user.get_address().get_location().get_country()
```

**Fix:** Add convenience method (Law of Demeter)
```python
class User:
    def get_country(self) -> str:
        """Get user's country directly."""
        return self.address.location.country

# Client code
country = user.get_country()
```

### Middle Man

**Description:** Class delegates most of its work to another class.

**Example:**
```python
class PersonFacade:
    def __init__(self, person: Person):
        self._person = person
    
    def get_name(self):
        return self._person.get_name()
    
    def get_age(self):
        return self._person.get_age()
    
    def get_email(self):
        return self._person.get_email()
    
    # Just forwarding everything...
```

**Fix:** Remove middle man
```python
# Use Person directly
person = Person()
name = person.get_name()
```

---

## Detection Checklist

Use this checklist during review:

**Bloaters:**
- [ ] Any methods > 50 lines?
- [ ] Any classes > 500 lines?
- [ ] Any parameter lists > 4 parameters?
- [ ] Using primitives for domain concepts?

**OO Abusers:**
- [ ] Complex if/elif chains that could be polymorphic?
- [ ] Subclasses refusing parent behavior?
- [ ] Instance fields only used sometimes?

**Change Preventers:**
- [ ] One class changing for multiple reasons?
- [ ] One change requiring edits in many files?

**Dispensables:**
- [ ] Unused code that could be deleted?
- [ ] Future-proofing that's not needed?
- [ ] Duplicate code that could be extracted?

**Couplers:**
- [ ] Methods using other objects' data extensively?
- [ ] Classes knowing too much about each other?
- [ ] Long chains of method calls?

If you answer "yes" to any question, investigate and potentially refactor.
