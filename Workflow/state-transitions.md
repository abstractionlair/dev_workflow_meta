# State Transitions

This document is the **single source of truth** for state transitions in the development workflow. It defines **who moves what when** with detailed preconditions, postconditions, and git commands.

For different perspectives:
- **High-level overview**: [workflow-overview.md](workflow-overview.md) - Mermaid diagrams and principles
- **Quick reference**: [LayoutAndState.md](LayoutAndState.md#state-transition-summary) - Directory structure and summary table
- **Ownership matrix**: [Workflow.md](Workflow.md#artifact-ownership-matrix) - Who creates, approves, and moves artifacts

## Artifact State Machine

### Specification States

Specs move through four states from draft to complete:

```
proposed/ → todo/ → doing/ → done/
```

| State | Directory | Meaning | Who Owns | Next Transition |
|-------|-----------|---------|----------|-----------------|
| **Draft** | `specs/proposed/` | Spec written, awaiting review | Spec Writer | Spec Reviewer moves to `todo/` if approved |
| **Approved** | `specs/todo/` | Review passed, ready to implement | Spec Reviewer (gatekeeper) | Skeleton Writer moves to `doing/` when starting work |
| **In Progress** | `specs/doing/` | Implementation underway | Skeleton Writer → Test Writer → Implementer | Implementation Reviewer moves to `done/` when complete |
| **Complete** | `specs/done/` | Implementation finished and merged | Implementation Reviewer (gatekeeper) | Terminal state (archived or remains) |

### Bug Report States

Bug reports move through three states from discovery to fix:

```
to_fix/ → fixing/ → fixed/
```

| State | Directory | Meaning | Who Owns | Next Transition |
|-------|-----------|---------|----------|-----------------|
| **Reported** | `bugs/to_fix/` | Bug identified, needs investigation | Bug Reporter | Bug Fixer moves to `fixing/` when starting work |
| **Fixing** | `bugs/fixing/` | Investigation and fix in progress | Bug Fixer (Implementer) | Implementation Reviewer moves to `fixed/` when approved |
| **Fixed** | `bugs/fixed/` | Fix merged, sentinel test added | Implementation Reviewer (gatekeeper) | Terminal state (permanent archive) |

### RFC States

RFCs move through three possible outcomes:

```
open/ → approved/ OR rejected/
```

| State | Directory | Meaning | Who Owns | Next Transition |
|-------|-----------|---------|----------|-----------------|
| **Open** | `rfcs/open/` | Change request pending decision | RFC Creator | Original artifact author moves to `approved/` or `rejected/` |
| **Approved** | `rfcs/approved/` | Change accepted, artifact updated | Original Artifact Author | Terminal state (archived) |
| **Rejected** | `rfcs/rejected/` | Change rejected with rationale | Original Artifact Author | Terminal state (archived) |

---

## Ownership Matrix: Who Moves What

### Specification Workflow

| Transition | Who | Action | Git Command |
|------------|-----|--------|-------------|
| proposed/ → todo/ | **Spec Reviewer** | Approve spec after review | `git mv specs/proposed/<feature>.md specs/todo/<feature>.md` |
| todo/ → doing/ | **Skeleton Writer** | Start implementation (create feature branch) | `git mv specs/todo/<feature>.md specs/doing/<feature>.md` |
| doing/ → done/ | **Implementation Reviewer** | Approve completed implementation | `git mv specs/doing/<feature>.md specs/done/<feature>.md` |

**Critical rule:** Only **gatekeepers** (reviewers) can move artifacts forward. Writers/implementers cannot self-approve.

### Bug Fix Workflow

| Transition | Who | Action | Git Command |
|------------|-----|--------|-------------|
| to_fix/ → fixing/ | **Bug Fixer** | Start investigation | `git mv bugs/to_fix/<bug>.md bugs/fixing/<bug>.md` |
| fixing/ → fixed/ | **Implementation Reviewer** | Approve fix and sentinel test | `git mv bugs/fixing/<bug>.md bugs/fixed/<bug>.md` |

**Note:** Bug Fixer can self-move from to_fix → fixing (no review needed to start investigation). Only the fixing → fixed transition requires reviewer approval.

### RFC Workflow

| Transition | Who | Action | Git Command |
|------------|-----|--------|-------------|
| open/ → approved/ | **Original Artifact Author** | Accept change request | `git mv rfcs/open/<rfc>.md rfcs/approved/<rfc>.md` |
| open/ → rejected/ | **Original Artifact Author** | Reject change request | `git mv rfcs/open/<rfc>.md rfcs/rejected/<rfc>.md` |

**Rationale:** The original author decides whether to accept changes to their work. RFC creator proposes, author decides.

### Review Requests

| Transition | Who | Action | Git Command |
|------------|-----|--------|-------------|
| Create request | **Writer/Implementer** | Request review with context | `git add review-requests/<type>/<request>.md` |
| Claim request | **Reviewer** (optional) | Mark as in-progress | Edit front matter: `reviewer: [name]` |
| Complete request | **Reviewer** | Create review document | `git add reviews/<type>/<review>.md` |
| Archive request | **Reviewer** | Move completed request | `git mv review-requests/<type>/<request>.md review-requests/archived/` |

---

## State Transition Details

### 1. Spec: proposed/ → todo/

**Preconditions:**
- ✓ Spec complete in `specs/proposed/<feature>.md`
- ✓ Spec reviewed by Spec Reviewer
- ✓ Review status: APPROVED

**Transition:**
```bash
# Spec Reviewer executes:
git mv specs/proposed/<feature>.md specs/todo/<feature>.md
git add reviews/specs/<timestamp>-<feature>-APPROVED.md
git commit -m "Approve spec: <feature>"
```

**Postconditions:**
- Spec in `specs/todo/` ready for implementation
- Review record in `reviews/specs/`
- Skeleton Writer can start work

**Who can execute:** Only Spec Reviewer (gatekeeper role)

---

### 2. Spec: todo/ → doing/

**Preconditions:**
- ✓ Spec approved in `specs/todo/<feature>.md`
- ✓ Skeleton Writer assigned to feature
- ✓ Feature branch created

**Transition:**
```bash
# Skeleton Writer executes:
git checkout -b feature/<feature>
git mv specs/todo/<feature>.md specs/doing/<feature>.md
git commit -m "Start implementing: <feature>"
```

**Postconditions:**
- Spec in `specs/doing/` on feature branch
- Skeleton Writer begins creating interfaces
- Spec locked to this implementation effort

**Who can execute:** Skeleton Writer (first implementer)

**Note:** This is NOT a gatekeeper transition - the writer moves it themselves when starting work. The gatekeeper transition was proposed → todo.

---

### 3. Spec: doing/ → done/

**Preconditions:**
- ✓ Skeleton complete and reviewed
- ✓ Tests complete and reviewed
- ✓ Implementation complete
- ✓ All tests passing
- ✓ Implementation review: APPROVED
- ✓ Pull request merged to main

**Transition:**
```bash
# Implementation Reviewer executes (after merging PR):
git checkout main
git pull
git mv specs/doing/<feature>.md specs/done/<feature>.md
git commit -m "Complete implementation: <feature>"
git push
```

**Postconditions:**
- Spec in `specs/done/` on main branch
- Feature complete and merged
- Ready for next feature

**Who can execute:** Only Implementation Reviewer (gatekeeper role)

**Critical:** This transition only happens AFTER the pull request is merged, not before. Implementation Reviewer approves the PR, merges it, then moves the spec.

---

### 4. Bug: to_fix/ → fixing/

**Preconditions:**
- ✓ Bug report complete in `bugs/to_fix/<bug>.md`
- ✓ Bug Fixer assigned

**Transition:**
```bash
# Bug Fixer executes:
git mv bugs/to_fix/<bug>.md bugs/fixing/<bug>.md
git commit -m "Investigate bug: <bug>"
```

**Postconditions:**
- Bug report in `bugs/fixing/`
- Bug Fixer investigates root cause
- Root Cause section added to bug report

**Who can execute:** Bug Fixer (self-move, no review needed)

**Rationale:** Starting investigation doesn't require approval, only completing the fix does.

---

### 5. Bug: fixing/ → fixed/

**Preconditions:**
- ✓ Root cause identified (Root Cause section in bug report)
- ✓ Fix implemented
- ✓ Sentinel test created in `tests/regression/`
- ✓ Sentinel test verified (fails on old code, passes on new code)
- ✓ All tests passing
- ✓ Bug fix review: APPROVED
- ✓ Pull request merged

**Transition:**
```bash
# Implementation Reviewer executes (after merging PR):
git checkout main
git pull
git mv bugs/fixing/<bug>.md bugs/fixed/<bug>.md
git commit -m "Fix bug: <bug>"
git push
```

**Postconditions:**
- Bug report in `bugs/fixed/` (permanent archive)
- Sentinel test in `tests/regression/` preventing recurrence
- Fix merged to main

**Who can execute:** Only Implementation Reviewer (gatekeeper role)

---

### 6. RFC: open/ → approved/

**Preconditions:**
- ✓ RFC filed in `rfcs/open/<rfc>.md`
- ✓ Original artifact author reviewed RFC
- ✓ Author decides to accept change

**Transition:**
```bash
# Original Artifact Author executes:
# 1. Update the affected artifact
# 2. Move RFC to approved
git mv rfcs/open/<rfc>.md rfcs/approved/<rfc>.md
git add <affected-artifact>
git commit -m "Approve RFC: <description>"
```

**Postconditions:**
- RFC in `rfcs/approved/`
- Artifact updated
- Work continues with updated artifact

**Who can execute:** Only original artifact author (they own the decision)

**Note:** If artifact needs re-review after changes, follow normal review process for that artifact type.

---

### 7. RFC: open/ → rejected/

**Preconditions:**
- ✓ RFC filed in `rfcs/open/<rfc>.md`
- ✓ Original artifact author reviewed RFC
- ✓ Author decides to reject change

**Transition:**
```bash
# Original Artifact Author executes:
# 1. Add decision rationale to RFC
# 2. Move RFC to rejected
git mv rfcs/open/<rfc>.md rfcs/rejected/<rfc>.md
git commit -m "Reject RFC: <description> - <brief rationale>"
```

**Postconditions:**
- RFC in `rfcs/rejected/` with rationale
- Artifact unchanged
- RFC creator must work within existing constraints

**Who can execute:** Only original artifact author (they own the decision)

**Important:** Rejection must include clear rationale in RFC document explaining why the change was rejected.

---

## Planning Document Transitions

Planning documents (VISION.md, SCOPE.md, ROADMAP.md) don't move between directories - they're updated in place with version increments.

### VISION.md Updates

**Normal updates (minor refinements):**
```bash
# Vision Writer executes:
# 1. Edit VISION.md
# 2. Increment version number in document
# 3. Commit with descriptive message
git add VISION.md
git commit -m "Update VISION.md to v1.1: <change summary>"
```

**Checkpoint Review updates (strategic changes):**
```bash
# After Checkpoint Review session:
# 1. Update VISION.md with strategic changes
# 2. Increment major version
# 3. Require re-review
git add VISION.md
git commit -m "Update VISION.md to v2.0: <strategic change summary>"

# Vision Reviewer then reviews and approves/rejects v2.0
```

**Version numbering:**
- **Minor updates (v1.0 → v1.1):** Clarifications, small additions, no strategic change
- **Major updates (v1.0 → v2.0):** Strategic pivots, scope changes, core assumptions changed

### SCOPE.md Updates

Same pattern as VISION.md:
- Minor updates: Increment minor version (v1.0 → v1.1)
- Major updates: Increment major version (v1.0 → v2.0), require re-review

### ROADMAP.md Updates

**Phase completion updates:**
```bash
# After phase completes:
# 1. Mark phase as complete
# 2. Update phase dates based on actuals
# 3. Commit
git add ROADMAP.md
git commit -m "Mark Phase 1 complete in ROADMAP.md"
```

**Just-in-time detailing:**
```bash
# During late Phase N, detail Phase N+1:
# 1. Expand Phase N+1 features from outlines to specifics
# 2. Update version
# 3. Commit
git add ROADMAP.md
git commit -m "Detail Phase 2 features in ROADMAP.md"
```

**Checkpoint Review updates:**
```bash
# After Checkpoint Review:
# 1. Update phase sequencing, features, timing
# 2. Increment major version
# 3. Require re-review
git add ROADMAP.md
git commit -m "Update ROADMAP.md to v2.0: <strategic change summary>"
```

---

## Consistency Rules

### Rule 1: Gatekeepers Control Forward Movement

**Gatekeepers (reviewers) move artifacts forward:**
- Spec Reviewer: proposed/ → todo/
- Implementation Reviewer: doing/ → done/, fixing/ → fixed/

**Writers/implementers can only:**
- Create artifacts in initial location (proposed/, to_fix/, open/)
- Move from todo/ → doing/ (start work, not a quality gate)
- Self-move to_fix/ → fixing/ (start investigation, not a quality gate)

**Rationale:** Prevents self-approval, ensures independent review.

### Rule 2: One Artifact, One State

An artifact cannot exist in multiple states simultaneously:
- ❌ `specs/proposed/feature.md` AND `specs/todo/feature.md`
- ✓ Only one copy in one directory at a time

**Enforcement:** Use `git mv` (not `cp`) to ensure atomic moves.

### Rule 3: Review Records Don't Move

Once created, review documents are immutable and never move:
- ✓ `reviews/specs/<timestamp>-<feature>-APPROVED.md` stays forever
- ❌ Never move or delete review records
- ✓ Create new review for re-review (new timestamp)

**Rationale:** Maintains audit trail, shows history of approvals.

### Rule 4: Terminal States Are Permanent

Artifacts in terminal states never move again:
- `specs/done/` - Feature complete (may stay or archive)
- `bugs/fixed/` - Bug fixed (permanent archive, NEVER delete)
- `rfcs/approved/` - Change approved (permanent archive)
- `rfcs/rejected/` - Change rejected (permanent archive)

**Exception:** Archiving old completed work to archive/ directories for project cleanup (optional).

---

## State Transition Flowchart

### Feature Specification State Machine

```
┌─────────────┐
│   Writer    │
│   Creates   │
│    Spec     │
└──────┬──────┘
       │
       v
┌─────────────────┐
│ specs/proposed/ │ ◄──┐ Needs Changes
└────────┬────────┘    │
         │             │
         │ Spec        │
         │ Reviewer    │
         v             │
    ┌────────┐         │
    │Approved│─────────┘
    └───┬────┘    No
        │ Yes
        v
┌─────────────┐
│ specs/todo/ │
└──────┬──────┘
       │
       │ Skeleton Writer
       │ Starts Work
       v
┌──────────────┐
│ specs/doing/ │ ◄──┐
└──────┬───────┘    │
       │            │ (RFC Process
       │            │  may update
       │            │  spec during
       │            │  implementation)
       │            │
       │ Impl       │
       │ Complete   │
       v            │
   ┌────────┐      │
   │Approved│──────┘
   └───┬────┘  No
       │ Yes
       v
┌─────────────┐
│ specs/done/ │
└─────────────┘
 (Terminal)
```

### Bug Report State Machine

```
┌─────────────┐
│    Bug      │
│  Discovered │
└──────┬──────┘
       │
       v
┌──────────────────┐
│ bugs/to_fix/     │
└────────┬─────────┘
         │
         │ Bug Fixer
         │ Starts
         v
┌─────────────────┐
│ bugs/fixing/    │
│ (Investigation) │
└────────┬────────┘
         │
         │ Fix +
         │ Sentinel
         │ Test
         v
    ┌────────┐
    │Approved│─────┐ No
    └───┬────┘     │
        │ Yes      │
        v          │
┌──────────────┐   │
│ bugs/fixed/  │ ◄─┘
└──────────────┘
 (Terminal)
```

---

## Common Scenarios

### Scenario 1: Normal Feature Implementation

```
1. Spec Writer creates       → specs/proposed/user-auth.md
2. Spec Reviewer approves    → specs/todo/user-auth.md
3. Skeleton Writer starts    → specs/doing/user-auth.md (on feature branch)
4. Test Writer writes tests  → (spec stays in doing/)
5. Implementer implements    → (spec stays in doing/)
6. Impl Reviewer approves    → specs/done/user-auth.md (merged to main)
```

### Scenario 2: Spec Needs Changes

```
1. Spec Writer creates       → specs/proposed/user-auth.md
2. Spec Reviewer rejects     → (stays in proposed/)
3. Spec Writer revises       → (still in proposed/)
4. Spec Reviewer re-reviews  → (new review document created)
5. Spec Reviewer approves    → specs/todo/user-auth.md
```

### Scenario 3: RFC During Implementation

```
1. Implementer finds issue   → rfcs/open/rfc-20251026-user-auth-validation.md
2. Spec Writer reviews RFC   → (original spec author)
3. Spec Writer approves      → rfcs/approved/rfc-20251026-user-auth-validation.md
4. Spec Writer updates spec  → specs/doing/user-auth.md (updated on feature branch)
5. Implementation continues  → (with updated spec)
```

### Scenario 4: Bug Fix

```
1. Bug discovered            → bugs/to_fix/BUG-123-empty-email.md
2. Bug Fixer starts          → bugs/fixing/BUG-123-empty-email.md
3. Bug Fixer investigates    → (Root Cause added to bug report)
4. Bug Fixer implements fix  → (code + sentinel test)
5. Impl Reviewer approves    → bugs/fixed/BUG-123-empty-email.md
6. Sentinel test added       → tests/regression/test_bug_123.py
```

---

## Navigation

- **[Workflow Overview](workflow-overview.md)** - High-level workflow diagrams
- **[Feedback Loops](feedback-loops-diagram.md)** - RFC and Checkpoint Review processes
- **[LayoutAndState.md](LayoutAndState.md)** - Directory structure reference
- **[Workflow.md](Workflow.md)** - Detailed workflow documentation
