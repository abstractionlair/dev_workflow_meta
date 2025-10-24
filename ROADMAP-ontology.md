# ROADMAP.md Ontology

## Purpose

This document defines the canonical structure, content, and semantics of ROADMAP.md files. It serves as the authoritative reference for:
- **roadmap-writer** (producer): What to create
- **spec-writer** (consumer): What to expect
- **Reviewers**: What to validate

## Document Type

**Format:** Markdown (.md)  
**Producer:** roadmap-writer  
**Primary Consumer:** spec-writer (reads feature entries)  
**Secondary Consumers:** Planning reviewers, stakeholders

## Required Structure

### Document Header

```markdown
# [Project Name] Roadmap
```

**Requirements:**
- Project name matches VISION.md and SCOPE.md
- Single H1 heading

---

## Section 1: Roadmap Overview

```markdown
## Roadmap Overview

[2-3 sentences explaining sequencing strategy]
```

**Purpose:** High-level summary of how features are sequenced and why

**Content Requirements:**
- 2-3 sentences (concise)
- Explains sequencing approach (e.g., "derisk early", "value ladder")
- References key principles or constraints
- Provides context for phase structure

**Example:**
```
This roadmap sequences features to derisk technical approach early while 
delivering immediate user value through progressive capability addition. We 
start with the riskiest technical challenge (static analysis linking), then 
layer user value with specs and living docs.
```

---

## Section 2: Alignment

```markdown
## Alignment

### Vision
[Copy vision statement from VISION.md]

### Success Criteria
[Copy key metrics from VISION.md]

### Scope Summary
[Brief summary of in-scope features from SCOPE.md]
```

**Purpose:** Connect roadmap to strategic documents (VISION, SCOPE)

**Subsections:**

### 2.1 Vision
**Content:** Vision statement copied verbatim from VISION.md
**Requirement:** Must match VISION.md exactly

### 2.2 Success Criteria
**Content:** Key success metrics from VISION.md that roadmap achieves
**Format:** List or paragraph
**Example:**
```
- Time to answer "why does this exist?" <30 seconds
- 100 active users within 6 months
- 60% retention after 3 months
```

### 2.3 Scope Summary
**Content:** Brief overview of what's in scope from SCOPE.md
**Length:** 1-3 sentences
**Purpose:** Remind readers what features roadmap will sequence

---

## Section 3: Sequencing Strategy

```markdown
## Sequencing Strategy

### Key Principles
[3-5 principles guiding feature sequence]

### Risk Mitigation Approach
[How roadmap derisks critical assumptions]

### Value Delivery Pattern
[How roadmap delivers user value incrementally]
```

**Purpose:** Explain the "why" behind feature sequencing

**Subsections:**

### 3.1 Key Principles
**Content:** 3-5 principles that guided sequencing decisions
**Format:** Numbered or bulleted list
**Example:**
```
1. Derisk technical linking first - Most novel/risky capability
2. Deliver complete user journeys - Usable value at each phase
3. Validate with real usage - Get features in front of users ASAP
4. Build infrastructure as needed - JIT, not upfront
5. Maintain development flow - Group related features
```

### 3.2 Risk Mitigation Approach
**Content:** How roadmap addresses risk (especially in early phases)
**Length:** 1-3 paragraphs
**Must specify:** Which risks, when mitigated, how validated

### 3.3 Value Delivery Pattern
**Content:** How roadmap delivers value across phases
**Format:** Usually phase-by-phase summary
**Example:**
```
Each phase delivers a complete user capability:
- Phase 1: Can link code to specs (core value)
- Phase 2: Can create and manage specs
- Phase 3: Can maintain living docs automatically
```

---

## Section 4: Phase Definitions

**Repeating structure for each phase:**

```markdown
## Phase [N]: [Phase Name] (Weeks X-Y)

### Goals
[What this phase achieves]

### Features
[Feature entries - see Feature Entry Structure below]

### Success Criteria
[How to know phase is complete]

### Learning Goals
[What we'll learn from building this]

### Validation Checkpoints
[Where we pause to assess and adjust]
```

### Phase Header
**Format:** `## Phase [N]: [Phase Name] (Weeks X-Y)`
**Requirements:**
- N is sequential (1, 2, 3, ...)
- Phase name is descriptive (e.g., "MVP Foundation", "Specification Management")
- Week range is approximate, relative to project start

### 4.1 Goals
**Content:** What this phase achieves (outcomes, not features)
**Length:** 1-2 paragraphs
**Must specify:** Value delivered, risks mitigated, or assumptions validated

### 4.2 Features

**Critical: This is what spec-writer consumes**

Each feature entry follows this exact structure:

```markdown
[N]. **[Feature Name]**
   - **Description:** [1-2 sentence overview of what this feature does]
   - **Why now:** [Rationale for sequencing]
   - **Delivers:** [User value or learning]
   - **Derisks:** [Assumptions validated]
   - **Depends on:** [Prerequisites]
   - **Effort:** [Small/Medium/Large]
```

**Feature Entry Field Definitions:**

#### Feature Number
- Sequential within phase (1, 2, 3, ...)
- Not globally unique (each phase starts at 1)

#### Feature Name
- **Format:** Bold text (e.g., `**User Registration**`)
- **Requirements:** 
  - Descriptive and specific
  - 2-5 words typically
  - Noun phrase (not verb phrase)
  - Unique within project

#### Description (REQUIRED)
- **Content:** Clear 1-2 sentence overview of what feature does
- **Purpose:** Enables spec-writer to understand feature without context
- **Focus:** What feature IS, not why or how
- **Length:** 1-2 sentences maximum
- **Examples:**
  - Ã¢Å“â€¦ "Analyzes Python code to automatically detect relationships between specs, tests, and implementation files"
  - Ã¢Å“â€¦ "CLI command that finds all code/test files linked to a given specification"
  - Ã¢ÂÅ’ "Static analysis" (too vague)
  - Ã¢ÂÅ’ "Uses AST parsing to scan Python files and build dependency graph with caching..." (too detailed)

#### Why now (REQUIRED)
- **Content:** Rationale for sequencing this feature in this phase
- **Common patterns:**
  - Risk: "Highest technical risk, must validate before building more"
  - Dependency: "Foundation for all user-specific features"
  - Value: "Delivers core user value immediately"
  - Learning: "Need feedback before committing to approach"
- **Length:** 1 sentence or short phrase

#### Delivers (REQUIRED)
- **Content:** User value or learning outcome from building feature
- **Format:** Noun phrase or short sentence
- **Must specify:** What changes for users or what we learn
- **Examples:**
  - "User accounts, authentication capability"
  - "Automatic detection of spec-to-code links"
  - "Validation of static analysis approach"

#### Derisks (REQUIRED)
- **Content:** Assumptions validated or risks mitigated
- **Format:** Noun phrase or short sentence
- **Can be:** "None" or "N/A" if feature doesn't derisk
- **Examples:**
  - "'Static analysis sufficient' assumption"
  - "Email validation approach"
  - "Query performance concerns"
  - "None (low-risk polish feature)"

#### Depends on (REQUIRED)
- **Content:** Prerequisites that must be complete first
- **Format:** Feature names or "Nothing"
- **Can be:** "Nothing" if no dependencies
- **Examples:**
  - "User Authentication"
  - "Static Analysis Engine"
  - "Nothing (foundational feature)"
  - "Database schema design"

#### Effort (REQUIRED)
- **Content:** Rough size estimate
- **Valid values:**
  - **Small:** 1-3 days
  - **Medium:** 4-7 days (1 week)
  - **Large:** 1.5-4 weeks
- **Can include:** Time estimate in parentheses (optional)
- **Examples:**
  - "Small"
  - "Medium (1 week)"
  - "Large (2 weeks, ~40 hours)"

### 4.3 Success Criteria
**Content:** Observable conditions that indicate phase completion
**Format:** Checklist (using `- [ ]` syntax)
**Requirements:**
- Specific and measurable
- Testable/verifiable
- 3-7 criteria per phase
**Example:**
```
- [ ] Can detect spec references in Python docstrings (>90% accuracy)
- [ ] Can build relationship graph for 1000-file codebase in <5 seconds
- [ ] `ctx find` returns results in <1 second
- [ ] Links are validated correctly (detects broken references)
```

### 4.4 Learning Goals
**Content:** What we'll learn from building this phase
**Format:** Bulleted list or paragraph
**Must specify:** Questions answered, assumptions validated, feedback obtained
**Example:**
```
- Does static analysis work reliably enough?
- Are there edge cases that break detection?
- Is performance acceptable for target project sizes?
```

### 4.5 Validation Checkpoints
**Content:** When and how to pause and assess progress
**Format:** Structured review format
**Required fields:**
- Date: When checkpoint occurs
- Review questions: What to evaluate
- Decision criteria: Continue/Pivot/Stop conditions

**Template:**
```markdown
### Validation Checkpoint

**Date:** [End of Week X]

**Review questions:**
- [Question 1]
- [Question 2]
- [Question 3]

**Decision criteria:**
- **Proceed:** [What must be true to continue as planned]
- **Pivot:** [What would cause strategy change]
- **Stop:** [What would cause project cancellation]
```

---

## Section 5: Dependencies and Sequencing

