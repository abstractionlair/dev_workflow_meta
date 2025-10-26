# REVIEW Ontology

## Purpose

This document defines the canonical structure, content, and semantics of REVIEW files. Reviews are gatekeeping artifacts that ensure quality and completeness before artifacts advance through workflow stages.

This schema serves as the authoritative reference for:
- **All reviewer roles** (producers): What to create when reviewing
- **All writer/implementer roles** (consumers): What feedback to expect
- **Platform leads**: How to track quality gates
- **Stakeholders**: How approval decisions are documented

## Document Type

**Format:** Markdown (.md)
**Producers:** All reviewer roles (vision-reviewer, spec-reviewer, test-reviewer, implementation-reviewer, etc.)
**Primary Consumers:** Original artifact creators, gatekeepers deciding state transitions
**Secondary Consumers:** Future reviewers, audit trails, project stakeholders

## File Naming Convention

**Pattern:** `[artifact-name]-[version]-review-[timestamp].md` or `[artifact-name]-[status].md`

**Timestamp Format:** `YYYY-MM-DDTHH-MM-SS` (ISO 8601 with seconds precision to avoid collisions)

**Examples:**
- `reviews/vision/vision-v1.0-review-2025-10-23T14-30-47.md`
- `reviews/specs/user-registration-v1.0-review-2025-10-23T15-22-13.md`
- `reviews/implementations/payment-gateway-APPROVED.md`
- `reviews/bug-fixes/validation-empty-email-v1.0-review.md`

**Location by Review Type:**

| Review Type | Directory | Example |
|-------------|-----------|---------|
| Vision review | `reviews/vision/` | `vision-v1.0-review.md` |
| Scope review | `reviews/scope/` | `scope-v1.0-review.md` |
| Roadmap review | `reviews/roadmap/` | `roadmap-v1.0-review.md` |
| Spec review | `reviews/specs/` | `user-auth-v1.0-review.md` |
| Skeleton review | `reviews/skeletons/` | `user-service-skeleton-review.md` |
| Test review | `reviews/tests/` | `user-auth-tests-review.md` |
| Implementation review | `reviews/implementations/` | `user-auth-impl-review.md` |
| Bug fix review | `reviews/bug-fixes/` | `bug-123-fix-review.md` |

---

## Required Structure

### Document Header

```markdown
# [Artifact Type] Review: [Artifact Name]

**Artifact:** [Path to artifact being reviewed]
**Version:** [Version of artifact]
**Reviewer:** [Reviewer name or AI model identifier]
**Review Date:** [ISO 8601 date]
**Decision:** [APPROVED | NEEDS CHANGES | REJECTED]
**Review Duration:** [Optional: time spent on review]
```

**Field Definitions:**

#### Artifact Type
- Vision, Scope, Roadmap, Spec, Skeleton, Tests, Implementation, Bug Fix
- Must match type of artifact being reviewed

#### Artifact Name
- Clear identifier of what's being reviewed
- Matches artifact filename or title

#### Artifact (Path)
- Relative path to artifact being reviewed
- Example: `specs/proposed/user-authentication.md`
- Enables linking review back to source

#### Version
- Version of artifact at time of review
- Example: `v1.0`, `v2.1`, `draft-3`
- Critical for tracking which version was reviewed

#### Reviewer
- Name of human reviewer OR
- AI model identifier (e.g., `Claude Sonnet 4.5`, `GPT-5 Codex`)
- Enables accountability and context

#### Review Date
- ISO 8601 format: `2025-10-23`
- Timestamp if multiple reviews same day

#### Decision
- **APPROVED**: Artifact meets all quality standards, ready to proceed
- **NEEDS CHANGES**: Artifact has issues that must be addressed before proceeding
- **REJECTED**: Artifact fundamentally flawed, requires major rework

#### Review Duration (Optional)
- Time spent reviewing (e.g., `45 minutes`, `2 hours`)
- Helps estimate review effort for planning

---

## Section 1: Summary

```markdown
## Summary

[1-3 sentence overview of review findings and decision]
```

**Purpose:** Executive summary of review outcome

**Content Requirements:**
- 1-3 sentences maximum
- States overall assessment
- Highlights key decision factors
- Quick reference for busy stakeholders

**Examples:**

```markdown
## Summary

Vision document clearly articulates problem, target users, and measurable success criteria. Strategic direction is compelling and feasible. APPROVED with minor recommendations for future versions.
```

```markdown
## Summary

Specification incomplete - missing error handling section and 3 acceptance criteria have ambiguous wording. Implementation cannot proceed until these gaps are addressed. NEEDS CHANGES (detailed below).
```

---

## Section 2: Evaluation Criteria

