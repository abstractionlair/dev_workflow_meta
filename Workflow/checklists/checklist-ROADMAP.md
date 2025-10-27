# ROADMAP Checklist

Use this checklist before requesting roadmap review.

## Required Sections

- [ ] Document Header (Project Name matching VISION.md and SCOPE.md)
- [ ] Roadmap Overview (2-3 sentences explaining sequencing strategy)
- [ ] Alignment (Vision statement, Success criteria, Scope summary)
- [ ] Sequencing Strategy (principles used to order features)
- [ ] Phase 1 (with all required subsections)
- [ ] Phase 2 (with all required subsections)
- [ ] Additional phases if needed (Phases 3, 4...)
- [ ] Dependencies (cross-phase dependency map)
- [ ] Risks and Mitigation (major risks and how addressed)
- [ ] Flexibility and Adaptation (how roadmap evolves based on learnings)

## Per-Phase Requirements

For each phase:

- [ ] Phase Goals (clear statement of what phase accomplishes)
- [ ] Features table (3-7 features minimum)
- [ ] Success Criteria (measurable outcomes for phase)
- [ ] Learning Goals (what we'll learn during this phase)
- [ ] Validation (checkpoint review triggers)

## Per-Feature Requirements

For each feature in each phase:

- [ ] **Feature** - Clear, descriptive name (2-5 words, noun phrase)
- [ ] **Description** - 1-2 sentence overview of what feature does
- [ ] **Why now** - Sequencing rationale (why in this phase, not earlier/later)
- [ ] **Delivers** - Specific user value or learning outcome
- [ ] **Derisks** - Assumptions addressed (or "None" if no risk)
- [ ] **Depends on** - Prerequisites listed (or "Nothing" if first feature)
- [ ] **Effort** - Estimate (Small/Medium/Large with optional time)

## Alignment Verification

### With VISION.md
- [ ] Vision statement copied exactly from VISION.md
- [ ] Success criteria align with VISION.md success metrics
- [ ] Feature sequence supports vision achievement
- [ ] Timeline milestones match VISION.md expectations

### With SCOPE.md
- [ ] Scope summary accurately reflects SCOPE.md In Scope section
- [ ] All in-scope features from SCOPE.md appear in roadmap phases
- [ ] No out-of-scope features in roadmap
- [ ] Deferred features explicitly noted if included in later phases

### Internal Consistency
- [ ] Phase numbers sequential (Phase 1, 2, 3...)
- [ ] Feature names consistent across dependencies
- [ ] Dependencies reference actual feature names (not made-up features)
- [ ] Effort estimates consistent in scale
- [ ] Timeline estimates realistic (if provided)

## Quality Checks

### Completeness
- [ ] All 10 required sections present
- [ ] Every phase has 3-7 features minimum
- [ ] All feature fields present (no empty "Why now" or "Delivers")
- [ ] Dependencies section maps all cross-phase dependencies
- [ ] Risks section identifies at least 3 major risks

### Clarity
- [ ] Feature descriptions understandable without context
- [ ] Sequencing rationale specific (not vague "important")
- [ ] Success criteria measurable and verifiable
- [ ] Learning goals clear and actionable

### Sequencing Quality
- [ ] First phase addresses highest risks or provides immediate value
- [ ] Dependencies respected (prerequisite features in earlier phases)
- [ ] Phases have coherent themes (not random feature collections)
- [ ] Sequencing strategy principles applied consistently

## Self-Review

Before requesting external review:

- [ ] Read each feature "Why now" - is rationale convincing?
- [ ] Check dependencies - can features be built in this order?
- [ ] Verify deliverables - does each feature provide clear value?
- [ ] Review risks - are major assumptions identified?
- [ ] Validate timeline - is phase 1 achievable with available resources?

## Common Issues to Check

- [ ] Missing feature descriptions (every feature needs 1-2 sentence overview)
- [ ] Vague descriptions ("improve system" - improve HOW?)
- [ ] Circular dependencies (Feature A depends on Feature B which depends on Feature A)
- [ ] Impossible sequencing (feature in Phase 1 depends on feature in Phase 2)
- [ ] Kitchen sink first phase (too many features, should be focused)
- [ ] No risk identification ("None" is rarely true - dig deeper)
- [ ] Vague success criteria ("users happy" - measure HOW?)
- [ ] Missing checkpoint review triggers

## Milestone Alignment

If timeline milestones exist:

- [ ] Phase completion dates align with milestone deadlines
- [ ] If misalignment exists, explicitly addressed in Flexibility section
- [ ] Mitigation strategy documented for timeline pressure
- [ ] Scope reduction options identified if needed

## Ready for Review

When all items checked:
1. Verify vision statement matches VISION.md exactly (common mistake!)
2. Cross-check all feature dependencies are valid
3. Request roadmap review from roadmap-reviewer

## Reference

For complete ROADMAP structure and examples, see [schema-roadmap.md](../schema-roadmap.md)
