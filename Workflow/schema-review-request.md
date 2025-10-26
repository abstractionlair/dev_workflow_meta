# REVIEW REQUEST Ontology

## Purpose

This document defines the canonical structure, content, and semantics of REVIEW REQUEST files. Review requests formalize what information reviewers need to perform effective, thorough reviews.

**Why formalize review requests?**

Without structured requests, reviewers may:
- Miss critical context needed for evaluation
- Overlook important dependencies or constraints
- Waste time searching for related documents
- Review against wrong criteria or outdated references
- Fail to address requestor's specific concerns

**Structured review requests ensure:**
- Reviewers have complete context upfront
- All necessary documents are identified and accessible
- Specific concerns are explicitly stated
- Review scope is clear and bounded
- Review timeline expectations are set

This schema serves as the authoritative reference for:
- **All writer/implementer roles** (producers): What to include when requesting reviews
- **All reviewer roles** (consumers): What information they can expect
- **Platform leads**: How to track review queue and bottlenecks
- **Workflow automation**: Standardized format for tooling

## Document Type

**Format:** Markdown (.md)
**Producers:** All writer/implementer roles (vision-writer, spec-writer, skeleton-writer, test-writer, implementer)
**Primary Consumers:** Reviewer roles (vision-reviewer, spec-reviewer, skeleton-reviewer, test-reviewer, implementation-reviewer)
**Secondary Consumers:** Platform leads tracking review queues, workflow automation tools

## File Naming Convention

**Pattern:** `review-request-[artifact-name]-[timestamp].md`

**Timestamp Format:** `YYYY-MM-DDTHH-MM-SS` (ISO 8601 with seconds precision to avoid collisions)

**Examples:**
- `review-requests/vision/review-request-vision-v1.0-2025-10-23T14-30-00.md`
- `review-requests/specs/review-request-user-registration-2025-10-23T15-22-00.md`
- `review-requests/skeletons/review-request-payment-service-2025-10-24T09-15-30.md`
- `review-requests/tests/review-request-user-auth-tests-2025-10-24T11-45-00.md`

**Location by Review Type:**

| Review Type | Directory | Example |
|-------------|-----------|---------|
| Vision review request | `review-requests/vision/` | `review-request-vision-v1.0-2025-10-23.md` |
| Scope review request | `review-requests/scope/` | `review-request-scope-v1.0-2025-10-23.md` |
| Roadmap review request | `review-requests/roadmap/` | `review-request-roadmap-v1.0-2025-10-23.md` |
| Spec review request | `review-requests/specs/` | `review-request-user-auth-2025-10-23.md` |
| Skeleton review request | `review-requests/skeletons/` | `review-request-user-service-2025-10-24.md` |
| Test review request | `review-requests/tests/` | `review-request-user-auth-tests-2025-10-24.md` |
| Implementation review request | `review-requests/implementations/` | `review-request-user-auth-impl-2025-10-25.md` |
| Bug fix review request | `review-requests/bug-fixes/` | `review-request-bug-123-fix-2025-10-26.md` |

**Lifecycle:**

1. **Created**: Writer creates review request in appropriate `review-requests/` subdirectory
2. **In Progress**: Reviewer acknowledges, begins review (optional: add `reviewer: [name]` to front matter)
3. **Completed**: Reviewer creates review document in `reviews/` subdirectory
4. **Archived**: Review request moved to `review-requests/archived/` or deleted after review complete

---

## Required Structure

All review requests share a common structure, with review-type-specific sections.

### Document Header (Mandatory)

```markdown
---
review_type: [vision|scope|roadmap|spec|skeleton|test|implementation|bug-fix]
artifact_path: [relative/path/to/artifact]
artifact_version: [version identifier]
requested_by: [name or role]
request_date: [YYYY-MM-DD]
priority: [normal|high|urgent]
requested_completion: [YYYY-MM-DD or "no deadline"]
reviewer: [assigned reviewer name - optional, filled when review claimed]
---

# Review Request: [Artifact Name]

**Artifact under review:** [Path to artifact]
**Version:** [Version identifier]
**Requested by:** [Name/Role]
**Request date:** [ISO 8601 date]
**Priority:** [normal|high|urgent]
**Requested completion:** [Date or "no deadline"]
```

**Field Definitions:**

#### review_type
- One of: vision, scope, roadmap, spec, skeleton, test, implementation, bug-fix
- Must match type of artifact being reviewed
- Determines which reviewer role should handle request

#### artifact_path
- Relative path from project root to artifact being reviewed
- Example: `specs/proposed/user-authentication.md`
- Example: `src/services/user_service.py` (for skeleton review)
- Must be exact, unambiguous path

#### artifact_version
- Version identifier of artifact at time of review request
- Examples: `v1.0`, `v2.1-draft`, `commit-abc1234`
- Critical for tracking what version was reviewed
- For code artifacts: use git commit hash or branch name

