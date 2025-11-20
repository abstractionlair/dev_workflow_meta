# Email Tools for AI Models

This guide explains how AI models working in workflow roles can efficiently use email for asynchronous communication.

## Overview

The workflow provides two main email tools optimized for AI model usage:

1. **email-helper.sh** - High-level commands for common email operations
2. **email_tools.py** - Low-level Python API for advanced operations

**Key Benefits:**
- **No escape sequence issues** - Messages written to temp files, not piped
- **Efficient search** - Find specific emails without reading entire maildir
- **Token-efficient** - Search metadata first, read full content only when needed
- **Thread-aware** - Follow conversation threads easily

## Quick Start: Common Tasks

### Check for New Work

```bash
# Check recent messages (last 24 hours)
./Workflow/scripts/email-helper.sh check-new

# Check messages from last 7 days
./Workflow/scripts/email-helper.sh recent 7
```

### Find Relevant Messages

```bash
# Find review requests for a specific artifact
./Workflow/scripts/email-helper.sh find-reviews auth.md

# Find all review requests
./Workflow/scripts/email-helper.sh find-reviews

# Find approvals for your work
./Workflow/scripts/email-helper.sh find-approvals user-auth.md

# Find clarification requests
./Workflow/scripts/email-helper.sh find-clarifications

# Find blocker reports
./Workflow/scripts/email-helper.sh find-blockers
```

### Read Full Message

```bash
# After finding a message, read it by key
./Workflow/scripts/email-helper.sh read 1763670407.M227636P4313Q1.runsc
```

### Follow Thread

```bash
# Get entire conversation thread
./Workflow/scripts/email-helper.sh thread "<20251120120000.spec-writer@workflow.local>"
```

## Efficient Email Workflows for Models

### Pattern 1: Process Review Requests

When starting work as a reviewer:

```bash
# 1. Find review requests for artifacts you review
./Workflow/scripts/email-helper.sh find-reviews

# 2. Read the most recent one (use key from search results)
./Workflow/scripts/email-helper.sh read <message-key>

# 3. Get the artifact path from X-Artifacts header
# 4. Read the artifact and perform review
# 5. Send response using workflow-notify.sh
```

### Pattern 2: Check for Clarifications

When you've sent work for review and want to check for feedback:

```bash
# Find clarification requests about your artifact
./Workflow/scripts/email-helper.sh find-clarifications my-spec.md

# Read any clarification requests
./Workflow/scripts/email-helper.sh read <message-key>

# Get the thread to understand full context
./Workflow/scripts/email-helper.sh thread <message-id-from-header>
```

### Pattern 3: Catch Up After Being Away

When spawned with fresh context (no memory of previous work):

```bash
# 1. Check what happened in last 7 days
./Workflow/scripts/email-helper.sh recent 7

# 2. Find messages relevant to your role
./Workflow/scripts/email-helper.sh find-reviews  # if you're a reviewer

# 3. Read relevant artifacts (from X-Artifacts headers)
# 4. Read recent threads to understand discussions
```

## Advanced: Using email_tools.py Directly

For more control, use the Python tool directly:

### Search with Multiple Criteria

```bash
# Find review requests from last 3 days about specs in "doing" state
./Workflow/scripts/email_tools.py search ~/Maildir/workflow \
  --event-type review-request \
  --since 3d \
  --state doing \
  --limit 10

# Search with specific sender
./Workflow/scripts/email_tools.py search ~/Maildir/workflow \
  --from spec-writer \
  --event-type approval

# Get JSON output for programmatic processing
./Workflow/scripts/email_tools.py search ~/Maildir/workflow \
  --event-type review-request \
  --artifact auth.md \
  --format json
```

### List Messages Efficiently

```bash
# List metadata only (fast, doesn't read message bodies)
./Workflow/scripts/email_tools.py list ~/Maildir/workflow \
  --event-type review-request \
  --limit 20

# JSON output for parsing
./Workflow/scripts/email_tools.py list ~/Maildir/workflow \
  --event-type approval \
  --format json
```

### Read and Parse Messages

```bash
# Read full message with headers and body
./Workflow/scripts/email_tools.py read ~/Maildir/workflow/cur/<message-key>

# Get JSON for programmatic parsing
./Workflow/scripts/email_tools.py read ~/Maildir/workflow/cur/<message-key> --format json
```

### Work with Threads

```bash
# Get all messages in thread
./Workflow/scripts/email_tools.py thread ~/Maildir/workflow \
  "<20251120120000.spec-writer@workflow.local>"

# JSON output
./Workflow/scripts/email_tools.py thread ~/Maildir/workflow \
  "<message-id>" \
  --format json
```

