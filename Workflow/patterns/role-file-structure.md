# Role File Structure Pattern

**Use this pattern when:** Creating or modifying any role file in the workflow
**Skip this if:** You're using an existing role (structure already applied)

## Purpose of This Document

This document defines the common structure used across all role files in the workflow. Each role file should follow this consistent structure while focusing on role-specific process details, examples, and reminders.

---

## Standard Role File Structure

All role files follow this structure:

```markdown
---
role: [Role Name]
trigger: [When this role activates]
typical_scope: [What scope of work this role covers]
---

# [Role Name]

## Purpose
[Role-specific purpose - what this role produces/accomplishes]

## When to Use This Role
[Role-specific activation conditions]

## Collaboration Pattern
[Role-specific collaboration approach - independent, collaborative, etc.]

## Inputs
[What artifacts/information this role needs]

## Process
[Role-specific detailed process with steps]

## Outputs
[What this role creates]

## Examples
[Role-specific examples showing process in action]

## Common Pitfalls
[Role-specific things to avoid]

## Integration with Workflow
[See pattern: How role fits in workflow - keep brief with link]

## Critical Reminders
[Role-specific DO/DON'T lists - always keep these]
```

---

## Pattern: Integration with Workflow

All role files should include a brief integration section that shows how the role fits in the workflow without duplicating detailed workflow documentation.

### Structure

```markdown
## Integration with Workflow

This role fits in the workflow as follows:
- **Receives:** [Upstream artifacts]
- **Produces:** [Downstream artifacts]
- **Next roles:** [What roles follow this one]

For complete workflow context, see [workflow-overview.md](../workflow-overview.md).
```

### Purpose

- Shows immediate workflow neighbors (what comes before/after)
- Points to comprehensive workflow documentation
- Avoids duplicating workflow details in every role file

### Examples

#### Writer Role Integration

```markdown
## Integration with Workflow

This role fits in the workflow as follows:
- **Receives:** VISION.md
- **Produces:** SCOPE.md in main branch
- **Next roles:** Scope Reviewer → Roadmap Writer

For complete workflow context, see [workflow-overview.md](../workflow-overview.md).
```

#### Reviewer Role Integration

```markdown
## Integration with Workflow

This role fits in the workflow as follows:
- **Receives:** specs/proposed/<feature>.md
- **Produces:** Review in reviews/specs/, moves approved spec to specs/todo/
- **Next roles:** Skeleton Writer (if approved), Spec Writer (if needs changes)
- **Gatekeeper:** Controls spec transition from proposed → todo

For complete workflow context and state transitions, see [workflow-overview.md](../workflow-overview.md) and [state-transitions.md](../state-transitions.md).
```

#### Implementer Role Integration

```markdown
## Integration with Workflow

This role fits in the workflow as follows:
- **Receives:** Skeleton code, test suite, SPEC.md in specs/doing/
- **Produces:** Implementation on feature branch
- **Next roles:** Implementation Reviewer

For complete workflow context, see [workflow-overview.md](../workflow-overview.md).
```

### Notes

- Keep to 4-7 lines maximum
- Focus on immediate neighbors only
- Link to comprehensive workflow docs
- For gatekeepers, note the gatekeeper responsibility explicitly

---

## Pattern: Role-Specific Process

The "Process" section is the heart of each role file and should be:

### Characteristics

- **Detailed and specific** to the role's work
- **Step-by-step** with clear numbering
- **Actionable** - tells the agent exactly what to do
- **Complete** - covers the full process from start to finish

### Structure Options

**Option A: Numbered Steps (for sequential processes)**
```markdown
## Process

### Step 1: [First Action]
[Details about what to do]

### Step 2: [Second Action]
[Details about what to do]

### Step 3: [Final Action]
[Details about what to do]
```

**Option B: Checklist Format (for review processes)**
```markdown
## Process

### 1. Verify Structure
- [ ] Item 1
- [ ] Item 2
- [ ] Item 3

### 2. Check Content
- [ ] Item 1
- [ ] Item 2
```

**Option C: Question-Driven (for exploratory processes)**
```markdown
## Process

### 1. Understand Context
**Questions to explore:**
- Question 1?
- Question 2?

### 2. Analyze
**Questions to explore:**
- Question 1?
- Question 2?
```

### Notes

- Use the format that best fits the role's work style
- Make each step independently understandable
- Include examples within process steps when helpful
- Reference schemas/ontologies where applicable

---

## Pattern: Critical Reminders

Every role file ends with role-specific DO/DON'T lists.

### Structure

```markdown
## Critical Reminders

**DO:**
- [Role-specific best practice 1]
- [Role-specific best practice 2]
- [Role-specific best practice 3]
- [Reference important schemas/ontologies]
- [5-15 items typically]

**DON'T:**
- [Role-specific anti-pattern 1]
- [Role-specific anti-pattern 2]
- [Role-specific pitfall 3]
- [5-15 items typically]
```

### Purpose

