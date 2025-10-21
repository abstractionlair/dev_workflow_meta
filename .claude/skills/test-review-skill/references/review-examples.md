# Test Review Examples

Complete examples of test reviews showing the before/after of common scenarios.

## Example 1: Basic Function Test Review

### Original Test Submission

```python
# test_calculator.py
def test_add():
    c = Calculator()
    assert c.add(2, 3) == 5
```

### Review Output

```
Summary: Basic test structure is present but incomplete. Missing critical test cases 
and clarity issues. Needs work before implementation.

Critical Issues:
❌ test_add: Name doesn't specify what behavior is being tested
   Impact: Unclear what scenario this covers
   Fix: Rename to test_add_two_positive_numbers_returns_sum
   
📋 Missing critical test cases:
   1. test_add_negative_numbers_returns_correct_sum
   2. test_add_with_zero_returns_other_number
   3. test_add_large_numbers_doesnt_overflow
   
   Example:
   def test_add_negative_numbers_returns_correct_sum():
       calc = Calculator()
       result = calc.add(-5, -3)
       assert result == -8

Important Issues:
⚠️  Single-letter variable name 'c' reduces clarity
   Better: calc = Calculator()

Suggestions:
💡 Consider parametrized test for multiple input combinations:
   @pytest.mark.parametrize("a,b,expected", [
       (2, 3, 5),
       (-5, -3, -8),
       (0, 5, 5),
   ])
   def test_add_returns_sum(a, b, expected):
       calc = Calculator()
       assert calc.add(a, b) == expected

Positive:
✅ Uses clear assertion with expected value
✅ Test is fast and focused
```

### Revised Tests

```python
# test_calculator.py
import pytest

class TestCalculatorAdd:
    """Tests for Calculator.add() method."""
    
    def test_add_two_positive_numbers_returns_sum(self):
        calc = Calculator()
        result = calc.add(2, 3)
        assert result == 5
    
    def test_add_negative_numbers_returns_correct_sum(self):
        calc = Calculator()
        result = calc.add(-5, -3)
        assert result == -8
    
    def test_add_with_zero_returns_other_number(self):
        calc = Calculator()
        assert calc.add(5, 0) == 5
        assert calc.add(0, 5) == 5
    
    def test_add_handles_large_numbers(self):
        calc = Calculator()
        result = calc.add(1_000_000, 2_000_000)
        assert result == 3_000_000
```

---

## Example 2: Class Method Review with State

### Original Test Submission

```python
# test_account.py
account = Account(100)

def test_withdraw():
    account.withdraw(30)
    assert account.balance == 70

def test_deposit():
    account.deposit(50)
    assert account.balance == 150
```

### Review Output

```
Summary: CRITICAL ISSUES - Tests share mutable state and will fail when run 
independently. Must fix before implementation.

Critical Issues:
❌ Shared mutable state (module-level 'account' variable)
   Impact: Tests are interdependent and order-sensitive
   - test_deposit assumes test_withdraw ran first (expects balance of 70)
   - Tests will fail if run in isolation or different order
   - Cannot run tests in parallel
   
   Fix: Create separate account instance in each test
   
   @pytest.fixture
   def account():
       return Account(balance=100)
   
   def test_withdraw(account):
       account.withdraw(30)
       assert account.balance == 70

❌ test_withdraw: Incomplete test name
   Fix: test_withdraw_with_sufficient_funds_decreases_balance

❌ test_deposit: Incomplete test name
   Fix: test_deposit_increases_balance_by_deposited_amount

📋 Missing critical error cases:
   1. test_withdraw_with_insufficient_funds_raises_error
   2. test_withdraw_negative_amount_raises_error
   3. test_deposit_negative_amount_raises_error
   
   def test_withdraw_with_insufficient_funds_raises_error():
       account = Account(balance=50)
       with pytest.raises(InsufficientFundsError):
           account.withdraw(60)

Important Issues:
⚠️  No test for withdraw with exact balance
   Add: test_withdraw_exact_balance_results_in_zero_balance

⚠️  No test for zero amount operations
   Add: test_withdraw_zero_leaves_balance_unchanged
   Add: test_deposit_zero_leaves_balance_unchanged

Suggestions:
💡 Consider testing initial state:
   def test_new_account_has_specified_balance():
       account = Account(balance=100)
       assert account.balance == 100

💡 Group related tests in a class:
   class TestAccountWithdraw:
       # All withdraw tests here
   
   class TestAccountDeposit:
       # All deposit tests here
```

