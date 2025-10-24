# VISION.md Document Ontology

## Purpose

This document defines the structure, semantics, and validation rules for VISION.md files in the AI-augmented software development workflow. VISION.md is the **strategic foundation document** that guides all downstream planning and implementation decisions.

## Document Role in Workflow

```
VISION.md (strategic) → SCOPE.md (tactical) → ROADMAP.md (operational) → Specs → Implementation
```

**VISION.md is consumed by:**
- vision-reviewer (validates quality)
- scope-writer (creates SCOPE.md)
- roadmap-writer (creates ROADMAP.md)
- Human stakeholders (alignment and approval)

**VISION.md is created by:**
- vision-writer
- Human product owners/solo developers

**VISION.md lifecycle:**
- Created: At project inception
- Updated: Quarterly or when major learnings invalidate assumptions
- Archived: Old versions preserved when significant changes occur

## Document Structure

### Complete Canonical Structure

```markdown
# [Project Name] Vision

## Vision Statement
[1-2 sentences that pass the elevator test]

## Problem Statement

### Current State
[What problem exists today, who experiences it, why it matters]

### Desired Future State
[What the world looks like after success, how users' lives improve, success indicators]

## Target Users

### Primary Persona
**Name/Role:** [e.g., "Solo Developer Sarah"]
**Demographics:** [e.g., 25-40 years old, 5+ years experience]
**Current Behavior:** [How they solve this problem today]
**Jobs-to-be-Done:** [What they're trying to accomplish]
**Pain Points:** [Specific frustrations with current solutions]
**Decision Criteria:** [What makes them choose solutions]

### Secondary Personas (if applicable)
[Additional user types, lighter detail]

## Value Proposition

### Core Benefit
[What is the primary outcome improvement for users?]

### Differentiation
**Unlike** [primary competitive alternative],
**our product** [statement of primary differentiation]

**Why users will choose this:**
- [Unique advantage 1]
- [Unique advantage 2]

**Why advantage is sustainable:**
[What makes this defensible/hard to copy]

## Product Scope

### In Scope (MVP)
**Core Features:**
- [Feature 1: Brief description]
- [Feature 2: Brief description]

**Must-Have Capabilities:**
- [Capability 1]
- [Capability 2]

**Technical Requirements:**
- [Requirement 1]
- [Requirement 2]

### Future Scope
**Features for Later Versions:**
- [Deferred feature 1]
- [Deferred feature 2]

**Growth Considerations:**
- [How product might evolve]
- [Additional user segments]

### Never in Scope
**Explicit Exclusions:**
- [Thing we deliberately won't do]
- [User segment we won't target]
- [Problem we won't solve]

## Success Criteria

### Key Metrics
1. **[Metric Name]:** [Definition and target]
   - Current baseline: [X]
   - 6-month goal: [Y]
   - 1-year goal: [Z]

2. **[Metric Name]:** [Definition and target]
   - Current baseline: [X]
   - 6-month goal: [Y]
   - 1-year goal: [Z]

3. **[Metric Name]:** [Definition and target]
   - Current baseline: [X]
   - 6-month goal: [Y]
   - 1-year goal: [Z]

### Counter-Metrics (Guardrails)
- [What we won't sacrifice for growth]
- [Quality threshold we must maintain]

### Timeline Milestones
- **6 Months:** [Definition of success]
- **1 Year:** [Aspirational goal]
- **3 Years:** [Vision achievement markers]

## Technical Approach

### Technology Stack
**Frameworks:**
- [Framework 1 and rationale]

**Platforms:**
- [Platform 1 and rationale]

**Key Dependencies:**
- [Third-party service/tool]

### Architecture Principles
**Core Technical Decisions:**
- [Decision 1 and rationale]
- [Decision 2 and rationale]

**Key Constraints:**
- [Constraint 1]
- [Constraint 2]

### Known Risks
**Technical Challenges:**
- [Risk 1]: [Mitigation approach]
- [Risk 2]: [Mitigation approach]

## Assumptions and Constraints

### Market Assumptions
- [User behavior prediction]
- [Market size/growth expectation]
- [Competitive response scenario]

### Technical Assumptions
- [Feasibility assumption]
- [Available tools/platforms assumption]
- [Required skills assumption]

### Resource Constraints
**Time:**
- [Available hours per week]
- [Project duration expectation]

**Budget:**
- [Available funding/runway]
- [Cost constraints]

**Team:**
- [Solo developer or team size]
- [Available skills]

### Solo Developer Specific (if applicable)
**Personal Commitment:**
- Time available per week: [X hours]
- Planned duration: [Y months]
- Accountability mechanism: [How staying on track]

**Skills and Learning:**
- Skills I have: [List]
- Skills to develop: [List]
- Learning resources: [Courses, books, communities]

**Support Network:**
- Advisors: [Who can help]
- Accountability partners: [Who keeps you on track]

**Decision Authority:**
- How to make tough decisions: [Framework]
- When to pivot vs persevere: [Criteria]

## Open Questions

**Unresolved Decisions:**
- [Question 1 requiring resolution]

**Areas Needing Research:**
- [Research area 1]

**Risks Requiring Mitigation:**
- [Risk 1]: [What needs to happen]

**Hypotheses to Validate:**
- [Assumption 1 needing testing]

## Changelog

### Version [X.Y] - [Date]
**Changed:** [What changed]
**Reason:** [Why it changed]
**Impact:** [Effect on project/scope/timeline]

### Version 1.0 - [Date]
- Initial vision document created
```