#### requested_by
- Name of person or role requesting review
- Examples: `Alice (Product Lead)`, `Spec Writer - Claude`, `Bob (Engineer)`
- Enables reviewer to ask clarifying questions

#### request_date
- ISO 8601 format: `2025-10-23`
- Date when review was requested
- Used for tracking review queue time

#### priority
- **normal**: Standard review queue (most reviews)
- **high**: Blocking other work, needs review within 1-2 days
- **urgent**: Critical path blocker, needs review within hours
- Default: normal unless specified otherwise

#### requested_completion
- Target date for review completion
- Format: `YYYY-MM-DD` or `no deadline`
- Helps reviewer prioritize workload
- Example: `2025-10-25` means review needed by Oct 25

#### reviewer (optional)
- Name of reviewer who claimed/was assigned the request
- Initially empty, filled when reviewer starts work
- Prevents duplicate review efforts
- Example: `Claude Sonnet 4.5`, `Alice (Senior Engineer)`

---

### Required Context (Mandatory)

**All review requests must include:**

```markdown
## Context

### What changed since last review (if applicable)
[Describe what was updated, or state "First review" if initial draft]

### Related documents
- [Document 1]: [brief description of relevance]
- [Document 2]: [brief description of relevance]

### Dependencies
- [Dependency 1]: [why reviewer needs to understand this]
- [Dependency 2]: [why reviewer needs to understand this]

### Key decisions made
1. [Decision 1]: [rationale]
2. [Decision 2]: [rationale]
```

**Field Definitions:**

#### What changed since last review
- If this is a re-review after changes: Summarize what was updated
- If first review: State "First review of initial draft"
- Helps reviewer focus on changed areas in re-reviews
- Example: "Updated authentication flow based on security feedback; added rate limiting section"

#### Related documents
- List all documents reviewer should read for context
- Common: VISION.md, SCOPE.md, ROADMAP.md, parent specs
- Include brief description of why each is relevant
- Example: `VISION.md - Defines target users and success criteria for this feature`

#### Dependencies
- External dependencies reviewer needs to understand
- Technical dependencies (libraries, services)
- Feature dependencies (other specs, components)
- Team dependencies (blocked on other work)
- Example: `User authentication service - This spec extends auth to add OAuth support`

#### Key decisions made
- Important design decisions made during artifact creation
- Alternatives considered and rejected
- Helps reviewer understand rationale rather than questioning decisions
- Example: `Chose JWT over sessions for scalability; requires Redis for token blacklist`

---

### Specific Concerns (Optional but Recommended)

```markdown
## Specific Concerns

**Areas needing extra scrutiny:**
1. [Concern 1 - what specifically to look at]
2. [Concern 2 - what specifically to look at]

**Open questions:**
1. [Question 1 - what you're unsure about]
2. [Question 2 - what you're unsure about]

**Known issues:**
1. [Issue 1 - what you know is problematic but need advice on]
2. [Issue 2 - what you know is problematic but need advice on]
```

**Field Definitions:**

#### Areas needing extra scrutiny
- Specific sections or aspects where you want focused review
- Example: "Error handling in Section 4 - is it comprehensive enough?"
- Example: "Performance requirements - are they realistic given current architecture?"
- Helps reviewer allocate attention effectively

#### Open questions
- Specific questions you want reviewer to address
- Technical uncertainties, design tradeoffs, unclear requirements
- Example: "Should we use optimistic or pessimistic locking for concurrent edits?"
- Example: "Is this the right abstraction level for the API?"

#### Known issues
- Problems you're aware of but need guidance on
- NOT: "I didn't finish section X" (finish before requesting review)
- YES: "Section X uses approach Y which conflicts with Z - need advice on resolution"
- Shows self-awareness and focuses review on real dilemmas

---

### Review Scope (Optional)

```markdown
## Review Scope

**In scope for this review:**
- [Area 1]
- [Area 2]

**Out of scope for this review:**
- [Area 1 - will be addressed in separate review]
- [Area 2 - intentionally deferred]

**Focused review requested:**
[If you only need review of specific sections, specify here]
```

**When to use:**
- Large artifacts where full review is too much
- Iterative review (review Part A now, Part B later)
- Re-review after changes (only review changed sections)
- Specialized review (only security aspects, only API design)

**Example:**
```markdown
## Review Scope

**In scope for this review:**
- Authentication flow (Section 3)
- Error handling (Section 5)

**Out of scope for this review:**
- Authorization rules (Section 4) - blocked on security team decision
- Performance optimization (Section 7) - will address after benchmarking

**Focused review requested:**
Please focus on whether the authentication flow in Section 3 properly handles
edge cases for OAuth callback failures. This was flagged in last review.
```

