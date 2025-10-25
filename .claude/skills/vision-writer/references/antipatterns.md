# Vision Anti-Patterns and Failures

This document catalogs common vision failures with real-world examples and how to avoid them.

## 1. Feature List Syndrome

### Pattern

Vision describes product capabilities rather than customer outcomes.

### Examples

**Bad:**
- "A SaaS platform with AI-powered analytics, real-time collaboration, mobile apps, SSO, API integrations, and customizable dashboards"
- "The most feature-rich project management tool on the market"
- "Build an app that does X, Y, Z, and also supports A, B, C"

**Why it fails:**
- Doesn't explain why these features matter
- Locks you into specific solutions
- Prevents pivoting when you learn
- Offers no guidance on priorities
- Indistinguishable from competitor visions

**Good alternative:**
- "Enable product teams to make evidence-based decisions in minutes instead of weeks"
- "Help distributed teams maintain shared context without meeting fatigue"

### How to fix

**If you find yourself listing features:**
1. For each feature, ask "What outcome does this enable?"
2. Roll up outcomes into higher-level benefit
3. Make that benefit the vision focus
4. Move features to product scope section

## 2. Mission Confusion

### Pattern

Vision is too broad and timeless, actually describing company mission.

### Examples

**Bad (these are missions, not visions):**
- "Organize the world's information" (Google's mission)
- "Connect the world" (Facebook's mission)
- "Democratize access to technology"
- "Make the world a better place"

**Why it fails:**
- Too broad to guide product decisions
- Never achievable, so no success criteria
- Could apply to many different products
- Doesn't specify time horizon or target users

**Good (actual product visions):**
- "Help researchers find relevant academic papers 10x faster than Google Scholar" (product vision)
- "Enable small businesses to accept payments anywhere without specialized hardware" (Square's early vision)

### How to distinguish

| Aspect | Mission | Vision |
|--------|---------|--------|
| Scope | Company-wide, enduring | Product-specific, time-bound |
| Timeframe | Timeless (decades) | 2-5 years for software |
| Specificity | Broad, aspirational | Specific users and outcomes |
| Measurability | Directional | Concrete success criteria |
| Stability | Unchanging | Evolves as product matures |

### How to fix

**If your vision sounds like a mission:**
1. Narrow to specific user segment
2. Define concrete outcome improvement
3. Add time horizon (what in 2-5 years?)
4. Specify measurable success criteria

## 3. Premature Abandonment

### Pattern

Giving up on vision after 6-12 months before solving hard problems.

### Why it happens

- Underestimating time to product-market fit (typically 2-5 years)
- Expecting linear progress (growth is usually hockey stick)
- Chasing trends instead of committing to vision
- Mistaking lack of early traction for invalid vision

### Real examples

**Companies that almost gave up:**
- **Slack:** Stewart Butterfield's team pivoted from failed game (Glitch) but nearly gave up on Slack after slow initial growth
- **Instagram:** Started as Burbn (location check-in app), took 8 weeks to pivot to photo-sharing, then 2 years to reach scale
- **YouTube:** Started as video dating site, pivoted to general video sharing after months of no traction

**Companies that gave up too soon:**
- Many products in the "graveyard of startups" had sound visions but founders lost faith before validation period completed

### How to avoid

**Set realistic milestones:**
- 6 months: Problem validation, initial traction
- 1 year: Product-market fit signals (not achievement)
- 2 years: Clear growth trajectory
- 3-5 years: Vision achievement

**Pre-commit to persistence:**
- Define failure criteria in advance
- Distinguish between vision failure vs. strategy failure
- Plan for "trough of sorrow" (period after launch before growth)

**Strategic pivots vs. vision abandonment:**
- âœ" Pivot strategy/approach while keeping vision stable
- âœ— Abandon vision at first sign of difficulty

## 4. Solution Lock-In

### Pattern

Vision commits to specific implementation approach, preventing beneficial pivots.

### Examples

**Bad:**
- "The best mobile app for task management"
- "Build a blockchain-based supply chain platform"
- "Create the leading voice interface for scheduling"

**Why it fails:**
- Locks you into potentially wrong technology
- Prevents pivoting as you learn
- Focuses on solution rather than problem
- May alienate users who don't want that solution

**Good alternative:**
- Instead of "best mobile app": "Help people capture and act on tasks anywhere"
- Instead of "blockchain-based": "Give supply chain participants verifiable product provenance"
- Instead of "voice interface": "Let people schedule meetings without email tennis"

### Real pivots enabled by solution-agnostic vision

**Slack:**
- Vision: "Make work life simpler, more pleasant, more productive"
- Allowed pivot from gaming tool to standalone messaging platform
- Later allowed expansion from messaging to platform

**Twitter:**
- Vision: "Give everyone the power to create and share ideas instantly"
- Allowed evolution from SMS-based to web/mobile
- Enabled adding media, threads, etc.

### How to fix

**If your vision specifies technology/platform:**
1. Identify the outcome that technology enables
2. Reframe vision around outcome, not technology
3. Move technology choices to technical approach section
4. Preserve flexibility to pivot implementation

## 5. Vague Aspirations

### Pattern

Vision uses feel-good language without concrete meaning.

### Examples

**Bad:**
- "Make people's lives better"
- "Revolutionize the industry"
- "Create amazing experiences"
- "Build the future of work"
- "Empower users to achieve their goals"

**Why it fails:**
- Could mean anything to anyone
- Provides no decision guidance
- Impossible to measure success
- Doesn't clarify priorities
- Indistinguishable from any other product

**How to test for vagueness:**
- Could this apply to competitors? (If yes, too vague)
- Can you measure if you achieved it? (If no, too vague)
- Does it tell you what NOT to build? (If no, too vague)

### How to fix

**Make it concrete:**
- Add specific user segment: "remote workers" not "people"
- Define measurable outcome: "reduce meeting time by 50%" not "make better"
- Specify the "how": unique approach that differentiates you
- Include success criteria: what does "achieved" look like?

## 6. Competitor Obsession

### Pattern

Vision defined in terms of beating competitors rather than serving customers.

### Examples

**Bad:**
- "Become the #1 player in the CRM market"
- "Build a better Salesforce"
- "The Uber of dog walking"
- "The Airbnb for parking spaces"

**Why it fails:**
- Focuses on copying rather than innovating
- Doesn't explain customer benefit
- Vulnerable to competitor moves
- No guidance on where to differentiate

**Good alternative:**
- Instead of "better Salesforce": "Help small business salespeople close deals without administrative overhead"
- Instead of "#1 in CRM": "Enable every salesperson to provide enterprise-grade customer experience"

### How to fix

**Flip from competitor-focused to customer-focused:**
1. Identify what competitors fail to deliver
2. Articulate customer pain from that gap
3. Frame vision around solving that pain
4. Use differentiation section to contrast with competitors

## 7. Scope Creep Spiral

### Pattern

Vision expands continuously without boundaries, attempting to solve all problems.

### Example progression

**Month 1:** "Help developers maintain project context"
**Month 3:** "...and also track time and manage teams"
**Month 6:** "...and also do code review and CI/CD"
**Month 9:** "...and also handle customer support and billing"

**Why it fails:**
- Loses focus on core value proposition
- Spreads resources across too many problems
- Each addition dilutes previous work
- Never achieves excellence in anything

### How to avoid

**Explicit scope boundaries:**
- "In scope" section: Core value only
- "Future scope" section: Defer tempting additions
- "Never in scope" section: Explicit exclusions

**Examples of "Never in Scope":**
- "We will never do general project management (use existing tools)"
- "We will never build our own chat/communication features"
- "We will never target enterprise with 1000+ employee organizations"

### When to expand scope

**Only expand when:**
- Current vision is fully achieved
- New scope serves same core user segment
- New scope strengthens core value proposition
- You have resources to execute well

## 8. Metric Mirage

### Pattern

Success criteria are vanity metrics that don't measure real value.

### Examples

**Bad metrics:**
- "1 million users" (without retention or engagement)
- "10,000 downloads" (without active usage)
- "#1 on Product Hunt" (short-term vanity)
- "Featured in TechCrunch" (press not proof of value)

**Why it fails:**
- Measures attention, not value delivery
- Can be gamed or bought
- Disconnected from customer outcomes
- Creates perverse incentives

**Good metrics instead:**
- Weekly active users (not just downloads)
- Customer retention rate (not just acquisition)
- Time saved per user (actual value delivered)
- Revenue/profitability (business sustainability)

### Metric selection framework

**For each proposed metric, ask:**
1. Does it measure value delivered to customers?
2. Can we track it accurately?
3. Does it predict long-term success?
4. Could we game it in harmful ways?

**Always include counter-metrics:**
- "Growth without sacrificing quality (NPS >40)"
- "User acquisition without burning cash (CAC < $20)"
- "Speed without increasing bugs (error rate <0.1%)"

## 9. Technical Architecture as Vision

### Pattern

Vision describes technical implementation rather than user outcomes.

### Examples

**Bad:**
- "Build a microservices architecture for scalability"
- "Create a machine learning platform leveraging transformers"
- "Develop a serverless real-time data pipeline"

**Why it fails:**
- Describes means, not ends
- Only meaningful to engineers
- Doesn't explain why anyone should care
- Technology may become obsolete

**Good alternative:**
- Instead of "microservices architecture": "Enable teams to deploy features independently without breaking the product"
- Instead of "ML platform": "Help users discover relevant content without manual curation"

### When technical details matter

**Include in technical approach section, not vision:**
- Architecture decisions and rationale
- Technology stack choices
- Technical constraints and trade-offs
- Performance/scalability targets

## 10. Solo Developer Sustainability Trap

### Pattern

Solo developer creates vision requiring unsustainable effort.

### Examples

**Unsustainable visions:**
- "Build enterprise SaaS with 24/7 support" (impossible for one person)
- "Create native apps for iOS, Android, and web" (3x the work)
- "Compete with venture-backed companies in crowded market"

**Why it fails:**
- Leads to burnout
- Quality suffers from spreading too thin
- Business model requires team before revenue exists
- No time for customer development

### How to create sustainable vision

**Scope to your constraints:**
- One platform initially (web or mobile, not both)
- Self-service model (no 24/7 support burden)
- Niche market (avoid competing with well-funded companies)
- 70% solution is enough (perfect is the enemy of shipped)

**Sustainability checklist:**
- Can I build MVP in 3-6 months at 10-20 hours/week?
- Does business model work without full-time support?
- Can I maintain/grow this alone for 1-2 years?
- Will I still be excited about this in 6 months?

## Recovery Patterns

If you recognize your vision in these anti-patterns:

### 1. Acknowledge the Issue
- Name the specific anti-pattern
- Explain impact on product/team
- Get buy-in that change is needed

### 2. Return to Fundamentals
- Customer interviews: Who are we serving?
- Problem validation: What pain are we solving?
- Outcome definition: What does success look like for them?

### 3. Rewrite the Vision
- Use one of the proven frameworks (Moore, Pichler, PR/FAQ)
- Test with stakeholders/customers
- Validate it addresses anti-pattern

### 4. Communicate Change
- Explain what changed and why
- Show how new vision is better
- Update all downstream artifacts (scope, roadmap, specs)

### 5. Establish Guardrails
- Create "never in scope" list
- Define review cadence to catch drift
- Appoint vision keeper (usually product owner)

## Prevention Through Good Habits

**Weekly:**
- Review work against vision: "Does this serve the vision?"
- Catch scope creep early

**Monthly:**
- Review metrics against success criteria
- Update assumptions based on learnings

**Quarterly:**
- Deep vision review with stakeholders
- Adjust scope boundaries if needed
- Revalidate market assumptions

**Annually:**
- Comprehensive vision refresh
- Archive old version
- Communicate changes across organization

Vision anti-patterns are common because creating effective visions is hard. The key is recognizing these patterns early and course-correcting before they compound into major problems.