These reminders are **role-specific** and should be preserved in each file. They capture:
- The most common mistakes for this role
- Critical success factors
- References to schemas/ontologies
- Quality standards
- Process requirements unique to this role

### Notes

- **Do NOT** consolidate these across roles
- Keep focused on role-specific concerns
- Make items concrete and actionable
- Order by importance or frequency

---

## Pattern: Examples Section

Most role files include examples showing the process in action.

### Structure

```markdown
## Examples

### Example 1: [Scenario Name]

[Narrative showing role's work in context]

**Input:**
[What the role received]

**Process highlights:**
[Key steps taken]

**Output:**
[What was produced]

### Example 2: [Alternative Scenario]

[Another example showing variation or edge case]
```

### Purpose

- Makes abstract process concrete
- Shows good and bad approaches
- Demonstrates decision-making
- Provides templates for common cases

### Types of Examples

**Writer roles:** Before/after examples showing transformation
**Reviewer roles:** Approved vs. needs-changes reviews
**Implementation roles:** Code structure or approach examples
**Helper roles:** Conversation excerpts (already in helper-role-pattern.md)

---

## Pattern: Common Pitfalls Section

Many role files include common mistakes to avoid.

### Structure

```markdown
## Common Pitfalls

### [Pitfall Name]

**Problem:** [What goes wrong]

**Example:** [Concrete instance]

**Solution:** [How to avoid it]

---

### [Another Pitfall]

**Problem:** [What goes wrong]

**Example:** [Concrete instance]

**Solution:** [How to avoid it]
```

### Purpose

- Captures lessons learned
- Prevents repeated mistakes
- Provides corrective guidance
- Makes quality expectations explicit

### Notes

- 3-7 pitfalls typically
- Focus on mistakes actually observed or likely
- Make examples concrete, not abstract
- Provide actionable solutions

---

## Usage Guidelines for Role Files

When creating or updating role files:

1. **Follow the standard structure** outlined above
2. **Keep role-specific content** detailed and complete:
   - Purpose section
   - Process section with all steps
   - Examples section
   - Common Pitfalls section
   - Critical Reminders (DO/DON'T)
3. **Simplify integration sections** to 4-7 lines + link
4. **Reference schemas** where applicable (schema-vision.md, schema-spec.md, etc.)
5. **Use consistent formatting** across all role files

### Before/After Example

**Before (verbose integration):**
```markdown
## Integration with Workflow

This role is part of the planning phase. It comes after Vision Writer creates
VISION.md and before Roadmap Writer sequences features. The Scope Reviewer
validates the scope document. If approved, Roadmap Writer uses SCOPE.md to
plan feature sequencing. If rejected, Scope Writer revises based on feedback.
The scope defines boundaries that all downstream roles (Roadmap Writer,
Spec Writer, implementation roles) must respect. Living docs (SYSTEM_MAP.md,
GUIDELINES.md) should also align with scope boundaries.
```

**After (concise with link):**
```markdown
## Integration with Workflow

This role fits in the workflow as follows:
- **Receives:** VISION.md
- **Produces:** SCOPE.md in main branch
- **Next roles:** Scope Reviewer → Roadmap Writer

For complete workflow context, see [workflow-overview.md](../workflow-overview.md).
```

---

## Variation by Role Type

Different role types emphasize different sections:

### Writer Roles
- Detailed "Process" section with step-by-step creation
- "Key Principles" subsections within process
- Multiple examples showing good vs. bad outputs
- "Maintaining as Living Document" section for planning docs

### Reviewer Roles
- Checklist-based "Process" section
- "Review Template" in Outputs section
- Examples of APPROVED vs. NEEDS-CHANGES reviews
- Emphasis on gatekeeper responsibilities

### Implementation Roles
- "Best Practices" section for code/test patterns
- Technical examples in "Examples" section
- Links to GUIDELINES.md and SYSTEM_MAP.md
- Tool/framework-specific guidance

### Helper Roles
- See [helper-role-pattern.md](helper-role-pattern.md) for full structure
- Conversation-focused process
- User adaptation strategies
- Transition to writer role

---

## Critical Reminders for Role Files

**DO:**
- Follow standard structure consistently
- Keep role-specific process details comprehensive
- Simplify integration sections to brief + link
- Preserve role-specific Critical Reminders
- Reference schemas where applicable
- Include concrete examples
- Update role files when process improves

**DON'T:**
- Duplicate workflow documentation in every file
- Remove role-specific DO/DON'T lists
- Make integration sections verbose
- Omit examples that clarify process
- Skip references to schemas/ontologies
- Let role files drift from actual practice

---

## Document Relationships

This pattern document relates to:
- **[helper-role-pattern.md](helper-role-pattern.md)** - Pattern for helper roles specifically
- **[workflow-overview.md](../workflow-overview.md)** - High-level workflow reference
- **[state-transitions.md](../state-transitions.md)** - State machine and git commands
- **Schema files** (schema-*.md) - Document structure specifications

All role files should link to these documents rather than duplicating their content.
