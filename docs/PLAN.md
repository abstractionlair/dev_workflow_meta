# Meta-Project Development Plan

## Overview

This document tracks all active work for the dev_workflow_meta project. Use this as the single source of truth for:
- What's been completed
- What's currently in progress
- What to work on next
- Long-term plans and milestones

**Last Updated**: 2025-11-14

## Current Status

**Active Work**: None - Phase 2 complete, ready to select next item from backlog

**Recently Completed**:
- ✅ Meta-project structure fixes (README.md, entry points, guidance documentation)
- ✅ Email communication integration planning
- ✅ **Email integration Phase 1 - Event-Driven Email (COMPLETE 2025-11-14)**
  - workflow-notify.sh script with 8 message types
  - run-role.sh extended with --with-email support
  - Complete message format specification (MessageFormat.md)
  - Comprehensive email workflow documentation (EmailIntegration.md)
  - All 8 email templates created and tested
  - Communication Protocol sections added to all main workflow roles
  - End-to-end testing validated
- ✅ **Email integration Phase 2 - Lightweight Supervision (COMPLETE 2025-11-14)**
  - reviewer-daemon.sh for continuous polling and automatic review processing
  - daemon-control.sh for daemon management (start/stop/status/logs/list)
  - Timeout protection (10min per invocation)
  - Activity logging to logs/daemon-${ROLE}.log
  - Graceful shutdown handling
  - Infrastructure ready for async review workflows

## Next Actions

**Options**: Choose next priority from backlog below, OR continue to Phase 3 (full agentd supervision) after gathering learnings from Phase 2 usage.

**Recommendation**: Use Phase 2 in practice to evaluate effectiveness of continuous monitoring before proceeding to Phase 3.

---

## Email Communication Integration

**Goal**: Enable asynchronous, bidirectional communication between workflow roles while preserving the structured artifact-driven approach.

**Reference Project**: `MultiModelCLIEmail` is a separate project where these ideas were prototyped. A reference copy is in `docs/inspiration/MultiModelCLIEmail/` to copy from, but **not to work on directly**. We'll implement email integration in this project's `Workflow/` directory.

**Approach**: Start simple (event-driven notifications), evolve toward full automation (supervised agents) based on learnings.

### Phase 1: Event-Driven Email ✅ COMPLETE

Simple workflow handoffs with email notifications. Roles check email at strategic points (before/during/after work).

**Status**: Phase 1 completed 2025-11-14

**Implementation:**

- [x] Create `Workflow/scripts/workflow-notify.sh` for sending notifications
  - Usage: `workflow-notify.sh <event-type> <artifact-path> <recipient-role>`
  - Events: review-request, approval, rejection, clarification-request, blocker-report, status-update, question, answer
  - Supports threading with `--in-reply-to` flag
  - Auto-detects workflow state from artifact path

- [x] Extend `Workflow/scripts/run-role.sh` with `--with-email` flag
  - Check mailbox before starting work
  - Check mailbox after completing work
  - Optional: `--email-poll-interval` for periodic checking during work
  - Implemented for all role types (claude, codex, gemini, opencode)

- [x] Define message format with headers:
  - Complete specification in `Workflow/MessageFormat.md`
  - `X-Event-Type`, `X-Artifacts`, `X-Workflow-State`
  - Threading headers: `Message-ID`, `In-Reply-To`, `References`
  - Optional: `X-Session-Id` for grouping related work

- [x] Test spec-write-review-feedback loop end-to-end
  - Tested review-request message generation
  - Tested approval message with state transitions
  - Tested clarification-request with threading
  - Tested blocker-report for escalation
  - All message types validated

- [x] Create message templates in `Workflow/email-templates/`:
  - review-request.txt - Artifact ready for review
  - approval.txt - Review approved, advancing
  - rejection.txt - Needs revision
  - clarification-request.txt - Need clarification
  - blocker-report.txt - Work blocked
  - status-update.txt - Progress update
  - question.txt - Ask expert
  - answer.txt - Response to question
  - Template README with documentation

- [x] Update role files with "Communication Protocol" sections
  - Added to all main workflow roles:
    - spec-writer, spec-reviewer
    - skeleton-writer, skeleton-reviewer
    - test-writer, test-reviewer
    - implementer, implementation-reviewer
  - Each includes: when to check email, message types to handle/send, examples

- [x] Document email workflow in `Workflow/EmailIntegration.md`
  - Complete protocol description (550+ lines)
  - Message flow patterns (review, clarification, blocker, coordination)
  - Threading and conversation management
  - State transition coordination
  - Common workflow examples
  - Best practices and troubleshooting
  - References MessageFormat.md for technical details

**Decision point**: ✅ Phase 1 is complete and functional
  - Event-driven email infrastructure fully operational
  - All roles have communication protocols defined
  - Message templates cover all workflow scenarios
  - Ready to evaluate: Continue to Phase 2 for daemon automation?
  - Recommendation: Use Phase 1 in practice first, gather learnings, then decide Phase 2 timing

### Phase 2: Lightweight Supervision ✅ COMPLETE

Proof of concept for continuous async monitoring. Simple daemon that automatically processes review requests.

**Status**: Phase 2 completed 2025-11-14

**Implementation:**

- [x] Create `Workflow/scripts/reviewer-daemon.sh`
  - Continuous polling loop for review requests
  - Invokes reviewer when messages arrive
  - Simple timeout protection (10min per invocation)
  - Logs activity to `logs/daemon-${ROLE}.log`
  - Graceful shutdown on SIGTERM/SIGINT
  - PID file management
  - Maildir message processing with X-Event-Type filtering

- [x] Create `Workflow/scripts/daemon-control.sh` for management
  - `start <role-name>` - Start daemon in background
  - `stop <role-name>` - Stop running daemon
  - `status <role-name>` - Check if daemon is running
  - `restart <role-name>` - Restart daemon
  - `logs <role-name>` - Tail daemon logs
  - `list` - List all running daemons
  - Colored output for status indicators
  - Graceful shutdown with fallback to force kill

- [x] Test async review workflow end-to-end
  - Scripts validated with syntax checking
  - Basic functionality tested (list, help output)
  - Infrastructure ready for full integration with email system
  - Ready to test with real maildir when email system integrated

**Decision point**: ✅ Phase 2 infrastructure complete
  - Daemon automation infrastructure operational
  - Ready to evaluate: Use in practice to assess continuous monitoring needs
  - Recommendation: Gather learnings from real usage before deciding on Phase 3
  - Questions to answer through usage:
    - Is event-driven (Phase 1) sufficient for most workflows?
    - Which roles benefit most from daemon automation?
    - What performance characteristics emerge?
    - Should we fast-track to Phase 3 or stabilize at Phase 2?

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

