# Workflow Scripts

Scripts for orchestrating multi-role AI workflow.

## Quick Start

```bash
# Check project status and get suggestions
./workflow-status.sh

# Review a spec
./run-role.sh spec-reviewer specs/proposed/user-auth.md

# Start interactive spec writing session
./run-role.sh -i spec-writer

# Implement a feature
./run-role.sh implementer specs/doing/user-auth.md
```

## workflow-status.sh

Scans the project to determine current state and suggests next actions.

### Usage

```bash
./workflow-status.sh [--verbose]
```

**Options:**
- `--verbose` - Show detailed information about completed items

**What It Checks:**

1. **Planning Documents** - VISION.md, SCOPE.md, ROADMAP.md existence and review status
2. **Specifications** - What's in proposed/todo/doing/done and what each needs
3. **Implementation Progress** - For specs in doing/, checks for skeleton code, tests, implementation completeness
4. **Bugs** - What's in to_fix/fixing/fixed
5. **Living Documentation** - SYSTEM_MAP.md, GUIDELINES.md existence
6. **Git Status** - Current branch and uncommitted changes

**Output:**

The script provides:
- Color-coded status for each item (✓ found, ✗ missing, ⊙ needs review, → in progress)
- Prioritized list of suggested next actions with exact commands to run

**Example:**

```bash
$ ./workflow-status.sh

=== Workflow Status Report ===
Project: my-project
Path: /path/to/my-project

=== Planning Documents ===
  ✓ VISION.md (reviewed)
  ✓ SCOPE.md (reviewed)
  ⊙ ROADMAP.md (needs review)

=== Specifications ===
Proposed (needs review):
  ⊙ user-authentication.md
Todo (ready to start):
  ✓ api-endpoints.md

=== Suggested Next Actions ===
1. Review ROADMAP.md
   ./Workflow/scripts/run-role.sh roadmap-reviewer ROADMAP.md

2. Review spec: user-authentication.md
   ./Workflow/scripts/run-role.sh spec-reviewer specs/proposed/user-authentication.md

3. Start implementing: api-endpoints.md
   ./Workflow/scripts/run-role.sh skeleton-writer specs/todo/api-endpoints.md
```

## run-role.sh

Launches the appropriate AI tool with the correct model and role configuration.

### Usage

```bash
./run-role.sh [-i] <role-name> [artifact-path] [additional-context...]
```

**Options:**
- `-i, --interactive` - Run in interactive mode (default is one-shot)

**Arguments:**
- `role-name` (required): Name of the role to assume (e.g., `spec-writer`, `spec-reviewer`)
- `artifact-path` (optional): Path to the artifact being worked on
- `additional-context` (optional): Extra context or instructions

**Examples:**

```bash
# Interactive sessions (for exploration and writing)
./run-role.sh -i vision-writing-helper
./run-role.sh -i spec-writer
./run-role.sh -i implementer specs/doing/user-auth.md

# One-shot reviews (default mode)
./run-role.sh spec-reviewer specs/proposed/user-authentication.md
./run-role.sh test-reviewer specs/doing/user-authentication.md
./run-role.sh implementation-reviewer specs/doing/user-authentication.md

# One-shot implementation with context
./run-role.sh implementer specs/doing/user-auth.md "Focus on error handling"

# List available roles
./run-role.sh
```

### How It Works

1. **Loads configuration** from `role-config.json` (role → tool/model mapping) and `tool-config.json` (tool settings)
2. **Builds system prompt** that tells the AI to:
   - Read the appropriate entry point doc (CLAUDE.md, AGENTS.md, etc.)
   - Follow the document graph to understand the project
   - Assume the specified role
3. **Launches the appropriate CLI** with correct model and parameters

### Interactive vs One-Shot

Any role can run in either mode, determined by the `-i` flag at call time:

**One-shot mode** (default):
- Requires artifact-path or additional-context
- Sends initialization automatically
- Executes task and returns result
- Exits when complete
- Best for: Reviews, focused implementation tasks