### Revised Tests

```python
# test_account.py
import pytest

@pytest.fixture
def account():
    """Fixture providing a fresh account for each test."""
    return Account(balance=100)

class TestAccountWithdraw:
    """Tests for Account.withdraw() method."""
    
    def test_withdraw_with_sufficient_funds_decreases_balance(self):
        # Arrange
        account = Account(balance=100)
        
        # Act
        account.withdraw(30)
        
        # Assert
        assert account.balance == 70
    
    def test_withdraw_with_insufficient_funds_raises_error(self):
        account = Account(balance=50)
        
        with pytest.raises(InsufficientFundsError, match="Insufficient funds"):
            account.withdraw(60)
    
    def test_withdraw_exact_balance_results_in_zero(self):
        account = Account(balance=100)
        account.withdraw(100)
        assert account.balance == 0
    
    def test_withdraw_negative_amount_raises_error(self):
        account = Account(balance=100)
        
        with pytest.raises(ValueError, match="Amount must be positive"):
            account.withdraw(-10)
    
    def test_withdraw_zero_leaves_balance_unchanged(self):
        account = Account(balance=100)
        account.withdraw(0)
        assert account.balance == 100


class TestAccountDeposit:
    """Tests for Account.deposit() method."""
    
    def test_deposit_increases_balance_by_deposited_amount(self):
        # Arrange
        account = Account(balance=100)
        
        # Act
        account.deposit(50)
        
        # Assert
        assert account.balance == 150
    
    def test_deposit_negative_amount_raises_error(self):
        account = Account(balance=100)
        
        with pytest.raises(ValueError, match="Amount must be positive"):
            account.deposit(-20)
    
    def test_deposit_zero_leaves_balance_unchanged(self):
        account = Account(balance=100)
        account.deposit(0)
        assert account.balance == 100
```

---

## Example 3: Testing Implementation Details

### Original Test Submission

```python
# test_user_service.py
from unittest.mock import patch, Mock

def test_register_user():
    mock_db = Mock()
    mock_cache = Mock()
    mock_logger = Mock()
    
    service = UserService(mock_db, mock_cache, mock_logger)
    
    with patch.object(service, '_hash_password') as mock_hash:
        with patch.object(service, '_send_welcome_email') as mock_email:
            mock_hash.return_value = "hashed_password"
            
            service.register("alice@example.com", "password123")
            
            # Check internal method calls
            assert mock_hash.called
            assert mock_email.called
            mock_db.save.assert_called()
            mock_cache.set.assert_called()
            mock_logger.info.assert_called()
```

### Review Output

```
Summary: Test is overly focused on implementation details and uses excessive mocking.
Will be extremely brittle and won't catch real bugs. Needs complete redesign.

Critical Issues:
❌ Testing implementation details instead of behavior
   Problem: Test checks internal method calls (_hash_password, _send_welcome_email)
   Impact: Test will break on any refactoring even if behavior is correct
   
   What you should test:
   - Can register a user with valid email/password
   - Can retrieve the registered user afterward
   - Cannot register duplicate email
   - Invalid input raises appropriate errors
   
   Not:
   - Whether specific internal methods were called
   - Whether password was hashed (implementation detail)
   - Whether cache was updated (implementation detail)

❌ Over-mocking (5 mocks for a single operation)
   Problem: With this many mocks, test verifies mock interactions, not real behavior
   Impact: Test becomes meaningless - just verifies you set up mocks correctly
   
   Reconsider:
   - Do you need to mock the database? (Use test database or in-memory)
   - Mock only true external dependencies (email service)
   - Use real cache implementation or in-memory variant

❌ Patching private methods (_hash_password, _send_welcome_email)
   Problem: These are implementation details that should not be tested directly
   Impact: Cannot refactor internal structure without breaking tests

Important Issues:
⚠️  No assertions on actual outcome
   What's missing: 
   - Was user actually created?
   - Can we retrieve the user?
   - Is user data correct?

⚠️  No error case tests
   Add:
   - test_register_with_invalid_email_raises_error
   - test_register_duplicate_email_raises_error
   - test_register_weak_password_raises_error

Suggestions:
💡 Use integration test approach instead:
   - Use in-memory database for testing
   - Mock only external email service
   - Test actual behavior: can register and retrieve user
```

