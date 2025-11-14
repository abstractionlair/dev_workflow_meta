# Guidelines - Development Workflow Meta-Project

## Purpose

This document contains coding and documentation patterns for the **meta-project** itself - conventions for creating and maintaining the workflow system.

For guidelines about how concrete projects should be structured, see the schemas in [Workflow/](Workflow/).

## Critical Distinction

**Meta-project guidelines** (this file): How to maintain the workflow system
**Concrete project GUIDELINES.md**: Coding patterns for the software being built

Never confuse these levels. This file guides meta-project contributors.

---

## Documentation Patterns

### ✅ Pattern: Creating Role Files

**Use case**: Adding a new role to the workflow system

**Location**: `Workflow/role-[name].md`

**Required structure**:
1. Follow [patterns/role-file-structure.md](Workflow/patterns/role-file-structure.md) template
2. Include frontmatter with role/trigger/typical_scope
3. Include all standard sections (Purpose, Process, Examples, Integration, Critical Reminders)
4. Keep Integration section brief (4-7 lines + link to workflow-overview.md)
5. Make Process section detailed and role-specific

**For helper roles**: Also follow [patterns/helper-role-pattern.md](Workflow/patterns/helper-role-pattern.md)

**Example structure**:
```markdown
---
role: Feature Analyzer
trigger: When analysis of existing features is needed
typical_scope: Single feature or module analysis
---

# Feature Analyzer

## Purpose
[Role-specific purpose]

## Process
[Detailed, role-specific steps]

## Examples
[Role-specific examples]

## Integration with Workflow
This role fits in the workflow as follows:
- **Receives:** [upstream artifacts]
- **Produces:** [downstream artifacts]
- **Next roles:** [what follows]

For complete workflow context, see [workflow-overview.md](workflow-overview.md).

## Critical Reminders
[Role-specific DO/DON'T lists]
```

**Why this pattern?**
- Consistency across 22+ role files
- Prevents duplication of workflow details
- Makes role files scannable and maintainable
- Centralizes common boilerplate in patterns/

**Related**:
- Pattern template: [Workflow/patterns/role-file-structure.md](Workflow/patterns/role-file-structure.md)
- All role files: `Workflow/role-*.md`

---

### ✅ Pattern: Creating Schema Files

**Use case**: Defining structure for a new artifact type

**Location**: `Workflow/schema-[artifact-type].md`

**Required structure**:
1. Purpose and overview
2. Required sections/fields
3. Formatting guidelines
4. Complete examples (good and bad)
5. Anti-patterns section
6. Cross-reference to LayoutAndState.md for directory structure

**Template**:
```markdown
# Schema: [Artifact Type]

## Purpose
[What this artifact accomplishes]

## Structure
[Required sections with descriptions]

## Formatting Guidelines
[How to format content]

## Examples
### Good Example
[Complete, realistic example]

### What Not to Do
[Anti-patterns with explanations]

## Directory Structure
See [LayoutAndState.md](LayoutAndState.md) for where these files live.

## Integration
[How this artifact relates to workflow]
```

**Why this pattern?**
- Comprehensive guidance for writers (1,000+ lines per schema)
- Concrete examples prevent ambiguity
- Anti-patterns teach from mistakes
- Single source of truth for structure

**Common schema size**: 1,000-1,600 lines for comprehensive schemas

**Related**:
- Directory structure: [Workflow/LayoutAndState.md](Workflow/LayoutAndState.md)
- All schemas: `Workflow/schema-*.md`

---

### ✅ Pattern: Cross-Referencing (Not Duplicating)

**Use case**: Referencing information that exists elsewhere

**Approach**: Link to canonical source, don't copy content

**Examples**:

**DO** (link to source):
```markdown
## State Transitions

This role moves specs from `proposed/` to `todo/` on approval.

For complete state transition rules and git commands, see
[state-transitions.md](state-transitions.md).
```

**DON'T** (duplicate):
```markdown
## State Transitions

This role moves specs from `proposed/` to `todo/` on approval.

To move a spec:
1. git add specs/proposed/feature.md
2. git mv specs/proposed/feature.md specs/todo/
3. git commit -m "Approve spec: feature"

[30 more lines of git commands duplicated from state-transitions.md]
```

