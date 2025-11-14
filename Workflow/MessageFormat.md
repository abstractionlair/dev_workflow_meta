# Workflow Message Format Specification

This document defines the standard format for workflow event notifications. These messages enable asynchronous communication between workflow roles and automate handoffs.

## Overview

Workflow messages are based on email format (RFC 5322) with custom headers for workflow-specific metadata. Messages can be:
- Output to stdout for testing and debugging
- Sent via email system (when integrated)
- Logged for audit trails
- Processed by automated systems

## Message Structure

A workflow message consists of three parts:

```
[Headers]
<blank line>
[Body]
<blank line>
[Signature]
```

## Standard Headers

### Required Headers

**From**: Sender role identifier
- Format: `<role-name>@workflow.local`
- Example: `spec-writer@workflow.local`

**To**: Recipient role identifier(s)
- Format: `<role-name>@workflow.local[,<role-name>@workflow.local...]`
- Example: `spec-reviewer@workflow.local`
- Multiple recipients: `skeleton-writer@workflow.local,test-writer@workflow.local`

**Subject**: Human-readable message summary
- Format: `[<EVENT-TYPE>] <brief-description>`
- Example: `[REVIEW REQUEST] Authentication spec ready`

**Date**: Message timestamp
- Format: RFC 5322 date format
- Example: `Thu, 14 Nov 2025 10:30:00 -0800`

### Workflow-Specific Headers

**X-Event-Type**: Machine-readable event classification
- Values: `review-request`, `approval`, `rejection`, `clarification-request`, `blocker-report`, `status-update`, `question`, `answer`
- Example: `X-Event-Type: review-request`

**X-Artifacts**: Paths to relevant artifacts (supports glob patterns)
- Format: Comma-separated paths relative to project root
- Glob patterns enable state-independent references
- Example: `X-Artifacts: specs/*/user-auth.md`
- Example: `X-Artifacts: specs/proposed/api-*.md,project-meta/architecture/SYSTEM_MAP.md`

**X-Workflow-State**: Current workflow state of primary artifact
- Values: `proposed`, `todo`, `doing`, `done`, `blocked`, `deferred`
- Example: `X-Workflow-State: proposed`

**X-Session-Id**: Optional session/thread identifier for grouping related work
- Format: UUID or human-readable identifier
- Example: `X-Session-Id: user-auth-feature-2025-11-14`

### Optional Threading Headers

**In-Reply-To**: Reference to message being replied to
- Format: Message-ID from original message
- Enables conversation threading
- Example: `In-Reply-To: <20251114103000.spec-writer@workflow.local>`

**References**: Complete thread ancestry
- Format: Space-separated Message-IDs
- Example: `References: <msg1@workflow.local> <msg2@workflow.local>`

**Message-ID**: Unique identifier for this message
- Format: `<timestamp.sender@workflow.local>`
- Example: `Message-ID: <20251114103000.spec-writer@workflow.local>`

## Template Variables

Templates can use variable substitution with the syntax: `{{VARIABLE_NAME}}`

### Standard Variables

- `{{FROM_ROLE}}` - Sender role name (e.g., "spec-writer")
- `{{TO_ROLE}}` - Primary recipient role name
- `{{EVENT_TYPE}}` - Event type identifier
- `{{ARTIFACT_PATH}}` - Primary artifact path
- `{{ARTIFACT_NAME}}` - Filename without path
- `{{WORKFLOW_STATE}}` - Current workflow state
- `{{DATE}}` - Current date/time
- `{{SESSION_ID}}` - Session identifier
- `{{MESSAGE_ID}}` - Unique message identifier

### Context-Specific Variables

Different event types may provide additional variables:

**Review events:**
- `{{REVIEW_TYPE}}` - Type of review (spec, skeleton, test, implementation)
- `{{REVIEWER_COMMENTS}}` - Reviewer's feedback text
- `{{APPROVAL_STATUS}}` - approved/rejected

