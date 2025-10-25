# Vision Review Examples

This document provides complete review examples for different scenarios and common issues.

## Example 1: New Project Vision - Needs Major Revision

### Original Vision Document

```markdown
# TaskMaster Pro Vision

## Vision Statement
Build the best project management tool with AI and real-time collaboration.

## Problem
People need better project management.

## Users
Everyone who manages projects.

## What We'll Build
- AI-powered task prioritization
- Real-time collaboration
- Mobile apps (iOS, Android)
- Desktop app
- Web app
- Calendar integration
- Email integration
- Slack integration
- Time tracking
- Resource management
- Budgeting
- Reporting and analytics

## Success
Lots of users and revenue.

## Team
Solo developer, 6 months.
```

### Review Output

```markdown
## Vision Review Summary

**Overall Assessment:** Needs Major Work - Not ready for planning

**Critical Issues:**

1. **Vision Statement - Feature List Syndrome (P0)**
   - Current: "Build the best project management tool with AI and real-time collaboration"
   - Problem: Describes product features, not customer outcomes
   - Impact: Doesn't guide decisions or inspire team
   - Fix: Reframe around outcome, e.g., "Help solo developers maintain project context 
     across planning and execution without documentation overhead"

2. **Problem Statement - Too Vague (P0)**
   - Current: "People need better project management"
   - Problem: No specifics about who, what pain, or why current solutions fail
   - Impact: Can't validate problem or design solution
   - Fix: Describe specific current state pain and desired future state with evidence

3. **Target Users - Too Broad (P0)**
   - Current: "Everyone who manages projects"
   - Problem: Can't build for everyone; no decision guidance
   - Impact: Can't prioritize features or validate designs
   - Fix: Specific persona, e.g., "Solo developers building 2-3 concurrent projects 
     with 10-20hrs/week available"

4. **Scope - Wildly Unrealistic (P0)**
   - Current: 12+ major features including 3 platforms (iOS, Android, desktop, web)
   - Problem: Impossible for solo developer in 6 months
   - Impact: Guaranteed failure and burnout
   - Fix: Focus on ONE platform and 3-5 core features maximum for MVP

5. **Success Criteria - Unmeasurable (P0)**
   - Current: "Lots of users and revenue"
   - Problem: Not specific or measurable
   - Impact: Can't know if successful or track progress
   - Fix: Specific metrics, e.g., "100 active users within 6 months, 60% retention 
     after 3 months"

**Missing Sections:**
- Value proposition/differentiation
- Technical approach
- Assumptions and constraints
- Open questions
- Scope boundaries (future/never)

**Anti-Patterns Detected:**
- Feature list syndrome (vision = product features)
- Competitor obsession ("best" without defining unique value)
- Solo developer sustainability trap (scope impossible for one person)
- Vague aspirations (no concrete meaning to "better")

**Readiness Assessment:**
- Ready for planning: **NO**
- Blockers: Vision needs complete rewrite addressing all P0 issues
- Estimated revision time: 4-8 hours of focused work

**Recommendation:**

Start over using Geoffrey Moore elevator pitch or Roman Pichler Vision Board:

1. Conduct 10-20 customer interviews to understand specific problems
2. Define one specific target persona with behavioral attributes
3. Articulate concrete outcome improvement (time saved, frustration eliminated)
4. Reduce MVP scope to 3-5 core features on ONE platform
5. Define 3-5 measurable success criteria with timelines
6. Add missing sections (technical approach, assumptions, constraints)

**Example rewrite of vision statement:**
"Help solo developers maintain project context when switching between features 
without spending hours reconstructing why decisions were made"

This focuses on specific user (solo developers), concrete problem (context loss when 
switching), and measurable outcome (reduce reconstruction time from hours to minutes).

Do not proceed to planning until these critical issues are addressed.
```

## Example 2: Pre-Planning Gate Review - Minor Issues

### Original Vision Document