---

## Review Request Types

### Vision Review Request

**Template:**

```markdown
---
review_type: vision
artifact_path: VISION.md
artifact_version: v1.0
requested_by: Alice (Product Lead)
request_date: 2025-10-23
priority: high
requested_completion: 2025-10-25
---

# Review Request: Product Vision

**Artifact under review:** VISION.md
**Version:** v1.0
**Requested by:** Alice (Product Lead)
**Request date:** 2025-10-23
**Priority:** high
**Requested completion:** 2025-10-25

## Context

### What changed since last review
First review of initial draft.

### Related documents
- None (vision is the starting point)

### Dependencies
- None

### Key decisions made
1. Target solo developers rather than teams - differentiates from competitors
2. 2-year horizon focusing on core workflow before expanding to collaboration features
3. CLI-first approach (not web UI) based on target user preferences

## Specific Concerns

**Areas needing extra scrutiny:**
1. Success criteria (Section 6) - Are the metrics realistic and measurable?
2. Target users (Section 3) - Is the persona specific enough to guide feature decisions?

**Open questions:**
1. Is 2-year timeline realistic for solo developer (20 hrs/week)?
2. Should we include collaboration features in "Future Scope" or "Never Scope"?

**Known issues:**
1. Technical approach (Section 7) mentions "AI-assisted" but doesn't specify which AI capabilities - need guidance on specificity level for vision document
```

**Vision review requests should emphasize:**
- Clarity and specificity of target users
- Measurability of success criteria
- Realistic scope for timeline and resources
- Alignment between problem statement and solution approach

---

### Scope Review Request

**Template:**

```markdown
---
review_type: scope
artifact_path: SCOPE.md
artifact_version: v1.0
requested_by: Bob (Platform Lead)
request_date: 2025-10-24
priority: normal
requested_completion: 2025-10-27
---

# Review Request: Project Scope

**Artifact under review:** SCOPE.md
**Version:** v1.0
**Requested by:** Bob (Platform Lead)
**Request date:** 2025-10-24
**Priority:** normal
**Requested completion:** 2025-10-27

## Context

### What changed since last review
First review of initial draft.

### Related documents
- VISION.md - This scope translates the 2-5 year vision into concrete deliverables

### Dependencies
- None

### Key decisions made
1. Defer collaboration features to post-1.0 (aligns with vision phasing)
2. Include basic search but not advanced search in v1.0 (enough to be useful, not overwhelming)
3. CLI-only for v1.0, consider web UI for v2.0+ (reduces scope, matches target users)

## Specific Concerns

**Areas needing extra scrutiny:**
1. In-Scope vs Future-Scope boundary - Is it clear and defensible?
2. Excluded features (Section 4) - Should any of these be in "Future Scope" instead?

**Open questions:**
1. Does the scope match the 6-month milestone in VISION.md?
2. Is "basic search" sufficiently defined, or should we specify what "basic" means?

**Known issues:**
1. Testing strategy (Section 7) mentions "comprehensive test coverage" but doesn't specify threshold - should scope document define this or leave to specs?
```

**Scope review requests should emphasize:**
- Alignment with VISION.md milestones and target users
- Clear boundaries between In-Scope, Future, and Never
- Feasibility of scope given resources and timeline
- Consistency of constraints and assumptions

---

### Roadmap Review Request

**Template:**

```markdown
---
review_type: roadmap
artifact_path: ROADMAP.md
artifact_version: v1.0
requested_by: Carol (Roadmap Writer)
request_date: 2025-10-25
priority: normal
requested_completion: 2025-10-28
---

# Review Request: Project Roadmap

**Artifact under review:** ROADMAP.md
**Version:** v1.0
**Requested by:** Carol (Roadmap Writer)
**Request date:** 2025-10-25
**Priority:** normal
**Requested completion:** 2025-10-28

## Context

### What changed since last review
First review of initial draft.

### Related documents
- VISION.md - Defines 6-month, 1-year, 3-year milestones this roadmap must hit
- SCOPE.md - Defines deliverables this roadmap must sequence

### Dependencies
- None

### Key decisions made
1. Phase 1 (8 weeks) focuses on core CRUD before adding search - enables early testing
2. User authentication in Phase 1 rather than Phase 2 - security requirement for any release
3. Phase 2 starts search features - data must exist before search is useful
4. Split advanced features across Phases 2-3 to deliver value incrementally

## Specific Concerns

**Areas needing extra scrutiny:**
1. Phase 1 timing (8 weeks) - Is this realistic for solo developer at 20 hrs/week?
2. Dependencies between features - Did I miss any critical dependencies?
3. Milestone alignment - Does Phase 1 completion map to the 6-month milestone in VISION.md?

**Open questions:**
1. Should user authentication be earlier in Phase 1 (blocks other features) or later (proves core value first)?
2. Is Phase 2 detailed enough, or should it be fleshed out more now?

**Known issues:**
1. Risk mitigation (Phase 1) mentions "technical spikes" but doesn't specify which features need spikes - waiting for more details before specifying
```

