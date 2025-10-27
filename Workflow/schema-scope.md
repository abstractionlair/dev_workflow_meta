# SCOPE.md Document Ontology

## Purpose

This document defines the structure, semantics, and validation rules for SCOPE.md files in the AI-augmented software development workflow. SCOPE.md is the **tactical boundaries document** that translates strategic vision into concrete deliverables, preventing scope creep and enabling realistic planning.

## Document Role in Workflow

```
VISION.md (strategic) → SCOPE.md (tactical) → ROADMAP.md (operational) → Specs → Implementation
```

**SCOPE.md is consumed by:**
- roadmap-writer (creates ROADMAP.md)
- Human stakeholders (approval and alignment)
- Future specification writers (understands boundaries)

**SCOPE.md is created by:**
- scope-writer (primary)
- Human product owners (collaboratively with scope-writer)

**SCOPE.md lifecycle:**
- Created: After VISION.md is approved
- Updated: When learnings require scope adjustments (quarterly typical)
- Archived: Old versions preserved when significant changes occur

## Document Structure

### Complete Canonical Structure

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
[What users can DO after MVP]

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
- **Team:** [Size and composition]
- **Time:** [Available timeline]
- **Budget:** [Financial limits]

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

## Section Semantics

### Scope Overview

**Purpose:** Executive summary of what the project delivers.

**Content requirements:**
- 2-3 sentences maximum
- States what gets delivered (deliverables, not vision)
- Concrete and specific
- Anyone can understand without reading full document

**Quality criteria:**
- Answers "what are we building?"
- Specific enough to guide (not vague)
- Brief enough to remember
- Links to vision is clear

**Consumed by:**
- roadmap-writer: Quick understanding of scope
- Stakeholders: Rapid comprehension

**Examples:**
- ✓ "DevContext MVP delivers a command-line tool that helps solo developers maintain project context through Git-integrated specifications and living documentation"
- ✗ "A better way to manage projects" (too vague)
- ✗ "Complete enterprise-grade context management platform with AI, collaboration, mobile apps, and analytics" (feature list, unrealistic for MVP)

### Vision Alignment

**Purpose:** Explicit connection between scope and vision.

**Content requirements:**

**Vision Statement:**
- Exact copy from VISION.md
- Ensures scope references authoritative vision

**How This Scope Serves Vision:**
- 1-2 sentences explaining connection
- Shows how scope delivers on vision value proposition
- Makes alignment explicit, not assumed

**Quality criteria:**
- Vision statement matches VISION.md exactly
- Connection is clear and direct
- No conflicts between scope and vision

**Consumed by:**
- roadmap-writer: Validates features serve vision
- Stakeholders: Confirms strategic alignment

**Anti-patterns:**
- Paraphrased vision (use exact copy)
- No connection explanation (assumed alignment)
- Scope contradicts vision direction

### Project Objectives

**Purpose:** Concrete, measurable objectives this scope achieves.

**Content requirements:**
- 3-5 specific objectives
- Each objective is:
  - Measurable (can verify achievement)
  - Achievable within scope
  - Aligned with vision success criteria
  - Actionable (clear what to build)

**Quality criteria:**
- Objectives more specific than vision
- Each objective contributes to vision metrics
- Can determine if objective is met
- No vague aspirations

**Consumed by:**
- roadmap-writer: Guides feature prioritization
- Implementation teams: Understanding success

**Examples:**
- ✓ "Enable spec creation in <2 minutes via CLI"
- ✓ "Automatic linking between specs, tests, and implementation"
- ✓ "Context retrieval in <30 seconds via CLI queries"
- ✗ "Improve developer productivity" (too vague)
- ✗ "Create best-in-class experience" (not measurable)

### In Scope - MVP

**This section is CRITICAL for roadmap-writer.**

**Purpose:** Define exactly what must be delivered in first release.

**Content requirements:**

**Core Features (mandatory subsection):**
- List of features that MUST be in MVP
- Each feature at capability level (not detailed specs)
- 3-7 features typical for MVP
- Features deliver on vision's "In Scope (MVP)"
- Each feature briefly described (1-2 sentences)

**User Capabilities (mandatory subsection):**
- What users can DO after MVP
- Format: "Users can [action] by [method] resulting in [outcome]"
- Observable behaviors (can be demonstrated)
- Focuses on user value, not system internals
- 5-10 capabilities typical

