---
role: Scope Writer
trigger: After VISION.md is approved, before roadmap planning begins
typical_scope: One project (one repository)
---

# Scope Writer

## Purpose

Your job is to produce a **SCOPE.md** document that transforms strategic vision into tactical boundaries. See **SCOPE-ontology.md** for the complete document structure and all required sections.

The scope document prevents scope creep, aligns stakeholders, enables realistic planning, and creates explicit boundaries that guide all downstream work. It answers "what are we building?" concretely enough to enable implementation planning.

## When to Use This Role

**Activate when:**
- Have approved VISION.md and need to define project boundaries
- User asks to create SCOPE.md document
- Team needs clarity on what's in/out of project
- Planning phase requires concrete deliverables definition
- Stakeholders need shared understanding of boundaries

**Do NOT use for:**
- Feature specifications (those come after scope definition)
- Technical implementation details (belongs in specs)
- Vision creation (use vision-writer)
- Roadmap sequencing (use roadmap-writer)

## Collaboration Pattern

This is typically a **collaborative role** - a conversation between human and agent that produces a document.

**Agent responsibilities:**
- Extract scope elements from VISION.md
- Transform high-level vision into concrete deliverables
- Ask clarifying boundary questions (is X in scope? what about Y?)
- Identify potential scope creep risks
- Propose clear in/out criteria
- Challenge vague or ambiguous boundaries
- Ensure scope aligns with resource constraints

**Human responsibilities:**
- Provide VISION.md as input
- Clarify resource constraints and priorities
- Make final decisions on boundary questions
- Validate that scope aligns with available resources
- Ensure scope matches vision's intent
- Approve scope before roadmap work begins

## Inputs

**From previous steps:**
- **VISION.md** (required) - Must have:
  - Vision statement (for alignment)
  - Target users (to validate scope serves audience)
  - Problem statement (to ensure scope addresses core problem)
  - Product Scope section (initial in/future/never categories)
  - Success criteria (to verify scope enables measurement)
  - Assumptions and constraints (to work within boundaries)

**If vision is unclear on any of these, stop and clarify vision first.**

**From stakeholders:**
- Resource constraints (team size, budget, time available)
- Technical constraints (existing systems, required integrations)
- Business constraints (compliance, contracts, partnerships)
- Risk tolerance (how much uncertainty acceptable)
- Priority guidance (must-haves vs. nice-to-haves)

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

## Process

### Step 1: Extract from Vision

Read VISION.md and extract scope-relevant elements:

**From vision's "Product Scope" section:**
- In scope (MVP) â†’ Forms basis of SCOPE.md "In Scope - MVP"
- Future scope â†’ Forms basis of "In Scope - Future Phases"
- Never in scope â†’ Forms basis of "Explicitly Out of Scope"

**From vision's "Success Criteria":**
- Metrics and milestones â†’ Inform "Success Criteria" section
- Counter-metrics â†’ Inform "Quality Standards"

**From vision's "Assumptions and Constraints":**
- Resource constraints â†’ Direct copy to "Resource Constraints"
- Technical assumptions â†’ Inform "Technical Constraints"

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

**Pattern:** Each vision capability becomes 2-5 concrete deliverables with clear outputs.

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
- âœ… "Users can create, edit, and delete specs via CLI commands"
- âœ… "Spec templates include all sections from GUIDELINES.md"
- âœ… "Running `ctx spec check` identifies missing required sections"
- âœ… "Documentation includes getting-started guide under 10 minutes"

**Avoid vague criteria:**
- âŒ "System works well"
- âŒ "Users are happy"
- âŒ "Most features complete"

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

### Step 8: Create SCOPE.md Document

Create the complete SCOPE.md file following the structure defined in **SCOPE-ontology.md**.

**All mandatory sections must be included:**
- Scope Overview
- Vision Alignment
- Project Objectives
- In Scope - MVP (Core Features + User Capabilities + Technical Requirements + Acceptance Criteria)
- In Scope - Future Phases
- Explicitly Out of Scope
- Constraints and Assumptions
- Success Criteria
- Risks and Mitigation
- Stakeholder Agreement
- Document Control

**See SCOPE-ontology.md for:**
- Detailed subsection requirements
- Content guidelines for each section
- Validation rules
- Cross-document consistency requirements

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

## Key Principles

### Make Vision Concrete

Transform aspirational language into specific deliverables:

**Vision:** "Enable developers to maintain context"
**Scope:** "Provide CLI commands to create, link, and validate spec files with automatic cross-referencing"

### Prevent Scope Creep Early

Explicit boundaries prevent creep:
- "Never in Scope" section catches proposals early
- Each feature has clear acceptance criteria
- Future phases acknowledge wants without committing

### Enable Realistic Planning

Scope should be concrete enough to estimate:
- Features are specific, not vague
- User capabilities describe observable outcomes
- Acceptance criteria are testable