## Sending Email

### Simple Notification

```bash
# Generate and send review request
./Workflow/scripts/workflow-notify.sh --send \
  review-request \
  project-meta/specs/proposed/auth.md \
  spec-reviewer
```

### Reply to Thread

```bash
# Send approval in reply to review request
./Workflow/scripts/workflow-notify.sh --send \
  --in-reply-to "<20251120120000.spec-reviewer@workflow.local>" \
  approval \
  project-meta/specs/todo/auth.md \
  spec-writer \
  NEXT_STATE="todo" \
  NEXT_ROLES="skeleton-writer"
```

## Token-Efficient Email Usage

### Don't Do This (Wasteful)

```bash
# ❌ Reading entire maildir to find one message
for file in ~/Maildir/workflow/cur/*; do
  cat "$file" | grep "auth.md"
done
```

### Do This Instead (Efficient)

```bash
# ✅ Search by metadata first, read only what you need
./Workflow/scripts/email-helper.sh find-reviews auth.md

# Then read specific message by key
./Workflow/scripts/email-helper.sh read <key-from-search>
```

### Strategy for Models

1. **Search metadata first** - Use `email-helper.sh` or `email_tools.py search/list` to find relevant messages without reading bodies
2. **Read selectively** - Only read full message content when you need the body
3. **Use time windows** - Limit searches to recent messages (e.g., last 7 days)
4. **Use artifact filters** - Search by artifact path to find relevant discussions
5. **Follow threads** - Use thread command to get conversation context efficiently

## Configuration

### Maildir Location

By default, emails are stored in `~/Maildir/workflow/`. Override with environment variable:

```bash
export WORKFLOW_MAILDIR=/path/to/custom/maildir
```

### Message Format

All messages follow the format defined in [MessageFormat.md](../MessageFormat.md):
- Standard email headers (From, To, Subject, Date)
- Workflow headers (X-Event-Type, X-Artifacts, X-Workflow-State)
- Threading headers (Message-ID, In-Reply-To, References)

## Examples by Role

### As spec-reviewer

```bash
# Start of work session
./Workflow/scripts/email-helper.sh find-reviews

# Found: specs/proposed/auth.md needs review
./Workflow/scripts/email-helper.sh read <message-key>

# Read the spec, perform review
cat project-meta/specs/proposed/auth.md

# Send approval
./Workflow/scripts/workflow-notify.sh --send \
  --in-reply-to "<message-id-from-review-request>" \
  approval \
  project-meta/specs/todo/auth.md \
  spec-writer
```

### As spec-writer (checking for feedback)

```bash
# Check if review completed
./Workflow/scripts/email-helper.sh find-approvals auth.md

# Or check for clarification requests
./Workflow/scripts/email-helper.sh find-clarifications auth.md

# Read any feedback
./Workflow/scripts/email-helper.sh read <message-key>

# If approved, notify next role
./Workflow/scripts/workflow-notify.sh --send \
  review-request \
  project-meta/specs/todo/auth.md \
  skeleton-writer
```

### As implementer (checking for blockers)

```bash
# Check recent messages
./Workflow/scripts/email-helper.sh recent 3

# Look for any blockers or clarifications about your work
./Workflow/scripts/email-helper.sh find-clarifications implementation

# Read relevant messages
./Workflow/scripts/email-helper.sh read <message-key>
```

## Troubleshooting

### Message not found

If email search returns no results:
1. Check maildir exists: `ls ~/Maildir/workflow`
2. Check for new vs cur: `ls ~/Maildir/workflow/new` and `ls ~/Maildir/workflow/cur`
3. Verify message was sent: Check workflow-notify.sh output

### Can't read message body

If message appears corrupted or unreadable:
1. Use `email_tools.py read <path>` instead of `cat` - handles encoding properly
2. Check message format in maildir - should be RFC 5322 compliant
3. Verify message was sent via `email_tools.py send` (not piped directly)

### Search not finding expected messages

1. Check time window: Use `--since 30d` for wider search
2. Check artifact name: Use partial match (e.g., "auth" matches "user-auth.md")
3. List all messages to verify they exist: `./Workflow/scripts/email-helper.sh check-new`

## See Also

- [MessageFormat.md](../MessageFormat.md) - Email message format specification
- [EmailIntegration.md](../EmailIntegration.md) - Email integration architecture
- [Email templates](../email-templates/) - Available message templates