**Blocker events:**
- `{{BLOCKER_DESCRIPTION}}` - Description of blocking issue
- `{{ERROR_SIGNATURE}}` - Normalized error identifier
- `{{ATTEMPTS_MADE}}` - Number of resolution attempts

**Question events:**
- `{{QUESTION_TEXT}}` - The question being asked
- `{{CONTEXT}}` - Additional context for the question

## Artifact Path Patterns

To ensure messages remain valid across state transitions, use glob patterns for artifact references:

### State-Independent Patterns

**Specific file, any state:**
```
specs/*/user-auth.md
```
Matches: `specs/proposed/user-auth.md`, `specs/todo/user-auth.md`, `specs/doing/user-auth.md`, etc.

**Feature prefix, any state:**
```
specs/*/auth-*.md
```
Matches all auth-related specs regardless of state

**All specs in specific state:**
```
specs/proposed/*.md
```
Matches all proposed specs

### State-Specific Patterns

When state is critical to the message:
```
X-Artifacts: specs/proposed/user-auth.md
X-Workflow-State: proposed
```

The `X-Workflow-State` header provides context even if the artifact path later changes.

## Message Body Structure

### Standard Sections

A well-formed message body includes:

```
[Opening statement]

Artifact: [primary artifact path]
State: [workflow state]
[Additional metadata as key: value pairs]

[Main content/message]

[Action items or next steps]

---
[Signature/role identification]
```

### Example Body

```
The authentication specification is ready for review.

Artifact: specs/proposed/user-auth.md
State: proposed
Writer: spec-writer
Date: 2025-11-14

This spec covers:
- User registration and login flows
- Session management
- Password reset procedures
- OAuth integration points

Please review for:
- Completeness against requirements
- Testability of acceptance criteria
- Clarity of interface contracts

---
Sent by spec-writer role
```

## Event Type Catalog

### review-request

Sent when an artifact is ready for review.

**Headers:**
- X-Event-Type: `review-request`
- X-Workflow-State: State before review (e.g., `proposed`)

**Common senders:** spec-writer, skeleton-writer, test-writer, implementer

**Common recipients:** spec-reviewer, skeleton-reviewer, test-reviewer, implementation-reviewer

### approval

Sent when a review is approved.

**Headers:**
- X-Event-Type: `approval`
- X-Workflow-State: New state after approval (e.g., `todo`)

**Common senders:** *-reviewer roles

**Common recipients:** Original writer, next-phase roles

### rejection

Sent when a review identifies issues requiring revision.

**Headers:**
- X-Event-Type: `rejection`
- X-Workflow-State: Remains in current state

**Common senders:** *-reviewer roles

**Common recipients:** Original writer

### clarification-request

Sent when reviewer or implementer needs clarification.

**Headers:**
- X-Event-Type: `clarification-request`
- In-Reply-To: Original message if part of a thread

**Common senders:** Any reviewer, implementer

**Common recipients:** Appropriate writer or platform-lead

### blocker-report

Sent when work is blocked and cannot proceed.

**Headers:**
- X-Event-Type: `blocker-report`
- X-Workflow-State: `blocked`

**Common senders:** implementer, any active role

**Common recipients:** platform-lead, coordinator (human)

### status-update

Informational update on progress.

**Headers:**
- X-Event-Type: `status-update`

**Common senders:** Any role

**Common recipients:** coordinator, relevant stakeholders

### question

General question requiring expert input.

**Headers:**
- X-Event-Type: `question`

**Common senders:** Any role

**Common recipients:** platform-lead, relevant expert role

### answer

Response to a question.

**Headers:**
- X-Event-Type: `answer`
- In-Reply-To: Original question message

**Common senders:** platform-lead, expert roles

**Common recipients:** Original questioner

## Threading Conventions

### Starting a New Thread

When initiating a new conversation:
1. Generate a unique Message-ID
2. Do NOT include In-Reply-To or References headers
3. Use descriptive Subject

