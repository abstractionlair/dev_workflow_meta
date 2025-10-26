# Feedback Loops

## Purpose

Software development is iterative. Implementation reveals insights that may invalidate planning assumptions. This document defines formal processes for feeding implementation learnings back to strategic planning.

**Key principle:** Planning artifacts (VISION, SCOPE, ROADMAP) are not immutable. When reality diverges from plans, update plans rather than force implementation to follow invalidated assumptions.

---

## Feedback Loop Types

### 1. Strategic Feedback (Checkpoint Review)

**Flow:** Implementation → VISION/SCOPE/ROADMAP

When to trigger and what to update.

### 2. Tactical Feedback (RFC Process)

**Flow:** Implementation → SPEC/Tests

Covered in [RFC.md](RFC.md) - Request for Change process.

---

## Checkpoint Review Process

### What Is a Checkpoint Review?

A **Checkpoint Review** is a formal pause to assess whether strategic planning documents (VISION, SCOPE, ROADMAP) still align with implementation reality.

**Not to be confused with:**
- Regular feature reviews (implementation-reviewer approvals)
- RFC process for spec/test changes (see RFC.md)

**Purpose:**
- Detect when core assumptions invalidated
- Update strategic direction based on learnings
- Prevent wasted effort building wrong thing

---

## When to Trigger Checkpoint Review

A Checkpoint Review is triggered when **any** of these conditions occur:

### Trigger 1: Phase Completion

**Condition:** A roadmap phase completes (all features done)

**Rationale:** Natural reflection point. Did this phase validate our assumptions?

**Example:**
```
ROADMAP.md Phase 1: Foundation (DONE)
- User authentication ✓
- Task CRUD operations ✓
- Basic API endpoints ✓

Checkpoint: Before starting Phase 2, review learnings from Phase 1
```

**Action:** Platform Lead schedules checkpoint review meeting/session

---

### Trigger 2: High Spec Change Rate

**Condition:** >50% of implemented features required spec changes during implementation

**Rationale:** Frequent spec changes signal planning misalignment

**Example:**
```
Last 10 features implemented:
- 6 required spec amendments (RFC process)
- Common theme: Original specs underestimated data volume requirements

Signal: SCOPE.md may need "Non-Functional Requirements" update
```

**Action:** Implementer or Implementation Reviewer flags pattern to Platform Lead

---

### Trigger 3: Core Assumption Invalidated

**Condition:** Implementation discovers a core assumption in VISION/SCOPE/ROADMAP is false

**Rationale:** Continuing with invalid assumptions wastes effort

**Examples:**

**Example 1: Technical Feasibility**
```
SCOPE.md assumption: "PostgreSQL can handle 10M tasks with sub-100ms queries"

Implementation discovery: Prototype shows 500ms queries at 1M tasks

Impact: Core assumption invalid, architecture needs rethinking
```

**Example 2: User Behavior**
```
VISION.md assumption: "Users will organize tasks into projects"

Implementation discovery: User testing shows users ignore project feature

Impact: Core feature assumption invalid, may need different approach
```

**Example 3: Dependency Availability**
```
ROADMAP.md dependency: "We'll use Library X for authentication"

Implementation discovery: Library X deprecated, no longer maintained

Impact: Technical dependency assumption invalid
```

**Action:** Anyone (Spec Writer, Implementer, Platform Lead) can flag to Platform Lead

---

## Checkpoint Review Process Steps

### Step 1: Platform Lead Identifies Need

**Who:** Platform Lead (or anyone raises to Platform Lead)

**What:**
- Recognizes one of the trigger conditions
- Decides whether checkpoint review warranted

**Output:** Decision to proceed with checkpoint review

---

### Step 2: Assemble Findings

**Who:** Platform Lead (may delegate)

**What:** Gather evidence of misalignment

**Collect:**
- Spec RFCs: What changed and why?
- Implementation challenges: What was harder than expected?
- User feedback: What surprised us?
- Performance data: What metrics differ from assumptions?
- Technical discoveries: What did we learn?

**Example findings document:**
```markdown
# Checkpoint Review Findings: Phase 1

## Spec Changes (6 RFCs filed)
- RFC-001: Task query performance (added pagination)
- RFC-002: User authentication (added OAuth, removed basic auth)
- RFC-003: Data model (added task tags, removed categories)
- RFC-004: API rate limiting (added requirement)
- RFC-005: Task search (added full-text search requirement)
- RFC-006: Error handling (standardized format)

## Common Themes
1. **Performance:** Underestimated scale (3 RFCs)
2. **Authentication:** Original basic auth insufficient (1 RFC)
3. **Data model:** Users need flexible organization (1 RFC)

## Core Assumption Check
- SCOPE.md: "System will support 100 concurrent users"
  Reality: Need 1,000 concurrent users (client demand)

- ROADMAP.md: "Basic auth sufficient for Phase 1"
  Reality: OAuth required (security audit requirement)

## Recommendation
Update SCOPE.md Non-Functional Requirements:
- Concurrent users: 100 → 1,000
- Authentication: Add OAuth to Phase 1 scope
```