**Roadmap review requests should emphasize:**
- Alignment with VISION.md milestones and SCOPE.md deliverables
- Feasibility of phase timing given resources
- Proper feature sequencing and dependency management
- Balance between detail and flexibility (just-in-time planning)

---

### Spec Review Request

**Template:**

```markdown
---
review_type: spec
artifact_path: specs/proposed/user-authentication.md
artifact_version: v1.0
requested_by: Dave (Spec Writer)
request_date: 2025-10-26
priority: high
requested_completion: 2025-10-28
---

# Review Request: User Authentication Specification

**Artifact under review:** specs/proposed/user-authentication.md
**Version:** v1.0
**Requested by:** Dave (Spec Writer)
**Request date:** 2025-10-26
**Priority:** high
**Requested completion:** 2025-10-28

## Context

### What changed since last review
First review of initial draft.

### Related documents
- VISION.md (Section 3: Target Users) - Defines security needs for solo developers
- SCOPE.md (Section 2.1: User Management) - Defines authentication requirements
- ROADMAP.md (Phase 1, Week 2) - This spec corresponds to roadmap feature
- SYSTEM_MAP.md (Section 4: Services Layer) - Shows where UserService fits in architecture

### Dependencies
- Password hashing library (bcrypt) - assumed available
- PostgreSQL database - schema defined in this spec
- Email service (for welcome emails) - stub for now, real implementation later

### Key decisions made
1. JWT tokens rather than sessions - scalability for future multi-instance deployment
2. bcrypt for password hashing - industry standard, secure defaults
3. Generic error messages for auth failures - prevents email enumeration attacks
4. No OAuth in v1.0 - scope limited to email/password, OAuth deferred to Phase 2

## Specific Concerns

**Areas needing extra scrutiny:**
1. Error handling (Section 5) - Is generic error message approach secure and user-friendly enough?
2. Interface contract (Section 3) - Are the function signatures clear and implementable?
3. Edge cases (Section 4.2) - Did I miss any critical edge cases?

**Open questions:**
1. Should password strength requirements be stricter (current: 8+ chars, upper/lower/digit/special)?
2. Should we add rate limiting to login attempts, or defer to Phase 2?
3. Is JWT refresh token needed in v1.0, or can we defer to Phase 2?

**Known issues:**
1. Email validation (Section 4.1) uses simple regex - known to be imperfect but sufficient for v1.0. Reviewer: Please advise if we need stronger validation now or later.
```

**Spec review requests should emphasize:**
- Alignment with VISION, SCOPE, ROADMAP
- Completeness of interface contracts and acceptance criteria
- Clarity and testability of behavior specifications
- Identification of dependencies and risks

---

### Skeleton Review Request

**Template:**

```markdown
---
review_type: skeleton
artifact_path: src/services/user_service.py, src/models/user.py
artifact_version: commit-abc1234
requested_by: Eve (Skeleton Writer)
request_date: 2025-10-27
priority: normal
requested_completion: 2025-10-28
---

# Review Request: User Authentication Skeleton

**Artifact under review:**
- src/services/user_service.py
- src/models/user.py
**Version:** commit-abc1234 (branch: feature/user-auth-skeleton)
**Requested by:** Eve (Skeleton Writer)
**Request date:** 2025-10-27
**Priority:** normal
**Requested completion:** 2025-10-28

## Context

### What changed since last review
First review of initial skeleton.

### Related documents
- specs/todo/user-authentication.md (approved) - This skeleton implements this spec's interfaces

### Dependencies
- SYSTEM_MAP.md (Section 4: Services Layer) - Shows expected file structure and patterns
- GUIDELINES.md (Python section) - Defines code style and architectural constraints
- Existing codebase (src/services/account_service.py) - Similar pattern for reference

### Key decisions made
1. UserService as main service class with injected UserRepository - follows existing service patterns
2. User model as @dataclass with validation in __post_init__ - matches existing models
3. Custom exceptions (DuplicateEmailError, InvalidCredentialsError) in models/exceptions.py - follows exception patterns
4. Type hints for all parameters and returns - enforces spec contracts at type level

## Specific Concerns

**Areas needing extra scrutiny:**
1. Dependency injection (UserService.__init__) - Does it match existing service patterns?
2. Docstrings (all functions) - Are they complete with Args, Returns, Raises?
3. Type hints - Did I correctly translate spec contracts to Python types?

**Open questions:**
1. Should UserRepository be an abstract base class (ABC) or just a concrete class? Existing code has both patterns.
2. Should validation errors in User.__post_init__ be ValueError or custom ValidationError?

**Known issues:**
1. Password hashing mentions bcrypt in docstring but doesn't import it - intentional (skeleton doesn't import real dependencies). Reviewer: Please confirm this is correct.
```