```
Message-ID: <20251114103000.spec-writer@workflow.local>
Subject: [REVIEW REQUEST] Authentication spec ready
```

### Replying in a Thread

When replying to an existing message:
1. Copy the Message-ID to In-Reply-To
2. Append to References (if present)
3. Keep original Subject (add "Re:" prefix by convention)

```
Message-ID: <20251114110000.spec-reviewer@workflow.local>
In-Reply-To: <20251114103000.spec-writer@workflow.local>
References: <20251114103000.spec-writer@workflow.local>
Subject: Re: [REVIEW REQUEST] Authentication spec ready
```

### Multi-Turn Conversations

For longer threads:
1. Each reply includes In-Reply-To pointing to immediate parent
2. References includes ALL ancestor Message-IDs
3. Subject remains consistent (with Re: prefix)

## Validation Rules

A valid workflow message MUST:
1. Include all required headers (From, To, Subject, Date)
2. Include X-Event-Type header
3. Include X-Artifacts header (unless purely conversational)
4. Have exactly one blank line between headers and body
5. Use valid role identifiers in From/To
6. Use valid event type in X-Event-Type

A valid workflow message SHOULD:
1. Include X-Workflow-State when referring to artifacts
2. Use glob patterns for artifacts that may transition
3. Include Message-ID for threading support
4. Follow body structure conventions
5. Include clear action items when appropriate

## Implementation Notes

### Timestamp Generation

Use ISO 8601 format internally, convert to RFC 5322 for message headers:

```bash
# ISO 8601 (for filenames, logging)
date -u +"%Y-%m-%dT%H:%M:%SZ"

# RFC 5322 (for message Date header)
date -R
```

### Message-ID Generation

Format: `<timestamp.sender@workflow.local>`

```bash
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
MESSAGE_ID="<${TIMESTAMP}.${FROM_ROLE}@workflow.local>"
```

### Glob Pattern Resolution

When processing messages, resolve glob patterns to actual paths:

```bash
# Find matching artifacts
ARTIFACT_PATTERN="specs/*/user-auth.md"
MATCHES=$(find . -path "./$ARTIFACT_PATTERN" 2>/dev/null)
```

## Testing Messages

### Manual Testing

Generate a message to stdout without sending:

```bash
./Workflow/scripts/workflow-notify.sh \
  review-request \
  specs/proposed/user-auth.md \
  spec-reviewer
```

### Validation Testing

Verify message format:

```bash
# Check required headers present
grep -q "^From: " message.txt
grep -q "^To: " message.txt
grep -q "^Subject: " message.txt
grep -q "^Date: " message.txt
grep -q "^X-Event-Type: " message.txt

# Check blank line separator
grep -q "^$" message.txt

# Validate event type
EVENT_TYPE=$(grep "^X-Event-Type: " message.txt | cut -d' ' -f2)
if [[ ! "$EVENT_TYPE" =~ ^(review-request|approval|rejection|clarification-request|blocker-report|status-update|question|answer)$ ]]; then
  echo "Invalid event type: $EVENT_TYPE"
fi
```

## Future Extensions

Planned additions for later milestones:

- **X-Loop** header for loop detection (Milestone 4)
- **X-Seq** header for sequence tracking (Milestone 4)
- **X-Thread** header for DAG threading (Milestone 4)
- **Auto-Submitted** header for automation detection (Milestone 4)
- **X-Budget-Remaining** for retry budget tracking (Milestone 4)
- **X-Delta-Proof** for change verification (Milestone 4)

## References

- [RFC 5322](https://tools.ietf.org/html/rfc5322) - Internet Message Format
- [Maildir specification](https://cr.yp.to/proto/maildir.html) - For email system integration
- [docs/PLAN.md](../docs/PLAN.md) - Email communication integration plan
- [Workflow/state-transitions.md](state-transitions.md) - Workflow state model

---

**Version**: 1.0
**Status**: Draft
**Last Updated**: 2025-11-14