```markdown
# DevContext Vision

## Vision Statement
Help solo developers maintain project context across planning and execution 
without documentation overhead.

## Problem Statement

### Current State
Solo developers building multiple projects lose critical context when switching 
between features or returning after breaks. They spend 20-30% of development 
time reconstructing "why" decisions were made, what edge cases matter, and how 
pieces fit together.

### Desired Future State
Developers maintain complete project context automatically as byproduct of normal 
workflow. Looking at any code change surfaces the full decision trail. Context gaps 
that took hours to reconstruct now take seconds.

## Target Users

### Primary Persona: Solo Developer with Multiple Projects
- Building 1-3 concurrent projects (client work + personal products)
- 10-20 hours/week development time
- Works alone, occasionally brings in contractors
- Frustrated by context loss after breaks
- Values tools that integrate with existing workflow

## Value Proposition

### Core Benefit
Eliminate context reconstruction time when switching projects/features.

### Differentiation
Unlike project management tools (focus on tracking, not context) or wikis 
(separate from code, immediately stale), DevContext maintains living context 
that evolves with code.

## Product Scope

### In Scope (MVP - 3 months)
- Lightweight spec format (Markdown)
- Git integration
- Context linking (specs/tests/code)
- CLI interface
- Living docs (SYSTEM_MAP, PATTERNS)

### Future Scope
- Editor integrations (VS Code, Cursor)
- AI-assisted spec generation
- Web interface
- Team features

### Never in Scope
- General project management
- Chat/communication features
- Bug tracking system (beyond simple ledger)

## Success Criteria

### Key Metrics
- Time to answer "why does this exist?" <30 seconds (currently 30-60 min)
- 100 active users within 6 months
- 60% retention after 3 months

### Timeline
- 6 months: 100 users, proof of time savings
- 1 year: 500 users, measurable context loss reduction
- 3 years: 5,000+ users, standard solo dev workflow

## Technical Approach
- Python CLI (familiar to target users)
- Git-based storage (no separate DB)
- Markdown for readability
- Static analysis for linking

## Assumptions
- Solo developers experience context loss pain
- They're willing to adopt lightweight workflow additions
- Git is universal enough to assume
- CLI tools remain viable for developer tools
```

### Review Output

```markdown
## Vision Review Summary

**Overall Assessment:** Ready with Minor Revisions - Can proceed to planning with fixes

**Strengths:**
- Vision statement is clear, outcome-focused, and memorable
- Problem statement has concrete specifics (20-30% time waste)
- Target user persona is specific with behavioral attributes
- Scope is realistic for solo developer in 3 months
- Clear boundaries with "never in scope"
- Differentiation is clear vs. alternatives

**Minor Issues to Address (P1):**

1. **Success Criteria - Missing Counter-Metrics**
   - Current: Only growth metrics listed
   - Issue: No guardrails preventing harmful optimization
   - Fix: Add counter-metrics like "Documentation overhead <10% of dev time" 
     and "Setup time <30 minutes"

2. **Assumptions - No Validation Plan**
   - Current: Lists assumptions but not how to validate
   - Issue: Riskiest assumptions unvalidated before building
   - Fix: For each assumption, add validation approach:
     * "Solo devs experience pain" → 10 customer interviews
     * "Willing to adopt" → Test with paper prototypes
     * "CLI viable" → Survey 20 target users on tool preferences

3. **Technical Approach - Missing Risks**
   - Current: Lists tech stack but not challenges
   - Issue: Known technical risks not acknowledged
   - Fix: Add section on risks:
     * Git expertise required (mitigate: excellent onboarding)
     * Static analysis limitations
     * Editor integration complexity (deferred to future)

4. **Open Questions - Section Missing**
   - Current: No open questions section
   - Issue: Likely has unresolved decisions
   - Suggested additions:
     * Pricing model? (Open source vs. freemium)
     * Which editor to prioritize first?
     * When to add team features vs. staying solo-focused?

**Improvement Opportunities (P2):**

- Add more detail to desired future state (what specifically happens in seconds?)
- Include example user quote or validation evidence for problem
- Specify retention measurement approach (how tracking this?)

**Readiness Assessment:**
- Ready for planning: **YES** (after addressing P1 issues)
- Blockers: None critical
- Time to address issues: 1-2 hours
- Next step: Add counter-metrics, validation plans, risks, open questions, then proceed

**Recommendation:**

Vision is fundamentally sound. Make these quick additions:

1. Add 2-3 counter-metrics as guardrails
2. Document validation plan for each key assumption
3. Add technical risks section with mitigation
4. Add open questions section for unresolved decisions

After these additions (1-2 hours work), proceed to scope definition and roadmap planning.

**Suggested additions:**

Counter-metrics:
- Documentation overhead <10% of dev time (ensure cure isn't worse than disease)
- Setup time <30 minutes (low friction threshold)
- Tool learning curve: productive within 1 day

Validation plan:
- Week 1-2: 10 customer interviews validating problem exists
- Week 3-4: Paper prototype testing for workflow acceptance
- Week 5-6: CLI prototype with 5 early users

Open questions:
- Business model: Open source core vs. freemium?
- Editor priority: VS Code first or multi-editor from start?
- AI integration: Essential for MVP or future addition?
```