### Revised Tests

```python
# test_user_service.py
import pytest
from unittest.mock import Mock

@pytest.fixture
def user_service():
    """Service with in-memory database and mocked email."""
    db = InMemoryDatabase()  # Real database behavior, just in-memory
    email_service = Mock(spec=EmailService)  # Mock external service only
    return UserService(db, email_service)


class TestUserRegistration:
    """Tests for UserService.register() behavior."""
    
    def test_register_valid_user_creates_user_account(self, user_service):
        # Act
        user_id = user_service.register("alice@example.com", "SecurePass123!")
        
        # Assert - test behavior, not implementation
        assert user_id is not None
        
        # Can retrieve user after registration
        user = user_service.get_user_by_email("alice@example.com")
        assert user is not None
        assert user.email == "alice@example.com"
        assert user.is_active == True
    
    def test_register_user_sends_welcome_email(self, user_service):
        # Act
        user_service.register("alice@example.com", "SecurePass123!")
        
        # Assert - verify external side effect (email sent)
        user_service.email_service.send_welcome.assert_called_once()
        call_args = user_service.email_service.send_welcome.call_args
        assert call_args[0][0] == "alice@example.com"
    
    def test_register_with_duplicate_email_raises_error(self, user_service):
        # Arrange
        user_service.register("alice@example.com", "Password123!")
        
        # Act & Assert
        with pytest.raises(DuplicateEmailError):
            user_service.register("alice@example.com", "DifferentPass456!")
    
    def test_register_with_invalid_email_raises_error(self, user_service):
        with pytest.raises(InvalidEmailError):
            user_service.register("not-an-email", "Password123!")
    
    def test_register_with_weak_password_raises_error(self, user_service):
        with pytest.raises(WeakPasswordError):
            user_service.register("alice@example.com", "weak")
    
    def test_registered_user_password_is_hashed(self, user_service):
        # Don't test _hash_password was called
        # Instead, test the outcome: stored password is not plaintext
        
        user_service.register("alice@example.com", "Password123!")
        user = user_service.get_user_by_email("alice@example.com")
        
        # Password should be hashed (not equal to plaintext)
        assert user.password_hash != "Password123!"
        # And should be able to verify with original password
        assert user_service.verify_password(user, "Password123!") == True
```

---

## Example 4: TypeScript API Testing

### Original Test Submission

```typescript
// user.test.ts
describe('UserAPI', () => {
  it('works', async () => {
    const api = new UserAPI();
    const result = await api.getUser(1);
    expect(result).toBeDefined();
  });
});
```

### Review Output

