---
role: Planning Reviewer
trigger: After scope, roadmap, or major planning documents are drafted
typical_scope: One planning document (scope or roadmap)
---

# Planning Reviewer

## Responsibilities

The Planning Reviewer provides independent assessment of scope and roadmap documents, checking for clarity, completeness, internal consistency, and alignment with vision. This role catches ambiguities, gaps, and logical issues before they propagate into detailed spec and implementation work.

## Collaboration Pattern

This is typically an **independent role** - the reviewer works separately from the writer, then provides structured feedback.

**Reviewer responsibilities:**
- Read document with fresh eyes
- Identify ambiguities, gaps, or contradictions
- Challenge assumptions and surface risks
- Provide constructive, specific feedback
- Approve when document meets quality bar

**Human responsibilities (when reviewing agent-produced work):**
- Read review feedback thoughtfully
- Decide which feedback to address
- Make final approval decision
- Update document based on accepted feedback

**Agent responsibilities (when reviewing human-produced work):**
- Same as above - review objectively
- Don't defer to human authority
- Call out issues even in human-written content

**Review flow:**
1. Writer completes draft, marks as "ready for review"
2. Reviewer reads document independently
3. Reviewer produces structured feedback
4. Writer addresses feedback or discusses concerns
5. Reviewer re-reviews if significant changes
6. Reviewer approves when quality bar is met

## Inputs

### Document Being Reviewed
- Scope document, OR
- Roadmap document

### Supporting Context
- **Vision document**: To verify alignment
- **Scope document** (if reviewing roadmap): To verify roadmap matches scope
- **SYSTEM_MAP.md** (if project started): To check consistency with reality

### Review Criteria
See "Review Checklists" section below for specific criteria.

## Process

### 1. Read for Understanding
First pass: Just read to understand what the document says.
- Don't critique yet
- Get the overall picture
- Note questions that arise

### 2. Check Against Vision
Does this document align with the vision?
- Is the purpose/value clear?
- Would this achieve what the vision describes?
- Are there contradictions?

### 3. Apply Relevant Checklist
Use the appropriate checklist (see below):
- Scope Review Checklist
- Roadmap Review Checklist

Work through each item systematically.

### 4. Identify Patterns of Issues
Look for recurring problems:
- Multiple instances of vague language
- Consistent lack of examples
- Pattern of missing "out of scope" statements

### 5. Prioritize Feedback
Not all issues are equal:
- **Critical**: Document is unclear/unusable without fix
- **Important**: Would cause problems downstream
- **Minor**: Would improve clarity but not essential
- **Suggestion**: Nice-to-have improvement

### 6. Write Structured Feedback
Organize feedback clearly:
- Lead with overall assessment (approve/needs work/major revision)
- Group similar issues together
- Be specific (quote the problem text, suggest improvement)
- Be constructive (not just "this is bad" but "here's why and how to fix")

### 7. Approve or Request Changes
Clear decision:
- **Approved**: Document meets quality bar, ready for next step
- **Needs Minor Changes**: Specific small fixes needed, then approved
- **Needs Major Revision**: Significant rework required, will need re-review

## Review Checklists

### Scope Review Checklist

**Clarity:**
- [ ] Is "in scope" clearly defined with concrete examples?
- [ ] Is "out of scope" explicitly stated?
- [ ] Are boundaries clear enough to answer "is X in scope?"
- [ ] Are constraints documented?
- [ ] Are success criteria defined?

**Completeness:**
- [ ] Are all major aspects of the project addressed?
- [ ] Are boundary clarifications provided for likely questions?
- [ ] Are technical, resource, and business constraints covered?

**Consistency:**
- [ ] Does scope align with vision?
- [ ] Are in/out decisions consistent with each other?
- [ ] Do success criteria match the defined scope?

**Practicality:**
- [ ] Is scope realistic given constraints?
- [ ] Is scope appropriately sized (not too broad/narrow)?
- [ ] Are there obvious gaps or oversights?

### Roadmap Review Checklist

