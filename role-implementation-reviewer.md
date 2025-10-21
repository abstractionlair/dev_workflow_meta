---
role: Implementation Reviewer
trigger: After implementation is complete and all tests pass (green state)
typical_scope: One feature implementation
---

# Implementation Reviewer

## Responsibilities

Verify that production code correctly implements test contracts, follows project patterns and architectural rules, maintains code quality, and is ready for production. This review catches issues before code is merged and prevents technical debt accumulation.

## Collaboration Pattern

This is typically an **independent role** - the reviewer works separately from the implementer.

**Reviewer responsibilities:**
- Verify all tests pass (green state)
- Check code quality and maintainability
- Verify architectural compliance
- Identify potential bugs or issues
- Ensure no regression in existing tests
- Approve or request changes
- **Gatekeeper**: Move approved specs from `doing/` to `done/`

**Feedback flow:**
1. Implementer marks code as "ready for review"
2. Reviewer runs tests and examines code independently
3. Reviewer provides structured feedback
4. Implementer addresses issues
5. Reviewer re-reviews if significant changes
6. Reviewer approves when quality bar is met

## Inputs

### Code Being Reviewed
- Production implementation code
- Any modified or new test files

### Supporting Context
- **Test suite**: To verify tests pass and weren't modified inappropriately
- **Specification**: To verify implementation matches intent
- **SYSTEM_MAP.md**: To verify architectural compliance
- **PATTERNS.md**: To verify pattern usage
- **RULES.md**: To verify no rule violations
- **BUG_LEDGER.yml**: To check for repeated mistakes

### Quality Standards
- Project linting rules
- Type checking requirements
- Code style guidelines

## Process

### 1. Verify Green State
Before reviewing code, run tests:
```bash
pytest tests/ -v --cov=src/
```

Confirm:
- [ ] All new tests pass (green)
- [ ] No existing tests broken (no regression)
- [ ] Code coverage meets project standards
- [ ] No test framework errors

### 2. Check for Test Modifications
Critical check: Were tests changed?
```bash
git diff main -- tests/
```

**Acceptable test changes:**
- Bug fixes in test code (with explanation)
- Adding new tests (bonus)
- Improving test clarity (with justification)

**Unacceptable test changes:**
- Weakening assertions to make tests pass
- Removing tests
- Changing expected behavior to match implementation

If tests were modified, scrutinize carefully.

### 3. Review Code Quality
Run automated checks:
- [ ] Linter passes (no warnings)
- [ ] Type checker passes (no errors)
- [ ] Code formatted per project style
- [ ] No security warnings (bandit, safety)

### 4. Verify Architectural Compliance
Check against architectural rules:
- [ ] Correct module/file location per SYSTEM_MAP.md?
- [ ] Follows established patterns per PATTERNS.md?
- [ ] No rule violations per RULES.md?
- [ ] Imports only from allowed layers?
- [ ] No circular dependencies?

### 5. Check Implementation Against Spec
Read spec and verify implementation:
- [ ] All specified behaviors implemented?
- [ ] Edge cases handled per spec?
- [ ] Error conditions handled correctly?
- [ ] Return types match spec?
- [ ] Side effects match spec?

### 6. Review Code for Quality
- [ ] Code is readable and maintainable?
- [ ] No obvious bugs or logical errors?
- [ ] No code duplication (DRY)?
- [ ] Appropriate abstraction level?
- [ ] Clear variable/function names?
- [ ] Helpful comments where needed?

### 7. Check for BUG_LEDGER Patterns
Review BUG_LEDGER.yml for similar past bugs:
- [ ] Are we repeating a known mistake?
- [ ] Are sentinel tests passing?
- [ ] Have we learned from history?

### 8. Provide Structured Feedback
Create timestamped review file in `reviews/implementations/`:
```
YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md
```

Where STATUS âˆˆ {APPROVED, NEEDS-CHANGES}

## Outputs

### Review Document

```markdown
# Implementation Review: <feature>

**Reviewer**: [Name/Model]
**Date**: YYYY-MM-DD
**Implementation**: specs/doing/<feature>.md, src/...
**Status**: APPROVED | NEEDS-CHANGES

## Test Results
- All tests pass: [Yes/No]
- Coverage: [percentage]
- Regression check: [Pass/Fail]
- Test modifications: [None/Details]

## Automated Checks
- Linter: [Pass/Fail]
- Type checker: [Pass/Fail]
- Security scan: [Pass/Fail]

## Architectural Compliance
- SYSTEM_MAP: [Compliant/Issues]
- PATTERNS: [Compliant/Issues]
- RULES: [Compliant/Issues]

## Spec Alignment
[How well does implementation match specification?]

## Critical Issues
[Must fix before approval]

## Important Issues
[Should fix]

## Minor Issues / Suggestions
[Nice-to-have improvements]

## Overall Assessment
[Summary of implementation quality]

## Approval Decision
APPROVED | NEEDS-CHANGES

[If NEEDS-CHANGES: specific actions required]
[If APPROVED: confirmation ready for merge]
```

