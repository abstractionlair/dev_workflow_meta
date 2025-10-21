---
role: Vision Writer
trigger: At project inception, before any other planning begins
typical_scope: One project (the entire initiative)
---

# Vision Writer

## Responsibilities

The Vision Writer articulates the fundamental purpose and aspirational outcome of a project. The vision captures the "why" - what problem this solves, for whom, and what success looks like at the highest level. This serves as the north star that informs all downstream decisions in scope, roadmap, and implementation.

## Collaboration Pattern

This is a **highly collaborative role** - an exploratory conversation between human and agent that crystallizes ideas into a clear vision statement.

**Agent responsibilities:**
- Ask probing questions to understand motivations
- Help articulate the core value proposition
- Identify who benefits and how
- Challenge vague statements with requests for concrete examples
- Ensure vision is inspirational yet grounded
- Capture essence in clear, memorable language

**Human responsibilities:**
- Provide the initial spark or idea
- Explain personal/business motivations
- Describe the problem being solved
- Validate that vision captures intent
- Ensure vision is ambitious yet achievable
- Make final decisions on vision framing

**Collaboration flow:**
1. Human shares initial idea or problem
2. Agent asks clarifying questions about goals, users, value
3. Agent proposes vision statement
4. Human and agent iterate on framing
5. Agent expands into vision document structure
6. Human approves final vision

## Inputs

### From the Human
- Initial idea or problem statement
- Target users or beneficiaries
- Personal/business motivations
- Constraints or context (time, resources, capabilities)
- Examples of similar projects or inspirations
- What "success" means

### No Other Inputs
Vision is the first document - no upstream artifacts to reference.

## Process

### 1. Explore the Idea
Start with open questions to understand the human's motivation:
- What problem are you trying to solve?
- Who has this problem?
- Why does this matter to you?
- What would success look like?
- Have you seen similar solutions? What did you like/dislike?

### 2. Identify the Core Value
Distill the idea to its essence:
- What's the fundamental benefit being delivered?
- What makes this valuable/exciting?
- What would users/customers say this enables?
- What's the "magic moment" when it works?

**Example:**
- Idea: "Drone delivery service for desserts"
- Core value: "Instant gratification - craving to satisfaction in 5 minutes"

### 3. Define Success Outcomes
Clarify what success looks like:
- What does "winning" mean for this project?
- Qualitative: How do people feel? What do they say?
- Quantitative: What numbers matter? (users, revenue, time saved)
- Timeframe: When should this success be evident?

### 4. Ground in Reality
Connect aspiration to feasibility:
- What resources are available? (time, budget, skills)
- What constraints exist? (regulatory, technical, market)
- What's achievable vs. what's a stretch goal?
- What must be true for this to succeed?

### 5. Craft the Vision Statement
Create a concise, memorable articulation:
- Start with the benefit: "We will [delight/enable/transform]..."
- State the audience: "...people/customers/users..."
- Describe the outcome: "...with [key benefit/experience]"
- Keep it under 3 sentences

**Formula**: [Action verb] + [audience] + [with/through] + [value proposition]

**Examples:**
- "We will delight people with 5-minute drone delivery of delicious desserts."
- "We will enable small teams to sync calendars automatically, eliminating scheduling confusion."
- "We will help solo developers maintain architecture knowledge as projects grow."

### 6. Expand with Context
Add supporting detail:
- **Problem**: What pain point does this address?
- **Solution approach**: High-level how (not detailed implementation)
- **Value delivered**: Why this matters
- **Success criteria**: What outcomes indicate success
- **Constraints**: Key limitations or boundaries

## Outputs

### Primary Deliverable
**VISION.md** containing:
- Vision statement (1-3 sentences)
- Problem description
- Solution approach (high-level)
- Value proposition
- Success criteria
- Key constraints (if relevant)

### Vision Document Format

```markdown
# Vision: [Project Name]

## Vision Statement
[1-3 sentence aspirational statement]

## The Problem
[What problem exists? Who has it? Why does it matter?]

## Our Solution
[High-level approach - the "how" without implementation details]

## Value Delivered
[Why this matters - benefits to users/customers/stakeholders]

## Success Looks Like
[Qualitative and quantitative outcomes that indicate success]

## Key Constraints
[Important limitations: time, budget, regulatory, technical]
```

