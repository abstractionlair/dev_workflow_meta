# Property-Based Testing

Property-based testing generates test cases automatically by defining properties that should always hold true, rather than writing individual example-based tests.

## Core Concept

Instead of:
```python
def test_reverse_twice_returns_original():
    assert reverse(reverse([1, 2, 3])) == [1, 2, 3]
    assert reverse(reverse([5])) == [5]
    assert reverse(reverse([])) == []
```

Write:
```python
@given(st.lists(st.integers()))
def test_reverse_twice_returns_original(lst):
    assert reverse(reverse(lst)) == lst
```

The framework generates hundreds of test cases automatically.

## Python: Hypothesis

**Installation:**
```bash
pip install hypothesis
```

**Basic usage:**
```python
from hypothesis import given, strategies as st

@given(st.integers())
def test_addition_is_commutative(x):
    y = 5
    assert x + y == y + x

@given(st.lists(st.integers()))
def test_sorting_is_idempotent(lst):
    sorted_once = sorted(lst)
    sorted_twice = sorted(sorted_once)
    assert sorted_once == sorted_twice

@given(st.integers(min_value=0, max_value=100))
def test_discount_never_negative(price):
    discount = calculate_discount(price, percent=10)
    assert discount >= 0
```

**Common strategies:**
```python
from hypothesis import strategies as st

# Primitives
st.integers()
st.integers(min_value=0, max_value=100)
st.floats(min_value=0.0, max_value=1.0)
st.text()
st.text(min_size=1, max_size=10)
st.booleans()

# Collections
st.lists(st.integers())
st.lists(st.text(), min_size=1, max_size=5)
st.tuples(st.integers(), st.text())
st.dictionaries(keys=st.text(), values=st.integers())

# Compositions
st.one_of(st.integers(), st.text())  # Either int or text
st.none() | st.integers()  # Optional integer
```

**Custom strategies:**
```python
@st.composite
def email_strategy(draw):
    local = draw(st.text(min_size=1, max_size=20, alphabet=st.characters(whitelist_categories=('Ll', 'Nd'))))
    domain = draw(st.sampled_from(['example.com', 'test.org', 'mail.net']))
    return f"{local}@{domain}"

@given(email_strategy())
def test_email_validation(email):
    assert is_valid_email(email)
```

**Stateful testing:**
```python
from hypothesis.stateful import RuleBasedStateMachine, rule, invariant

class AccountMachine(RuleBasedStateMachine):
    def __init__(self):
        super().__init__()
        self.balance = 0
    
    @rule(amount=st.integers(min_value=1, max_value=1000))
    def deposit(self, amount):
        self.balance += amount
    
    @rule(amount=st.integers(min_value=1, max_value=100))
    def withdraw(self, amount):
        if self.balance >= amount:
            self.balance -= amount
    
    @invariant()
    def balance_non_negative(self):
        assert self.balance >= 0

TestAccount = AccountMachine.TestCase
```

## TypeScript: fast-check

**Installation:**
```bash
npm install --save-dev fast-check
```

**Basic usage:**
```typescript
import fc from 'fast-check';

test('addition is commutative', () => {
  fc.assert(
    fc.property(fc.integer(), fc.integer(), (a, b) => {
      return a + b === b + a;
    })
  );
});

test('sorting is idempotent', () => {
  fc.assert(
    fc.property(fc.array(fc.integer()), (arr) => {
      const sortedOnce = [...arr].sort();
      const sortedTwice = [...sortedOnce].sort();
      return JSON.stringify(sortedOnce) === JSON.stringify(sortedTwice);
    })
  );
});
```

**Common arbitraries:**
```typescript
import fc from 'fast-check';

// Primitives
fc.integer()
fc.integer({ min: 0, max: 100 })
fc.float()
fc.boolean()
fc.string()
fc.string({ minLength: 1, maxLength: 10 })

// Collections
fc.array(fc.integer())
fc.array(fc.string(), { minLength: 1, maxLength: 5 })
fc.tuple(fc.integer(), fc.string())
fc.record({ name: fc.string(), age: fc.integer() })

// Combinations
fc.oneof(fc.integer(), fc.string())
fc.option(fc.integer())  // null or integer
```

