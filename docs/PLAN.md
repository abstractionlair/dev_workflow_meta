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

**Top Priority**: Email integration Milestone 1 - Basic email automation (see detailed plan below)

---

## Backlog Items

When email integration Milestone 1 is complete (or paused), choose from:

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

## Email Communication Integration

**Goal**: Enable asynchronous, bidirectional communication between workflow roles while preserving the structured artifact-driven approach.

**Overall Status**: Planning complete - ready to begin Milestone 1 when selected

### Background

#### Current State

**dev_workflow_meta** (this project) provides:
- Structured artifact workflow (vision → scope → roadmap → specs → implementation)
- Clear role definitions (writers, reviewers, implementers, platform lead)
- Git-based state transitions with gatekeepers
- Scripts for launching roles and checking workflow status

**MultiModelCLIEmail** (another project; reference copy in docs/inspiration/MultiModelCLIEmail) provides:
- Maildir-based messaging using standard email protocols
- `msg` CLI tool for send/poll/read/reply operations
- `run-role.sh` for launching agents with role context
- Support for multiple AI models (Claude, GPT-5, Gemini, Grok)

#### The Problem

Current workflow requires **manual handoffs** between roles:
- Spec writer completes → manually invoke spec reviewer
- Reviewer approves → manually move files, notify next role
- Implementer blocked → manually ask for help
- No mechanism for clarification questions during work

#### The Solution

Integrate email communication to enable:
1. **Automated workflow notifications** (spec ready for review, approval complete, etc.)
2. **Bidirectional async communication** (ask clarifications, report blockers, get feedback)
3. **Multi-model collaboration** (different models can discuss approaches)
4. **Reduced manual coordination overhead**

### Design Principles

1. **Preserve the artifact-driven workflow** - Email complements, doesn't replace artifacts
2. **Graceful degradation** - Workflow still works without email (manual fallback)
3. **Incremental delivery** - Each milestone provides value independently
4. **Learn from usage** - Early milestones inform later ones
5. **Role autonomy** - Roles decide when to check/send email based on their needs

### Architecture Options Considered

#### Option 1: agentd Supervisor (Full Vision)
External daemon per role that continuously polls mailbox, invokes CLI tool when messages arrive, handles loop detection and budgets.

**Pros**: True async, fast response, sophisticated error handling
**Cons**: Complex, longer timeline (5-7 weeks), more moving parts

#### Option 2: Event-Driven Email Integration (Selected Approach)
Workflow scripts send notifications at key events; roles check email at strategic points (before/during/after work).

**Pros**: Simpler, faster delivery (2 weeks), natural integration
**Cons**: Not truly continuous, some latency in responses

#### Decision: Incremental Path
Start with event-driven integration (Option 2), evolve toward supervision (Option 1) based on learnings.

### Implementation Roadmap

#### Milestone 1: Basic Email Automation (Phase 1 Core)
**Timeline: 1 week**
**Goal**: Automate simple workflow handoffs with email notifications

**Deliverables:**

1. **Email-aware workflow scripts** (`Workflow/scripts/`)
   - Extend state transition scripts to send notifications
   - Create `workflow-notify.sh` helper for common notifications
   - Email format templates for workflow events

2. **Role polling integration** (`Workflow/scripts/run-role.sh`)
   - Update to check mailbox before starting work
   - Update to check mailbox after completing work
   - Add `--with-email` flag for email-enabled mode
   - Add `--email-poll-interval` for periodic checking during work

3. **Test with one complete flow**
   - Spec Writer creates spec → email sent to spec reviewer
   - Spec Reviewer reads spec, sends feedback → email to spec writer
   - Validate bidirectional communication works

**Success Criteria:**
- [ ] Can trigger a role manually, it automatically checks email
- [ ] Role can send notifications at workflow milestones
- [ ] Successfully complete one spec-write-review-feedback loop via email
- [ ] Fallback to manual mode still works if email disabled

**Technical Details:**

**New scripts**:
```bash
Workflow/scripts/workflow-notify.sh
# Usage: workflow-notify.sh <event-type> <artifact-path> <recipient-role>
# Events: spec-ready-for-review, review-complete, approval, rejection, etc.
```

**Extended scripts**:
```bash
Workflow/scripts/run-role.sh --with-email <role-name>
# Checks mailbox before running role
# Allows role to send messages during work
# Checks mailbox after completing work
```