## Example 3: Quarterly Review - Update Needed

### Context
Vision has been in use for 6 months. Reviewing based on learnings.

### Findings from 6 Months

- **Actual metrics:**
  - 150 active users (exceeded goal of 100)
  - 45% retention after 3 months (missed goal of 60%)
  - Time to answer "why" now 2-3 minutes (goal was <30 seconds)

- **Key learnings:**
  - Users love spec format but find CLI too friction-ful
  - Most users are NOT solo devs - they're 2-5 person teams
  - Users want editor integration NOW, not in future
  - "Living docs" concept is confusing without examples

- **Market changes:**
  - Two competitors launched similar tools
  - VS Code extension ecosystem grew significantly
  - AI coding assistants became mainstream

### Review Output

```markdown
## Quarterly Vision Review Summary

**Overall Assessment:** Update Needed - Vision partially invalidated by learnings

**What's Still Valid:**
- Core problem (context loss) remains real and important
- Outcome focus (reduce reconstruction time) is right direction
- Differentiation (living context vs. separate docs) still unique
- Technical approach (Git-based, Markdown) is working well

**What Needs Updating:**

1. **Target Users - Hypothesis Invalidated**
   - Original: "Solo developers with multiple projects"
   - Reality: 70% of users are 2-5 person teams, not solo
   - Impact: Feature priorities wrong (CLI vs. collaboration)
   - Update: Change primary persona to "small team" and add solo as secondary

2. **Success Criteria - Metrics Partially Missed**
   - Time to context: 2-3 min (goal <30 sec) - Not meeting expectation
   - Retention: 45% (goal 60%) - Below target
   - Users: 150 (goal 100) - Exceeded
   - Analysis: Getting users but not delivering enough value (retention issue)
   - Update: Revise retention goal to 50% (more realistic) and add "80% of users 
     report <1 min context access" as leading indicator

3. **Scope Boundaries - Market Pressure**
   - Original: Editor integration in "future scope"
   - Reality: Users demanding editor integration immediately; competitors have it
   - Impact: Losing users to integrated competitors
   - Update: Move editor integration (VS Code) to MVP; defer other platforms

4. **Technical Approach - New Opportunity**
   - Original: CLI only, AI not mentioned
   - Reality: AI coding assistants now mainstream; users expect integration
   - Opportunity: AI-assisted context generation could dramatically reduce friction
   - Update: Add AI integration to technical approach

5. **Assumptions - Some Validated, Some Invalidated**
   - ✅ Validated: Git ubiquity, Markdown preference, context loss pain
   - ❌ Invalidated: "Solo developers are primary users" (actually small teams)
   - ❌ Invalidated: "CLI sufficient for MVP" (editor integration critical)
   - Update: Document validated/invalidated status and adjust strategy

**New Assumptions to Test:**
- Small teams will adopt context tool across team (vs. individual use)
- VS Code extension can be built in 6-8 weeks
- AI-assisted context generation improves retention

**Anti-Patterns Check:**
- ⚠️  Minor scope creep: Adding features based on requests without vision update
- ⚠️  Risk of competitor obsession: Don't copy features, focus on unique value

**Recommendation:**

Update vision document with learnings:

1. **Rewrite target users section:**
   - Primary: 2-5 person development teams
   - Secondary: Solo developers
   - Keep behavioral attributes but adjust team size

2. **Update scope priorities:**
   - Move VS Code extension to MVP (critical for retention)
   - Add AI-assisted context generation to future scope
   - Defer web interface (less important than editor)

3. **Revise success criteria:**
   - Adjust retention goal to 50% (more realistic baseline)
   - Add leading indicator: "80% of users achieve <1 min context access"
   - Keep user growth targets (actually exceeding)

4. **Document validated assumptions:**
   - Add section tracking which assumptions proven right/wrong
   - Update strategy based on invalidated assumptions

5. **Add changelog entry:**
   ```markdown
   ### Version 2.0 - [Date]
   **Changed:** Primary user from solo developers to small teams (2-5 people)
   **Reason:** User research showed 70% of actual users are small teams
   **Impact:** Prioritizing collaboration features and editor integration over CLI
   
   **Changed:** Moved VS Code extension to MVP scope
   **Reason:** Retention data shows CLI friction is primary churn cause
   **Impact:** 6-8 week addition to MVP timeline, but critical for retention goal
   ```

**Next Actions:**
1. Update vision document (2-3 hours)
2. Share updated vision with current users for validation
3. Adjust roadmap based on new priorities
4. Plan VS Code extension development
5. Research AI integration opportunities

Vision fundamentals remain sound, but specific user segment and scope priorities 
need updating based on 6 months of market learning. This is healthy iteration, 
not vision failure.
```