```
Summary: Extremely weak test that verifies almost nothing. Test name is non-descriptive
and assertions are too vague. Not ready for implementation.

Critical Issues:
❌ Test name 'works' is meaningless
   Fix: Describe what behavior you're testing
   - test_getUser_with_valid_id_returns_user_object
   - test_getUser_with_invalid_id_throws_error

❌ Assertion 'toBeDefined()' is too weak
   Problem: Just checks result exists, not that it's correct
   Fix: Check specific properties:
   - expect(result.id).toBe(1);
   - expect(result.username).toBe('alice');
   - expect(result.email).toMatch(/@/);

📋 Missing critical test cases:
   1. What happens with invalid user ID?
   2. What happens with negative ID?
   3. What happens with non-existent user?
   4. Does it handle network errors?
   
   Examples:
   it('should throw error when user not found', async () => {
     const api = new UserAPI();
     await expect(api.getUser(999)).rejects.toThrow(NotFoundError);
   });
   
   it('should throw error for invalid user ID', async () => {
     const api = new UserAPI();
     await expect(api.getUser(-1)).rejects.toThrow(ValidationError);
   });

Important Issues:
⚠️  No setup/teardown visible
   Consider: Does API need configuration? Mock HTTP client?

⚠️  No error handling tests
   Add tests for network failures, timeouts, invalid responses

Suggestions:
💡 Structure tests by scenario:
   describe('getUser', () => {
     describe('when user exists', () => {
       it('should return user data', ...);
     });
     
     describe('when user does not exist', () => {
       it('should throw NotFoundError', ...);
     });
   });

💡 Mock HTTP client to avoid real API calls:
   const mockClient = {
     get: jest.fn()
   };
```

### Revised Tests

```typescript
// user.test.ts
import { UserAPI } from './user-api';
import { NotFoundError, ValidationError, NetworkError } from './errors';

describe('UserAPI', () => {
  let api: UserAPI;
  let mockHttpClient: any;
  
  beforeEach(() => {
    // Arrange - create mock HTTP client
    mockHttpClient = {
      get: jest.fn()
    };
    api = new UserAPI(mockHttpClient);
  });
  
  describe('getUser', () => {
    describe('when user exists', () => {
      it('should return user with correct data', async () => {
        // Arrange
        const mockUserData = {
          id: 1,
          username: 'alice',
          email: 'alice@example.com',
          created_at: '2024-01-01T00:00:00Z'
        };
        mockHttpClient.get.mockResolvedValue(mockUserData);
        
        // Act
        const result = await api.getUser(1);
        
        // Assert
        expect(result).toEqual(mockUserData);
        expect(result.id).toBe(1);
        expect(result.username).toBe('alice');
        expect(mockHttpClient.get).toHaveBeenCalledWith('/users/1');
      });
      
      it('should call correct API endpoint', async () => {
        mockHttpClient.get.mockResolvedValue({ id: 5 });
        
        await api.getUser(5);
        
        expect(mockHttpClient.get).toHaveBeenCalledWith('/users/5');
        expect(mockHttpClient.get).toHaveBeenCalledTimes(1);
      });
    });
    
    describe('when user does not exist', () => {
      it('should throw NotFoundError', async () => {
        // Arrange
        mockHttpClient.get.mockRejectedValue(new Error('404 Not Found'));
        
        // Act & Assert
        await expect(api.getUser(999))
          .rejects
          .toThrow(NotFoundError);
      });
    });
    
    describe('with invalid input', () => {
      it('should throw ValidationError for negative ID', async () => {
        await expect(api.getUser(-1))
          .rejects
          .toThrow(ValidationError);
        
        // Should not even call HTTP client
        expect(mockHttpClient.get).not.toHaveBeenCalled();
      });
      
      it('should throw ValidationError for zero ID', async () => {
        await expect(api.getUser(0))
          .rejects
          .toThrow(ValidationError);
      });
      
      it('should throw ValidationError for non-integer ID', async () => {
        await expect(api.getUser(1.5 as any))
          .rejects
          .toThrow(ValidationError);
      });
    });
    
    describe('when network error occurs', () => {
      it('should throw NetworkError', async () => {
        // Arrange
        mockHttpClient.get.mockRejectedValue(new Error('Network timeout'));
        
        // Act & Assert
        await expect(api.getUser(1))
          .rejects
          .toThrow(NetworkError);
      });
    });
  });
});
```

---

## Example 5: Testing Async Operations

### Original Test Submission

