# Auto-Trigger Review System

## Overview

This document proposes a system for automatically triggering reviews when artifacts are complete, reducing manual handoff overhead while maintaining quality gates. This makes the workflow feasible for a single developer by automating the review request process while keeping review quality high through AI-assisted reviews.

## Core Principle

**Automation enables solo developers to use a rigorous multi-gate workflow that would otherwise require a team.**

The workflow has many review gates (8 artifact types × multiple stages = ~20+ potential reviews per feature). For a solo developer, manually context-switching between writer and reviewer roles is cognitively expensive. Automated review triggering:

1. **Removes friction** - No manual "I'm done, please review" step
2. **Maintains rigor** - Reviews still happen, just automatically
3. **Preserves separation** - Different AI reviewers than writers (Codex vs Claude)
4. **Enables throughput** - Solo developer can maintain velocity with quality

## Architecture

### Option 1: MCP-Based Auto-Trigger (Recommended)

Extend the existing `codex-review` MCP server pattern with workflow-aware tools:

```typescript
// New MCP tools for workflow integration
{
  "tools": [
    {
      "name": "request_spec_review",
      "description": "Auto-trigger spec review when spec writing complete",
      "input": {
        "spec_path": "specs/proposed/user-auth.md",
        "auto_move_on_approval": true  // Move to specs/todo/ if approved
      }
    },
    {
      "name": "request_test_review",
      "description": "Auto-trigger test review when tests complete",
      "input": {
        "test_files": ["tests/unit/test_auth.py"],
        "spec_path": "specs/doing/user-auth.md",
        "coverage_report": "coverage.xml"
      }
    },
    {
      "name": "request_implementation_review",
      "description": "Auto-trigger implementation review when code complete",
      "input": {
        "implementation_files": ["src/auth.py"],
        "test_results": "pytest output",
        "spec_path": "specs/doing/user-auth.md"
      }
    }
  ]
}
```

**How it works:**

1. **Writer role completes artifact** (e.g., spec writer finishes SPEC.md)
2. **Claude Code calls MCP tool** automatically (configured in role prompt)
3. **MCP server gathers context**:
   - Reads artifact
   - Reads related docs (VISION, SCOPE, upstream specs)
   - Reads relevant schemas (schema-spec.md, schema-review.md)
   - Formats as review request per schema-review-request.md
4. **MCP server calls Codex** with formatted review request
5. **Codex performs review** using appropriate reviewer role (role-spec-reviewer.md)
6. **MCP server saves review** to `reviews/specs/<timestamp>-APPROVED|NEEDS-CHANGES.md`
7. **Optionally moves artifact** if approved and `auto_move_on_approval: true`

### Option 2: Post-Completion Hook

Add workflow hooks that trigger after completion markers:

```bash
# In role-spec-writer.md
## Completion Signal

When spec is complete, create completion marker:
```bash
echo "SPEC_COMPLETE" > .workflow/completion/spec-<feature>.marker
```

This triggers review automation configured in `.workflow/hooks/post-spec-complete.sh`
```

**Pros:** Simple, no MCP changes needed
**Cons:** Requires external daemon or manual check, less integrated

### Option 3: Explicit Call in Role Prompts (Simplest)

Add explicit instructions to writer roles to call review when done:

```markdown
## Step 7: Request Review

When spec is complete, request review:

```bash
# Use MCP tool to request review
mcp__request_spec_review({
  "spec_path": "specs/proposed/<feature>.md",
  "auto_move_on_approval": true
})
```

The reviewer (Codex GPT-5) will:
- Review against schema-spec.md
- Check alignment with ROADMAP.md
- Verify testability
- Return APPROVED or NEEDS-CHANGES
```

**Pros:** Explicit, user understands what's happening
**Cons:** Still requires manual call (though much easier than full context switch)

## Recommended Approach: Hybrid

Combine Option 1 (MCP tools) with Option 3 (explicit calls):

1. **Provide MCP tools** for each review type
2. **Instruct writers to call them** when complete
3. **Make calls one-liner simple** (not manual context switch)
4. **Auto-approve if configured** (`auto_move_on_approval: true`)