**Technical Requirements (mandatory subsection):**
- Infrastructure needed for MVP
- Required integrations
- Platform/technology constraints
- Performance/scalability baselines
- Non-functional requirements
- Does NOT include implementation details

**Acceptance Criteria (mandatory subsection):**
- Specific, testable criteria for MVP completion
- Observable and verifiable
- Cover core features, not nice-to-haves
- Format: Checkbox list for clarity
- Typically 8-15 criteria

**Quality criteria:**
- MVP is minimal (no nice-to-haves)
- Features are achievable within resource constraints
- User capabilities are concrete (can demonstrate)
- Acceptance criteria are testable
- Complete user journey included

**Consumed by:**
- roadmap-writer: PRIMARY INPUT
  - **Core Features** → Becomes features in ROADMAP.md Phase 1
  - **User Capabilities** → Validates phases deliver complete value
  - **Technical Requirements** → Identifies technical dependencies
  - **Acceptance Criteria** → Informs phase success criteria

**Transformation to ROADMAP.md:**
- Each Core Feature becomes feature in roadmap with:
  - Why now (sequencing rationale)
  - Delivers (user value)
  - Derisks (assumptions validated)
  - Depends on (technical prerequisites)
  - Effort (size estimate)

**Example:**

**Core Features:**
```markdown
- **Specification Management:** CLI commands to create, list, edit, and validate specs
- **Context Linking:** Automatic detection of relationships between specs/tests/code
- **Living Documentation:** SYSTEM_MAP.md that stays current with code changes
```

**User Capabilities:**
```markdown
- Users can create new feature specs in under 2 minutes by running `ctx spec create`
- Users can find all code related to a spec in under 30 seconds by running `ctx find`
- Users can verify living docs are current by running `ctx docs check`
```

**Technical Requirements:**
```markdown
- Python 3.9+ CLI tool installed via pip
- Works with existing Git repositories (no restructuring required)
- Static analysis via Python AST parsing
- Markdown files are source of truth
```

**Acceptance Criteria:**
```markdown
- [ ] Creating spec generates Markdown file with all template sections
- [ ] `ctx spec list` shows spec name, status, and file path
- [ ] `ctx find` returns results within 1 second
- [ ] Living docs stay current automatically
```

**Anti-patterns:**
- Too many features (>10 indicates not minimal)
- Vague features: "Better user experience"
- Technical specs instead of capabilities
- Acceptance criteria that aren't testable
- Missing technical requirements

### In Scope - Future Phases

**This section is CRITICAL for roadmap-writer.**

**Purpose:** Acknowledge desired features deferred beyond MVP.

**Content requirements:**

**Phase 2 (Post-MVP):**
- Features for second release
- Logical extensions of MVP
- Require MVP validation first
- Brief description (1 sentence per feature)

**Phase 3 and Beyond:**
- Longer-term additions
- May change based on MVP learnings
- Shows evolution path
- Less detail than Phase 2

**Deferred Features:**
- Things desired but not prioritized
- Acknowledgment prevents "forgotten" feeling
- May be reconsidered based on feedback
- Brief list (bullet points)

**Quality criteria:**
- Clear what's NOT in MVP but desired
- Logical progression from MVP
- Flexible (may change based on learning)
- Not overly detailed (plans will change)

**Consumed by:**
- roadmap-writer: PRIMARY INPUT
  - **Phase 2** → Becomes ROADMAP.md Phase 2
  - **Phase 3+** → Becomes ROADMAP.md Phase 3+
  - **Deferred Features** → Backlog for future consideration

**Example:**

```markdown
### Phase 2 (Post-MVP)
- VS Code extension for in-editor spec access
- Inline spec navigation (click reference → opens spec)
- Quick spec creation from editor

### Phase 3 and Beyond
- AI-assisted spec content generation
- Automatic living doc updates from commit messages
- Web-based interface

### Deferred Features
- Real-time collaboration features
- Integration with issue trackers
- Mobile apps
```

**Anti-patterns:**
- Too detailed (these plans WILL change)
- No Phase 2 (looks like nothing after MVP)
- Everything in Phase 2 (no prioritization)

### Explicitly Out of Scope