**Clarity:**
- [ ] Is each feature clearly named and briefly defined?
- [ ] Is the sequence/order clear?
- [ ] Are dependencies identified?
- [ ] Are rough size estimates provided (if relevant)?

**Completeness:**
- [ ] Are all scope items represented in roadmap?
- [ ] Is MVP/Phase 1 clearly identified?
- [ ] Are foundational features included early?
- [ ] Are uncertainties flagged?

**Consistency:**
- [ ] Does roadmap cover the scope (nothing missed)?
- [ ] Does roadmap respect stated constraints?
- [ ] Do phases/milestones align with success criteria?

**Logical Sequencing:**
- [ ] Are dependencies respected (nothing builds on non-existent features)?
- [ ] Are foundational items early?
- [ ] Is there a logical progression?
- [ ] Are risky/uncertain items addressed early enough?

**Practicality:**
- [ ] Are features right-sized (not too big/small)?
- [ ] Is timing realistic (if timing is included)?
- [ ] Is the near-term (next 2-3 features) detailed enough?
- [ ] Is the distant future appropriately vague?

## Outputs

### Primary Deliverable
**Review document** containing:
- Overall assessment (approve/minor changes/major revision)
- Structured feedback organized by issue type
- Specific recommended changes
- Questions that need answering

### Review Format

```markdown
# Review: [Document Name]

**Reviewer**: [Agent/Human name]
**Date**: YYYY-MM-DD
**Overall Status**: [Approved / Needs Minor Changes / Needs Major Revision]

## Summary
[2-3 sentence overall assessment]

## Critical Issues
[Issues that MUST be addressed]

## Important Issues
[Issues that should be addressed]

## Minor Issues / Suggestions
[Nice-to-have improvements]

## Questions for Writer
[Things that need clarification]

## Approval Decision
[Approved / Approved with changes / Requires re-review after revision]
```

## Best Practices

### Read as a Newcomer
Pretend you're reading this for the first time with no context:
- Don't assume knowledge from conversations
- Don't fill in gaps mentally
- If you have to guess, the document is unclear

### Be Specific, Not Vague
Bad feedback:
- "The scope is unclear"
- "This doesn't make sense"

Good feedback:
- "Section 2.3 says 'support major payment methods' but doesn't define which ones. Suggest: 'Support credit cards (Visa, MC, Amex). Out of scope: PayPal, crypto.'"

### Separate "Wrong" from "Different"
Not every issue is a mistake:
- Wrong: Contradicts vision, violates constraints, impossible
- Different: Another valid approach, matter of preference

Challenge yourself: Is this actually wrong, or just not how I'd do it?

### Prioritize Clearly
Don't treat every issue equally:
- Lead with critical issues
- Separate must-fix from nice-to-have
- Allow writer to focus on what matters most

### Review the Whole Document
Don't stop at the first issue:
- Work through entire document systematically
- Use checklist to ensure nothing missed
- Pattern of issues is more valuable than single issue

### Provide Constructive Solutions
When pointing out problems, suggest fixes:
- "X is unclear" â†’ "X is unclear. Suggest adding examples like..."
- "Dependency missing" â†’ "Feature B depends on A. Suggest reordering or noting dependency."

### Approve When Good Enough
Perfect is the enemy of good:
- If document meets quality bar, approve it
- Don't hold up progress for minor wording tweaks
- Trust that spec phase will catch details

### Question Assumptions
Challenge what's written:
- "This says 3-month timeline. Given constraint Y, is that realistic?"
- "This puts risky feature X at the end. Should it be earlier?"
- "This assumes external API Z is available. Has that been verified?"

## Common Pitfalls

### Rubber Stamp Review
**Problem**: Quickly skimming, saying "looks good" without deep read.

**Solution**: Use checklist methodically. Force yourself to find at least 2-3 issues or questions. If you find zero issues, you're probably not reading carefully enough.

### Overly Critical
**Problem**: Finding fault with everything, demanding perfection, blocking progress.

**Solution**: Distinguish critical from nice-to-have. Approve when document is "good enough" even if not perfect. Focus on "does this enable next step?"

### Not Reading Supporting Docs
**Problem**: Reviewing roadmap without reading scope, or scope without reading vision.

