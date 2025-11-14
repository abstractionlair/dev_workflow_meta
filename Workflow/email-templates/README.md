# Email Templates

This directory contains message templates for workflow event notifications.

## Overview

Templates define the structure and content for different types of workflow messages. The `workflow-notify.sh` script uses these templates to generate properly formatted messages.

## Template Syntax

Templates use variable substitution with the syntax: `{{VARIABLE_NAME}}`

### Standard Variables

Available in all templates:
- `{{FROM_ROLE}}` - Sender role name (e.g., "spec-writer")
- `{{TO_ROLE}}` - Primary recipient role name
- `{{EVENT_TYPE}}` - Event type identifier
- `{{ARTIFACT_PATH}}` - Primary artifact path
- `{{ARTIFACT_NAME}}` - Filename without path or extension
- `{{WORKFLOW_STATE}}` - Current workflow state
- `{{DATE}}` - Current date/time (RFC 5322 format)
- `{{SESSION_ID}}` - Session identifier (if provided)
- `{{MESSAGE_ID}}` - Unique message identifier

### Template-Specific Variables

Some templates accept additional variables:

**review-request.txt:**
- `{{REVIEW_TYPE}}` - Type of review (spec, skeleton, test, implementation)
- `{{CONTEXT}}` - Optional additional context

**approval.txt:**
- `{{REVIEW_TYPE}}` - Type of review completed
- `{{NEXT_STATE}}` - New workflow state after approval
- `{{NEXT_ROLES}}` - Comma-separated list of roles that can work on this next
- `{{REVIEWER_COMMENTS}}` - Optional approval comments

**rejection.txt:**
- `{{REVIEW_TYPE}}` - Type of review completed
- `{{REVIEWER_COMMENTS}}` - Required feedback on what needs to change
- `{{ISSUES_FOUND}}` - Optional structured list of issues

**clarification-request.txt:**
- `{{QUESTION}}` - The question being asked
- `{{CONTEXT}}` - Context for the question
- `{{BLOCKING}}` - Whether this blocks progress (yes/no)
- `{{BLOCKING_DETAILS}}` - Additional details about blocking issue

**blocker-report.txt:**
- `{{BLOCKING_DETAILS}}` - Description of blocking issue
- `{{CONTEXT}}` - What was attempted
- `{{ISSUES_FOUND}}` - Optional structured list of issues

**status-update.txt:**
- `{{CONTEXT}}` - Progress summary
- `{{NEXT_ACTIONS}}` - Expected next steps
- `{{NEXT_ROLES}}` - Comma-separated list of next roles

**question.txt:**
- `{{QUESTION}}` - The question being asked
- `{{CONTEXT}}` - Context for the question
- `{{BLOCKING}}` - Whether this blocks progress (yes/no)
- `{{BLOCKING_DETAILS}}` - Additional details if blocking

**answer.txt:**
- `{{QUESTION}}` - The original question being answered
- `{{CONTEXT}}` - The answer/guidance provided
- `{{NEXT_ACTIONS}}` - Recommended next steps

## Available Templates

### review-request.txt

Sent when an artifact is ready for review.

**Usage:**
```bash
./workflow-notify.sh review-request specs/proposed/user-auth.md spec-reviewer
```

**When to use:**
- Spec writer completes a specification
- Skeleton writer completes interface skeletons
- Test writer completes tests
- Implementer completes implementation

### approval.txt

Sent when a review approves an artifact and transitions it to the next state.

**Usage:**
```bash
./workflow-notify.sh approval specs/todo/user-auth.md spec-writer
```

**When to use:**
- Reviewer approves a spec (proposed → todo)
- Reviewer approves skeleton (skeleton-proposed → skeleton-todo)
- Reviewer approves tests (test-proposed → test-todo)
- Reviewer approves implementation (doing → done)

### rejection.txt

Sent when a review identifies issues requiring revision.

**Usage:**
```bash
./workflow-notify.sh rejection specs/proposed/user-auth.md spec-writer
```

**When to use:**
- Reviewer finds issues in a spec
- Reviewer finds issues in skeleton code
- Reviewer finds issues in tests
- Reviewer finds issues in implementation

### clarification-request.txt

Sent when reviewer or implementer needs clarification.

**Usage:**
```bash
./workflow-notify.sh clarification-request specs/proposed/user-auth.md spec-writer \
  QUESTION="Should OAuth tokens expire or use refresh pattern?" \
  BLOCKING="no"
```

**When to use:**
- Reviewer doesn't understand part of an artifact
- Implementer needs clarification on spec requirements
- Any role has questions about artifact intent

### blocker-report.txt

Sent when work is blocked and cannot proceed without intervention.