**Why?**
- Changes in one place, not N places
- Prevents drift and inconsistency
- Keeps role files focused on role-specific content
- Reduced redundancy (~650-700 lines eliminated in Phase 3 optimization)

**Canonical sources**:
- State transitions: [Workflow/state-transitions.md](Workflow/state-transitions.md)
- Workflow overview: [Workflow/workflow-overview.md](Workflow/workflow-overview.md)
- Directory structure: [Workflow/LayoutAndState.md](Workflow/LayoutAndState.md)

---

### ✅ Pattern: Pattern Extraction

**Use case**: Same boilerplate appears in 3+ files

**Approach**: Extract to patterns/ directory, reference from individual files

**Process**:
1. Identify common boilerplate (appears in 3+ files with minimal variation)
2. Create `Workflow/patterns/[name]-pattern.md` with:
   - Purpose statement
   - Template/structure
   - Usage guidelines
   - Examples
3. Update original files to reference pattern instead of duplicating
4. Keep role-specific content in role files

**Example (helper roles)**:
- **Before**: 4 helper role files × ~400 lines common boilerplate = 1,600 lines
- **After**: 1 pattern file (441 lines) + 4 files with references = ~650 line reduction

**Why?**
- Maintain consistency automatically
- Update pattern once, all files benefit
- Focus role files on role-specific content
- Explicit about what's shared vs. unique

**Existing patterns**:
- [Workflow/patterns/helper-role-pattern.md](Workflow/patterns/helper-role-pattern.md)
- [Workflow/patterns/role-file-structure.md](Workflow/patterns/role-file-structure.md)

---

### ✅ Pattern: Documentation Hierarchies

**Use case**: Multiple docs covering related topics at different levels

**Approach**: Establish clear hierarchy with bidirectional links

**Structure**:
```
High-level overview (workflow-overview.md)
    ↓
Detailed specification (state-transitions.md)
    ↓
Role-specific application (role-spec-reviewer.md)
```

**Linking pattern**:
- Overview → "For details, see [detailed doc]"
- Detailed doc → "Part of [overview]" (in header)
- Role file → "For complete context, see [overview]"

**Example**:
- workflow-overview.md: "For detailed state transitions, see state-transitions.md"
- state-transitions.md: "Part of workflow overview in workflow-overview.md"
- role-spec-reviewer.md: "For complete workflow context, see workflow-overview.md"

**Why?**
- Clear navigation path
- Each document has clear scope
- No orphaned documents
- Prevents circular duplication

---

## Documentation Rules

### ❌ Rule: Don't Duplicate Workflow Details in Role Files

**Constraint**: Role files MUST NOT replicate state transitions, workflow sequences, or directory structures

**Rationale**:
- Workflow details change, role responsibilities don't
- N role files × duplicated details = maintenance nightmare
- Created 650-700 lines of redundancy before cleanup

**Correct approach**:
```markdown
## Integration with Workflow
This role fits in the workflow as follows:
- **Receives:** specs/proposed/<feature>.md
- **Produces:** Review in reviews/specs/, moves to specs/todo/

For complete workflow context, see [workflow-overview.md](workflow-overview.md).
```

