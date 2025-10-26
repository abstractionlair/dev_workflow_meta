# SPEC: Workflow Reviewer MCP Server

**Feature:** MCP server providing auto-triggered reviews for dev workflow artifacts

**Status:** Proposed

**Related Documents:**
- AutoTriggerReviews.md - High-level design and rationale
- /mcp-servers/codex-review/ - Existing Codex review MCP server (reference implementation)
- schema-review-request.md - Review request format
- schema-review.md - Review output format

---

## 1. Purpose

Enable solo developers to use rigorous multi-gate workflow by automating review requests while maintaining quality through AI-assisted reviews (Codex GPT-5).

## 2. Success Criteria

1. **One-line review trigger:** Writer calls single MCP tool to trigger complete review
2. **Context-aware:** MCP server gathers all necessary context (artifact, related docs, schemas)
3. **Schema-compliant:** Review requests follow schema-review-request.md format
4. **Quality reviews:** Codex reviews match or exceed manual prompt quality
5. **Auto-move capability:** Approved artifacts can auto-move through workflow states
6. **Test integrity verification:** Implementation reviews detect test modifications

## 3. Scope

### In Scope

- MCP tools for 8 review types (vision, scope, roadmap, spec, skeleton, test, implementation, bug-fix)
- Automatic context gathering (read related docs, schemas)
- Review request formatting per schema-review-request.md
- Codex API integration via `codex` CLI
- Review result parsing (APPROVED vs NEEDS-CHANGES)
- Auto-move on approval (optional, configurable)
- Git integration (move artifacts, create commits)
- Test integrity verification (git diff detection)

### Out of Scope (Deferred)

- Real-time test review (Phase 5 - future feature)
- Sophisticated workaround detection (operator overloading, state recording - Phase 4)
- Review quality metrics/analytics
- Multi-reviewer consensus
- Review caching

### Constraints