## Section Semantics

### Vision Statement

**Purpose:** The memorable "north star" that guides all decisions.

**Content requirements:**
- Exactly 1-2 sentences (no more)
- Must mention target user (not just product)
- Must describe outcome/benefit (not features)
- Must be emotionally resonant and memorable
- Must be solution-agnostic (allows strategic pivots)

**Quality criteria:**
- Passes "elevator test" (easy to recall and repeat)
- Guides what NOT to build
- Customers recognize themselves in it
- Inspires rather than just informs

**Consumed by:**
- scope-writer: Validates scope alignment
- roadmap-writer: Ensures feature sequencing serves vision
- All stakeholders: Strategic alignment

**Examples:**
- ✓ "Help solo developers maintain project context across planning and execution without documentation overhead"
- ✗ "Build the best project management tool with AI and collaboration" (feature list)
- ✗ "Revolutionize the industry" (too vague)

### Problem Statement

**Purpose:** Establish the "why" - what problem we're solving and for whom.

**Content requirements:**

**Current State subsection:**
- Specific problem description (not generic)
- Who experiences this problem (link to Target Users)
- Quantified pain where possible (hours wasted, error rates, etc.)
- Root causes (not just symptoms)
- Why problem persists today (why hasn't someone solved it?)

**Desired Future State subsection:**
- Concrete improvement (measurable difference)
- How users' lives will be different
- What friction will be eliminated
- How to know when achieved (links to Success Criteria)

**Quality criteria:**
- Target users would recognize this description
- Root causes clear vs. just symptoms
- Future state measurably different from current
- Evidence that problem is real and important

**Consumed by:**
- scope-writer: Ensures scope addresses core problem
- roadmap-writer: Prioritizes features that solve problem

**Anti-patterns:**
- Vague complaints: "Users are frustrated" (with what specifically?)
- Solution in disguise: "Users need mobile app" (that's solution, not problem)
- No validation: No evidence problem is real
- Symptoms only: "Too many meetings" vs. root cause "context loss requiring synchronous alignment"

### Target Users

**Purpose:** Define specifically who this product serves.

**Content requirements:**

**Primary Persona (mandatory):**
- Name/role (makes it concrete and memorable)
- Demographics (just enough to target, not stereotype)
- Behavioral attributes (how they work, what they value)
- Current behavior (how they solve problem today)
- Jobs-to-be-done (what they're trying to accomplish)
- Pain points (specific frustrations, not generic)
- Decision criteria (what makes them choose solutions)

**Secondary Personas (optional):**
- Same structure as primary but lighter detail
- Clearly labeled as secondary priority

**Quality criteria:**
- Specific enough to recognize user in real life
- Clear who is NOT a target user (exclusions matter)
- Behavioral attributes beyond just demographics
- Concrete pain points you can validate

**Consumed by:**
- scope-writer: Validates scope serves target users
- roadmap-writer: Prioritizes features by user value

**Anti-patterns:**
- Too broad: "Everyone" or "all developers"
- Demographics only: "25-40 year olds" (no behavior)
- No exclusions: Can't tell who's NOT a target
- Generic: "Busy professionals who value efficiency"

### Value Proposition

**Purpose:** Articulate why users will choose this over alternatives.

**Content requirements:**

**Core Benefit:**
- Primary outcome improvement for users
- Both emotional and practical dimensions
- Focused on "how lives are improved" not "what product does"

**Differentiation:**
- Explicit competitive alternative (including "do nothing")
- Specific advantage vs. that alternative
- Why advantage matters to users
- Why advantage is sustainable/defensible

**Quality criteria:**
- Explains why users will choose this
- Addresses real alternatives (not strawmen)
- Advantage is meaningful to target users
- Sustainability/defensibility articulated

**Consumed by:**
- scope-writer: Ensures scope delivers unique value
- roadmap-writer: Sequences differentiating features appropriately

**Anti-patterns:**
- Feature list without benefits: "Has X, Y, Z capabilities"
- Generic superiority: "Better, faster, cheaper" without specifics
- Ignoring alternatives: No mention of what users use today
- Easily copied: Advantage with no defensibility

### Product Scope

**Purpose:** Define boundaries - what's included, deferred, and excluded.

**This section is CRITICAL for scope-writer.**

**Content requirements:**

**In Scope (MVP):**
- Core features delivering primary value (3-7 features typical)
- Must-have capabilities (what users can do)
- Technical requirements (infrastructure, integrations)
- Should be achievable within resource constraints
- Level: Capabilities, not detailed specs

**Future Scope:**
- Features for later versions (explicit deferrals)
- Growth considerations (how product might evolve)
- Additional user segments (potential expansion)
- Level: High-level, may change based on MVP learnings

**Never in Scope:**
- Explicit exclusions (what we deliberately won't do)
- User segments we won't target
- Problems we won't solve
- Prevents scope creep by making exclusions explicit

**Quality criteria:**
- MVP is minimal (no nice-to-haves)
- "Never in Scope" prevents common scope creep
- Clear boundaries enable realistic planning
- Future scope acknowledges desires without committing

**Consumed by:**
- scope-writer: Primary input - transforms this into detailed SCOPE.md
  - "In Scope (MVP)" → SCOPE.md "In Scope - MVP" section
  - "Future Scope" → SCOPE.md "In Scope - Future Phases"
  - "Never in Scope" → SCOPE.md "Explicitly Out of Scope"
- roadmap-writer: Secondary input - validates roadmap doesn't exceed scope

**Transformation to SCOPE.md:**
Vision's high-level features → Scope's concrete deliverables

**Example:**
- **Vision**: "Lightweight specification format"
- **Scope**: "Markdown-based spec templates, CLI command to create specs, validation to check completeness, examples in documentation"

**Anti-patterns:**
- Everything in "In Scope" with nothing deferred
- No "Never in Scope" section
- MVP too ambitious for resources
- Detailed specifications (too granular for vision)

### Success Criteria

**Purpose:** Define measurable outcomes that prove vision is achieved.

**This section is CRITICAL for both scope-writer and roadmap-writer roles.**

**Content requirements:**

**Key Metrics:**
- 3-5 specific, measurable metrics
- Each metric must have:
  - Definition (what it measures)
  - Current baseline (where we are now)
  - 6-month goal
  - 1-year goal
  - 3-year goal (optional for longer visions)
- Metrics should measure value delivered, not vanity
- Metrics should align with problem solved

**Counter-Metrics (Guardrails):**
- 2-3 metrics that ensure quality isn't sacrificed
- What we won't compromise for growth
- Quality thresholds we must maintain

**Timeline Milestones:**
- 6-month definition of success
- 1-year aspirational goal
- 3-year vision achievement markers
- These guide phase duration in roadmap

**Quality criteria:**
- Metrics measure actual value delivered to users
- Metrics can't be easily gamed
- Counter-metrics prevent harmful optimization
- Timelines are realistic for stated scope
- Metrics prove the problem is solved

**Consumed by:**
- scope-writer: Ensures scope enables measuring these metrics
- roadmap-writer: Uses timeline milestones to plan phase durations
  - **6-month milestone** → Influences MVP completion target
  - **1-year milestone** → Guides Phase 2+ planning
  - **3-year milestone** → Validates long-term strategic alignment

**Anti-patterns:**
- Vanity metrics: "1M users" without retention
- Unmeasurable: "Make users happy"
- No counter-metrics: Growth without guardrails
- Unrealistic timelines: 6 months to achieve 3-year vision
- Metrics don't measure problem solved

### Technical Approach

**Purpose:** Document technology choices and architectural principles.

**Content requirements:**

**Technology Stack:**
- Frameworks and why chosen
- Platforms and rationale
- Key third-party dependencies
- Infrastructure requirements

**Architecture Principles:**
- Core technical decisions and rationale
- Key constraints (performance, security, scalability)
- Trade-offs acknowledged

**Known Risks:**
- Technical challenges identified
- Mitigation approaches for each
- Areas requiring proof-of-concept

**Quality criteria:**
- Decisions have clear rationale
- Constraints are realistic
- Risks are identified early
- Enough detail for feasibility assessment
- Not so detailed that it constrains implementation

**Consumed by:**
- scope-writer: Informs technical requirements in SCOPE.md
- roadmap-writer: Identifies technical dependency order

**Anti-patterns:**
- Too detailed: Specifies algorithms, data structures
- Too vague: "Use modern cloud technology"
- No rationale: Decisions without "why"
- Ignores constraints: Assumes ideal conditions

### Assumptions and Constraints

**Purpose:** Make implicit assumptions explicit and document real constraints.

**This section is CRITICAL for scope-writer.**

**Content requirements:**

**Market Assumptions:**
- User behavior predictions
- Market size and growth expectations
- Competitive response scenarios
- Technology trend dependencies

**Technical Assumptions:**
- Feasibility assumptions (can we build this?)
- Available tools/platforms assumptions
- Required skills assumptions
- Integration complexity estimates

**Resource Constraints:**
- Time: Available hours per week, duration
- Budget: Available funding, cost limits
- Team: Size, composition, skills

**Solo Developer Specific (if applicable):**
- Personal commitment (time, accountability)
- Skills and learning (have vs. need)
- Support network (advisors, community)
- Decision authority (how to make calls)

**Quality criteria:**
- All major assumptions explicitly stated
- Riskiest assumptions identified
- Constraints are realistic (not optimistic)
- Clear what happens if assumptions invalid

**Consumed by:**
- scope-writer: Primary input - carries these over to SCOPE.md
  - Resource constraints → SCOPE.md "Resource Constraints"
  - Technical assumptions → SCOPE.md "Technical Constraints"
  - Market assumptions → SCOPE.md "Assumptions" section
- roadmap-writer: Validates phasing is realistic given constraints

**Anti-patterns:**
- No assumptions listed (everything treated as fact)
- Assumptions without validation plans
- Optimistic constraints (ignoring reality)
- Technical feasibility assumed without verification

### Open Questions

**Purpose:** Acknowledge unresolved decisions and areas needing research.

**Content requirements:**
- Unresolved decisions requiring resolution
- Areas needing research before planning
- Risks requiring mitigation strategies
- Hypotheses needing validation

**Quality criteria:**
- Honest about what's unknown
- Clear what needs to happen to resolve
- Prioritized (which questions block progress)

**Consumed by:**
- scope-writer: Identifies areas needing clarification
- roadmap-writer: May influence phase sequencing (validate assumptions early)

### Changelog

**Purpose:** Track how vision evolves over time and why.

**Content requirements:**
- Version number and date
- What changed (specific sections/content)
- Reason for change (why it changed)
- Impact (effect on project/scope/timeline)

**Quality criteria:**
- Every significant change documented
- Rationale captured (not just what changed)
- Impact on downstream documents noted

**Consumed by:**
- All roles: Understanding evolution of thinking
- Stakeholders: Transparency on strategic changes

## Cross-Document References

### VISION.md References Other Documents

**None** - Vision is the root document with no upstream dependencies.

### Other Documents Reference VISION.md

**SCOPE.md references:**
- Vision statement (copied into "Vision Alignment" section)
- Product scope (transformed into detailed scope sections)
- Success criteria (informs acceptance criteria)
- Assumptions/constraints (carried over)

**ROADMAP.md references:**
- Vision statement (copied into "Alignment" section)
- Success criteria (especially timeline milestones)
- Target users (for feature prioritization)

**Feature specs reference:**
- Vision statement (to validate alignment)
- Target users (to ensure features serve them)
- Success criteria (to validate feature contributes)

## Validation Rules

### Mandatory Sections

**Must have:**
- Vision Statement
- Problem Statement (Current State + Desired Future State)
- Target Users (at least Primary Persona)
- Value Proposition (Core Benefit + Differentiation)
- Product Scope (In Scope MVP + Future + Never)
- Success Criteria (Key Metrics + Timeline Milestones)
- Technical Approach
- Assumptions and Constraints
- Open Questions
- Changelog

**Optional but recommended:**
- Secondary Personas
- Solo Developer Specific sections

### Section Completeness Rules

**Vision Statement:**
- Must be 1-2 sentences (no more)
- Must be customer-focused (mention user)
- Must be outcome-oriented (not features)

**Problem Statement:**
- Current State: Minimum 2-3 sentences with specifics
- Desired Future State: Minimum 1-2 sentences with measurable difference

**Target Users:**
- Primary Persona must have all 7 subsections
- Each subsection: Minimum 1-2 sentences

**Product Scope:**
- In Scope (MVP): Minimum 3 features
- Never in Scope: Minimum 2 exclusions (no empty section)

**Success Criteria:**
- Key Metrics: Minimum 3 metrics
- Each metric must have baseline + 6mo + 1yr goals
- Timeline Milestones: Must include 6-month and 1-year (3-year optional)

**Assumptions and Constraints:**
- Must include Resource Constraints subsection
- Resource Constraints must specify: Team, Time, Budget

### Cross-Document Consistency

**When VISION.md changes:**
- SCOPE.md must be reviewed for alignment
- ROADMAP.md must be reviewed for timeline changes
- Changelog must document impact on downstream docs

**Validation checks:**
- Scope features trace to Vision "In Scope (MVP)"
- Roadmap phases align with Vision "Timeline Milestones"
- Success metrics in Scope match Vision metrics

## Version Control and Change Management

### When to Update VISION.md

**Mandatory updates:**
- Major market shifts (competitor launches, regulation changes)
- Significant user feedback contradicting assumptions
- Technical feasibility discoveries requiring pivots
- Resource changes affecting timeline or scope

**Discretionary updates:**
- Quarterly reviews revealing minor misalignments
- Clarifications that don't change direction
- Additional context from learnings

**Red flags (update too frequently):**
- Changing vision statement more than once per year
- Updating "In Scope" monthly (signals instability)
- Constant changes signal lack of commitment

### Update Process

1. **Identify need for change** (checkpoint review or learning)
2. **Document proposed change** with rationale
3. **Assess impact** on downstream documents
4. **Update VISION.md** with new version number
5. **Add changelog entry** (what, why, impact)
6. **Archive old version** (VISION-v1-2024.md)
7. **Review downstream docs** (SCOPE.md, ROADMAP.md) for needed updates
8. **Communicate changes** to stakeholders and team

### Version Numbering

**Major version (X.0):**
- Vision statement changes
- Target user changes
- Fundamental strategy changes

**Minor version (X.Y):**
- Scope adjustments
- Success criteria refinements
- Assumption validations/updates

### Archival

**When creating new major version:**
- Archive old version: `VISION-v1-2024.md`
- Keep in repository (don't delete)
- Update references in other documents
- Changelog in new version explains changes

## Common Patterns

### Solo Developer Vision

**Characteristics:**
- Emphasizes sustainability and resource realism
- Includes "Solo Developer Specific" subsections
- MVP scope is very minimal (one platform, core features only)
- Timeline accounts for part-time work (10-20 hrs/week)
- Support network and decision frameworks documented

### Team Product Vision

**Characteristics:**
- Multiple user personas (primary + secondary)
- Larger MVP scope (can parallelize work)
- More ambitious timeline milestones
- Business constraints more prominent
- Stakeholder alignment section more detailed

### Internal Tool Vision

**Characteristics:**
- Problem quantified with concrete metrics (hours wasted, error rates)
- Target users are colleagues (easier validation)
- Success criteria focus on efficiency gains
- MVP scope very focused (solve one pain point well)
- Often minimal "Future Scope" (done when problem solved)

### Platform Vision

**Characteristics:**
- Two-sided value proposition (platform + applications)
- Success criteria include ecosystem metrics
- Future scope emphasizes extensibility
- Technical approach more detailed (API design critical)

## Integration with Roles

### vision-writer creates VISION.md

**Process:**
1. Collaborative conversation exploring problem space
2. Crafts vision statement
3. Defines users, value prop, scope
4. Specifies success criteria
5. Documents assumptions
6. Outputs complete VISION.md

### vision-reviewer validates VISION.md

**Checks:**
- Structural completeness (all sections present)
- Section quality (vision statement passes tests, etc.)
- Anti-pattern detection (feature list syndrome, etc.)
- Readiness for downstream use

**Validates specifically:**
- Product Scope section structured correctly for scope-writer
- Success Criteria includes Timeline Milestones for roadmap-writer
- Assumptions/Constraints detailed enough for scope-writer

### scope-writer consumes VISION.md

**Reads:**
- Vision statement → Copies to SCOPE.md alignment section
- Product Scope → Transforms into detailed scope sections
- Success Criteria → Informs acceptance criteria
- Assumptions/Constraints → Carries over to SCOPE.md

**Stops if:**
- Product Scope section missing or incomplete
- Success Criteria missing metrics
- Assumptions/Constraints too vague

### roadmap-writer consumes VISION.md

**Reads:**
- Vision statement → Copies to ROADMAP.md alignment
- Success Criteria → Uses Timeline Milestones for phase planning
- Target Users → For feature value prioritization

**Stops if:**
- Timeline Milestones missing from Success Criteria
- Target Users too vague to prioritize features

## Anti-Patterns to Avoid

### In Vision Document Creation

**Feature List as Vision:**
- Vision statement lists capabilities: "Build platform with X, Y, Z"
- Fix: Focus on customer outcomes, not features

**Mission Confusion:**
- Vision is too broad: "Make the world better"
- Fix: Product-specific, time-bound (2-5 years), measurable

**Solution Lock-In:**
- Vision commits to technology: "Build mobile app for..."
- Fix: Outcome-oriented: "Enable users to... anywhere"

**Vague Aspirations:**
- No concrete meaning: "Revolutionize industry"
- Fix: Specific outcomes: "Reduce time from 40hrs to 2hrs"

**No Boundaries:**
- Everything in scope, nothing excluded
- Fix: Explicit "Never in Scope" section

**Vanity Metrics:**
- Success criteria: "1M users"
- Fix: Value metrics: "Users reduce task time by 80%"

### In Vision Document Usage

**Treating as Immutable:**
- Never updating despite learnings
- Fix: Quarterly reviews, update based on evidence

**Updating Too Frequently:**
- Vision changes monthly
- Fix: Vision should be stable, strategy can change

**Ignoring Downstream:**
- Updating vision without reviewing SCOPE.md, ROADMAP.md
- Fix: Change management process updates all affected docs

**Allowing Drift:**
- Scope and roadmap diverge from vision over time
- Fix: Regular alignment checks at phase boundaries

## Example Vision Documents

See vision-writer assets for complete examples:
- Full SaaS product vision (DevContext)
- Minimal internal tool vision (Data Pipeline Monitor)

## Related Documents

- **SCOPE.md Ontology** - Defines scope document structure
- **ROADMAP.md Ontology** - Defines roadmap document structure
- **vision-writer** - Creates VISION.md documents
- **vision-reviewer** - Validates VISION.md quality
- **scope-writer** - Consumes VISION.md to create SCOPE.md
- **roadmap-writer** - Consumes VISION.md (+ SCOPE.md) to create ROADMAP.md

## Document Metadata

**Version:** 1.0  
**Created:** 2025-10-22  
**Purpose:** Define canonical structure for VISION.md in AI-augmented development workflow  
**Audience:** Roles (vision-writer, vision-reviewer, scope-writer, roadmap-writer), human developers  
**Maintainer:** Workflow design team