**Message format**:
```
From: spec-writer@workflow.local
To: spec-reviewer@workflow.local
Subject: [REVIEW REQUEST] Authentication spec ready
X-Event-Type: spec-ready-for-review
X-Artifacts: specs/proposed/authentication.md
X-Workflow-State: proposed

The authentication spec is ready for review.

Spec: specs/proposed/authentication.md
Writer: spec-writer
Date: 2025-11-14
```

---

#### Milestone 2: Structured Communication Protocols (Phase 1 Complete)
**Timeline: +1 week (2 weeks total)**
**Goal**: Well-defined communication patterns for all major workflow events

**Deliverables:**

4. **Message templates** (`Workflow/email-templates/`)
   - Review request template
   - Approval/rejection template
   - Clarification request template
   - Blocker report template
   - Status update template
   - Question/answer template

5. **Role-specific email behaviors** (update role files)
   - **Reviewers**: How to respond to review requests, format for feedback
   - **Writers**: When to ask clarifications, how to request feedback
   - **Implementer**: How to report blockers, ask questions during implementation
   - **Platform Lead**: Monitor for architecture questions, provide guidance

6. **Threading and artifact management**
   - Proper use of `In-Reply-To` for conversation threads
   - `X-Artifacts` headers with glob patterns for state-independent references
   - State transitions reflected in email threads
   - Coordinator (human) can observe all threads via monitor mailbox

7. **Documentation updates**
   - Update all role files with "Communication Protocol" section
   - Document email workflow in `Workflow/EmailIntegration.md`
   - Update `GUIDELINES.md` with email conventions

**Success Criteria:**
- [ ] All major workflow events have defined message templates
- [ ] Each role knows when to check email and how to respond
- [ ] Threads properly track conversations (can follow in Mutt)
- [ ] Artifacts referenced correctly survive state transitions
- [ ] Documentation complete for email-enabled workflow

**Technical Details:**

**New directory structure**:
```
Workflow/
  email-templates/
    review-request.txt
    approval.txt
    rejection.txt
    clarification-request.txt
    blocker-report.txt
    status-update.txt
  EmailIntegration.md
```

**Role file updates** (example for spec-reviewer):
```markdown
## Communication Protocol

### Incoming Messages

Check for messages:
- **Before starting review**: Check for new review requests
- **During review**: Check for clarifications from spec writer
- **After completing review**: Check for follow-up questions

Message types to handle:
- Review requests (`X-Event-Type: spec-ready-for-review`)
- Clarification answers from writer
- Questions from implementer about approved specs

### Outgoing Messages

Send messages:
- **Review complete**: Approval or rejection with detailed feedback
- **Need clarification**: Questions about unclear requirements
- **Follow-up**: Additional comments after initial review

Use templates:
- Approval: `email-templates/approval.txt`
- Rejection: `email-templates/rejection.txt`
- Clarification: `email-templates/clarification-request.txt`
```

**Example workflow sequence**:
```
1. Spec Writer completes spec
   → Sends: review-request to spec-reviewer
   → X-Artifacts: specs/proposed/auth.md

2. Spec Reviewer checks mailbox (via run-role.sh --with-email)
   → Reads review request
   → Reviews spec
   → Sends: approval to spec-writer (or rejection with feedback)
   → State transition: specs/proposed/auth.md → specs/todo/auth.md

3. If rejection:
   → Spec Writer receives feedback
   → Updates spec
   → Sends: updated review-request (reply to original thread)
   → Loop continues until approval
```

---

#### Milestone 3: Lightweight Supervision (Phase 1.5)
**Timeline: +1-2 weeks (3-4 weeks total)**
**Goal**: Proof of concept for continuous async monitoring

**Deliverables:**

8. **Simple supervisor for reviewers** (`Workflow/scripts/reviewer-daemon.sh`)
   - Continuously polls reviewer mailboxes
   - Invokes reviewer when review requests arrive
   - Captures response, sends it back
   - Simple timeout-based protection (no complex loop detection yet)

9. **Test async review workflow**
   - Spec Writer sends review request → returns to other work
   - Reviewer daemon picks up request automatically
   - Review sent back without manual intervention
   - Spec Writer notified of review completion

10. **Monitoring and control**
    - Script to start/stop reviewer daemons
    - Log file per daemon for debugging
    - Status command to check if daemons running