```markdown
## Evaluation

### [Criterion 1]
**Status:** ✓ PASS | ⚠ CONCERN | ✗ FAIL
**Finding:** [Specific observation]
**Evidence:** [Quote, line reference, or example]
**Impact:** [Why this matters]

### [Criterion 2]
...
```

**Purpose:** Systematic assessment against quality standards

**Content Requirements:**
- One subsection per evaluation criterion
- Criterion name from relevant schema (see Evaluation Standards below)
- Status indicator (✓ ⚠ ✗ for clarity)
- Specific findings with evidence
- Impact explanation for non-passing items

**Evaluation Standards by Artifact Type:**

### Vision Review Criteria

1. **Problem Statement Clarity**
   - ✓ Problem clearly defined
   - ✗ Vague or missing problem description

2. **Target Audience Defined**
   - ✓ Primary and secondary users identified
   - ✗ Unclear who benefits

3. **Measurable Success Criteria**
   - ✓ Concrete metrics at 6mo/1yr/3yr milestones
   - ✗ Vague goals or missing metrics

4. **Feasibility**
   - ✓ Goals realistic given constraints
   - ✗ Unrealistic scope or timeline

5. **Alignment with Constraints**
   - ✓ Vision respects technical/resource constraints
   - ✗ Vision ignores known limitations

### Scope Review Criteria

1. **Boundary Clarity**
   - ✓ Clear in/out scope delineation
   - ✗ Ambiguous boundaries

2. **Constraint Completeness**
   - ✓ Technical, resource, timeline constraints defined
   - ✗ Missing critical constraints

3. **Non-Functional Requirements**
   - ✓ Performance, security, reliability specified
   - ✗ NFRs missing or vague

4. **Feasibility vs Vision**
   - ✓ Scope deliverable within vision constraints
   - ✗ Scope doesn't align with vision

### Roadmap Review Criteria

1. **Phase Sequencing Logic**
   - ✓ Features ordered by dependencies and value
   - ✗ Illogical or risky sequencing

2. **Feature Detail Sufficiency**
   - ✓ Each feature has priority, effort, criteria
   - ✗ Missing key feature details

3. **Milestone Mapping**
   - ✓ Phases map to vision milestones
   - ✗ Disconnection between roadmap and vision

4. **Risk Mitigation**
   - ✓ High-risk items addressed early or called out
   - ✗ Risks ignored in sequencing

### Spec Review Criteria

1. **Acceptance Criteria Testability**
   - ✓ All criteria can be verified by tests
   - ✗ Vague or untestable criteria

2. **Interface Contract Completeness**
   - ✓ All signatures, parameters, returns, exceptions defined
   - ✗ Missing interface details

3. **Error Handling Coverage**
   - ✓ 3-7 error scenarios defined
   - ✗ Only happy path specified

4. **Data Structure Definitions**
   - ✓ All custom types fully defined
   - ✗ Undefined or incomplete types

5. **Implementation Constraints**
   - ✓ Behavior specified, not implementation
   - ✗ Over-specifies algorithms/structures

6. **Scenario Concreteness**
   - ✓ Scenarios have specific Given-When-Then
   - ✗ Abstract or missing scenarios

### Skeleton Review Criteria

1. **Interface Completeness**
   - ✓ All spec interfaces implemented as skeletons
   - ✗ Missing functions/methods from spec

2. **Type Correctness**
   - ✓ Signatures match spec exactly
   - ✗ Type mismatches

3. **Dependency Injection**
   - ✓ Dependencies injected via constructor
   - ✗ Hard-coded dependencies or globals

4. **No Implementation Logic**
   - ✓ Only NotImplementedError or pass
   - ✗ Implementation code present

5. **Documentation Stubs**
   - ✓ Docstrings present with contracts
   - ✗ Missing docstrings

### Test Review Criteria

1. **Coverage Completeness**
   - ✓ All acceptance criteria have tests
   - ✗ Missing tests for some criteria

2. **Test Independence**
   - ✓ Tests can run in any order
   - ✗ Tests depend on each other

3. **Assertion Quality**
   - ✓ Specific assertions, clear failure messages
   - ✗ Vague assertions

4. **Coverage Thresholds**
   - ✓ >80% line coverage, >70% branch coverage projected
   - ✗ Insufficient coverage

5. **Edge Case Coverage**
   - ✓ Boundary conditions, null/empty tested
   - ✗ Only happy path tested

6. **Error Path Testing**
   - ✓ All error conditions have tests
   - ✗ Missing error tests

### Implementation Review Criteria

1. **Tests Passing**
   - ✓ All tests GREEN
   - ✗ Failing tests remain

2. **Code Quality**
   - ✓ Readable, maintainable, follows conventions
   - ✗ Code smells, poor naming, complexity

3. **Adherence to GUIDELINES.md**
   - ✓ Follows project patterns
   - ✗ Violates established conventions