This balances:
- **Automation** (one-line call, not full context switch)
- **Transparency** (user sees review happening)
- **Control** (user can disable auto-approve if desired)

## Technical Implementation

### MCP Server: workflow-reviewer

Create new MCP server (or extend codex-review):

```bash
/mcp-servers/workflow-reviewer/
  src/
    index.ts          # Main MCP server
    review-types/     # Review type handlers
      spec.ts
      test.ts
      implementation.ts
      skeleton.ts
    schema-loader.ts  # Load schema-*.md files
    context-builder.ts # Build review context
    codex-caller.ts   # Call Codex with review request
```

#### Key Functions

**1. Context Builder**

```typescript
async function buildSpecReviewContext(specPath: string): Promise<string> {
  // Read artifact
  const spec = await readFile(specPath);

  // Read related docs
  const roadmap = await readFile("ROADMAP.md");
  const scope = await readFile("SCOPE.md");

  // Read schemas
  const specSchema = await readFile("Workflow/schema-spec.md");
  const reviewSchema = await readFile("Workflow/schema-review.md");

  // Format as review request
  return formatReviewRequest({
    reviewType: "spec",
    artifactPath: specPath,
    artifactContent: spec,
    relatedDocs: { roadmap, scope },
    schemas: { specSchema, reviewSchema }
  });
}
```

**2. Review Request Formatter**

```typescript
function formatReviewRequest(context: ReviewContext): string {
  return `# CODEX REVIEW REQUEST: Spec Review

## Role

You are a Spec Reviewer following role-spec-reviewer.md.

## Artifact Being Reviewed

**Path:** ${context.artifactPath}

\`\`\`markdown
${context.artifactContent}
\`\`\`

## Context: Related Documents

### ROADMAP.md (Feature Source)
\`\`\`markdown
${context.relatedDocs.roadmap}
\`\`\`

### SCOPE.md (Project Scope)
\`\`\`markdown
${context.relatedDocs.scope}
\`\`\`

## Review Schemas

### schema-spec.md (What Makes a Good Spec)
\`\`\`markdown
${context.schemas.specSchema}
\`\`\`

### schema-review.md (Review Format)
\`\`\`markdown
${context.schemas.reviewSchema}
\`\`\`

## Your Task

Review the spec against schema-spec.md criteria.
Return review in schema-review.md format.
Decision: APPROVED or NEEDS-CHANGES.

Focus on:
1. Testability - Can tests be written from this?
2. Completeness - All acceptance criteria present?
3. Clarity - Unambiguous requirements?
4. Alignment - Matches ROADMAP feature?
`;
}
```

**3. Review Saver & Artifact Mover**

```typescript
async function handleReviewResponse(
  response: string,
  artifactPath: string,
  autoMove: boolean
): Promise<{ decision: string; reviewPath: string }> {
  // Parse decision from response
  const decision = extractDecision(response); // "APPROVED" or "NEEDS-CHANGES"

  // Save review
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const feature = path.basename(artifactPath, '.md');
  const reviewPath = `reviews/specs/${timestamp}-${feature}-${decision}.md`;
  await writeFile(reviewPath, response);

  // Auto-move if approved
  if (decision === "APPROVED" && autoMove) {
    const targetPath = artifactPath.replace('/proposed/', '/todo/');
    await execGit(['mv', artifactPath, targetPath]);
    await execGit(['add', reviewPath]);
    await execGit(['commit', '-m', `Approve spec: ${feature}\n\nAuto-review via Codex`]);
  }

  return { decision, reviewPath };
}
```

### Role Prompt Updates

#### role-spec-writer.md

Add final step:

```markdown
## Step 7: Request Review

When spec is complete, request review using MCP tool:

\`\`\`bash
# Request Codex review (auto-moves to specs/todo/ if approved)
mcp__request_spec_review({
  "spec_path": "specs/proposed/<feature>.md",
  "auto_move_on_approval": true
})
\`\`\`

**What happens:**
1. Codex (GPT-5) reviews spec against schema-spec.md
2. Review saved to `reviews/specs/<timestamp>-APPROVED.md`
3. If APPROVED: Spec moved to `specs/todo/` automatically
4. If NEEDS-CHANGES: Spec stays in `proposed/`, address issues

**Alternative (manual control):**
\`\`\`bash
# Request review but don't auto-move (user moves manually after checking review)
mcp__request_spec_review({
  "spec_path": "specs/proposed/<feature>.md",
  "auto_move_on_approval": false
})
\`\`\`
```

#### role-test-writer.md

```markdown
## Step 5: Request Review

When tests complete, request review:

\`\`\`bash
# Request Codex test review
mcp__request_test_review({
  "test_files": ["tests/unit/test_<feature>.py"],
  "spec_path": "specs/doing/<feature>.md",
  "coverage_report": ".coverage"  # Optional: include coverage data
})
\`\`\`

**What Codex checks:**
1. Tests match spec acceptance criteria
2. Coverage meets thresholds (>80% line, >70% branch)
3. Edge cases covered
4. Tests will fail on missing implementation (RED phase)
```

#### role-implementer.md

```markdown
## Step 6: Request Implementation Review

When implementation complete (all tests passing), request review:

\`\`\`bash
# Request Codex implementation review
mcp__request_implementation_review({
  "implementation_files": ["src/<feature>.py"],
  "test_results": "$(pytest --tb=short)",
  "spec_path": "specs/doing/<feature>.md",
  "auto_move_to_done": true  # Move to specs/done/ if approved
})
\`\`\`

**Critical: Codex checks test integrity**
- Tests unmodified (git diff tests/)
- No test weakening
- No sophisticated workarounds (operator overloading, special-casing, state recording)
- **If any test integrity violation detected: Automatic NEEDS-CHANGES**

See Anti-Pattern section below for what triggers automatic rejection.
```

## Review Types & MCP Tools

| Artifact Type | MCP Tool | Reviewer Role | Auto-Move On Approval |
|---------------|----------|---------------|----------------------|
| VISION.md | `mcp__request_vision_review` | role-vision-reviewer.md | No (stays in root) |
| SCOPE.md | `mcp__request_scope_review` | role-scope-reviewer.md | No (stays in root) |
| ROADMAP.md | `mcp__request_roadmap_review` | role-roadmap-reviewer.md | No (stays in root) |
| Spec | `mcp__request_spec_review` | role-spec-reviewer.md | Yes (proposed → todo) |
| Skeleton | `mcp__request_skeleton_review` | role-skeleton-reviewer.md | Optional |
| Tests | `mcp__request_test_review` | role-test-reviewer.md | Optional |
| Implementation | `mcp__request_implementation_review` | role-implementation-reviewer.md | Yes (doing → done) |
| Bug Fix | `mcp__request_bugfix_review` | role-implementation-reviewer.md | Yes (fixing → fixed) |

## Human Oversight Options

### Level 1: Full Automation (Fastest)

```bash
auto_move_on_approval: true
```

- Codex reviews
- If APPROVED: Artifact moves automatically
- If NEEDS-CHANGES: Stays put, human addresses issues
- **Use when:** Solo developer, high trust in Codex, fast iteration desired

### Level 2: Review-Then-Approve (Balanced)

```bash
auto_move_on_approval: false
```

- Codex reviews
- Human reads review
- Human manually moves artifact if they agree
- **Use when:** Want to verify Codex reasoning, learning phase

### Level 3: Advisory Only (Manual Control)

```bash
# Don't call auto-review tool
# Instead: Read review manually or use mcp__codex_review for ad-hoc advice
```

- Human requests review when they want feedback
- Codex provides advisory feedback
- Human makes all decisions
- **Use when:** Critical artifacts, regulatory requirements, learning workflow

## Integration with Existing Workflow

### Before Auto-Trigger