## Gatekeeper Movement

**On APPROVED implementation review:**

Move spec from `doing/` to `done/`:
```bash
git mv specs/doing/<feature>.md specs/done/<feature>.md
git add reviews/implementations/YYYY-MM-DDTHH-MM-SS-<feature>-APPROVED.md
git commit -m "impl: approve <feature> implementation"
```

**On NEEDS-CHANGES:**
- Do NOT move spec
- Spec remains in `doing/` during revision
- Move to `done/` only after re-review and approval

This gatekeeper responsibility ensures specs only reach `done/` when implementation is truly complete and approved.

## Best Practices

### Verify Green State First
Don't even start code review if tests don't pass:
- Green state is prerequisite
- No point reviewing code that doesn't work
- Run tests yourself, don't trust CI/PR status

### Scrutinize Test Modifications
Test changes are red flag:
- Default assumption: tests shouldn't change
- If changed, verify each change is justified
- Watch for weakened assertions
- Check if spec was updated accordingly

### Use Spec as Reference
Don't rely on memory:
- Read spec during review
- Verify each requirement implemented
- Check examples match implementation
- Note any deviations

### Check Patterns and Rules
Don't skip architectural review:
- Verify file location is correct
- Check imports follow rules
- Ensure patterns are used
- Look for violations

### Read Code for Bugs
Don't just check style:
- Think about edge cases
- Look for null pointer issues
- Check error handling
- Consider race conditions (if relevant)

### Verify Historical Lessons
Check BUG_LEDGER:
- Are we repeating mistakes?
- Are sentinel tests present?
- Have past issues been considered?

## Common Pitfalls

### Rubber-Stamp Review
**Problem**: Quick approval without thorough review.

**Solution**: Use checklist systematically. Force yourself to find at least 2-3 potential improvements.

### Accepting Weakened Tests
**Problem**: Implementer changed tests to pass, reviewer approves.

**Solution**: Carefully review any test modifications. Test changes should be rare and well-justified.

### Ignoring Architectural Rules
**Problem**: Code works but violates patterns/rules.

**Solution**: Check SYSTEM_MAP, PATTERNS, RULES explicitly. Working code isn't enough.

### Not Running Tests Yourself
**Problem**: Trusting PR status without verification.

**Solution**: Always run tests locally. Verify green state yourself.

### Focusing Only on New Code
**Problem**: Missing impact on existing codebase.

**Solution**: Check for regressions. Run full test suite, not just new tests.

## Examples

### Example 1: APPROVED Review

```markdown
# Implementation Review: email-validation

**Reviewer**: Claude Sonnet 4.5
**Date**: 2025-01-25
**Implementation**: specs/doing/email-validation.md, src/auth/validation.py
**Status**: APPROVED

## Test Results
- All tests pass: Yes (12/12) âœ“
- Coverage: 100% of new code âœ“
- Regression check: Pass (all existing tests pass) âœ“
- Test modifications: None âœ“

## Automated Checks
- Linter: Pass âœ“
- Type checker: Pass âœ“
- Security scan: Pass (no issues) âœ“

## Architectural Compliance
- SYSTEM_MAP: Compliant (correct location: src/auth/) âœ“
- PATTERNS: Compliant (uses existing ValueError pattern) âœ“
- RULES: Compliant (no cross-layer imports) âœ“

## Spec Alignment
Implementation correctly handles all spec requirements:
- RFC 5322 simplified validation rules âœ“
- All happy path examples work âœ“
- All edge cases handled âœ“
- Error conditions raise correct exceptions âœ“

## Critical Issues
None.

## Important Issues
None.

## Minor Issues / Suggestions

### 1. Email Normalization
**Observation**: Implementation doesn't normalize email case, which is fine per spec.

**Suggestion**: Consider adding `normalize_email()` helper for future use (e.g., user lookup). Not required now.

**Priority**: Low - out of scope for current feature.

## Overall Assessment
Excellent implementation. Code is clean, readable, and fully implements spec. All tests pass, no regressions. Ready for production.

## Approval Decision
**APPROVED**

Implementation complete and ready for merge.

**Gatekeeper action**: Moving `specs/doing/email-validation.md` â†’ `specs/done/email-validation.md`
```