**This section is CRITICAL for roadmap-writer.**

**Purpose:** Prevent scope creep by explicitly excluding common expansions.

**Content requirements:**

**Never in This Project:**
- Features deliberately excluded
- User segments not targeting
- Problems not solving
- Adjacent capabilities ruled out
- Prevents "why don't we also..." requests

**Not in This Version:**
- Features possible later but definitely not now
- Differ from "Future Phases" (more definitive exclusion)
- Sets clear expectations

**External Dependencies:**
- Things other teams/projects must provide
- What we assume exists externally
- Not our responsibility

**Quality criteria:**
- At least 3-5 exclusions in "Never in This Project"
- Exclusions are specific (not vague)
- Addresses common scope creep areas
- Makes boundaries crystal clear

**Consumed by:**
- roadmap-writer: Ensures roadmap doesn't include excluded items
- Stakeholders: Sets expectations
- Implementation teams: Knows boundaries

**Example:**

```markdown
### Never in This Project
- General project management (time tracking, resource allocation)
- Communication/chat features (use existing tools)
- Bug tracking system (beyond bugs/ directory)
- CI/CD pipeline management
- Code generation or automated implementation

### Not in This Version
- Visual interfaces (web or desktop apps)
- Team collaboration features
- Integration with cloud services
- Plugin/extension ecosystem

### External Dependencies
- N/A - Standalone tool with no external dependencies
```

**Anti-patterns:**
- Empty "Never in Scope" section
- Vague exclusions: "Bad features"
- No exclusions at all (invites scope creep)

### Constraints and Assumptions

**This section is CRITICAL for roadmap-writer.**

**Purpose:** Document realistic constraints and explicit assumptions.

**Content requirements:**

**Resource Constraints (mandatory):**
- Team size and composition
- Available time (hours/week, duration)
- Budget limits
- Must be realistic, not optimistic

**Technical Constraints (mandatory):**
- Existing systems to integrate with
- Technology stack limitations
- Performance requirements
- Platform constraints
- Security/compliance requirements

**Business Constraints:**
- Compliance/regulatory requirements
- Contractual obligations
- Market timing pressures
- Partnership dependencies

**Assumptions:**
- What we're taking as given
- Risks if assumptions prove invalid
- Validation status (validated vs. unvalidated)

**Quality criteria:**
- Constraints are realistic (not wishes)
- All major constraints documented
- Assumptions explicitly stated
- Clear what happens if assumptions wrong

**Consumed by:**
- roadmap-writer: PRIMARY INPUT
  - **Resource Constraints** → Determines phase durations and feature count per phase
  - **Technical Constraints** → Identifies technical dependencies and sequencing
  - **Business Constraints** → Informs timing and priorities
  - **Assumptions** → Identifies risks to validate early

**Roadmap-writer uses this to:**
- Ensure phases fit within resource constraints
- Sequence technically dependent features correctly
- Plan validation for risky assumptions
- Set realistic timelines

**Example:**

```markdown
### Resource Constraints
- **Team:** Solo developer
- **Time:** 15 hours/week for 3 months (180 hours total)
- **Budget:** $0 (open source, no paid services)

### Technical Constraints
- Must work with existing Git repos (no special structure)
- Python 3.9+ required
- No server/database required (works offline)
- Must be cross-platform (macOS, Linux, Windows/WSL)

### Business Constraints
- Open source from day one (MIT license)
- No funding requirement
- Launch within 3 months (market timing)

### Assumptions
- Target users know Git basics
  - Risk: Some users might not
  - Mitigation: Excellent onboarding docs
- CLI is acceptable for MVP
  - Risk: Users might demand GUI
  - Mitigation: Validate with early users
```

**Anti-patterns:**
- Optimistic constraints: "Unlimited time/budget"
- Missing resource constraints
- Assumptions treated as facts
- No mitigation for assumption failures

### Success Criteria

**This section is CRITICAL for roadmap-writer.**

**Purpose:** Define how to know scope is successfully delivered.

**Content requirements:**

**MVP Complete When:**
- Specific, measurable criteria
- Observable and verifiable
- Must all be true for completion
- Typically 5-10 criteria

**Quality Standards:**
- Non-functional requirements
- Performance benchmarks
- Quality thresholds
- No specific features (those are in acceptance criteria)

