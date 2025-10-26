# Request for Change (RFC) Process

## Purpose

Approved artifacts (specs, tests, skeletons) define contracts. However, downstream work sometimes reveals gaps, ambiguities, or errors in these contracts.

The **RFC (Request for Change) process** provides a lightweight, artifact-driven method for amending approved artifacts when downstream discoveries necessitate changes.

**Key principle:** Contracts can be updated, but changes require justification, review, and approval to maintain quality.

---

## When to Use RFC Process

Use RFC when you discover issues in **approved artifacts** during downstream work:

| Discovery Stage | Artifact with Issue | RFC Needed For |
|----------------|---------------------|----------------|
| **Skeleton Writing** | SPEC | Missing interface details, structural problems |
| **Test Writing** | SPEC | Missing acceptance criteria, ambiguous behaviors |
| **Test Writing** | Skeleton | Interface doesn't support required testing |
| **Implementation** | SPEC | Behavioral ambiguities, conflicting requirements |
| **Implementation** | Tests | Tests verify wrong behavior (tests are bugs) |
| **Implementation** | Skeleton | Interface needs additional methods/parameters |

**Not for:**
- Strategic changes (VISION/SCOPE/ROADMAP) → Use [Checkpoint Review](FeedbackLoops.md)
- Implementation bugs (tests fail, code wrong) → Fix implementation
- Refactoring (behavior unchanged) → No RFC needed

---

## RFC Workflow Overview

```
1. Discoverer identifies issue in approved artifact
   ↓
2. Discoverer files RFC (artifact in rfcs/open/)
   ↓
3. Original author reviews RFC
   ↓
4. If approved: Author updates artifact, moves to rfcs/approved/
   If rejected: Author provides rationale, moves to rfcs/rejected/
   ↓
5. Updated artifact goes through standard review process
   ↓
6. Once approved, work continues with updated artifact
```

---

## RFC Document Structure

RFCs are markdown files in `rfcs/open/`, `rfcs/approved/`, or `rfcs/rejected/`.

### File Naming

```
rfcs/open/rfc-YYYYMMDD-brief-description.md
```

**Examples:**
- `rfcs/open/rfc-20251026-add-email-validation-to-user-auth-spec.md`
- `rfcs/open/rfc-20251027-fix-password-test-strength-check.md`

### RFC Template

```markdown
# RFC: [Brief Description]

**RFC ID:** RFC-YYYYMMDD-NNN
**Filed by:** [Role - Name]
**Date filed:** YYYY-MM-DD
**Status:** OPEN | APPROVED | REJECTED
**Affected artifact:** [path/to/artifact.md or src/path/to/file.py]

## Problem

**Discovery context:**
[What stage: skeleton writing, test writing, implementation]

**Issue description:**
[Clear description of the problem with the current artifact]

**Impact:**
[What can't be done without this change? Who is blocked?]

## Evidence

[Concrete examples showing the problem]

**Example:**
- Current spec says: "..."
- But implementation needs: "..."
- Because: "..."

## Proposed Solution

**Change to [artifact]:**

[Specific changes proposed - use diff format or before/after]

**Before:**
```
[Current content]
```

**After:**
```
[Proposed content]
```

**Rationale:**
[Why this change fixes the problem without introducing new issues]

## Impact Analysis

**Downstream effects:**
- [ ] Specs need updating: [Yes/No - which ones]
- [ ] Tests need updating: [Yes/No - which tests]
- [ ] Skeletons need updating: [Yes/No - which files]
- [ ] Implementation needs updating: [Yes/No - which files]

**Contract strength:**
- [ ] This change strengthens contract (adds clarity/requirements)
- [ ] This change maintains contract strength (clarification only)
- [ ] This change weakens contract (removes requirements) - requires strong justification

## Alternatives Considered

**Alternative 1:** [Description]
- Rejected because: [Reason]

**Alternative 2:** [Description]
- Rejected because: [Reason]

## Review Decision

**Reviewer:** [Original author or designated reviewer]
**Decision:** APPROVED | REJECTED
**Date:** YYYY-MM-DD

**Decision rationale:**
[Why approved or rejected]

**If approved - implementation plan:**
1. Update [artifact] with proposed changes
2. File for re-review by [reviewer role]
3. Notify affected roles: [list]

**If rejected - guidance:**
[Alternative approach or clarification of original intent]
```

---

## RFC Scenarios and Processes

### Scenario 1: Spec Change Discovered During Skeleton Writing

**Problem:** Skeleton Writer discovers spec is missing interface details

**Example:**
```
SPEC says: "UserService validates password strength"
But doesn't specify:
- What are the strength requirements?
- What error is raised?
- What is the error message format?

Skeleton Writer cannot create complete interface without these details.
```

**RFC Process:**

