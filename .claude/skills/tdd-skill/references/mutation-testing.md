# Mutation Testing

Mutation testing evaluates the quality of your tests by introducing small bugs (mutations) into your code and checking if your tests catch them. If tests still pass with mutated code, the tests aren't thorough enough.

## Core Concept

**Mutation testing answers:** "How good are my tests?"

1. Tool mutates production code (changes `+` to `-`, `==` to `!=`, etc.)
2. Runs test suite against mutated code
3. **Killed mutation:** Tests fail (good - tests caught the bug)
4. **Survived mutation:** Tests pass (bad - tests missed the bug)

**Mutation score:** `killed_mutations / total_mutations * 100%`

Target: 80%+ mutation score for critical code.

## Python: mutmut

**Installation:**
```bash
pip install mutmut
```

**Basic usage:**
```bash
# Run mutation testing
mutmut run

# Show results
mutmut results

# Show specific mutations
mutmut show <mutation_id>

# Show survived mutations only
mutmut show survived

# Apply a mutation to see what changed
mutmut apply <mutation_id>
```

**Example workflow:**

```python
# Original code: calculator.py
def add(a, b):
    return a + b

def multiply(a, b):
    return a * b

# Tests: test_calculator.py
def test_add():
    assert add(2, 3) == 5

def test_multiply():
    assert multiply(2, 3) == 6
```

Run mutmut:
```bash
$ mutmut run
- Mutation testing starting -
Total number of mutations: 4

1. ⚠ Survived: Changed + to - in add function
2. ✓ Killed: Changed return to None in add function  
3. ⚠ Survived: Changed * to / in multiply function
4. ✓ Killed: Changed return to None in multiply function

Mutation score: 50.0%
```

The survived mutations reveal test weaknesses:
- Need test to verify that `add(2, 3) != 2 - 3`
- Need test to verify that `multiply(2, 3) != 2 / 3`

**Improved tests:**
```python
def test_add():
    assert add(2, 3) == 5
    assert add(2, 3) != 2 - 3  # Catches the mutation
    assert add(0, 5) == 5
    assert add(-1, 1) == 0

def test_multiply():
    assert multiply(2, 3) == 6
    assert multiply(2, 3) != 2 / 3  # Catches the mutation
    assert multiply(0, 5) == 0
    assert multiply(-1, 5) == -5
```

**Configuration (.mutmut-config.toml):**
```toml
[mutmut]
paths_to_mutate = "src/"
tests_dir = "tests/"
runner = "pytest -x"

[mutmut.filter]
# Exclude certain mutations
exclude_mutations = ["string"]
```

## TypeScript/JavaScript: Stryker

**Installation:**
```bash
npm install --save-dev @stryker-mutator/core
# For specific test runners:
npm install --save-dev @stryker-mutator/jest-runner
# or
npm install --save-dev @stryker-mutator/vitest-runner
```

**Configuration (stryker.conf.json):**
```json
{
  "$schema": "./node_modules/@stryker-mutator/core/schema/stryker-schema.json",
  "packageManager": "npm",
  "testRunner": "jest",
  "coverageAnalysis": "perTest",
  "mutate": [
    "src/**/*.ts",
    "!src/**/*.test.ts"
  ]
}
```

**Basic usage:**
```bash
# Run mutation testing
npx stryker run

# Generate HTML report
npx stryker run --reporters html
```

**Example:**

```typescript
// calculator.ts
export function add(a: number, b: number): number {
  return a + b;
}

export function multiply(a: number, b: number): number {
  return a * b;
}

// calculator.test.ts
describe('Calculator', () => {
  test('add', () => {
    expect(add(2, 3)).toBe(5);
  });
  
  test('multiply', () => {
    expect(multiply(2, 3)).toBe(6);
  });
});
```

Stryker output:
```
Mutant killed: Changed + to - in add function ✓
Mutant survived: Changed + to * in add function ⚠
Mutant killed: Changed * to / in multiply function ✓
Mutant survived: Changed * to + in multiply function ⚠

Mutation score: 50.0%
```

## Common Mutation Types

**Arithmetic operators:**
```python
# Original
result = a + b

# Mutations
result = a - b  # Addition to subtraction
result = a * b  # Addition to multiplication
result = a / b  # Addition to division
```

**Comparison operators:**
```python
# Original
if x > 5:

# Mutations
if x >= 5:   # Greater than to greater or equal
if x < 5:    # Greater than to less than
if x == 5:   # Greater than to equal
if x != 5:   # Greater than to not equal
```

**Boolean operators:**
```python
# Original
if a and b:

# Mutations
if a or b:   # And to or
if not (a and b):  # Negation
if a:        # Remove second condition
```

**Return values:**
```python
# Original
return True

# Mutations
return False
return None
```

**Constants:**
```python
# Original
limit = 100

# Mutations
limit = 101  # Increment
limit = 99   # Decrement
limit = 0    # Zero
```

## Interpreting Results

**High mutation score (80%+):**
- Tests are thorough
- Edge cases covered
- Good confidence in test suite

**Low mutation score (<60%):**
- Tests are weak
- Missing edge cases
- False sense of security from high code coverage

