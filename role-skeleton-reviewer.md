---
role: Skeleton Interface Reviewer
trigger: After skeleton interfaces are created and before test writing begins
typical_scope: One feature's skeleton interface code
---

# Skeleton Interface Reviewer

## Responsibilities

The Skeleton Interface Reviewer verifies that skeleton code accurately reflects the specification, follows project patterns, passes quality checks, and is ready to serve as the foundation for test writing and implementation. Once approved, the skeleton writer will create the feature branch and move the spec to `doing/` state. This review catches mismatches between spec and code before they propagate into tests and implementation.

## Collaboration Pattern

This is typically an **independent role** - the reviewer works separately from the skeleton writer.

**Reviewer responsibilities:**
- Verify skeleton matches approved spec
- Check code quality (linting, type hints, imports)
- Verify consistency with project patterns
- Approve or request changes

**Feedback flow:**
1. Skeleton writer marks code as "ready for review"
2. Reviewer reads spec and skeleton independently
3. Reviewer provides structured feedback
4. Skeleton writer addresses issues
5. Reviewer approves when quality bar is met
6. Skeleton writer then creates feature branch and moves spec to `doing/`

## Inputs

### Code Being Reviewed
- Skeleton interface files created by skeleton writer

### Supporting Context
- **Approved specification** (in `specs/todo/`): To verify skeleton matches spec
- **SYSTEM_MAP.md**: To verify proper file organization
- **PATTERNS.md**: To verify code style compliance
- **RULES.md**: To verify no rule violations
- **Existing codebase**: To verify consistency with similar features

## Process

### 1. Read Specification First
Before looking at code:
- Understand what the spec defines (from `specs/todo/`)
- Note key signatures, types, behaviors
- Identify critical interface details

### 2. Verify Spec-to-Code Mapping
For each function/class in spec:
- [ ] Does skeleton have matching function/class?
- [ ] Do parameter names and types match?
- [ ] Do return types match?
- [ ] Are documented exceptions included in docstring?
- [ ] Are examples from spec reflected in docstring?

### 3. Check Code Quality
Run automated checks:
- [ ] Does code pass linter? (no warnings/errors)
- [ ] Does code pass type checker?
- [ ] Are all imports valid?
- [ ] Can skeleton be imported without errors?

Review code manually:
- [ ] Are docstrings comprehensive?
- [ ] Are type hints complete and precise?
- [ ] Are NotImplementedError messages specific?
- [ ] Is code formatted consistently?

### 4. Verify Project Consistency
Check against project patterns:
- [ ] Are files in correct locations per SYSTEM_MAP.md?
- [ ] Do naming conventions match PATTERNS.md?
- [ ] Does import style match existing code?
- [ ] Does docstring format match project style?
- [ ] Are there any RULES.md violations?

### 5. Check for Common Issues
- [ ] No circular import dependencies?
- [ ] No naming conflicts with existing code?
- [ ] No overly generic names (util.py, helpers.py)?
- [ ] No layer boundary violations?

### 6. Provide Structured Feedback
Use review template (see Outputs section).

## Review Checklist

### Completeness
- [ ] All functions/classes from spec are present
- [ ] No extra functions/classes not in spec
- [ ] All parameters from spec are included
- [ ] Return types match spec
- [ ] Exceptions from spec are documented

### Correctness
- [ ] Signatures match spec exactly
- [ ] Type hints are accurate (not just `Any`)
- [ ] Docstrings describe spec behavior correctly
- [ ] No misinterpretation of spec requirements

### Quality
- [ ] Code passes linter
- [ ] Code passes type checker
- [ ] Imports are valid and optimal
- [ ] Docstrings are comprehensive
- [ ] NotImplementedError messages are helpful

### Consistency
- [ ] Follows SYSTEM_MAP.md structure
- [ ] Matches PATTERNS.md conventions
- [ ] Respects RULES.md constraints
- [ ] Consistent with similar features