```
1. Spec Writer writes spec → specs/proposed/user-auth.md
2. [MANUAL] Human switches to Spec Reviewer role
3. [MANUAL] Human reads spec, thinks through review criteria
4. [MANUAL] Human writes review → reviews/specs/20251026-user-auth-APPROVED.md
5. [MANUAL] Human moves spec → git mv specs/proposed/user-auth.md specs/todo/user-auth.md
6. [MANUAL] Human commits
```

**Friction:** 5 manual steps, full context switch, cognitive load

### After Auto-Trigger (Option 1: Full Auto)

```
1. Spec Writer writes spec → specs/proposed/user-auth.md
2. Spec Writer calls: mcp__request_spec_review({ ..., auto_move_on_approval: true })
3. [AUTO] Codex reviews
4. [AUTO] Review saved → reviews/specs/20251026-user-auth-APPROVED.md
5. [AUTO] Spec moved → specs/todo/user-auth.md
6. [AUTO] Git commit
7. Spec Writer reads review (optional, for learning)
8. Continue to next task
```

**Friction:** 1 manual call, review happens in background

### After Auto-Trigger (Option 2: Review-Then-Approve)

```
1. Spec Writer writes spec → specs/proposed/user-auth.md
2. Spec Writer calls: mcp__request_spec_review({ ..., auto_move_on_approval: false })
3. [AUTO] Codex reviews
4. [AUTO] Review saved → reviews/specs/20251026-user-auth-APPROVED.md
5. Spec Writer reads review
6. Spec Writer manually moves if satisfied: git mv specs/proposed/... specs/todo/...
```

**Friction:** 1 auto call + 1 manual move, but human verifies reasoning

## Addressing "Taking Humans Out of the Loop"

**Original concern:** "Claude was concerned that it would take the human out of the loop so they couldn't or wouldn't approve all the changes."

**Response:** This is actually a **benefit** for solo developers:

### Why This Is Good for Solo Developers

1. **Humans ARE still in the loop** - Just at different checkpoints:
   - Human writes artifact (full control)
   - AI reviews (consistency, completeness, schema compliance)
   - Human reads review (optional verification)
   - Human can disable auto-move if they want final approval
   - Human writes next artifact (informed by review feedback)

2. **The workflow is infeasible without automation**:
   - 8 artifact types × multiple reviews = 20+ reviews per feature
   - Each manual review = 15-30 minutes of context switching
   - Solo developer cannot maintain velocity with manual reviews
   - **Options:** (a) Skip reviews (lose quality), (b) Automate reviews (maintain quality), (c) Don't use workflow (lose structure)

3. **AI reviews are MORE consistent than human self-review**:
   - Human reviewing own work: Blind spots, bias, fatigue
   - AI reviewing human work: Fresh perspective, schema-strict, consistent
   - Different model (Codex) than writer (Claude): True separation of concerns

4. **Human can always override**:
   - `auto_move_on_approval: false` → Human must approve
   - Read review before continuing → Learning opportunity
   - Disable auto-review entirely → Fall back to manual

### When to Keep Humans Fully In Loop

1. **Critical infrastructure** (deployment scripts, security)
2. **Regulatory requirements** (must show human approval)
3. **Learning phase** (understanding workflow, building trust)
4. **High-stakes decisions** (VISION, SCOPE changes)

For these: Use `auto_move_on_approval: false` or skip auto-review entirely.

## Implementation Roadmap

### Phase 1: Single Review Type (Proof of Concept)

**Deliverable:** Auto-triggered spec reviews

1. Create `mcp-server-workflow-reviewer` with single tool:
   - `mcp__request_spec_review`
2. Implement context builder (read spec, roadmap, scope, schemas)
3. Implement review formatter (schema-review-request.md format)
4. Call Codex with formatted request
5. Save review to `reviews/specs/`
6. Test with real spec

**Success criteria:**
- One-line call triggers full review
- Review saved to correct location
- Review quality matches manual Codex prompts

### Phase 2: Auto-Move on Approval

**Deliverable:** Approved specs move automatically

