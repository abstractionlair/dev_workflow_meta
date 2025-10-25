---
name: vision-reviewer
description: Review product vision documents for clarity, feasibility, and effectiveness. Use when evaluating VISION.md documents to ensure they provide strategic direction, avoid common pitfalls, and meet quality standards before cascading to planning and implementation.
---

# Vision Reviewer

## Overview

Evaluate vision documents against proven quality criteria to catch issues before they cascade into planning and implementation. This skill provides structured review frameworks that identify vague language, missing elements, unrealistic scope, and other common vision failures.

## When to Use This Skill

**Trigger scenarios:**
- User asks to review a VISION.md document
- Vision document completed and needs validation before planning begins
- Vision seems unclear or team experiencing misalignment
- Quarterly/annual vision review cadence
- Before making major resource commitments based on vision

**Do NOT use for:**
- Reviewing implementation code or technical specs
- Project management or task planning reviews
- Marketing copy or sales material evaluation

## Review Framework

### Level 1: Structural Completeness

Check if all essential sections exist with adequate detail.

**Required sections:**
- ✅ Vision statement (1-2 sentences)
- ✅ Problem statement (current state + desired future state)
- ✅ Target users (with specific personas)
- ✅ Value proposition and differentiation
- ✅ Product scope (in/future/never)
- ✅ Success criteria (metrics + timeline)
- ✅ Technical approach (stack + principles)
- ✅ Assumptions and constraints
- ✅ Open questions

**For each section, check:**
- Does it exist?
- Is it adequately detailed?
- Is it specific rather than vague?

**Red flags:**
- Missing critical sections
- Placeholder text like "[TODO]" or "TBD"
- Sections with < 2 sentences (too thin)
- Generic boilerplate that could apply to any project

### Level 2: Quality Assessment

Evaluate each section against quality criteria.

#### Vision Statement Quality

**Pass criteria:**
- ✅ One sentence (maybe two if complex)
- ✅ Mentions target user, not just product
- ✅ Describes outcome/benefit, not features
- ✅ Emotionally resonant and memorable
- ✅ Solution-agnostic (allows strategic pivots)

**Fail patterns:**
- ❌ Multiple paragraphs or vague aspirations
- ❌ Feature list: "Build a platform with X, Y, Z"
- ❌ Mission confusion: Too broad and timeless
- ❌ Solution lock-in: "The best mobile app for..."
- ❌ Could apply to any competitor

**Test questions:**
- Can someone recall this after hearing it once?
- Does it guide what NOT to build?
- Would customers recognize themselves?
- Does it inspire rather than just inform?

#### Problem Statement Quality

**Pass criteria:**
- ✅ Specific current state with concrete pain points
- ✅ Root causes, not just symptoms
- ✅ Clear desired future state (measurable improvement)
- ✅ Explains why this problem persists today
- ✅ Evidence or validation that problem exists

**Fail patterns:**
- ❌ Vague complaints: "Users are frustrated"
- ❌ Solution in disguise: "Users need mobile app"
- ❌ No evidence problem is real or important
- ❌ Focus on symptoms rather than root causes

**Test questions:**
- Would target users recognize this problem description?
- Is the root cause clear vs. just symptoms?
- Is the desired future state measurably different?
- Why hasn't someone already solved this?

#### Target Users Quality

**Pass criteria:**
- ✅ Specific personas with names/roles
- ✅ Demographics AND behavioral attributes
- ✅ Current behavior and alternatives described
- ✅ Jobs-to-be-done articulated
- ✅ Specific enough to determine who's excluded

**Fail patterns:**
- ❌ Too broad: "Everyone" or "all developers"
- ❌ Only demographics: "25-40 year olds"
- ❌ No behavioral description
- ❌ Can't tell who's NOT a target user

**Test questions:**
- Could you recognize a target user in real life?
- Are there clear examples of who's NOT a target?
- Do you understand their current behavior?
- Are their pain points specific and concrete?

#### Value Proposition & Differentiation Quality

**Pass criteria:**
- ✅ Primary benefit focused on outcomes
- ✅ Emotional + practical dimensions
- ✅ Clear statement of what's unique
- ✅ Explains why users will choose this
- ✅ Addresses real competitive alternatives