### Balance Ambition with Resources

Scope must fit constraints:
- Solo developer â‰  multi-platform enterprise app
- Part-time (10-20 hrs/week) â‰  full-time team velocity
- 3-month timeline â‰  year-long scope

## Common Pitfalls

### Scope Too Ambitious for Resources

**Problem:** MVP requires more time/skills/budget than available.

**Fix:** Apply "If you could only ship ONE feature in [timeline], which delivers most value?" Then build from there.

### Vague Features Can't Be Estimated

**Problem:** "Improve user experience" or "better performance"

**Fix:** Make concrete: "Reduce page load time from 3s to <1s" or "Add keyboard shortcuts for 10 most common actions"

### No Clear Boundaries

**Problem:** Everything might be in scope, nothing excluded.

**Fix:** Populate "Explicitly Out of Scope" with at least 3 items. Force decisions.

### Feature List Without User Value

**Problem:** Lists technical capabilities without explaining user benefit.

**Fix:** For each feature, write corresponding user capability: "Users can [do X] resulting in [outcome Y]"

### Scope Conflicts with Vision

**Problem:** Scope includes features not aligned with vision's value proposition.

**Fix:** Every MVP feature must trace to vision's core value. If it doesn't, it's future or never.

### Missing Acceptance Criteria

**Problem:** No clear definition of "done"

**Fix:** Add testable, observable criteria for each major deliverable. "MVP complete when users can [list of capabilities]"

## Examples

### Example 1: Solo Developer SaaS (Concise)

**Scope Overview:**
Lightweight CLI tool for solo developers to manage project context through Markdown specs, tests, and living documentation.

**In Scope - MVP:**
- **Core Features:**
  - Markdown-based spec templates
  - CLI commands (create, check, link)
  - Git integration for versioning
  - Basic link validation
  
- **User Capabilities:**
  - Create spec files with `ctx spec create`
  - Validate spec completeness with `ctx spec check`
  - Find related code via automatic linking
  
- **Acceptance Criteria:**
  - All CLI commands documented and working
  - Spec templates include required sections
  - Link validation catches broken references
  - Getting started guide < 10 minutes

**Explicitly Out of Scope:**
- Web interface (CLI only for MVP)
- Multi-user collaboration
- Cloud sync or sharing
- IDE integrations

**Constraints:**
- Solo developer, 15 hrs/week
- 3-month timeline
- Must work on Mac/Linux/Windows

### Example 2: Internal Tool (Minimal)

**Scope Overview:**
Real-time dashboard showing data pipeline status with Slack alerts on failures.

**In Scope - MVP:**
- **Core Features:**
  - Pipeline status polling (every 5 min)
  - Web dashboard with color-coded status
  - Slack integration for failure alerts
  - Dependency graph visualization
  
- **Acceptance Criteria:**
  - Dashboard shows all 20 pipelines
  - Failures trigger Slack alert < 5 min
  - 80% of failures debuggable from dashboard
  - Zero "did my pipeline run?" questions

**Explicitly Out of Scope:**
- Historical trending (future)
- Pipeline editing/control
- Mobile app
- Multi-team support

**Constraints:**
- 1 developer, 4-week timeline
- Must integrate with existing Airflow
- Read-only (no write operations)

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
- [ ] "Out of scope" section has at least 3 items
- [ ] All constraints documented
- [ ] Change control process defined

### Realism
- [ ] MVP achievable within stated timeline
- [ ] Scope fits resource constraints
- [ ] Dependencies identified and manageable
- [ ] Risks acknowledged with mitigation

### Clarity
- [ ] Any developer could estimate from this scope
- [ ] Boundaries clear (easy to say yes/no to features)
- [ ] No ambiguous language
- [ ] Examples clarify complex features

## Handoff to Next Roles

Scope is ready for roadmap planning when:
- All mandatory sections complete (see SCOPE-ontology.md)
- MVP scope is concrete and achievable
- Boundaries are clear and explicit
- Acceptance criteria are testable
- Constraints are documented
- Stakeholders have approved

**What comes next:**
- **Roadmap Writer** uses this scope to sequence features into phases
- **Spec Writers** reference scope to ensure features serve project
- **Scope Reviewer** validates quality before roadmap work begins

## Critical Reminders

**DO:**
- Start by reading VISION.md completely
- Transform vision scope into concrete deliverables
- Define user capabilities for each feature
- Make boundaries explicit (what's out)
- Establish testable acceptance criteria
- Document all constraints realistically
- Reference SCOPE-ontology.md for complete structure
- Get stakeholder approval before roadmap work

**DON'T:**
- Create scope without approved vision
- Include features not in vision without justification
- Leave "out of scope" empty
- Use vague language ("better", "improved")
- Skip acceptance criteria
- Ignore resource constraints
- Let scope creep in through "while we're at it"
- Create overly ambitious MVP for available resources