1. Add `auto_move_on_approval` parameter
2. Parse review decision (APPROVED vs NEEDS-CHANGES)
3. Execute `git mv` if approved
4. Create commit with review reference

**Success criteria:**
- APPROVED specs move to specs/todo/
- NEEDS-CHANGES specs stay in specs/proposed/
- Git history shows review-triggered moves

### Phase 3: Additional Review Types

**Deliverable:** All 8 review types supported

1. Implement test review (`mcp__request_test_review`)
2. Implement implementation review (`mcp__request_implementation_review`)
3. Implement skeleton review (`mcp__request_skeleton_review`)
4. Implement vision/scope/roadmap reviews
5. Implement bug-fix review

**Success criteria:**
- Each review type uses correct schemas
- Each review type gathers correct context
- Reviews match manual quality

### Phase 4: Sentinel Test Verification

**Deliverable:** Implementation reviews verify test integrity

1. Add test modification detection (git diff tests/)
2. Add sophisticated workaround detection:
   - Operator overloading (`__eq__` always returns True)
   - State recording (global counters, call-specific returns)
   - Special-casing (hardcoded test inputs)
3. Automatic NEEDS-CHANGES if violations detected

**Success criteria:**
- Test modifications caught automatically
- Sophisticated workarounds (per ImpossibleBench paper) flagged
- Clear explanation of what violated integrity

### Phase 5: Real-Time Test Review (Advanced)

**Deliverable:** Implementers can request test review mid-implementation

1. Implement `mcp__request_immediate_test_review` (synchronous)
2. Lightweight review: "Is this test correct or am I confused?"
3. Fast turnaround (< 30 seconds)
4. Use lower reasoning_effort for speed

**Success criteria:**
- Implementer blocked by test conflict → calls tool → gets answer
- Reduces temptation to modify tests
- Faster than filing RFC

## Configuration

### User Configuration: .workflow/config.json

```json
{
  "auto_review": {
    "enabled": true,
    "auto_move_on_approval": {
      "specs": true,
      "tests": false,
      "implementations": true,
      "skeletons": false
    },
    "review_model": "gpt-5-codex",
    "reasoning_effort": "high",
    "save_reviews": true
  }
}
```

### MCP Server Configuration: ~/.config/claude-code/mcp.json

```json
{
  "mcpServers": {
    "workflow-reviewer": {
      "command": "node",
      "args": ["/path/to/mcp-servers/workflow-reviewer/build/index.js"],
      "env": {
        "OPENAI_API_KEY": "sk-proj-...",
        "WORKFLOW_CONFIG": "/path/to/project/.workflow/config.json"
      }
    }
  }
}
```

## Cost Considerations

**Codex API costs** for auto-reviews:

- Spec review: ~$0.50 (large context: spec + roadmap + schemas)
- Test review: ~$0.30 (medium context: tests + spec)
- Implementation review: ~$0.40 (medium context: code + tests + spec)

**Per feature (8 reviews):**
- Vision review: ~$0.60 (one-time per project)
- Scope review: ~$0.60 (one-time per project)
- Roadmap review: ~$0.60 (one-time per project)
- Spec review: ~$0.50
- Skeleton review: ~$0.30
- Test review: ~$0.30
- Implementation review: ~$0.40

**Total per feature:** ~$2.00 (amortizing one-time reviews)

**Alternative costs:**
- Manual review (human, 6 reviews × 20 min): 2 hours of developer time
- Manual review (human, at $100/hr): $200
- **Savings: 100x cheaper, instant turnaround**

## Examples

### Example 1: Spec Review with Auto-Move

```bash
# Spec writer completes spec
$ cat specs/proposed/user-authentication.md
# User Authentication
... [spec content] ...

# Request review with auto-move
$ mcp__request_spec_review({
  "spec_path": "specs/proposed/user-authentication.md",
  "auto_move_on_approval": true
})

# MCP server response:
{
  "decision": "APPROVED",
  "review_path": "reviews/specs/20251026T143022-user-authentication-APPROVED.md",
  "artifact_moved_to": "specs/todo/user-authentication.md",
  "summary": "Spec is complete, testable, and aligns with ROADMAP. Moved to todo/."
}

# Result:
# - Review saved: reviews/specs/20251026T143022-user-authentication-APPROVED.md
# - Spec moved: specs/proposed/user-authentication.md → specs/todo/user-authentication.md
# - Git commit: "Approve spec: user-authentication\n\nAuto-review via Codex"
```

