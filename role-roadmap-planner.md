---
role: Roadmap Planner
trigger: After scope is defined, or when roadmap needs updating based on progress
typical_scope: One project, multiple features/phases
---

# Roadmap Planner

## Responsibilities

The Roadmap Planner sequences the work defined in scope into a practical plan. The roadmap lists anticipated features/phases, their rough definitions, and their order, creating a shared understanding of "what comes next" without over-planning distant future work.

## Collaboration Pattern

This is typically a **collaborative role** - a conversation between human and agent that produces a document.

**Agent responsibilities:**
- Propose logical feature sequencing
- Identify dependencies between features
- Suggest MVP vs. later-phase splits
- Question ordering decisions to surface risks
- Propose rough feature definitions

**Human responsibilities:**
- Set priorities (what matters most?)
- Make tradeoff decisions (speed vs. completeness)
- Validate that sequence makes business sense
- Provide timing constraints or milestones
- Approve roadmap before detailed spec work begins

**Collaboration flow:**
1. Agent reads scope and proposes initial feature breakdown
2. Human provides priority feedback
3. Agent identifies dependencies and suggests ordering
4. Human validates or adjusts sequence
5. Together, refine feature definitions and phases
6. Human approves roadmap

## Inputs

### From Previous Steps
- **Vision document**: Overall direction and value
- **Scope document**: What's in/out, constraints, success criteria

### From Standing Documents
- **SYSTEM_MAP.md** (if project has started): What already exists, current architecture
- **PATTERNS.md** (if project has started): Established approaches