### Usability
- [ ] Code can be imported successfully
- [ ] Docstrings provide enough info for test writer
- [ ] Type hints enable IDE autocomplete
- [ ] Clear what needs to be implemented

## Outputs

### Review Document

```markdown
# Skeleton Interface Review: [Feature Name]

**Reviewer**: [Name]
**Date**: YYYY-MM-DD
**Overall Status**: [Approved / Needs Changes / Major Issues]

## Summary
[2-3 sentence overall assessment]

## Automated Checks
- [ ] Linter: [Pass/Fail - details]
- [ ] Type checker: [Pass/Fail - details]
- [ ] Import test: [Pass/Fail - details]

## Spec-to-Code Verification
[Document any mismatches between spec and skeleton]

## Critical Issues
[Must be fixed before approval]

## Important Issues
[Should be fixed]

## Minor Issues / Suggestions
[Nice-to-have improvements]

## Approval Decision
[Approved / Needs revision - specifics]

## Next Steps
[If approved: Skeleton writer will create feature branch and move spec to doing/]
```

## Best Practices

### Verify with Fresh Eyes
Don't assume skeleton writer got it right:
- Read spec independently first
- Check each function against spec
- Don't just spot-check; review systematically

### Run the Automated Checks Yourself
Don't trust that writer ran them:
- Import the skeleton module
- Run linter with project config
- Run type checker
- Better to verify than assume

### Check Both Letter and Spirit
Verify:
- **Letter**: Signatures match exactly
- **Spirit**: Docstrings capture spec intent

Example: Spec says function "validates email format." Docstring should explain what that means, not just repeat "validates email format."

### Look for Project-Specific Patterns
Each project has its own style:
- How are utilities organized?
- What's the import pattern?
- How are types defined?

Skeleton should match established style, not introduce new patterns without reason.

### Be Constructive
When requesting changes:
- Explain why (not just "fix this")
- Suggest solution
- Prioritize (critical vs. nice-to-have)

### Approve When Ready
If skeleton meets the bar:
- Explicitly approve
- Don't hold up for tiny issues
- Trust implementation phase for refinement
- Remember: after approval, skeleton writer creates feature branch

## Common Pitfalls

### Rubber-Stamp Review
**Problem**: Quickly saying "looks good" without actual verification.

**Solution**: Use checklist methodically. Actually run imports and linters. Compare side-by-side with spec.

### Focusing Only on Style
**Problem**: Catching formatting issues but missing spec mismatches.

**Solution**: Check spec accuracy first (correctness), then code quality (style). Correctness is more important.

### Not Running Automated Checks
**Problem**: Trusting that code passes linters without verifying.

**Solution**: Run linter and type checker yourself. It takes 10 seconds and catches real issues.

### Missing Import Problems
**Problem**: Approving code that can't actually be imported due to circular dependencies.

**Solution**: Try importing the module. Open a Python/TS REPL and `from module import function`. Does it work?

### Accepting Weak Type Hints
**Problem**: Approving `def func(x: Any) -> Any:` without questioning.

**Solution**: Type hints should be precise. If spec defines types, skeleton should use them. `Any` means "I don't know the type" and should be rare.

### Not Checking Against Existing Code
**Problem**: Approving skeleton that introduces inconsistencies with existing features.

**Solution**: Look at similar features in the codebase. Does skeleton match their style and organization? If not, why not?

### Forgetting About Next Steps
**Problem**: Not reminding skeleton writer about branch creation after approval.

**Solution**: In APPROVED reviews, note that skeleton writer should create feature branch and move spec to `doing/`.

## Examples

### Example 1: Approval

