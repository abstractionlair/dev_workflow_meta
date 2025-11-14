# Meta-Project Development Plan

## Overview

This document tracks all active work for the dev_workflow_meta project. Use this as the single source of truth for:
- What's been completed
- What's currently in progress
- What to work on next
- Long-term plans and milestones

**Last Updated**: 2025-11-14

## Current Status

**Active Work**: None - waiting to select next item from backlog below

**Recently Completed**:
- ✅ Meta-project structure fixes (README.md, entry points, guidance documentation)
- ✅ Email communication integration planning

## Next Actions

**Top Priority**: Email integration Phase 1 - Basic email automation (see detailed plan below)

When complete (or paused), see backlog at end of document.

---

## Email Communication Integration

**Goal**: Enable asynchronous, bidirectional communication between workflow roles while preserving the structured artifact-driven approach.

**Reference Project**: `MultiModelCLIEmail` is a separate project where these ideas were prototyped. A reference copy is in `docs/inspiration/MultiModelCLIEmail/` to copy from, but **not to work on directly**. We'll implement email integration in this project's `Workflow/` directory.

**Approach**: Start simple (event-driven notifications), evolve toward full automation (supervised agents) based on learnings.

### Phase 1: Event-Driven Email

Simple workflow handoffs with email notifications. Roles check email at strategic points (before/during/after work).

**Implementation:**

- [ ] Create `Workflow/scripts/workflow-notify.sh` for sending notifications
  - Usage: `workflow-notify.sh <event-type> <artifact-path> <recipient-role>`
  - Events: spec-ready-for-review, review-complete, approval, rejection, etc.

- [ ] Extend `Workflow/scripts/run-role.sh` with `--with-email` flag
  - Check mailbox before starting work
  - Check mailbox after completing work
  - Optional: `--email-poll-interval` for periodic checking during work

- [ ] Define message format with headers:
  - `X-Event-Type`, `X-Artifacts`, `X-Workflow-State`
  - Example: `[REVIEW REQUEST] Authentication spec ready`

- [ ] Test spec-write-review-feedback loop end-to-end
  - Spec Writer creates spec → email to Spec Reviewer
  - Spec Reviewer sends feedback → email to Spec Writer
  - Validate bidirectional communication works

- [ ] Create message templates in `Workflow/email-templates/`:
  - Review request, approval, rejection
  - Clarification request, blocker report
  - Status update, question/answer

- [ ] Update role files with "Communication Protocol" sections
  - When to check email (before/during/after)
  - What message types to handle
  - What message types to send
  - Templates to use

- [ ] Document email workflow in `Workflow/EmailIntegration.md`
  - Protocol description
  - Threading and artifact management
  - `X-Artifacts` headers with glob patterns for state transitions

- [ ] Decision point: Evaluate if event-driven email is sufficient
  - Is it useful enough to continue?
  - Which roles benefit most?
  - Which events are highest value?
  - Continue to Phase 2 or stay here longer?

### Phase 2: Lightweight Supervision

Proof of concept for continuous async monitoring. Simple daemon that automatically processes review requests.

**Implementation:**

- [ ] Create `Workflow/scripts/reviewer-daemon.sh`
  - Continuous polling loop for review requests
  - Invokes reviewer when messages arrive
  - Simple timeout protection (10min per invocation)
  - Logs activity to `logs/daemon-${ROLE}.log`

- [ ] Create `Workflow/scripts/daemon-control.sh` for management
  - `start <role-name>` - Start daemon in background
  - `stop <role-name>` - Stop running daemon
  - `status <role-name>` - Check if daemon is running

- [ ] Test async review workflow end-to-end
  - Spec Writer sends review request → returns to other work
  - Reviewer daemon picks up automatically
  - Review sent back without manual intervention
  - Spec Writer notified

- [ ] Decision point: Is continuous monitoring needed?
  - Is event-driven sufficient?
  - Which roles need daemons vs manual triggering?
  - Fast-track to Phase 3 or stay at Phase 2?