**Survived mutations indicate:**
- Missing test cases
- Tests too lenient
- Dead code (code that doesn't affect behavior)

## Improving Mutation Score

**Before mutation testing:**
```python
def calculate_discount(price, percent):
    if percent > 0:
        return price - (price * percent / 100)
    return price

# Weak test
def test_calculate_discount():
    assert calculate_discount(100, 10) == 90
```

**Mutmut finds survived mutations:**
```
⚠ Survived: Changed > to >= in if statement
⚠ Survived: Changed - to + in return statement
⚠ Survived: Changed * to / in discount calculation
⚠ Survived: Changed / to * in discount calculation
```

**After improving tests:**
```python
def test_calculate_discount_with_valid_percent():
    assert calculate_discount(100, 10) == 90
    assert calculate_discount(100, 10) != 100 - (100 / 10 / 100)  # Kills operator mutations
    
def test_calculate_discount_with_zero_percent():
    assert calculate_discount(100, 0) == 100  # Kills >= mutation
    
def test_calculate_discount_with_negative_percent():
    assert calculate_discount(100, -5) == 100  # Kills >= mutation
    
def test_calculate_discount_boundary():
    assert calculate_discount(100, 100) == 0
    assert calculate_discount(100, 50) == 50
```

## Integration with TDD

Use mutation testing to validate test quality during refactoring:

```
1. Write tests (TDD Red phase)
2. Implement code (TDD Green phase)
3. Run mutation testing to check test quality
4. Add tests for survived mutations
5. Refactor (TDD Refactor phase)
6. Run mutation testing again to ensure refactoring didn't weaken tests
```

## Performance Considerations

Mutation testing is slow (runs tests hundreds/thousands of times):

**Strategies to speed up:**

1. **Test only changed code:**
```bash
# mutmut - specify paths
mutmut run --paths-to-mutate src/module.py

# Stryker - use incremental mode
npx stryker run --incremental
```

2. **Run in CI only for critical code:**
```yaml
# .github/workflows/mutation-testing.yml
name: Mutation Testing
on:
  pull_request:
    paths:
      - 'src/critical/**'
      
jobs:
  mutation:
    runs-on: ubuntu-latest
    steps:
      - run: mutmut run --paths-to-mutate src/critical/
```

3. **Set timeout limits:**
```toml
# .mutmut-config.toml
[mutmut]
runner = "pytest -x --timeout=10"
```

4. **Use coverage to limit mutations:**
Only mutate code that's already covered by tests.

## When to Use Mutation Testing

**Good fit:**
- Critical business logic
- Security-sensitive code
- Core algorithms
- Refactoring legacy code
- Evaluating test suite quality

**Less suitable:**
- Every commit (too slow)
- Simple CRUD operations
- UI code
- Code with good property-based tests (often redundant)

## Best Practices

1. **Don't chase 100% mutation score** - Some mutations are meaningless
2. **Focus on critical paths** - Prioritize important code
3. **Run regularly but not constantly** - Weekly or per-release
4. **Use with code coverage** - High coverage is prerequisite
5. **Ignore equivalent mutations** - Some mutations don't change behavior
6. **Add survived mutations as regression tests** - Turn findings into permanent tests

## Excluding Meaningless Mutations

Some mutations don't matter:

```python
# Example: Logging mutations often don't matter
def process_data(data):
    logger.info("Processing data")  # Mutating this string doesn't affect logic
    result = complex_calculation(data)
    return result

# Mark for exclusion
def process_data(data):
    logger.info("Processing data")  # pragma: no mutate
    result = complex_calculation(data)
    return result
```

**mutmut exclusions:**
```toml
[mutmut.filter]
exclude_mutations = ["string"]  # Ignore string mutations
```

**Stryker exclusions:**
```json
{
  "mutator": {
    "excludedMutations": ["StringLiteral", "LogStatement"]
  }
}
```

## Mutation Testing vs Code Coverage

**Code coverage answers:** "Which lines were executed?"
**Mutation testing answers:** "Did tests verify the code worked correctly?"

Example showing the difference:

```python
def withdraw(account, amount):
    if account.balance >= amount:  # Line covered
        account.balance -= amount   # Line covered
        return True                 # Line covered
    return False                    # Line covered

# Test with 100% code coverage but weak assertions
def test_withdraw():
    account = Account(balance=100)
    result = withdraw(account, 50)
    # Test doesn't check balance decreased!
    # Just checks function returns True
    assert result == True  # Line covered
```

Mutation testing reveals the weakness:
```
⚠ Survived: Changed -= to += (balance increases instead of decreases)
⚠ Survived: Removed balance -= amount line entirely
```

Fix with proper assertions:
```python
def test_withdraw():
    account = Account(balance=100)
    result = withdraw(account, 50)
    assert result == True
    assert account.balance == 50  # Now mutation is killed
```

## Key Takeaways

1. Mutation testing tests your tests
2. Survived mutations reveal test weaknesses
3. Target 80%+ mutation score for critical code
4. Slower than regular tests - use strategically
5. Complements code coverage, doesn't replace it
6. Focus on killing mutations in critical paths
7. Don't chase 100% - some mutations don't matter
8. Use findings to write better tests