```markdown
# Skeleton Interface Review: Email Validation

**Reviewer**: Gemini
**Date**: 2025-01-20
**Overall Status**: Approved

## Summary
Skeleton accurately implements spec requirements with comprehensive docstrings and proper type hints. Code passes all quality checks and matches project conventions.

## Automated Checks
- [x] Linter: Pass (ruff 0.1.0)
- [x] Type checker: Pass (mypy 1.8.0)
- [x] Import test: Pass (`from src.utils.validation import validate_email`)

## Spec-to-Code Verification
âœ“ Function signature matches spec exactly
âœ“ Return type `tuple[bool, Optional[str]]` matches spec
âœ“ Docstring includes all examples from spec
âœ“ TypeError exception documented as specified

## Critical Issues
None.

## Important Issues
None.

## Minor Issues / Suggestions

### 1. Docstring Example Format
**Observation**: Examples use `>>>` doctest format.
**Suggestion**: This is fine, but note that project uses plain code blocks in other modules (e.g., `src/utils/phone.py`). Consider matching for consistency.
**Priority**: Low (not blocking)

## Approval Decision
**Approved**. Skeleton is ready for test writing. The minor docstring format issue is optional and doesn't affect functionality. Nice clear implementation of the spec!

## Next Steps
Skeleton writer should:
1. Create feature branch: `feature/email-validation`
2. Move spec from `specs/todo/email-validation.md` to `specs/doing/email-validation.md`
3. Notify test writer that skeleton is ready
```

### Example 2: Needs Changes

```markdown
# Skeleton Interface Review: Weather Cache

**Reviewer**: Claude
**Date**: 2025-01-22
**Overall Status**: Needs Changes

## Summary
Skeleton has good structure but contains several issues that need fixing before test writing: missing type hints, import problems, and spec mismatches.

## Automated Checks
- [ ] Linter: **FAIL** - Missing imports for datetime types
- [ ] Type checker: **FAIL** - Incompatible return type in get() method
- [x] Import test: Pass (after fixing above, this should pass)

## Spec-to-Code Verification

### Mismatch #1: Return Type
**Issue**: `get()` method returns `Optional[WeatherData]` but spec says it should return `WeatherData | None` (same thing, but spec uses union syntax).
**Action**: For consistency with spec, change to `WeatherData | None` OR document that Optional is project standard.

### Mismatch #2: Missing Validation
**Issue**: Spec section 2.3 states: "`__init__` raises ValueError if ttl_seconds is negative."
**Problem**: Docstring doesn't mention this exception.
**Action**: Add to docstring: "Raises: ValueError: If ttl_seconds is negative"

## Critical Issues

### 1. Import Errors
**Issue**: Code imports `datetime` and `timedelta` but linter reports they're not used correctly.
**Problem**: Line 5 should be `from datetime import datetime, timedelta` not `from datetime import datetime; from datetime import timedelta`
**Action**: Fix import statement

### 2. Type Hint Import Missing
**Issue**: Uses `Optional` but doesn't import from `typing`.
**Problem**: Type checker fails because `Optional` is undefined.
**Action**: Add `from typing import Optional` to imports

## Important Issues

### 3. Attribute Documentation
**Issue**: Class docstring mentions `ttl_seconds` attribute but it's not clear if this is stored as instance variable.
**Problem**: Implementation phase will need to know: Do we store `self.ttl_seconds`?
**Action**: Either:
- Add "Instance variables: ttl_seconds (int): The configured TTL" to docstring
- Or clarify that ttl_seconds is just a parameter, not stored

## Minor Issues / Suggestions

### 4. NotImplementedError Message Detail
**Suggestion**: Current message: "WeatherCache.__init__() requires implementation."
**Enhancement**: Could add: "Should store ttl_seconds and initialize empty cache dict. See spec section 2.1 for details."

## Approval Decision
**Needs Changes**. Please fix critical issues #1-2 (imports) and important issue #3 (attribute clarity), then this will be ready for approval. Should take ~10 minutes. Will approve after fixes without re-review if changes are straightforward.

## Next Steps
After fixes and re-approval, skeleton writer will create feature branch and move spec to doing/.
```

