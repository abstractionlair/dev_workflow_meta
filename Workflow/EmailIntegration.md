# Email Communication Integration

## Overview

Email integration enables asynchronous, bidirectional communication between workflow roles while preserving the structured artifact-driven approach. This document describes how roles use email to coordinate handoffs, request reviews, provide feedback, and ask questions.

**Status**: Phase 1 - Event-driven email notifications (Phase 3 design in progress)
**Last Updated**: 2025-11-20

## Architecture

### Core Principles

1. **Artifacts remain the source of truth** - Email coordinates work but doesn't replace artifacts
2. **Event-driven notifications** - Email triggered at key workflow events (review requests, approvals, etc.)
3. **Asynchronous communication** - Roles check email at strategic points, not continuously
4. **Threaded conversations** - Message threading preserves context and conversation history
5. **State coordination** - Email headers track artifact state and workflow transitions

### Email Communication Model

Email serves different purposes at different workflow stages:

**Strategic/Planning Phases** (Vision, Scope, Roadmap, Spec)
- **Collaborative email encouraged** - Rich multi-turn discussions explore ideas
- **Message types:** question, answer, clarification-request
- **Purpose:** Surface tradeoffs, challenge assumptions, explore alternatives
- **Pattern:** "What about X?" → "That gains Y but loses Z" → "How about W instead?"
- **Outcome:** Discussions must result in artifact updates (email coordinates, artifacts capture decisions)

**Implementation Phases** (Skeleton, Test, Implementation)
- **Transactional email preferred** - Coordinate handoffs and state transitions
- **Message types:** review-request, approval, rejection, status-update
- **Purpose:** "I'm done, your turn" handoffs between roles
- **Pattern:** Straightforward workflow progression
- **Outcome:** Artifact moves through states (proposed → todo → doing → done)

