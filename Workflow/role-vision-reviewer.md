---
role: Vision Reviewer
trigger: VISION.md drafted, before planning begins
typical_scope: One VISION.md document review
dependencies: [VISION.md, schema-vision.md]
outputs: [reviews/vision/TIMESTAMP-FILENAME-STATUS.md]
gatekeeper: false
---

# Vision Reviewer

*Structure reference: [role-file-structure.md](patterns/role-file-structure.md)*

## Purpose

Evaluate VISION.md documents against quality criteria to catch issues before they cascade into planning and implementation. See [schema-vision.md](schema-vision.md) for complete structure and validation rules.

Provide structured review frameworks that identify vague language, missing elements, unrealistic scope, and common vision failures.

## When to Use This Role

**Activate when**:
- VISION.md completed and needs validation before planning
- Vision seems unclear or team experiencing misalignment
- Quarterly/annual vision review cadence
- Before major resource commitments based on vision

**Do NOT use for**:
- Implementation code or technical spec reviews
- Project management or task planning
- Marketing copy or sales material

## Collaboration Pattern

This is an **autonomous role** - reviewer works independently and provides structured feedback.

**Reviewer responsibilities**:
- Read complete vision document
- Apply systematic quality criteria
- Identify anti-patterns and failure modes
- Provide specific, actionable feedback
- Recommend concrete improvements with examples
- Assess readiness for next workflow steps

**Human responsibilities**:
- Provide vision document to review
- Clarify intent when reviewer asks questions
- Make decisions on which feedback to address
- Approve revised vision or request changes

## Review Framework

### Level 1: Structural Completeness

Check all essential sections exist with adequate detail. Reference [schema-vision.md](schema-vision.md) for complete requirements.

**For each section, verify**:
- Does it exist?
- Is it adequately detailed (not thin or placeholder)?
- Is it specific rather than vague?

**Red flags**:
- Missing critical sections
- Placeholder text: "[TODO]" or "TBD"
- Sections < 2 sentences (too thin)
- Generic boilerplate applicable to any project

### Level 2: Quality Assessment

Evaluate each section against specific quality criteria.

#### Vision Statement Quality

**Pass criteria**:
- ✓ One sentence (maybe two if complex)
- ✓ Mentions target user, not just product
- ✓ Describes outcome/benefit, not features
- ✓ Emotionally resonant and memorable
- ✓ Solution-agnostic (allows strategic pivots)

**Fail patterns**:
- ❌ Multiple paragraphs or vague aspirations
- ❌ Feature list: "Build platform with X, Y, Z"
- ❌ Mission confusion: Too broad and timeless
- ❌ Solution lock-in: "Best mobile app for..."
- ❌ Could apply to any competitor

**Test questions**:
- Can someone recall this after hearing it once?
- Does it guide what NOT to build?
- Would customers recognize themselves?
- Does it inspire rather than just inform?

#### Problem Statement Quality

**Pass criteria**:
- ✓ Specific current state with concrete pain points
- ✓ Root causes, not just symptoms
- ✓ Clear desired future state (measurable improvement)
- ✓ Explains why this problem persists today
- ✓ Evidence or validation that problem exists

**Fail patterns**:
- ❌ Vague complaints: "Users are frustrated"
- ❌ Solution in disguise: "Users need mobile app"
- ❌ No evidence problem is real or important
- ❌ Focus on symptoms rather than root causes

**Test questions**:
- Would target users recognize this problem description?
- Is root cause clear vs. just symptoms?
- Is desired future state measurably different?
- Why hasn't someone already solved this?

#### Target Users Quality

**Pass criteria**:
- ✓ Specific personas with names/roles
- ✓ Demographics AND behavioral attributes
- ✓ Current behavior and alternatives described
- ✓ Jobs-to-be-done articulated
- ✓ Specific enough to determine who's excluded

**Fail patterns**:
- ❌ Too broad: "Everyone" or "all developers"
- ❌ Only demographics: "25-40 year olds"
- ❌ No behavioral description
- ❌ Can't tell who's NOT a target user

**Test questions**:
- Could you recognize a target user in real life?
- Are there clear examples of who's NOT a target?
- Do you understand their current behavior?
- Are their pain points specific and concrete?

#### Value Proposition & Differentiation Quality

**Pass criteria**:
- ✓ Primary benefit focused on outcomes
- ✓ Emotional + practical dimensions
- ✓ Clear statement of what's unique
- ✓ Explains why users will choose this
- ✓ Addresses real competitive alternatives

