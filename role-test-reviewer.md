---
role: Test Reviewer
trigger: After tests are written and before implementation begins
typical_scope: Complete test suite for one feature
---

# Test Reviewer

## Responsibilities

Verify that test suites comprehensively cover specification requirements, follow TDD principles (fail appropriately before implementation), use proper testing practices, and will effectively prevent regressions. This review ensures tests serve as reliable contracts for implementation.

## Collaboration Pattern

This is typically an **independent role** - the reviewer works separately from the test writer.

**Reviewer responsibilities:**
- Verify test coverage matches spec requirements
- Confirm tests achieve valid TDD red state
- Check test quality and maintainability
- Identify missing test cases
- Approve or request additions/changes

**Feedback flow:**
1. Test writer marks tests as "ready for review"
2. Reviewer reads spec and runs tests independently
3. Reviewer provides structured feedback
4. Test writer addresses gaps or issues
5. Reviewer approves when quality bar is met

**Collaborative tone:**
- Reviews guide the test writer, not judge them
- Focus on the work, not the worker
- Use: "Tests expect X but skeleton has Y"
- Avoid: "Writer ignored/failed to/incorrectly did X"

## Inputs

### Code Being Reviewed
- Test files created by test writer
- Test fixtures and mocks

### Supporting Context
- **Approved specification**: To verify complete coverage
- **Skeleton interfaces**: To understand what's being tested
- **BUG_LEDGER.yml**: To verify sentinel tests exist
- **Existing test suite**: To verify consistency with project patterns

## Understanding TDD Red State

### Valid Red State ✅
Tests fail because **unimplemented methods** raise NotImplementedError:
```python
def reconcile(self, entity_id: str):
    raise NotImplementedError("Reconciliation not yet implemented")
```
Result: Test calls `reconcile()` → NotImplementedError → Test fails (expected)