**Exception Handling** (Blockers, spec doesn't work as planned)
- **Collaborative email for problem-solving** - Figure out how to proceed
- **Message types:** blocker-report, question, answer
- **Purpose:** Resolve unexpected issues, adapt plans
- **Pattern:** "Hit blocker X" → discussion → "Try approach Y" → resolution
- **Outcome:** Updated spec or new implementation strategy

**Key principle:** Artifacts remain the source of truth. Email discussions that reach conclusions must update the relevant artifact. Email is for coordination and exploration, not archival decisions.

### Panel-Based vs. Solo Roles

The workflow supports both individual roles and multi-model panels:

**Review Panels (Tier 1 - Highest Value)**

Review panels provide the greatest value by catching "didn't think of that" failures. All significant artifacts should be reviewed by panels:

```
vision-reviewer-panel: [claude, gpt-5, gemini]
scope-reviewer-panel: [claude, gpt-5, gemini]
roadmap-reviewer-panel: [claude, gpt-5, gemini]
spec-reviewer-panel: [claude, gpt-5, gemini]
skeleton-reviewer-panel: [claude, gpt-5, gemini]
test-reviewer-panel: [claude, gpt-5, gemini]
implementation-reviewer-panel: [claude, gpt-5, gemini]
```

**Panel review process:**
1. Each panel member reviews independently (fresh context, reviewer prompt)
2. Each writes individual review assessment
3. Panel discusses reviews via internal email
4. Panel reaches consensus: approve, reject, or request revisions
5. Panel sends unified decision via cross-panel email

**Writing Panels (Tier 2 - Strategic Value)**

Writing panels provide collaborative exploration for strategic/planning work:

```
vision-writer-panel: [claude (primary), gpt-5, gemini]
scope-writer-panel: [claude (primary), gpt-5, gemini]
roadmap-writer-panel: [claude (primary), gpt-5, gemini]
spec-writer-panel: [claude (primary), gpt-5, gemini]
```

**Panel writing process (Primary + Helpers pattern):**
1. Primary announces section: "Starting Section A: Problem Statement"
2. All panel members contribute ideas equally (collaborative exploration)
3. Panel discusses tradeoffs, challenges assumptions
4. Primary makes decision: "Section A decided: [summary]. Moving to Section B..."
5. Primary integrates discussion into artifact
6. Process repeats for each section
7. Primary sends completed artifact for review

**Solo Roles (Tier 3 - Sufficient for Implementation)**

Solo roles are sufficient for mechanical/implementation work:

```
skeleton-writer: single model
test-writer: single model
implementer: single model
```

**Rationale:** Implementation issues ("can't figure out how to write the code") are less common than planning issues ("forgot about that requirement"). Review panels catch implementation problems.

### Independence Principle

**Definition of Independence:**

Reviewers must be independent from writers, even when using the same models. Independence has three components:

1. **Fresh context** - Reviewers have no memory of participating in writing
2. **Different system prompt** - Reviewers use reviewer role definition, not writer role
3. **Email isolation** - Reviewers cannot see writer panel internal emails

**Example with same model on both panels:**

```
Writing phase:
  Model: Claude
  Role: vision-writer (primary)
  Context: [30 emails of collaborative discussion]
  Produces: VISION.md

Review phase:
  Model: Claude
  Role: vision-reviewer
  Context: [Fresh - no memory of writing phase]
  Input: VISION.md only (cannot see writing emails)
  Produces: Independent review
```

**Rationale for fresh context independence:**

- With single writer + single reviewer: Use different models (e.g., GPT-5 writes, Claude reviews)
- With panels: Fresh context + different prompt provides independence even with same models
- Vertical diversity (multiple models in panel) + horizontal diversity (fresh context) catches more issues than single model diversity alone

### Email Visibility Boundaries

Panels create distinct email spaces to preserve independence:

**1. Writer Panel Internal**
- Address: `{artifact}-writer-panel-internal@workflow.local`
- Visible to: Writer panel members only
- Purpose: Collaborative drafting discussions
- Example: "Should we prioritize X or Y in the roadmap?"

**2. Reviewer Panel Internal**
- Address: `{artifact}-reviewer-panel-internal@workflow.local`
- Visible to: Reviewer panel members only
- Purpose: Review coordination and consensus building
- Example: "Claude found issue X, I found issue Y. Should we reject or request clarification?"

**3. Cross-Panel Communication**
- Address: `{artifact}-discussion@workflow.local`
- Visible to: Both writer and reviewer panels
- Purpose: Clarification requests, questions about artifact
- Example: "In Section 3, you mention 'scalability' - do you mean horizontal or vertical?"

**Threading rules:**
- Panel-internal threads: Never reference or reply to other panel's internal emails
- Cross-panel threads: New threads only (don't reference internal discussions)
- This preserves independence while allowing necessary communication

**Prevents:**
- Reviewers seeing "we chose X because..." rationale from writers (reduces bias)
- Writers seeing "I'm worried about Y" reviewer concerns before official review
- Loss of independent perspective

### Synchronous vs. Asynchronous Roles

The workflow distinguishes between two types of roles with different communication models:

**1. Synchronous Helper Roles** (`*-writing-helper`)
- **Interaction:** Interactive CLI session (Socratic dialogue with user)
- **Communication:** Direct user input/output only
- **Email:** Does **NOT** check or send email
- **Daemon:** Never runs in background/daemon mode
- **Purpose:** guiding the user to create the *initial* artifact (VISION.md, etc.)
- **Handoff:** Creates the file, which then allows the Asynchronous Workflow to begin (by sending a review request)

**2. Asynchronous Workflow Roles** (`*-writer`, `*-reviewer`, `implementer`)
- **Interaction:** Often autonomous or task-based
- **Communication:** Via artifacts and Email notifications
- **Email:** Fully integrated (checks for requests, sends status/approvals)
- **Daemon:** Can run in background (agentd) to process queues
- **Purpose:** Reviewing, refining, testing, and implementing defined artifacts

**The Handoff Pattern:**
```
[User] <-> [Helper] (Sync Chat)
       |
       v
[Creates Artifact]
       |
       v
[Writer/User] -> (Sends 'review-request' Email) -> [Reviewer] (Async)
```

### Components

**workflow-notify.sh** - Generates structured workflow messages
**run-role.sh --with-email** - Launches roles with email checking enabled
**email-templates/** - Message templates for different event types
**MessageFormat.md** - Specification for message structure and headers

## Message Flow Patterns

### Pattern 1: Review Request → Approval/Rejection

The most common workflow pattern.

```
┌─────────────┐                    ┌──────────────┐
│ Spec Writer │                    │ Spec Reviewer│
└──────┬──────┘                    └──────┬───────┘
       │                                  │
       │ 1. Create spec                   │
       │    specs/proposed/auth.md        │
       │                                  │
       │ 2. Send review-request ─────────>│
       │    X-Event-Type: review-request  │
       │    X-Workflow-State: proposed    │
       │                                  │
       │                                  │ 3. Check email
       │                                  │    (before starting work)
       │                                  │
       │                                  │ 4. Review artifact
       │                                  │
       │ 5. Receive approval <────────────│
       │    X-Event-Type: approval        │
       │    X-Workflow-State: todo        │
       │                                  │
       │                                  │ 6. Move artifact
       │                                  │    proposed/ → todo/
       │                                  │
       │ 7. Check email                   │
       │    (artifact now in todo/)       │
```

**Key points:**
- Reviewer checks email before starting work session
- Approval message indicates state transition
- Spec Writer learns artifact is approved by checking email
- Artifact file location changes to reflect new state

### Pattern 2: Review Request → Clarification → Revised Spec

When reviewer needs clarification.

```
┌─────────────┐                    ┌──────────────┐
│ Spec Writer │                    │ Spec Reviewer│
└──────┬──────┘                    └──────┬───────┘
       │                                  │
       │ 1. Send review-request ─────────>│
       │                                  │
       │                                  │ 2. Review, find issue
       │                                  │
       │ 3. Receive clarification-req <───│
       │    In-Reply-To: <original-msg>   │
       │    Question: "How to handle X?"  │
       │                                  │
       │ 4. Reply with answer ───────────>│
       │    In-Reply-To: <clarif-msg>     │
       │    X-Event-Type: answer          │
       │                                  │
       │                                  │ 5. Continue review
       │                                  │
       │ 6. Receive approval <────────────│
       │    Or: receive rejection         │
```

**Key points:**
- Threading preserves conversation context
- Clarifications can happen mid-review
- Writer may need to revise and resubmit if rejected
- Questions reference specific artifacts via X-Artifacts header

### Pattern 3: Implementation → Blocker → Resolution

When implementer encounters a blocker.

```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│ Implementer │     │Platform Lead │     │ Coordinator  │
└──────┬──────┘     └──────┬───────┘     └──────┬───────┘
       │                   │                     │
       │ 1. Attempt impl   │                     │
       │    (hits blocker) │                     │
       │                   │                     │
       │ 2. Send blocker-report ────────────────>│
       │    X-Event-Type: blocker-report         │
       │    X-Workflow-State: blocked            │
       │                   │                     │
       │                   │                     │ 3. Assess blocker
       │                   │                     │
       │                   │                     │ 4. Escalate to
       │                   │<────────────────────│    platform lead
       │                   │                     │
       │                   │ 5. Investigate      │
       │                   │                     │
       │ 6. Receive answer │                     │
       │ <─────────────────│                     │
       │    X-Event-Type: answer                 │
       │    "Try approach Y"                     │
       │                   │                     │
       │ 7. Retry with new │                     │
       │    approach       │                     │
```

**Key points:**
- Blockers escalate to appropriate expertise level
- Multiple experts can collaborate on resolution
- Answer provides actionable guidance
- Work resumes when blocker is resolved

### Pattern 4: Multi-Role Coordination

Complex features requiring coordination between multiple roles.

```
┌──────────┐  ┌──────────────┐  ┌────────────┐
│ Skeleton │  │ Test Writer  │  │ Implementer│
│ Writer   │  │              │  │            │
└────┬─────┘  └──────┬───────┘  └─────┬──────┘
     │               │                 │
     │ 1. Complete   │                 │
     │    skeleton   │                 │
     │               │                 │
     │ 2. Send review-request ─> Reviewer
     │               │                 │
     │ 3. Approved   │                 │
     │               │                 │
     │ 4. Send notification ───────────>│ (test-writer,
     │    To: test-writer,implementer  │  implementer)
     │    X-Event-Type: approval        │
     │    NEXT_ROLES=test-writer,...    │
     │               │                 │
     │               │ 5. Check email  │ 6. Check email
     │               │    Start tests  │    Wait for tests
     │               │                 │
     │               │ 7. Send status-update ────────> │
     │               │                 │
     │               │                 │ 8. Receive status
     │               │                 │    Tests ready soon
```

**Key points:**
- Approval messages can notify multiple next-phase roles
- Status updates keep dependent roles informed
- Roles coordinate timing without blocking
- Each role works independently, synchronized via email

## Email Checking Protocol

### When to Check Email

Roles check email at three key points:

**1. Before starting work session**
```bash
./Workflow/scripts/run-role.sh --with-email spec-reviewer
```
- Discovers pending review requests
- Learns about state changes to artifacts
- Receives answers to questions asked previously

**2. After completing work**
- Sends notifications about completed work
- Checks for any urgent messages
- Coordinates handoff to next role

**3. During long work sessions (optional)**
- Periodic checking with `--email-poll-interval`
- Useful for multi-hour implementation sessions
- Allows mid-session coordination

### Email Checking Sequence

When `run-role.sh --with-email` executes:

1. **Check mailbox** for new messages
2. **Display new messages** relevant to current role
3. **Process messages** (filter, thread, prioritize)
4. **Present to role** in context of current work
5. **Launch role** with awareness of email state
6. **After role completes**:
   - Check mailbox again
   - Send any outgoing notifications
   - Display any new replies received

### Message Filtering

Roles filter incoming messages by:
- **To:** header - direct messages to this role
- **X-Event-Type** - message category
- **X-Artifacts** - artifact patterns relevant to current work
- **X-Workflow-State** - state transitions affecting this role

## Threading and Conversation Management

### Thread Hierarchy

Messages form conversation threads via RFC 5322 threading headers:

```
Message-ID: <20251114103000.spec-writer@workflow.local>
In-Reply-To: <20251114100000.spec-reviewer@workflow.local>
References: <20251114095000.spec-writer@workflow.local> <20251114100000.spec-reviewer@workflow.local>
```

**Thread root:** Initial review-request or question
**Thread replies:** Clarifications, answers, status updates
**Thread resolution:** Final approval, rejection, or blocker resolution

### Threading Best Practices

1. **One thread per artifact per review cycle**
   - New cycle = new thread
   - Keeps conversations focused

2. **Preserve References header**
   - Complete ancestry enables thread reconstruction
   - Helps identify related conversations

3. **Consistent Subject lines**
   - Add "Re:" prefix for replies
   - Keep artifact name in subject

4. **Use In-Reply-To for direct responses**
   - Points to immediate parent message
   - Enables linear conversation view

## State Transition Coordination

### Email + File System = Complete Picture

State tracked in two complementary ways:

**File system location:**
```
specs/proposed/auth.md  →  specs/todo/auth.md  →  specs/doing/auth.md
```

**Email X-Workflow-State header:**
```
X-Workflow-State: proposed  →  X-Workflow-State: todo  →  X-Workflow-State: doing
```

### State Transition Messages

When artifact moves between states:

**Reviewer approves spec:**
1. Move file: `specs/proposed/auth.md` → `specs/todo/auth.md`
2. Send email with `X-Workflow-State: todo`
3. Include `NEXT_ROLES: skeleton-writer,test-writer`

**Skeleton writer starts work:**
1. Check email, see spec approved
2. Move spec: `specs/todo/auth.md` → `specs/doing/auth.md`
3. Optional: Send status-update to coordinator

### Glob Patterns for State Independence

Use glob patterns in X-Artifacts header to handle state transitions:

```
X-Artifacts: specs/*/auth.md
```

This pattern matches the artifact regardless of current state, preventing broken references when files move.

## Common Workflow Examples

### Example 1: Spec Write → Review → Approve

**Spec Writer session:**
```bash
# Start work
./Workflow/scripts/run-role.sh -i spec-writer

# ... writes specs/proposed/user-auth.md ...

# Send for review
./Workflow/scripts/workflow-notify.sh \
  review-request \
  specs/proposed/user-auth.md \
  spec-reviewer \
  CONTEXT="Focus on error handling patterns"
```

**Spec Reviewer session (later):**
```bash
# Check email and start review
./Workflow/scripts/run-role.sh --with-email spec-reviewer

# Sees: "[REVIEW REQUEST] user-auth ready for review"
# Reviews specs/proposed/user-auth.md

# If approved:
git mv specs/proposed/user-auth.md specs/todo/user-auth.md
git commit -m "spec-reviewer: Approve user-auth spec"

./Workflow/scripts/workflow-notify.sh \
  approval \
  specs/todo/user-auth.md \
  spec-writer \
  NEXT_STATE="todo" \
  NEXT_ROLES="skeleton-writer,test-writer"
```

**Spec Writer (later):**
```bash
# Check email
./Workflow/scripts/run-role.sh --with-email spec-writer

# Sees: "[APPROVAL] user-auth approved"
# Notes artifact now in specs/todo/
```

### Example 2: Clarification Mid-Review

**Reviewer encounters ambiguity:**
```bash
./Workflow/scripts/workflow-notify.sh \
  --in-reply-to "<20251114103000.spec-writer@workflow.local>" \
  clarification-request \
  specs/proposed/user-auth.md \
  spec-writer \
  QUESTION="Should OAuth tokens expire or use refresh pattern?" \
  BLOCKING="no"
```

**Writer responds:**
```bash
./Workflow/scripts/workflow-notify.sh \
  --in-reply-to "<20251114110000.spec-reviewer@workflow.local>" \
  answer \
  specs/proposed/user-auth.md \
  spec-reviewer \
  CONTEXT="Use refresh token pattern per OAuth 2.0 spec. Will update spec to clarify."

# Updates spec with clarification
# Sends notification that spec is updated
```

### Example 3: Implementation Blocker

**Implementer hits blocker:**
```bash
# Move artifact to blocked state
git mv specs/doing/user-auth.md specs/blocked/user-auth.md

./Workflow/scripts/workflow-notify.sh \
  blocker-report \
  specs/blocked/user-auth.md \
  coordinator \
  BLOCKING_DETAILS="External API library incompatible with specified interface" \
  CONTEXT="Tried adapters, but async/sync mismatch prevents clean integration"
```

**Platform Lead provides solution:**
```bash
./Workflow/scripts/workflow-notify.sh \
  --in-reply-to "<blocker-msg-id>" \
  answer \
  specs/blocked/user-auth.md \
  implementer \
  CONTEXT="Spec needs revision. Use async interfaces throughout. Will update spec." \
  NEXT_ACTIONS="Wait for spec revision, then retry implementation"
```

## Message Templates Reference

### Available Templates

All templates in `Workflow/email-templates/`:

- **review-request.txt** - Artifact ready for review
- **approval.txt** - Review approved, artifact advancing
- **rejection.txt** - Review rejected, revision needed
- **clarification-request.txt** - Need clarification to proceed
- **blocker-report.txt** - Work blocked, cannot proceed
- **status-update.txt** - Progress update (informational)
- **question.txt** - General question for expert
- **answer.txt** - Response to question

See [email-templates/README.md](email-templates/README.md) for template documentation.

### Template Variables

Common variables available in all templates:

- `{{FROM_ROLE}}` - Sender role
- `{{TO_ROLE}}` - Recipient role
- `{{ARTIFACT_PATH}}` - Primary artifact path
- `{{ARTIFACT_NAME}}` - Artifact filename
- `{{WORKFLOW_STATE}}` - Current state
- `{{DATE}}` - Timestamp
- `{{MESSAGE_ID}}` - Unique message ID

See [MessageFormat.md](MessageFormat.md) for complete variable list.

## Integration with run-role.sh

### Basic Email-Aware Execution

```bash
# Check email before and after work
./Workflow/scripts/run-role.sh --with-email spec-reviewer
```

### Email Polling During Work

```bash
# Check every 5 minutes during long session
./Workflow/scripts/run-role.sh --with-email --email-poll-interval 300 implementer
```

### One-Shot With Email Check

```bash
# Non-interactive: check email, process, send results
./Workflow/scripts/run-role.sh --with-email spec-reviewer specs/proposed/auth.md
```

## Future Evolution

### Phase 2: Lightweight Supervision (Planned)

- Daemon processes for continuous monitoring
- Auto-trigger reviews when requests arrive
- Simple timeout protection
- Basic logging and status tracking

### Phase 3: Full agentd Supervision (Planned)

- Loop detection and error budgets
- Persistent state across invocations
- Advanced threading (DAG, multi-parent)
- Budget tracking and escalation

See [docs/PLAN.md](../docs/PLAN.md) for detailed evolution roadmap.

## Troubleshooting

### Messages Not Appearing

**Check mailbox location:**
```bash
# Default: ~/.maildir/workflow/<role-name>/
ls -la ~/.maildir/workflow/spec-reviewer/new/
```

**Verify template generation:**
```bash
# Generate message to stdout
./Workflow/scripts/workflow-notify.sh \
  review-request \
  specs/proposed/test.md \
  spec-reviewer
```

### Threading Issues

**Verify Message-ID format:**
```bash
# Should be: <timestamp.role@workflow.local>
grep "^Message-ID:" message.txt
```

**Check In-Reply-To matching:**
```bash
# In-Reply-To should match parent's Message-ID exactly
grep "^In-Reply-To:" message.txt
```

### State Synchronization Issues

**Check file location vs X-Workflow-State:**
```bash
# File location
ls specs/*/auth.md

# Email header
grep "^X-Workflow-State:" message.txt

# Should match!
```

## Best Practices

### For Message Senders

1. **Include artifact context** - Always specify X-Artifacts
2. **Use glob patterns** - Artifacts may move between states
3. **Provide clear next steps** - Tell recipient what to do
4. **Thread properly** - Use In-Reply-To for conversations
5. **Keep concise** - AI agents prefer structured information

### For Message Recipients

1. **Check email regularly** - Before/after work sessions
2. **Process by priority** - Blockers first, then reviews, then status
3. **Respond promptly** - Don't leave questions unanswered
4. **Update state** - Move artifacts when appropriate
5. **Close loops** - Send final approval/rejection

### For Coordinators

1. **Monitor blocker reports** - Unblock agents quickly
2. **Track conversation threads** - Ensure questions get answered
3. **Watch for loops** - Same question multiple times = process problem
4. **Escalate appropriately** - Route to right expert
5. **Document patterns** - Repeated issues → update workflow

## References

- [MessageFormat.md](MessageFormat.md) - Complete message specification
- [email-templates/README.md](email-templates/README.md) - Template documentation
- [Workflow.md](Workflow.md) - Overall workflow process
- [state-transitions.md](state-transitions.md) - State transition rules
- [docs/PLAN.md](../docs/PLAN.md) - Email integration roadmap

---

**Version**: 1.0 (Phase 1)
**Status**: Active - Event-driven email
**Last Updated**: 2025-11-14
