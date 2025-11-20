# Meta-Project Development Plan

## Overview

This document tracks all active work for the dev_workflow_meta project. Use this as the single source of truth for:
- What's been completed
- What's currently in progress
- What to work on next
- Long-term plans and milestones

**Last Updated**: 2025-11-15

---

## Completed Work

### Project Initialization Structure Fix ✅

**Completed**: 2025-11-15

Fixed confusing nested structure where `init-project.sh` created projects inside `dev_workflow_meta/`.

**Solution implemented:**
- Auto-detect when running from inside dev_workflow_meta repository
- Create projects in parent directory (as siblings) when detected
- Intelligent template fallback (checks submodule and meta project locations)
- Clear user messaging showing where project is being created
- Display absolute path in success message and next steps
- Updated Quick Start documentation in README.md and ConcreteProjectSetup.md

**Result**: New projects are now created as siblings to dev_workflow_meta, avoiding circular submodule references and maintaining clean structure.

### Meta-Project Structure Fixes ✅

**Completed**: 2025-11-14

- Fixed README.md structure and content
- Restored entry points to root directory
- Added docs/MetaProjectStructure.md guidance
- Updated CONTRIBUTING.md

### Email Communication Integration

**Goal**: Enable asynchronous, bidirectional communication between workflow roles while preserving the structured artifact-driven approach.

**Reference Project**: `MultiModelCLIEmail` is a separate project where these ideas were prototyped. A reference copy is in `docs/inspiration/MultiModelCLIEmail/` to copy from, but **not to work on directly**. We'll implement email integration in this project's `Workflow/` directory.

**Approach**: Start simple (event-driven notifications), evolve toward full automation (supervised agents) based on learnings.

#### Phase 1: Event-Driven Email ✅

**Completed**: 2025-11-14

Simple workflow handoffs with email notifications. Roles check email at strategic points (before/during/after work).

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

#### Phase 2: Lightweight Supervision ✅

**Completed**: 2025-11-14

Proof of concept for continuous async monitoring. Simple daemon that automatically processes review requests.

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

**Limitations** (to be addressed in Phase 3):
- No loop detection
- No state management across invocations
- No budget tracking

---

## Current Work

### Immediate Issues to Address

**Priority**: These issues affect new users trying to adopt the workflow. Should be addressed before promoting wider adoption.

#### 1. ConcreteProjectSetup.md Missing Helper Role Integration ✅

**Completed**: 2025-11-15 (commit c2ff59b)

**Problem**: Documentation tells users to manually create VISION.md, SCOPE.md, ROADMAP.md
- We have helper roles for this: `vision-writing-helper`, `scope-writing-helper`, `roadmap-writing-helper`
- We have writer roles: `vision-writer`, `scope-writer`, `roadmap-writer`
- We have reviewer roles: `vision-reviewer`, `scope-reviewer`, `roadmap-reviewer`
- We have schemas they should follow
- Extensive documentation exists but isn't referenced

**Impact**: Users miss the guided workflow and create documents from scratch without assistance

**Actions completed**:
- [x] Rewrite ConcreteProjectSetup.md "Next Steps" section to guide users through helper workflow
- [x] Add example: "Ask AI to act as vision-writing-helper" with expected flow
- [x] Link to relevant schemas and role documentation
- [x] Show the progression: helper → writer → reviewer → approved artifact

**Result**: ConcreteProjectSetup.md now provides comprehensive guidance (lines 276-431) with concrete examples, detailed flow descriptions, and proper schema links.

#### 2. Broken Documentation Links ✅

**Completed**: 2025-11-20

**Problem**: Top-level docs may not properly link to helper workflow
- Entry points (CLAUDE.md, AGENTS.md, etc.) might not mention helpers
- README.md might not explain the interactive helper pattern
- New users may not discover the guided onboarding flow

**Impact**: Users don't know helpers exist or how to use them

**Actions completed**:
- [x] Audit all entry point files for helper role mentions
- [x] Verify README.md explains helper workflow
- [x] Check CONTRIBUTING.md references helpers for new projects
- [x] Add "Getting Started" section that starts with vision-writing-helper

**Result**:
- README.md now includes "Getting Started with Your First Project" section (lines 71-89) with concrete examples of using helpers
- CONTRIBUTING.md now includes "Using the Workflow in Your Own Projects" section (lines 43-48) directing new users to helpers
- Entry points (CLAUDE.md, etc.) correctly route to CONTRIBUTING.md which now references helper workflow
- All documentation properly links to ConcreteProjectSetup.md for complete guidance

#### 3. Helper Roles and Email Workflow Design

**Problem**: Helper roles (`*-writing-helper`) are interactive/conversational
- Designed for synchronous back-and-forth dialogue
- Don't fit async email-based workflow model
- Need special handling or explicit exemption from email automation

**Impact**: Unclear how helpers work in email-enabled workflow

**Design decision needed**:
- [ ] Document that helpers are synchronous-only (never run via daemon)
- [ ] Update EmailIntegration.md to clarify helper role exception
- [ ] Consider: Do helpers eventually hand off to async writers?
- [ ] Define clear boundary: helpers (sync) → writers (can be async) → reviewers (can be async)

**Proposed approach**:
- Helpers remain interactive CLI sessions (no email, no daemon)
- Helpers invoke writers when done (writers use email workflow)
- Update role documentation to clarify this distinction

---

## Future Work

### Email Integration Phase 3: Full agentd Supervision

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

**Questions to answer through Phase 2 usage before proceeding**:
- Is event-driven (Phase 1) sufficient for most workflows?
- Which roles benefit most from daemon automation?
- What performance characteristics emerge?
- Should we fast-track to Phase 3 or stabilize at Phase 2?

### Backlog Items

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

## Open Questions

These questions will be answered as we implement future phases:

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