**Fail patterns:**
- ❌ Just lists features without benefits
- ❌ "Better/faster/cheaper" without specifics
- ❌ Ignores actual alternatives (including "do nothing")
- ❌ Differentiation is easily copied
- ❌ No counter-positioning (what you deliberately don't do)

**Test questions:**
- Why would users choose this over alternatives?
- What makes this defensible long-term?
- Is differentiation meaningful to customers?
- Does it explain what you WON'T do?

#### Scope Quality

**Pass criteria:**
- ✅ MVP scope is achievable in stated timeline
- ✅ Clear boundaries (in/future/never)
- ✅ "Never in scope" prevents scope creep
- ✅ Features at right level (capabilities not buttons)
- ✅ Aligned with stated success criteria

**Fail patterns:**
- ❌ MVP too ambitious for resources
- ❌ Everything marked "in scope" with no deferrals
- ❌ No "never in scope" section
- ❌ Feature list without priorities
- ❌ Scope conflicts with success timeline

**Test questions:**
- Can stated team build MVP in stated time?
- What's explicitly NOT being built?
- Are there clear priorities within MVP?
- Does scope match the core value proposition?

#### Success Criteria Quality

**Pass criteria:**
- ✅ 3-5 specific, measurable metrics
- ✅ Metrics measure value delivered, not vanity
- ✅ Counter-metrics as guardrails included
- ✅ Timeline milestones (6mo/1yr/3yr)
- ✅ Metrics aligned with problem statement

**Fail patterns:**
- ❌ Vanity metrics: "1M users" without retention
- ❌ Unmeasurable: "Make users happy"
- ❌ No counter-metrics (optimization without guardrails)
- ❌ Unrealistic timelines
- ❌ Metrics don't measure problem solved

**Test questions:**
- Do metrics measure actual value delivered?
- Can these be gamed in harmful ways?
- Are counter-metrics preventing harmful optimization?
- Are timelines realistic for stated scope?
- Do metrics prove the problem is solved?

#### Assumptions & Constraints Quality

**Pass criteria:**
- ✅ Market assumptions explicitly stated
- ✅ Technical feasibility assumptions noted
- ✅ Resource constraints documented
- ✅ Riskiest assumptions identified
- ✅ Validation plan for key assumptions

**Fail patterns:**
- ❌ No assumptions listed (everything treated as fact)
- ❌ Assumptions without validation plans
- ❌ Resource constraints ignored or optimistic
- ❌ Technical feasibility assumed without verification

**Test questions:**
- What could invalidate this vision?
- Which assumptions are riskiest?
- How will assumptions be validated?
- Are resource constraints realistic?

### Level 3: Anti-Pattern Detection

Scan for common vision failures that undermine effectiveness.

**Feature List Syndrome:**
- Vision describes capabilities rather than outcomes
- Lists product features instead of customer benefits
- Test: Remove feature names - does value remain clear?

**Mission Confusion:**
- Vision is too broad and timeless (actually a mission)
- Could apply to company, not specific product
- No time-bound achievement criteria
- Test: Could this vision be for a different product?

**Solution Lock-In:**
- Vision commits to specific technology/platform
- "Build mobile app" vs. "enable access anywhere"
- Prevents beneficial pivots as you learn
- Test: Can strategy change without changing vision?

**Vague Aspirations:**
- "Make people's lives better" or "revolutionize industry"
- No concrete meaning or measurement
- Could apply to any competitor
- Test: Can you measure when you've achieved it?

**Competitor Obsession:**
- Defined in terms of beating competitors
- "Better than X" or "#1 in market"
- No clear customer benefit stated
- Test: Does it work without mentioning competitors?

**Scope Creep Spiral:**
- Vision keeps expanding without boundaries
- "And also..." additions dilute focus
- No "never in scope" constraints
- Test: Is there anything you won't build?

**Premature Abandonment Setup:**
- Timeline too short for meaningful achievement
- No expectation of pivots or hard problems
- 6-12 month horizon (should be 2-5 years)
- Test: Is timeline realistic for this ambition?

**Solo Developer Sustainability Trap:**
- Requires unsustainable effort
- Multiple platforms, 24/7 support, enterprise features
- No acknowledgment of solo constraints
- Test: Can one person actually do this?

### Level 4: Readiness Gates

Determine if vision is ready for next steps.

**Ready for Planning (YES if all true):**
- ✅ All structural elements present
- ✅ Vision statement passes quality tests
- ✅ Problem is specific and validated
- ✅ Target users are concrete
- ✅ Success criteria are measurable
- ✅ Scope is realistic for resources
- ✅ No critical anti-patterns detected
- ✅ Stakeholders aligned on vision

**Ready for scope-writer skill (additional checks):**
- ✅ Product Scope section has clear In/Future/Never structure
- ✅ Success Criteria includes Timeline Milestones (6mo/1yr minimum)
- ✅ Assumptions and Constraints has Resource Constraints subsection
- ✅ Resource Constraints specifies Team, Time, Budget

**Ready for roadmap-planner skill (checked after scope created):**
- ✅ Timeline Milestones in Success Criteria (used for phase planning)
- ✅ Target Users concrete enough to prioritize features by value

**Needs Revision (YES if any true):**
- ❌ Missing critical sections
- ❌ Vision statement fails quality tests
- ❌ Problem is vague or unvalidated
- ❌ Success criteria unmeasurable
- ❌ Scope unrealistic for resources
- ❌ Critical anti-patterns present
- ❌ Stakeholder misalignment

**Blockers Requiring Resolution:**
- Major assumptions unvalidated
- Technical feasibility uncertain
- Resource commitment unclear
- Conflicting stakeholder priorities

## Review Process

### 1. Initial Read-Through

Read entire document without stopping to get overall impression.

**First impression questions:**
- Do I understand what this is after one read?
- Am I inspired or confused?
- Could I explain this to someone else?
- Does it feel focused or scattered?

### 2. Structural Assessment

Go through each required section, checking presence and adequacy.

**Create checklist:**
- [ ] Vision statement exists and is 1-2 sentences
- [ ] Problem statement with current + desired state
- [ ] Target users with specific personas
- [ ] Value proposition articulated
- [ ] Scope boundaries (in/future/never)
- [ ] Success criteria with metrics
- [ ] Technical approach documented
- [ ] Assumptions made explicit
- [ ] Open questions listed

### 3. Quality Deep Dive

For each section, apply quality criteria from Level 2.

**Document findings:**
- Strengths: What works well
- Weaknesses: What needs improvement
- Missing: What's absent that should exist
- Questions: Clarifications needed

### 4. Anti-Pattern Scan

Check for each common failure pattern.

**Flag any detected:**
- Pattern name
- Where it appears
- Why it's problematic
- Suggested fix

### 5. Synthesis and Recommendation

Provide overall assessment with concrete next steps.

**Recommendation format:**
```markdown
## Vision Review Summary

**Overall Assessment:** [Ready / Needs Revision / Needs Major Work]

**Strengths:**
- [Specific strength 1]
- [Specific strength 2]

**Critical Issues:**
- [Issue 1]: [Why critical] → [Suggested fix]
- [Issue 2]: [Why critical] → [Suggested fix]

**Improvement Opportunities:**
- [Opportunity 1]: [Suggested enhancement]
- [Opportunity 2]: [Suggested enhancement]

**Anti-Patterns Detected:**
- [Pattern name]: [Where] → [How to fix]

**Readiness Assessment:**
- Ready for planning: [Yes/No]
- Blockers: [List any]
- Next steps: [Specific actions needed]

**Recommendation:**
[Clear guidance on what to do next]
```

## Review Types

### Quick Review (10-15 minutes)

**Use when:** Regular check-ins, minor updates

**Focus on:**
- Vision statement still clear?
- Major sections present?
- Any obvious anti-patterns?
- Alignment with current work?

**Output:** Brief assessment with 2-3 key points

### Standard Review (30-45 minutes)

**Use when:** New vision, pre-planning gate, quarterly review

**Process:**
- Full structural assessment
- Quality evaluation of each section
- Anti-pattern scan
- Detailed recommendations

**Output:** Comprehensive review document

### Deep Review (2-3 hours)

**Use when:** Major product initiative, significant pivot, annual review

**Process:**
- Standard review components PLUS:
- Stakeholder interviews for alignment check
- Competitive analysis validation
- Assumption validation research
- Market sizing verification
- Technical feasibility assessment

**Output:** Full review with research validation

## Common Review Scenarios

### Scenario 1: New Project Vision

**Context:** First draft of vision for new project

**Review focus:**
- Is problem real and important?
- Are users specific enough?
- Is scope realistic for team?
- Are assumptions identified?

**Common issues:**
- Too ambitious scope
- Vague target users
- Unvalidated assumptions
- Missing "never in scope"

**Typical recommendation:**
Narrow scope, make users concrete, identify riskiest assumptions for validation

### Scenario 2: Pre-Planning Gate

**Context:** Vision exists, team wants to start planning

**Review focus:**
- Are boundaries clear enough for planning?
- Do success criteria enable roadmap priorities?
- Is technical approach feasible?
- Are all stakeholders aligned?

**Common issues:**
- Scope boundaries too vague
- Success criteria unmeasurable
- Technical assumptions untested

**Typical recommendation:**
Sharpen boundaries, define measurable criteria, validate technical approach before detailed planning

### Scenario 3: Quarterly Check-In

**Context:** Vision in use for 3-12 months

**Review focus:**
- Does vision still reflect reality?
- Have assumptions been validated or invalidated?
- Does scope need adjustment?
- Are metrics tracking as expected?

**Common issues:**
- Scope crept beyond original vision
- Assumptions proven wrong
- Metrics not captured or wrong

**Typical recommendation:**
Update based on learnings, adjust scope, refine metrics, document what changed and why

### Scenario 4: Vision Seems Ineffective

**Context:** Team experiencing misalignment or drift

**Review focus:**
- Is vision actually guiding decisions?
- Do team members know/remember it?
- Are there conflicting interpretations?
- Is it too vague to be useful?

**Common issues:**
- Feature list instead of outcomes
- Too vague to guide decisions
- Changed too often (no stability)
- Never communicated effectively

**Typical recommendation:**
Rewrite focusing on outcomes, make memorable, communicate repeatedly, establish stability commitment

## Review Best Practices

### Be Specific in Feedback

**Bad feedback:**
- "Vision is too vague"
- "Scope is unrealistic"
- "Users aren't clear"

**Good feedback:**
- "Vision statement 'make users happy' doesn't specify which users or what improvement. Suggest: 'Help solo developers maintain project context without documentation overhead'"
- "MVP includes 5 platforms (web, iOS, Android, desktop, CLI) but team is 1 developer with 6-month timeline. Suggest focusing on web-only for MVP"
- "Target users are 'developers' (too broad). Suggest specific persona: 'Solo developers building 2-3 concurrent projects with 10-20hrs/week available'"

### Focus on Fixable Issues

**Not helpful:**
- "You chose the wrong market"
- "This idea will never work"
- "You should build something else"

**Helpful:**
- "Current market assumption is unvalidated - suggest 10 customer interviews before planning"
- "MVP scope seems ambitious for 6 months - consider reducing to core feature only"
- "Vision locks into mobile app - suggest outcome framing to allow platform flexibility"

### Prioritize Issues

**P0 - Blocks planning:**
- Missing critical sections
- Unmeasurable success criteria
- Unrealistic scope for resources
- Major anti-patterns (mission confusion, feature list)

**P1 - Reduces effectiveness:**
- Vague language in key sections
- Unvalidated assumptions
- Minor anti-patterns
- Missing counter-metrics

**P2 - Nice to have:**
- Polish and clarity improvements
- Additional examples
- Format/structure enhancements

### Provide Examples

For every critique, offer concrete improvement example:

**Instead of:** "Vision statement is too feature-focused"

**Say:** "Vision statement 'Build a mobile app with AI analytics' is feature-focused. Consider outcome framing like: 'Enable sales teams to access customer insights instantly without returning to office'"

### Validate Understanding

Before critiquing, confirm you understand intent:

**Ask clarifying questions:**
- "Vision says 'revolutionize industry' - what specific outcome does this mean?"
- "Target users are 'professionals' - which professions specifically?"
- "Success metric is 'user happiness' - how will you measure this?"

## Critical Reminders

**DO:**
- Read full document before detailed critique
- Check for all required sections
- Apply quality criteria systematically
- Scan for common anti-patterns
- Provide specific, actionable feedback
- Include examples of improvements
- Prioritize issues by impact
- Recommend concrete next steps

**DON'T:**
- Reject vision because you'd build something different
- Focus on writing style over substance
- Nitpick minor issues while missing major problems
- Give vague feedback without examples
- Review only part of document
- Assume you know what they mean without asking
- Let personal preferences override quality criteria
- Recommend starting over without trying to fix first

## Reference Materials

For detailed examples and guidance:
- **references/review-examples.md** - Complete review examples showing different scenarios and issues
- **references/antipatterns-detailed.md** - Expanded anti-pattern catalog with recovery approaches