## Example 4: Anti-Pattern Detection - Multiple Issues

### Original Vision Document

```markdown
# InnovateAI Vision

## Vision
We will revolutionize the enterprise software industry by leveraging cutting-edge 
AI and machine learning to create a paradigm shift in how businesses operate, 
delivering unprecedented value to stakeholders while disrupting traditional 
approaches and becoming the market leader in our space.

## The Opportunity
There's a huge market for AI-powered business tools. Everyone needs AI now. 
We can be the Uber of enterprise software.

## Our Solution
A comprehensive AI platform featuring:
- Natural language processing
- Computer vision
- Predictive analytics
- Automated decision-making
- Blockchain integration
- IoT connectivity
- Mobile-first architecture
- Cloud-native microservices
- Real-time collaboration
- Advanced security
- Scalable infrastructure
- API-first design

## Go-to-Market
Beat Salesforce and SAP by being better and cheaper. Raise $50M Series A. 
Hire 100 engineers. Launch in 6 months.
```

### Review Output

```markdown
## Vision Review Summary

**Overall Assessment:** Unusable - Complete Rewrite Required

This vision document exhibits MULTIPLE critical anti-patterns that make it unusable 
for guiding product development. Recommend complete rewrite using proven framework 
(Geoffrey Moore or Roman Pichler).

**Critical Anti-Patterns Detected:**

### 1. Mission Confusion (Severe)

**Problem:**
Vision statement is too broad and timeless:
"revolutionize the enterprise software industry... paradigm shift... unprecedented value"

This is mission language (company-level, decades-long) not product vision (specific, 
2-5 years, measurable).

**Test:**
- Could this apply to company, not specific product? ✅ YES (RED FLAG)
- Is there a time-bound achievement? ❌ NO (RED FLAG)
- Can you measure when achieved? ❌ NO (RED FLAG)

**Fix:**
Narrow to specific user segment and concrete outcome:
"Enable sales operations managers at mid-market B2B companies to forecast quarterly 
revenue within 5% accuracy without manual spreadsheet work"

### 2. Feature List Syndrome (Severe)

**Problem:**
12+ features listed without explaining customer benefit or outcome. Vision describes 
WHAT you'll build, not WHY it matters or WHAT PROBLEM it solves.

**Test:**
- Remove feature names - does value remain clear? ❌ NO (RED FLAG)
- Does this guide what NOT to build? ❌ NO (RED FLAG)

**Fix:**
Start with customer problem and desired outcome, not solution features:
"Problem: Sales leaders spend 40+ hours monthly on forecast accuracy, still off by 
15-20%. Desired: Reduce forecasting time to <2 hours with <5% error."

### 3. Vague Aspirations (Severe)

**Problem:**
Buzzword density is off the charts:
- "revolutionize"
- "cutting-edge"
- "paradigm shift"
- "unprecedented value"
- "disrupting"

None of these terms have concrete meaning.

**Test:**
- Could competitors use exact same language? ✅ YES (RED FLAG)
- Can you measure when you've "revolutionized" something? ❌ NO (RED FLAG)

**Fix:**
Use concrete, measurable language:
Instead of "revolutionize," specify "reduce forecast time from 40 hours to 2 hours"
Instead of "unprecedented value," specify "save each sales leader $30K annually"

### 4. Competitor Obsession (Severe)

**Problem:**
Vision defined entirely as "beat Salesforce and SAP by being better and cheaper."

No explanation of:
- Why customers would switch from Salesforce/SAP
- What unique value you provide
- What you do differently (besides "better and cheaper")

**Test:**
- Does vision work without mentioning competitors? ❌ NO (RED FLAG)
- Is there clear customer benefit stated? ❌ NO (RED FLAG)

**Fix:**
Frame around customer problem, not competitor comparison:
"Unlike Salesforce (requires extensive configuration and training), our approach 
requires zero setup and learns from existing data automatically"

### 5. Solution Lock-In (Moderate)

**Problem:**
Vision commits to specific technologies:
- "Mobile-first architecture"
- "Cloud-native microservices"
- "Blockchain integration"

These are implementation details that should be flexible.

**Test:**
- Can strategy change without changing vision? ❌ NO (RED FLAG)

**Fix:**
Move technical decisions to "Technical Approach" section. Vision should describe 
outcomes, not implementation.

### 6. "Uber of X" Syndrome (Severe)

**Problem:**
"We can be the Uber of enterprise software" provides zero information about what 
you actually do or what customer problem you solve.

**Fix:**
Describe your specific approach and value, not analogies to other companies.

### 7. Scope Creep Spiral (Severe)

**Problem:**
12+ major feature areas with no prioritization, no "never in scope," and timeline 
of 6 months with plan to hire 100 engineers.

This signals:
- No focus or priorities
- Unrealistic resource/timeline expectations
- Everything is "yes" with no boundaries

**Fix:**
Define:
- MVP: 3-5 core features only
- Future scope: What comes later
- Never in scope: What you deliberately won't do
- Realistic timeline with actual resources

**Missing Critical Sections:**
- ❌ Problem statement (why does this matter?)
- ❌ Target users (who is this for?)
- ❌ Success criteria (how measure success?)
- ❌ Assumptions (what must be true?)
- ❌ Scope boundaries (what's in/out?)

**Structural Issues:**
- Vision is 3 sentences of buzzwords
- No concrete problem described
- No specific users identified
- No measurable outcomes defined
- Resource plan disconnected from reality

**Readiness Assessment:**
- Ready for planning: **ABSOLUTELY NOT**
- Blockers: Unusable vision with multiple critical anti-patterns
- Time to fix: 8-16 hours of complete rewrite

**Recommendation:**

**DO NOT attempt to fix this incrementally.** Start over with structured framework:

**Step 1: Customer Discovery (1-2 weeks)**
- Interview 20+ potential customers
- Understand specific problems they experience
- Identify jobs-to-be-done
- Validate problem is real and important

**Step 2: Use Geoffrey Moore Elevator Pitch (2-3 hours)**
```
For [specific target customers]
who [specific problem/need],
the [product name]
is a [product category]
that [key benefit].
Unlike [primary competitive alternative],
our product [statement of primary differentiation].
```

**Step 3: Validate Core Assumptions (2-4 weeks)**
- Test problem with prototypes
- Validate users will adopt solution
- Confirm technical feasibility
- Verify business model viability

**Step 4: Write Complete Vision (4-8 hours)**
- All required sections
- Concrete, measurable language
- Realistic scope and timeline
- Based on validated assumptions

**Example Rewrite Start:**

Instead of current vision, try:

```markdown
# InnovateAI Vision