### Handoff Criteria
Vision is ready for scope writing when:
- Core value is clear and compelling
- Problem and solution are well-articulated
- Success criteria are defined
- Human feels excited and aligned
- Another person reading this would understand "why we're doing this"

## Best Practices

### Start Broad, Then Focus
Begin with open exploration:
- Let human share their excitement
- Ask about motivations and context
- Don't jump to details immediately

Then narrow to essence:
- What's the core benefit?
- What's the simplest articulation?

### Make It Memorable
Vision should be quotable:
- Short enough to remember
- Clear enough to explain
- Inspiring enough to motivate

Test: Can you explain this vision in one sentence to a friend?

### Balance Aspiration and Reality
Vision should be:
- **Aspirational**: Exciting, ambitious, inspiring
- **Grounded**: Achievable given constraints
- **Honest**: Acknowledges limitations

Avoid:
- âœ— "We will revolutionize everything for everyone"
- âœ“ "We will delight dessert lovers in Manhattan with 5-minute drone delivery"

### Connect Problem to Solution
Make the "why" explicit:
- What problem exists?
- Why does current state hurt?
- How does our solution address this?
- What changes for users?

### Define Success Concretely
Vague: "Success means happy customers"
Concrete: "Success = 100 deliveries in first 3 months with 90%+ satisfaction"

Use measurables when possible.

### Keep Implementation Out
Vision describes "what" and "why," not "how":
- âœ“ "5-minute drone delivery"
- âœ— "Using DJI drones with GPS waypoint navigation"

Implementation details belong in specs, not vision.

## Common Pitfalls

### Vague or Generic Vision
**Problem**: Vision could apply to any project in the domain.

**Example**: "We will build great software that customers love"

**Solution**: Be specific. What makes *this* project unique? "We will enable solo developers to maintain architecture knowledge through AI-augmented documentation workflows."

### Confusing Vision with Plan
**Problem**: Vision document reads like a roadmap or spec.

**Solution**: Vision is aspirational direction. Details belong in scope/roadmap. Keep vision high-level.

### No Clear Value Proposition
**Problem**: What's being built is clear, but not *why* it matters.

**Solution**: Always articulate the benefit. Don't just say "what" - say "what this enables/prevents/improves."

### Ignoring Constraints
**Problem**: Vision is so ambitious it's clearly unachievable.

**Solution**: Acknowledge reality. Solo dev with 3 months â‰  enterprise platform. Be honest about constraints.

### Success Criteria Missing
**Problem**: No way to know if project succeeded.

**Solution**: Define success outcomes. What metrics, milestones, or outcomes indicate we've achieved the vision?

### Too Long or Detailed
**Problem**: Vision document is 10 pages of details.

**Solution**: Keep it concise. Vision should be readable in 5 minutes. Details belong in downstream docs.

## Examples

### Example 1: Dessert Drone Delivery

```markdown
# Vision: Dessert Drone Delivery

## Vision Statement
We will delight people with 5-minute drone delivery of delicious desserts.

## The Problem
Late-night dessert cravings are real, but options are limited. Walking to a bakery takes 20+ minutes. Traditional delivery takes 45+ minutes. By the time the dessert arrives, the craving has passed or you've settled for something else. People want instant gratification for spontaneous treats.

## Our Solution
On-demand drone delivery of fresh desserts from our commercial kitchen to anywhere in lower Manhattan. Order via web, dessert arrives by drone in 5-10 minutes. Focus on items that travel well: chocolate cakes and apple pies initially.

## Value Delivered
- **Instant gratification**: Craving to satisfaction in minutes, not hours
- **Quality preserved**: Fresh-baked items, not sitting in delivery bags
- **Unique experience**: Fun, futuristic, memorable
- **Convenience**: No need to leave home or plan ahead

## Success Looks Like
- **Phase 1 (Month 4)**: First successful test delivery to real customer
- **Phase 2 (Month 6)**: 10 successful deliveries with 90%+ customer satisfaction
- **Phase 3 (Month 9)**: 100 deliveries/month, profitable unit economics

## Key Constraints
- **Geography**: Lower Manhattan only (drone range limitation)
- **Regulatory**: FAA Part 107 compliance required
- **Weather**: Cannot fly in rain, snow, or high winds
- **Product**: Limited to items that survive 5-minute flight
- **Timeline**: 6-month runway to prove concept
```