**Acceptance Process:**
- Who must approve
- Approval criteria
- Timeline for approval

**Quality criteria:**
- Criteria are specific and testable
- Quality standards are measurable
- Process is clear
- No ambiguity about "done"

**Consumed by:**
- roadmap-writer: 
  - Informs phase success criteria
  - Validates roadmap achieves scope goals
  - Sets quality bars for implementation

**Example:**

```markdown
### MVP Complete When
1. All acceptance criteria in "In Scope - MVP" are met
2. 5 beta users can complete getting-started guide in under 10 minutes
3. Beta users report context retrieval reduced from 30+ min to <1 min
4. Zero critical bugs reported by beta users
5. Documentation is complete (getting started, reference, examples)

### Quality Standards
- Test coverage >80% for core functionality
- CLI commands respond in <1 second for typical projects
- Zero data loss (specs/docs never corrupted)
- Works offline (no internet required after install)

### Acceptance Process
- Beta testing with 5 target users (2 weeks)
- Address all critical feedback
- Final review by project owner
- Public launch on GitHub
```

**Anti-patterns:**
- Vague criteria: "Works well"
- Unmeasurable: "Users are happy"
- No quality standards
- Unclear approval process

### Risks and Mitigation

**Purpose:** Acknowledge risks and plan for them.

**Content requirements:**

**Scope Risks:**
- Risks that scope is wrong
- Risks that scope is too large/small
- Probability and impact assessment
- Mitigation strategies

**Execution Risks:**
- Risks during implementation
- Technical risks
- Resource risks
- Mitigation approaches

**Quality criteria:**
- Major risks identified
- Realistic probability/impact
- Concrete mitigation plans
- Not just risk list (includes mitigation)

**Consumed by:**
- roadmap-writer: Identifies which features should sequence early to derisk
- Implementation teams: Awareness of risks

**Example:**

```markdown
### Scope Risks
**Risk:** MVP scope too ambitious for 180 hours
**Probability:** Medium
**Impact:** High (failure to launch)
**Mitigation:** Built-in 20% buffer. If behind at 50% mark, cut Phase 2 features from MVP.

### Execution Risks
**Risk:** Static analysis more complex than expected
**Probability:** Medium
**Impact:** Medium (could delay MVP)
**Mitigation:** Prototype linking in week 1. If too complex, simplify to manual links only.
```

### Stakeholder Agreement

**Purpose:** Document who must approve and what's unresolved.

**Content requirements:**

**Key Stakeholders:**
- Who must approve this scope
- Role in approval (decision maker, consulted, informed)

**Open Questions:**
- Unresolved scope decisions
- Blockers to approval
- Areas needing clarification

**Change Control:**
- How scope changes are handled
- Change request process
- Approval authority for changes

**Quality criteria:**
- All stakeholders identified
- Open questions specific
- Change control process clear

**Consumed by:**
- roadmap-writer: Understands flexibility constraints
- Implementation teams: Knows approval chain

### Document Control

**Purpose:** Track scope evolution over time.

**Content requirements:**

**Version History:**
- Version number and date
- What changed in this version
- Why it changed
- Impact on project

**Related Documents:**
- Links to VISION.md
- Links to ROADMAP.md (when created)
- Links to specifications (as created)

**Quality criteria:**
- Complete version history
- Clear change rationale
- Related docs linked

**Consumed by:**
- All roles: Understanding scope evolution

## Cross-Document References

### SCOPE.md References Other Documents

**Upstream: VISION.md (mandatory)**
- Vision statement (exact copy)
- Product scope (transformed into detailed scope)
- Success criteria (carried over and elaborated)
- Assumptions/constraints (carried over)

**Validation:**
- Scope must align with vision
- No conflicts with vision direction
- All vision "In Scope" items addressed

### Other Documents Reference SCOPE.md