**Usage:**
```bash
./workflow-notify.sh blocker-report specs/blocked/user-auth.md coordinator \
  BLOCKING_DETAILS="External API library incompatible with specified interface" \
  CONTEXT="Tried adapters, but async/sync mismatch prevents clean integration"
```

**When to use:**
- Implementer encounters technical blocker
- Dependencies cannot be resolved
- External systems unavailable
- Requires human intervention or platform-lead decision

### status-update.txt

Sent for informational progress updates.

**Usage:**
```bash
./workflow-notify.sh status-update specs/doing/user-auth.md coordinator \
  CONTEXT="Implementation 60% complete, tests passing" \
  NEXT_ACTIONS="Will complete remaining endpoints by EOD"
```

**When to use:**
- Long-running implementation progress updates
- Coordination between parallel workstreams
- Informing stakeholders of milestone completion
- No action required, purely informational

### question.txt

Sent when expert input or guidance is needed.

**Usage:**
```bash
./workflow-notify.sh question specs/doing/user-auth.md platform-lead \
  QUESTION="Should we use JWT or session cookies for authentication?" \
  CONTEXT="Spec doesn't specify; both approaches viable" \
  BLOCKING="yes"
```

**When to use:**
- Need expert decision on technical approach
- Ambiguity in spec requires clarification
- Architecture decision needed
- Can be blocking or non-blocking

### answer.txt

Sent in response to a question.

**Usage:**
```bash
./workflow-notify.sh --in-reply-to "<question-msg-id>" \
  answer specs/doing/user-auth.md implementer \
  QUESTION="Should we use JWT or session cookies?" \
  CONTEXT="Use JWT for stateless API. Spec will be updated to clarify." \
  NEXT_ACTIONS="Proceed with JWT implementation per OAuth 2.0 best practices"
```

**When to use:**
- Responding to question.txt messages
- Providing expert guidance
- Resolving ambiguities
- Unblocking work

## Template Structure

Each template file contains:

1. **Header section** - Email headers using template variables
2. **Blank line** - Required separator
3. **Body section** - Message content
4. **Signature** - Standard footer

### Example Template Structure

```
From: {{FROM_ROLE}}@workflow.local
To: {{TO_ROLE}}@workflow.local
Subject: [{{EVENT_TYPE}}] {{ARTIFACT_NAME}}
Date: {{DATE}}
Message-ID: {{MESSAGE_ID}}
X-Event-Type: {{EVENT_TYPE}}
X-Artifacts: {{ARTIFACT_PATH}}
X-Workflow-State: {{WORKFLOW_STATE}}

[Body content with template variables]

---
Sent by {{FROM_ROLE}} role
Generated: {{DATE}}
```

## Creating New Templates

To add a new template:

1. **Create the template file** - Use `.txt` extension
2. **Define headers** - Include all required headers (From, To, Subject, Date, X-Event-Type)
3. **Add workflow headers** - X-Artifacts, X-Workflow-State as appropriate
4. **Write body content** - Use clear language and template variables
5. **Add signature** - Standard footer section
6. **Document variables** - Update this README with any new variables
7. **Update workflow-notify.sh** - Add event type to supported list

## Testing Templates

### View Generated Message

```bash
# Generate message to stdout
./workflow-notify.sh review-request specs/proposed/test.md spec-reviewer
```

### Validate Format

```bash
# Save to file and check
./workflow-notify.sh review-request specs/proposed/test.md spec-reviewer > /tmp/msg.txt

# Verify headers
grep "^From: " /tmp/msg.txt
grep "^X-Event-Type: " /tmp/msg.txt

# Verify blank line separator
grep -q "^$" /tmp/msg.txt && echo "Format OK" || echo "Missing blank line"
```

## Style Guidelines

When editing templates:

1. **Be concise** - Recipients are AI agents who prefer clear, structured information
2. **Be specific** - Include artifact paths, states, and actionable information
3. **Use consistent structure** - Follow the standard body format
4. **Include metadata** - Artifact path, state, and other key-value pairs
5. **Suggest actions** - Tell recipient what to do next
6. **Maintain threading** - For replies, preserve conversation context

## Integration with Email System

Currently, templates output to stdout for testing. When the email system is integrated (Milestone 1, part 2):

1. `workflow-notify.sh --send` will send via email
2. Messages will be delivered to Maildir mailboxes
3. Roles will poll mailboxes and process messages
4. Threading headers will enable conversation tracking

See [../MessageFormat.md](../MessageFormat.md) for complete message format specification.

---

**Last Updated**: 2025-11-14
**Related**: MessageFormat.md, ../scripts/workflow-notify.sh