```python
# test_async_processor.py
import asyncio

def test_process_data():
    processor = AsyncDataProcessor()
    asyncio.run(processor.process([1, 2, 3]))
    # No assertion!
```

### Review Output

```
Summary: Critical issues - no assertions and doesn't properly test async behavior.
Must be fixed before implementation.

Critical Issues:
❌ No assertions - test verifies nothing
   Problem: Test runs code but doesn't check outcome
   Fix: Assert on return value or side effects
   
   result = asyncio.run(processor.process([1, 2, 3]))
   assert result == [2, 4, 6]  # Or whatever expected output is

❌ Doesn't use pytest-asyncio properly
   Problem: Using asyncio.run() instead of async test function
   Impact: Can't properly test async behavior, exceptions, or concurrent operations
   
   Fix: Use async test function:
   @pytest.mark.asyncio
   async def test_process_data():
       processor = AsyncDataProcessor()
       result = await processor.process([1, 2, 3])
       assert result is not None

📋 Missing critical async-specific tests:
   1. test_process_handles_concurrent_calls
   2. test_process_with_cancellation
   3. test_process_timeout_behavior
   4. test_process_error_propagation

Important Issues:
⚠️  No test for what process() actually does
   Specify: What should process([1, 2, 3]) return?

⚠️  No error case tests
   Add: What happens with empty list? Invalid data?
```

### Revised Tests

```python
# test_async_processor.py
import pytest
import asyncio

@pytest.fixture
def processor():
    return AsyncDataProcessor()


class TestAsyncDataProcessor:
    """Tests for AsyncDataProcessor.process() method."""
    
    @pytest.mark.asyncio
    async def test_process_doubles_each_value(self, processor):
        # Arrange
        input_data = [1, 2, 3]
        
        # Act
        result = await processor.process(input_data)
        
        # Assert
        assert result == [2, 4, 6]
    
    @pytest.mark.asyncio
    async def test_process_empty_list_returns_empty_list(self, processor):
        result = await processor.process([])
        assert result == []
    
    @pytest.mark.asyncio
    async def test_process_handles_concurrent_calls(self, processor):
        # Act - run multiple processes concurrently
        results = await asyncio.gather(
            processor.process([1, 2]),
            processor.process([3, 4]),
            processor.process([5, 6])
        )
        
        # Assert
        assert results[0] == [2, 4]
        assert results[1] == [6, 8]
        assert results[2] == [10, 12]
    
    @pytest.mark.asyncio
    async def test_process_with_invalid_data_raises_error(self, processor):
        with pytest.raises(ValueError):
            await processor.process([1, "invalid", 3])
    
    @pytest.mark.asyncio
    async def test_process_respects_timeout(self, processor):
        # Configure processor with 1 second timeout
        processor.timeout = 1.0
        
        # This should timeout
        with pytest.raises(asyncio.TimeoutError):
            await processor.process([1] * 1000000)  # Huge list
    
    @pytest.mark.asyncio
    async def test_process_can_be_cancelled(self, processor):
        # Arrange
        task = asyncio.create_task(processor.process([1] * 1000))
        
        # Act - cancel after short delay
        await asyncio.sleep(0.01)
        task.cancel()
        
        # Assert
        with pytest.raises(asyncio.CancelledError):
            await task
```

---

## Key Review Patterns

### Pattern: Incomplete Coverage
Look for happy path only → Request error cases, edge cases, boundaries

### Pattern: Shared State
Look for module-level variables → Request fixtures or per-test instantiation

### Pattern: Vague Names
Look for test_method() → Request test_method_condition_result()

### Pattern: Weak Assertions
Look for assert result → Request assert result == expected_value

### Pattern: Implementation Testing
Look for mock patches on private methods → Request behavior testing

### Pattern: Over-Mocking
Look for 3+ mocks → Question if integration test is better

### Pattern: No Async Handling
Look for asyncio.run() in tests → Request @pytest.mark.asyncio

### Pattern: No Error Tests
Look for only success scenarios → Request error/exception tests