```markdown
## Dependencies and Sequencing

### Technical Dependencies
[Feature A requires Feature B to be complete]

### Learning Dependencies
[Feature C depends on validating assumption from Feature A]

### External Dependencies
[Features waiting on external factors]
```

**Purpose:** Document cross-feature dependencies

**Subsections:**

### 5.1 Technical Dependencies
**Content:** Features that must be built before others
**Format:** List or prose
**Example:** "User Dashboard requires User Authentication"

### 5.2 Learning Dependencies
**Content:** Features blocked by learning from other features
**Format:** List or prose
**Example:** "Collaborative Editing depends on validating 'Users work in teams' assumption from Phase 1"

### 5.3 External Dependencies
**Content:** Features blocked by external factors
**Format:** List with explanation
**Example:**
```
- Payment Processing: Requires merchant account approval (3-4 weeks)
- Email Notifications: Requires email service provider setup
```

---

## Section 6: Assumptions and Risks

```markdown
## Assumptions and Risks

### Key Assumptions
[Assumptions underlying this sequence]

### Sequencing Risks
[Risks if we get sequence wrong]

### Mitigation Plans
[How we'll handle if assumptions invalid]
```

**Purpose:** Document what could go wrong and how to handle it

**Subsections:**

### 6.1 Key Assumptions
**Content:** Critical assumptions underlying roadmap
**Format:** Bulleted list
**Must specify:** What we're assuming is true
**Example:**
```
- Static analysis can achieve >85% accuracy on spec detection
- Users will adopt spec-based workflow
- Team can maintain 20 hours/week development pace
- No major scope changes during MVP
```

### 6.2 Sequencing Risks
**Content:** What could go wrong with this sequence
**Format:** Bulleted list
**Example:**
```
- Phase 1 technical approach fails Ã¢â€ â€™ Months wasted
- Early features don't resonate Ã¢â€ â€™ Wrong problem being solved
- Dependencies block progress Ã¢â€ â€™ Timeline extends
```

### 6.3 Mitigation Plans
**Content:** How to handle if assumptions are wrong
**Format:** Assumption Ã¢â€ â€™ Mitigation pairs
**Example:**
```
- If static analysis <85% accurate Ã¢â€ â€™ Add manual linking support
- If users don't adopt specs Ã¢â€ â€™ Pivot to different workflow
- If development pace <20hr/wk Ã¢â€ â€™ Reduce scope or extend timeline
```

---

## Section 7: Flexibility and Change

```markdown
## Flexibility and Change

### Adaptation Triggers
[What would cause roadmap changes]

### Review Cadence
[How often we revisit roadmap]

### Change Process
[How to adjust roadmap based on learning]
```

**Purpose:** Define how roadmap evolves

**Subsections:**

### 7.1 Adaptation Triggers
**Content:** Events that would trigger roadmap revision
**Format:** Bulleted list
**Example:**
```
- Validation checkpoint reveals critical assumption false
- Major user feedback contradicts feature priority
- External dependency blocked longer than expected
- New constraint emerges (resources, timeline, scope)
```

### 7.2 Review Cadence
**Content:** How often roadmap is revisited
**Format:** Statement of frequency
**Example:** "After each phase completion and at monthly intervals"

### 7.3 Change Process
**Content:** How roadmap changes are made
**Format:** Process description
**Example:**
```
1. Identify trigger event
2. Assess impact on current phase and future phases
3. Propose adjustment (continue/pivot/stop)
4. Review with stakeholders
5. Update roadmap document with new version
6. Document change in Version History
```

---

## Section 8: Document Control

```markdown
## Document Control

### Version History
[Track roadmap changes]

### Related Documents
- VISION.md - [link]
- SCOPE.md - [link]
- Feature specs - [links as created]
```

**Purpose:** Track changes and cross-reference

**Subsections:**

### 8.1 Version History
**Content:** Log of roadmap changes
**Format:** Reverse chronological (newest first)
**Required fields:** Version, Date, Changes
**Template:**
```markdown
**Version 2.0 - 2025-02-15**
- Pivoted Phase 2 based on Phase 1 learnings
- Added manual linking fallback
- Adjusted timeline (+2 weeks)

**Version 1.0 - 2025-01-10**
- Initial roadmap created
```

### 8.2 Related Documents
**Content:** Links to related documents
**Required links:**
- VISION.md
- SCOPE.md
**Optional links:**
- Feature specs (as created)
- Technical design docs
- User research

---

## Section Ordering

**Required order:**
1. Roadmap Overview
2. Alignment
3. Sequencing Strategy
4. Phase 1
5. Phase 2
6. Phase N (additional phases)
7. Dependencies and Sequencing
8. Assumptions and Risks
9. Flexibility and Change
10. Document Control