**Skeleton review requests should emphasize:**
- Exact match with approved spec contracts
- Testability (dependency injection, interfaces)
- Consistency with project patterns (GUIDELINES.md, SYSTEM_MAP.md)
- Code quality (type hints, docstrings)

---

### Test Review Request

**Template:**

```markdown
---
review_type: test
artifact_path: tests/unit/test_user_service.py, tests/integration/test_user_auth_flow.py
artifact_version: commit-def5678
requested_by: Frank (Test Writer)
request_date: 2025-10-28
priority: high
requested_completion: 2025-10-30
---

# Review Request: User Authentication Tests

**Artifact under review:**
- tests/unit/test_user_service.py (342 lines, 28 tests)
- tests/integration/test_user_auth_flow.py (187 lines, 12 tests)
**Version:** commit-def5678 (branch: feature/user-auth-tests)
**Requested by:** Frank (Test Writer)
**Request date:** 2025-10-28
**Priority:** high
**Requested completion:** 2025-10-30

## Context

### What changed since last review
First review of initial tests.

### Related documents
- specs/doing/user-authentication.md - Tests verify all acceptance criteria from this spec
- src/services/user_service.py (skeleton) - Tests are written against this interface

### Dependencies
- pytest framework (existing)
- pytest-mock for mocking UserRepository (existing)
- Test database fixture (tests/conftest.py) - needed for integration tests

### Key decisions made
1. 28 unit tests covering all function paths + edge cases - comprehensive coverage
2. 12 integration tests covering end-to-end flows - verifies real database interactions
3. Separate test files for unit vs integration - follows existing test structure
4. Parametrized tests for edge cases - reduces duplication

## Specific Concerns

**Areas needing extra scrutiny:**
1. Coverage - Did I test all acceptance criteria from spec? (I believe so, but please verify)
2. Edge cases - Are edge cases (empty strings, None values, boundary conditions) comprehensive?
3. Error conditions - Did I test all error paths specified in spec?
4. Assertion strength - Are assertions specific enough, or too weak?

**Open questions:**
1. Should I add tests for concurrent registration (race conditions)? Spec doesn't mention this.
2. Is integration test coverage sufficient, or do I need more end-to-end scenarios?

**Known issues:**
1. test_register_duplicate_email (line 142) mocks the repository's find_by_email - this might not catch actual database constraint violations. Reviewer: Should this be an integration test instead?
```

**Test review requests should emphasize:**
- Complete coverage of spec acceptance criteria
- Edge case and error condition coverage
- Test quality (clear, focused, maintainable)
- Proper test organization (unit vs integration vs regression)

---

### Implementation Review Request

**Template:**

```markdown
---
review_type: implementation
artifact_path: src/services/user_service.py, src/models/user.py, src/repositories/user_repository.py
artifact_version: commit-ghi9012
requested_by: Grace (Implementer)
request_date: 2025-10-30
priority: high
requested_completion: 2025-11-01
---

# Review Request: User Authentication Implementation

**Artifact under review:**
- src/services/user_service.py (234 lines)
- src/models/user.py (87 lines)
- src/repositories/user_repository.py (156 lines)
**Version:** commit-ghi9012 (branch: feature/user-auth-impl)
**Requested by:** Grace (Implementer)
**Request date:** 2025-10-30
**Priority:** high
**Requested completion:** 2025-11-01
**Test Status:** All 40 tests passing ✓

## Context

### What changed since last review
First review of implementation (skeleton → full implementation).

### Related documents
- specs/doing/user-authentication.md - Implementation meets all acceptance criteria
- tests/unit/test_user_service.py - All tests passing
- tests/integration/test_user_auth_flow.py - All tests passing

### Dependencies
- bcrypt library (pip install bcrypt) - for password hashing
- PostgreSQL database - schema created by migration script
- Environment variable for JWT_SECRET - documented in .env.example

### Key decisions made
1. bcrypt work factor = 12 - balances security and performance (recommendation: 10-12)
2. JWT expiration = 24 hours - balances security and UX (no refresh tokens in v1.0)
3. Email validation uses python-email-validator library - more robust than regex
4. Database connection pooling uses existing pool from app context - no new pools

## Specific Concerns

**Areas needing extra scrutiny:**
1. Security - Is password hashing, JWT generation, error handling secure?
2. Error handling - Are all error conditions handled properly? (I believe so, but extra eyes appreciated)
3. Performance - Any obvious inefficiencies? (I don't think so, but want confirmation)

**Open questions:**
1. Should JWT_SECRET be required or have a insecure default for development? (Currently required)
2. Should we log authentication attempts? (Currently not logging for privacy, but adds security monitoring)

**Known issues:**
None - all tests passing, believe implementation is complete. Ready for thorough review.
```

