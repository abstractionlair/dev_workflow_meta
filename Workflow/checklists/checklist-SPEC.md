# SPEC Checklist

Use this checklist before requesting spec review.

## Required Sections

- [ ] Document Header (Feature ID, Version, Status, Date, Author)
- [ ] Overview (1-2 paragraphs explaining feature)
- [ ] Feature Scope (boundaries: in scope, out of scope, future scope)
- [ ] User/System Perspective (personas or system context)
- [ ] Value Delivered (user outcomes, measurable benefits)
- [ ] Interface Contract (all methods with signatures, parameters, returns, raises)
- [ ] Acceptance Criteria (all testable, clear pass/fail)
- [ ] Scenarios (Given-When-Then format, map to acceptance criteria)
- [ ] Data Structures (if feature introduces new data types)
- [ ] Dependencies (libraries, services, other features)
- [ ] Constraints and Limitations (performance, security, technical)
- [ ] Open Questions (if any - should be minimal for review)
- [ ] References (roadmap feature, vision alignment)

## Quality Checks

### Testability
- [ ] Every acceptance criterion specifies exact inputs and expected outputs
- [ ] Every acceptance criterion has clear pass/fail condition
- [ ] All error cases documented with expected exceptions/responses
- [ ] Scenarios provide concrete test cases

### Completeness
- [ ] All interface methods fully specified (types, parameters, returns, exceptions)
- [ ] All error conditions documented
- [ ] Edge cases and boundary conditions identified
- [ ] Dependencies explicitly listed

### Clarity
- [ ] Unambiguous language throughout
- [ ] No implementation prescriptions (no "use algorithm X" or "data structure Y")
- [ ] Concrete examples provided for complex behaviors
- [ ] Consistent terminology

### Alignment
- [ ] Feature ID matches ROADMAP.md entry
- [ ] Feature scope aligns with roadmap description
- [ ] Success criteria align with roadmap "Delivers" field
- [ ] Dependencies match roadmap "Depends on" field

## Self-Review

Before requesting external review:

- [ ] Read spec aloud - does it make sense?
- [ ] Can you implement feature from spec alone? (completeness test)
- [ ] Can you write tests from acceptance criteria alone? (testability test)
- [ ] Does spec answer "what" without prescribing "how"? (abstraction test)
- [ ] Are examples realistic and detailed? (quality test)

## Common Issues to Check

- [ ] Vague acceptance criteria like "handles errors correctly" (be specific!)
- [ ] Missing error cases (check every "if" implies an error path)
- [ ] Implementation details in interface contracts (avoid algorithm specifications)
- [ ] Ambiguous data types (use precise type annotations)
- [ ] Missing scenario coverage (every acceptance criterion needs scenario)
- [ ] Contradictory requirements (check for conflicts)

## Ready for Review

When all items checked:
1. Move SPEC to `specs/proposed/`
2. Create review request following [schema-review-request.md](../schema-review-request.md)
3. Request spec review from spec-reviewer

## Reference

For complete SPEC structure and examples, see [schema-spec.md](../schema-spec.md)
