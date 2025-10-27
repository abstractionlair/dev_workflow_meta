# Documentation Linking Strategy

**Use this pattern when:** Creating or updating documentation cross-references to ensure clear triggers
**Skip this if:** You're following an existing, well-triggered link (pattern already applied)

## Purpose

This pattern defines when and how to create links between documentation files. The core principle: **Links must have clear triggers** - readers (human or AI) must know exactly when to follow a link without ambiguity.

## The Trigger Problem

**Problem:** Links without clear triggers create cognitive overhead and risk:
- Reader uncertain whether to follow link now or later
- Reader uncertain if link contains essential vs. supplementary information
- Reader may skip critical content or get lost in tangents

**Solution:** Every link must answer: "Under what circumstance should I follow this link?"

---

## Successful Trigger Patterns

### 1. Need-Based Triggers

**Pattern:** Reader has specific need that linked document fulfills.

**Examples:**
```markdown
✅ For complete directory structure, see [LayoutAndState.md]
✅ For validation rules, see [schema-X.md]
✅ Before requesting review, use [checklist-SPEC.md]
```

**Why it works:**
- Clear when link is needed: "I need directory structure" → follow link
- Reader can skip if need doesn't apply
- No ambiguity about link purpose

**Anti-pattern:**
```markdown
❌ See related documentation for more details
❌ Check other files for context
```
(What need? Which files? When?)

---

### 2. Authority-Based Triggers

**Pattern:** Linked document is the authoritative source for a topic.

**Examples:**
```markdown
✅ Follows [schema-spec.md] structure exactly
✅ All specs must comply with [schema-spec.md]
✅ State transitions defined in [state-transitions.md]
```

**Why it works:**
- Clear that linked doc is canonical reference
- Reader knows to consult link when creating/validating artifact
- Establishes single source of truth

**Anti-pattern:**
```markdown
❌ Also see schema-spec.md
❌ Schema-spec.md has related info
```
(Is it required or optional? Canonical or supplementary?)

---

### 3. Scope-Expansion Triggers

**Pattern:** Current document provides overview, link provides comprehensive treatment.

**Examples:**
```markdown
✅ For complete schema relationships, see [schema-relationship-map.md]
✅ For all workflow state transitions, see [state-transitions.md]
✅ For detailed examples, see [WorkflowExample.md]
```

**Why it works:**
- Current context sufficient for basic understanding
- Link available when depth needed
- Clear boundary between overview and deep-dive

**Anti-pattern:**
```markdown
❌ See X for more
❌ Additional information available in Y
```
(How much more? Essential or optional?)

---

### 4. Action-Based Triggers

**Pattern:** Link needed for specific action or workflow step.

**Examples:**
```markdown
✅ When creating SPEC: Reference [schema-spec.md] section templates
✅ Before review: Verify against [checklist-SPEC.md]
✅ During implementation: Follow [GUIDELINES.md] patterns
```

**Why it works:**
- Clear workflow context for when link applies
- Triggered by specific action
- Reader knows exactly when to consult

**Anti-pattern:**
```markdown
❌ Link to schema-spec.md
❌ See checklist-SPEC.md
```
(When do I need this? Before, during, or after?)

---

### 5. Conditional Triggers

**Pattern:** Link applies only under specific conditions.

**Examples:**
```markdown
✅ If unfamiliar with helper patterns, see [helper-role-pattern.md] first
✅ If implementing bug fix, reference bug report in bugs/fixing/
✅ For first-time spec creation, study examples in [schema-spec.md] Section 7
```

**Why it works:**
- Reader self-selects based on condition
- Avoids forcing unnecessary reading
- Targets specific audience/situation

**Anti-pattern:**
```markdown
❌ New users should read X
❌ See Y for background
```
(Am I "new"? Do I need "background"?)

---

## Failed Trigger Patterns

### 1. Internal Forward-References

**Anti-pattern:**
```markdown
❌ See section below for details
❌ Explained in Section 5
```

**Why it fails:**
- Interrupts linear reading flow
- Creates anticipation without fulfillment
- Readers uncertain if they should skip ahead

**Better:**
```markdown
✅ [Include content inline - no forward reference needed]
```

Or if content is far away:
```markdown
✅ Detailed examples provided in Examples section (end of document)
```
(Sets expectation without requiring immediate jump)

---

### 2. Lateral Alternatives

**Anti-pattern:**
```markdown
❌ Quick Reference (20 lines) ... For detailed version, see below
❌ Summary version here, complete version in Section X
```

**Why it fails:**
- No clear decision point for which version to read
- Risk of duplication divergence
- Ambiguous: "Did summary answer my question or do I need detail?"

**Better:**
```markdown
✅ [Single version with progressive detail in linear flow]
```

Or:
```markdown
✅ Essential checklist below. For rationale and edge cases, see Section X.
```
(Clear: checklist for doing, section for understanding why)

---

### 3. Optional Enrichment

**Anti-pattern:**
```markdown
❌ See examples/ directory for more examples
❌ Additional patterns available in X
```

**Why it fails:**
- Ambiguous: Are inline examples sufficient?
- Reader uncertain when "more" is needed
- Risk: Skip link and miss essential patterns

**Better:**
```markdown
✅ Before writing first spec: Study complete examples in [schema-spec.md] Section 7
✅ Inline examples demonstrate each pattern. Full specimen artifacts in [WorkflowExample.md]
```
(Clear trigger: "first time" or "need full specimen")

---

## Application Guidelines

### When to Inline (No Link)

**Inline content when:**
- Essential for understanding current context
- Eliminating duplication is not critical (small amount of overlap acceptable)
- Linear reading flow matters more than avoiding repetition
- Examples directly reinforce nearby rules