### Example 2: Team Calendar Sync Tool

```markdown
# Vision: Team Calendar Sync

## Vision Statement
We will eliminate calendar confusion by automatically syncing team availability across tools.

## The Problem
Our team uses Google Calendar for meetings but Slack for communication. People frequently ask "Are you available?" only to find out someone is in a meeting. Manually updating Slack status is tedious and forgotten. We waste time coordinating what's already in our calendars.

## Our Solution
Automatic sync from Google Calendar to Slack status. Every 15 minutes, the tool reads each team member's calendar and updates their Slack status accordingly. "In meeting," "Focus time," "Available" - whatever the calendar says, Slack reflects.

## Value Delivered
- **Visibility**: Team knows who's available without asking
- **Time saved**: No manual status updates
- **Reduced interruptions**: Don't message people who are in meetings
- **Better coordination**: Easier to find time for quick chats

## Success Looks Like
- **Week 1**: Single user's calendar syncing reliably
- **Week 2**: All 8 team members synced, zero manual interventions
- **Month 1**: Team reports reduced "are you free?" messages

## Key Constraints
- **Team size**: 5-10 people (not building for scale)
- **Tools**: Google Calendar + Slack only (what we use)
- **Maintenance**: Must be set-and-forget (no time for ongoing tweaks)
- **Timeline**: 2 weeks to ship
```

### Example 3: Architecture Amnesia Prevention

```markdown
# Vision: AI-Augmented Development Workflow

## Vision Statement
We will help solo developers maintain architecture knowledge as projects grow, preventing the "architecture amnesia" that occurs when working with AI agents across multiple sessions.

## The Problem
Solo developers working with AI agents (like Claude) face a recurring issue: as projects grow beyond a single session, the AI loses track of existing patterns, blessed utilities, and past decisions. This leads to reimplementation, inconsistent patterns, and repeated bugs. The conversation context disappears, but the codebase remains. Developers spend time re-explaining architecture or finding mistakes after the fact.

## Our Solution
A structured workflow with living documentation (SYSTEM_MAP, PATTERNS, RULES, BUG_LEDGER) that serves as persistent memory. Each role in the workflow (Spec Writer, Test Writer, Implementation Reviewer, etc.) references these docs, ensuring consistency. The Platform Lead maintains docs as the project evolves.

## Value Delivered
- **Consistency**: Patterns are documented and followed
- **Quality**: Reviews catch issues before merge
- **Learning**: Past bugs don't repeat (BUG_LEDGER + sentinel tests)
- **Onboarding**: New contexts can quickly understand architecture
- **Scalability**: Process works for projects lasting months, not just days

## Success Looks Like
- **Low regression rate**: Old bugs don't return
- **High pattern reuse**: Utilities reused, not reinvented
- **Fast recovery**: New chat sessions can resume work effectively
- **Maintainability**: Codebase stays understandable as it grows

## Key Constraints
- **Solo developer focus**: Designed for individuals, not large teams
- **AI-augmented workflow**: Assumes AI agents as collaborators
- **Lightweight process**: Not heavyweight enterprise methodology
```

## When to Deviate

### Skip Vision When:
- Trivial project (1-day script)
- Well-understood problem with obvious solution
- Personal tool where you're the only user
- Prototype meant to be thrown away

For tiny projects, mental clarity may suffice.

### Lightweight Vision When:
- Small internal tool (2-3 week effort)
- Problem and solution are very clear
- Solo project with no handoff

Vision can be 1 paragraph if sufficient.

### Detailed Vision When:
- Large project (multi-month effort)
- Multiple stakeholders or users
- Complex problem space
- Seeking funding or approval
- Team project requiring alignment

Invest in thorough vision articulation.

## Critical Reminders

**DO:**
- Start with questions, not assumptions
- Make vision specific and memorable
- Define concrete success criteria
- Acknowledge constraints honestly
- Keep implementation details out
- Balance aspiration with reality

**DON'T:**
- Write generic vision that could be any project
- Include technical implementation details
- Skip success criteria definition
- Ignore resource/time constraints
- Make vision a long spec document
- Confuse vision with roadmap

The goal is a clear, inspiring north star that guides all downstream decisions and keeps the project focused on delivering real value.