**Implementation review requests should emphasize:**
- All tests passing (critical requirement)
- Spec compliance
- Code quality and maintainability
- Security review
- No test modifications (or RFC approval if modified)

---

### Bug Fix Review Request

**Template:**

```markdown
---
review_type: bug-fix
artifact_path: src/services/email_validator.py, tests/regression/test_bug_123.py
artifact_version: commit-jkl3456
requested_by: Hank (Bug Fixer)
request_date: 2025-11-02
priority: urgent
requested_completion: 2025-11-03
bug_id: BUG-123
---

# Review Request: Bug Fix - Empty Email Validation Bypass

**Artifact under review:**
- src/services/email_validator.py (fix: lines 23-25)
- tests/regression/test_bug_123.py (sentinel test: 34 lines)
**Version:** commit-jkl3456 (branch: bugfix/BUG-123-empty-email)
**Requested by:** Hank (Bug Fixer)
**Request date:** 2025-11-02
**Priority:** urgent (security bug)
**Requested completion:** 2025-11-03
**Bug ID:** BUG-123

## Context

### What changed since last review
Bug fix - no prior review.

### Related documents
- bugs/fixing/BUG-123-empty-email-validation.md - Bug report with root cause analysis

### Dependencies
- None

### Key decisions made
1. Add explicit empty string check before regex validation - simplest fix
2. Sentinel test uses parametrize for empty string variants ("", " ", "\t") - catches all whitespace cases
3. Error message "Email cannot be empty" rather than "Invalid email" - helps users understand issue

## Specific Concerns

**Areas needing extra scrutiny:**
1. Sentinel test verification - Please verify test FAILS on commit def5678 (before fix) and PASSES on commit jkl3456 (with fix)
2. Fix completeness - Does this fix catch all empty string cases, including whitespace-only strings?
3. Regression risk - Could this fix break any existing functionality?

**Open questions:**
1. Should we also strip whitespace before validating, or just reject whitespace-only emails?

**Known issues:**
None - confident this fix is correct and complete.

## Verification Commands

**Verify sentinel test FAILS on old code:**
```bash
git checkout def5678
pytest tests/regression/test_bug_123.py -v
# Expected: FAILED
```

**Verify sentinel test PASSES on new code:**
```bash
git checkout jkl3456
pytest tests/regression/test_bug_123.py -v
# Expected: PASSED
```
```

**Bug fix review requests should emphasize:**
- Clear link to bug report with root cause
- Minimal, focused fix (no scope creep)
- Sentinel test that catches the bug
- Verification that sentinel test fails on old code, passes on new code
- Regression risk assessment

---

## Best Practices

### DO: Provide Complete Context

✓ **Good review request:**
```markdown
## Context

### Related documents
- VISION.md (Section 3) - Defines target users; this feature serves solo developers specifically
- SCOPE.md (Section 2.3) - Defines search as "basic" not "advanced"; this spec interprets that boundary
- specs/done/user-management.md - This spec extends user management with search capability

### Dependencies
- Elasticsearch 8.x - Required for full-text search
- User data already in PostgreSQL - Search indexes existing data
- User authentication - Search results filtered by user permissions
```

Why this is good:
- Specific sections cited (not just "read VISION.md")
- Explains WHY each document is relevant
- Identifies technical and feature dependencies
- Shows reviewer exactly what context they need

❌ **Bad review request:**
```markdown
## Context

### Related documents
- VISION.md
- SCOPE.md
- Other specs

### Dependencies
- Various
```

Why this is bad:
- No guidance on what to look for in documents
- Doesn't explain relevance
- Vague dependencies waste reviewer time

---

### DO: Highlight Specific Concerns

✓ **Good review request:**
```markdown
## Specific Concerns

**Areas needing extra scrutiny:**
1. Error handling in Section 5 - Does it properly handle the case where Elasticsearch is temporarily unavailable? I'm unsure if graceful degradation or hard failure is better.
2. Performance requirements (Section 6.2) - "Sub-second response time" feels vague. Should this be "< 500ms p95" or is current wording acceptable for a spec?

**Open questions:**
1. Should search results be cached (Redis), or is Elasticsearch fast enough?
2. Is fuzzy matching (typo tolerance) necessary in v1.0, or defer to v2.0?
```

Why this is good:
- Specific sections and line numbers
- Concrete questions with enough context
- Shows self-awareness of uncertainties
- Gives reviewer clear focus areas

❌ **Bad review request:**
```markdown
## Specific Concerns

**Areas needing extra scrutiny:**
1. Everything
2. Make sure it's good

**Open questions:**
1. Is this right?
```