**Output:** Findings document with themes and recommendations

---

### Step 3: Review Session

**Who:** Platform Lead + key stakeholders (Spec Writers, Implementers, Product Owner if applicable)

**What:** Discuss findings, decide what changes needed

**Questions to answer:**
1. **Do we need to update VISION.md?**
   - Has our "why" or "who benefits" changed?
   - Do success metrics need adjustment?

2. **Do we need to update SCOPE.md?**
   - Are in-scope/out-of-scope boundaries still correct?
   - Have constraints changed (timeline, team size, budget)?
   - Do NFRs need updating?

3. **Do we need to update ROADMAP.md?**
   - Should we re-sequence features?
   - Add/remove features from phases?
   - Adjust phase goals or success criteria?

**Example decisions:**
```
DECISION 1: Update SCOPE.md
- NFR: Concurrent users 100 → 1,000
- NFR: Add performance testing requirement
- Constraint: Timeline extended 4 weeks

DECISION 2: Update ROADMAP.md
- Move "Advanced search" from Phase 2 → Phase 1 (higher priority than expected)
- Defer "Export to CSV" from Phase 1 → Phase 2 (lower priority)

DECISION 3: No VISION.md change needed
- Core vision still valid
```

**Output:** List of decisions (which docs to update, what changes)

---

### Step 4: Update Strategic Documents

**Who:** Original document authors (Vision Writer, Scope Writer, Roadmap Writer) or Platform Lead

**What:** Make approved changes to VISION/SCOPE/ROADMAP

**Process for each document:**

1. **Create new version:**
   ```markdown
   ## Version

   v2.0 (2025-10-26)

   **Changes from v1.0:**
   - Updated NFR: Concurrent users 100 → 1,000
   - Updated constraint: Timeline extended 4 weeks
   - Rationale: Checkpoint Review after Phase 1 revealed scale requirements
   ```

2. **Update content:**
   - Make specific changes identified in review session
   - Add rationale for changes

3. **Version bump:**
   - Minor changes (clarifications, small scope adjustments): Increment minor version (v1.0 → v1.1)
   - Major changes (significant scope/timeline changes): Increment major version (v1.0 → v2.0)

**Example SCOPE.md update:**
```markdown
# Scope: TaskFlow API

## Non-Functional Requirements

**Performance:**
- ~~100~~ **1,000** concurrent users
- API response time: p95 < 200ms
- **Added:** Performance testing required before Phase 1 completion

**Constraints:**

**Timeline:**
- ~~Phase 1: 8 weeks~~ **Phase 1: 12 weeks**
- Phase 2: 8 weeks

**Rationale:** Checkpoint Review after implementing 50% of Phase 1 features
revealed client requires 10x concurrent user capacity. Extended timeline to
accommodate performance optimization work.

## Version

v2.0 (2025-10-26)

**Changes from v1.0:**
- Updated NFR: Concurrent users 100 → 1,000
- Added NFR: Performance testing requirement
- Updated constraint: Phase 1 timeline 8w → 12w
- Rationale: Checkpoint Review findings (see reviews/scope/checkpoint-2025-10-26.md)
```

**Output:** Updated VISION.md, SCOPE.md, and/or ROADMAP.md with new versions

---

### Step 5: Re-review Updated Documents

**Who:** Appropriate reviewers (Vision Reviewer, Scope Reviewer, Roadmap Reviewer)

**What:** Review updated documents to ensure changes are sound

**Why:** Changes to strategic documents are significant - warrant review

**Process:** Standard review process (see schema-review.md)

**Output:** Review artifacts in `reviews/vision/`, `reviews/scope/`, `reviews/roadmap/`

---

### Step 6: Communicate Changes

**Who:** Platform Lead

**What:** Notify team of strategic document updates

**How:**
- Team meeting/standup announcement
- Written summary of changes and rationale
- Update project README if necessary