## Vision Statement
Help sales operations managers at mid-market B2B companies forecast quarterly 
revenue within 5% accuracy in under 2 hours instead of 40+ hours of manual work.

## Problem Statement

### Current State
Sales ops managers at 50-500 person B2B companies spend 40+ hours monthly 
consolidating rep forecasts in spreadsheets. Despite this effort, forecast 
accuracy is typically 15-20% off, causing cash flow and planning problems.

Current solutions (Salesforce, Clari) require extensive configuration, training, 
and rep behavior change. Adoption is low, data quality is poor, accuracy doesn't 
improve.

### Desired Future State
Sales ops managers spend <2 hours monthly on forecasts. System learns from 
existing data automatically. Accuracy improves to <5% error. No behavior change 
required from reps.
```

This rewrite:
✅ Specifies target users
✅ Describes concrete problem
✅ States measurable improvement
✅ Avoids buzzwords
✅ Focuses on outcome not features

Do not proceed until vision is completely rewritten addressing all anti-patterns.
```

## Key Patterns from Examples

### Pattern 1: Severity Determines Approach

- **P0 issues (blocking):** Recommend complete rewrite or major revision
- **P1 issues (reducing effectiveness):** Provide specific fixes, can proceed with changes
- **P2 issues (polish):** Suggest improvements, can proceed as-is

### Pattern 2: Specific Feedback Always Includes Examples

Never say "this is too vague" without showing what concrete looks like.

### Pattern 3: Test Questions Reveal Issues

Each quality criterion has test questions that reveal if vision passes or fails.

### Pattern 4: Prioritize Fixable Issues

Focus on what can be improved, not what's fundamentally wrong with the idea itself.

### Pattern 5: Provide Path Forward

Always end with concrete next steps, not just criticism.