4. **No Test Modifications**
   - ✓ Tests unchanged OR changes approved
   - ✗ Unauthorized test changes

5. **Coverage Achieved**
   - ✓ >80% line, >70% branch coverage
   - ✗ Below threshold

6. **SYSTEM_MAP.md Consistency**
   - ✓ Follows architectural patterns
   - ✗ Deviates from architecture

### Bug Fix Review Criteria

1. **Root Cause Documented**
   - ✓ Clear explanation in bug report
   - ✗ Missing or vague root cause

2. **Sentinel Test Quality**
   - ✓ Test fails on old code, passes on new code, specific to bug
   - ✗ Generic test or doesn't verify fix

3. **Fix Scope Appropriate**
   - ✓ Minimal changes, addresses root cause
   - ✗ Over-engineering or symptom patch

4. **Regression Prevention**
   - ✓ Test added to regression suite
   - ✗ No test or wrong location

---

## Section 3: Decision Rationale

```markdown
## Decision Rationale

[2-4 paragraphs explaining why APPROVED, NEEDS CHANGES, or REJECTED]
```

**Purpose:** Explain the decision with context

**Content Requirements:**
- 2-4 paragraphs
- Summarize critical findings
- Explain how findings led to decision
- For APPROVED: Highlight strengths
- For NEEDS CHANGES: Prioritize required fixes
- For REJECTED: Explain fundamental issues

**Example (APPROVED):**

```markdown
## Decision Rationale

The specification demonstrates exceptional clarity in defining the user authentication feature. All 12 acceptance criteria are testable and specific, with clear success/failure conditions. The interface contract section provides complete method signatures, parameter types, and exception definitions that skeleton-writer can directly translate to code.

Error handling is thoroughly addressed with 5 distinct error scenarios, each with specific trigger conditions and expected responses. The scenario section includes 8 concrete Given-When-Then examples that test-writer can convert to test cases.

The spec respects SYSTEM_MAP.md architecture by using dependency injection and following established authentication patterns. Implementation notes provide helpful guidance without over-constraining the solution.

Minor recommendation for v1.1: Add rate limiting acceptance criteria for failed login attempts. This doesn't block implementation but should be considered for future enhancement.
```

**Example (NEEDS CHANGES):**

```markdown
## Decision Rationale

While the specification has a solid foundation, three critical gaps prevent proceeding to implementation:

First, acceptance criteria AC-4 states "System handles invalid input appropriately" which is too vague to test. What constitutes "invalid"? What is "appropriate" handling? This must be split into specific criteria (e.g., "System rejects emails without @ symbol with ValidationError").

Second, the Interface Contract section defines `processPayment(amount)` but doesn't specify what the function returns. Does it return a transaction ID? A boolean? A PaymentResult object? The return type must be defined.

Third, error handling only covers one scenario (insufficient funds) but the Scope document requires handling network timeouts, invalid card numbers, and expired cards. At minimum, these three additional error scenarios must be added.

These are not minor issues - they directly prevent skeleton-writer and test-writer from doing their jobs. However, the core feature design is sound. Addressing these three items should take ~1 hour and then the spec will be ready for approval.
```

---

## Section 4: Required Changes (if NEEDS CHANGES)

```markdown
## Required Changes

### Change 1: [Title]
**Location:** [File, section, line number]
**Current:** [What's currently there or missing]
**Required:** [Specific change needed]
**Rationale:** [Why this change is necessary]
**Blocking:** YES | NO

### Change 2: [Title]
...
```

**Purpose:** Actionable checklist for artifact author

**Content Requirements:**
- Only present if Decision is NEEDS CHANGES
- One subsection per required change
- Specific location references
- Clear before/after or "add this" direction
- Rationale for each change
- Mark whether change is blocking (must fix) or optional (nice to have)

**Example:**

```markdown
## Required Changes

### Change 1: Make AC-4 Testable
**Location:** Section 4 (Acceptance Criteria), AC-4
**Current:** "System handles invalid input appropriately"
**Required:** Replace with specific criteria:
- AC-4a: "System rejects emails without @ symbol with ValidationError('Email must contain @ symbol')"
- AC-4b: "System rejects emails longer than 254 characters with ValidationError('Email exceeds maximum length')"
- AC-4c: "System trims whitespace from email before validation"
**Rationale:** Current wording is untestable - "appropriate" is subjective and "invalid input" is undefined
**Blocking:** YES

### Change 2: Define processPayment Return Type
**Location:** Section 5 (Interface Contract), processPayment method
**Current:** `async def processPayment(amount: float) -> ???`
**Required:** Specify return type, e.g., `-> PaymentResult` and define PaymentResult in Data Structures section
**Rationale:** skeleton-writer cannot create skeleton without knowing return type
**Blocking:** YES

### Change 3: Add Missing Error Scenarios
**Location:** Section 7 (Error Handling)
**Current:** Only "insufficient funds" scenario defined
**Required:** Add scenarios for:
- Network timeout (external payment gateway unreachable)
- Invalid card number (fails Luhn check)
- Expired card (expiration date in past)
**Rationale:** Scope document requires these errors be handled, tests cannot be written without error definitions
**Blocking:** YES

### Change 4: Add Rate Limiting Note
**Location:** Section 9 (Implementation Notes)
**Current:** No mention of rate limiting
**Required:** Add note: "Consider rate limiting for failed login attempts in future version (not required for v1.0)"
**Rationale:** Security best practice, but not blocking v1.0
**Blocking:** NO
```

