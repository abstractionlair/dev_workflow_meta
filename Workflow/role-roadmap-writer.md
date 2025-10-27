---
role: Roadmap Writer
trigger: After VISION.md and SCOPE.md are approved, before specification begins
typical_scope: One project roadmap
dependencies: ["VISION.md", "SCOPE.md"]
outputs: ["ROADMAP.md"]
gatekeeper: false
state_transition: "scope/approved → roadmap/proposed"
---

# Roadmap Writer

*For standard role file structure, see [role-file-structure.md](patterns/role-file-structure.md).*

## Purpose

Produce a **ROADMAP.md** document that sequences features from scope into phases that balance value delivery, risk mitigation, and learning. See [schema-roadmap.md](schema-roadmap.md) for the complete document structure and all required sections.

The roadmap converts scope boundaries into actionable feature sequences that maximize learning velocity, derisk assumptions early, and deliver value incrementally while maintaining strategic alignment.

## When to Use This Role

**Activate when:**
- Have approved VISION.md and SCOPE.md, need to sequence work
- User asks to create ROADMAP.md document
- Need to prioritize features across multiple phases
- Planning which features to build in what order
- Stakeholders need visibility into delivery timeline

**Do NOT use for:**
- Detailed sprint/iteration planning (too granular)
- Task breakdown and estimation (that's in specs)
- Technical architecture decisions (belongs in system design)
- Vision or scope creation (use other roles)

## Collaboration Pattern

This is typically a **collaborative role** - a conversation between human and agent that produces a document.

**Agent responsibilities:**
- Read and synthesize VISION.md and SCOPE.md
- Propose feature sequencing based on value, risk, and dependencies
- Identify technical dependencies between features
- Suggest derisking strategies for assumptions
- Challenge unrealistic timelines
- Ensure phases are cohesive and deliverable

**Human responsibilities:**
- Provide VISION.md and SCOPE.md as inputs
- Clarify technical dependencies
- Validate risk assessment
- Make final prioritization decisions
- Confirm timeline expectations are realistic
- Approve roadmap before spec work begins

## Inputs

**From VISION.md (required):**
- Vision statement (to ensure roadmap serves strategic direction)
- Target users (to prioritize features by user value)
- Success criteria (to sequence toward measurable outcomes)
- Timeline milestones (to understand delivery expectations: 6mo/1yr/3yr)

**From SCOPE.md (required):**
- In Scope - MVP (features to sequence in roadmap)
- In Scope - Future Phases (post-MVP features to plan)
- Explicitly Out of Scope (to avoid including excluded items)
- Constraints and Assumptions (to plan realistically)
- Success Criteria (to know what "done" looks like)

**From stakeholders/team:**
- Technical dependencies (what must be built before what)
- Riskiest assumptions (what to validate first)
- Team velocity or capacity (if known)
- Market timing constraints (deadlines that matter)
- Early access user availability (for validation)

**If vision or scope are unclear, stop and clarify them first.**

## What Roadmaps Do

**Primary purposes:**
1. **Sequence features** - What to build in what order
2. **Derisk early** - Validate riskiest assumptions first
3. **Deliver value** - Get user value as soon as possible
4. **Enable learning** - Build in feedback loops
5. **Communicate plans** - Align stakeholders on timing

**Roadmap is NOT:**
- Project schedule with dates (too detailed, changes too often)
- Commitment to specific features (must stay flexible)
- Complete feature specifications (those come next)
- Sprint backlog (too operational)

## Process

### Step 1: Extract and Synthesize Inputs

Read VISION.md and SCOPE.md completely.

**From VISION.md, extract:**
- Vision statement
- Target users (who are we serving?)
- Success criteria with timeline milestones
- Riskiest assumptions

**From SCOPE.md, extract:**
- All MVP features
- All future phase features
- Constraints (timeline, resources, technical)
- Success criteria for MVP

**Create mental model:**
- What's the core value proposition?
- Who are primary users?
- What's the timeline pressure?
- What are biggest risks/unknowns?

### Step 2: Identify Dependencies

Determine technical dependencies between features.

**Dependency types:**

**Hard dependencies (must build before):**
- "Feature B requires Feature A's infrastructure"
- "Feature C uses Feature A's API"
- Example: User auth must come before user profiles

**Soft dependencies (easier if built before):**
- "Feature B benefits from Feature A's groundwork"
- "Feature B shares code with Feature A"
- Example: Search benefits from existing data models

**No dependency:**
- Features can be built in parallel or any order
- Example: Import feature independent from export feature

**Document dependencies:**
For each feature, ask:
- What must exist before this can be built?
- What does this enable downstream?
- Can this be built standalone?

### Step 3: Assess Risk and Learning Value

Identify which features derisk critical assumptions vs. which are low-risk.

**High-risk features (validate early):**
- Tests unvalidated assumptions from VISION/SCOPE
- New/unfamiliar technology
- Complex integrations with external systems
- Core value proposition (if wrong, vision fails)
- Performance-critical components

**Low-risk features (can defer):**
- Well-understood patterns
- Polish and refinement
- Optional enhancements
- Similar to things you've built before

**Learning value:**
- Features that teach you about users: HIGH priority early
- Features that validate technical approach: HIGH priority early
- Features that are nice-to-have: LOW priority

**Example risk assessment:**

**High risk (build early):**
- AI-powered context generation (unproven, core value)
- Git integration (complex, uncertain effort)
- Link validation engine (new algorithm, performance critical)

**Low risk (build later):**
- Configuration file support (standard patterns)
- Color-coded output (polish)
- Additional CLI flags (incremental additions)

### Step 4: Determine Value Delivery Sequence

Sequence features to deliver user value as soon as possible.

**Value delivery principles:**

**1. Core value first:**
- What's the minimum to deliver on vision statement?
- What proves the concept works?
- What would users pay for (if commercial)?

**2. Complete user journeys:**
- Don't build half a workflow
- Ensure end-to-end usability
- Example: Create + Edit + Delete, not just Create

**3. Incremental value:**
- Each phase should be usable on its own
- Not just "infrastructure" phases
- Users can accomplish real tasks after each phase

**4. Feedback opportunities:**
- Early phases enable user feedback
- Learn before building too much
- Validate assumptions with real usage

**Example value sequencing:**

**Phase 1 (Core MVP):**
- Spec creation/editing (core workflow)
- Basic validation (quality gate)
- File storage (persistence)
→ Users can manage specs end-to-end

**Phase 2 (Enhanced MVP):**
- Link detection (value multiplier)
- Cross-reference navigation (usability)
- Status reporting (visibility)
→ Users get connected context benefits

**Phase 3 (Scale):**
- Import existing docs (migration)
- Export/sharing (collaboration)
- Advanced validation (quality)
→ Users can adopt at scale

### Step 5: Define Phases

Group features into cohesive phases with clear goals.

**Phase definition criteria:**

**Phase 0 (Foundation):**
- Core infrastructure needed before any features
- Should be minimal (don't overengineer)
- Examples: CLI framework, config system, file handling
- Duration: ~10-15% of total timeline

**Phase 1 (MVP):**
- Minimum to deliver core value proposition
- Complete user journeys (end-to-end)
- High-risk technical assumptions validated
- User-testable and valuable
- Duration: ~30-40% of total timeline

**Phase 2 (Enhanced MVP):**
- Features that multiply MVP value
- Address top user feedback from Phase 1
- Derisk remaining technical concerns
- Make MVP production-ready
- Duration: ~25-30% of total timeline

**Phase 3+ (Growth/Scale):**
- Expansion features from future scope
- Performance optimization
- Additional user segments
- Integrations and ecosystem
- Duration: Remaining timeline

**Phase cohesion tests:**
- Can you demo this phase standalone?
- Does it have a clear goal/theme?
- Is it deliverable in one unit of time (sprint/month/quarter)?
- Does it set up the next phase?

### Step 6: Establish Timeline Milestones

Map phases to vision's timeline expectations.

**From VISION.md success criteria:**
Extract timeline milestones (e.g., 6 months, 1 year, 3 years)

**Standard milestone-to-phase mapping:**

**6-month milestone → Phase 1 (MVP)**
- Core value delivered
- Riskiest assumptions validated
- User-testable product

**1-year milestone → Phase 2 (Enhanced MVP)**
- Production-ready
- Top user feedback addressed
- Market-ready if commercial

**3-year milestone → Phases 3+ (Growth)**
- Platform maturity
- Ecosystem development
- Market leadership

**When milestones don't align with natural phases:**

**Problem:** VISION says "6-month milestone" but Phase 1 realistically needs 9 months.

**Solutions:**

**Option 1: Negotiate milestone** (preferred if vision still draft)
- Flag timing concern to vision stakeholders
- Provide evidence: feature list, team velocity, risk assessment
- Propose updated milestone in VISION.md
- Example: "6-month goal not achievable with solo dev. Recommend 9-month first milestone."

**Option 2: Reduce scope** (if milestone is firm)
- Identify sub-MVP that fits timeline
- Document what's deferred to Phase 1b
- Ensure sub-MVP still delivers meaningful value
- Example: "Phase 1a (6mo): Create/edit only. Phase 1b (9mo): Add search."

**Option 3: Accept mismatch and document** (if neither flexible)
- Clearly state in ROADMAP.md: "Phase 1 extends beyond 6-month milestone"
- Explain rationale (technical complexity, team size, dependencies)
- Provide checkpoint at 6-month mark (demo, user feedback)
- Example: "Phase 1 MVP targets 9mo. At 6mo checkpoint: working prototype for user testing."

**Option 4: Add interim checkpoints**
- Break Phase 1 into Phase 1a, 1b, 1c
- Map checkpoints to vision milestones
- Each checkpoint delivers demoable value
- Example: "Phase 1a (6mo): Core features. Phase 1b (9mo): Complete MVP."

**Key principle:** Better to extend timeline than cut core features or skip risk mitigation.

**Red flags requiring milestone adjustment:**
- Phase 1 scope > 50% of first milestone time
- Solo developer with <20 hrs/week availability
- Novel technology requiring learning curve
- External dependencies outside your control
- Team members with <50% allocation

**Reality check questions:**
- Does phase scope fit timeline realistically?
- Is team velocity realistic (not aspirational)?
- Have you included buffer (20% recommended)?
- What if something is harder than expected?
- What if someone is unavailable (vacation, sick)?
- Have you accounted for non-coding time (planning, debugging, docs)?

### Step 7: Document Sequencing Rationale

Explain WHY features are sequenced this way.

**For each phase, document:**

**What:** List of features in this phase

**Why now:** Rationale for sequencing
- Dependencies on prior phases
- Risk mitigation needs
- Value delivery pattern
- Learning goals

**Why not earlier:** What blocked earlier inclusion
- Technical dependencies
- Need MVP validation first
- Resource constraints

**Why not later:** What pushes it into this phase
- High risk (must derisk)
- Core value (needed for MVP)
- User demand (feedback-driven)

**Example rationale:**

**Phase 1: Link detection included**
- Why now: Core value prop is context linking
- Why not earlier: Needs spec management working first (dependency)
- Why not later: High risk (novel algorithm), need to validate early

### Step 8: Create ROADMAP.md Document

Create the complete ROADMAP.md file following [schema-roadmap.md](schema-roadmap.md) structure.

**During roadmap creation:**
1. Start with [schema-roadmap.md](schema-roadmap.md) Required Structure section for section templates
2. Reference inline examples in schema for each section pattern
3. Ensure all phases have complete 6-field feature entries
4. Before completion: Verify with [checklist-ROADMAP.md](checklists/checklist-ROADMAP.md)

## Roadmap Sequencing Strategies

### Strategy 1: Value-First (User-Driven)

**Principle:** Deliver user value as quickly as possible

**Sequence:**
1. Minimum viable user journey
2. Expand to complete workflows
3. Add convenience and polish
4. Scale and optimize

**Best for:**
- B2C products
- Solo developer tools
- Products with clear user pain

**Example:**
- Phase 1: Create/edit/delete notes (basic value)
- Phase 2: Search and organization (usability)
- Phase 3: Sync and sharing (collaboration)

### Strategy 2: Risk-First (Technical Derisking)

**Principle:** Validate riskiest assumptions before building too much

**Sequence:**
1. Proof of concept for risky tech
2. Core value on proven foundation
3. Expand with confidence
4. Optimize and scale

**Best for:**
- Novel technology
- Unproven architectures
- High technical uncertainty

**Example:**
- Phase 1: AI model integration (high risk)
- Phase 2: User workflow around AI (value)
- Phase 3: Additional features (expansion)

### Strategy 3: Foundation-First (Platform Building)

**Principle:** Build reusable infrastructure before applications

**Sequence:**
1. Core platform capabilities
2. First application using platform
3. Additional applications
4. Ecosystem development

**Best for:**
- Platform products
- Reusable tooling
- Long-term architecture investments

**Example:**
- Phase 1: Context management engine
- Phase 2: Spec management app
- Phase 3: Test/docs management apps

### Strategy 4: Vertical Slice (User Segment)

**Principle:** Complete experience for one user type before expanding

**Sequence:**
1. Full workflow for primary user
2. Full workflow for secondary user
3. Cross-user features
4. Advanced capabilities

**Best for:**
- Multiple user types
- B2B products
- Marketplace/two-sided products

**Example:**
- Phase 1: Manager dashboard (primary user)
- Phase 2: Rep input features (secondary user)
- Phase 3: Cross-role collaboration

### Strategy 5: Hybrid (Most Common)

**Principle:** Mix value, risk, and dependencies pragmatically

**Sequence:**
1. Derisk highest-risk tech THEN core value
2. Complete MVP with essential features
3. Learn from users and iterate
4. Expand based on validated learning

**This is usually the best approach for most projects.**

## Common Roadmap Patterns

### Pattern 1: Foundation → MVP → Enhance → Scale

**Structure:**
- Phase 0: Core infrastructure (10-15%)
- Phase 1: Minimum viable value (30-40%)
- Phase 2: Production-ready (25-30%)
- Phase 3+: Growth features (remaining)

**When to use:** Standard approach for most projects

### Pattern 2: Spike → Build → Polish → Expand

**Structure:**
- Phase 1: Technical spike on risky approach
- Phase 2: Build MVP using validated approach
- Phase 3: Polish and production-ready
- Phase 4: Expansion features

**When to use:** High technical uncertainty

### Pattern 3: Slice → Expand → Integrate → Optimize

**Structure:**
- Phase 1: Complete vertical slice for one use case
- Phase 2: Additional use cases/user types
- Phase 3: Cross-cutting features
- Phase 4: Performance and scale

**When to use:** Multiple distinct user types

## Sequencing Decision Framework

When deciding feature order, use this framework:

### Decision Tree

```
For each feature, ask:

1. Does it have hard dependencies?
   YES → Must sequence after dependency
   NO → Continue to #2

2. Does it validate a critical assumption?
   YES → HIGH PRIORITY (Phase 1)
   NO → Continue to #3

3. Is it part of core value proposition?
   YES → Phase 1
   NO → Continue to #4

4. Does it complete a user journey?
   YES → Include with journey features
   NO → Continue to #5

5. Is it polish or optimization?
   YES → Phase 3+
   NO → Phase 2

6. Is it explicitly future scope?
   YES → Phase 3+
   NO → Determine based on value/risk
```

### Tie-Breaker Criteria

When multiple features have equal priority:

1. **User value** - More valuable first
2. **Risk** - Higher risk first (derisk early)
3. **Dependencies** - Enables more features first
4. **Effort** - Easier first (quick wins)
5. **Feedback** - Enables learning first

## Key Principles

### Derisk Early

**Principle:** Validate riskiest assumptions in Phase 1

- Novel technology? Test it early
- Unproven user demand? Get feedback fast
- Performance concerns? Prototype first
- Complex integration? Spike it

**Anti-pattern:** Building lots of low-risk features while deferring the hard stuff

### Deliver Value Incrementally

**Principle:** Each phase should be usable standalone

- Not just "infrastructure" phases
- Not "90% done but not usable"
- Real user value at each milestone

**Anti-pattern:** Long build phases with no deliverable until the end

### Complete User Journeys

**Principle:** Don't leave workflows half-finished

- Create + Edit + Delete, not just Create
- End-to-end scenarios work
- No "TBD" in critical flows

**Anti-pattern:** Piecemeal features that don't form complete workflows

### Plan for Learning

**Principle:** Roadmap enables feedback and adaptation

- Early phases inform later phases
- User feedback opportunities
- Technical learnings incorporated

**Anti-pattern:** Detailed plan for all phases without flexibility

### Just-in-Time Planning

**Principle:** Detail phases progressively, not all upfront

**Phase 1 (MVP):**
- **Detail level:** High - Specific features with clear goals
- **When:** During roadmap creation
- **Why:** Need to start implementation immediately
- **Includes:**
  - Feature names and descriptions
  - Dependencies between features
  - Success criteria for phase
  - Rough effort estimates

**Phase 2 (Enhanced MVP):**
- **Detail level:** Medium - Feature themes and examples
- **When:** During roadmap creation
- **Why:** Inform dependencies and sequencing
- **Includes:**
  - Major feature categories
  - 2-3 example features per category
  - How Phase 2 builds on Phase 1
  - General goals (production-ready, user feedback addressed)

**Phase 3+ (Growth):**
- **Detail level:** Low - High-level themes only
- **When:** During roadmap creation (outline), detailed during Phase 1-2 (refinement)
- **Why:** Will change based on Phase 1-2 learnings
- **Includes:**
  - Strategic themes (scale, integrations, advanced features)
  - Example possibilities (not commitments)
  - General direction

**When to flesh out Phase 2+ details:**

**Too early (DON'T):**
- ❌ Before Phase 1 starts
- ❌ During Phase 1 specification writing
- ❌ During Phase 1 implementation (unless blocked)

**Just right (DO):**
- ✓ **Phase 2 detailed during Phase 1 implementation** (late implementation, when ~60-80% done)
- ✓ **Phase 3 detailed during Phase 2 implementation** (same timing)
- ✓ Triggered by Checkpoint Review after phase completion

**Why wait?**
- Phase 1 reveals user needs you didn't predict
- Phase 1 reveals technical complexity you underestimated
- Phase 1 reveals features are more/less valuable than expected
- User feedback changes priorities
- Market conditions change
- Technology landscape shifts

**Checkpoint Review triggers detailed planning:**

After Phase 1 complete:
1. Run Checkpoint Review (see [FeedbackLoops.md](FeedbackLoops.md))
2. Gather Phase 1 learnings: What worked? What didn't? What surprised us?
3. Update ROADMAP.md Phase 2 with detailed features based on learnings
4. Optionally update Phase 3+ outlines if strategic direction changed
5. Approve updated roadmap before Phase 2 spec writing begins

**Example progression:**

**Initial ROADMAP.md (before Phase 1 starts):**
```markdown
## Phase 1: MVP (Detailed)
- User authentication (email/password)
- Task CRUD operations
- Basic search (keyword in title/description)
- API endpoints for all operations

## Phase 2: Enhanced MVP (Medium detail)
- Advanced search capabilities
- User experience improvements
- Performance optimizations
- Example features: search filters, keyboard shortcuts, response caching

## Phase 3: Growth (Low detail)
- Collaboration features
- Mobile applications
- Third-party integrations
- Advanced analytics
```

**Updated ROADMAP.md (after Phase 1 complete, before Phase 2 starts):**
```markdown
## Phase 1: MVP (COMPLETE)
[... detailed features as implemented ...]

## Phase 2: Enhanced MVP (NOW DETAILED)
- Full-text search with Elasticsearch (users requested better search)
- Task tags and filtering (most requested feature in Phase 1 feedback)
- Bulk operations (power users need efficiency)
- Keyboard shortcuts (accessibility requirement discovered)
- API rate limiting (performance testing revealed need)
- Response caching with Redis (p95 latency too high without)

## Phase 3: Growth (Updated outline based on Phase 1)
- Team workspaces and sharing (many users wanted collaboration)
- Mobile-responsive web UI (defer native apps based on budget)
- Slack/Email notifications (most requested integration)
- Advanced filtering and saved searches
```

**Notice:**
- Phase 2 features changed based on Phase 1 feedback and discoveries
- Phase 2 now has specific technical decisions (Elasticsearch, Redis)
- Phase 3 outline updated to reflect what users actually requested
- Some original Phase 2 ideas removed or deferred

**Red flags (over-planning):**
- Writing detailed specs for Phase 2 features before Phase 1 starts
- Committing to specific Phase 3 features in contracts/roadmaps
- Detailed effort estimates for Phase 3+ features
- Architecture diagrams for Phase 3 systems
- Stakeholder promises about Phase 3 delivery dates

**Anti-pattern:** Detailed plan for all phases without flexibility

## Common Issues

### Pitfall 1: "Infrastructure Phase" That Delivers No User Value

**Problem:** Phase 1 is pure infrastructure, no user features

**Why bad:** No way to validate value, long time before learning

**Fix:** Include minimum user-facing features in Phase 1, just enough infrastructure

### Pitfall 2: Deferring All Hard Problems

**Problem:** Phase 1 is easy features, all risky stuff in Phase 3

**Why bad:** Late discovery of blockers, might invalidate early work

**Fix:** Tackle riskiest assumptions in Phase 1 (derisking)

### Pitfall 3: Phases Too Large

**Problem:** Phases are 6+ months each

**Why bad:** Too long between feedback, hard to stay motivated

**Fix:** Keep phases 4-8 weeks for solo dev, 1-3 months for teams

### Pitfall 4: No Clear Phase Themes

**Problem:** Features randomly distributed across phases

**Why bad:** No coherence, hard to communicate, unclear goals

**Fix:** Each phase should have clear theme and demo-able outcome

### Pitfall 5: Ignoring Dependencies

**Problem:** Feature scheduled before its prerequisites

**Why bad:** Can't build, blocks progress, cascading delays

**Fix:** Map dependencies first, sequence respecting prerequisites

### Pitfall 6: Over-Committing to Later Phases

**Problem:** Detailed feature specs for Phase 3+ before Phase 1 complete

**Why bad:** Waste effort, will change based on learning

**Fix:** Detail Phase 1-2, outline Phase 3+, refine after learning

## Examples

### Example 1: Developer Tool Roadmap (Minimal)

**Phase 1 - Core MVP (6 weeks)**
- Spec creation/editing with templates
- Basic validation (required sections)
- File storage in Git repos
**Goal:** Solo devs can manage specs

**Phase 2 - Context Linking (4 weeks)**
- Automatic link detection
- Cross-reference navigation
- Link validation in CI
**Goal:** Specs become living context

**Phase 3 - Living Docs (4 weeks)**
- Status tracking across artifacts
- Dependency visualization
- Health reporting
**Goal:** Maintain context as project evolves

**Rationale:** Phase 1 derisks "Will devs use plain Markdown specs?" Phase 2 delivers unique value (linking). Phase 3 adds sustainability.

### Example 2: SaaS Product Roadmap (Moderate)

**Phase 0 - Foundation (2 weeks)**
- Auth system (email/password)
- Database schema
- API framework

**Phase 1 - MVP (8 weeks)**
- User registration/login
- Create/edit/delete items
- Basic search
- Mobile-responsive web UI
**Goal:** Core CRUD workflow works

**Phase 2 - Production-Ready (6 weeks)**
- Sharing and permissions
- Export functionality
- Error handling and logging
- Performance optimization
**Goal:** Reliable enough for paying customers

**Phase 3 - Growth (Ongoing)**
- Integrations (Slack, etc.)
- Advanced search
- Team workspaces
- Mobile apps
**Goal:** Scale to more users and use cases

**Rationale:** Foundation minimal. MVP proves value. Phase 2 makes it production-quality. Phase 3 expands based on feedback.

## Quality Checklist

### Alignment
- [ ] Roadmap serves vision statement
- [ ] Phases progress toward success criteria
- [ ] All MVP scope features included
- [ ] No out-of-scope features included
- [ ] Timeline fits vision milestones

### Sequencing
- [ ] Dependencies respected (nothing before its prerequisite)
- [ ] Riskiest assumptions validated in Phase 1
- [ ] Core value delivered in Phase 1
- [ ] Each phase has complete user journeys
- [ ] Incremental value delivery (no "infrastructure-only" phases)

### Realism
- [ ] Phase scope fits timeline
- [ ] Buffer time included (20% recommended)
- [ ] Resource constraints respected
- [ ] Technical feasibility validated

### Clarity
- [ ] Each phase has clear theme
- [ ] Rationale for sequencing documented
- [ ] Dependencies explicit
- [ ] Anyone could understand the plan

### Flexibility
- [ ] Later phases less detailed than Phase 1
- [ ] Learning opportunities identified
- [ ] Adaptation strategy documented
- [ ] Not over-committed to distant features

## Integration with Workflow

This role fits in the workflow as follows:
- **Receives:** VISION.md, SCOPE.md
- **Produces:** ROADMAP.md in main branch
- **Next roles:** Roadmap Reviewer → Spec Writer

**To understand where this role fits:** See [workflow-overview.md](workflow-overview.md) role diagram
**For state transitions this role controls:** See [state-transitions.md](state-transitions.md) gatekeeper matrix
**For directory structure and file locations:** See [LayoutAndState.md](LayoutAndState.md)

## Critical Reminders

**DO:**
- Read VISION.md and SCOPE.md completely first to extract features and constraints
- Map dependencies before sequencing (use "Sequencing Decision Framework")
- Document sequencing rationale for each phase (why now, why not earlier/later)
- Reality-check against timeline with 20% buffer
- Reference [schema-roadmap.md](schema-roadmap.md) for complete structure
- Get stakeholder approval before spec work begins
- Apply "Quality Checklist" (alignment, sequencing, realism, clarity, flexibility)

**DON'T:**
- Ignore technical dependencies (map them in Step 2)
- Skip rationale (why this sequence?)
- Forget buffer time for unknowns (20% recommended)