**Custom arbitraries:**
```typescript
const emailArbitrary = fc.tuple(
  fc.stringOf(fc.constantFrom('abcdefghijklmnopqrstuvwxyz0123456789'), { minLength: 1, maxLength: 20 }),
  fc.constantFrom('example.com', 'test.org', 'mail.net')
).map(([local, domain]) => `${local}@${domain}`);

test('email validation', () => {
  fc.assert(
    fc.property(emailArbitrary, (email) => {
      return isValidEmail(email);
    })
  );
});
```

## Properties to Test

Good properties are invariants that should always hold:

**Inverse operations:**
```python
# encode/decode
@given(st.text())
def test_decode_encode_roundtrip(text):
    assert decode(encode(text)) == text

# serialize/deserialize
@given(st.integers())
def test_json_roundtrip(value):
    assert json.loads(json.dumps(value)) == value
```

**Idempotence:**
```python
@given(st.lists(st.integers()))
def test_sort_is_idempotent(lst):
    assert sorted(sorted(lst)) == sorted(lst)

@given(st.text())
def test_lowercase_is_idempotent(text):
    assert text.lower().lower() == text.lower()
```

**Invariants:**
```python
@given(st.lists(st.integers()))
def test_filter_reduces_or_maintains_length(lst):
    filtered = [x for x in lst if x > 0]
    assert len(filtered) <= len(lst)

@given(st.integers(min_value=1, max_value=1000))
def test_cache_size_never_exceeds_limit(item):
    cache = LRUCache(max_size=10)
    cache.put(item, f"value_{item}")
    assert cache.size() <= 10
```

**Commutativity:**
```python
@given(st.integers(), st.integers())
def test_addition_is_commutative(a, b):
    assert a + b == b + a

@given(st.sets(st.integers()), st.sets(st.integers()))
def test_set_union_is_commutative(set1, set2):
    assert set1.union(set2) == set2.union(set1)
```

**Associativity:**
```python
@given(st.integers(), st.integers(), st.integers())
def test_addition_is_associative(a, b, c):
    assert (a + b) + c == a + (b + c)
```

## Integration with Traditional TDD

Property-based testing complements example-based tests:

```python
# Example-based tests for specific known cases
def test_empty_list_sum_is_zero():
    assert sum([]) == 0

def test_single_element_sum():
    assert sum([5]) == 5

# Property-based test for general behavior
@given(st.lists(st.integers()))
def test_sum_of_list_equals_sum_of_reversed(lst):
    assert sum(lst) == sum(reversed(lst))

@given(st.lists(st.integers()), st.integers())
def test_sum_with_constant_added_to_each(lst, constant):
    original_sum = sum(lst)
    modified_sum = sum(x + constant for x in lst)
    assert modified_sum == original_sum + constant * len(lst)
```

## When to Use Property-Based Testing

**Good fit:**
- Functions with clear mathematical properties
- Data transformations (parsing, encoding, serialization)
- Algorithms with invariants (sorting, caching, compression)
- Finding edge cases automatically

**Less suitable:**
- Business logic with complex conditional rules
- Integration tests with external dependencies
- Code where properties are hard to define
- When specific examples are more valuable than generated ones

## Debugging Failed Property Tests

When Hypothesis/fast-check finds a failing case:

```python
from hypothesis import given, strategies as st, seed

# Hypothesis prints the failing example:
# Falsifying example: test_example(x=12345)

# Use seed to reproduce
@seed(12345)
@given(st.integers())
def test_example(x):
    # Now runs with the same random seed
    assert some_function(x) > 0

# Or use example decorator for regression test
from hypothesis import example

@given(st.integers())
@example(12345)  # Always test this case
def test_example(x):
    assert some_function(x) > 0
```

## Configuration

**Python (Hypothesis):**
```python
from hypothesis import given, settings, strategies as st

@settings(max_examples=1000)  # Run more examples
@given(st.integers())
def test_with_more_examples(x):
    assert abs(x) >= 0

@settings(deadline=None)  # Disable timeout
@given(st.lists(st.integers(), min_size=1000))
def test_slow_operation(lst):
    result = expensive_operation(lst)
    assert len(result) > 0
```

**TypeScript (fast-check):**
```typescript
fc.assert(
  fc.property(fc.integer(), (x) => {
    return Math.abs(x) >= 0;
  }),
  { numRuns: 1000 }  // More examples
);
```

## Key Takeaways

1. Properties describe what should always be true
2. Framework generates hundreds of test cases
3. Excellent for finding edge cases you didn't think of
4. Complements example-based tests, doesn't replace them
5. Best for algorithmic code with clear invariants
6. When test fails, add it as example-based regression test