---

## Section 5: Recommendations (Optional)

```markdown
## Recommendations

- [Non-blocking suggestion 1]
- [Non-blocking suggestion 2]
```

**Purpose:** Suggestions for future improvement

**Content Requirements:**
- Only for non-blocking suggestions
- Improvements that don't prevent current approval
- Ideas for next version
- Best practices not required now

**Example:**

```markdown
## Recommendations

- Consider adding performance benchmarks to acceptance criteria for future versions (current spec is sufficient but quantitative goals would help)
- The scenario for "concurrent user registration" is good but could be expanded with specific race condition examples
- Implementation note about password hashing is helpful; consider moving to GUIDELINES.md so all authentication features can reference it
```

---

## Section 6: Approval Conditions (if APPROVED with conditions)

```markdown
## Approval Conditions

This review APPROVES the artifact for proceeding to [next stage], contingent on:

1. [Condition 1]
2. [Condition 2]
```

**Purpose:** Define conditions that must be met before work proceeds

**Content Requirements:**
- Only present for conditional approvals
- Clear, verifiable conditions
- Typically used for minor issues that don't warrant NEEDS CHANGES
- Must be resolved before next stage begins

**Example:**

```markdown
## Approval Conditions

This review APPROVES the specification for skeleton writing, contingent on:

1. Fix typo in AC-7 ("recieve" → "receive") before skeleton-writer reads spec
2. Add forgotten import for `datetime` module to Interface Contract section
3. Update version number from "draft-2" to "v1.0" to reflect approved status

These are trivial fixes that don't require re-review. Once addressed, proceed to skeleton writing.
```

---

## Section 7: State Transition Authorization (for Gatekeeper Reviews)

```markdown
## State Transition

**From:** [Current state]
**To:** [New state]
**Authorized:** YES | NO
**Date:** [Date of transition]
```

**Purpose:** Document state change approvals

**Content Requirements:**
- Only present for reviews that gate state transitions
- Spec review: proposed → todo
- Implementation review: doing → done
- Clear before/after states
- Authorization decision
- Date of transition

**State Transitions by Review Type:**

| Review Type | From | To | Transition Action |
|-------------|------|-----|-------------------|
| Spec Review | specs/proposed/ | specs/todo/ | Reviewer moves file |
| Skeleton Review | n/a | n/a | Approves for test writing (no file move) |
| Test Review | n/a | n/a | Approves implementer to start (no file move) |
| Implementation Review | specs/doing/ | specs/done/ | Reviewer moves spec, merges branch |
| Bug Fix Review | bugs/fixing/ | bugs/fixed/ | Reviewer moves bug report |

**Example:**

```markdown
## State Transition

**From:** specs/proposed/user-authentication.md
**To:** specs/todo/user-authentication.md
**Authorized:** YES
**Date:** 2025-10-23

File moved to todo queue. Ready for skeleton-writer to begin work.
```

---

## Examples

### Example 1: Vision Review (APPROVED)