**Downstream: ROADMAP.md (created after SCOPE.md)**
- Scope overview (referenced in roadmap alignment)
- In Scope - MVP (becomes Phase 1 features)
- In Scope - Future Phases (becomes Phase 2+)
- Explicitly Out of Scope (ensures roadmap doesn't exceed)
- Constraints and Assumptions (informs realistic sequencing)
- Success Criteria (informs phase success criteria)

**Downstream: Feature Specifications (created during implementation)**
- In Scope - MVP (validates specs are in scope)
- Acceptance Criteria (informs spec acceptance tests)
- Technical Requirements (informs spec technical sections)

## Validation Rules

### Mandatory Sections

**Must have:**
- Scope Overview
- Vision Alignment
- Project Objectives
- In Scope - MVP (with all 4 subsections)
- In Scope - Future Phases
- Explicitly Out of Scope
- Constraints and Assumptions (with Resource Constraints at minimum)
- Success Criteria
- Risks and Mitigation
- Stakeholder Agreement
- Document Control

**Optional but recommended:**
- Detailed risk analysis for complex projects
- Multiple future phases (Phase 2, 3, 4+)

### Section Completeness Rules

**Scope Overview:**
- Must be 2-3 sentences (no more)
- Must describe deliverables specifically

**Vision Alignment:**
- Vision Statement must match VISION.md exactly
- Connection explanation: Minimum 1 sentence

**Project Objectives:**
- Minimum 3 objectives
- Each objective must be measurable

**In Scope - MVP:**
- Core Features: Minimum 3, maximum 10
- User Capabilities: Minimum 5
- Technical Requirements: Minimum 3
- Acceptance Criteria: Minimum 5

**In Scope - Future Phases:**
- Phase 2 must exist (minimum 2 features)
- Deferred Features: Minimum 2 items

**Explicitly Out of Scope:**
- Never in This Project: Minimum 3 exclusions
- Not in This Version: Minimum 2 items

**Constraints and Assumptions:**
- Resource Constraints: MUST specify Team, Time, Budget
- Technical Constraints: Minimum 2
- Assumptions: Minimum 2

**Success Criteria:**
- MVP Complete When: Minimum 3 criteria
- Quality Standards: Minimum 2 standards

### Cross-Document Consistency

**SCOPE.md — VISION.md:**
- Vision statement in SCOPE.md matches VISION.md
- SCOPE.md "In Scope - MVP" addresses VISION.md "In Scope (MVP)"
- SCOPE.md objectives contribute to VISION.md success criteria
- SCOPE.md constraints consistent with VISION.md constraints

**When SCOPE.md changes:**
- ROADMAP.md must be reviewed (if exists)
- Changelog must document impact
- VISION.md may need update if scope reveals vision misalignment

**Validation checks:**
- Every vision "In Scope (MVP)" feature has corresponding scope feature
- Scope resource constraints don't exceed vision constraints
- Scope timeline fits within vision milestones
- No scope features conflict with vision "Never in Scope"

## Information Flow: VISION.md → SCOPE.md

### Transformation Rules

**Vision "Product Scope" → Scope "In Scope - MVP":**

**Vision provides:** High-level capabilities  
**Scope provides:** Concrete deliverables

**Example transformation:**
- **Vision**: "Lightweight specification format"
- **Scope Core Feature**: "Specification Management: CLI commands to create, list, edit, and validate specs using Markdown templates"
- **Scope User Capability**: "Users can create new feature specs in under 2 minutes by running `ctx spec create`"
- **Scope Technical Requirement**: "Markdown-based spec templates with validation via YAML schema"
- **Scope Acceptance Criterion**: "Creating spec generates Markdown file with all template sections populated"

**Pattern:** Each vision capability expands into 2-5 concrete deliverables in scope.

**Vision "Success Criteria" → Scope "Success Criteria":**

**Vision provides:** Strategic metrics  
**Scope provides:** Tactical completion criteria

**Example transformation:**
- **Vision**: "Time to answer 'why does this exist?' <30 seconds"
- **Scope MVP Complete When**: "Beta users report context retrieval reduced from 30+ min to <1 min"
- **Scope Quality Standard**: "CLI commands respond in <1 second for typical projects"

**Vision "Assumptions/Constraints" → Scope "Constraints and Assumptions":**

**Vision provides:** High-level constraints  
**Scope provides:** Detailed operational constraints

**Example transformation:**
- **Vision Resource Constraint**: "Solo developer, 15 hours/week"
- **Scope Resource Constraint**: "Solo developer, 15 hours/week for 3 months (180 hours total)"
- **Scope adds**: Breakdown by phase, buffer allocation, risk mitigation

## Information Flow: SCOPE.md → ROADMAP.md

### What roadmap-writer Extracts

**From "In Scope - MVP":**
- Core Features → Phase 1 features in roadmap
- Technical Requirements → Technical dependencies for sequencing
- Acceptance Criteria → Phase success criteria

**From "In Scope - Future Phases":**
- Phase 2 → Roadmap Phase 2
- Phase 3+ → Roadmap Phase 3+
- Deferred Features → Potential Phase 4+ or backlog

**From "Explicitly Out of Scope":**
- Validation that roadmap doesn't include excluded items
- Boundaries for what features can be added

**From "Constraints and Assumptions":**
- Resource Constraints → Phase duration calculation
- Technical Constraints → Feature sequencing based on dependencies
- Assumptions → Risks to validate early in roadmap

**From "Success Criteria":**
- MVP Complete When → Phase 1 completion criteria
- Quality Standards → Quality gates in roadmap

### Example Transformation

**SCOPE.md "Core Features":**
```markdown
- **Specification Management:** CLI commands to create, list, edit, validate specs
- **Context Linking:** Automatic detection between specs/tests/code
- **Living Documentation:** SYSTEM_MAP.md stays current with code
```

**ROADMAP.md Phase 1:**
```markdown
1. **Static Analysis Engine**
   - **Why now:** Highest technical risk, validate before building more
   - **Delivers:** Ability to detect code references to specs
   - **Derisks:** "Static analysis sufficient" assumption
   - **Depends on:** Nothing
   - **Effort:** Large (2 weeks)

2. **Spec Management Commands**
   - **Why now:** Need specs to link to
   - **Delivers:** Can create and manage specs
   - **Derisks:** Template format acceptance
   - **Depends on:** Nothing from Phase 1
   - **Effort:** Small (3-4 days)
```

**Note:** roadmap-writer adds sequencing rationale, dependencies, effort - things not in SCOPE.md.

## Version Control and Change Management

### When to Update SCOPE.md

**Mandatory updates:**
- Vision changes requiring scope adjustment
- MVP scope proves unrealistic (too large or too small)
- Technical constraints discovered during implementation
- Resource constraints change significantly
- Stakeholder agreement changes

**Discretionary updates:**
- Minor feature clarifications
- Acceptance criteria refinements
- Additional deferred features identified

**Red flags (update too frequently):**
- MVP scope changing monthly (instability)
- Constant additions to "In Scope" without removing items
- No change control process being followed

### Update Process

1. **Identify need for change** (implementation learning, technical discovery)
2. **Document proposed change** with rationale
3. **Assess impact** on ROADMAP.md and ongoing work
4. **Check vision alignment** (may require VISION.md update)
5. **Update SCOPE.md** with new version number
6. **Add changelog entry** (what, why, impact)
7. **Review ROADMAP.md** for needed updates
8. **Communicate changes** to team and stakeholders

### Version Numbering

**Major version (X.0):**
- MVP scope significantly changes
- Major features added or removed
- Resource constraints drastically change

**Minor version (X.Y):**
- Feature clarifications
- Acceptance criteria adjustments
- Constraint updates

### Change Control

**Change categories from SCOPE.md itself:**

**Clarifications:**
- Can update immediately
- No timeline impact
- Example: "Specify that 'user' means 'authenticated user'"

**Additions:**
- Require formal review
- Timeline adjustment needed
- Example: "Add OAuth integration to MVP"

**Reductions:**
- Require justification
- Success criteria update
- Example: "Remove mobile app from MVP"

**Scope changes:**
- May require vision re-examination
- Example: "Target different user segment"

## Common Patterns

### Solo Developer Scope

**Characteristics:**
- Very minimal MVP (3-5 features)
- Single platform only
- Extensive "Never in Scope" (manages temptation)
- Realistic resource constraints (10-20 hrs/week)
- Buffer time built in (20%+)
- Simple success criteria (validated with 5 beta users)

### Team Product Scope

**Characteristics:**
- Larger MVP (5-10 features)
- Can include multiple platforms if team parallelizes
- Future phases more detailed
- More complex stakeholder agreement
- Business constraints prominent

### Internal Tool Scope

**Characteristics:**
- Focused MVP (solve one pain point well)
- Minimal "Future Scope" (done when solved)
- Success criteria heavily metric-focused (time saved, errors reduced)
- Stakeholders are colleagues (easier alignment)
- Often aggressive timeline (internal pressure)

### Platform Scope

**Characteristics:**
- MVP includes platform + one application
- Future phases emphasize extensibility
- Technical requirements more detailed (API critical)
- Success criteria include ecosystem metrics
- External dependencies section important

## Integration with Roles

### scope-writer creates SCOPE.md

**Process:**
1. Reads VISION.md (especially Product Scope, Success Criteria, Assumptions/Constraints)
2. Transforms vision features into concrete deliverables
3. Defines user capabilities (observable behaviors)
4. Establishes explicit boundaries (in/future/never)
5. Creates acceptance criteria (testable)
6. Documents constraints realistically
7. Outputs complete SCOPE.md

**Stops if:**
- VISION.md missing Product Scope section
- VISION.md Success Criteria incomplete
- VISION.md Assumptions/Constraints too vague

### roadmap-writer consumes SCOPE.md

**Reads:**
- Scope overview → References in roadmap alignment
- In Scope - MVP → PRIMARY INPUT for Phase 1 features
- In Scope - Future Phases → PRIMARY INPUT for Phase 2+
- Explicitly Out of Scope → Validates roadmap boundaries
- Constraints and Assumptions → Informs realistic sequencing
- Technical Requirements → Identifies dependencies
- Success Criteria → Informs phase success criteria

**Stops if:**
- In Scope - MVP missing or incomplete
- Core Features has <3 items
- Resource Constraints missing
- Technical Requirements missing

**Transforms:**
- Each Core Feature → Roadmap feature with sequencing rationale
- Technical Requirements → Dependency analysis
- Resource Constraints → Phase duration limits
- Assumptions → Risks to validate early

## Anti-Patterns to Avoid

### In Scope Document Creation

**Feature Creep Disguised as Clarification:**
- Adding features not in vision under guise of "clarifying"
- Fix: Additions require vision update first

**Vague Deliverables:**
- "Better user experience" or "Improved performance"
- Fix: Every capability must be concrete and testable

**Missing "Out of Scope":**
- Only defining inclusions, not exclusions
- Fix: "Never in Scope" is mandatory, minimum 3 items

**Unrealistic MVP:**
- Solo dev, 10 hrs/week, wants web + iOS + Android in 6 months
- Fix: MVP must fit within constraints (be ruthless)

**No Acceptance Criteria:**
- Features listed but no definition of "done"
- Fix: Every MVP feature needs testable criterion

**Ignoring Constraints:**
- Scope requires unavailable resources or impossible timeline
- Fix: Constraints must be realistic and respected

### In Scope Document Usage

**Scope Creep:**
- Continuously adding to "In Scope" without removing
- Fix: Change control process, additions go to future phases

**Treating as Specification:**
- Scope has too much detail (button labels, API signatures)
- Fix: Scope is capabilities, not specs (specs come later)

**Allowing Drift:**
- Implementation diverges from scope without updates
- Fix: Regular alignment checks, update scope when needed

**No Change Control:**
- Ad-hoc scope changes without process
- Fix: Follow change control process from Stakeholder Agreement

## Example Scope Documents

**Before writing your first scope:** Study complete examples in role-scope-writer.md:
- Full developer tool scope (DevContext) - comprehensive example
- Minimal internal tool scope (Data Pipeline Monitor) - minimal viable example

**Inline examples throughout this schema** demonstrate individual section patterns.

## Related Schemas

**When creating this artifact:**
- Read [schema-vision.md](schema-vision.md) to understand strategic direction
- Translate vision into concrete features and boundaries

**After creating this artifact:**
- Next: [schema-roadmap.md](schema-roadmap.md) sequences scope features into phases
- Next: [schema-spec.md](schema-spec.md) details individual features
- Quality gate: Scope review validates completeness and alignment
- Living artifact: Updated through change control process

For complete schema workflow, see [schema-relationship-map.md](patterns/schema-relationship-map.md).

## Document Metadata

**Version:** 1.0  
**Created:** 2025-10-22  
**Purpose:** Define canonical structure for SCOPE.md in AI-augmented development workflow  
**Audience:** Roles (scope-writer, roadmap-writer), human developers  
**Maintainer:** Workflow design team  
**Dependencies:** Requires VISION.md ontology