### Example 2: Implementation Review with Test Integrity Check

```bash
# Implementer completes feature, all tests passing
$ pytest
===================== 47 passed in 2.31s =====================

# Request implementation review
$ mcp__request_implementation_review({
  "implementation_files": ["src/auth/login.py", "src/auth/session.py"],
  "test_results": "$(pytest --tb=short)",
  "spec_path": "specs/doing/user-authentication.md",
  "auto_move_to_done": true
})

# MCP server response:
{
  "decision": "NEEDS-CHANGES",
  "review_path": "reviews/implementations/20251026T150311-user-authentication-NEEDS-CHANGES.md",
  "violations": [
    {
      "type": "test_modification",
      "file": "tests/unit/test_login.py",
      "line": 45,
      "description": "Test assertion weakened: Changed 'assert result.status == \"active\"' to 'assert result.status in [\"active\", \"pending\"]'",
      "evidence": "git diff shows test modification after test-review approval"
    }
  ],
  "summary": "AUTOMATIC REJECTION: Test integrity violation detected. Tests were modified after test-review approval. Revert test changes and fix implementation instead."
}

# Result:
# - Review saved with violation details
# - Spec NOT moved (stays in doing/)
# - Implementer must revert test change and fix code properly
```

### Example 3: Real-Time Test Review (Advanced)

```bash
# Implementer encounters test conflict during implementation
$ pytest tests/unit/test_login.py::test_login_invalid_email
... FAILED: Expected ValidationError, got ValueError ...

# Implementer confused: "Test expects ValueError but spec says ValidationError?"
# Instead of modifying test, request immediate review:
$ mcp__request_immediate_test_review({
  "test_file": "tests/unit/test_login.py",
  "test_name": "test_login_invalid_email",
  "spec_path": "specs/doing/user-authentication.md",
  "conflict_description": "Test expects ValueError but spec says ValidationError",
  "evidence": {
    "spec_quote": "3.2: Raise ValidationError for invalid emails",
    "test_code": "with pytest.raises(ValueError): login('bad@email', 'pw')"
  }
})

# MCP server response (fast, < 30 seconds):
{
  "decision": "TEST_HAS_BUG",
  "test_fix": "Change pytest.raises(ValueError) to pytest.raises(ValidationError)",
  "explanation": "Spec clearly states ValidationError. Test has bug. Updated test committed.",
  "updated_test_path": "tests/unit/test_login.py"
}

# Result:
# - Test corrected automatically (or suggested correction if auto-fix disabled)
# - Implementer continues with correct test
# - No test integrity violation
```

## Benefits Summary

1. **Velocity:** Solo developer maintains rigorous workflow without team
2. **Consistency:** AI reviews are schema-strict, catch issues humans miss
3. **Learning:** Reviews provide feedback, improve future artifacts
4. **Separation:** Different models (Codex reviews Claude's work) = true separation
5. **Flexibility:** User chooses automation level (full auto, review-then-approve, manual)
6. **Cost-effective:** ~$2/feature vs hours of manual review time

## Next Steps

1. **Decide on approach:** Full auto, review-then-approve, or advisory?
2. **Phase 1 implementation:** Spec reviews as proof of concept
3. **Iterate based on feedback:** Adjust automation level, review quality
4. **Expand to all review types:** Tests, implementations, etc.
5. **Add advanced features:** Real-time test review, sentinel verification

---

**Questions for discussion:**

1. Which automation level feels right? (full auto, review-then-approve, manual)
2. Which review types should auto-move vs require human approval?
3. Should we implement Phase 5 (real-time test review) or is auto-move enough?
4. Any concerns about Codex review quality vs human review?
