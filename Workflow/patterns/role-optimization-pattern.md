# Role File Optimization Pattern

## Purpose

This document provides validated principles for optimizing role files to be lean, complete, and AI-optimized while preserving all essential procedural knowledge.

## Context: skill-creator Influence

This optimization approach was informed by Anthropic's `skill-creator` skill, which provides guidance for creating AI-optimized documentation. Key principles borrowed:

- **Progressive disclosure**: Lean core documentation with detailed references separate
- **Avoid duplication**: Information lives in one place
- **Essential procedural knowledge**: Focus on what agents need to know
- **<5k words target**: Keep core documentation lean without sacrificing completeness

However, our role files differ from Claude Skills in important ways:
- **Multi-model usage**: Claude, Codex, Gemini (not just Claude)
- **Workflow system**: Roles interact within larger workflow, need explicit collaboration context
- **Living documents**: Updated as workflow evolves, not packaged artifacts

We adapted skill-creator principles for our specific context rather than directly applying them.

## Discovery Process

To validate optimization principles, we:

1. Created an OPTIMIZED version of role-spec-reviewer.md applying compression
2. Conducted unbiased comparison (fresh conversation, minimal system prompt)
3. Loaded skill-creator into unbiased instance for re-evaluation
4. Synthesized IDEAL version combining best of both

**Key findings**:
- AI agents don't get fatigued by length - clarity and completeness matter more
- Collaboration Pattern sections are essential procedural knowledge (not redundant)
- Consolidating duplicate guidance reduces verbosity without information loss
- Layered guidance (aspirational + boundaries) can be flattened when truly duplicative
- Examples are the most valuable learning signal - preserve fully
- 23% reduction achieved while improving clarity

## Validated Principles

### 1. Preserve Essential Procedural Context

**What**: Keep Collaboration Pattern sections that explain role independence, feedback flows, and workflow position.

**Why**: AI agents need explicit context about their role in the system. Metadata alone doesn't replace prose explanation.

**Example (spec-reviewer)**:
```markdown
## Collaboration Pattern

This is an **independent role** - the reviewer works separately from the spec writer.

**Feedback flow:**
1. Spec Writer creates draft in `specs/proposed/<feature>.md`
2. Reviewer reads independently, creates timestamped review
3. If APPROVED: move to `specs/todo/`
4. If NEEDS-CHANGES: return feedback
5. Spec Writer addresses feedback, repeat from step 2
```

**Don't remove**: Sections explaining role type (independent vs collaborative), multi-step workflows, boundaries between roles.

---

### 2. Consolidate Duplicate Guidance

**What**: Merge sections that contain overlapping guidance (e.g., "Best Practices" + "Critical Reminders").

**Why**: Follows "information lives in one place" principle. Reduces verbosity without losing content.

**Example**:
- **Before**: "Best Practices" had "Verify examples work", "Critical Reminders" had "Verify examples are concrete"
- **After**: Single "Critical Reminders" with "Verify examples actually work and are concrete"

**Keep**: Mirror statements (positive + negative framing) are beneficial for boundary reinforcement:
- DO: "Provide specific, actionable feedback"
- DON'T: "Provide feedback without concrete next steps"

These aren't duplicates - they reinforce boundaries from both directions.

---

### 3. Use Better Terminology

**What**: Choose neutral, action-oriented language over judgmental or vague terms.

**Examples**:
- ✅ "Common Issues" → ❌ "Common Pitfalls"
- ✅ "Gatekeeper Actions" → ❌ "Gatekeeper Movement"
- ✅ "When to Adjust Rigor" → ❌ "When to Deviate"

**Why**: More professional, focuses on solutions over problems.

---

### 4. Enhanced Frontmatter

**What**: Add machine-readable metadata to enable automation and multi-role coordination.

**Add**:
```yaml
---
role: [Role Name]
trigger: [When to activate - concise]
typical_scope: [Work unit]
dependencies: [List of required artifacts/docs]
outputs: [What this role creates]
gatekeeper: [true/false - controls state transitions?]
state_transition: [If gatekeeper: state1 → state2]
---
```