**Interactive mode** (with `-i` flag):
- Optional initial task/artifact
- Launches interactive session with role pre-loaded and automatically injected
- For Claude: Uses `--append-system-prompt` to inject role
- For Codex: Passes init message as positional argument (preserves TTY for interactive mode)
- For Gemini: Uses `-i/--prompt-interactive` to inject role
- For OpenCode: Uses `-p/--prompt` to inject role
- Best for: Exploratory work, writing, iterative development

### Configuration

**role-config.json** - Maps roles to tools and models:
```json
{
  "spec-writer": {
    "tool": "claude",
    "model": "claude-sonnet-4-5"
  },
  "spec-reviewer": {
    "tool": "codex",
    "model": "gpt-5",
    "reasoning_effort": "high"
  },
  "implementer": {
    "tool": "codex",
    "model": "gpt-5-codex"
  }
}
```

**tool-config.json** - Tool-specific settings:
```json
{
  "claude": {
    "entry_point": "CLAUDE.md",
    "cli": "claude"
  },
  "codex": {
    "entry_point": "AGENTS.md",
    "cli": "codex"
  }
}
```

### Customizing for Concrete Projects

When copying this workflow to a concrete project:

1. **Copy the entire Workflow/ directory** to your project
2. **Adjust role-config.json** if you want different model assignments
3. **Keep tool-config.json** as-is (it references entry points that are also copied)
4. **Run scripts from anywhere** - they auto-detect the project root

### Requirements

- **jq** - Install with `brew install jq`
- **Appropriate CLIs installed** - `claude`, `codex`, `gemini`, and/or `opencode`
- **Authentication configured** for each tool you use

### Troubleshooting

**"Unknown role: X"**
- Check spelling against available roles in `role-config.json`
- Run `./run-role.sh` without arguments to see available roles

**"CLI not found"**
- Verify the tool is installed: `which claude`, `which codex`, etc.
- Check that it's in your PATH

**"Role file not found"**
- Verify `Workflow/role-<name>.md` exists
- Check you're running from the correct directory

## workflow-notify.sh

Generates standardized workflow event notifications for handoffs between roles.

### Usage

```bash
./workflow-notify.sh [OPTIONS] <event-type> <artifact-path> <recipient-role> [key=value...]
```

**Options:**
- `--send` - Send via email (requires email system integration, not yet implemented)
- `--from <role>` - Specify sender role (default: auto-detect)
- `--session <id>` - Specify session identifier for grouping related work
- `--in-reply-to <id>` - Mark as reply to a specific message ID
- `--help` - Show help message

**Arguments:**
- `event-type` (required): Type of event (see Event Types below)
- `artifact-path` (required): Path to the primary artifact
- `recipient-role` (required): Role to receive notification (comma-separated for multiple)
- `key=value` (optional): Additional template variables

**Event Types:**
- `review-request` - Artifact ready for review
- `approval` - Review approved, artifact transitioned
- `rejection` - Review rejected, revision needed
- `clarification-request` - Need clarification on artifact
- `blocker-report` - Work blocked, cannot proceed
- `status-update` - Informational progress update
- `question` - General question requiring expert input
- `answer` - Response to a question

### Examples

**Generate a review request:**
```bash
./workflow-notify.sh review-request specs/proposed/user-auth.md spec-reviewer
```

**Generate approval with custom variables:**
```bash
./workflow-notify.sh approval specs/todo/user-auth.md spec-writer \
  NEXT_ROLES="skeleton-writer,test-writer" \
  NEXT_STATE="todo" \
  REVIEWER_COMMENTS="Excellent spec, very thorough"
```

**Generate rejection with feedback:**
```bash
./workflow-notify.sh rejection specs/proposed/api.md spec-writer \
  REVIEWER_COMMENTS="Missing error handling section" \
  ISSUES_FOUND="1. No error codes defined\n2. Missing retry logic"
```

**Request clarification:**
```bash
./workflow-notify.sh clarification-request specs/proposed/auth.md spec-writer \
  QUESTION="Should OAuth tokens be stored in database or cache?" \
  BLOCKING="yes"
```

### How It Works