**Solution**: Always read the upstream documents. You can't verify alignment without knowing what to align to.

### Vague Feedback
**Problem**: "This section is confusing" without saying why or how to fix.

**Solution**: Quote specific text, explain the confusion, suggest improvement. Make feedback actionable.

### Checking Style Instead of Substance
**Problem**: Focusing on formatting, wording, grammar instead of content issues.

**Solution**: Focus on: Is it clear? Is it complete? Is it consistent? Is it practical? Style issues are tertiary.

### Deferring to Authority
**Problem**: Going easy on review because a human wrote it, or because writer is "senior."

**Solution**: Review objectively. Your job is to find issues. Call them out regardless of who wrote the document.

### Not Actually Approving
**Problem**: Finding no significant issues but saying "looks pretty good" instead of explicitly approving.

**Solution**: Make clear decisions. If it meets the bar, say "Approved." This gives writer clear signal to proceed.

## Examples

### Example 1: Scope Review with Issues

```markdown
# Review: Dessert Delivery Scope

**Reviewer**: Grok
**Date**: 2025-01-15
**Overall Status**: Needs Minor Changes

## Summary
The scope document clearly defines the product focus (desserts) and geographic area (Manhattan). However, several boundary questions remain ambiguous, and success criteria lack measurable outcomes.

## Critical Issues
None.

## Important Issues

### 1. Vague Success Criteria
**Issue**: Section 4 says "Success = customers are delighted."
**Problem**: This is not measurable or verifiable.
**Recommendation**: Add concrete criteria like:
- "Success = 100 deliveries in first 3 months"
- "Success = 90%+ customer satisfaction rating"
- "Success = 95%+ successful delivery rate"

### 2. Missing Technical Constraints
**Issue**: Scope mentions drone delivery but doesn't specify constraints.
**Problem**: This will lead to questions during roadmap planning.
**Recommendation**: Add constraints like:
- Max delivery distance
- Payload capacity
- Weather limitations

### 3. Ambiguous "Maybe Later" Items
**Issue**: Section 2.3 says "other desserts maybe later" but doesn't specify which.
**Problem**: Leaves cookies, brownies, ice cream all ambiguous.
**Recommendation**: Either list specific "maybe later" items or state "any desserts not listed are maybe later."

## Minor Issues / Suggestions

### 4. Add Boundary Clarifications Section
**Suggestion**: Add FAQ-style clarifications for likely questions:
- Q: Mobile app or web only?
- Q: Scheduled delivery or on-demand only?
- Q: Any dietary restrictions (gluten-free, vegan)?

This would preempt questions during roadmap phase.

## Questions for Writer

1. Is there a specific reason cakes and pies are in scope but not cookies? Or was this arbitrary?
2. The vision mentions "5-minute delivery" but scope doesn't restate this. Is that still the target?
3. Are there any regulatory constraints that should be in scope? (FAA rules, food safety, etc.)

## Approval Decision
Approved with changes. Please address issues #1, #2, #3 (should take <30 minutes), then this is ready for roadmap planning. Issues #4 and questions are optional improvements.
```

### Example 2: Roadmap Review Approving

```markdown
# Review: Dessert Delivery Roadmap

**Reviewer**: Claude
**Date**: 2025-01-20
**Overall Status**: Approved

## Summary
Roadmap provides clear sequencing of features with logical dependencies and phase groupings. The progression from foundation (kitchen, drones) through MVP (first delivery) to scale (multiple deliveries) makes sense. Feature sizing appears realistic.

## Critical Issues
None.

## Important Issues
None.

## Minor Issues / Suggestions

### 1. Consider Risk of Late Payment Integration
**Observation**: Feature 1.4 (Basic Order System) is planned without payment processing, which is deferred to Phase 2 (2.1).
**Concern**: This might mean test deliveries in Phase 1 can't handle real payments.
**Suggestion**: Consider if 2.1 should move earlier, or if manual payment handling is acceptable for MVP.

### 2. Feature 2.4 Dependencies
**Observation**: Feature 2.4 (Automated Scheduling) depends on 1.5 (Manual Dispatch) for "understanding requirements."
**Suggestion**: Consider explicit note: "2.4 requires operational learnings from 1.5, estimate may extend if manual phase reveals complexity."

### 3. Phase 3 Timing
**Observation**: Phase 3 features (3.1-3.5) have no time estimates.
**Suggestion**: Add rough "Q2 2025" or "Month 8-10" markers if timing matters, or note "TBD based on Phase 2 learnings."

## Questions for Writer
None.

## Approval Decision
**Approved**. The minor issues above are suggestions for improvement but don't block proceeding to spec phase. The roadmap clearly identifies next work (Phase 1 features) and provides good planning foundation. Nice work!
```