**Success Criteria:**
- [ ] Reviewer daemon runs continuously without crashing
- [ ] Automatically picks up review requests within reasonable time (< 5 min)
- [ ] Completes review and sends response without manual intervention
- [ ] Can start/stop daemons easily
- [ ] Logs provide visibility into daemon activity

**Technical Details:**

**New scripts**:
```bash
Workflow/scripts/reviewer-daemon.sh <role-name>
# Continuous polling loop for review requests
# Invokes role when messages arrive
# Handles response and continues polling

Workflow/scripts/daemon-control.sh {start|stop|status} <role-name>
# Manage reviewer daemons
```

**Daemon architecture**:
```bash
#!/usr/bin/env bash
# reviewer-daemon.sh

ROLE=$1
LOG_FILE="logs/daemon-${ROLE}.log"

while true; do
    # Non-blocking check for messages
    MESSAGES=$(msg poll --role "$ROLE" 2>&1)

    if [ -n "$MESSAGES" ]; then
        echo "[$(date)] Processing messages for $ROLE" >> "$LOG_FILE"

        # Invoke role with timeout protection
        timeout 10m ./scripts/run-role.sh "$ROLE" >> "$LOG_FILE" 2>&1

        echo "[$(date)] Completed processing for $ROLE" >> "$LOG_FILE"
    fi

    # Sleep before next poll
    sleep 60
done
```

**Limitations** (to be addressed in Milestone 4):
- Simple timeout, no loop detection
- No state management across invocations
- No budget tracking
- Fixed polling interval

---

#### Milestone 4: Full agentd Supervision (Phase 2)
**Timeline: +2-3 weeks (5-7 weeks total)**
**Goal**: Production-ready async multi-model workflow with robust error handling

**Deliverables:**

11. **Generalized supervisor** (`agentd.py`)
    - Works for any role (not just reviewers)
    - Supports persistent_session mode (keep CLI alive) vs single_shot mode
    - Proper state management across invocations
    - Configurable per role via `config/supervisor-config.json`

12. **Loop detection and budgets** (from `workflow_improvements.md`)
    - ErrorSignature normalization (strip line numbers, paths)
    - DeltaProof tracking across attempts
    - Budget management per error type (deps=1, perm=0, test-fail=2, etc.)
    - BLOCKED escalation when budget exhausted
    - Workspace fingerprinting (detect actual changes)

13. **Full protocol implementation** (extend `msg` tool)
    - Headers: X-Thread, X-Seq, X-Event-Id, Auto-Submitted, X-Loop
    - Top-line fields: Mode, ErrorSignature, DeltaProof, BudgetRemaining, NextAction
    - Diagnose mode and template
    - ACTION_REQUEST/ACTION_RESULT protocol

14. **Role file invariants** (update all role files)
    - Verify after every action (exit code + output)
    - No repeat without DeltaProof
    - Same error twice → switch to Diagnose
    - Diagnose proposes multiple hypotheses
    - Budget awareness and escalation

**Success Criteria:**
- [ ] agentd runs stably for multiple roles simultaneously
- [ ] Loop detection prevents infinite retry cycles
- [ ] Budget system stops unproductive work
- [ ] BLOCKED escalations reach coordinator appropriately
- [ ] All protocol headers and fields properly implemented
- [ ] Roles follow invariants and escalate when stuck

**Technical Details:**

**New components**:
```
Workflow/scripts/agentd.py
config/supervisor-config.json
Workflow/AgentdArchitecture.md
```

**Protocol extensions** (to `MultiModelCLIEmail/scripts/msg`):
- Add header stamping: X-Thread, X-Seq, X-Event-Id, X-Loop
- Add body parsing for Mode, ErrorSignature, DeltaProof, etc.
- Validation for required fields

**Role invariants** (paste into all role files):
```markdown
## Error Handling and Loop Prevention

### Invariants

1. **Verify after every action**: Include exit code + key output
2. **No repeat without DeltaProof**: Changed args/env or code diff required
3. **Same error twice**: Switch to Diagnose mode before further action
4. **Diagnose requirement**: Propose ≥2 distinct hypotheses with different causes
5. **Budget limits**:
   - deps/missing-module: 1 attempt
   - permission/network: 0 attempts (immediate escalation)
   - test-failure: 2 attempts (require distinct patches)
   - path/import mismatch: 2 attempts
   - schema drift: 2 attempts

### Escalation

On budget exhaustion or no DeltaProof:
- Send BLOCKED message with ErrorSignature and last two attempts
- Pause work on that thread
- Wait for coordinator guidance
```