**Example communication:**
```markdown
# Checkpoint Review Complete: Phase 1 Learnings

## Summary
After implementing 50% of Phase 1 features, we conducted a Checkpoint Review.

## Key Findings
- Client requires 10x concurrent user capacity (1,000 not 100)
- OAuth authentication required (not basic auth)
- Users need more flexible task organization

## Strategic Document Updates
- SCOPE.md v1.0 → v2.0
  - NFR: Concurrent users 100 → 1,000
  - Timeline: Phase 1 extended 4 weeks

- ROADMAP.md v1.0 → v1.1
  - Moved "Advanced search" to Phase 1 (higher priority)
  - Deferred "Export CSV" to Phase 2 (lower priority)

## Impact on Current Work
- Implementers: Focus on performance optimization for remaining Phase 1 features
- Spec Writers: New specs should target 1,000 concurrent users
- Test Writers: Add performance tests to test suites

## Questions?
Contact Platform Lead
```

**Output:** Team is informed and aligned on strategic changes

---

## Checkpoint Review Anti-Patterns

### Anti-Pattern 1: Ignoring Warning Signs

❌ **Problem:**
```
Implementer: "This is the 5th spec that needed changes due to scale..."
Platform Lead: "Just implement what's spec'd, we'll deal with it later."

Result: Continue building for wrong scale, accumulate technical debt
```

✓ **Fix:**
```
Implementer: "This is the 5th spec that needed changes due to scale..."
Platform Lead: "Good catch - that's a pattern. Let's trigger a checkpoint review."

Result: Early detection of misalignment, strategic course correction
```

**Why:** Ignoring patterns leads to wasted effort and rework.

---

### Anti-Pattern 2: Checkpoint Review Without Evidence

❌ **Problem:**
```
Platform Lead: "I have a feeling we should change the roadmap..."
Team: "Based on what?"
Platform Lead: "Just a hunch."

Result: Arbitrary changes without justification, team confusion
```

✓ **Fix:**
```
Platform Lead: "Let's review our checkpoint evidence..."
[Shows: 6 spec RFCs, all related to scale assumptions]
Platform Lead: "Data shows our scale assumptions were off. Let's update SCOPE.md."

Result: Evidence-based decisions, team alignment
```

**Why:** Changes to strategic documents must be justified with evidence.

---

### Anti-Pattern 3: Treating Planning Docs as Immutable

❌ **Problem:**
```
Implementer: "This assumption in SCOPE.md is clearly wrong now..."
Platform Lead: "SCOPE was approved. We can't change it. Just implement it."

Result: Building wrong thing, wasted effort
```

✓ **Fix:**
```
Implementer: "This assumption in SCOPE.md is clearly wrong now..."
Platform Lead: "Good find. Let's trigger a checkpoint review and update SCOPE if needed."

Result: Adapt plans to reality, build right thing
```

**Why:** Plans should serve reality, not the other way around.

---

### Anti-Pattern 4: Checkpoint Review Without Re-Review

❌ **Problem:**
```
Platform Lead updates SCOPE.md v1.0 → v2.0 with major changes.
No one reviews the changes.
Team proceeds with potentially flawed updates.

Result: Quality gate bypassed, potential errors in strategic direction
```

✓ **Fix:**
```
Platform Lead updates SCOPE.md v1.0 → v2.0 with major changes.
Scope Reviewer reviews changes for soundness.
After approval, team proceeds with confidence.

Result: Strategic changes validated, team has confidence in direction
```

**Why:** Strategic document changes are significant and warrant review.

---

## Relationship to RFC Process

**Checkpoint Review** and **RFC Process** are complementary:

| Aspect | Checkpoint Review | RFC Process |
|--------|------------------|-------------|
| **Scope** | Strategic (VISION/SCOPE/ROADMAP) | Tactical (SPEC/Tests/Skeletons) |
| **Trigger** | Phase completion, pattern of changes, core assumption invalid | Individual discovery during skeleton/test/implementation |
| **Frequency** | Infrequent (per phase, ~monthly) | Frequent (per feature, ~weekly) |
| **Initiator** | Platform Lead | Any role (Skeleton Writer, Test Writer, Implementer) |
| **Approval** | Strategic reviewers | Spec Reviewer + impacted role reviewers |

**Example flow:**
```
1. Implementer discovers spec issue → Files RFC (tactical)
2. RFC approved, spec updated
3. After 6 similar RFCs, pattern emerges
4. Platform Lead triggers Checkpoint Review (strategic)
5. SCOPE.md updated to address root cause
6. Future specs written against updated SCOPE
```

See [RFC.md](RFC.md) for tactical change process.

---

## Summary

**Checkpoint Review** enables strategic course correction based on implementation learnings.

**Key points:**
- Planning documents are not immutable
- Trigger when phase complete, high RFC rate, or core assumption invalid
- Platform Lead coordinates review process
- Gather evidence, review as team, update docs with version bump
- Re-review updated strategic documents
- Communicate changes to team

**Goal:** Ensure strategic direction remains aligned with reality, adapt plans based on learnings.