- Must use existing `codex` CLI (no direct OpenAI API calls)
- Must work with existing directory structure (specs/proposed/, reviews/specs/, etc.)
- Must preserve git history (no force-push, no rewriting)
- Must handle API failures gracefully (don't leave workflow in broken state)

## 4. User Stories

### Story 1: Spec Writer Auto-Review

**As a** spec writer
**I want to** trigger spec review with a single command
**So that** I don't have to manually context-switch to reviewer role

**Acceptance criteria:**
- Call `mcp__request_spec_review({ spec_path, auto_move_on_approval })`
- MCP server reads spec, roadmap, scope, schemas
- MCP server formats review request per schema-review-request.md
- Codex performs review following role-spec-reviewer.md
- Review saved to `reviews/specs/<timestamp>-<feature>-<DECISION>.md`
- If APPROVED and auto_move=true: Spec moved to `specs/todo/`
- Git commit created with review reference

### Story 2: Implementation Review with Test Integrity

**As an** implementer
**I want to** get implementation review that verifies test integrity
**So that** I can't accidentally (or intentionally) modify tests to pass

**Acceptance criteria:**
- Call `mcp__request_implementation_review({ implementation_files, test_results, spec_path })`
- MCP server checks: `git diff tests/` since test-review approval
- If tests modified: Automatic NEEDS-CHANGES with violation details
- If tests unchanged: Full implementation review proceeds
- Review includes test integrity verification section
- Clear explanation if test integrity violated

### Story 3: Review-Then-Approve Workflow

**As a** cautious developer
**I want to** review Codex's assessment before auto-moving artifacts
**So that** I maintain final approval authority

**Acceptance criteria:**
- Call review tool with `auto_move_on_approval: false`
- Review saved but artifact NOT moved
- User reads review at `reviews/<type>/<timestamp>-<DECISION>.md`
- User manually moves artifact if satisfied: `git mv specs/proposed/... specs/todo/...`
- User can reject Codex's APPROVED decision by not moving

## 5. Architecture

### 5.1 MCP Server Structure

```
mcp-servers/workflow-reviewer/
├── src/
│   ├── index.ts                 # Main MCP server
│   ├── tools/                   # Tool implementations
│   │   ├── spec-review.ts       # mcp__request_spec_review
│   │   ├── test-review.ts       # mcp__request_test_review
│   │   ├── impl-review.ts       # mcp__request_implementation_review
│   │   ├── skeleton-review.ts   # mcp__request_skeleton_review
│   │   └── ...                  # Other review types
│   ├── lib/
│   │   ├── context-builder.ts   # Read artifacts, related docs, schemas
│   │   ├── review-formatter.ts  # Format review request (schema-review-request.md)
│   │   ├── codex-caller.ts      # Call Codex via CLI
│   │   ├── result-parser.ts     # Parse APPROVED/NEEDS-CHANGES
│   │   ├── artifact-mover.ts    # Git mv, commit
│   │   └── test-integrity.ts    # Check test modifications
│   └── types/
│       └── index.ts             # TypeScript interfaces
├── package.json
├── tsconfig.json
└── README.md
```

### 5.2 Tool Interface

Each review tool follows this pattern:

```typescript
interface ReviewToolParams {
  // Artifact to review
  artifact_path: string;

  // Related artifacts (context)
  related_docs?: {
    spec_path?: string;
    roadmap_path?: string;
    // ...
  };

  // Test-specific
  test_files?: string[];
  test_results?: string;
  coverage_report?: string;

  // Implementation-specific
  implementation_files?: string[];

  // Behavior
  auto_move_on_approval?: boolean; // Default: false
  reasoning_effort?: "low" | "medium" | "high"; // Default: "high"
}

interface ReviewToolResponse {
  decision: "APPROVED" | "NEEDS-CHANGES";
  review_path: string;
  artifact_moved_to?: string; // Only if auto_move=true and APPROVED
  summary: string;
  violations?: Array<{
    type: string;
    description: string;
    evidence: string;
  }>;
}
```

### 5.3 Data Flow

```
User calls MCP tool
    ↓
MCP server: contextBuilder.buildContext()
    ├─ Read artifact (spec, test, impl)
    ├─ Read related docs (roadmap, scope, etc.)
    └─ Read schemas (schema-spec.md, schema-review.md, etc.)
    ↓
MCP server: reviewFormatter.formatRequest()
    └─ Format per schema-review-request.md
    ↓
MCP server: codexCaller.callCodex()
    ├─ Construct codex CLI command
    ├─ Include role context (role-spec-reviewer.md)
    └─ Send formatted review request
    ↓
Codex performs review
    ↓
MCP server: resultParser.parseDecision()
    └─ Extract APPROVED or NEEDS-CHANGES
    ↓
MCP server: Save review
    └─ Write to reviews/<type>/<timestamp>-<DECISION>.md
    ↓
MCP server: artifactMover.moveIfApproved() [if auto_move=true]
    ├─ git mv artifact to next state
    └─ git commit with review reference
    ↓
Return ReviewToolResponse to user
```

## 6. Interface Contracts

### 6.1 Tool: mcp__request_spec_review

**Input:**
```typescript
{
  spec_path: string;              // Required: specs/proposed/<feature>.md
  auto_move_on_approval?: boolean; // Default: false
  reasoning_effort?: string;      // Default: "high"
}
```

**Output:**
```typescript
{
  decision: "APPROVED" | "NEEDS-CHANGES";
  review_path: string;            // reviews/specs/<timestamp>-<DECISION>.md
  artifact_moved_to?: string;     // specs/todo/<feature>.md (if auto_move=true && APPROVED)
  summary: string;                // One-sentence summary
}
```

**Behavior:**
1. Read spec at `spec_path`
2. Read ROADMAP.md (find feature this spec implements)
3. Read SCOPE.md (project scope context)
4. Read schema-spec.md (spec quality criteria)
5. Read schema-review.md (review format)
6. Read role-spec-reviewer.md (reviewer instructions)
7. Format review request per schema-review-request.md
8. Call Codex with formatted request
9. Parse response for APPROVED/NEEDS-CHANGES
10. Save review to reviews/specs/
11. If auto_move && APPROVED: git mv to specs/todo/, commit

**Edge cases:**
- Spec file not found → Error: "Spec not found at {spec_path}"
- ROADMAP.md missing → Warning, continue without roadmap context
- Codex API failure → Error: "Codex API failed: {error}", no artifact move
- Review unparseable → Error: "Could not determine decision from review"

### 6.2 Tool: mcp__request_test_review

**Input:**
```typescript
{
  test_files: string[];           // Required: ["tests/unit/test_*.py"]
  spec_path: string;              // Required: specs/doing/<feature>.md
  coverage_report?: string;       // Optional: path to coverage.xml or .coverage
  auto_move_on_approval?: boolean; // Default: false
}
```

**Output:**
```typescript
{
  decision: "APPROVED" | "NEEDS-CHANGES";
  review_path: string;
  summary: string;
  coverage?: {
    line_coverage: number;        // 0-100
    branch_coverage: number;      // 0-100
    meets_threshold: boolean;     // line>80% && branch>70%
  };
}
```

**Behavior:**
1. Read all test files
2. Read spec (acceptance criteria, edge cases)
3. Read schema-test-code.md (test quality criteria)
4. Read role-test-reviewer.md (reviewer instructions)
5. If coverage_report provided: Parse coverage data
6. Format review request
7. Call Codex
8. Parse decision
9. Save review

**Edge cases:**
- Test file not found → Error: "Test file not found: {file}"
- Coverage below threshold → NEEDS-CHANGES with coverage details
- Spec not found → Error: "Spec not found at {spec_path}"

### 6.3 Tool: mcp__request_implementation_review

**Input:**
```typescript
{
  implementation_files: string[]; // Required: ["src/auth.py"]
  test_results: string;           // Required: pytest output or "all passing"
  spec_path: string;              // Required: specs/doing/<feature>.md
  auto_move_to_done?: boolean;    // Default: false
}
```

**Output:**
```typescript
{
  decision: "APPROVED" | "NEEDS-CHANGES";
  review_path: string;
  artifact_moved_to?: string;     // specs/done/<feature>.md (if auto_move && APPROVED)
  summary: string;
  violations?: Array<{
    type: "test_modification" | "test_weakening" | "workaround";
    file: string;
    line?: number;
    description: string;
    evidence: string;
  }>;
}
```

**Behavior:**
1. **Test Integrity Check:**
   - Find test-review approval timestamp
   - Run `git diff <test-review-commit> tests/`
   - If tests modified: Automatic NEEDS-CHANGES, skip rest
2. Read implementation files
3. Read test results (verify all passing)
4. Read spec (verify spec compliance)
5. Read schema-implementation-code.md (implementation quality)
6. Read role-implementation-reviewer.md (reviewer instructions)
7. Format review request
8. Call Codex
9. Parse decision
10. Save review
11. If auto_move && APPROVED && no violations: git mv to specs/done/, commit

**Edge cases:**
- Tests not passing → Error: "Cannot review implementation with failing tests"
- Tests modified since test-review → Automatic NEEDS-CHANGES with violation details
- Implementation file not found → Error: "Implementation file not found: {file}"

## 7. Test Integrity Verification

### 7.1 Detection Method

**Find test-review approval:**
```bash
# Search for most recent test review approval
git log --all --grep="Approve tests:" --format="%H %s" | head -1
# Returns: <commit-hash> Approve tests: user-authentication
```

**Check for modifications:**
```bash
git diff <test-review-commit> HEAD -- tests/
```

**If diff output is non-empty:** Tests modified, trigger violation.

### 7.2 Violation Response

```typescript
{
  decision: "NEEDS-CHANGES",
  violations: [
    {
      type: "test_modification",
      file: "tests/unit/test_login.py",
      line: 45,
      description: "Test assertion weakened",
      evidence: "- assert result.status == 'active'\n+ assert result.status in ['active', 'pending']"
    }
  ],
  summary: "AUTOMATIC REJECTION: Test integrity violation. Tests modified after test-review approval. Revert changes and fix implementation instead."
}
```

### 7.3 Legitimate Test Changes

If tests need legitimate fixes:
1. Implementer files RFC requesting test review
2. Test reviewer re-reviews tests
3. If approved: New test-review commit created
4. Implementation review uses new baseline

## 8. Configuration

### 8.1 User Config: .workflow/config.json

```json
{
  "auto_review": {
    "enabled": true,
    "default_auto_move": false,
    "auto_move_overrides": {
      "spec": true,
      "implementation": true,
      "test": false
    },
    "review_model": "gpt-5-codex",
    "reasoning_effort": "high"
  }
}
```

### 8.2 MCP Config: ~/.config/claude-code/mcp.json

```json
{
  "mcpServers": {
    "workflow-reviewer": {
      "command": "node",
      "args": ["/path/to/mcp-servers/workflow-reviewer/build/index.js"],
      "env": {
        "OPENAI_API_KEY": "sk-proj-...",
        "WORKFLOW_ROOT": "/path/to/project"
      }
    }
  }
}
```

## 9. Error Handling

### 9.1 Codex API Failures

**Behavior:**
- Retry once (exponential backoff: 5s)
- If still fails: Return error, do NOT move artifact
- Save error details to `reviews/<type>/<timestamp>-ERROR.md`

**Example:**
```typescript
{
  error: "Codex API timeout after 300s",
  artifact_path: "specs/proposed/user-auth.md",
  action: "Review not completed. Artifact not moved. Retry manually or check API status."
}
```

### 9.2 Unparseable Reviews

**Behavior:**
- If review doesn't contain clear APPROVED/NEEDS-CHANGES decision
- Treat as NEEDS-CHANGES (conservative)
- Save review with WARNING marker
- User can read and manually approve if appropriate

### 9.3 Git Failures

**Behavior:**
- If `git mv` fails (file conflicts, etc.)
- Review still saved
- Return error: "Review saved but could not move artifact: {error}"
- User resolves git issue manually

## 10. Performance

### 10.1 Latency Targets

- Spec review: < 60 seconds (large context)
- Test review: < 45 seconds (medium context)
- Implementation review: < 50 seconds (medium context + test integrity check)

### 10.2 Cost Targets

- Spec review: ~$0.50 per review
- Test review: ~$0.30 per review
- Implementation review: ~$0.40 per review

**Total per feature:** ~$2.00 (6 reviews: spec, skeleton, test, implementation, + amortized planning reviews)

## 11. Security

### 11.1 API Key Management

- API key stored in MCP server env (not in project)
- Never logged or exposed in review documents
- Loaded from `~/.config/claude-code/mcp.json` env vars

### 11.2 File Access

- MCP server only reads from WORKFLOW_ROOT directory
- No writes outside WORKFLOW_ROOT
- Git operations limited to: `git mv`, `git add`, `git commit` (no force-push, no reset)

### 11.3 Prompt Injection

- Review requests use structured format (schema-review-request.md)
- Artifact content wrapped in code fences (prevents injection)
- Codex instructed to ignore requests in artifact content

## 12. Testing

### 12.1 Unit Tests

- `context-builder.test.ts` - Context gathering for each review type
- `review-formatter.test.ts` - Schema-compliant formatting
- `result-parser.test.ts` - Parse APPROVED/NEEDS-CHANGES
- `test-integrity.test.ts` - Detect test modifications
- `artifact-mover.test.ts` - Git operations

### 12.2 Integration Tests

- `spec-review-e2e.test.ts` - Full spec review flow
- `test-review-e2e.test.ts` - Full test review flow
- `impl-review-e2e.test.ts` - Full implementation review with integrity check
- `auto-move-e2e.test.ts` - Auto-move on approval

### 12.3 Manual Testing

- Create test project with VISION, SCOPE, ROADMAP
- Write spec, trigger review, verify quality
- Write tests, trigger review, verify coverage checks
- Write implementation, trigger review, verify test integrity
- Modify test, verify integrity violation detected

## 13. Documentation

- README.md - Setup, configuration, usage examples
- ARCHITECTURE.md - System design, data flow
- REVIEW_TYPES.md - Each review type's behavior, context requirements
- TROUBLESHOOTING.md - Common errors, debugging

## 14. Open Questions

1. **Should auto-move be default true or false?**
   - Pro default-true: Maximizes automation benefit
   - Pro default-false: User maintains control, learns workflow first

2. **Should we save review requests in addition to review responses?**
   - Pro: Audit trail, see exactly what was sent to Codex
   - Con: Extra files, duplicates some info in review

3. **Should violations (test modifications) be saved separately?**
   - Pro: Easy to search for "what got rejected and why"
   - Con: Extra complexity

4. **How to handle review version mismatch?**
   - If schema-review.md changes, old reviews may not match
   - Options: (a) Version reviews, (b) Re-review on schema change, (c) Ignore

## 15. Future Enhancements (Out of Scope for V1)

### Phase 4: Sophisticated Workaround Detection

Detect patterns identified in ImpossibleBench paper:

**Operator overloading:**
```python
# Detect: __eq__ that always returns True
class FakeResult:
    def __eq__(self, other):
        return True
```

**State recording:**
```python
# Detect: Global state used to change behavior per call
call_count = 0
def function():
    global call_count
    call_count += 1
    if call_count == 1: return "first"
    if call_count == 2: return "second"
```

**Special-casing:**
```python
# Detect: Hardcoded responses for test inputs
def function(input):
    if input == "test_value":
        return "hardcoded_output"
```

**Implementation:**
- AST parsing of implementation files
- Pattern matching for known workarounds
- Flag in review as violations

### Phase 5: Real-Time Test Review

**Tool:** `mcp__request_immediate_test_review`

**Purpose:** Implementer blocked by confusing test, needs quick answer

**Behavior:**
- Synchronous (blocks until answer)
- Lightweight review (< 30 seconds)
- Lower reasoning_effort for speed
- Focused question: "Is test correct or am I confused?"

**Use case:**
```bash
# Implementer stuck
mcp__request_immediate_test_review({
  test_file: "tests/unit/test_login.py",
  test_name: "test_login_invalid_email",
  conflict: "Test expects ValueError but spec says ValidationError"
})

# Fast response:
{
  answer: "TEST_HAS_BUG",
  fix: "Change to pytest.raises(ValidationError)",
  explanation: "Spec section 3.2 clearly states ValidationError"
}
```

---

## Appendix A: Review Request Template

**Example formatted review request sent to Codex:**

```markdown
# CODEX REVIEW REQUEST: Spec Review

## Your Role

You are a Spec Reviewer following the instructions in role-spec-reviewer.md (included below).

## Artifact Being Reviewed

**Type:** Specification
**Path:** specs/proposed/user-authentication.md
**Version:** Draft (proposed)

```markdown
[Full spec content here]
```

## Context: Related Documents

### ROADMAP.md - Feature Source

This spec implements Feature 3 from ROADMAP.md:

```markdown
[Relevant roadmap section]
```

### SCOPE.md - Project Scope

```markdown
[Relevant scope section]
```

## Review Criteria (schema-spec.md)

A good spec must have:

```markdown
[schema-spec.md content]
```

## Review Format (schema-review.md)

Your review must follow this format:

```markdown
[schema-review.md content]
```

## Reviewer Instructions (role-spec-reviewer.md)

```markdown
[role-spec-reviewer.md content]
```

## Your Task

Review the spec above against schema-spec.md criteria.
Return your review in schema-review.md format.
Make a clear decision: APPROVED or NEEDS-CHANGES.

Focus on:
1. **Testability** - Can tests be written from this spec?
2. **Completeness** - Are all acceptance criteria present?
3. **Clarity** - Are requirements unambiguous?
4. **Alignment** - Does this match the ROADMAP feature?
5. **Interface contracts** - Are inputs/outputs defined?

Provide specific feedback for any issues found.
```

---

## Appendix B: MCP Tool Signatures

```typescript
// Spec review
mcp__request_spec_review({
  spec_path: "specs/proposed/user-auth.md",
  auto_move_on_approval?: boolean
})

// Test review
mcp__request_test_review({
  test_files: ["tests/unit/test_auth.py"],
  spec_path: "specs/doing/user-auth.md",
  coverage_report?: "coverage.xml",
  auto_move_on_approval?: boolean
})

// Implementation review
mcp__request_implementation_review({
  implementation_files: ["src/auth.py"],
  test_results: "all passing",
  spec_path: "specs/doing/user-auth.md",
  auto_move_to_done?: boolean
})

// Skeleton review
mcp__request_skeleton_review({
  skeleton_files: ["src/auth.py"],
  spec_path: "specs/doing/user-auth.md",
  auto_move_on_approval?: boolean
})

// Vision/Scope/Roadmap reviews
mcp__request_vision_review({
  vision_path: "VISION.md"
})

mcp__request_scope_review({
  scope_path: "SCOPE.md",
  vision_path: "VISION.md"
})

mcp__request_roadmap_review({
  roadmap_path: "ROADMAP.md",
  scope_path: "SCOPE.md"
})

// Bug fix review
mcp__request_bugfix_review({
  bug_report_path: "bugs/fixing/BUG-123.md",
  fix_files: ["src/auth.py"],
  sentinel_test: "tests/regression/test_bug_123.py",
  auto_move_to_fixed?: boolean
})
```