**agentd architecture** (hybrid approach from workflow_improvements.md):
- Persistent_session for stable CLIs (Gemini, optionally Claude)
- Single_shot with state prefix for others
- Poll mailbox → assemble context → invoke adapter → read response → send reply → continue

---

### Integration with Existing Workflow

#### Directory Structure

```
dev_workflow_meta/
  Workflow/
    # Existing
    role-*.md                   # Updated with Communication Protocol sections
    scripts/
      run-role.sh              # Extended with --with-email flag
      workflow-status.sh       # Extended to show email activity

    # New
    email-templates/           # Message templates
    EmailIntegration.md        # Email system documentation
    scripts/
      workflow-notify.sh       # Send workflow event notifications
      reviewer-daemon.sh       # Lightweight supervisor (M3)
      daemon-control.sh        # Daemon management (M3)
      agentd.py               # Full supervisor (M4)

  config/
    supervisor-config.json     # agentd configuration (M4)

MultiModelCLIEmail/
  .messages/                   # Maildir mailboxes
  scripts/msg                  # Extended with protocol headers (M4)
  roles/
    # Add workflow role files (reuse from dev_workflow_meta/Workflow/role-*.md)
```

#### Workflow Event Notifications

| Event | Triggered By | Notifies | Message Type |
|-------|-------------|----------|--------------|
| Spec ready for review | Spec Writer | Spec Reviewer | review-request |
| Review complete (approval) | Spec Reviewer | Spec Writer, Skeleton Writer | approval |
| Review complete (rejection) | Spec Reviewer | Spec Writer | rejection |
| Clarification needed | Reviewer | Writer | clarification-request |
| Spec approved → todo | Spec Reviewer | Skeleton Writer, Test Writer | spec-approved |
| Skeleton ready | Skeleton Writer | Skeleton Reviewer | review-request |
| Tests ready | Test Writer | Test Reviewer | review-request |
| Implementation blocked | Implementer | Coordinator, Platform Lead | blocker-report |
| Implementation ready | Implementer | Implementation Reviewer | review-request |
| Implementation approved | Implementation Reviewer | Coordinator | approval |
| Bug recorded | Bug Recorder | Implementer | bug-assignment |
| Architecture question | Any role | Platform Lead | question |

#### State Transition Integration

Extend state transition scripts to send notifications:

```bash
# When spec-reviewer approves (moves specs/proposed → specs/todo)
git mv specs/proposed/auth.md specs/todo/auth.md
git commit -m "Approve spec: authentication"

# Also send notification
./Workflow/scripts/workflow-notify.sh \
  spec-approved \
  specs/todo/auth.md \
  skeleton-writer,test-writer
```

#### Role Invocation Patterns

**Without email** (current):
```bash
./Workflow/scripts/run-role.sh spec-writer
# No email checking
```

**With event-driven email** (M1-M2):
```bash
./Workflow/scripts/run-role.sh --with-email spec-reviewer
# Checks email before/after, optionally during
```

**With supervision** (M3-M4):
```bash
./Workflow/scripts/daemon-control.sh start spec-reviewer
# Daemon runs continuously, invokes role when needed
```

### Testing Strategy

#### Milestone 1 Testing
- Manual end-to-end: Spec write → review request → review → feedback
- Verify email format and headers
- Verify fallback to manual mode if email disabled
- Test with at least 2 different AI models

#### Milestone 2 Testing
- Test all message templates
- Verify threading works (can follow in Mutt)
- Test artifact references survive state transitions
- Test bidirectional communication (questions and answers)
- Test with all primary roles (writers, reviewers, implementer)

#### Milestone 3 Testing
- Daemon stability test (run for 24 hours)
- Performance test (multiple concurrent review requests)
- Timeout protection test (long-running reviews)
- Log analysis (verify activity captured)
- Graceful shutdown test

#### Milestone 4 Testing
- Loop detection: Trigger same error multiple times
- Budget enforcement: Exhaust budget, verify escalation
- DeltaProof validation: Retry without changes, verify block
- Multi-role coordination: Complex workflow with multiple agents
- Stress test: High message volume
- Error recovery: Kill and restart agentd

### Success Metrics

