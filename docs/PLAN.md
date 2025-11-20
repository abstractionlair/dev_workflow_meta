# Meta-Project Development Plan

## Overview

This document tracks all active work for the dev_workflow_meta project. Use this as the single source of truth for:
- What's been completed
- What's currently in progress
- What to work on next
- Long-term plans and milestones

### Planning Philosophy

**This plan is intentionally simple, linear, and chronological.**

Since this is a meta-project (defines a workflow for other projects), we avoid over-planning to prevent "plans to make plans to make plans" recursion. The plan follows a straightforward progression:
- Phase 1 → Phase 2 → Phase 3 (email integration evolution)
- Each phase builds on the previous
- Features listed in implementation order where dependencies exist
- Backlog items tracked but not elaborately prioritized

**Success criterion:** Being able to migrate other projects onto this workflow and see improved development pace.

**Last Updated**: 2025-11-20 (Added Phase 3 panel infrastructure requirements)

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

### Documentation Fixes & Improvements ✅

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

#### 3. Helper Roles and Email Workflow Design ✅

**Completed**: 2025-11-20

**Problem**: Helper roles (`*-writing-helper`) are interactive/conversational
- Designed for synchronous back-and-forth dialogue
- Don't fit async email-based workflow model
- Need special handling or explicit exemption from email automation

**Impact**: Unclear how helpers work in email-enabled workflow

**Actions completed**:
- [x] Document that helpers are synchronous-only (never run via daemon)
- [x] Update EmailIntegration.md to clarify helper role exception
- [x] Defined clear boundary: helpers (sync) → writers (can be async) → reviewers (can be async)

**Result**:
- `Workflow/EmailIntegration.md` now includes a "Synchronous vs. Asynchronous Roles" section explicitly distinguishing the models.
- All Helper role definitions (`role-*-writing-helper.md`) now include an "Interaction Model" section clarifying they are interactive-only and explaining the handoff trigger.

---

## Current Work

### Email Integration Phase 3: Full agentd Supervision

Production-ready async multi-model workflow with robust error handling and loop prevention.

**Implementation order (linear):**

1. Fix known email tooling issues
2. Build core agentd supervisor
3. Add interactive intervention capability
4. Implement panel infrastructure
5. (Expected: Iterate on email tooling based on panel usage discoveries)

**Detailed tasks:**

- [ ] 1. Improve email tooling for model usage
  - **Fix `msg` tool (or replace)**:
    - Current issues: escape sequences not working (newlines show as `\n`), HTML/XML tags getting stripped
    - Solution: Write message to temp file, pass file path to CLI rather than piping content
    - Makes message content more reliable
  - **Efficient email search**:
    - Don't waste tokens reading every file in maildir
    - Use `mu` (maildir search tool) for queries
    - Or: provide code execution capability for models to write search scripts
    - Example: "Find all review-request messages about auth.md in last 7 days" → `mu` query, not manual file reading

