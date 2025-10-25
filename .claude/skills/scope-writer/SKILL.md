---
name: scope-writer
description: Transform product visions into concrete scope documents that define project boundaries, deliverables, and constraints. Use when you have a VISION.md and need to create SCOPE.md that clarifies what's included, excluded, and deferred while maintaining alignment with strategic direction.
---

# Scope Writer

## Overview

Convert strategic vision into tactical boundaries by creating scope documents that prevent scope creep, align stakeholders, and enable realistic planning. This skill ensures scope documents are concrete enough to guide implementation while flexible enough to accommodate learning.

## When to Use This Skill

**Trigger scenarios:**
- Have approved VISION.md and need to define project boundaries
- User asks to create SCOPE.md document
- Team needs clarity on what's in/out of project
- Planning phase requires concrete deliverables definition
- Stakeholders need shared understanding of boundaries

**Do NOT use for:**
- Feature specifications (those come after scope definition)
- Technical implementation details (belongs in specs)
- Vision creation (use vision-writer skill)
- Roadmap sequencing (use roadmap-planner skill)

## What Scope Documents Do

**Primary purposes:**
1. **Prevent scope creep** - Explicit boundaries show what's excluded
2. **Enable realistic planning** - Concrete deliverables allow estimation
3. **Align stakeholders** - Shared understanding prevents misalignment
4. **Guide prioritization** - Clear MVP vs. future helps decisions
5. **Manage expectations** - Explicit constraints prevent disappointment

