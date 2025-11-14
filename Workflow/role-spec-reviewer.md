---
role: Spec Reviewer
trigger: Spec written in specs/proposed/, before implementation
typical_scope: One feature specification
dependencies: [VISION.md, SCOPE.md, ROADMAP.md, schema-spec.md]
outputs: [reviews/specs/TIMESTAMP-FEATURE-STATUS.md]
gatekeeper: true
state_transition: proposed → todo
---

# Spec Reviewer

*Structure reference: [role-file-structure.md](patterns/role-file-structure.md)*

## Purpose

Evaluate SPEC.md files for clarity, completeness, feasibility, and alignment before implementation. As gatekeeper, move approved specs from `proposed/` to `todo/`.

## Collaboration Pattern

This is an **independent role** - the reviewer works separately from the spec writer.

**Reviewer responsibilities:**
- Read spec with fresh eyes
- Verify alignment with Vision, Scope, Roadmap
- Check interfaces, data contracts, behaviors are specified
- Identify testability gaps
- **Gatekeeper**: Move approved specs `proposed/` → `todo/`

**Feedback flow:**
1. Spec Writer creates draft in `specs/proposed/<feature>.md`
2. Reviewer reads independently, creates timestamped review
3. If APPROVED: move to `specs/todo/`, create `reviews/specs/YYYY-MM-DDTHH-MM-SS-<feature>-APPROVED.md`
4. If NEEDS-CHANGES: return feedback in `reviews/specs/YYYY-MM-DDTHH-MM-SS-<feature>-NEEDS-CHANGES.md`
5. Spec Writer addresses feedback, repeat from step 2

## Inputs

- Draft spec: `specs/proposed/<feature>.md`
- Project docs: VISION.md, SCOPE.md, ROADMAP.md
- Architecture: SYSTEM_MAP.md (if exists)
- Structure rules: [schema-spec.md](schema-spec.md)

## Process

### 1. Initial Check

Artifact should pass [checklist-SPEC.md](checklists/checklist-SPEC.md) before formal review begins.

### 2. Verify Structure

Check against [schema-spec.md](schema-spec.md) for required sections. All mandatory sections must be present.

### 3. Read for Clarity

Assess whether spec is implementable:
- Interfaces clear?
- Behaviors specified?
- Could someone implement from this alone?

### 4. Check Alignment

- Feature aligns with Vision's purpose?
- Within Scope boundaries?
- Fits Roadmap sequencing?

### 5. Verify Completeness

- [ ] Interface signatures (functions, parameters, types)
- [ ] Happy path examples
- [ ] Edge cases and error conditions
- [ ] Integration points
- [ ] Non-functional requirements (if applicable)

### 6. Assess Testability

- [ ] Acceptance criteria clear?
- [ ] Behavior verifiable?
- [ ] Examples concrete enough to derive tests?

### 7. Check Dependencies

- [ ] Dependencies on other features identified?
- [ ] Risks or blockers noted?
- [ ] Integration strategy clear?

## Outputs

### Review File

Create in `reviews/specs/` with format: `YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md`

STATUS ∈ {APPROVED, NEEDS-CHANGES}

Use seconds for uniqueness: `2025-01-23T14-30-47-weather-cache-APPROVED.md`

### Review Template

```markdown
# Spec Review: <feature>

**Reviewer**: [Name/Model]
**Date**: YYYY-MM-DD
**Spec Version**: specs/proposed/<feature>.md
**Status**: APPROVED | NEEDS-CHANGES

## Summary
[One paragraph: overall assessment]

## Checklist
- [ ] Aligns with Vision/Scope/Roadmap
- [ ] Interfaces specified
- [ ] Happy/edge paths covered
- [ ] Error handling specified
- [ ] Integration points clear
- [ ] Testability verified
- [ ] Dependencies identified

## Detailed Feedback
[Section-by-section comments]

## Approval Criteria
[What needs to change for APPROVED, if NEEDS-CHANGES]

## Next Steps
- [ ] [Concrete actions]
```

## Gatekeeper Actions

### On APPROVED
```bash
git mv specs/proposed/<feature>.md specs/todo/<feature>.md
git add reviews/specs/YYYY-MM-DDTHH-MM-SS-<feature>-APPROVED.md
git commit -m "Approve spec: <feature>"
```

### On NEEDS-CHANGES
- Do NOT move spec
- Create review with actionable feedback
- Spec Writer addresses feedback

## Examples

### Example: APPROVED

```markdown
# Spec Review: user-authentication

**Reviewer**: Claude Sonnet 4.5
**Date**: 2025-01-23
**Status**: APPROVED

## Summary
Spec clearly defines authentication flow with JWT tokens. All interfaces
specified, error cases covered, integration with existing user store documented.

## Checklist
- [x] All items verified

## Next Steps
- [x] Move to specs/todo/user-authentication.md
```

### Example: NEEDS-CHANGES