1. **Skeleton Writer files RFC:**
   ```markdown
   # RFC: Add Password Strength Requirements to User Auth Spec

   **Filed by:** Skeleton Writer - Claude
   **Affected artifact:** specs/doing/user-authentication.md

   ## Problem
   **Discovery context:** Skeleton writing

   **Issue:** Spec says "validate password strength" but doesn't define:
   - Minimum length
   - Character requirements (upper/lower/digit/special)
   - Error type to raise
   - Error message format

   **Impact:** Cannot create complete PasswordHasher interface with proper
   docstrings.

   ## Proposed Solution
   Add to spec:
   - AC: Password must be ≥8 chars with uppercase, lowercase, digit, special char
   - Error: Raise WeakPasswordError with specific reason
   ```

2. **Spec Writer reviews RFC:**
   - Validates issue is real
   - Assesses proposed solution
   - Makes decision (APPROVE/REJECT)

3. **If APPROVED:**
   - Spec Writer updates spec with missing details
   - Moves RFC to `rfcs/approved/`
   - Spec goes to Spec Reviewer for re-review (focused review of changes)
   - Once approved, Skeleton Writer can continue

4. **If REJECTED:**
   - Spec Writer provides clarification in RFC
   - Moves RFC to `rfcs/rejected/`
   - Explains how existing spec should be interpreted

**Key point:** Skeleton Writer **blocks on RFC approval** - cannot proceed without interface details.

---

### Scenario 2: Spec Change Discovered During Test Writing

**Problem:** Test Writer discovers spec has missing or ambiguous acceptance criteria

**Example:**
```
SPEC AC: "User can authenticate with email and password"

Test Writer questions:
- What if email not found? (Not specified)
- What if password wrong? (Not specified)
- Should errors differentiate between "email not found" vs "password wrong"?
  (Security consideration not addressed in spec)
```

**RFC Process:**

1. **Test Writer files RFC:**
   ```markdown
   # RFC: Clarify Authentication Error Handling in User Auth Spec

   **Filed by:** Test Writer - Claude
   **Affected artifact:** specs/doing/user-authentication.md

   ## Problem
   **Discovery context:** Test writing

   **Issue:** Spec doesn't define error behavior:
   - What happens if email not found?
   - What happens if password wrong?
   - Security: Should error reveal whether email exists?

   **Impact:** Cannot write comprehensive error case tests without knowing
   expected behavior.

   ## Proposed Solution
   Add AC:
   - AC: If credentials invalid (email or password), raise
     InvalidCredentialsError with generic message "Invalid email or password"
   - Rationale: Generic error prevents email enumeration attacks
   ```

2. **Spec Writer reviews RFC:**
   - Validates gap in spec
   - Considers security implications
   - Decides whether to accept proposed solution or provide alternative

3. **If APPROVED:**
   - Spec Writer updates spec with error behavior
   - Spec re-reviewed by Spec Reviewer
   - Test Writer continues writing tests against updated spec

**Key point:** Test Writer **blocks on RFC approval** - cannot write comprehensive tests without knowing expected behavior.

---

### Scenario 3: Spec Change Discovered During Implementation

**Problem:** Implementer discovers spec has conflicting requirements or behavioral ambiguities

**Example:**
```
SPEC AC1: "Emails are case-insensitive (alice@example.com = ALICE@EXAMPLE.COM)"
SPEC AC2: "Store email exactly as user entered it"

Conflict: Can't be both case-insensitive AND store exactly as entered.
If user registers "Alice@Example.com" and later logs in with
"alice@example.com", what should be stored?
```

**RFC Process:**

1. **Implementer files RFC:**
   ```markdown
   # RFC: Resolve Email Case Handling Conflict in User Auth Spec

   **Filed by:** Implementer - Claude
   **Affected artifact:** specs/done/user-authentication.md

   ## Problem
   **Discovery context:** Implementation

   **Issue:** Spec has conflicting requirements:
   - AC1: Emails case-insensitive
   - AC2: Store email exactly as entered

   **Impact:** Cannot implement both. Tests will fail either way.

   ## Evidence
   Test: test_email_case_insensitive expects:
   - Register "Alice@Example.COM"
   - Login "alice@example.com"
   - Should succeed

   But AC2 says store "Alice@Example.COM" exactly.
   Lookup for "alice@example.com" won't find "Alice@Example.COM".

   ## Proposed Solution
   Change AC2 to: "Store email normalized to lowercase"
   - Pro: Consistent with case-insensitive requirement
   - Pro: Simplifies lookups
   - Con: User doesn't see their original capitalization

   Alternative: Store original + normalized:
   - Store both: display_email="Alice@Example.COM", normalized_email="alice@example.com"
   - Use normalized for lookups
   - Pro: Preserves user input for display
   - Con: More complex data model
   ```

