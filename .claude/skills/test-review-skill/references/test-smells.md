# Test Smells Catalog

A comprehensive guide to identifying and fixing common test smells encountered when reviewing tests before implementation.

## Table of Contents

1. [Clarity & Readability Smells](#clarity--readability-smells)
2. [Completeness Smells](#completeness-smells)
3. [Independence & Isolation Smells](#independence--isolation-smells)
4. [Design Smells](#design-smells)
5. [Assertion Smells](#assertion-smells)
6. [Performance Smells](#performance-smells)

---

## Clarity & Readability Smells

### 1. Mystery Guest

**Description:** Test relies on external data or state that isn't visible in the test itself.

**Example:**
```python
# ❌ Bad: Where does user_data.json come from?
def test_user_import():
    importer = UserImporter()
    result = importer.import_from_file("user_data.json")
    assert len(result) == 5
```

**Fix:**
```python
# ✅ Good: Data is visible in test
def test_user_import():
    # Arrange - create test data explicitly
    test_file = create_temp_file([
        {"name": "Alice", "email": "alice@example.com"},
        {"name": "Bob", "email": "bob@example.com"},
    ])
    
    # Act
    importer = UserImporter()
    result = importer.import_from_file(test_file)
    
    # Assert
    assert len(result) == 2
    assert result[0].name == "Alice"
```

### 2. Unclear Test Names

**Description:** Test name doesn't describe what's being tested or expected outcome.

**Bad examples:**
```python
def test_1():  # ❌ No information
def test_method():  # ❌ Which method? What behavior?
def test_user():  # ❌ What about user?
def test_edge_case():  # ❌ Which edge case?
```

**Good examples:**
```python
def test_withdraw_with_sufficient_funds_decreases_balance()
def test_withdraw_with_insufficient_funds_raises_error()
def test_empty_cart_has_zero_total()
def test_add_duplicate_item_increases_quantity()
```

**Pattern:** `test_<what>_<condition>_<expected_result>`

### 3. Obscure Test

**Description:** Test is hard to understand because of complex setup or unclear assertions.

**Example:**
```python
# ❌ Bad: What's being tested?
def test_process():
    x = [1, 2, 3]
    y = process(x, lambda a: a * 2 if a > 1 else a, True)
    assert y == [1, 4, 6]
```

**Fix:**
```python
# ✅ Good: Clear intent
def test_process_doubles_values_greater_than_one():
    # Arrange
    input_values = [1, 2, 3]
    double_if_greater_than_one = lambda value: value * 2 if value > 1 else value
    
    # Act
    result = process(input_values, double_if_greater_than_one, apply_filter=True)
    
    # Assert
    expected = [1, 4, 6]  # 1 unchanged, 2*2=4, 3*2=6
    assert result == expected
```

### 4. Magic Numbers

**Description:** Test uses unexplained numeric values.

**Example:**
```python
# ❌ Bad: Why these numbers?
def test_discount():
    order = Order(price=100)
    order.apply_discount(15)
    assert order.total() == 85
```

**Fix:**
```python
# ✅ Good: Named constants explain meaning
def test_discount_fifteen_percent_off():
    # Arrange
    original_price = 100
    discount_percent = 15
    expected_price = 85  # 100 - (100 * 0.15)
    
    # Act
    order = Order(price=original_price)
    order.apply_discount(discount_percent)
    
    # Assert
    assert order.total() == expected_price
```

---

## Completeness Smells

### 5. Happy Path Only

**Description:** Only tests successful scenarios, ignoring errors and edge cases.

**Example:**
```python
# ❌ Incomplete: Only tests success
def test_user_login():
    user = User("alice", "password123")
    result = user.login("alice", "password123")
    assert result.success == True
```

**Fix: Add error cases:**
```python
# ✅ Complete: Tests success and failures
def test_user_login_with_correct_credentials_succeeds():
    user = User("alice", "password123")
    result = user.login("alice", "password123")
    assert result.success == True

def test_user_login_with_wrong_password_fails():
    user = User("alice", "password123")
    result = user.login("alice", "wrong_password")
    assert result.success == False

def test_user_login_with_nonexistent_user_fails():
    user = User("alice", "password123")
    result = user.login("bob", "password123")
    assert result.success == False

def test_user_login_with_empty_password_fails():
    user = User("alice", "password123")
    with pytest.raises(ValueError):
        user.login("alice", "")
```

### 6. Missing Boundary Tests

**Description:** Doesn't test edge values, boundaries, or limits.

**Example:**
```python
# ❌ Missing boundaries
def test_age_validator():
    assert validate_age(25) == True
```

**Fix:**
```python
# ✅ Tests boundaries
def test_age_validator_accepts_valid_ages():
    assert validate_age(25) == True

def test_age_validator_rejects_negative_ages():
    assert validate_age(-1) == False

def test_age_validator_accepts_zero():
    assert validate_age(0) == True

def test_age_validator_accepts_minimum_valid_age():
    assert validate_age(18) == True  # If 18 is minimum

def test_age_validator_rejects_below_minimum():
    assert validate_age(17) == False

def test_age_validator_accepts_maximum_realistic_age():
    assert validate_age(120) == True

def test_age_validator_rejects_above_maximum():
    assert validate_age(150) == False
```

### 7. Fragile Test Data

**Description:** Test data is too specific or brittle, making tests fragile.

**Example:**
```python
# ❌ Fragile: Test breaks if CSV format changes slightly
def test_parse_csv():
    csv_data = "Name,Age,City\nAlice,30,NYC\nBob,25,SF"
    result = parse_csv(csv_data)
    assert result[0].name == "Alice"
    assert result[0].age == 30
    assert result[0].city == "NYC"
```

**Fix:**
```python
# ✅ Robust: Tests the contract, not format details
def test_parse_csv_extracts_user_data():
    csv_data = "Name,Age,City\nAlice,30,NYC"
    
    result = parse_csv(csv_data)
    
    assert len(result) == 1
    assert result[0].name == "Alice"
    assert result[0].age == 30
    assert result[0].city == "NYC"

def test_parse_csv_handles_extra_whitespace():
    csv_data = "Name, Age, City\nAlice , 30 , NYC "
    result = parse_csv(csv_data)
    assert result[0].name == "Alice"  # Trimmed
```

---

## Independence & Isolation Smells

### 8. Shared Fixture

**Description:** Tests share mutable state, causing interdependencies.

**Example:**
```python
# ❌ Shared state
shared_cart = ShoppingCart()

def test_add_item():
    shared_cart.add("Widget")
    assert len(shared_cart.items) == 1

def test_remove_item():  # ❌ Assumes add_item ran first
    shared_cart.remove("Widget")
    assert len(shared_cart.items) == 0
```

**Fix:**
```python
# ✅ Independent: Each test creates its own fixture
def test_add_item():
    cart = ShoppingCart()
    cart.add("Widget")
    assert len(cart.items) == 1

def test_remove_item():
    cart = ShoppingCart()
    cart.add("Widget")  # Set up state this test needs
    cart.remove("Widget")
    assert len(cart.items) == 0

# Or use pytest fixtures:
@pytest.fixture
def cart():
    return ShoppingCart()

def test_add_item(cart):
    cart.add("Widget")
    assert len(cart.items) == 1
```

### 9. Test Order Dependency

**Description:** Tests must run in specific order to pass.

**Example:**
```python
# ❌ Order dependent
counter = 0

def test_increment_once():
    global counter
    counter += 1
    assert counter == 1

def test_increment_twice():  # ❌ Assumes previous test ran
    global counter
    counter += 1
    assert counter == 2
```

**Fix:**
```python
# ✅ Order independent
def test_increment_from_zero_to_one():
    counter = Counter(initial=0)
    counter.increment()
    assert counter.value == 1

def test_increment_from_one_to_two():
    counter = Counter(initial=1)
    counter.increment()
    assert counter.value == 2
```

### 10. External Dependency

**Description:** Test depends on external systems (database, network, filesystem).

**Example:**
```python
# ❌ Depends on external database
def test_get_user():
    db = Database("postgresql://production-db")
    user = db.get_user(user_id=123)
    assert user.name == "Alice"
```

**Fix:**
```python
# ✅ Mock external dependency
def test_get_user():
    mock_db = Mock(spec=Database)
    mock_db.get_user.return_value = User(id=123, name="Alice")
    
    service = UserService(mock_db)
    user = service.get_user(user_id=123)
    
    assert user.name == "Alice"
    mock_db.get_user.assert_called_once_with(user_id=123)
```

---

## Design Smells

### 11. Testing Implementation Details

**Description:** Tests are coupled to internal implementation rather than behavior.

**Example:**
```python
# ❌ Tests implementation detail
def test_user_registration_saves_to_cache():
    user_service = UserService()
    
    with patch.object(user_service, '_cache') as mock_cache:
        user_service.register("alice@example.com")
        assert mock_cache.set.called  # ❌ Tests HOW, not WHAT
```

**Fix:**
```python
# ✅ Tests behavior
def test_user_registration_allows_subsequent_retrieval():
    user_service = UserService()
    
    # Act
    user_service.register("alice@example.com")
    
    # Assert behavior: can retrieve registered user
    user = user_service.get_user("alice@example.com")
    assert user is not None
    assert user.email == "alice@example.com"
```

### 12. Over-Mocking

**Description:** Excessive use of mocks obscures real behavior and makes tests brittle.

**Example:**
```python
# ❌ Over-mocked: Tests nothing meaningful
def test_calculate_order_total():
    mock_item1 = Mock()
    mock_item1.get_price.return_value = 10
    mock_item2 = Mock()
    mock_item2.get_price.return_value = 20
    
    mock_calculator = Mock()
    mock_calculator.sum.return_value = 30
    
    # This test is useless
    order = Order(mock_calculator)
    total = order.calculate_total([mock_item1, mock_item2])
    assert total == 30
```

**Fix:**
```python
# ✅ Use real objects when possible
def test_calculate_order_total():
    item1 = OrderItem(name="Widget", price=10)
    item2 = OrderItem(name="Gadget", price=20)
    
    order = Order()
    total = order.calculate_total([item1, item2])
    
    assert total == 30
```

### 13. Conditional Test Logic

**Description:** Tests contain if/else or loops, making them complex.

**Example:**
```python
# ❌ Complex test with conditional logic
def test_user_validation():
    users = [User("alice"), User(""), User("bob")]
    valid_count = 0
    
    for user in users:
        if user.name:
            valid_count += 1
    
    assert valid_count == 2
```

**Fix:**
```python
# ✅ Simple, focused tests
def test_user_with_name_is_valid():
    user = User("alice")
    assert user.is_valid() == True

def test_user_with_empty_name_is_invalid():
    user = User("")
    assert user.is_valid() == False

# If testing multiple inputs, use parametrize:
@pytest.mark.parametrize("name,expected_valid", [
    ("alice", True),
    ("", False),
    ("bob", True),
])
def test_user_validation(name, expected_valid):
    user = User(name)
    assert user.is_valid() == expected_valid
```

### 14. General Fixture

**Description:** Fixture is too general and contains unnecessary setup for most tests.

**Example:**
```python
# ❌ Fixture with unnecessary complexity
@pytest.fixture
def complete_user():
    # Most tests don't need all this
    user = User(
        username="alice",
        email="alice@example.com",
        first_name="Alice",
        last_name="Smith",
        age=30,
        address="123 Main St",
        phone="555-1234",
        subscription="premium",
        preferences={"theme": "dark", "notifications": True}
    )
    return user

def test_user_can_login(complete_user):
    # Only needs username and password
    assert complete_user.login("password") == True
```

**Fix:**
```python
# ✅ Minimal fixtures, compose as needed
@pytest.fixture
def basic_user():
    return User(username="alice", password="password123")

@pytest.fixture
def premium_user(basic_user):
    basic_user.subscription = "premium"
    return basic_user

def test_user_can_login(basic_user):
    assert basic_user.login("password123") == True

def test_premium_user_has_no_ads(premium_user):
    assert premium_user.sees_ads() == False
```

---

## Assertion Smells

### 15. No Assertion

**Description:** Test has no assertions, verifying nothing.

**Example:**
```python
# ❌ No verification
def test_process_data():
    processor = DataProcessor()
    processor.process([1, 2, 3])
    # ❌ Test passes but verifies nothing!
```

**Fix:**
```python
# ✅ Verify the outcome
def test_process_data():
    processor = DataProcessor()
    result = processor.process([1, 2, 3])
    
    assert result is not None
    assert len(result) == 3
    assert result == [2, 4, 6]  # Assuming doubles values
```

### 16. Assertion Roulette

**Description:** Multiple assertions without clear messages, hard to know which failed.

**Example:**
```python
# ❌ Which assertion failed?
def test_user_data():
    user = create_user("alice", "alice@example.com")
    assert user.username == "alice"
    assert user.email == "alice@example.com"
    assert user.is_active == True
    assert user.created_at is not None
    assert user.id > 0
```

**Fix:**
```python
# ✅ Separate tests or descriptive messages
def test_user_creation_sets_username():
    user = create_user("alice", "alice@example.com")
    assert user.username == "alice"

def test_user_creation_sets_email():
    user = create_user("alice", "alice@example.com")
    assert user.email == "alice@example.com"

# Or use descriptive assertion messages:
def test_user_data():
    user = create_user("alice", "alice@example.com")
    assert user.username == "alice", "Username not set correctly"
    assert user.email == "alice@example.com", "Email not set correctly"
    assert user.is_active == True, "User should be active by default"
```

### 17. Weak Assertion

**Description:** Assertion is too vague or doesn't test the right thing.

**Example:**
```python
# ❌ Weak assertions
def test_calculate():
    result = calculate(10, 20)
    assert result  # ❌ Just checks truthy
    assert result != None  # ❌ Too weak
    assert result > 0  # ❌ Doesn't verify actual value
```

**Fix:**
```python
# ✅ Specific assertion
def test_calculate():
    result = calculate(10, 20)
    assert result == 30  # Exact expected value

def test_get_user():
    user = get_user(user_id=1)
    # Don't just assert it exists
    assert isinstance(user, User)
    assert user.id == 1
    assert user.username == "alice"
```

---

## Performance Smells

### 18. Slow Test

**Description:** Test takes too long to run, slowing down feedback loop.

**Example:**
```python
# ❌ Slow: Real HTTP requests
def test_fetch_user_data():
    response = requests.get("https://api.example.com/users/1")
    data = response.json()
    assert data['username'] == "alice"
```

**Fix:**
```python
# ✅ Fast: Mock external calls
@patch('requests.get')
def test_fetch_user_data(mock_get):
    mock_response = Mock()
    mock_response.json.return_value = {'username': 'alice'}
    mock_get.return_value = mock_response
    
    data = fetch_user_data(user_id=1)
    
    assert data['username'] == 'alice'
```

### 19. Sleepy Test

**Description:** Test uses sleep() to wait for operations, making it slow and flaky.

**Example:**
```python
# ❌ Uses sleep
def test_async_operation():
    start_async_task()
    time.sleep(5)  # ❌ Wait for completion
    assert task_completed() == True
```

**Fix:**
```python
# ✅ Use proper async testing or polling with timeout
async def test_async_operation():
    await start_async_task()
    result = await wait_for_completion(timeout=1.0)
    assert result == True

# Or for synchronous polling:
def test_async_operation():
    start_async_task()
    
    # Poll with timeout
    for _ in range(10):  # Max 1 second
        if task_completed():
            break
        time.sleep(0.1)
    
    assert task_completed() == True
```

---

## Quick Smell Detection

**Checklist for reviewers:**

- [ ] Can I understand what's tested just from the test name?
- [ ] Is the AAA structure obvious?
- [ ] Are there error/edge case tests for each happy path?
- [ ] Do tests run independently (no shared state)?
- [ ] Are tests fast (unit tests < 100ms)?
- [ ] Do assertions check specific values, not just "truthy"?
- [ ] Are mocks only used for external dependencies?
- [ ] Will tests survive refactoring?
- [ ] Are test names consistent across the file?
- [ ] Do I see any conditional logic in tests?

If you answer "no" to any question, there's likely a smell to address.