```markdown
# Vision Review: TaskFlow API

**Artifact:** VISION.md
**Version:** v1.0
**Reviewer:** Claude Sonnet 4.5
**Review Date:** 2025-10-23
**Decision:** APPROVED

## Summary

Vision document clearly articulates problem (locked-in task management tools), defines target users (developers, teams, end-users), and establishes measurable success criteria across 6-month, 1-year, and 3-year horizons. Strategic direction is compelling and feasible.

## Evaluation

### Problem Statement Clarity
**Status:** ✓ PASS
**Finding:** Problem statement clearly identifies issue (users locked into specific task management interfaces) and explains impact
**Evidence:** "Current task management tools lock users into specific interfaces. We're building a flexible API..."

### Target Audience Defined
**Status:** ✓ PASS
**Finding:** Three distinct user types identified with clear benefit propositions
**Evidence:** Section "Who Benefits" lists developers (building custom UIs), teams (custom workflows), users (interface flexibility)

### Measurable Success Criteria
**Status:** ✓ PASS
**Finding:** Concrete metrics at all three milestones
**Evidence:**
- 6mo: "50+ teams using the API"
- 1yr: "500+ teams, 99.9% uptime"
- 3yr: "Thousands of client applications"

### Feasibility
**Status:** ✓ PASS
**Finding:** Goals realistic for 2-person team over 6-month timeline
**Evidence:** 6-month goal (50 teams) achievable with grassroots adoption; later goals show growth trajectory

### Alignment with Constraints
**Status:** ✓ PASS
**Finding:** Vision respects stated resource constraints ($500/month budget, 2-person team)
**Evidence:** Infrastructure approach (cloud hosting) and scope (API only, not clients) fit constraints

## Decision Rationale

The vision document provides excellent strategic direction for the TaskFlow API project. It clearly articulates the problem (inflexible task management tools), identifies who benefits (developers, teams, users), and sets measurable success criteria at appropriate time horizons.

The feasibility assessment is realistic - building an API backend is achievable with a 2-person team over 6 months, and the success metrics (50 teams at 6mo, 500 at 1yr) represent sustainable growth rather than hockey-stick expectations.

One strength worth highlighting: the vision explicitly scopes OUT client applications ("third-party responsibility"), which prevents scope creep and maintains focus on the API's role as an enabling platform.

## Recommendations

- Consider adding security/privacy goals in a future version (e.g., SOC 2 compliance by year 2)
- The 3-year vision mentions "extension ecosystem" - this could be expanded into a strategy for plugin architecture

## Approval

VISION.md v1.0 is APPROVED. Proceed to scope definition (act as scope-writer).
```

### Example 2: Spec Review (NEEDS CHANGES)

```markdown
# Spec Review: User Authentication

**Artifact:** specs/proposed/user-authentication.md
**Version:** v0.9 (draft)
**Reviewer:** GPT-5 Codex
**Review Date:** 2025-10-23
**Decision:** NEEDS CHANGES

## Summary

Specification has solid foundation but three critical gaps prevent implementation: vague acceptance criteria (AC-4, AC-7), undefined return type for processPayment(), and incomplete error handling (missing network timeout and card validation scenarios).

## Evaluation

### Acceptance Criteria Testability
**Status:** ✗ FAIL
**Finding:** 2 of 10 acceptance criteria are too vague to test
**Evidence:**
- AC-4: "System handles invalid input appropriately" (what is "invalid"? what is "appropriate"?)
- AC-7: "User receives appropriate response" (what response? when?)
**Impact:** test-writer cannot write tests without specific expected behaviors

### Interface Contract Completeness
**Status:** ✗ FAIL
**Finding:** `processPayment` method missing return type definition
**Evidence:** Line 67: `async def processPayment(amount: float)` - no return type specified
**Impact:** skeleton-writer cannot create correct skeleton

### Error Handling Coverage
**Status:** ✗ FAIL
**Finding:** Only 1 of 3 required error scenarios defined
**Evidence:** Section 7 only covers "insufficient funds" but scope document (Section 3.4) requires network timeout and invalid card handling
**Impact:** Critical error paths won't be tested or implemented

### Data Structure Definitions
**Status:** ✓ PASS
**Finding:** All data structures fully defined
**Evidence:** PaymentRequest, User, and ValidationError types complete with all fields

### Implementation Constraints
**Status:** ✓ PASS
**Finding:** Spec describes behavior, not implementation
**Evidence:** Interface contract specifies inputs/outputs/exceptions without dictating algorithms

### Scenario Concreteness
**Status:** ⚠ CONCERN
**Finding:** 7 of 8 scenarios are excellent Given-When-Then format, but scenario 6 is abstract
**Evidence:** Scenario 6 says "user performs payment" without specifying what payment data is provided
**Impact:** Minor - test-writer can infer from context but would be better to make explicit

## Decision Rationale

The specification cannot proceed to implementation due to three blocking issues:

1. **Vague acceptance criteria (AC-4, AC-7):** These must be specific enough to test. Current wording like "handles appropriately" is subjective. Test-writer needs to know: given X input, system must respond with Y output/error.

2. **Missing return type:** skeleton-writer cannot create method skeletons without knowing what processPayment returns. Is it a PaymentResult object? Boolean? Transaction ID string?

3. **Incomplete error handling:** The scope document explicitly requires network timeout and invalid card handling, but spec only defines insufficient funds error. These aren't optional - they're contractual requirements from scope.

However, the core design is sound. The interface structure makes sense, data types are well-defined, and most scenarios are concrete and testable. Addressing these three issues should take approximately 1 hour, after which the spec will be ready for approval.

## Required Changes

### Change 1: Make AC-4 Specific
**Location:** Section 4, Acceptance Criteria, AC-4
**Current:** "System handles invalid input appropriately"
**Required:** Replace with specific criteria:
```
AC-4a: System rejects emails without @ symbol with ValidationError("Email must contain @ symbol")
AC-4b: System rejects emails >254 chars with ValidationError("Email exceeds maximum length")
AC-4c: System trims whitespace from email before validation
```
**Rationale:** "Appropriate" is subjective and untestable
**Blocking:** YES

### Change 2: Make AC-7 Specific
**Location:** Section 4, Acceptance Criteria, AC-7
**Current:** "User receives appropriate response"
**Required:** "User receives JSON response with status code 200 and `{success: true, paymentId: <uuid>}` on successful payment"
**Rationale:** Tests need to know exact expected response
**Blocking:** YES

### Change 3: Define processPayment Return Type
**Location:** Section 5, Interface Contract, processPayment
**Current:** `async def processPayment(amount: float)`
**Required:** `async def processPayment(amount: float) -> PaymentResult` and add PaymentResult to Data Structures section:
```python
@dataclass
class PaymentResult:
    success: bool
    payment_id: Optional[str]
    error_code: Optional[str]