**Scope is NOT:**
- Detailed specifications (those follow scope)
- Technical architecture (that's in system design)
- Project schedule (that's in roadmap/timeline)
- Success metrics (those are in vision)

## Inputs Required

### From VISION.md

**Essential elements the scope writer needs:**
- **Vision statement** - To ensure scope aligns with strategic direction
- **Target users** - To validate scope serves right audience
- **Problem statement** - To ensure scope addresses core problem
- **Product scope section** - Initial in/future/never categories
- **Success criteria** - To verify scope enables measurement
- **Assumptions and constraints** - To work within realistic boundaries

**If vision is unclear on any of these, stop and clarify vision first.**

### From Stakeholders

**Additional context needed:**
- Resource constraints (team size, budget, time available)
- Technical constraints (existing systems, required integrations)
- Business constraints (compliance, contracts, partnerships)
- Risk tolerance (how much uncertainty acceptable)
- Priority guidance (must-haves vs. nice-to-haves)

## SCOPE.md Document Structure

### Complete Structure

```markdown
# [Project Name] Scope

## Scope Overview
[2-3 sentence summary of what this project delivers]

## Vision Alignment
**Vision Statement:** [Copy from VISION.md]
**How This Scope Serves Vision:** [Explicit connection]

## Project Objectives
[3-5 concrete, measurable objectives this project achieves]

## In Scope - MVP

### Core Features
[Features that must be in first release]

### User Capabilities
[What users can do after MVP]

### Technical Requirements
[Technical deliverables required for MVP]

### Acceptance Criteria
[How to know MVP is complete]

## In Scope - Future Phases

### Phase 2 (Post-MVP)
[Features/capabilities for second release]

### Phase 3 and Beyond
[Longer-term additions]

### Deferred Features
[Things we want but not yet prioritized]

## Explicitly Out of Scope

### Never in This Project
[Things this project will never include]

### Not in This Version
[Things possible later but definitely not now]

### External Dependencies
[Things other teams/projects must provide]

## Constraints and Assumptions

### Resource Constraints
- Team: [Size and composition]
- Time: [Available timeline]
- Budget: [Financial limits]

### Technical Constraints
- [Existing systems to integrate with]
- [Technology stack limitations]
- [Performance requirements]

### Business Constraints
- [Compliance requirements]
- [Contractual obligations]
- [Market timing pressures]

### Assumptions
- [What we're assuming is true]
- [Risks if assumptions invalid]

## Success Criteria

### MVP Complete When
[Specific, measurable criteria]

### Quality Standards
[Non-functional requirements]

### Acceptance Process
[Who approves and how]

## Risks and Mitigation

### Scope Risks
[Risks of scope being wrong]

### Execution Risks
[Risks during implementation]

### Mitigation Strategies
[How we'll handle risks]

## Stakeholder Agreement

### Key Stakeholders
[Who needs to approve this scope]

### Open Questions
[Unresolved scope decisions]

### Change Control
[How scope changes are handled]

## Document Control

### Version History
[Track scope changes over time]

### Related Documents
- VISION.md - [link]
- ROADMAP.md - [link when created]
- Technical specs - [links when created]
```

## Scope Writing Process

### Step 1: Extract from Vision

Read VISION.md and extract scope-relevant elements:

**From vision's "Product Scope" section:**
- In scope (MVP) → Forms basis of SCOPE.md "In Scope - MVP"
- Future scope → Forms basis of "In Scope - Future Phases"
- Never in scope → Forms basis of "Explicitly Out of Scope"

**From vision's "Success Criteria":**
- Metrics and milestones → Inform "Success Criteria" section
- Counter-metrics → Inform "Quality Standards"

**From vision's "Assumptions and Constraints":**
- Resource constraints → Direct copy to "Resource Constraints"
- Technical assumptions → Inform "Technical Constraints"

**Key principle:** Scope document makes vision concrete without contradicting it.

### Step 2: Make Features Concrete

Transform high-level vision scope into concrete deliverables.

**Vision says:** "Lightweight specification format"  
**Scope says:**
- Markdown-based spec templates
- CLI command to create new specs
- Validation to check spec completeness
- Examples of good specs in documentation

**Vision says:** "Context linking between specs/tests/code"  
**Scope says:**
- Automatic link detection via static analysis
- Cross-reference navigation in CLI
- Link validation in CI pipeline
- Link visualization in status reports

**Pattern:** Each vision capability becomes 2-5 concrete deliverables

### Step 3: Define User Capabilities

For each feature, specify what users can DO after MVP.

**Format:**
"Users can [action] by [method] resulting in [outcome]"

**Examples:**
- "Users can create new feature specs by running `ctx spec create <name>` resulting in pre-populated spec template"
- "Users can find related code by clicking spec references resulting in editor opening relevant files"
- "Users can validate spec completeness by running `ctx spec check` resulting in checklist of required sections"

**This is critical:** Features describe system; capabilities describe user value.

### Step 4: Establish Boundaries

Make scope boundaries explicit and concrete.

**"In Scope - MVP" rules:**
- Must deliver core value proposition from vision
- Must enable measuring primary success metric
- Must be achievable within resource constraints
- Must be minimal (no "nice to haves")

**"Explicitly Out of Scope" rules:**
- Adjacent problems deliberately not solving
- Features that would dilute focus
- User segments not targeting
- Technical approaches ruled out

**"Future Phases" rules:**
- Logical extensions of MVP
- Require MVP to be proven first
- Acknowledge desired but defer

### Step 5: Define Acceptance Criteria

Specify how to know when scope is complete.

**Criteria format:**
- Observable (can verify objectively)
- Testable (can create test for it)
- Specific (no ambiguity)
- Necessary (must have to be complete)

**Example criteria:**
- ✅ "Users can create, edit, and delete specs via CLI commands"
- ✅ "Spec templates include all sections from PATTERNS.md"
- ✅ "Running `ctx spec check` identifies missing required sections"
- ✅ "Documentation includes getting-started guide under 10 minutes"

**Avoid vague criteria:**
- ❌ "System works well"
- ❌ "Users are happy"
- ❌ "Most features complete"

### Step 6: Document Constraints

Make constraints explicit to prevent unrealistic expectations.

**Resource constraints:**
- Team size and composition (solo developer vs. team)
- Available hours per week
- Budget for tools/services
- Timeline pressures

**Technical constraints:**
- Must integrate with existing systems
- Must use approved technology stack
- Performance requirements
- Security/compliance requirements

**Business constraints:**
- Contractual obligations
- Market timing requirements
- Partnership dependencies
- Regulatory compliance

**Assumptions:**
- What we're taking as given
- What happens if assumptions prove wrong
- Which assumptions are validated vs. unvalidated

### Step 7: Establish Change Control

Define how scope changes are handled.

**Change process:**
1. Proposed change documented with rationale
2. Impact assessment (time, resources, risks)
3. Stakeholder review and decision
4. If approved, update SCOPE.md with changelog
5. Communicate changes to team

**Change categories:**
- **Minor clarifications:** Can be made without formal review
- **Scope additions:** Require stakeholder approval and timeline adjustment
- **Scope reductions:** Require stakeholder approval and success criteria update
- **Scope changes:** Require vision re-examination

## Common Scope Patterns

### Pattern 1: MVP + Phased Expansion

**Structure:**
- MVP: Core value only (3-5 features)
- Phase 2: Expand to adjacent use cases (2-4 features)
- Phase 3: Scale and polish (performance, UX, integrations)

**When to use:** Clear core value, logical expansion path

**Example:**
- MVP: Solo developer project context tool
- Phase 2: Small team collaboration features
- Phase 3: IDE integrations and AI assistance

### Pattern 2: Vertical Slice

**Structure:**
- MVP: Complete flow for one user type
- Phase 2: Additional user types
- Phase 3: Cross-user-type features

**When to use:** Multiple distinct user segments

**Example:**
- MVP: Sales manager forecasting
- Phase 2: Individual rep input features
- Phase 3: Executive dashboard

### Pattern 3: Platform + Applications

**Structure:**
- MVP: Core platform capabilities
- Phase 2: First application using platform
- Phase 3: Additional applications

**When to use:** Building reusable foundation

**Example:**
- MVP: Context management infrastructure
- Phase 2: Specification management app
- Phase 3: Test management and documentation apps

### Pattern 4: Feature Parity Then Differentiation

**Structure:**
- MVP: Match existing tool's core features
- Phase 2: Key differentiating features
- Phase 3: Novel capabilities

**When to use:** Migrating users from existing tool

**Example:**
- MVP: Basic project management features
- Phase 2: Living context that existing tools lack
- Phase 3: AI-assisted context generation

## Scope Quality Checklist

### Alignment with Vision
- [ ] Scope explicitly references vision statement
- [ ] Scope delivers on vision's value proposition
- [ ] Scope targets users identified in vision
- [ ] Scope enables measuring vision's success criteria
- [ ] No conflicts between scope and vision

### Concreteness
- [ ] Each feature is specific enough to estimate
- [ ] User capabilities are observable behaviors
- [ ] Acceptance criteria are testable
- [ ] No vague phrases like "better," "improved," "more"
- [ ] Examples provided for complex features

### Completeness
- [ ] All vision "in scope" items addressed
- [ ] MVP scope includes complete user flow
- [ ] Technical requirements specified
- [ ] Quality standards defined
- [ ] Acceptance criteria cover all features

### Boundaries
- [ ] MVP is minimal (no nice-to-haves)
- [ ] "Explicitly out of scope" prevents common expansions
- [ ] Future phases show evolution path
- [ ] Deferred features acknowledged
- [ ] Clear what other teams must provide

### Realism
- [ ] MVP achievable with stated resources
- [ ] Timeline accounts for unknowns
- [ ] Technical constraints acknowledged
- [ ] Risks identified with mitigation
- [ ] Assumptions documented

### Stakeholder Alignment
- [ ] Key stakeholders identified
- [ ] Open questions documented
- [ ] Change control process defined
- [ ] Success criteria agreed upon
- [ ] Constraints acknowledged by all parties

## Common Pitfalls

### Pitfall 1: Scope Creep Disguised as Clarification

**Problem:** "Clarifying" scope by adding features not in vision.

**Example:**
- Vision: "Lightweight specification format"
- Scope adds: "AI-powered spec generation, visual spec editor, collaborative editing"

**Why problematic:** Violates vision's MVP boundaries.

**Fix:** Additions must either go to future phases or trigger vision update.

### Pitfall 2: Vague Deliverables

**Problem:** Scope lists high-level capabilities without concrete deliverables.

**Example:**
- ❌ "Better project management"
- ❌ "Improved user experience"
- ❌ "Enhanced performance"

**Why problematic:** Can't estimate, can't validate completion.

**Fix:** Every capability must have 2-5 concrete, testable deliverables.

### Pitfall 3: Missing "Out of Scope"

**Problem:** Only defining what's included, not what's excluded.

**Why problematic:** Allows scope creep, doesn't set expectations.

**Fix:** "Explicitly Out of Scope" section is mandatory, not optional.

### Pitfall 4: Unrealistic MVP

**Problem:** MVP includes too much for available resources.

**Example:**
- Solo developer with 10 hrs/week
- 6-month timeline
- MVP includes: web app, iOS app, Android app, API, documentation

**Why problematic:** Sets up guaranteed failure.

**Fix:** MVP should be 70% of what seems minimal. Defer everything else.

### Pitfall 5: No Acceptance Criteria

**Problem:** Scope lists features but not how to know when done.

**Why problematic:** Can't determine if scope is complete.

**Fix:** Every MVP feature needs observable, testable acceptance criteria.

### Pitfall 6: Ignoring Constraints

**Problem:** Scope doesn't account for real-world limitations.

**Example:**
- Scope requires integration with system team doesn't control
- No time/budget for required third-party services
- Technical constraint makes approach infeasible

**Why problematic:** Scope looks good on paper but can't be executed.

**Fix:** Document all constraints explicitly and verify scope is achievable within them.

### Pitfall 7: No Change Control

**Problem:** No process for handling scope changes.

**Why problematic:** Ad-hoc scope changes cause chaos and drift.

**Fix:** Define change control process upfront. Minor clarifications vs. major changes.

## Review and Validation

### Self-Review Questions

**Vision alignment:**
- Does this scope deliver on the vision's value proposition?
- Would completing this scope enable measuring vision success criteria?
- Are there any conflicts with vision direction?

**Concreteness:**
- Could someone estimate time/effort for each deliverable?
- Are acceptance criteria testable?
- Can I demonstrate each user capability?

**Completeness:**
- Does MVP include complete user journey?
- Are technical requirements specified?
- Do I know what "done" looks like?

**Boundaries:**
- Is MVP truly minimal?
- Have I explicitly called out common scope creep areas?
- Is it clear what we're NOT doing?

**Realism:**
- Is this achievable with stated resources?
- Have I accounted for unknowns?
- Are constraints realistic?

### Stakeholder Review

**Get explicit approval on:**
- MVP feature list (what's included)
- Out of scope list (what's excluded)
- Success criteria (how we know when done)
- Resource constraints (time, budget, team)
- Risk acceptance (what could go wrong)

**Common stakeholder concerns:**
- "But we also need X" → Is X in vision? If no, update vision first. If yes, is it Phase 2?
- "This seems like too little" → MVP should feel small. That's the point.
- "Can we add just one more thing?" → No. That's how scope creep starts.
- "What about Y?" → Is Y in "Explicitly Out of Scope"? Add it there.

## Examples

### Example 1: Developer Tool - Full Scope

```markdown
# DevContext Scope

## Scope Overview
DevContext MVP delivers a command-line tool that helps solo developers maintain 
project context across features and time through Git-integrated, Markdown-based 
specifications and living documentation.

## Vision Alignment
**Vision Statement:** "Help solo developers maintain project context across planning 
and execution without documentation overhead"

**How This Scope Serves Vision:** Delivers complete MVP that enables the core value 
proposition of eliminating context reconstruction time. Users can create specs, link 
them to code, and maintain living docs as byproduct of development workflow.

## Project Objectives
1. Enable spec creation in <2 minutes via CLI
2. Automatic linking between specs, tests, and implementation
3. Living docs (SYSTEM_MAP, PATTERNS) stay current automatically
4. Context retrieval in <30 seconds via CLI queries
5. Zero-setup for new projects (works with existing Git repos)

## In Scope - MVP

### Core Features

**Specification Management:**
- `ctx spec create <name>` - Generate spec from template
- `ctx spec list` - Show all specs with status
- `ctx spec edit <name>` - Open spec in $EDITOR
- `ctx spec check <name>` - Validate completeness

**Context Linking:**
- Static analysis detects spec/test/code relationships
- `ctx find <spec>` - Show related tests and code
- `ctx trace <file>` - Show specs/tests for given file
- Link validation in pre-commit hook

**Living Documentation:**
- SYSTEM_MAP.md template generation
- Automatic component detection from code structure
- `ctx docs update` - Refresh docs from current code
- `ctx docs check` - Verify docs current with code

**Project Setup:**
- `ctx init` - Initialize DevContext in existing Git repo
- Template installation for specs and docs
- Configuration via `.devcontext/config.yml`

### User Capabilities After MVP
- Users can create new feature specs in under 2 minutes by running `ctx spec create`
- Users can find all code related to a spec in under 30 seconds by running `ctx find`
- Users can verify living docs are current by running `ctx docs check`
- Users can set up DevContext in new project in under 5 minutes by running `ctx init`
- Users can validate spec completeness before implementation by running `ctx spec check`

### Technical Requirements
- Python 3.9+ CLI tool installed via pip
- Git repository (uses Git for storage, no separate DB)
- Works on macOS, Linux, Windows (WSL)
- Configuration via YAML files
- Markdown files are source of truth
- Static analysis via Python AST parsing

### Acceptance Criteria

**Specification Management:**
- [ ] Creating spec generates Markdown file with all template sections
- [ ] Spec templates include: Overview, Interface, Behavior, Dependencies, Testing
- [ ] `ctx spec list` shows spec name, status (proposed/todo/doing/done), and file path
- [ ] `ctx spec check` identifies missing required sections with specific error messages

**Context Linking:**
- [ ] Python files with docstring references to specs are automatically linked
- [ ] `ctx find` shows related files within 1 second
- [ ] Links validated in pre-commit hook (fails commit if broken)
- [ ] Link format documented in getting-started guide

**Living Documentation:**
- [ ] `ctx init` generates SYSTEM_MAP.md template
- [ ] SYSTEM_MAP.md includes: Modules, Dependencies, Key Abstractions sections
- [ ] `ctx docs update` detects new modules and adds to SYSTEM_MAP
- [ ] `ctx docs check` shows specific sections that need updating

**Project Setup:**
- [ ] `ctx init` completes in under 60 seconds
- [ ] Works with existing Git repos (no repo restructuring required)
- [ ] Configuration options documented with examples
- [ ] Uninstall removes all DevContext files cleanly

**Quality Standards:**
- [ ] CLI commands respond in <1 second for typical projects
- [ ] Works with projects up to 10,000 files
- [ ] Test coverage >80% for core functionality
- [ ] Getting-started guide enables productivity in under 10 minutes

## In Scope - Future Phases

### Phase 2: Editor Integration (6-8 weeks post-MVP)
- VS Code extension for in-editor spec access
- Inline spec navigation (click spec reference → opens spec)
- Quick spec creation from editor
- Link validation in real-time

### Phase 3: AI Assistance (3-4 months post-MVP)
- AI-suggested spec content from code analysis
- Automatic living doc updates from commit messages
- Context summarization for returning to old projects

### Deferred Features
- Web-based interface (CLI sufficient for MVP validation)
- Real-time collaboration (focus on solo developer first)
- Integration with issue trackers (keep scope minimal)
- Mobile apps (not relevant for developer tool)

## Explicitly Out of Scope

### Never in This Project
- General project management (time tracking, resource allocation, gantt charts)
- Communication/chat features (use existing tools like Slack)
- Bug tracking system (beyond simple BUG_LEDGER.yml)
- CI/CD pipeline management (integrate with existing CI)
- Code generation or automated implementation

### Not in This Version (Definitely Not MVP)
- Visual interfaces (web or desktop apps)
- Team collaboration features
- Integration with cloud services
- Real-time synchronization
- Plugin/extension ecosystem

### External Dependencies (Other Teams Must Provide)
- N/A - This is standalone tool with no external dependencies

## Constraints and Assumptions

### Resource Constraints
- **Team:** Solo developer
- **Time:** 15 hours/week for 3 months (180 hours total)
- **Budget:** $0 (open source, no paid services)

### Technical Constraints
- Must work with existing Git repos (no special repo structure)
- Python 3.9+ required (use modern Python features)
- No server/database required (works offline)
- Must be cross-platform (macOS, Linux, Windows/WSL)

### Business Constraints
- Open source from day one (MIT license)
- No funding requirement (must be sustainable as side project)
- Launch within 3 months (market timing)

### Assumptions
- **Target users know Git basics** - Risk: Some users might not. Mitigation: Excellent onboarding docs.
- **CLI is acceptable for MVP** - Risk: Users might demand GUI. Mitigation: Validate with early users.
- **Static analysis is sufficient for linking** - Risk: Might miss complex references. Mitigation: Allow manual links.
- **Solo developers experience this pain** - Risk: Problem might not be important. Mitigation: 10 customer interviews done, validated.

## Success Criteria

### MVP Complete When
1. All acceptance criteria in "In Scope - MVP" are met
2. 5 beta users can complete getting-started guide in under 10 minutes
3. Beta users report context retrieval time reduced from 30+ min to <1 min
4. Zero critical bugs reported by beta users
5. Documentation is complete (getting started, reference, examples)

### Quality Standards
- Test coverage >80% for core functionality
- CLI commands respond in <1 second for typical projects (1000 files)
- Zero data loss (specs/docs must never be corrupted)
- Works offline (no internet required after installation)
- Clean uninstall (removes all DevContext files without affecting project)

### Acceptance Process
- Beta testing with 5 target users (2 weeks)
- Address all critical feedback
- Final review by project owner (self)
- Public launch on GitHub

## Risks and Mitigation

### Scope Risks

**Risk:** MVP scope too ambitious for 180 hours  
**Probability:** Medium  
**Impact:** High (failure to launch)  
**Mitigation:** Built-in 20% buffer. If behind schedule at 50% mark, cut Phase 2 features from MVP.

**Risk:** Users want features not in MVP  
**Probability:** High  
**Impact:** Low (expected and manageable)  
**Mitigation:** Clear roadmap shows future phases. Collect feature requests for Phase 2.

### Execution Risks

**Risk:** Static analysis more complex than expected  
**Probability:** Medium  
**Impact:** Medium (could delay MVP)  
**Mitigation:** Prototype linking in week 1. If too complex, simplify to manual links only.

**Risk:** Cross-platform compatibility issues  
**Probability:** Low  
**Impact:** Medium (limits user base)  
**Mitigation:** Test on all platforms weekly. Focus on macOS/Linux first, Windows/WSL as stretch goal.

## Stakeholder Agreement

### Key Stakeholders
- Project owner (solo developer) - Must approve all scope decisions
- Beta users (5 target users) - Feedback during development
- Open source community - Input on design decisions

### Open Questions
- Should we include PATTERNS.md in MVP or defer to Phase 2? → Leaning toward inclusion, only adds ~10 hours
- Windows native support or WSL-only for MVP? → Start with WSL, add native if users request
- Telemetry/analytics to understand usage? → Defer to Phase 2, focus on MVP

### Change Control

**Process:**
1. Proposed change documented in GitHub issue
2. Impact assessment (time, alignment with vision, risks)
3. Decision by project owner within 48 hours
4. If approved, SCOPE.md updated with changelog entry
5. Communicate to beta users

**Change categories:**
- **Clarifications:** Can update immediately (no timeline impact)
- **Additions:** Require formal review, timeline adjustment
- **Reductions:** Require justification, success criteria update
- **Scope changes:** May require vision re-examination

## Document Control

### Version History

**Version 1.0 - 2025-01-15**
- Initial scope document
- MVP defined: CLI tool with specs, linking, living docs
- 3-month timeline, 180 hours effort

### Related Documents
- [VISION.md](./VISION.md) - Strategic direction
- [ROADMAP.md](./ROADMAP.md) - Feature sequencing (to be created)
- Technical specs - (to be created during implementation)
```

### Example 2: Internal Tool - Minimal Scope

```markdown
# Data Pipeline Monitor Scope

## Scope Overview
Dashboard showing real-time status of all data pipelines with Slack alerts on failures 
and quick access to logs for debugging. Replaces manual log checking and reduces mean 
time to detect failures from 2+ hours to under 5 minutes.

## Vision Alignment
**Vision:** "Give data team instant visibility into pipeline health without manual 
log checking"

**How This Scope Serves Vision:** Delivers complete visibility and alerting system 
that eliminates manual log checking and provides debugging context immediately.

## In Scope - MVP (4 weeks)

**Dashboard:**
- Real-time status for all 30+ daily pipelines
- Color-coded status (green/yellow/red)
- Last run time and duration
- Success/failure trend (7 days)

**Alerting:**
- Slack notifications on pipeline failures
- Include pipeline name, error message, and log link
- Alert to #data-ops channel

**Debugging:**
- Click pipeline → view full logs
- Show last 5 runs with status
- Link to relevant data samples
- Dependency graph visualization

**Setup:**
- Integrate with existing Airflow instance
- Works with current logging infrastructure
- No changes to existing pipelines required

## Explicitly Out of Scope
- Pipeline editing/creation (use Airflow for that)
- Historical data >30 days (keep recent only)
- Performance optimization suggestions (future enhancement)
- Cost tracking (separate project)

## Success Criteria
- MTTD (mean time to detect) <5 minutes (currently 2+ hours)
- 80% of failures debuggable from dashboard (vs. SSH to servers)
- Zero Slack escalations asking "did my pipeline run?"
- 100% of pipelines monitored within 2 weeks of launch

## Constraints
- Must use existing infrastructure (no new services)
- No changes to existing pipelines (read-only integration)
- 4-week deadline (hard constraint)
- 1 engineer part-time
```

## Critical Reminders

**DO:**
- Start from VISION.md and maintain alignment
- Make every feature concrete and testable
- Define explicit boundaries (out of scope)
- Specify user capabilities, not just features
- Include acceptance criteria for every deliverable
- Document all constraints realistically
- Establish change control process
- Get stakeholder approval before proceeding

**DON'T:**
- Add features not in vision without updating vision first
- Use vague language ("better," "improved," "enhanced")
- Skip "explicitly out of scope" section
- Make MVP too ambitious for resources
- Ignore constraints and assume ideal conditions
- Promise deliverables without acceptance criteria
- Allow scope changes without formal process
- Proceed to planning without stakeholder sign-off