Why this is bad:
- No specific guidance
- Forces reviewer to guess what matters
- Wastes reviewer time on unfocused review

---

### DO: State Priority and Timeline Clearly

✓ **Good review request:**
```markdown
---
priority: high
requested_completion: 2025-11-03
---

**Context:** This spec blocks skeleton writing for Phase 1's critical path feature (user authentication). Phase 1 deadline is Nov 15, so we need skeleton and tests started by Nov 4. High priority reflects critical path dependency, not arbitrary urgency.
```

Why this is good:
- Explains WHY priority is high
- Realistic timeline with reasoning
- Shows impact of delayed review

❌ **Bad review request:**
```markdown
---
priority: urgent
requested_completion: today
---

**Context:** Need this reviewed ASAP.
```

Why this is bad:
- Everything is urgent → nothing is urgent
- Unrealistic timeline
- No justification

---

### DO: Keep Review Scope Focused

✓ **Good review request:**
```markdown
## Review Scope

**In scope for this review:**
- Authentication flow (Section 3) - Updated based on previous feedback
- Error handling (Section 5) - New section added

**Out of scope for this review:**
- Authorization rules (Section 4) - Unchanged from last approved review
- Performance optimization (Section 7) - Unchanged from last approved review

**Focused review requested:**
Please verify that authentication flow (Section 3) properly handles OAuth callback failures per previous review feedback. All other sections unchanged.
```

Why this is good:
- Clear boundaries save reviewer time
- Explains what changed vs unchanged
- Specific focus request prevents wasted effort

❌ **Bad review request:**
```markdown
## Review Scope

Please review everything thoroughly.
```

Why this is bad:
- Forces re-review of unchanged content
- Wastes reviewer time
- Slows feedback cycle

---

### DON'T: Request Review for Incomplete Work

❌ **Anti-pattern:**
```markdown
## Specific Concerns

**Known issues:**
1. Section 4 not finished yet - will complete later
2. Examples in Section 3 are placeholders - need to fill in
3. Dependencies section is TODO - not sure what to list

Please review what's done so far and I'll finish the rest after feedback.
```

Why this is bad:
- Wastes reviewer time on incomplete work
- Feedback may not apply to finished version
- Forces multiple review rounds unnecessarily
- Disrespects reviewer's time

✓ **Fix:**
Complete the artifact before requesting review. If you need early feedback on direction, have a conversation instead of a formal review request.

---

### DON'T: Request Review Without Self-Review

❌ **Anti-pattern:**
```markdown
## Specific Concerns

None - I haven't read through it myself yet, just finished writing. Please let me know what needs fixing.
```

Why this is bad:
- Shows lack of professionalism
- Wastes reviewer time on issues you could have caught
- Disrespects review process

✓ **Fix:**
Always self-review before requesting external review:
1. Read your artifact completely (preferably after a break)
2. Check against schema/template requirements
3. Verify all sections complete
4. Fix obvious issues yourself
5. Then request review

---

### DON'T: Make Reviewer Hunt for Information

❌ **Anti-pattern:**
```markdown
## Context

### Related documents
- See project directory for relevant docs

### Dependencies
- Usual stuff
```

Why this is bad:
- Forces reviewer to guess what's relevant
- Wastes time searching
- May miss important context

✓ **Fix:**
Provide explicit, direct paths and explanations:
```markdown
## Context

### Related documents
- VISION.md (Section 3: Target Users) - This feature specifically serves solo developers mentioned here
- specs/done/user-management.md - This spec extends user management; read Section 4 for context on user model

### Dependencies
- PostgreSQL database (existing) - Schema changes required in migration/003_add_search.sql
- Elasticsearch 8.x (new) - Full-text search engine; installation documented in docs/setup/elasticsearch.md
```

---

## Anti-Patterns

### Anti-Pattern 1: "Drive-By" Review Requests

❌ **Problem:**
```markdown
# Review Request: User Auth Spec

Please review specs/proposed/user-auth.md. Thanks!
```

**Why it fails:**
- No context provided
- No related documents listed
- No specific concerns
- No priority or timeline
- Minimal information forces reviewer to hunt for context

**Impact:**
- Reviewer wastes time understanding context
- May miss important considerations
- Slow feedback cycle
- Low-quality review

✓ **Fix:**
Use complete review request template with all sections filled out.

---

### Anti-Pattern 2: "Everything is Urgent"

❌ **Problem:**
```
Every review request marked priority: urgent
Every requested_completion: tomorrow
```

**Why it fails:**
- Boy-who-cried-wolf effect
- Reviewer can't prioritize
- Real urgencies hidden among fake ones
- Burnout and resentment

**Impact:**
- Important reviews delayed
- Reviewer ignores priority field
- Broken trust in process