```
**Rationale:** skeleton-writer needs return type to generate correct code
**Blocking:** YES

### Change 4: Add Network Timeout Error Scenario
**Location:** Section 7, Error Handling
**Current:** Only "insufficient funds" covered
**Required:** Add scenario:
```
Scenario: Network Timeout
Trigger: Payment gateway unreachable for >5 seconds
Response: Raise PaymentError("Payment gateway timeout", code="GATEWAY_TIMEOUT")
Retry: Caller should retry with exponential backoff
```
**Rationale:** Scope section 3.4 requires network error handling
**Blocking:** YES

### Change 5: Add Invalid Card Error Scenario
**Location:** Section 7, Error Handling
**Current:** Card validation not covered
**Required:** Add scenario:
```
Scenario: Invalid Card Number
Trigger: Card number fails Luhn algorithm check
Response: Raise ValidationError("Invalid card number", code="INVALID_CARD")
```
**Rationale:** Scope section 3.4 requires card validation
**Blocking:** YES

## Recommendations

- Consider adding performance benchmark to acceptance criteria (e.g., "Payment processing completes within 2 seconds for p95")
- Scenario 6 would be clearer with specific payment data example

## State Transition

**From:** specs/proposed/user-authentication.md
**To:** specs/proposed/user-authentication.md (remains in proposed)
**Authorized:** NO
**Date:** N/A

File remains in proposed/ until required changes are addressed. Once updated, request re-review.
```

### Example 3: Implementation Review (APPROVED with Sentinel Verification)

```markdown
# Implementation Review: User Authentication Bug Fix

**Artifact:** bugs/fixing/empty-email-validation.md + implementation
**Version:** v1.0
**Reviewer:** Claude Sonnet 4.5
**Review Date:** 2025-10-23
**Decision:** APPROVED
**Review Duration:** 30 minutes

## Summary

Bug fix correctly addresses root cause (empty string validation order), includes well-designed sentinel test, and follows minimal change principle. All tests passing, GUIDELINES.md updated with new pattern.

## Evaluation

### Root Cause Documented
**Status:** ✓ PASS
**Finding:** Bug report clearly explains root cause with code example
**Evidence:** "Email validation checked for @ symbol before checking for empty string, allowing empty strings to bypass validation"

### Sentinel Test Quality
**Status:** ✓ PASS
**Finding:** Sentinel test is specific, fails on old code, passes on new code
**Evidence:**
- Test file: `tests/regression/test_validation_empty_email.py`
- Verified test FAILS when fix reverted (git stash)
- Verified test PASSES with fix applied
- Test specifically checks empty string rejection (not generic validation test)

### Fix Scope Appropriate
**Status:** ✓ PASS
**Finding:** Minimal change, addresses root cause without over-engineering
**Evidence:** Single line added to check empty string before other validations (src/utils/validation.py:23)

### Regression Prevention
**Status:** ✓ PASS
**Finding:** Sentinel test added to regression suite with clear documentation
**Evidence:** Test includes docstring explaining bug, fix, and purpose as sentinel

### Tests Passing
**Status:** ✓ PASS
**Finding:** All 147 tests pass including new sentinel test
**Evidence:** pytest output shows 147 passed

### GUIDELINES.md Update
**Status:** ✓ PASS
**Finding:** New pattern added documenting "validate empty/null first" best practice
**Evidence:** GUIDELINES.md lines 234-247 added validation order pattern with rationale

## Decision Rationale

This bug fix exemplifies best practices for bug resolution: minimal changes targeting root cause, comprehensive sentinel test preventing recurrence, and GUIDELINES.md update extracting learnings.

The root cause analysis is excellent - clearly explains why empty strings passed validation (checked @ symbol before checking empty). The fix is appropriately minimal: one line added to check empty first.

The sentinel test is specific to this bug (not a generic validation test) and includes detailed documentation of the bug context. I verified the sentinel test fails when the fix is reverted and passes with the fix applied, confirming it actually guards against regression.

The GUIDELINES.md update adds value beyond this fix - it documents a general pattern (validate empty/null first) that prevents similar bugs in other validators.

## Recommendations

- Consider adding similar empty/null checks to other validators (password, username, etc.) proactively

## State Transition

**From:** bugs/fixing/empty-email-validation.md
**To:** bugs/fixed/empty-email-validation.md
**Authorized:** YES
**Date:** 2025-10-23

Bug report moved to fixed/. Implementation merged to main. Sentinel test remains in tests/regression/ permanently.
```