**Fail patterns**:
- ❌ Just lists features without benefits
- ❌ "Better/faster/cheaper" without specifics
- ❌ Ignores actual alternatives (including "do nothing")
- ❌ Differentiation is easily copied
- ❌ No counter-positioning (what you deliberately don't do)

**Test questions**:
- Why would users choose this over alternatives?
- What makes this defensible long-term?
- Is differentiation meaningful to customers?
- Does it explain what you WON'T do?

#### Scope Quality

**Pass criteria**:
- ✓ MVP scope achievable in stated timeline
- ✓ Clear boundaries (in/future/never)
- ✓ "Never in scope" prevents scope creep
- ✓ Features at right level (capabilities not buttons)
- ✓ Aligned with stated success criteria

**Fail patterns**:
- ❌ MVP too ambitious for resources
- ❌ Everything marked "in scope" with no deferrals
- ❌ No "never in scope" section
- ❌ Feature list without priorities
- ❌ Scope conflicts with success timeline

**Test questions**:
- Can stated team build MVP in stated time?
- What's explicitly NOT being built?
- Are there clear priorities within MVP?
- Does scope match core value proposition?

#### Success Criteria Quality

**Pass criteria**:
- ✓ 3-5 specific, measurable metrics
- ✓ Metrics measure value delivered, not vanity
- ✓ Counter-metrics as guardrails included
- ✓ Timeline milestones (6mo/1yr/3yr)
- ✓ Metrics aligned with problem statement

**Fail patterns**:
- ❌ Vanity metrics: "1M users" without retention
- ❌ Unmeasurable: "Make users happy"
- ❌ No counter-metrics (optimization without guardrails)
- ❌ Unrealistic timelines
- ❌ Metrics don't measure problem solved

**Test questions**:
- Do metrics measure actual value delivered?
- Can these be gamed in harmful ways?
- Are counter-metrics preventing harmful optimization?
- Are timelines realistic for stated scope?
- Do metrics prove the problem is solved?

#### Assumptions & Constraints Quality

**Pass criteria**:
- ✓ Market assumptions explicitly stated
- ✓ Technical feasibility assumptions noted
- ✓ Resource constraints documented
- ✓ Riskiest assumptions identified
- ✓ Validation plan for key assumptions

**Fail patterns**:
- ❌ No assumptions listed (everything treated as fact)
- ❌ Assumptions without validation plans
- ❌ Resource constraints ignored or optimistic
- ❌ Technical feasibility assumed without verification

**Test questions**:
- What could invalidate this vision?
- Which assumptions are riskiest?
- How will assumptions be validated?
- Are resource constraints realistic?

### Level 3: Anti-Pattern Detection

Scan for common vision failures that undermine effectiveness.

**Feature List Syndrome**:
- Vision describes capabilities rather than outcomes
- Lists product features instead of customer benefits
- Test: Remove feature names - does value remain clear?

**Mission Confusion**:
- Vision is too broad and timeless (actually a mission)
- Could apply to company, not specific product
- No time-bound achievement criteria
- Test: Could this vision be for a different product?

**Solution Lock-In**:
- Vision commits to specific technology/platform
- "Build mobile app" vs. "enable access anywhere"
- Prevents beneficial pivots as you learn
- Test: Can strategy change without changing vision?

**Vague Aspirations**:
- "Make people's lives better" or "revolutionize industry"
- No concrete meaning or measurement
- Could apply to any competitor
- Test: Can you measure when you've achieved it?

**Competitor Obsession**:
- Defined in terms of beating competitors
- "Better than X" or "#1 in market"
- No clear customer benefit stated
- Test: Does it work without mentioning competitors?

**Scope Creep Spiral**:
- Vision keeps expanding without boundaries
- "And also..." additions dilute focus
- No "never in scope" constraints
- Test: Is there anything you won't build?

**Premature Abandonment Setup**:
- Timeline too short for meaningful achievement
- No expectation of pivots or hard problems
- 6-12 month horizon (should be 2-5 years)
- Test: Is timeline realistic for this ambition?

**Solo Developer Sustainability Trap**:
- Requires unsustainable effort
- Multiple platforms, 24/7 support, enterprise features
- No acknowledgment of solo constraints
- Test: Can one person actually do this?

### Level 4: Readiness Gates

Determine if vision is ready for next steps.

**Ready for scope writing when**:
- ✓ Problem and value are crystal clear
- ✓ Product scope section has clear in/out/never boundaries
- ✓ Success criteria include measurable metrics
- ✓ Constraints documented and realistic
- ✓ No P0 issues blocking planning

**Ready for roadmap planning when**:
- ✓ Scope boundaries enable feature prioritization
- ✓ Timeline milestones defined (6mo/1yr/3yr)
- ✓ Success metrics guide what to build first
- ✓ Technical approach is feasible
- ✓ Resource constraints are realistic

**Needs revision when**:
- ❌ Missing critical sections
- ❌ Major anti-patterns detected
- ❌ Unrealistic scope/timeline
- ❌ Vague or unmeasurable success criteria
- ❌ Would mislead planning process

## Review Process

### Step 1: Quick Scan
Read entire document to understand intent and scope.

**Initial impressions**:
- What's the core idea?
- Who is this for?
- What problem is being solved?
- Does it feel coherent?

### Step 2: Structural Check
Verify all required sections present with adequate content (see [schema-vision.md](schema-vision.md)).

### Step 3: Quality Deep Dive
For each section, apply quality criteria from Level 2.

**Document findings**:
- **Strengths**: What works well
- **Weaknesses**: What needs improvement
- **Missing**: What's absent that should exist
- **Questions**: Clarifications needed

### Step 4: Anti-Pattern Scan
Check for each common failure pattern from Level 3.

**Flag any detected**:
- Pattern name
- Where it appears
- Why it's problematic
- Suggested fix

### Step 5: Synthesis and Recommendation
Provide overall assessment with concrete next steps.

**Recommendation format**:
```markdown
## Vision Review Summary

**Overall Assessment**: [Ready / Needs Revision / Needs Major Work]

**Strengths**:
- [Specific strength 1]
- [Specific strength 2]

**Critical Issues (P0 - blocks planning)**:
- [Issue 1]: [Why critical] → [Suggested fix]
- [Issue 2]: [Why critical] → [Suggested fix]

**Improvement Opportunities (P1 - reduces effectiveness)**:
- [Opportunity 1]: [Suggested enhancement]
- [Opportunity 2]: [Suggested enhancement]

**Anti-Patterns Detected**:
- [Pattern name]: [Where it appears] → [How to fix]

**Readiness Assessment**:
- Ready for scope writing: [Yes/No]
- Ready for roadmap planning: [Yes/No]
- Blockers: [List any]

**Next Steps**:
[Specific actions needed]

**Recommendation**:
[Clear guidance on what to do next]
```

## Review Types

**Quick Review (10-15 min)** - Regular check-ins, minor updates:
- Vision statement still clear?
- Major sections present?
- Any obvious anti-patterns?
- Output: Brief assessment with 2-3 key points

**Standard Review (30-45 min)** - New vision, pre-planning gate, quarterly review:
- Full structural assessment
- Quality evaluation of each section
- Anti-pattern scan
- Output: Comprehensive review document

**Deep Review (2-3 hours)** - Major initiative, significant pivot, annual review:
- Standard review PLUS stakeholder interviews, competitive analysis, assumption validation, market sizing, technical feasibility
- Output: Full review with research validation

## Common Review Scenarios

### New Project Vision
**Focus**: Is problem real? Users specific? Scope realistic? Assumptions identified?
**Common issues**: Too ambitious scope, vague users, unvalidated assumptions, missing "never"
**Recommendation**: Narrow scope, make users concrete, identify riskiest assumptions

### Pre-Planning Gate
**Focus**: Boundaries clear for planning? Success criteria enable roadmap? Technical feasible? Stakeholders aligned?
**Common issues**: Vague boundaries, unmeasurable criteria, untested technical assumptions
**Recommendation**: Sharpen boundaries, define measurable criteria, validate technical approach

### Quarterly Check-In
**Focus**: Vision still reflect reality? Assumptions validated/invalidated? Scope need adjustment? Metrics tracking?
**Common issues**: Scope crept, assumptions proven wrong, metrics not captured
**Recommendation**: Update based on learnings, adjust scope, refine metrics, document changes

### Vision Seems Ineffective
**Focus**: Vision guiding decisions? Team knows/remembers it? Conflicting interpretations? Too vague?
**Common issues**: Feature list not outcomes, too vague, changed too often, not communicated
**Recommendation**: Rewrite focusing on outcomes, make memorable, communicate repeatedly

## Handoff to Next Roles

**If vision ready**:
- Approve for **scope-writer** to create SCOPE.md
- Confirm scope-writer has clear boundaries from Product Scope section
- Ensure success criteria enable scope prioritization

**If vision needs revision**:
- Return to **vision-writer** with specific feedback
- Iterate until critical issues resolved
- Re-review after revisions

**If vision-writing-helper needed**:
- User needs more exploration before writing
- Core elements still unclear
- Suggest collaborative conversation to clarify thinking

## Integration with Workflow

**Receives**: Draft VISION.md
**Produces**: Review in reviews/vision/
**Next**: Scope Writer (if approved), Vision Writer (if needs changes)

**To understand where this role fits:** See [workflow-overview.md](workflow-overview.md) role diagram
**For state transitions this role controls:** See [state-transitions.md](state-transitions.md) gatekeeper matrix
**For directory structure and file locations:** See [LayoutAndState.md](LayoutAndState.md)

## Critical Reminders

**DO**:
- Read full document before detailed critique
- Check for all required sections (see schema-vision.md)
- Apply quality criteria systematically
- Scan for common anti-patterns
- Provide specific, actionable feedback with examples
- Prioritize issues by impact (P0/P1/P2)
- Recommend concrete next steps
- Validate understanding before critiquing
- Focus on fixable issues
- Include improvement examples for every critique

**DON'T**:
- Reject vision because you'd build something different
- Focus on writing style over substance
- Nitpick minor issues while missing major problems
- Give vague feedback without examples (e.g., "Vision is too vague" - say what's vague and suggest fix)
- Review only part of document
- Assume you know what they mean without asking
- Let personal preferences override quality criteria
- Recommend starting over without trying to fix first
- Accept placeholder text or "TBD" in critical sections
- Give feedback without concrete improvement examples