**Why**: Enables scripts like workflow-status.sh to understand role relationships and suggest next actions.

---

### 5. Imperative Form

**What**: Use verb-first instructions, not second person ("you should...").

**Examples**:
- ✅ "Evaluate SPEC.md files for clarity..."
- ❌ "Your job is to evaluate SPEC.md files..."
- ✅ "Create review in reviews/specs/"
- ❌ "You should create a review in reviews/specs/"

**Why**: More direct, AI-optimal, consistent with skill-creator guidance.

---

### 6. Aggressive Reference for Structure Details

**What**: Link to schemas for detailed structural requirements rather than inlining long checklists.

**Example**:
- **Before** (17 lines):
```markdown
**Verify all mandatory sections present:**
- [ ] Feature Overview
- [ ] Interface Contract
- [ ] Behavior Specification
- [ ] Dependencies
- [ ] Testing Strategy
- [ ] Success Criteria
- [ ] Implementation Notes
```

- **After** (2 lines):
```markdown
Check against [schema-spec.md](schema-spec.md) for required sections. All mandatory sections must be present.
```

**Why**: Avoids duplication between role files and schemas. AI agents will follow links when needed.

**Keep inline**: Short checklists (3-6 items) that are workflow-specific rather than structure-specific.

---

### 7. Keep All Examples

**What**: Preserve complete concrete examples - both positive and negative cases.

**Why**: Examples are the most valuable learning signal for AI agents. They show pattern application, not just rules.

**In spec-reviewer**: Both APPROVED and NEEDS-CHANGES examples preserved fully (~60 lines each).

**Don't compress**: Examples should be realistic and complete, showing actual review output format.

---

### 8. Target Lean but Complete

**What**: Remove duplication and verbosity, but preserve all essential procedural knowledge.

**Not**: Arbitrary word count targets or percentage reductions.

**Result**: spec-reviewer achieved 23% reduction (286 → 220 lines) while improving clarity.

**Balance**:
- ✅ Remove redundant explanations
- ✅ Consolidate overlapping sections
- ✅ Improve terminology
- ❌ Remove essential context
- ❌ Remove examples
- ❌ Remove procedural workflows

---

## Role Groups for Application

### Group A: Reviewers (7 files)

Most similar to validated spec-reviewer example:

1. role-vision-reviewer.md
2. role-scope-reviewer.md
3. role-roadmap-reviewer.md
4. role-spec-reviewer.md (template: use IDEAL version)
5. role-skeleton-reviewer.md
6. role-test-reviewer.md
7. role-implementation-reviewer.md

**Common characteristics**:
- Independent role (works separately from writer)
- Gatekeeper responsibilities
- Creates timestamped reviews
- Approves or requests changes

**Optimization focus**:
- Preserve Collaboration Pattern (independent + feedback flow)
- Consolidate Best Practices + Critical Reminders
- Add gatekeeper: true to frontmatter

---

### Group B: Writers (6 files)

1. role-vision-writer.md
2. role-scope-writer.md
3. role-roadmap-writer.md
4. role-spec-writer.md
5. role-skeleton-writer.md
6. role-test-writer.md

**Common characteristics**:
- Create artifacts from upstream inputs
- May be collaborative or independent
- Follow schemas for structure
- Iterative refinement based on reviews

**Optimization focus**:
- Collaboration Pattern may differ from reviewers
- Heavy schema references appropriate
- Process sections likely detailed - preserve

---

### Group C: Helpers (4 files)

1. role-vision-writing-helper.md
2. role-scope-writing-helper.md
3. role-roadmap-writing-helper.md
4. role-spec-writing-helper.md

**Common characteristics**:
- Already reference helper-role-pattern.md
- Socratic dialogue approach
- Transition to writer roles
- User adaptation strategies

**Optimization focus**:
- Verify no conflict with helper-role-pattern.md
- Conversation examples are critical - preserve fully
- May already be well-optimized