✓ **Fix:**
- Default to `priority: normal`
- Use `high` only for blocking critical path
- Use `urgent` only for production issues or security bugs
- Provide realistic timelines with justification

---

### Anti-Pattern 3: "Scope Creep" Review Requests

❌ **Problem:**
```markdown
# Review Request: User Authentication Spec

Please review:
- User authentication spec
- While you're at it, also review the user management spec
- Also, can you check if the overall architecture makes sense?
- Oh and give feedback on the VISION.md document too
```

**Why it fails:**
- Multiple artifacts in one request
- Unbounded scope
- Mixed review types (spec + vision)
- Reviewer overwhelmed

**Impact:**
- Reviewer refuses or does poor job
- Delays all artifacts
- Confusion about what to approve

✓ **Fix:**
One review request per artifact. Create separate requests for separate artifacts.

---

### Anti-Pattern 4: "Passive-Aggressive" Review Requests

❌ **Problem:**
```markdown
## Specific Concerns

I think this is fine but [Senior Engineer] will probably complain about [thing I disagree with but they insisted on]. I still think my original approach was better but whatever, here it is for review.
```

**Why it fails:**
- Unprofessional tone
- Undermines artifact before review starts
- Puts reviewer in awkward position
- Signals poor collaboration

**Impact:**
- Reviewer questions requestor's commitment
- May reject based on tone alone
- Damages working relationships

✓ **Fix:**
Be professional and objective. If you disagree with a decision, document it neutrally:
```markdown
## Key decisions made
1. Used approach X rather than Y - per Senior Engineer recommendation for consistency with existing code. (Note: Approach Y has performance advantage but increases complexity.)
```

---

### Anti-Pattern 5: "No-Show" Reviewer

❌ **Problem:**
```markdown
Review request created on 2025-10-23
Requested completion: 2025-10-25
[No reviewer assigned]
[No review completed]
[Requestor waiting indefinitely]
```

**Why it fails:**
- Workflow blocked
- No visibility into review status
- Unclear if anyone is working on it

**Impact:**
- Work stalls
- Frustration and conflict
- Missed deadlines

✓ **Fix:**
Process for review requests:
1. **Reviewer claims request**: Edit front matter to add `reviewer: [name]`
2. **Reviewer acknowledges timeline**: If can't meet deadline, communicate immediately
3. **Platform lead monitors**: If request unclaimed after 24hrs, assign or escalate

---

## Integration with Review Process

### Review Request Lifecycle

```
1. Writer creates review request
   Location: review-requests/[type]/review-request-[artifact]-[timestamp].md
   Status: Pending

2. Reviewer claims request (optional but recommended)
   Updates: reviewer: [name] in front matter
   Status: In Progress

3. Reviewer completes review
   Creates: reviews/[type]/[artifact]-[status]-[timestamp].md
   Updates: Links review document in review request
   Status: Completed

4. Review request archived or deleted
   Location: review-requests/archived/ or deleted
   Status: Archived
```

### Directory Structure

```
review-requests/
  vision/
    review-request-vision-v1.0-2025-10-23.md
  scope/
  roadmap/
  specs/
    review-request-user-auth-2025-10-26.md
  skeletons/
  tests/
  implementations/
  bug-fixes/
  archived/
    [completed review requests]

reviews/
  vision/
  scope/
  roadmap/
  specs/
    user-auth-APPROVED-2025-10-28T14-30-00.md
  skeletons/
  tests/
  implementations/
  bug-fixes/
```

---

## Relationship to Other Schemas

**schema-review-request.md** (this document) defines inputs to review process.
**schema-review.md** defines outputs from review process.

Together, they formalize the complete review workflow:

```
Writer creates artifact
     ↓
Writer creates REVIEW REQUEST (this schema)
     ↓
Reviewer reads review request
     ↓
Reviewer gathers context (documents listed in request)
     ↓
Reviewer evaluates artifact
     ↓
Reviewer creates REVIEW (schema-review.md)
     ↓
Writer addresses feedback or artifact approved
```

**Key principle:** Review requests formalize what reviewers need; reviews formalize what writers get back.

---

## Summary

**Review requests formalize reviewer inputs** to ensure effective, thorough, and efficient reviews.

**Key benefits:**
- Reviewers have complete context upfront
- Specific concerns explicitly stated
- Review scope clearly defined
- Priority and timeline expectations set
- Reduces review time and improves quality

**Required elements:**
- Artifact identification (path, version)
- Requestor and date
- Related documents and dependencies
- Key decisions made
- Specific concerns (optional but recommended)

**Best practices:**
- Complete context (not "read everything")
- Focused scope (not "review everything")
- Realistic priority and timeline
- Professional tone
- Self-review before requesting external review

**Goal:** Make it easy for reviewers to do excellent work by providing everything they need in a structured, findable format.