### Example 3: Major Issues

```markdown
# Skeleton Interface Review: User Data Export

**Reviewer**: Grok
**Date**: 2025-01-25
**Overall Status**: Major Issues

## Summary
Skeleton has fundamental problems: doesn't match spec signatures, uses wrong module location, and violates project architecture rules. Requires significant revision.

## Automated Checks
- [ ] Linter: **FAIL** - Multiple violations
- [ ] Type checker: **FAIL** - Type errors
- [x] Import test: Pass (but in wrong location)

## Spec-to-Code Verification

### Major Mismatch: Function Signature
**Spec says:**
```python
def export_user_data(user_id: int, format: str = "csv") -> str:
```

**Skeleton has:**
```python
def export_data(user_id: int) -> bytes:
```

**Problems:**
1. Function name wrong: `export_data` vs spec's `export_user_data`
2. Missing `format` parameter entirely
3. Return type is `bytes` but spec says `str` (CSV file path)

**Action**: Rewrite to match spec exactly.

## Critical Issues

### 1. Wrong Module Location
**Issue**: Skeleton created in `src/utils/export.py`
**Problem**: SYSTEM_MAP.md clearly states: "All export features in `src/exports/` directory"
**Action**: Move file to `src/exports/user_data.py`

### 2. Architectural Rule Violation
**Issue**: Skeleton imports `src.database.models.User` directly
**Problem**: RULES.md section 3.2: "Export layer must not import database models directly. Use service layer."
**Action**: Change to import `src.services.user_service` instead

### 3. Missing Spec Functions
**Issue**: Spec defines THREE functions: `export_user_data()`, `export_user_activities()`, `export_user_preferences()`
**Problem**: Skeleton only implements first one
**Action**: Add skeletons for all three functions

## Important Issues

### 4. Weak Type Hints
**Issue**: Uses `str` for format parameter but spec lists specific formats: "csv", "json", "xml"
**Suggestion**: Use `Literal["csv", "json", "xml"]` for type safety

### 5. Incomplete Docstring
**Issue**: Docstring doesn't mention supported formats or CSV schema
**Problem**: Test writer won't know what formats are valid or what CSV structure to expect
**Action**: Add details from spec sections 3.2 and 3.3

## Minor Issues / Suggestions
None (address major issues first).

## Approval Decision
**Major Revision Required**. This skeleton needs significant rework:
1. Match spec signatures exactly (correct names, parameters, return types)
2. Move to correct module per SYSTEM_MAP.md
3. Fix architectural rule violation
4. Add all three functions from spec

Please revise and request re-review. Given the extent of changes needed, I'll need to review the updated version before approval.

## Next Steps
After major revision and re-review, if approved, skeleton writer will create feature branch and move spec to doing/.
```

## When to Deviate

### Lighter Review When:
- Very simple skeleton (single function)
- Skeleton writer has track record of quality
- Low-risk feature

### Heavier Review When:
- Complex interfaces (many functions/classes)
- First feature in new module
- TypeScript or strictly-typed language (types matter more)
- High-stakes feature (security, payments, core functionality)

### Skip Review When:
- Tiny project (1-2 day effort)
- Solo dev implementing own skeleton immediately
- Prototype code (will be rewritten)

The goal is ensuring skeleton is correct foundation for tests and implementation, not creating process overhead.

## Critical Reminders

**DO:**
- Review skeleton against spec from `specs/todo/`
- Run automated checks yourself
- Verify imports work
- Check for project consistency
- Provide constructive feedback
- Approve when quality bar is met
- Note in approval that skeleton writer handles branch creation

**DON'T:**
- Rubber-stamp without verification
- Focus only on style over correctness
- Skip running automated checks
- Accept weak type hints
- Approve without testing imports
- Forget that skeleton writer creates branch after approval

The skeleton review ensures the design-to-code translation is correct before active development begins.