**Example:** Schema anti-patterns
- Each schema has contextual anti-patterns
- Appeared duplicative ("vague specs", "vague guidelines") but actually different
- Inlining correct choice - contextual examples more valuable than DRY principle

---

### When to Link (External Reference)

**Create links when:**
- Reader has explicit, identifiable need
- Linked document is authoritative source (establish single source of truth)
- Current document is overview, link is comprehensive
- Action-specific context makes trigger obvious
- Condition-based targeting (if X, then see Y)

**Example:** schema-relationship-map.md
- Central authority on schema relationships
- Clear trigger: "For complete schema relationships..."
- Overview inline, comprehensive map external

---

### When to Extract to Pattern File

**Extract pattern when:**
- Identical content appears in 3+ files (Rule of Three)
- Content is procedural/structural, not contextual
- References have clear authority-based triggers
- Duplication creates maintenance burden

**Example:** helper-role-pattern.md
- Identical collaboration pattern across 4 helper roles
- Clear authority trigger: "Follows [helper-role-pattern.md]"
- Eliminated 400 lines of duplication

**Counter-example:** Schema anti-patterns
- Appeared similar but were contextual
- Extraction would lose context-specific value
- Inline was correct choice

---

## Trigger Checklist

Before creating a link, verify:

- [ ] Reader can answer: "When should I follow this link?"
- [ ] Trigger is explicit (not implied or assumed)
- [ ] Link purpose is clear (what will I find?)
- [ ] Decision to follow/skip is unambiguous
- [ ] Link enhances rather than fragments understanding

If any item fails, consider:
- Inline the content instead
- Strengthen trigger language
- Restructure to eliminate need for link

---

## Common Mistakes

### Mistake 1: Assuming Context

**Problem:**
```markdown
❌ See schema-spec.md for structure
```

**Unclear:** When? For what purpose? Required or optional?

**Fixed:**
```markdown
✅ When creating SPEC: Follow [schema-spec.md] Required Structure section
```

---

### Mistake 2: Vague References

**Problem:**
```markdown
❌ Related documentation available
❌ See other schemas for patterns
```

**Unclear:** Which docs? Which schemas? What patterns?

**Fixed:**
```markdown
✅ For schema relationships: See [schema-relationship-map.md]
✅ When designing interfaces: Reference [schema-interface-skeleton-code.md] Type Completeness standards
```

---

### Mistake 3: Over-Linking

**Problem:**
```markdown
❌ Every mention of another document becomes a link
❌ "The spec-writer role [link] creates specs [link] following schema-spec [link]"
```

**Result:** Link fatigue, unclear which links are critical

**Fixed:**
```markdown
✅ The spec-writer role creates specs following [schema-spec.md] structure
```
(One authoritative link with clear trigger)

---

### Mistake 4: Under-Explaining Links

**Problem:**
```markdown
❌ [schema-spec.md]
❌ See LayoutAndState.md
```

**Unclear:** Why am I clicking this? What will I learn?

**Fixed:**
```markdown
✅ For complete SPEC structure and section templates: [schema-spec.md]
✅ For canonical directory structure: [LayoutAndState.md]
```

---

## Maintenance Implications

### Links Create Coupling

**Every link creates:**
- Dependency: Linked doc must continue to exist
- Assumption: Linked doc structure remains compatible
- Maintenance burden: Both docs must evolve together

**Guideline:** Only create links when value exceeds coupling cost.

---

### Breaking Link Changes

**When restructuring linked documents:**

1. **Audit references:**
   ```bash
   grep -r "schema-spec.md" Workflow/
   ```

2. **Check triggers still valid:**
   - Does "Required Structure section" still exist?
   - Are inline examples still present?

3. **Update or remove broken references:**
   - Fix link targets
   - Update trigger language
   - Remove obsolete links

---

## Examples in Practice

### Good: Authority-Based with Clear Trigger

```markdown
## Creating a SPEC

1. Read the feature entry in [ROADMAP.md] for context
2. Follow [schema-spec.md] Required Structure section
3. Reference inline examples for each section template
4. Before review: Verify with [checklist-SPEC.md]
```

**Why it works:**
- Each link has clear action context (when to use)
- Authority established (schema is canonical)
- Workflow sequence clear (read → follow → verify)

---

### Good: Conditional Trigger

```markdown
## Related Schemas

**When creating this artifact:**
- Reference [schema-system-map.md] for architectural context
- Follow [schema-spec.md] structure

**If unfamiliar with spec writing:**
- Study complete examples in [WorkflowExample.md]

For complete schema relationships, see [schema-relationship-map.md]
```

**Why it works:**
- Action-based triggers ("when creating")
- Conditional trigger ("if unfamiliar")
- Scope-expansion trigger ("complete relationships")

---

### Bad: Ambiguous Triggers

```markdown
❌ See schema-spec.md, schema-roadmap.md, and LayoutAndState.md for details
```

**Why it fails:**
- Which doc for which details?
- When do I need each?
- Are all three required?

---

## Summary

**Core principle:** Every link must have an explicit trigger.

**Successful trigger types:**
1. Need-based: "For X, see Y"
2. Authority-based: "Follows [schema-X] exactly"
3. Scope-expansion: "For complete Z, see Y"
4. Action-based: "When doing X, reference Y"
5. Conditional: "If X applies, see Y"

**Failed patterns to avoid:**
- Internal forward-references
- Lateral alternatives (Quick vs Detailed)
- Optional enrichment without clear trigger
- Vague references without context

**Decision framework:**
- Can reader answer "when should I follow this link?"
- Is trigger explicit and unambiguous?
- Does link enhance or fragment understanding?

**When in doubt:** Inline content. Links create coupling and cognitive overhead - only use when value is clear.
