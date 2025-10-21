---
role: Scope Writer
trigger: At project inception, or when project boundaries need redefinition
typical_scope: One project (one repository)
---

# Scope Writer

## Responsibilities

The Scope Writer defines what the project includes and excludes, establishing clear boundaries that guide all downstream work. The scope document answers "what are we building?" and serves as the reference point for determining if proposed features belong in this project or elsewhere.

## Collaboration Pattern

This is typically a **collaborative role** - a conversation between human and agent that produces a document.

**Agent responsibilities:**
- Extract key boundaries from vision document
- Ask clarifying questions about edge cases (is X in scope? what about Y?)
- Identify potential scope creep risks
- Propose clear in/out criteria
- Challenge vague or ambiguous boundaries

**Human responsibilities:**
- Provide strategic context and constraints
- Make final decisions on boundary questions
- Validate that scope aligns with available resources
- Ensure scope matches vision's intent
- Approve scope before roadmap work begins

**Collaboration flow:**
1. Agent reads vision document
2. Agent proposes initial scope boundaries based on vision
3. Human provides feedback and clarifications
4. Agent asks boundary questions (specific features in/out?)
5. Together, refine until boundaries are clear
6. Human approves final scope document

## Inputs

### From Previous Steps
- **Vision document**: Why this project exists, what problem it solves, what value it delivers

### From the Human
- Resource constraints (time, budget, skills available)
- Strategic priorities (what matters most?)
- Known non-goals (what are we explicitly NOT doing?)
- External dependencies or constraints

## Process

### 1. Review the Vision
Read the vision document to understand:
- What problem are we solving?
- For whom?
- What value does this create?
- What's the "big picture" success?

### 2. Extract Core Scope from Vision
Identify what the vision implies about scope:
- What capabilities must exist for the vision to be realized?
- What's the minimum viable scope?
- What would be nice-to-have but not essential?

### 3. Define Clear Boundaries
Create explicit in/out criteria:
- **In scope**: What capabilities, features, or components are included?
- **Out of scope**: What's explicitly excluded (to prevent scope creep)?
- **Maybe later**: What might be added in future but not now?

Use concrete examples to clarify boundaries:
- "In scope: Chocolate cakes and apple pies"
- "Out of scope: Savory foods, beverages, non-dessert items"
- "Maybe later: Cookies, brownies (after initial launch proves concept)"

### 4. Identify Key Constraints
Document limitations that shape the scope:
- Technical constraints (existing systems, integrations)
- Resource constraints (solo dev, 6-month timeline)
- Business constraints (must comply with regulation X)
- Domain constraints (delivering to Manhattan only, not other boroughs)

### 5. Define Success Criteria
How will we know this project succeeded?
- Measurable outcomes when possible
- Qualitative goals when measures don't fit
- Time-bound if relevant

### 6. Anticipate Boundary Questions
Think about likely scope questions and pre-answer them:
- "Does this include mobile apps or just web?"
- "Are we supporting all payment methods or just credit cards?"
- "Is multi-language support in scope?"

## Outputs