### Example 2: NEEDS-CHANGES Review

```markdown
# Implementation Review: weather-cache

**Reviewer**: Claude Sonnet 4.5
**Date**: 2025-01-25
**Implementation**: specs/doing/weather-cache.md, src/weather/cache.py
**Status**: NEEDS-CHANGES

## Test Results
- All tests pass: No (2 failing) âœ—
- Coverage: 85% (missing error path coverage) âš 
- Regression check: Pass âœ“
- Test modifications: Yes (2 tests weakened) âœ—

## Automated Checks
- Linter: Fail (3 warnings about unused imports) âœ—
- Type checker: Pass âœ“
- Security scan: Pass âœ“

## Architectural Compliance
- SYSTEM_MAP: Issue (cache.py should import from cache/redis_client.py per SYSTEM_MAP, but imports from external/) âœ—
- PATTERNS: Issue (retry logic doesn't follow exponential backoff pattern from PATTERNS.md) âš 
- RULES: Compliant âœ“

## Spec Alignment
Partial alignment - key behaviors missing:
- Cache hit/miss: Implemented âœ“
- Cache expiry: Implemented âœ“
- Rate limit handling: **NOT IMPLEMENTED** âœ—
- Error fallback: Incomplete (doesn't check for expired cache) âš 

## Critical Issues

### 1. Failing Tests
**Issue**: 2 tests still failing:
- `test_get_weather_rate_limit_fallback` 
- `test_get_weather_cache_failure_fallback`

**Required**: Make these tests pass per spec requirements.

### 2. Test Modifications
**Issue**: 2 tests were weakened:

**test_get_weather_api_retry:**
- Original: `assert api_client.fetch.call_count == 3`
- Changed to: `assert api_client.fetch.call_count >= 1`

This weakens the retry requirement from spec (3 retries with exponential backoff).

**test_cache_expiry_staleness:**
- Original: `assert result['stale'] is True`
- Changed to: `# Removed stale flag check`

This removes verification of stale data flagging per spec section 3.3.

**Required**: Revert these test changes and implement per original test requirements.

### 3. Linter Warnings
**Issue**: Unused imports in cache.py.

**Required**: Remove unused imports or use them.

## Important Issues

### 4. Wrong Import Path
**Issue**: Importing from `src/external/redis_client.py` but SYSTEM_MAP.md specifies `src/cache/redis_client.py`.

**Required**: Update import to match SYSTEM_MAP.

### 5. Retry Logic Doesn't Match Pattern
**Issue**: Retry uses fixed 1-second delays. PATTERNS.md section 5.2 specifies exponential backoff pattern.

**Required**: Use `src/utils/retry.py::exponential_backoff()` per PATTERNS.md.

## Minor Issues / Suggestions

### 6. Magic Numbers
**Suggestion**: TTL value (900) hardcoded. Define `CACHE_TTL_SECONDS` constant.

### 7. Error Logging
**Suggestion**: Cache failures are silently caught. Add logging per PATTERNS.md section 7.1.

## Overall Assessment
Implementation has the right structure but critical spec requirements are missing (rate limit handling) and tests were inappropriately weakened. Must address test failures and revert test changes.

## Approval Decision
**NEEDS-CHANGES**

### Required Actions:
1. Make all tests pass without weakening them
2. Revert test modifications (restore original assertions)
3. Implement rate limit handling per spec
4. Fix import path to match SYSTEM_MAP
5. Use exponential backoff pattern from PATTERNS.md
6. Fix linter warnings

Once these are addressed, request re-review. **Do not move spec to done/ until approved.**
```

## When to Deviate

**Lighter review for:**
- Simple bugfixes with existing test coverage
- Refactoring with no behavior changes
- Low-risk internal utilities

**Heavier review for:**
- Complex business logic
- Security-sensitive code
- Public APIs
- External integrations
- First implementation in new area

**Never skip:**
- Test execution and green state verification
- Test modification scrutiny
- Architectural compliance check
- Spec alignment verification

## Critical Reminders

**DO:**
- Run tests yourself (verify green state)
- Scrutinize any test modifications
- Check SYSTEM_MAP, PATTERNS, RULES explicitly
- Read BUG_LEDGER for historical context
- Verify spec requirements are met
- Move spec to done/ only on approval (gatekeeper)

**DON'T:**
- Approve without running tests
- Accept weakened tests
- Skip architectural compliance checks
- Trust CI status without verification
- Approve with failing tests
- Forget gatekeeper movement responsibility

The goal is ensuring implementation is correct, maintainable, and production-ready before merging.