---

### Group D: Implementation (3 files)

1. role-implementer.md
2. role-platform-lead.md
3. role-bug-recorder.md

**Common characteristics**:
- Unique workflows (not simple writer/reviewer pattern)
- Technical execution focus
- Complex state management

**Optimization focus**:
- Adapt principles carefully to unique contexts
- Implementation examples critical
- Platform-lead may have living doc guidance

---

## Application Process

For each role file:

### Step 1: Read and Analyze
- Identify Collaboration Pattern section (or equivalent context)
- Find Best Practices + Critical Reminders sections
- Check for duplication between guidance sections
- Note long inline checklists that could reference schemas

### Step 2: Apply Principles
1. **Enhanced frontmatter**: Add dependencies, outputs, gatekeeper flag
2. **Imperative form**: Convert "Your job..." → "Verb first..."
3. **Preserve context**: Keep Collaboration Pattern intact
4. **Consolidate guidance**: Merge Best Practices → Critical Reminders if duplicate
5. **Aggressive reference**: Link to schemas for structure details
6. **Better terminology**: "Issues" not "Pitfalls", "Actions" not "Movement"
7. **Keep examples**: Preserve all examples fully
8. **Review**: Ensure no essential procedural knowledge lost

### Step 3: Verify
- Collaboration Pattern present and clear?
- All examples intact?
- Essential procedural workflows preserved?
- Frontmatter complete?
- No information loss, only duplication removal?

### Step 4: Measure
- Line count before/after
- Verify ~20-30% reduction typical
- If >40% reduction, review for lost content
- If <10% reduction, likely already optimized

---

## Expected Results

Based on spec-reviewer validation:

**Metrics**:
- **Reduction**: 20-30% typical (286 → 220 lines for spec-reviewer)
- **Character reduction**: 30-40% typical
- **Information loss**: Zero (all essential knowledge preserved)

**Improvements**:
- Clearer structure (no duplicate guidance)
- Better terminology (action-oriented)
- Enhanced automation (richer frontmatter)
- Easier maintenance (references vs duplication)

**Not a goal**: Maximum compression - completeness and clarity over brevity.

---

## When to Use This Pattern

**Apply when**:
- Creating new role files
- Updating existing role files
- Role file exceeds ~400 lines
- Duplicate guidance identified between sections
- Inline checklists replicate schema content

**Consider not applying**:
- Role already well-optimized (<250 lines, no duplication)
- Role is in patterns/ (different optimization criteria)
- Unique role structure doesn't fit standard patterns

---

## Integration with Other Patterns

This pattern works alongside:
- **[role-file-structure.md](role-file-structure.md)**: Standard structure for all roles
- **[helper-role-pattern.md](helper-role-pattern.md)**: Pattern for helper roles specifically

**Relationship**:
- role-file-structure.md defines WHAT sections exist
- role-optimization-pattern.md defines HOW to make those sections lean
- helper-role-pattern.md provides content for helper-specific sections

---

## Reference: spec-reviewer Transformation

Validated example showing principles in action:

**Original**: 286 lines, 11,484 characters
**IDEAL**: 220 lines, 7,485 characters
**Reduction**: 23% lines, 35% characters

**Key changes**:
- ✅ Added enhanced frontmatter (7 fields)
- ✅ Kept Collaboration Pattern (17 lines, essential)
- ✅ Consolidated Best Practices + Critical Reminders (removed ~15 lines duplication)
- ✅ Improved terminology (3 changes)
- ✅ Aggressive schema reference (removed ~15 lines inline checklist)
- ✅ Preserved both examples fully (~120 lines)
- ✅ Imperative form throughout (~20 instances changed)

**Information loss**: Zero
**Clarity improvement**: Validated by unbiased review

See role-spec-reviewer-IDEAL.md for complete example.

---

## Maintenance

Update this pattern when:
- New optimization principles discovered
- Validation shows principles need adjustment
- Role file structure patterns change
- New role types emerge

This pattern should evolve with the workflow system.