### Primary Deliverable
**Project scope document** (`SCOPE.md` or `docs/SCOPE.md`) containing:
- Project summary (brief restatement of vision)
- In scope (what we're building)
- Out of scope (what we're not building)
- Key constraints
- Success criteria
- Boundary clarifications (FAQs)

### Handoff Criteria
The scope is ready for roadmap planning when:
- Boundaries are clear enough that someone could propose a feature and you could definitively say "in" or "out"
- Constraints are documented
- Success criteria are defined
- Another person reading this would understand what the project includes/excludes

## Best Practices

### Be Specific, Use Examples
Generic boundaries are useless:
- âœ— "Build a food delivery system"
- âœ“ "Deliver chocolate cakes and apple pies to lower Manhattan addresses"

### Explicitly Name What's Out
Unstated exclusions lead to scope creep:
- âœ“ "Out of scope: Beverages, prepared meals, grocery items"
- âœ“ "Out of scope: Delivery tracking/ETA predictions (v2 feature)"

### Distinguish "Not Now" from "Never"
Some things are out of scope temporarily:
- "Out of scope for v1, planned for later: Cookie delivery"
- "Permanently out of scope: Savory food delivery (different business model)"

### Ground in Vision
Every scope decision should trace back to the vision:
- Why is X in scope? "Because vision requires Y capability, which depends on X"
- Why is Z out of scope? "Vision is about desserts; Z is savory food"

### Make Scope Queryable
Write scope so future questions can be answered by referencing it:
- Someone proposes feature X â†’ Can check scope doc for answer
- If scope doc doesn't clearly answer â†’ Scope needs refinement

### Right-Size the Scope
Consider the resources available:
- Solo dev, 3 months â†’ Limited scope
- Team of 5, 1 year â†’ Broader scope
- Don't let vision's ambition create unrealistic scope

## Common Pitfalls

### Scope = Vision (Too Broad)
**Problem**: Treating scope document as just a restatement of vision, without defining boundaries.

**Solution**: Vision is aspirational and broad. Scope is concrete and bounded. If your scope sounds like "delight customers with amazing service," it's too vague.

### No Clear Out-of-Scope
**Problem**: Only defining what's included, not what's excluded.

**Solution**: Explicitly list what you're NOT doing. This prevents "well, couldn't we also..." conversations later.

### Scope Creep Through Vagueness
**Problem**: Using fuzzy language that allows expansive interpretation.

**Solution**: Use concrete examples. "Support major payment methods" â†’ "Support credit cards (Visa, Mastercard, Amex). Out of scope: PayPal, crypto, buy-now-pay-later."

### Ignoring Constraints
**Problem**: Defining scope without considering resources, time, or technical limitations.

**Solution**: Match scope to reality. Solo dev with 3 months â‰  enterprise platform. Be honest about constraints.

### Over-Engineering the Scope Doc
**Problem**: Creating a 50-page scope document with every possible detail.

**Solution**: Scope defines boundaries, not implementation. Keep it under 5 pages. Details belong in specs.

### Scope Without Success Criteria
**Problem**: Defining what to build but not how to know if it succeeded.

**Solution**: Add measurable outcomes or qualitative goals. "Success = 100 successful deliveries in first month" or "Success = users report satisfaction with delivery speed."

### Static Scope (Never Updates)
**Problem**: Writing scope once at project start, never revisiting as understanding evolves.

**Solution**: Scope can evolve, but changes should be deliberate and documented. If you discover "oh, we need to handle X," update the scope document.

## Examples

### Example 1: Dessert Delivery Service (from your example)

```markdown
# Project Scope: Dessert Drone Delivery

## Vision Summary
Delight people with 5-minute drone delivery of delicious desserts.

## In Scope

### Products
- Chocolate cakes (single-serving size)
- Apple pies (single-serving size)

### Delivery Area
- Lower Manhattan (south of 14th Street)
- Delivery to street addresses and accessible rooftops
- 5-10 minute delivery time target

### Core Capabilities
- Online ordering system (web-based)
- Payment processing (credit cards)
- Drone fleet management
- Recipe development and kitchen operations
- Regulatory compliance (FAA, NYC health department)

## Out of Scope

### Not in Initial Launch
- Other dessert types (cookies, brownies, ice cream)
- Savory foods
- Beverages
- Gift wrapping or custom messages

### Not Our Geography
- Delivery outside lower Manhattan
- Indoor delivery (we deliver to street or roof)

### Not Our Business Model
- Grocery delivery
- Meal kits
- Subscription services (individual orders only)

## Key Constraints

### Technical
- Drone range: 2-mile radius from kitchen
- Payload: Up to 2 lbs per delivery
- Weather: Cannot fly in rain, snow, or high winds

### Regulatory
- FAA Part 107 compliance required
- NYC commercial kitchen licensing
- Food handling certifications

### Resource
- Solo founder, 6-month runway to MVP
- Budget: $50k for initial setup
- Timeline: 4 months to first test delivery

## Success Criteria

**Phase 1 (Month 4)**: First successful test delivery
**Phase 2 (Month 6)**: 10 successful deliveries to real customers
**Phase 3 (Month 9)**: 100 deliveries, 90%+ customer satisfaction

## Boundary Clarifications

**Q: What about gluten-free or vegan options?**
A: Out of scope for v1. Standard recipes only initially.

**Q: Do we deliver to Brooklyn?**
A: No. Manhattan only, specifically south of 14th St.

**Q: Can customers schedule future deliveries?**
A: No. On-demand only. Scheduling is v2 feature.

**Q: Will there be a mobile app?**
A: No. Web-based ordering only for v1.
```

### Example 2: Internal Tool (Smaller Scope)

```markdown
# Project Scope: Team Calendar Sync Tool

## Vision Summary
Eliminate calendar confusion by automatically syncing team availability across tools.

## In Scope

### Core Sync Capability
- Read availability from Google Calendar
- Write availability to Slack status
- Sync every 15 minutes
- Handle multiple team members (5-10 people)

### Configuration
- Simple config file for team member mappings
- Calendar selection (which calendars to monitor)
- Status templates (meeting, focus time, available)

### Deployment
- Run as cron job on team server
- Log sync status for debugging

## Out of Scope

### Integrations
- No Outlook support (team uses Google)
- No Microsoft Teams (team uses Slack)
- No public calendar publishing

### Features
- No calendar event creation (read-only)
- No meeting scheduling
- No automatic meeting notes
- No calendar analytics/reporting

### User Interface
- No web dashboard
- No mobile app
- Config via text file only

## Key Constraints

### Technical
- Team already uses Google Workspace and Slack
- Must run on existing Linux server
- Python 3.9+ (what's on the server)

### Resource
- Solo dev, 2-week timeline
- No budget for external services
- Must be maintenance-free after setup

## Success Criteria

**Week 1**: Successfully sync one user's calendar
**Week 2**: All team members synced, running reliably
**Month 1**: Zero maintenance interventions needed

## Boundary Clarifications

**Q: Can it sync to multiple Slack workspaces?**
A: No, single workspace only.

**Q: What about syncing back from Slack to calendar?**
A: No, one-way sync only (calendar â†’ Slack).

**Q: Can it send notifications?**
A: No, silent operation only. Check logs if issues occur.
```

## When to Deviate

### Scope Less When:
- Very small project (1-2 week effort)
- Prototype/proof-of-concept
- Internal tool with single user (you)

For tiny projects, scope might just be: "Build X tool that does Y. Not doing Z."

### Scope More When:
- Larger project (multi-month effort)
- Multiple stakeholders or users
- Regulatory or compliance concerns
- When project might grow significantly

### Revisit Scope When:
- Major new requirements discovered
- Resource constraints change significantly
- Strategic direction shifts
- After MVP launch (planning v2)

The goal is clarity about boundaries, not perfect prediction of the future.