**Violation (don't do this)**:
```markdown
## Integration with Workflow
This role is part of the contract layer. It comes after Spec Writer
creates the spec and before Skeleton Writer creates interfaces. The
workflow sequence is: Vision Writer → Scope Writer → Roadmap Writer →
Spec Writer → Spec Reviewer → Skeleton Writer → ... [repeating the
entire workflow]
```

**Enforcement**: Code review, pattern compliance check

---

### ❌ Rule: Don't Create Role-Specific State Transition Logic

**Constraint**: State transitions defined ONLY in state-transitions.md

**Rationale**:
- Single source of truth for state machine
- Git commands must be consistent
- Prevents roles from inventing their own rules

**Correct approach**:
- state-transitions.md defines: WHO moves, WHEN, git commands, preconditions
- Role files reference: "See state-transitions.md for git commands"
- Scripts implement: workflow-status.sh understands state rules

**Violation (don't do this)**:
```markdown
## Moving Specs [in role-spec-reviewer.md]

When approving a spec:
git mv specs/proposed/feature.md specs/todo/

[This belongs in state-transitions.md, not here]
```

**Exception**: None. Always reference state-transitions.md.

---

### ❌ Rule: Don't Modify Workflow/ in Concrete Projects

**Constraint**: Concrete projects copy Workflow/ as read-only reference

**Rationale**:
- Workflow maintained in meta-project only
- Concrete projects get updates by re-copying
- Prevents divergence and fragmentation

**Correct approach**:
```bash
# In concrete project
cp -r /path/to/dev_workflow_meta/Workflow ./Workflow/
# Treat as reference documentation (read-only)
```

**Violation (don't do this)**:
```bash
# In concrete project
cp -r /path/to/dev_workflow_meta/Workflow ./Workflow/
cd Workflow/
# Editing role files to add project-specific details ❌
```

**Where to put project-specific content**:
- SYSTEM_MAP.md (in concrete project root, not Workflow/)
- GUIDELINES.md (in concrete project root, not Workflow/)
- Project-specific CONTRIBUTING.md

**Documented in**: [Workflow/ConcreteProjectSetup.md](Workflow/ConcreteProjectSetup.md)

---

### ❌ Rule: Never Use Placeholders in Role Integration Sections

**Constraint**: Integration sections must have concrete links, not "See workflow docs"

**Rationale**:
- "See workflow docs" is too vague
- Links enable quick navigation
- Specific references clarify which doc has the answer

**Correct approach**:
```markdown
## Integration with Workflow
For complete workflow context, see [workflow-overview.md](workflow-overview.md).
For state transition details, see [state-transitions.md](state-transitions.md).
```

**Violation (don't do this)**:
```markdown
## Integration with Workflow
See workflow documentation for how this role fits in.
```

---

## Naming Conventions

### File Naming

| Type | Pattern | Examples |
|------|---------|----------|
| Role files | `role-[role-name].md` | role-spec-writer.md, role-implementation-reviewer.md |
| Schema files | `schema-[artifact-type].md` | schema-spec.md, schema-review.md |
| Pattern files | `[topic]-pattern.md` | helper-role-pattern.md, role-file-structure.md |
| Core docs | `[CamelCase].md` | LayoutAndState.md, ConcreteProjectSetup.md |
| Overview docs | `[kebab-case].md` | workflow-overview.md, state-transitions.md |
| Entry points | `[UPPERCASE].md` | CLAUDE.md, CONTRIBUTING.md, README.md |

**Why these conventions?**
- `role-*` prefix makes roles greppable: `ls role-*.md`
- `schema-*` prefix groups schemas together
- CamelCase for established docs (less likely to conflict with shell)
- kebab-case for new technical docs (modern convention)
- UPPERCASE for entry points (high visibility)

---

### Role Naming

| Pattern | When to Use | Examples |
|---------|-------------|----------|
| [Noun]-writer | Creates artifacts | vision-writer, spec-writer, test-writer |
| [Noun]-reviewer | Reviews artifacts (gatekeeper) | spec-reviewer, implementation-reviewer |
| [Noun]-writing-helper | Guides creation through dialogue | scope-writing-helper, roadmap-writing-helper |
| [Role] | Implementation/support | implementer, platform-lead, bug-recorder |

**Why?**
- Consistent suffixes clarify role type
- -writer/-reviewer pairs obvious
- -helper suffix distinguishes dialogue roles

---

## Blessed Utilities

### ✅ Utility: scripts/run-role.sh

**Location**: `Workflow/scripts/run-role.sh`

**Purpose**: Launch any role with proper initialization

**Usage**:
```bash
# Interactive mode (stays in conversation)
./Workflow/scripts/run-role.sh -i scope-writer

# One-shot mode (single execution)
./Workflow/scripts/run-role.sh spec-reviewer
```

**Why use this?**
- Automatic tool selection (reads role-config.json)
- Proper CLI argument handling per tool
- Loads correct entry point file
- Appends role file to system prompt
- No manual copy-paste of role content

**Configuration**:
- Role mappings: `Workflow/scripts/role-config.json`
- Tool CLI args: `Workflow/scripts/tool-config.json`

**Supports**: Claude, Codex, Gemini, OpenCode

**Documented in**: [Workflow/scripts/README.md](Workflow/scripts/README.md)

---

### ✅ Utility: scripts/workflow-status.sh

**Location**: `Workflow/scripts/workflow-status.sh`

**Purpose**: Scan project state and suggest next actions

**Usage**:
```bash
# Quick status check
./Workflow/scripts/workflow-status.sh

# Detailed output with suggestions
./Workflow/scripts/workflow-status.sh --verbose
```

**What it detects**:
- Planning docs (VISION.md, SCOPE.md, ROADMAP.md)
- Spec states (proposed, todo, doing, done)
- Bug states (to_fix, fixing, fixed)
- Implementation progress (skeleton code, tests, implementation)
- Review status

**Output**:
- Color-coded status indicators (✓ ✗ ⊙ →)
- Prioritized action suggestions
- Exact commands to run next

**Why use this?**
- Know "what's next?" without memorizing workflow
- Catch forgotten reviews or incomplete implementations
- Verify state before moving forward

**Documented in**: [Workflow/scripts/README.md](Workflow/scripts/README.md)

---

## Documentation Style

### Code Examples

**Use fenced code blocks with language**:
```markdown
\`\`\`bash
git mv specs/proposed/feature.md specs/todo/
\`\`\`
```

**Not**:
```
git mv specs/proposed/feature.md specs/todo/
```

**Why?**
- Syntax highlighting
- Clear boundaries
- Easier to copy-paste

---

### Section Markers

**Use consistent markers for patterns and rules**:
- ✅ for DO patterns
- ❌ for DON'T rules

**Example**:
```markdown
### ✅ Pattern: Cross-Referencing
[Content about what TO do]

### ❌ Rule: Don't Duplicate State Transitions
[Content about what NOT to do]
```

**Why?**
- Visual scanning
- Clear distinction between positive/negative guidance
- Searchable with grep

---

### File Sizes

**Target sizes for comprehensive docs**:
- Schema files: 1,000-1,600 lines (comprehensive guidance)
- Role files: 300-600 lines (detailed process)
- Pattern files: 400-500 lines (reusable templates)
- Core docs: Variable (as needed for topic)

**These are observations, not strict limits**

**Why document this?**
- Sets expectations for comprehensiveness
- Schemas with <500 lines probably incomplete
- Schemas with >2,000 lines might need splitting

---

## Maintenance Patterns

### ✅ Pattern: Updating Schemas

**When to update**:
- New section type discovered
- Better example created
- Anti-pattern identified
- Concrete project provides feedback

**Process**:
1. Update schema file
2. Check if RoleCatalog.md references need updates
3. Check if related role files need updates
4. Update SYSTEM_MAP.md if structure changed
5. Document in commit message

**Example commit**:
```
Update schema-spec.md with integration testing section

Added Integration Testing subsection to Testing Strategy with
examples of API contract tests and service boundary tests.

Based on feedback from concrete project X where integration
test requirements were unclear.
```

---

### ✅ Pattern: Adding New Roles

**When to add**:
- New workflow stage needed
- Existing role responsibilities too broad
- New specialization emerges

**Process**:
1. Create `Workflow/role-[name].md` following patterns/role-file-structure.md
2. Add entry to Workflow/RoleCatalog.md
3. Add to scripts/role-config.json if automation needed
4. Update workflow-overview.md if workflow sequence changes
5. Update SYSTEM_MAP.md Role Definitions section
6. Document rationale in commit message

**Checklist**:
- [ ] role-[name].md created with all standard sections
- [ ] RoleCatalog.md updated
- [ ] role-config.json updated (if needed)
- [ ] workflow-overview.md updated (if workflow changed)
- [ ] SYSTEM_MAP.md updated
- [ ] Integration section links to workflow-overview.md
- [ ] Process section is detailed and role-specific
- [ ] Examples section has concrete scenarios

---

### ✅ Pattern: Extracting New Patterns

**When to extract**:
- Same boilerplate in 3+ files
- 100+ lines of duplicated content
- Common structure across similar files

**Process**:
1. Identify common content across files
2. Create `Workflow/patterns/[name]-pattern.md`
3. Include: purpose, template, usage guidelines, examples
4. Update original files to reference pattern
5. Verify consistency across all files
6. Update SYSTEM_MAP.md Patterns section
7. Document reduction in commit message

**Example commit**:
```
Extract reviewer-pattern.md from reviewer role files

Created patterns/reviewer-pattern.md with common structure for
all reviewer roles (checklist format, review template, gatekeeper
responsibilities).

Updated 7 reviewer role files to reference pattern.

Reduced ~300 lines of redundancy across reviewer roles.
```

---

## Version Control

### Commit Message Format

**For meta-project changes**:
```
<type>: <subject>

<body explaining what and why>

<impact if significant>
```

**Types**:
- `feat`: New role, schema, pattern, or script
- `refactor`: Reorganization, pattern extraction
- `docs`: Documentation improvements
- `fix`: Corrections to existing content

**Examples**:
```
feat: Add skeleton-reviewer role

Added role-skeleton-reviewer.md to validate interface skeletons
before test writing. Prevents test writers from working with
incomplete or incorrect interface definitions.

Added to RoleCatalog.md and role-config.json.
```

```
refactor: Extract role-file-structure pattern

Created patterns/role-file-structure.md and updated all 22 role
files to reference it instead of duplicating integration sections.

Reduced ~400 lines of redundancy. Integration sections now 4-7
lines + link instead of 15-30 lines each.
```

---

## Testing Changes

**Before committing role file changes**:
1. Verify all links work (no broken references)
2. Check pattern compliance (follows role-file-structure.md?)
3. Verify consistent formatting (markdown linting)
4. Test with run-role.sh if automation affected

**Before committing schema changes**:
1. Verify complete example present
2. Check anti-patterns section exists
3. Verify cross-reference to LayoutAndState.md

**Before committing script changes**:
1. Test with all supported tools (Claude, Codex, Gemini, OpenCode)
2. Verify config files still valid JSON
3. Test both interactive and one-shot modes
4. Update scripts/README.md if usage changed

---

## Common Pitfalls

### Over-Abstracting Too Early

**Problem**: Creating patterns before duplication actually exists

**Example**: Creating "writer-pattern.md" when only 2 writer roles exist

**Solution**: Wait until 3+ files share content (Rule of Three). Extract when duplication is proven problem, not anticipated.

---

### Under-Explaining Rationale

**Problem**: Documenting rules without explaining why

**Example**: "Don't duplicate workflow details" with no explanation

**Solution**: Every pattern/rule needs "Why?" section. Rationale more valuable than the rule itself.

---

### Circular References

**Problem**: Doc A references Doc B, Doc B references Doc A with no clear hierarchy

**Example**: workflow-overview.md says "see state-transitions.md", state-transitions.md says "see workflow-overview.md" for same information

**Solution**: Establish clear hierarchy. Overview links to details. Details link back to overview only in header context, not circularly.

---

### Forgetting SYSTEM_MAP.md Updates

**Problem**: Adding files/directories without updating SYSTEM_MAP.md

**Example**: Creating patterns/ directory but not documenting it in SYSTEM_MAP.md

**Solution**: SYSTEM_MAP.md update part of process for any structural change. Add to checklist.

---

### Version Drift

**Problem**: Meta-project updated but concrete projects use old Workflow/

**Example**: state-transitions.md improved but concrete projects have stale copy

**Solution**: Document update process in ConcreteProjectSetup.md. Consider version numbers or update checklist. No perfect solution - trade-off of copy approach.

---

## Meta-Guidelines

**These guidelines apply to this file itself:**

### Keep Examples Concrete
- Show actual file paths, not [placeholders]
- Use real role names, not [role-name]
- Include realistic commit messages

### Update When Patterns Change
- When new pattern extracted, add to Blessed Utilities
- When new rule discovered, add to Documentation Rules
- Keep synchronized with actual practice

### Link to Sources
- Every pattern references example files
- Every rule shows where it's enforced
- All utilities link to scripts/README.md

### Maintain Structure
- Patterns (✅) before Rules (❌)
- General before specific
- Theory before practice

---

## Related Documentation

- **SYSTEM_MAP.md** - Where files live and how they relate
- **Workflow/** - The workflow system this file helps maintain
- **patterns/** - Reusable templates referenced by these guidelines
- **scripts/README.md** - Detailed automation tool documentation
- **todo.md** - Meta-project task tracking and history

---

## Updating These Guidelines

When meta-project conventions evolve:

1. **Patterns emerge** → Add to Documentation Patterns
2. **Mistakes repeated** → Add to Documentation Rules
3. **Utilities created** → Add to Blessed Utilities
4. **Conventions solidify** → Add to Naming Conventions or Documentation Style

These guidelines should reflect actual practice, not aspirational ideals.

Platform Lead role maintains this file as meta-project evolves.