**Rationale:** Top-down structure (strategy Ã¢â€ â€™ tactics Ã¢â€ â€™ governance)

---

## Quality Standards

### Completeness Checklist

**Document level:**
- [ ] All 10 sections present
- [ ] Project name in header matches VISION/SCOPE
- [ ] Vision statement matches VISION.md exactly

**Per phase:**
- [ ] Goals clearly stated
- [ ] 3-7 features with complete entries
- [ ] All feature fields present (Description, Why now, Delivers, Derisks, Depends on, Effort)
- [ ] Success criteria specific and measurable
- [ ] Learning goals identified
- [ ] Validation checkpoint defined

**Per feature entry:**
- [ ] Description is clear 1-2 sentence overview
- [ ] Why now explains sequencing rationale
- [ ] Delivers specifies user value or learning
- [ ] Derisks identifies assumptions (or "None")
- [ ] Depends on lists prerequisites (or "Nothing")
- [ ] Effort is Small/Medium/Large with optional time estimate

### Clarity Standards

**Feature descriptions must:**
- Focus on WHAT feature does
- Be understandable without context
- Avoid implementation details
- Use 1-2 sentences maximum

**Sequencing rationale must:**
- Explain why this feature in this phase
- Reference principles from Sequencing Strategy
- Be specific (not vague like "important")

### Consistency Standards

**Cross-document:**
- Vision statement matches VISION.md
- Scope summary aligns with SCOPE.md
- Feature names consistent if referenced in multiple sections

**Internal:**
- Phase numbering sequential
- Feature dependencies reference actual feature names
- Effort estimates consistent in scale

---

## Common Issues

### Issue 1: Missing Feature Descriptions
**Problem:** Feature entries lack Description field
**Impact:** spec-writer cannot understand what feature is
**Fix:** Add 1-2 sentence description to every feature

### Issue 2: Vague Descriptions
**Problem:** Descriptions like "Static analysis" or "API work"
**Impact:** Insufficient context for spec-writer
**Fix:** Make descriptions specific and complete

### Issue 3: Implementation in Description
**Problem:** Descriptions include how feature works
**Impact:** Over-constrains implementation
**Fix:** Focus on what feature does (behavior) not how (implementation)

### Issue 4: Missing Dependencies
**Problem:** Features list "Nothing" but actually depend on other features
**Impact:** Sequencing breaks, features can't be built
**Fix:** Trace dependencies carefully, list all prerequisites

### Issue 5: Unmeasurable Success Criteria
**Problem:** Criteria like "Phase complete when done"
**Impact:** No clear definition of phase completion
**Fix:** Use specific, testable conditions

---

## Downstream Usage

### spec-writer Consumption

**Reads from ROADMAP.md:**
- Feature name Ã¢â€ â€™ SPEC title
- Feature description Ã¢â€ â€™ SPEC overview foundation
- Why now Ã¢â€ â€™ SPEC rationale context
- Delivers Ã¢â€ â€™ SPEC value proposition
- Depends on Ã¢â€ â€™ SPEC dependencies section
- Effort Ã¢â€ â€™ SPEC complexity estimate

**Critical:** All 6 fields must be present for spec-writer to function

### Planning Review

**Reviewers validate:**
- Sequencing follows stated principles
- Dependencies correctly identified
- Effort estimates reasonable
- Success criteria measurable
- Risks identified and mitigated

### Stakeholder Communication

**Stakeholders use roadmap for:**
- Understanding feature sequence
- Knowing when capabilities delivered
- Seeing rationale for priorities
- Tracking progress via checkpoints

---

## Version Control

**Roadmap lifecycle:**
1. **Initial:** Created by roadmap-writer after SCOPE.md complete
2. **Living:** Updated after validation checkpoints
3. **Versioned:** Changes tracked in Version History section
4. **Archived:** Old versions preserved in git history

**Update triggers:**
- Validation checkpoint reveals need for change
- Stakeholder feedback requires adjustment
- External constraint changes (timeline, resources)
- Major assumption invalidated

---

## Related Ontologies

- **VISION-ontology.md** - Roadmap aligns with vision
- **SCOPE-ontology.md** - Roadmap sequences scope features
- **SPEC-ontology.md** - Roadmap features become specs

---

## Summary

ROADMAP.md is the bridge between strategic planning (VISION, SCOPE) and tactical execution (SPEC). It defines:
- **What** to build (features)
- **When** to build it (phases)
- **Why** that sequence (rationale)
- **How** to adapt (flexibility)

**Most critical for downstream:** Feature entries with complete 6-field structure enable spec-writer to transform roadmap features into detailed specifications.