---

## Quality Standards

### Review Completeness

**A complete review must:**
- ✓ Address ALL evaluation criteria for the artifact type
- ✓ Provide specific evidence (quotes, line numbers)
- ✓ Explain decision rationale with context
- ✓ List required changes with clear action items (if NEEDS CHANGES)
- ✓ Document state transition if applicable

### Review Objectivity

**Reviews must be:**
- ✓ Based on schema criteria, not personal preferences
- ✓ Evidence-driven with specific references
- ✓ Constructive, not punitive
- ✓ Focused on artifact quality, not author identity

### Review Actionability

**NEEDS CHANGES decisions must:**
- ✓ Provide specific, actionable change requests
- ✓ Include location references (section, line number)
- ✓ Explain rationale for each change
- ✓ Distinguish blocking vs non-blocking changes
- ✓ Estimate effort to address changes

### Review Timeliness

**Reviews should be:**
- ✓ Completed within 24-48 hours for async workflows
- ✓ Completed within same session for AI agent workflows
- ✓ Not batched - review when artifact ready, not weekly

---

## Anti-Patterns

### Anti-Pattern 1: Vague Rejection

**Problem:**
```markdown
## Decision

NEEDS CHANGES

The spec has some issues that need to be fixed.
```

**Why it's bad:**
- No specific issues identified
- No actionable feedback
- Author doesn't know what to fix
- Wastes time on back-and-forth

**Fix:**
```markdown
## Required Changes

### Change 1: Vague Acceptance Criteria
**Location:** Section 4, AC-3
**Current:** "System handles errors correctly"
**Required:** Specify each error condition:
  - What triggers the error
  - What exception/response is returned
  - Example: "System raises ValidationError('Email invalid') when email missing @ symbol"
**Rationale:** test-writer cannot write tests for "handles correctly" - needs specific expected behavior
**Blocking:** YES
```

### Anti-Pattern 2: Scope Creep Review

**Problem:**
```markdown
## Required Changes

### Change 1: Add Real-Time Sync
The spec should include WebSocket support for real-time synchronization...
```

**Why it's bad:**
- Adds features beyond scope
- Reviewer overstepping role
- Delays approval for unrelated additions

**Fix:**
```markdown
## Recommendations

- Consider real-time sync as a future feature (mentioned in roadmap Phase 3)
- Current REST API design is sufficient for v1.0 per scope document
```

### Anti-Pattern 3: Rubber Stamp Approval

**Problem:**
```markdown
## Decision

APPROVED

Looks good!
```

**Why it's bad:**
- No evaluation evidence
- Didn't actually check criteria
- Quality issues might slip through

**Fix:**
```markdown
## Evaluation

### Acceptance Criteria Testability
**Status:** ✓ PASS
**Finding:** All 8 criteria specify exact inputs, outputs, and error conditions
**Evidence:** AC-1 through AC-8 each define specific test conditions

### Interface Contract Completeness
**Status:** ✓ PASS
**Finding:** All method signatures complete with types, parameters, returns, exceptions
**Evidence:** Section 5 defines 4 methods with full signatures

[Continue through all criteria...]
```

### Anti-Pattern 4: Bike-Shedding Minor Style

**Problem:**
```markdown
## Required Changes

### Change 1: Fix Formatting
Line 45 should have 2 blank lines before the heading, not 1

### Change 2: Use Title Case
Section heading should be "Error Handling" not "Error handling"
```

**Why it's bad:**
- Focuses on trivial style over substance
- Delays work for non-functional issues
- Wastes reviewer and author time

**Fix:**
```markdown
## Recommendations

- Minor formatting inconsistency on line 45 (doesn't affect quality)

[Focus required changes on actual quality/completeness issues]
```

### Anti-Pattern 5: Implementation Review Without Running Tests

**Problem:**
```markdown
# Implementation Review

The code looks correct to me. APPROVED.

[Didn't actually run tests]
```

**Why it's bad:**
- Tests might be failing
- Coverage might be below threshold
- Approving broken code