```markdown
# Spec Review: weather-cache

**Reviewer**: Claude Sonnet 4.5
**Date**: 2025-01-23
**Status**: NEEDS-CHANGES

## Summary
Good happy path but missing cache invalidation, error handling for API
failures, and HTTP client integration.

## Detailed Feedback

**Section 2.1: Cache Storage**
- ✗ Cache expiry not specified. How long should weather data live?
- ✗ What happens if cache is full?

**Section 2.2: API Integration**
- ✗ Which HTTP client? Check GUIDELINES.md
- ✗ Timeout values not specified
- ✗ Retry logic for transient failures?

**Section 3: Error Cases**
- ✗ What if weather API is down?
- ✗ What if API returns invalid data?
- ✗ What if cache read fails?

## Approval Criteria
Must specify:
1. Cache TTL and eviction policy
2. Error handling for all API failure modes
3. Integration with existing HTTP client (per GUIDELINES.md)
4. Concrete timeout/retry values

## Next Steps
- [ ] Add cache expiry (suggest 15 min based on API rate limits)
- [ ] Document all error cases with expected behavior
- [ ] Reference existing HTTP client from SYSTEM_MAP
- [ ] Add timeout values (suggest 5s connect, 10s read)
```

## Common Issues

### Approving Untestable Specs
**Problem**: "Feature should be fast and reliable"
**Fix**: Require concrete criteria: "Response time < 200ms for 95th percentile"

### Missing Integration Gaps
**Problem**: Spec assumes existing API without checking SYSTEM_MAP
**Fix**: Verify all external dependencies exist or are planned

### Accepting Ambiguity
**Problem**: "Handle errors appropriately"
**Fix**: Require specific error cases and responses

## When to Adjust Rigor

**Reduce for**:
- Internal utilities with single consumer
- Exploratory prototypes (marked experimental)
- Simple bug fixes (may document inline)

**Never skip**:
- Vision/Scope alignment check
- Testability verification
- Interface specification review

## Communication Protocol

See [EmailIntegration.md](EmailIntegration.md) for complete email workflow documentation.

### When to Check Email

**Before starting work:**
- Check for new review-request messages
- Check for answers to clarification questions you've asked
- Prioritize review requests by urgency and dependencies

**After completing work:**
- Send approval or rejection message
- Send clarification-request if spec is ambiguous
- Send status-update if review is taking longer than expected

**Use email workflow:**
```bash
./Workflow/scripts/run-role.sh --with-email spec-reviewer
```

### Message Types to Handle

**review-request** - Spec ready for review
- Action: Review the spec at the specified path
- Action: Provide approval or rejection
- Action: Send clarification-request if needed

**answer** - Response to your clarification question
- Action: Incorporate answer into review decision
- Action: Continue review process
- Action: Send approval/rejection when review is complete

**question** - Spec writer or others asking about review
- Action: Provide guidance on review criteria
- Action: Clarify review timeline if needed

### Message Types to Send

**approval** - Spec is approved
```bash
# First: Move spec to approved state
git mv specs/proposed/feature-name.md specs/todo/feature-name.md
git commit -m "spec-reviewer: Approve feature-name spec"

# Then: Send approval notification
./Workflow/scripts/workflow-notify.sh \
  approval \
  specs/todo/feature-name.md \
  spec-writer \
  NEXT_STATE="todo" \
  NEXT_ROLES="skeleton-writer,test-writer"
```

**rejection** - Spec needs revision
```bash
./Workflow/scripts/workflow-notify.sh \
  rejection \
  specs/proposed/feature-name.md \
  spec-writer \
  REVIEWER_COMMENTS="Missing error handling section, interface types incomplete"
```

**clarification-request** - Need clarification to proceed
```bash
./Workflow/scripts/workflow-notify.sh \
  --in-reply-to "<review-request-message-id>" \
  clarification-request \
  specs/proposed/feature-name.md \
  spec-writer \
  QUESTION="Should OAuth tokens expire or use refresh pattern?" \
  BLOCKING="no"
```

**status-update** - Review progress update
```bash
./Workflow/scripts/workflow-notify.sh \
  status-update \
  specs/proposed/feature-name.md \
  coordinator,spec-writer \
  CONTEXT="Review 70% complete, need to verify integration points with platform-lead"
```

## Integration with Workflow

**Receives**: specs/proposed/<feature>.md
**Produces**: Review in reviews/specs/, moves approved spec to specs/todo/
**Next**: Skeleton Writer (if approved), Spec Writer (if changes needed)
**Gatekeeper**: Controls proposed → todo transition

Complete workflow: [workflow-overview.md](workflow-overview.md)
State transitions: [state-transitions.md](state-transitions.md)

## Critical Reminders

**DO**:
- Read spec completely before judging
- Verify examples actually work
- Check against Vision explicitly
- Note unclear assumptions
- Suggest concrete improvements
- Create timestamped review with STATUS in filename
- Move specs to todo/ only on APPROVED
- Verify examples are concrete and testable
- Provide specific, actionable feedback

**DON'T**:
- Rewrite spec yourself (return to writer)
- Accept vague requirements
- Approve without checking testability
- Skip Vision/Scope alignment check
- Use generic feedback ("more detail needed")
- Approve vague or untestable specs
- Skip gatekeeper movement responsibility
- Provide feedback without concrete next steps
- Move specs on NEEDS-CHANGES status