1. **Loads template** - Finds the appropriate template file in `email-templates/`
2. **Detects context** - Auto-detects workflow state, review type from artifact path
3. **Substitutes variables** - Replaces `{{VARIABLE}}` placeholders with actual values
4. **Generates headers** - Creates proper email headers (From, To, Subject, Date, Message-ID, etc.)
5. **Outputs message** - Sends to stdout (or email when integrated)

### Template Variables

Variables can be set via command-line arguments or are auto-detected:

**Auto-detected:**
- `FROM_ROLE` - Sender (from `--from` or auto-detected)
- `TO_ROLE` - Recipient role
- `ARTIFACT_PATH` - Path to artifact
- `ARTIFACT_NAME` - Filename without extension
- `WORKFLOW_STATE` - Detected from path (proposed/todo/doing/done)
- `REVIEW_TYPE` - Detected from path (specification/skeleton/test/implementation)
- `DATE` - Current timestamp
- `MESSAGE_ID` - Unique message identifier

**Custom (via key=value arguments):**
- `CONTEXT` - Additional context for the message
- `REVIEWER_COMMENTS` - Feedback from reviewer
- `NEXT_STATE` - State after transition
- `NEXT_ROLES` - Roles that should work on this next
- `NEXT_ACTIONS` - Specific action items
- `QUESTION` - Question text (for clarification-request)
- `BLOCKING` - Whether issue blocks progress (yes/no)
- `ISSUES_FOUND` - Structured list of issues

See [../email-templates/README.md](../email-templates/README.md) for complete variable reference.

### Message Format

Generated messages follow email format with workflow-specific headers:

```
From: spec-writer@workflow.local
To: spec-reviewer@workflow.local
Subject: [REVIEW REQUEST] user-auth ready for review
Date: Thu, 14 Nov 2025 10:30:00 -0800
Message-ID: <20251114103000.spec-writer@workflow.local>
X-Event-Type: review-request
X-Artifacts: specs/proposed/user-auth.md
X-Workflow-State: proposed

The specification is ready for review.

Artifact: specs/proposed/user-auth.md
State: proposed
Author: spec-writer
Date: Thu, 14 Nov 2025 10:30:00 -0800

[Message body...]

---
Sent by spec-writer role
Generated: Thu, 14 Nov 2025 10:30:00 -0800
```

See [../MessageFormat.md](../MessageFormat.md) for complete format specification.

### Templates

Message templates are stored in `../email-templates/`:
- `review-request.txt` - Request review of completed artifact
- `approval.txt` - Notify of approved review
- `rejection.txt` - Notify of rejected review with feedback
- `clarification-request.txt` - Request clarification on artifact

To create new templates, see [../email-templates/README.md](../email-templates/README.md).

### Integration with Email System

Currently, messages are output to stdout for testing and debugging. When the email system is integrated (docs/PLAN.md Milestone 1, part 2):

1. `--send` flag will send via Maildir-based email system
2. Roles will poll mailboxes for incoming messages
3. Threading will enable conversation tracking
4. State transitions can trigger automatic notifications

### Testing Messages

**View generated message:**
```bash
./workflow-notify.sh review-request specs/proposed/test.md spec-reviewer
```

**Save to file:**
```bash
./workflow-notify.sh approval specs/todo/test.md spec-writer > /tmp/approval.txt
```

**Validate format:**
```bash
./workflow-notify.sh review-request specs/proposed/test.md spec-reviewer | grep -q "^X-Event-Type: review-request" && echo "Valid"
```

### Troubleshooting

**"Invalid event type"**
- Check spelling of event type
- Use `--help` to see valid event types

**"Template not found"**
- Verify template exists in `email-templates/`
- Check that template filename matches event type (e.g., `review-request.txt`)

**Missing variables in output**
- Optional variables are omitted if not provided
- Required variables are auto-detected or must be provided via key=value arguments

## Future Enhancements

- **Enhanced heuristics** - Improve workflow-status.sh detection of implementation completeness
- **Parallel execution** - Add option to run-role.sh to execute multiple reviews in parallel
- **Custom workflows** - Support for project-specific workflow variations
- **Email system integration** - Implement `--send` flag with Maildir support (PLAN.md Milestone 1)