**Fix:**
```markdown
## Evaluation

### Tests Passing
**Status:** ✓ PASS
**Finding:** All 24 tests pass
**Evidence:**
```
$ pytest tests/
======================== 24 passed in 2.34s ========================
```

### Coverage Achieved
**Status:** ✓ PASS
**Finding:** 87% line coverage, 78% branch coverage
**Evidence:**
```
$ pytest --cov=src tests/
src/services/auth.py    87%    78%
```
```

### Anti-Pattern 6: Conflating Review and Design

**Problem:**
```markdown
## Required Changes

### Change 1: Use Different Algorithm
The spec uses JWT tokens but OAuth2 would be better...
```

**Why it's bad:**
- Reviewer redesigning instead of reviewing
- Overstepping role boundaries
- Design choices should have been made earlier

**Fix:**

If design is fundamentally flawed:
```markdown
## Decision

REJECTED

The design choice to use JWT tokens conflicts with scope requirement for OAuth2 integration (Scope section 3.2 explicitly requires OAuth2). This is a fundamental mismatch that requires spec re-write, not minor changes.
```

If design is just different than reviewer preference:
```markdown
## Recommendations

- JWT tokens are valid implementation; consider OAuth2 in future versions if third-party integration becomes priority
```

---

## Downstream Usage

### Artifact Authors (Consumers)

**Writers/Implementers consume reviews to:**
- Understand what needs to change (NEEDS CHANGES)
- Confirm they can proceed (APPROVED)
- Incorporate recommendations into future versions
- Learn quality standards

**What they read:**
- Decision (APPROVED/NEEDS CHANGES/REJECTED)
- Required Changes section (actionable fixes)
- Recommendations (optional improvements)

### Gatekeepers (Consumers)

**Roles controlling state transitions consume reviews to:**
- Authorize moving artifacts between states
- Verify quality gates passed
- Track approval history

**What they read:**
- Decision
- State Transition Authorization section

### Audit Trail (Long-term Consumers)

**Future reviewers and stakeholders consume reviews to:**
- Understand why decisions were made
- Track evolution of artifacts over time
- Learn from past review findings

**What they read:**
- Full review for historical context

---

## Review Lifecycle

**Review workflow:**

1. **Artifact Ready**: Writer/implementer completes artifact, requests review
2. **Reviewer Assigned**: Appropriate reviewer role takes on review
3. **Review Conducted**: Reviewer evaluates against schema criteria
4. **Review Documented**: Reviewer creates review document
5. **Decision Communicated**: Review shared with artifact author
6. **Changes Addressed** (if NEEDS CHANGES): Author fixes issues, requests re-review
7. **Re-Review** (if needed): Reviewer validates changes
8. **Final Approval**: Review with APPROVED decision
9. **State Transition**: Gatekeeper moves artifact to next state (if applicable)
10. **Archive**: Review retained for audit trail

**Re-review triggers:**
- NEEDS CHANGES decision: Author must address required changes and request re-review
- Spec updated during implementation: Spec re-reviewed to validate changes
- Test modifications requested: Tests re-reviewed if implementer requests changes

---

## Related Ontologies

- **All schema-*.md files**: Define what to review for each artifact type
- **All role-*-reviewer.md files**: Define who creates reviews and when
- **schema-vision.md, schema-scope.md, schema-roadmap.md**: Strategic artifact schemas
- **schema-spec.md**: Most commonly reviewed artifact
- **schema-test-code.md**: Test review standards
- **schema-implementation-code.md**: Implementation review standards
- **schema-bug-report.md**: Bug fix review standards

---

## Summary

REVIEW files are quality gates that ensure artifacts meet standards before advancing through workflow stages.

**Key principles:**
- **Evidence-based**: Cite specific findings, not opinions
- **Schema-driven**: Evaluate against artifact's schema criteria
- **Actionable**: NEEDS CHANGES must specify exact fixes required
- **Gatekeeping**: Reviews authorize (or block) state transitions
- **Audit trail**: Reviews document decision history

**Review types by workflow stage:**
- Vision/Scope/Roadmap reviews: Strategic planning quality
- Spec reviews: Gate proposed → todo transition
- Skeleton reviews: Approve test writing start
- Test reviews: Approve implementation start (RED→GREEN)
- Implementation reviews: Gate doing → done transition, merge to main
- Bug fix reviews: Gate fixing → fixed transition

**Quality indicators:**
- ✓ Complete evaluation of all schema criteria
- ✓ Specific evidence with references
- ✓ Clear decision rationale
- ✓ Actionable required changes (if NEEDS CHANGES)
- ✓ Appropriate blocking vs non-blocking distinction

Reviews are the quality control mechanism that prevents defects from cascading through the workflow. A rigorous review process at each gate ensures high-quality outputs and prevents rework.