2. **Spec Writer reviews RFC:**
   - Acknowledges conflict
   - Chooses solution (simplified or alternative)
   - Updates spec

3. **Updated spec goes to Spec Reviewer:**
   - Validates conflict resolved
   - Approves updated spec

4. **Implementer continues:**
   - Implements according to updated spec
   - Tests should now pass

**Key point:** Implementer **blocks on RFC approval** - cannot proceed with conflicting requirements.

---

### Scenario 4: Test Change Requested by Implementer

**Problem:** Implementer believes tests are wrong (test is the bug, not implementation)

**This is the most sensitive scenario** - tests define contracts, so changing them requires extra scrutiny.

**Example:**
```
Test: test_password_strength_requires_special_char

def test_password_strength_requires_special_char():
    with pytest.raises(WeakPasswordError):
        service.register_user("alice@example.com", "Abc12345")  # No special char

Implementer: "This test is wrong. The spec says 'strong password' but doesn't
require special characters. This test is adding a requirement not in the spec."
```

**RFC Process:**

1. **Implementer files RFC:**
   ```markdown
   # RFC: Remove Special Character Requirement from Password Tests

   **Filed by:** Implementer - Claude
   **Affected artifact:** tests/unit/test_user_service.py

   ## Problem
   **Discovery context:** Implementation

   **Issue:** Test requires special character in password, but spec doesn't.

   **Evidence:**
   - SPEC says: "Password must be ≥8 characters with uppercase, lowercase, digit"
   - Test requires: Special character (!@#$%...)
   - This is a requirement not in the spec

   **Impact:** Implementation that follows spec will fail test.

   ## Proposed Solution

   **Option 1: Remove test requirement** (if test is wrong)
   Change test to not require special character.

   **Option 2: Update spec** (if test captured implicit requirement)
   Add special character requirement to spec, then update implementation.

   ## Contract Strength Analysis

   Removing special char requirement **weakens** password security.
   - Before: 8+ chars, uppercase, lowercase, digit, special = stronger
   - After: 8+ chars, uppercase, lowercase, digit = weaker

   **Recommendation:** Option 2 (update spec to include special char requirement)
   - Rationale: Stronger passwords = better security
   - Test captured a security best practice
   ```

2. **Test Writer reviews RFC:**
   - Examines spec and test
   - Determines whether test is wrong or spec is incomplete

3. **Decision:**

   **If test is wrong (test added requirement not in spec):**
   - Test Writer approves RFC
   - Updates test to match spec
   - Test goes to Test Reviewer for re-review

   **If spec is incomplete (test correctly captured implicit requirement):**
   - Test Writer rejects RFC
   - Suggests filing RFC against spec instead
   - Implementer files spec RFC to add requirement
   - Once spec updated, implementation conforms to updated spec + tests

**Key principle:** Tests cannot be changed to make implementation pass unless test demonstrably wrong. Default assumption is test is correct.

**Extra validation required:**
- Test Reviewer must approve test changes
- Spec Reviewer must confirm test change doesn't weaken contract
- If contract weakens, strong security/usability justification required

---

### Scenario 5: Skeleton Change Discovered During Test Writing

**Problem:** Test Writer discovers skeleton interface doesn't support required testing

**Example:**
```
Skeleton: UserService.register_user(email, password) -> User

Test needs to verify: "Registration fails if database unavailable"

Problem: How to simulate database failure with current interface?
Need way to inject failing repository for this test.

Skeleton is missing: Dependency injection for UserRepository
```

**RFC Process:**

1. **Test Writer files RFC:**
   ```markdown
   # RFC: Add Dependency Injection to UserService Skeleton

   **Filed by:** Test Writer - Claude
   **Affected artifact:** src/user_service.py (skeleton)

   ## Problem
   **Discovery context:** Test writing

   **Issue:** Cannot test error case "Registration fails if database unavailable"
   because skeleton doesn't support dependency injection.

   **Current skeleton:**
   ```python
   class UserService:
       def __init__(self):
           self._repo = PostgreSQLUserRepository()  # Hardcoded!
   ```

   **Impact:** Cannot inject mock repository that raises StorageError.

   ## Proposed Solution
   Add dependency injection to skeleton:
   ```python
   class UserService:
       def __init__(self, user_repository: UserRepository):
           self._user_repository = user_repository
   ```

   **Rationale:** Follows testability principle in GUIDELINES.md.
   ```

2. **Skeleton Writer reviews RFC:**
   - Validates skeleton is not testable as-is
   - Approves change

3. **Updated skeleton goes to Skeleton Reviewer:**
   - Validates dependency injection added correctly
   - Approves

4. **Test Writer continues:**
   - Can now write test with mock repository