**Limitations** (to be addressed in Phase 3):
- No loop detection
- No state management across invocations
- No budget tracking

---

### Phase 3: Full agentd Supervision

Production-ready async multi-model workflow with robust error handling and loop prevention.

**Implementation:**

- [ ] Create generalized supervisor `Workflow/scripts/agentd.py`
  - Works for any role (not just reviewers)
  - Supports persistent_session mode (keep CLI alive) and single_shot mode
  - State management across invocations
  - Configurable per role via `config/supervisor-config.json`

- [ ] Implement loop detection and budgets
  - ErrorSignature normalization (strip line numbers, paths)
  - DeltaProof tracking across attempts
  - Budget management per error type (deps=1, perm=0, test-fail=2, etc.)
  - BLOCKED escalation when budget exhausted
  - Workspace fingerprinting (detect actual changes)

- [ ] Extend `msg` tool with full protocol
  - Headers: X-Thread, X-Seq, X-Event-Id, Auto-Submitted, X-Loop
  - Body fields: Mode, ErrorSignature, DeltaProof, BudgetRemaining, NextAction
  - Diagnose mode and template
  - ACTION_REQUEST/ACTION_RESULT protocol

- [ ] Update all role files with error handling invariants
  - Verify after every action (exit code + output)
  - No repeat without DeltaProof
  - Same error twice → switch to Diagnose mode
  - Diagnose proposes ≥2 distinct hypotheses
  - Budget awareness and escalation to BLOCKED

- [ ] Decision point: Expand or stabilize?
  - Add more roles to agentd supervision?
  - Focus on reliability and optimization?
  - Advanced features: multi-parent threading, cross-machine sync?

---

## Open Questions

These questions will be answered as we implement the phases above:

- [ ] **Model assignment**: Which AI model for which workflow role?
  - Spec Writer: Claude? GPT-5?
  - Reviewer: Different model than writer for diversity?
  - Implementer: Best coding model?

- [ ] **Escalation paths**: When BLOCKED, who resolves?
  - Coordinator (human) always involved?
  - Platform Lead can resolve some blocks?
  - Peer roles can help?

- [ ] **Conversation vs workflow**: When to use email vs artifacts?
  - Transient discussion → email
  - Decisions → artifacts
  - How to migrate insights from email to artifacts?

---

## Backlog Items

When email integration Phase 1 is complete (or paused), choose from:

- **TDD pattern for non-code artifacts** - Document and formalize the discovered TDD approach for prompts/templates (see pattern description below)
- **State transition discipline detection** - Add checks to workflow-status.sh to detect when work starts without moving specs from `todo/` to `doing/`
- **Feature branch creation timing** - Verify and fix when/how skeleton-writer creates feature branches
- **Merge timing verification** - Document when feature branches merge to main and who performs merges
- **Vision/scope schema enhancements** - Update vision role/schema to focus on timeline, tech stack, available time, deferred scope
- **Timestamp resolution in file names** - Need higher resolution timestamps (likely milliseconds)
- **Version history cleanup** - There is still version history to remove from somewhere (need to specify where)

### TDD Pattern for Non-Code Artifacts (Prompts/Templates)

We discovered this TDD approach works for specs whose implementation is prompts/prompt templates/context (not code):

**Skeleton Phase:**
- Create outline of prompt document structure
- Headers, sections, subsections with placeholders
- Each section marked: "This section needs to be written."

**Test Phase:**
- Tests become evals using LLM Judge
- Tell model how to "fail" when info is missing
- Define success criteria for each prompt section

**Implementation Phase:**
- Make tests pass by writing actual prompt content
- Iterative refinement based on eval results

**To implement/document:**
- Decide: New schema `schema-prompt-artifact.md` OR new section in existing schemas (implementation, test)?
- Update relevant role files (skeleton-writer, test-writer, implementer)
- Create example showing the pattern in action

---

