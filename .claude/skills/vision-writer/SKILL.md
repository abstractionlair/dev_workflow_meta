---
name: vision-writer
description: Create effective product visions for software projects. Use when starting a new project, clarifying strategic direction, or creating VISION.md documents that define why a project exists, who it serves, what problems it solves, and what success looks like over a 2-5 year horizon.
---

# Vision Writer

## Overview

Create product visions that provide strategic direction and prevent common failures like feature-focused thinking, architecture amnesia, and premature abandonment. This skill guides the creation of vision documents that focus on customer outcomes rather than features, remain stable while strategy evolves, and include concrete success criteria.

## When to Use This Skill

**Trigger scenarios:**
- Starting a new software project or product
- User asks to create a VISION.md document
- Project lacks clear strategic direction
- Team experiencing scope creep or misalignment
- Need to clarify "why" before "what" or "how"
- Solo developer planning a sustainable long-term project

**Do NOT use for:**
- Feature specifications (those come after vision)
- Project management or task planning
- Technical architecture decisions (vision is product-focused)
- Marketing copy or sales materials

## Vision Creation Workflow

### 1. Understand the Problem Space

Before writing anything, explore fundamentals through questions:

**Customer understanding:**
- Who experiences this problem? (Specific beyond demographics)
- What triggers their need? (Jobs-to-be-done)
- What do they do today? (Current alternatives)
- Why do current solutions fail? (Root causes)
- What would "meaningfully better" look like?

**Market context:**
- Why now? (What changed to make this solvable?)
- What alternatives exist including "do nothing"?
- What's the market size and trajectory?
- What makes this defensible?

**For solo developers:**
- Why are you the right person?
- What's your realistic time commitment?
- What constraints must the vision respect?

### 2. Craft the Vision Statement

Create one sentence that passes the elevator test:

**Good characteristics:**
- Customer-focused (mentions user, not product)
- Outcome-oriented (describes improved state, not features)
- Emotionally resonant (inspires, doesn't just inform)
- Solution-agnostic (allows strategic pivots)
- Memorable (can be recalled and repeated)

**Template options:**
- "Help [target users] [achieve outcome] by [unique approach]"
- "Enable [user group] to [job-to-be-done] without [current friction]"

**Common pitfalls to avoid:**
- âœ— Feature lists: "Build a platform with X, Y, Z"
- âœ— Mission confusion: "Organize all the world's information" (too broad)
- âœ— Vague aspirations: "Make people happy" (not specific enough)
- âœ— Solution lock-in: "The best mobile app for..." (constrains approach)

### 3. Define Target Users and Problem

**User definition includes:**
- Demographics (just enough to target)
- Behavioral attributes (how they currently solve problems)
- Jobs-to-be-done (what they're trying to accomplish)
- Pain points (specific frustrations)

**Problem articulation:**
- Current state reality
- Root causes (why the problem persists)
- Desired future state
- Success indicators

### 4. Specify Value Proposition and Differentiation

**Value proposition:**
- Primary benefit (main outcome improvement)
- Emotional dimension (how users will feel different)
- Practical advantage (concrete capability improvement)

**Differentiation using Geoffrey Moore's template:**
"Unlike [primary competitive alternative], our product [statement of primary differentiation]"

### 5. Define Scope Boundaries

**MVP scope:** Core features delivering primary value
**Future scope:** Features deferred to later versions
**Never in scope:** Explicit exclusions to prevent scope creep

### 6. Specify Success Criteria

**Metrics:**
- Usage adoption (MAU, DAU, retention)
- Value delivery (task completion, time saved)
- Business impact (revenue, growth, market penetration)

**Counter-metrics as guardrails:**
- What you won't sacrifice for growth
- Quality thresholds to maintain

**Timeline milestones:**
- 6-month definition of success
- 1-year aspirational goals
- 3-year vision achievement markers

### 7. Document Assumptions and Risks

Make implicit assumptions explicit:
- Market assumptions (user behavior, market size)
- Technical assumptions (feasibility, available tools)
- Resource assumptions (time, budget, skills)
- Open questions requiring validation

## VISION.md Document Structure

Create in project root with this structure:

```markdown
# [Project Name] Vision

## Vision Statement
[One sentence that passes elevator test]

## Problem Statement
### Current State
[What problem exists, who experiences it, why it matters]

### Desired Future State
[What success looks like, how users' lives improve]

## Target Users
### Primary Persona
[Detailed description with demographics, behaviors, jobs-to-be-done]

## Value Proposition
### Core Benefit
[Primary outcome improvement]

### Differentiation
[What makes this unique vs. alternatives]

## Product Scope
### In Scope (MVP)
[Core features, must-have capabilities]

### Future Scope
[Features for later versions]

### Never in Scope
[Explicit exclusions and boundaries]

## Success Criteria
### Key Metrics
[3-5 quantitative measures]

### Counter-Metrics
[Guardrails preventing harmful optimization]

### Timeline Milestones
[6-month, 1-year, 3-year definitions]

## Technical Approach
### Technology Stack
[Frameworks, platforms, key dependencies]

### Architecture Principles
[Core technical decisions]

## Assumptions and Constraints
### Market Assumptions
### Technical Assumptions
### Resource Constraints

## Open Questions
[Unresolved decisions, research needs]

## Changelog
[Version history and major updates]
```

**Length guidelines:**
- Vision statement: 1-2 sentences
- Problem statement: 1-2 paragraphs
- Total document: 3-7 pages typical, 10-15 for complex products

## Key Principles

### Focus on Outcomes, Not Features

âœ" "Help teams maintain context across planning and execution"
âœ— "Build a dashboard with real-time analytics"

### Make It Memorable

If people can't remember and repeat it, it won't guide decisions.

### Validate Assumptions

**Validation approaches:**
- Jobs-to-be-done interviews (10-20 potential customers)
- Prototype testing (paper mockups → MVP)
- Metric baselines (establish current state)

### Balance Ambition with Feasibility

Vision should stretch without breaking:
- Challenging enough to matter
- Feasible enough to maintain belief
- Specific enough to guide decisions
- Flexible enough to allow pivots

### Solo Developer Considerations

**Sustainability checklist:**
- Time commitment realistic given other obligations?
- Scope achievable as one person?
- Skills within capability or clear learning path?
- Personally compelling enough to sustain years?

**Ruthless prioritization:**
- 70% solutions ship, perfect solutions stagnate
- One Metric That Matters for current stage
- Explicit "not doing" list

## Common Pitfalls to Avoid

**Architecture Amnesia from Day One**
- Write vision FIRST before any code
- Even rough initial vision prevents divergent understanding

**Confusing Vision with Mission**
- Mission: "Organize the world's information" (broad, timeless)
- Vision: "Help researchers find papers 10x faster" (specific, time-bound)

**Feature List Masquerading as Vision**
- Bad: "Platform with AI analytics, real-time collaboration, mobile apps"
- Good: "Enable teams to make evidence-based decisions in minutes vs. weeks"

**Giving Up Too Soon**
- Meaningful visions require 2-5 years to achieve
- Expect pivots in approach, but stability in destination

**Updating Too Frequently**
- Vision statement: Rarely (once in 2-3 years)
- Scope boundaries: Regularly (quarterly adjustments)

## Examples

### Example 1: Solo Developer SaaS

**Vision Statement:**
"Help solo developers maintain project context across planning and execution without drowning in documentation overhead"

**Problem:**
Solo developers lose critical context when switching between planning documents and implementation. They spend 20-30% of time reconstructing "why" decisions were made.

**Target Users:**
Solo developers building 1-3 concurrent projects with 10-20 hours/week available, frustrated by context loss after breaks.

**MVP Scope (3 months):**
- Lightweight specification format (Markdown)
- Git integration for version control
- Context linking between specs/tests/code
- CLI interface
- Living document maintenance

**Success Metrics:**
- Time to answer "why does this exist?" <30 seconds (currently 30-60 min)
- 100 active users within 6 months
- 60% retention after 3 months

### Example 2: Internal Tool (Minimal)

**Vision Statement:**
"Give data team instant visibility into pipeline health without manual log checking"

**Problem:**
Data engineers spend 2-3 hours daily checking if pipelines succeeded. Pipelines fail silently until someone notices.

**MVP Scope (4 weeks):**
- Real-time status dashboard
- Slack alerts on failures with logs
- Dependency graph visualization

**Success Metrics:**
- Mean time to detect failures <5 min (currently 2+ hours)
- 80% of failures debuggable from dashboard
- Zero Slack escalations asking "did my pipeline run?"

## Frameworks Reference

For deeper guidance on specific frameworks and patterns, see:
- **references/frameworks.md** - Detailed coverage of Geoffrey Moore elevator pitch, Roman Pichler Vision Board, Amazon PR/FAQ, Lean Canvas
- **references/antipatterns.md** - Extended examples of failed visions and how to avoid them

## Maintaining Vision as Living Document

**Review cadences:**
- Weekly quick checks (5-10 min): Alignment verification
- Monthly reviews (1-2 hours): Metrics and assumptions
- Quarterly reviews (half day): Major reassessment
- Annual refresh (1-2 days): Comprehensive update

**Mandatory update triggers:**
- Major market shifts (competitor launches, regulation)
- User feedback contradicting assumptions
- Technical feasibility discoveries requiring pivots
- Resource changes affecting timeline

**Version control:**
- Maintain VISION.md in Git
- Archive old versions: VISION-v1-2024.md
- Changelog captures: what changed, why, impact

## Critical Reminders

**DO:**
- Write vision BEFORE any code or specs
- Focus on customer outcomes, not features
- Make assumptions explicit for validation
- Keep vision statement to 1-2 sentences
- Validate riskiest assumptions early
- Maintain as living document with reviews

**DON'T:**
- Confuse vision with mission or strategy
- List features instead of outcomes
- Skip user validation
- Update too frequently (signals lack of commitment)
- Create vision too ambitious for resources