#### Milestone 1
- 80% reduction in manual handoff steps for spec review flow
- Email notifications delivered within 1 minute of event
- Zero failures to fallback to manual mode

#### Milestone 2
- All major workflow events (10+) have email integration
- 100% of roles have documented communication protocols
- Threads maintain context across ≥3 message exchanges

#### Milestone 3
- Reviewer daemon uptime ≥99% over 1 week
- Review requests processed automatically within 5 minutes
- Zero missed notifications

#### Milestone 4
- Loop detection prevents ≥90% of infinite retry scenarios
- Budget system stops unproductive work in ≤2 attempts
- Multi-role workflows complete without manual intervention
- Zero uncontrolled agent loops in 1 week of testing

### Risk Mitigation

#### Risk: Email system adds complexity
**Mitigation**: Graceful degradation - workflow works without email

#### Risk: Agents get stuck in loops
**Mitigation**:
- M1-M2: Simple timeouts and manual monitoring
- M3: Daemon timeout protection
- M4: Full loop detection and budget system

#### Risk: Messages lost or delayed
**Mitigation**:
- Maildir is atomic and reliable
- Monitoring via monitor mailbox
- Can always check manually with Mutt

#### Risk: Integration breaks existing workflow
**Mitigation**:
- Email is additive, doesn't change core workflow
- Extensive testing at each milestone
- Can revert to manual mode

#### Risk: Too many daemons consuming resources
**Mitigation**:
- Start with critical roles only (reviewers)
- Monitor resource usage
- Can stop daemons and fall back to event-driven

### Decision Points

After each milestone, evaluate:

#### After Milestone 1
- **Go/No-Go for M2**: Is event-driven email useful enough to invest in structured protocols?
- **Adjust scope**: Which roles benefit most? Which events are highest value?

#### After Milestone 2
- **Go/No-Go for M3**: Is continuous monitoring needed, or is event-driven sufficient?
- **Timeline**: Fast-track to M4 or stay at M2 longer?

#### After Milestone 3
- **Go/No-Go for M4**: Is simple supervision enough, or is loop detection critical?
- **Scope**: Which roles get full agentd supervision vs lightweight daemon?

#### After Milestone 4
- **Expand or stabilize**: Add more roles, or focus on reliability and optimization?
- **Advanced features**: Multi-parent threading (true DAG), cross-machine sync, etc.

### Open Questions

1. **Model assignment**: Which AI model for which workflow role?
   - Spec Writer: Claude? GPT-5?
   - Reviewer: Different model than writer for diversity?
   - Implementer: Best coding model?

2. **Escalation paths**: When BLOCKED, who resolves?
   - Coordinator (human) always involved?
   - Platform Lead can resolve some blocks?
   - Peer roles can help?

3. **Conversation vs workflow**: When to use email vs artifacts?
   - Transient discussion → email
   - Decisions → artifacts
   - How to migrate insights from email to artifacts?

4. **Privacy and logging**:
   - All emails logged permanently?
   - Archive old threads?
   - Public repo implications (from workflow_improvements.md)?

5. **Performance**:
   - Acceptable latency for responses?
   - How many concurrent agents feasible?
   - Resource limits per agent?

### References

#### Source Documents
- `dev_workflow_meta/README.md` - Workflow overview
- `dev_workflow_meta/GUIDELINES.md` - Meta-project guidelines
- `dev_workflow_meta/Workflow/` - Role definitions and schemas
- `MultiModelCLIEmail/DESIGN.md` - Email system architecture
- `MultiModelCLIEmail/README.md` - Email system usage
- `MultiModelCLIEmail/docs/workflow_improvements.md` - agentd specification

#### Key Concepts
- **Artifact-driven workflow**: Vision → Scope → Roadmap → Specs → Implementation
- **Role-based messaging**: Messages between roles, not models
- **Maildir format**: Standard email storage (new/, cur/, tmp/)
- **Threading**: Email In-Reply-To/References create conversation DAG
- **Loop detection**: ErrorSignature + DeltaProof prevent infinite retries
- **Budget system**: Limits per error type prevent wasted work

---

## Appendix: Email Integration Implementation Notes

When ready to begin Milestone 1:
1. Create `Workflow/scripts/workflow-notify.sh`
2. Extend `Workflow/scripts/run-role.sh` with `--with-email`
3. Create first message template
4. Test spec write-review-feedback loop
5. Document learnings as we go
6. Evaluate after M1 before proceeding to M2
