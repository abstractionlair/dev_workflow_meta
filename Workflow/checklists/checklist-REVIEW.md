# REVIEW Checklist

Use this checklist before finalizing a review.

## Required Sections

- [ ] Document Header (Artifact, Version, Reviewer, Date, Decision, Duration)
- [ ] Summary (2-3 sentence overview of review findings)
- [ ] Evaluation (assessment of artifact against all relevant criteria)
- [ ] Decision Rationale (explanation of APPROVED/NEEDS CHANGES/REJECTED decision)
- [ ] Required Changes (if NEEDS CHANGES - specific, actionable changes)
- [ ] Recommendations (optional improvements, non-blocking suggestions)
- [ ] Approval Conditions (if APPROVED with conditions)
- [ ] State Transition (if gatekeeper review - authorization to move artifact)

## Decision Clarity

- [ ] Decision is one of: APPROVED, NEEDS CHANGES, REJECTED
- [ ] Decision clearly stated in header and Decision Rationale section
- [ ] Decision matches evaluation findings (no contradictions)

## Evaluation Completeness

### For Spec Reviews
- [ ] Testability of acceptance criteria evaluated
- [ ] Completeness of interface contracts evaluated
- [ ] Clarity of scenarios evaluated
- [ ] Alignment with roadmap verified
- [ ] Dependencies validated

### For Test Reviews
- [ ] Coverage completeness verified (>80% line, >70% branch)
- [ ] Test isolation verified (no shared state, run in any order)
- [ ] AAA pattern verified (Arrange-Act-Assert)
- [ ] Test names descriptive and clear
- [ ] All acceptance criteria from spec covered

### For Implementation Reviews
- [ ] All tests passing (verified by running test suite)
- [ ] No test modifications (tests remain unchanged)
- [ ] GUIDELINES.md compliance verified
- [ ] Code quality standards met (no duplication, clear names, short functions)
- [ ] Sentinel tests passing (for bug fixes)

### For Bug Fix Reviews
- [ ] Root cause documented in bug report
- [ ] Fix addresses root cause (not just symptoms)
- [ ] Sentinel test exists and verifies fix
- [ ] Bug report moved from bugs/fixing/ to bugs/fixed/

## Required Changes Quality (if NEEDS CHANGES)

- [ ] Each change has specific location reference (section, line number, file)
- [ ] Each change has clear description of current state
- [ ] Each change has clear description of required state
- [ ] Each change has rationale explaining why change needed
- [ ] Each change marked as blocking or non-blocking
- [ ] Blocking changes prevent approval, non-blocking are recommendations
- [ ] No vague feedback ("improve quality", "make clearer" - be specific!)

## Evidence-Based Review

- [ ] Evaluation cites specific evidence (line numbers, quotes, examples)
- [ ] Claims are verifiable (not just opinions)
- [ ] Concrete examples provided for issues found
- [ ] References to schema criteria (not personal preferences)

## Objectivity

- [ ] Review focuses on artifact quality, not author identity
- [ ] Feedback is constructive, not punitive
- [ ] Based on schema standards, not personal style preferences
- [ ] Major issues identified (not bike-shedding minor formatting)

## Actionability

For NEEDS CHANGES decisions:

- [ ] Author knows exactly what to fix
- [ ] Each required change is actionable (not "think harder")
- [ ] Estimated effort provided (helps author plan)
- [ ] Clear what makes change complete

## Gatekeeping (if applicable)

For reviews that control state transitions:

- [ ] State Transition section present
- [ ] Authorization clear (approved to move from X → Y)
- [ ] Any conditions for transition documented
- [ ] Handoff to next role explicit

## Self-Review

Before publishing review:

- [ ] Read review from author's perspective - is it actionable?
- [ ] Did I evaluate ALL schema criteria, not just some?
- [ ] Is decision justified by evidence?
- [ ] Would I understand what to fix if I received this review?
- [ ] Is tone professional and constructive?

## Common Issues to Avoid

- [ ] Vague rejection ("has some issues" - what issues?)
- [ ] Scope creep (adding features beyond artifact scope)
- [ ] Rubber stamp approval (no evidence of evaluation)
- [ ] Bike-shedding (focusing on trivial style over substance)
- [ ] Missing test execution (for implementation reviews - actually run tests!)
- [ ] Conflating review and design (review evaluates, doesn't redesign)

## Ready to Publish

When all items checked:
1. Save review to appropriate `reviews/[type]/` directory
2. Use timestamped filename: `[artifact]-[decision]-[timestamp].md`
3. Link review in review request (if one exists)
4. Notify author of review completion

## Reference

For complete REVIEW structure and examples, see [schema-review.md](../schema-review.md)