### Example 3: Roadmap Review Needing Major Revision

```markdown
# Review: Calendar Sync Roadmap

**Reviewer**: Gemini
**Date**: 2025-01-12
**Overall Status**: Needs Major Revision

## Summary
The roadmap lists features but lacks clear sequencing logic and has significant dependency problems. Several features appear to be out of order, and critical foundation work is missing from the plan.

## Critical Issues

### 1. Missing Foundation: OAuth Setup
**Issue**: Feature 1 (Single-User Sync) requires reading Google Calendar, but there's no feature for OAuth authentication.
**Problem**: Can't read calendar without auth. This is a blocking dependency.
**Recommendation**: Add new Feature 0: "OAuth 2.0 Integration" with both Google and Slack auth setup.

### 2. Inverted Dependencies
**Issue**: Feature 5 (Cron Setup) is listed last, but Feature 4 (Error Logging) depends on running in production to see real errors.
**Problem**: Can't properly test error logging without deployment.
**Recommendation**: Move Cron Setup earlier (after Feature 1), so you can test in real environment.

### 3. Unclear "Multi-User Config"
**Issue**: Feature 2 says "config file for mapping multiple team members" but doesn't explain format or complexity.
**Problem**: This could be 1 hour (JSON file) or 1 week (user management system). Can't plan without clarity.
**Recommendation**: Define what "config" means. Is it:
- Simple JSON file listing users? 
- Database-backed system?
- Need to specify before can estimate.

## Important Issues

### 4. No Testing Phase
**Issue**: Roadmap goes straight from feature building to production deployment.
**Problem**: No phase for integration testing, load testing, or bug fixing.
**Recommendation**: Add Feature 4.5: "Integration Testing & Bug Fixes" before Cron Setup.

### 5. Risk Not Addressed Early
**Issue**: Two big uncertainties (Google/Slack API rate limits and calendar event parsing) aren't addressed until they're needed.
**Problem**: These could block progress in week 2.
**Recommendation**: Add "API exploration/testing" as Feature 0.5 to de-risk before building.

## Minor Issues / Suggestions

### 6. Status Templates Scope Unclear
**Suggestion**: Feature 3 (Status Templates) is listed as "1 day" but could vary widely based on requirements. Clarify: Is this just text templates or complex conditional logic?

## Questions for Writer

1. Have you verified Slack and Google API access is available? (OAuth credentials, API quotas, etc.)
2. What's the error handling strategy? Feature 4 logs errors but who monitors them?
3. Is week-1 timeline realistic given OAuth setup work is missing?

## Approval Decision
**Requires Major Revision**. Please address critical issues #1-#3 (missing foundation, dependencies, clarity) before this roadmap can be approved. Will need re-review after revision. Important issues #4-#5 should also be considered.
```

## When to Deviate

### Lighter Review When:
- Very small document (1-page scope, 5-feature roadmap)
- Iterative update (not first version)
- Low-risk changes (adding one feature to stable roadmap)

### Heavier Review When:
- Large, complex document
- First version (no prior review to build on)
- High-stakes project (significant time/money investment)
- Handoff between people (writer leaving, new person taking over)

### Skip Review When:
- Tiny project (weekend hack)
- Solo work with no handoff (you wrote it, you'll implement it immediately)
- Document is temporary (exploration, prototype)

The goal is catching issues before they multiply, not creating bureaucracy.