- [ ] 2. Create generalized supervisor `Workflow/scripts/agentd.py`
  - **Fresh context model**: Each spawn starts with clean slate
  - **Queue draining behavior**:
    - Spawn CLI with fresh context
    - Process all messages in email queue
    - After each message, check for new arrivals
    - Continue until queue empty
    - Exit (don't wait/poll)
    - Next spawn is fresh context again
  - **Catch-up protocol**: When spawned, model must:
    - Read relevant artifacts (VISION.md, SPEC.md, etc. based on role)
    - Review recent email threads (not entire maildir history)
    - Get context from artifacts + emails, not from prior sessions
    - Need to provide guidance on efficient catch-up strategy
  - **Configuration**: `config/supervisor-config.json`
    - Role-to-CLI mapping
    - Catch-up artifacts per role (e.g., spec-reviewer reads current spec)
    - Email lookback window (e.g., last 7 days, or threads touching current artifacts)

- [ ] 3. Implement Interactive Intervention UX
  - **Physical layout**: One terminal per active role, each running `agentd` in foreground
    - Example: Terminal 1: `agentd spec-reviewer`, Terminal 2: `agentd implementer`, etc.
    - Each agentd process is visible (not background daemon) so you can see what it's doing
  - **Keystroke detection**: agentd watches for specific key (e.g., `i` for interactive)
    - Non-blocking stdin monitoring while running event loop
    - Immediate response when keystroke detected
  - **Interactive mode launch**: When interrupted, agentd:
    - Pauses its monitoring loop
    - Spawns appropriate CLI tool based on role (claude, codex, gemini, etc.)
    - Hands control to interactive session
  - **Auto-resume**: When interactive session closes:
    - agentd detects subprocess exit
    - Automatically resumes monitoring loop
    - Continues processing email queue
  - **Configuration**: Role-to-CLI mapping in `config/supervisor-config.json`
    - Maps role name → CLI command to launch
    - Example: `spec-reviewer` → `claude --role spec-reviewer`

  **Rationale**: Solves event loop juggling problem. Instead of managing multiple CLI sessions manually, watch agentd terminals and jump into interactive mode only when needed.

- [ ] 4. Implement panel-based role infrastructure
  - Panel coordination for multi-model review (Tier 1 priority)
  - Panel coordination for multi-model writing (Tier 2 priority)
  - Email visibility boundaries (panel-internal vs cross-panel)
  - Independence enforcement (fresh context + different prompts)
  - Primary + helpers decision pattern for writing panels
  - Consensus mechanisms for review panels
  - Panel-specific message routing and filtering

  **Note**: Panel infrastructure will likely reveal new email system requirements. Expect to iterate on email tooling after this is working.

**Design documented in:**
- [Workflow/EmailIntegration.md](../Workflow/EmailIntegration.md) - Email Communication Model, Panel-Based vs. Solo Roles, Independence Principle, Email Visibility Boundaries

**Key principles:**
- **Review panels (highest value)**: Catch "didn't think of that" failures - all significant artifacts reviewed by panels
- **Writing panels (strategic value)**: Collaborative exploration for vision/scope/roadmap/spec
- **Solo implementation (sufficient)**: Skeleton/test/implementation work
- **Independence via**: Fresh context + different role prompts + email isolation
- **Email phases**: Collaborative (strategic/planning), transactional (implementation), collaborative (exception handling)

---

## Future Work

### Backlog Items

**Note:** None of these items need to be addressed before Phase 3.

- **TDD pattern for non-code artifacts** - Document and formalize the discovered TDD approach for prompts/templates (see pattern description below)
- **State transition discipline** - Enforce proper state transitions throughout workflow. Includes: moving specs from `todo/` to `doing/` when work starts, proper feature branch creation timing, and correct merge timing. May involve checks in workflow-status.sh, pre-commit hooks, or role enforcement.
- **Timestamp resolution in file names** - Need higher resolution timestamps (likely milliseconds). Issue: one CLI tool didn't allow the agent to get accurate times.
- **Loop detection and budgets** - ErrorSignature normalization, DeltaProof tracking, budget management per error type, BLOCKED escalation when exhausted, workspace fingerprinting. Originally needed for infinite event loops; may be less necessary after model upgrades. Implement if loops resurface.

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

- [x] **Model assignment**: Addressed via panel-based roles
  - Panels use multiple models (vertical diversity)
  - Same models can be on writer and reviewer panels (horizontal diversity via fresh context)
  - See [Workflow/EmailIntegration.md](../Workflow/EmailIntegration.md) - Panel-Based vs. Solo Roles

- [ ] **Escalation paths**: When BLOCKED, who resolves?
  - Coordinator (human) always involved?
  - Platform Lead can resolve some blocks?
  - Peer roles can help?

- [x] **Conversation vs workflow**: Answered via phase-based email model
  - Strategic/planning phases: Collaborative email encouraged
  - Implementation phases: Transactional email preferred
  - Exception handling: Collaborative email for problem-solving
  - Principle: Email coordinates, artifacts remain source of truth
  - See [Workflow/EmailIntegration.md](../Workflow/EmailIntegration.md) - Email Communication Model

---