### From the Human
- Strategic priorities (what's urgent vs. what can wait?)
- External deadlines or milestones
- Resource availability (continuous work vs. sprint-based)
- Risk tolerance (ship fast vs. ship complete)

## Process

### 1. Break Scope into Features
Decompose the scope into feature-sized chunks:
- Each feature â‰ˆ one coding session (one spec, one implementation cycle)
- Features should be independently deliverable when possible
- Look for natural boundaries (frontend vs. backend, core vs. nice-to-have)

**Rough feature definition includes:**
- Feature name
- 1-2 sentence description
- Rough size estimate (small/medium/large or hours/days)

### 2. Identify Dependencies
Map out what depends on what:
- Technical dependencies (feature B needs feature A)
- Logical dependencies (users need login before they can save data)
- Foundational features (shared utilities, base architecture)

### 3. Sequence Features
Create an ordered list considering:
- **Dependencies first**: Can't build B without A
- **Foundation early**: Core architecture, shared utilities
- **Value early**: Get something working/usable quickly
- **Risk early**: Tackle unknowns before they can derail later work
- **Complexity spread**: Don't cluster all hard features at the end

Common sequencing patterns:
- "Walking skeleton" (end-to-end minimal flow first)
- "Foundation up" (infrastructure, then features)
- "Value first" (most important user-facing feature first)

### 4. Group into Phases/Milestones
If helpful, cluster features into logical phases:
- Phase 1: MVP / Core functionality
- Phase 2: Polish and extended features
- Phase 3: Scale and optimization

Phases should have clear goals:
- Phase 1 goal: "Deliver first successful dessert"
- Phase 2 goal: "Handle 10 deliveries/day reliably"

### 5. Add Rough Timing
If timing matters, add estimates:
- Can be simple: "2 weeks", "1 month"
- Can be relative: "Feature A: 3 days, Feature B: 1 day"
- Can be milestone-based: "Ship by end of Q2"

**Important**: These are rough estimates, not commitments. They help with planning, not with pressure.

### 6. Flag Uncertainties
Mark features where definition is still fuzzy:
- "Payment integration [NEEDS RESEARCH: which payment provider?]"
- "Drone fleet management [COMPLEX: may need to break down further]"

### 7. Plan for Evolution
Roadmaps change as you learn:
- Mark items as tentative if they might change
- Expect features to be added/removed/reordered
- Plan only the next few features in detail (GTD-inspired)

## Outputs

### Primary Deliverable
**Roadmap document** (`ROADMAP.md` or `docs/ROADMAP.md`) containing:
- List of features/phases in sequence
- Rough feature definitions (1-2 sentences each)
- Dependencies noted
- Rough size/timing estimates (optional)
- Current status tracking (todo/doing/done)

### Updates Over Time
As work progresses, roadmap should be updated:
- Mark features as completed
- Add newly discovered features
- Adjust sequence based on learnings
- Remove features that are no longer relevant

### Handoff Criteria
The roadmap is ready for spec writing when:
- Features are listed in a logical order
- Next 2-3 features to work on are clear
- Each feature has enough definition to start spec conversation
- Dependencies are identified

## Best Practices

### Right-Size Features
Features should be:
- Small enough to complete in roughly one session
- Large enough to deliver value independently
- "Add login form" is too small (part of auth feature)
- "Build entire user management system" is too large (many features)
- "Implement user authentication" is about right

### Plan Detail Inversely to Distance
- **Next feature**: Detailed understanding
- **Next 2-3 features**: Good understanding
- **Features 4-10**: Rough understanding
- **Beyond 10**: Just names/concepts

Following GTD principles: Only detail what you're about to work on.

### Make Dependencies Explicit
Don't just order features, explain why:
- "Feature B: Email notifications (requires Feature A: user accounts, for recipient emails)"

### Keep It Updateable
Roadmap is a living document:
- Add features when you discover them
- Remove features that no longer make sense
- Reorder as priorities change
- Track status (todo/doing/done)

### Balance Ambition with Reality
Roadmaps can be aspirational but should reflect:
- Available resources (solo dev vs. team)
- Available time (3 months vs. 3 years)
- Known complexity (building on existing code vs. greenfield)

### Tie to Success Criteria
Connect roadmap phases to scope success criteria:
- Scope says: "Success = 100 deliveries in month 9"
- Roadmap shows: Features needed to support 100 deliveries/month

### Separate "Must" from "Nice"
Make it clear what's essential vs. optional:
- Core features (without these, project fails)
- Enhancement features (these make it better)
- Experimental features (we might try these)

## Common Pitfalls

### Over-Planning Distant Future
**Problem**: Detailed planning of features 6 months out that will likely change.

**Solution**: Detail the next few features, keep distant features as rough concepts. Embrace emergence.

### Feature Soup (No Sequencing Logic)
**Problem**: Random order of features, no clear reason for the sequence.

**Solution**: Explicitly note dependencies and rationale. "Why is X before Y?" should have an answer.

### Hidden Dependencies
**Problem**: Building feature B, discover it needs A, which isn't built yet.

**Solution**: Think through technical and logical dependencies upfront. Draw a dependency graph if helpful.

### Features Too Large
**Problem**: "Build admin dashboard" as one feature (actually 10+ features).

**Solution**: Break down large concepts into session-sized chunks. Admin dashboard â†’ user list, user edit, activity logs, etc.

### Static Roadmap
**Problem**: Roadmap written once at project start, never updated, becomes outdated immediately.

**Solution**: Update roadmap regularly as features complete, new features discovered, priorities shift.

### No MVP Thinking
**Problem**: Planning to build everything before shipping anything.

**Solution**: Identify minimum viable feature set. What's the smallest thing that delivers value? Build that first.

### Ignoring Risk and Unknowns
**Problem**: Putting all complex/uncertain features at the end, then discovering fundamental problems late.

**Solution**: Tackle big unknowns early. If drone communication protocol is uncertain, prototype that first, don't leave it for month 5.

### Forgetting to Add Emergent Features
**Problem**: Discovering during spec writing that you need feature X, but just spec'ing X without adding it to roadmap.

**Solution**: When you discover a needed feature, STOP and add it to the roadmap first. Maintain artifact-driven workflow.

## Examples

### Example 1: Dessert Delivery Service

```markdown
# Roadmap: Dessert Drone Delivery

## Status Legend
- ðŸ”´ Todo (not started)
- ðŸŸ¡ Doing (in progress)
- ðŸŸ¢ Done (completed)

## Phase 1: Foundation & First Delivery (Months 1-4)

### 1.1 Recipe Development ðŸŸ¢
Finalize recipes for chocolate cake and apple pie that survive drone transport.
- Size: Medium (1-2 weeks)
- Dependencies: None
- Status: Completed

### 1.2 Commercial Kitchen Setup ðŸŸ¢
Secure kitchen space, acquire licenses, set up production capability.
- Size: Large (3-4 weeks)
- Dependencies: None (parallel with recipe dev)
- Status: Completed

### 1.3 Drone Acquisition & Testing ðŸŸ¡
Purchase drones, test payload capacity and range, practice flight operations.
- Size: Large (4 weeks)
- Dependencies: None (parallel with above)
- Status: In progress

### 1.4 Basic Order System ðŸ”´
Web form for placing orders: select dessert, enter delivery address, payment.
- Size: Medium (1 week)
- Dependencies: Need to decide payment provider [DECISION PENDING]
- Status: Not started

### 1.5 Manual Dispatch System ðŸ”´
Simple tool for assigning orders to drones and tracking flights manually.
- Size: Small (3-4 days)
- Dependencies: 1.3 (need to understand drone control API)
- Status: Not started

### 1.6 First Test Delivery ðŸ”´
**Milestone**: Successfully deliver one dessert to a test address.
- Dependencies: All above
- Target: End of Month 4

## Phase 2: Reliability & Scale (Months 5-7)

### 2.1 Payment Processing ðŸ”´
Integrate with payment provider, handle transactions, refunds.
- Size: Medium (1 week)
- Dependencies: 1.4 (order system must exist)
- Status: Not started

### 2.2 Flight Safety Monitoring ðŸ”´
Monitor weather conditions, battery levels, no-fly zones, auto-abort if unsafe.
- Size: Large (2 weeks)
- Dependencies: 1.3 (drone operations)
- Status: Not started

### 2.3 Customer Notifications ðŸ”´
Send order confirmation, flight updates, delivery confirmation via email/SMS.
- Size: Small (3-4 days)
- Dependencies: 1.4 (need customer contact info)
- Status: Not started

### 2.4 Automated Scheduling ðŸ”´
System automatically assigns orders to available drones based on location and capacity.
- Size: Medium (1 week)
- Dependencies: 1.5 (manual dispatch provides requirements understanding)
- Status: Not started

### 2.5 Error Handling ðŸ”´
Handle failed deliveries, weather delays, drone malfunctions gracefully.
- Size: Medium (1 week)
- Dependencies: 2.2, 2.4 (need operational experience first)
- Status: Not started

### 2.6 Reliable Operations ðŸ”´
**Milestone**: 10 successful deliveries to real customers with 90%+ success rate.
- Dependencies: All phase 2 features
- Target: End of Month 7

## Phase 3: Growth (Months 8-12)

### 3.1 Multi-Drone Fleet Management ðŸ”´
Coordinate multiple drones, handle concurrent deliveries, optimize routing.
- Size: Large (2-3 weeks)
- Dependencies: Phase 2 completion (need operational data)

### 3.2 Expanded Menu ðŸ”´
Add cookies and brownies to menu options.
- Size: Small (recipe dev) + Small (menu updates)
- Dependencies: 2.4 (system must be stable first)

### 3.3 Delivery Analytics ðŸ”´
Dashboard showing delivery times, success rates, customer satisfaction.
- Size: Medium (1 week)
- Dependencies: Phase 2 (need data to analyze)

### 3.4 Customer Accounts ðŸ”´
Allow users to save addresses, payment methods, order history.
- Size: Medium (1 week)
- Dependencies: 2.1 (payment system)

### 3.5 Scale Target ðŸ”´
**Milestone**: 100 deliveries/month with 90%+ customer satisfaction.
- Dependencies: All phase 3 features
- Target: End of Month 9

## Future Considerations (Not Scheduled)

These are ideas for later, not committed features:

- Geographic expansion (beyond lower Manhattan)
- Delivery scheduling (order for later)
- Corporate catering orders
- Subscription service
- Mobile app
- Real-time tracking map

## Notes

**Last Updated**: 2025-01-15
**Next Review**: After 1.6 (first test delivery)

**Key Uncertainties**:
- Payment provider selection (evaluating Stripe vs. Square)
- Drone communication reliability (testing in progress)
- Regulatory approval timeline (FAA waiver pending)
```

### Example 2: Internal Tool (Simpler)

```markdown
# Roadmap: Team Calendar Sync Tool

## Features

### 1. Single-User Sync ðŸŸ¡
Read one person's Google Calendar, write to their Slack status.
- Size: 3-4 days
- Dependencies: None
- Status: In progress
- **MVP target**: Get this working end-to-end first

### 2. Multi-User Config ðŸ”´
Config file for mapping multiple team members (calendar â†’ Slack user).
- Size: 1 day
- Dependencies: 1 (need working single-user sync first)
- Status: Not started

### 3. Status Templates ðŸ”´
Configurable status messages (meeting, focus time, available, etc.).
- Size: 1 day
- Dependencies: 1 (need working sync first)
- Status: Not started

### 4. Error Logging ðŸ”´
Log sync failures, API errors, rate limiting for debugging.
- Size: 1 day
- Dependencies: 1 (need something to log first)
- Status: Not started

### 5. Cron Setup ðŸ”´
Deploy to server, configure cron job for 15-minute sync.
- Size: Half day
- Dependencies: 1-4 (need working tool first)
- Status: Not started

## Timeline

- **Week 1**: Features 1-3 (working prototype)
- **Week 2**: Features 4-5 (production deployment)

## Future Ideas (Not Planned)

- Two-way sync (Slack â†’ Calendar)
- Outlook support
- Web dashboard
- Slack commands for manual sync

**Last Updated**: 2025-01-10
```

## When to Deviate

### Minimal Roadmap When:
- Tiny project (1-2 weeks total)
- Single linear path (no choices about ordering)
- Prototype/proof-of-concept (will rewrite anyway)

For tiny projects, roadmap might just be: "Build X, then Y, then deploy."

### Detailed Roadmap When:
- Complex project (multi-month effort)
- Multiple ordering options (need to justify choices)
- Multiple stakeholders (need shared understanding)
- High uncertainty (helps surface questions early)

### Update Frequency:
- Active development: Update after each feature completion
- Between work periods: Update before starting new work
- Major learning: Update when plans significantly change

The goal is a living, useful planning document, not a contract or a perfect prediction.