### Invalid Red State ❌
Tests error because of **framework or structural issues**:
- ImportError (wrong module paths)
- AttributeError (method doesn't exist on object)
- NameError (class/function not defined)
- Tests can't instantiate objects because `__init__` raises NotImplementedError

**Critical**: Framework errors must be fixed BEFORE approval can be considered. Tests must fail due to unimplemented business logic, not broken infrastructure.

## Two Separate Concerns

The review assesses TWO INDEPENDENT things:

### Concern 1: Specification Coverage
**Question**: "Do tests exist that conceptually cover all spec requirements?"

This is what the **Coverage Matrix** assesses - whether the test writer thought about and wrote tests for each spec section.

### Concern 2: Execution & Architecture
**Question**: "Do tests match the skeleton and execute properly?"

This is what **Critical Issues** address - import errors, method mismatches, framework problems.

**Why separate?**
- Tests can have great coverage but wrong imports (Concern 1: ✓, Concern 2: ✗)
- Tests can execute perfectly but miss requirements (Concern 1: ✗, Concern 2: ✓)
- Keep these concerns separate in your review

## Review Protocol

### All-In Review Approach
**Review the COMPLETE suite for the feature as a single unit**, not per contributor.

Even if multiple people/models contributed to the test file, the approval applies to the entire suite. This ensures:
- Holistic coverage assessment
- No gaps between different contributors' sections  
- Consistent quality across the whole suite
- Single source of truth for approval

### Output Format
Create timestamped review file:
```
reviews/tests/YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md
```

Where STATUS ∈ {APPROVED, NEEDS-CHANGES}

Use seconds to avoid filename collisions (e.g., `2025-01-23T14-30-47-weather-cache-APPROVED.md`)

### Outcomes

**APPROVED**: 
- Suite ready for implementation to target
- Move forward with confidence in test contract

**NEEDS-CHANGES**: 
- Return concrete gaps and fixes
- Test writer addresses issues
- Re-review after changes

## Process

### 1. Read Specification First
Before looking at tests:
- Understand all specified behaviors
- Note happy paths, edge cases, error conditions
- Identify integration points
- Check BUG_LEDGER.yml for relevant bugs

### 2. Run the Test Suite
Execute tests to verify TDD red state:
```bash
pytest tests/unit/test_feature.py -v
pytest tests/integration/test_feature.py -v
```

Check that:
- All new tests fail (red state)
- Failures are due to NotImplementedError (not test bugs)
- Failure messages are clear and helpful
- **No import errors or test framework issues** (critical)

### 3. Create Coverage Matrix

**Purpose**: Verify that tests exist for all spec requirements.

**Status values:**
- ✓ = Test exists that conceptually covers this requirement
- ✓ (note) = Test exists but has execution/architecture issues *
- ⚠️ = Partial coverage or weak test
- ✗ = No test found for this requirement

\* Note execution issues in Critical Issues section, not here

**Example Matrix:**
```markdown
| Spec Section | Test Coverage | Status |
|--------------|---------------|--------|
| FR1 Multi-source | test_reconcile_primary_success | ✓ |
| FR2.1 Primary fail | test_fallback_to_secondary | ✓ (import error) |
| FR2.2 All fail | **MISSING** | ✗ |
```

In this example:
- FR1: Test exists ✓
- FR2.1: Test exists ✓, but has import error (noted, addressed in Critical Issues)
- FR2.2: No test exists ✗

**Don't confuse:**
- "Test covers FR1" ≠ "Test executes without errors"
- Coverage matrix = Concern 1 only
- Execution issues = Concern 2, addressed separately

### 4. Check Test Quality
Review test code for:
- [ ] Clear test names (describe what's being tested)
- [ ] Proper Arrange-Act-Assert structure
- [ ] One assertion per test (or related assertions)
- [ ] No test interdependencies
- [ ] Appropriate use of fixtures/mocks
- [ ] Good docstrings explaining test purpose

### 5. Verify Sentinel Tests
For each relevant bug in BUG_LEDGER.yml:
- [ ] Sentinel test exists?
- [ ] Test references bug ID?
- [ ] Test would catch the bug?

### 6. Check Test Organization
- [ ] Tests in correct directories (unit/ integration/)?
- [ ] Logical file organization?
- [ ] Single coherent file per feature?
- [ ] Fixtures properly shared?
- [ ] Follows project test conventions?

### 7. Verify Attribution (if multiple contributors)
If test file has contributions from multiple people/models:
- [ ] Inline section comments present?
- [ ] Format correct: `# === Tests by <name> (<Date>) ===`?
- [ ] Clear boundaries between sections?
- [ ] No confusion about who wrote what?

## Review Document Template

```markdown
# Test Review: <feature>

**Reviewer**: [Name/Model]
**Date**: YYYY-MM-DD
**Test Suite**: tests/unit/test_<feature>.py
**Status**: APPROVED | NEEDS-CHANGES

## Test Execution Results
- Total tests: [number]
- Passing: 0 (expected in red state)
- Failing: [number] (expected - all new tests)
- Errors: [number] (should be 0)

**If errors > 0**: Describe error types (ImportError, AttributeError, etc.)

## Coverage Assessment

[One-sentence summary: "Complete coverage" or "Gaps in X, Y, Z"]

**Coverage Matrix:**
| Spec Section | Test Coverage | Status |
|--------------|---------------|--------|
| FR1 ... | test_x, test_y | ✓ |
| FR2 ... | test_z | ✓ (import issue) |
| FR3 ... | **MISSING** | ✗ |

**Coverage Gaps**: [List any spec sections with ✗ or ⚠️]

## Attribution Check
- [ ] Multiple contributors: [Yes/No]
- [ ] If yes, inline attribution present: [Yes/No/N/A]
- [ ] Attribution format correct: [Yes/No/N/A]

## Critical Issues
[Issues that MUST be fixed before approval - typically blocking execution or missing core coverage]

### 1. [Issue Title]
**Issue**: [What's wrong]
**Impact**: [Why it matters]
**Fix**: [What needs to change]

## Important Issues
[Issues that SHOULD be addressed - typically quality concerns or minor gaps]

### N. [Issue Title]
**Issue**: [What's wrong]
**Recommendation**: [Suggested improvement]

## Minor Issues / Suggestions
[Nice-to-have improvements - typically style, documentation, organization]

### N. [Issue Title]
**Suggestion**: [Proposed change]
**Priority**: [Low/Medium]

## Overall Assessment
[2-3 sentences on suite quality, coverage completeness, and readiness]

**Strengths**: [What's working well]
**Critical Problems**: [What must be fixed]

## Approval Decision
APPROVED | NEEDS-CHANGES

### [If NEEDS-CHANGES] Required Actions:
1. [Specific action]
2. [Specific action]
...

### [If APPROVED] Next Steps:
Test suite is comprehensive and ready to serve as implementation contract. Implementation may proceed.
```

## Best Practices

### Actually Run the Tests
Don't just read test code:
- Execute the test suite
- Verify red state (all fail appropriately)
- Check error messages make sense
- Look for flaky tests

### Separate Coverage from Execution
**In Coverage Matrix:**
- Mark ✓ if test exists for requirement (even if broken)
- Note execution issues in parentheses
- Address execution issues in Critical Issues section

**Don't:**
- Mark ✗ just because imports are wrong
- Conflate "test doesn't exist" with "test doesn't match skeleton"

### Use Spec as Checklist
Systematically verify each spec requirement has tests:
- Go through spec section by section
- Mark which tests cover each requirement
- Flag gaps immediately

### Look for Common Testing Antipatterns
- Tests that test nothing (trivial assertions)
- Tests that test implementation, not behavior
- Tests with multiple unrelated assertions
- Tests that depend on execution order
- Tests with unclear failure messages

### Verify Sentinel Tests Are Effective
Don't just check that sentinel tests exist:
- Read the BUG_LEDGER entry
- Verify test would actually catch that bug
- Consider if test is specific enough

### Balance Thoroughness with Conciseness
- Use tables and bullets over prose
- Be specific but don't over-explain obvious things
- Focus on actionable feedback
- Group related issues together

## Common Pitfalls

### Conflating Coverage and Execution
**Problem**: Marking spec requirements as "not covered" (✗) when tests exist but have import errors.

**Solution**: 
- Coverage Matrix = Does test exist?
- Critical Issues = Does test execute?
- Keep these separate

### Creating Wrong Type of Matrix
**Problem**: Creating "Architecture Mismatch Matrix" showing skeleton vs test differences instead of spec-to-test coverage.

**Solution**: Coverage Matrix maps SPEC SECTIONS to TESTS, not skeleton to tests.

### Spot-Checking Instead of Systematic Review
**Problem**: Reviewing a few random tests instead of full coverage verification.

**Solution**: Create coverage matrix mapping every spec requirement to tests.

### Not Running Tests
**Problem**: Reviewing code without executing it.

**Solution**: Always run test suite. Verify red state, check error messages.

### Harsh or Judgmental Tone
**Problem**: Using language that judges the test writer ("ignored", "failed to", "incorrectly").

**Solution**: Collaborative language that guides ("Tests expect X but skeleton has Y").

## Examples

### Example 1: Coverage Matrix - Correct Usage

```markdown
## Coverage Assessment

Comprehensive coverage with two execution issues.

**Coverage Matrix:**
| Spec Section | Test Coverage | Status |
|--------------|---------------|--------|
| FR1 Fetch primary | test_reconcile_primary_success | ✓ (import error) |
| FR2 Fallback | test_fallback_to_secondary | ✓ (import error) |
| FR3 Batch | test_reconcile_batch | ✓ |
| FR4 Retry | **MISSING** | ✗ |

**Coverage Gaps**: FR4 retry behavior not tested.

## Critical Issues

### 1. Import Path Mismatch
**Issue**: Tests import from `src.reconciliation.*` but skeleton uses `src.recon.*`
**Impact**: All tests error with ImportError before reaching NotImplementedError
**Fix**: Update imports to `src.recon.models`, `src.recon.exceptions`, etc.

### 2. Missing Retry Test
**Issue**: FR4 specifies retry behavior but no test exists
**Fix**: Add test for secondary source retry with exponential backoff
```

**Why this is correct:**
- Coverage Matrix shows which spec sections have tests (FR1-FR3: ✓, FR4: ✗)
- Import errors noted in matrix but addressed separately in Critical Issues
- Clear separation between "test exists" (✓) and "test executes" (import error)

### Example 2: Coverage Matrix - Wrong Usage

❌ **Wrong Approach:**
```markdown
**Coverage Matrix:**
| Spec Section | Test Coverage | Status |
|--------------|---------------|--------|
| FR1 Fetch primary | test_reconcile_primary_success | ✗ (import error) |
| FR2 Fallback | test_fallback_to_secondary | ✗ (import error) |
```

**Why this is wrong:**
- Using ✗ implies NO TEST EXISTS for FR1 and FR2
- But tests DO exist - they just have import errors
- This conflates coverage (Concern 1) with execution (Concern 2)

✅ **Correct Approach:**
```markdown
**Coverage Matrix:**
| Spec Section | Test Coverage | Status |
|--------------|---------------|--------|
| FR1 Fetch primary | test_reconcile_primary_success | ✓ (import error) |
| FR2 Fallback | test_fallback_to_secondary | ✓ (import error) |
```

**Why this is correct:**
- ✓ shows test EXISTS for requirement
- Note indicates execution issue
- Import error addressed in Critical Issues section

### Example 3: APPROVED Review

```markdown
# Test Review: email-validation

**Reviewer**: Test Reviewer
**Date**: 2025-01-23
**Test Suite**: tests/unit/test_email_validation.py
**Status**: APPROVED

## Test Execution Results
- Total tests: 12
- Passing: 0 (expected in red state) ✓
- Failing: 12 (all new tests) ✓
- Errors: 0 ✓

## Coverage Assessment

Complete coverage of all spec requirements.

**Coverage Matrix:**
| Spec Section | Test Coverage | Status |
|--------------|---------------|--------|
| 2.1 Valid formats | test_validate_email_valid_format (3 params) | ✓ |
| 2.2 Empty input | test_validate_email_empty_string | ✓ |
| 2.3 Missing @ | test_validate_email_missing_at_symbol | ✓ |
| 2.4 Type errors | test_validate_email_none_input | ✓ |
| 2.5 Whitespace | test_validate_email_whitespace_handling | ✓ |

Sentinel test present for Bug #142 (whitespace handling).

## Attribution Check
- [x] Multiple contributors: No (single author)
- [ ] Inline attribution: N/A

## Critical Issues
None.

## Important Issues
None.

## Minor Issues / Suggestions

### 1. Parameterized Test Documentation
**Suggestion**: test_validate_email_valid_format docstring could list formats being tested.
**Priority**: Low

## Overall Assessment

Excellent test suite with complete coverage, clean structure, and good test names. All tests fail appropriately with NotImplementedError. Ready for implementation.

**Strengths**: Comprehensive, well-organized, proper TDD red state
**Critical Problems**: None

## Approval Decision
**APPROVED**

### Next Steps:
Test suite is comprehensive and ready to serve as implementation contract. Implementation may proceed.
```

### Example 4: NEEDS-CHANGES Review

```markdown
# Test Review: weather-cache

**Reviewer**: Test Reviewer
**Date**: 2025-01-24
**Test Suite**: tests/unit/test_weather_cache.py
**Status**: NEEDS-CHANGES

## Test Execution Results
- Total tests: 8
- Passing: 0 ✓
- Failing: 7 (expected)
- Errors: 1 ❌ (PROBLEM - import error)

**Error Details:**
```
ImportError: cannot import name 'WeatherAPIError' from src.weather.exceptions
```

## Coverage Assessment

Partial coverage - two spec sections not tested.

**Coverage Matrix:**
| Spec Section | Test Coverage | Status |
|--------------|---------------|--------|
| 3.1 Cache hit | test_get_weather_cache_hit | ✓ |
| 3.2 Cache miss | test_get_weather_cache_miss | ✓ |
| 3.3 Cache expiry | test_get_weather_expired_cache | ✓ |
| 3.4 API rate limit | **MISSING** | ✗ |
| 3.5 API error (500) | test_get_weather_api_error | ✓ (import error) |
| 3.6 Cache failure | **MISSING** | ✗ |
| 3.7 Cache clear | test_clear_weather_cache | ✓ |

**Coverage Gaps**: 
- Section 3.4: No test for rate limit (429) scenario
- Section 3.6: No test for cache failure fallback

## Attribution Check
- [x] Multiple contributors: Yes (Claude + Human)
- [x] Inline attribution present: Yes
- [x] Attribution format correct: Yes

## Critical Issues

### 1. Import Error Prevents Valid Red State
**Issue**: WeatherAPIError cannot be imported, causing test framework error.
**Impact**: test_get_weather_api_error errors out instead of failing with NotImplementedError. This violates TDD red state requirement.
**Fix**: Verify exception class exists in src.weather.exceptions or update import path.

### 2. Missing Rate Limit Test
**Issue**: Spec section 3.4 specifies behavior when API returns 429. No test covers this.
**Impact**: Critical requirement not tested - could cause production issues.
**Fix**: Add test verifying exponential backoff and fallback to expired cache on rate limit.

### 3. Missing Cache Failure Test
**Issue**: Spec section 3.6 specifies fallback when Redis unavailable. No test covers this.
**Impact**: System behavior undefined when cache fails.
**Fix**: Add test mocking Redis failure, verifying fallback to API without caching.

## Important Issues

### 4. Incomplete Error Test
**Issue**: test_get_weather_api_error only tests 500 error, doesn't verify retry logic.
**Recommendation**: Add assertions for exponential backoff retries at 1s, 2s, 4s intervals per spec.

## Minor Issues / Suggestions

### 5. Magic Numbers
**Suggestion**: test_get_weather_cache_miss uses `setex(900)` without explanation.
**Priority**: Low - add comment or constant for 15-minute TTL.

## Overall Assessment

Good test structure and proper attribution, but critical coverage gaps and import error prevent approval.

**Strengths**: Clean structure, proper attribution, good happy path coverage
**Critical Problems**: Import error, missing rate limit test, missing cache failure test

## Approval Decision
**NEEDS-CHANGES**

### Required Actions:
1. Fix WeatherAPIError import to achieve valid TDD red state
2. Add test for API rate limit scenario (429 response + backoff)
3. Add test for cache failure fallback
4. Enhance error test to verify retry timing

Once these issues are addressed, request re-review.
```

## When to Deviate

**Lighter review for:**
- Simple features with obvious test requirements
- Extensions of well-tested patterns
- Low-risk internal utilities

**Heavier review for:**
- Complex business logic features
- Security-sensitive functionality
- First feature in new area
- External system integrations

**Never skip:**
- Coverage verification against spec
- Actual test execution (running the suite)
- TDD red state confirmation
- Sentinel test verification

## Critical Reminders

**DO:**
- Review the COMPLETE suite as single unit (all-in)
- Run tests to verify valid red state (NotImplementedError, not ImportError)
- Map every spec requirement to tests in coverage matrix
- Separate coverage assessment from execution issues
- Use collaborative, guiding language
- Check inline attribution if multiple contributors
- Create timestamped review with STATUS in filename
- Be specific and actionable in feedback

**DON'T:**
- Approve without running tests
- Accept framework errors as valid red state
- Conflate "test exists" with "test executes" in coverage matrix
- Mark requirements as "not covered" (✗) when tests exist but have import errors
- Use judgmental language ("ignored", "failed to")
- Provide vague feedback ("needs more tests")
- Skip verification of sentinel tests

**Remember:**
- Coverage Matrix = Concern 1 (Does test exist for requirement?)
- Critical Issues = Concern 2 (Does test execute properly?)
- Keep these separate in your review

The goal is ensuring the test suite serves as a complete, reliable contract for implementation.