**Key point:** This is a structural fix to skeleton, not a behavioral change. Usually approved.

---

## RFC Decision Criteria

### When to APPROVE RFC

✓ **Approve if:**
- Artifact has genuine gap, ambiguity, or error
- Proposed change fixes problem without introducing new issues
- Downstream work is blocked without change
- Change maintains or strengthens contract quality

### When to REJECT RFC

❌ **Reject if:**
- Problem is misunderstanding of artifact's intent (clarify instead)
- Proposed change weakens contract without strong justification
- Alternative solution exists that doesn't require artifact change
- Issue is actually in discoverer's work, not artifact

---

## RFC Anti-Patterns

### Anti-Pattern 1: Changing Tests to Make Implementation Pass

❌ **Problem:**
```
Implementation doesn't normalize emails to lowercase.

Implementer files RFC: "Remove email normalization test"
Rationale: "My implementation doesn't do this"

Result: Tests weakened to match lazy implementation
```

✓ **Fix:**
```
Test Reviewer rejects RFC:
"Test correctly verifies spec requirement. Fix implementation instead."

Result: Implementation corrected to meet contract
```

**Why:** Tests define contracts. Implementation conforms to tests, not vice versa.

---

### Anti-Pattern 2: RFC Without Evidence

❌ **Problem:**
```
RFC: "Spec should include email validation"
Problem: "I think we need it"
Evidence: [None]

Result: Unclear whether this is real need or personal preference
```

✓ **Fix:**
```
RFC: "Spec should include email validation"
Problem: "Skeleton Writer cannot create email validation interface method"
Evidence:
- Spec says "validate email" but doesn't define validation rules
- Cannot write EmailValidator interface without knowing requirements

Result: Clear problem with concrete evidence
```

**Why:** RFCs must demonstrate actual problem, not theoretical improvements.

---

### Anti-Pattern 3: Bypassing RFC Process

❌ **Problem:**
```
Implementer discovers spec ambiguity.
Implementer: "I'll just guess what this means and implement it."
[Implements wrong behavior]
Test fails, confusion ensues.

Result: Wasted effort, wrong implementation
```

✓ **Fix:**
```
Implementer discovers spec ambiguity.
Implementer files RFC describing ambiguity.
Spec Writer clarifies in updated spec.
Implementer proceeds with correct understanding.

Result: Correct implementation, no wasted effort
```

**Why:** Guessing spec intent leads to errors. RFC ensures alignment.

---

### Anti-Pattern 4: Treating RFCs as Permanent Blocks

❌ **Problem:**
```
Implementer files RFC on Monday.
Spec Writer on vacation for 2 weeks.
Implementer waits idly for 2 weeks.

Result: Work blocked unnecessarily
```

✓ **Fix:**
```
Implementer files RFC on Monday.
Spec Writer on vacation.
Platform Lead designates backup reviewer (another Spec Writer).
RFC reviewed within 24 hours.

Result: Work continues with minimal delay
```

**Why:** RFCs need timely review. Designate backups for critical roles.

---

## RFC Metrics

Track RFC metrics to identify patterns:

**Healthy patterns:**
- ~1-2 RFCs per feature (some clarification expected)
- Most RFCs from test writing stage (tests reveal gaps)
- >80% approval rate (most RFCs are legitimate)

**Unhealthy patterns:**
- >5 RFCs per feature (specs are low quality)
- Most RFCs from implementation stage (specs/tests missing too much)
- <50% approval rate (RFC process being abused)
- High RFC rate from one person (training need)

**Trigger Checkpoint Review if:**
- >50% of features require RFCs (see [FeedbackLoops.md](FeedbackLoops.md))

---

## Relationship to Other Processes

**RFC vs Checkpoint Review:**

| Aspect | RFC | Checkpoint Review |
|--------|-----|------------------|
| Scope | Tactical (SPEC/Tests/Skeletons) | Strategic (VISION/SCOPE/ROADMAP) |
| Frequency | Frequent (~1-2 per feature) | Infrequent (~1 per phase) |
| Initiator | Anyone (Skeleton/Test/Implementation) | Platform Lead |
| Approval | Original author + reviewer | Team consensus + reviewers |

**RFC enables:** Individual artifact corrections
**Checkpoint Review enables:** Strategic direction changes

See [FeedbackLoops.md](FeedbackLoops.md) for strategic feedback.

---

## Summary

**RFC process enables tactical corrections** to approved artifacts when downstream work reveals issues.

**Key principles:**
- Contracts can be updated with justification
- Evidence required (not opinions)
- Original author reviews first
- Test changes require extra scrutiny (default: test is correct)
- Updated artifacts go through standard review
- Timely review prevents blocking work

**Goal:** Maintain high-quality contracts while allowing necessary updates based on implementation discoveries.
