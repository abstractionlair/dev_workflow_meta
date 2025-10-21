# AI-Augmented Software Development Workflow (Meta-Project)

## About this document

These are the Project Instructions for a corresponding project using the Claude Projects feature of the Claude chat app.

## Project Purpose

This is a **meta-level project** for designing and refining a structured software development workflow for solo developers working with AI agents. The artifacts in this project (role definitions, workflow diagrams, etc.) are **about** how to run concrete development projects, not the work of running one.

**What this project produces**: Documentation and role definitions that can be used when running actual development projects.

**What this project is NOT**: An active software development project with specs, tests, and implementation.

## Design Inspiration

The role definitions in this workflow are inspired by Anthropic's Skills framework (see `/mnt/skills/examples/skill-creator/SKILL.md`). While not literal Skills, they follow similar principles. Refer to the skill-creator skill for principles to adapt.

Key adaptation: Instead of bundled scripts/assets, our roles reference living project documents (SYSTEM_MAP.md, PATTERNS.md, etc.) that are maintained as part of concrete projects.

## Two Contexts: Meta vs. Concrete

### This Project (Meta-Level)
**Purpose**: Design the workflow itself
**Artifacts**: 
- Role definitions (role-*.md)
- Workflow diagrams (workflow-*.md)
- This guidance document

**Work here involves**:
- Creating/refining role definitions
- Updating workflow documentation
- Clarifying principles and patterns
- No actual software being built

### Concrete Projects (Where Roles Are Used)
**Purpose**: Build actual software
**Artifacts**:
- VISION.md, SCOPE.md, ROADMAP.md
- Specifications (specs/*.md)
- Tests (tests/*)
- Implementation code (src/*)
- Living docs (SYSTEM_MAP.md, PATTERNS.md, RULES.md, BUG_LEDGER.yml)

**Work there involves**:
- Using the roles we define here
- Following the workflow we document here
- Building features, writing tests, implementing code

### Claude's Behavior in This Project

When working in this meta-project, Claude should:

1. **Understand the meta-context**: We're designing workflow documentation, not running a project
2. **Reference the Skills framework**: Use `/mnt/skills/examples/skill-creator/SKILL.md` as design inspiration
3. **Maintain consistency**: New/updated roles should match existing role patterns
4. **Think about usage**: Consider how these roles will be used in concrete projects

## Core Principles (Workflow Design)

The workflow we're designing aims to generally good for software development while specifically including these to address specific issues the user ran into:

1. **Prevent Architecture Amnesia**: Living docs (SYSTEM_MAP, PATTERNS, RULES, BUG_LEDGER) maintain institutional memory
2. **Artifact-Driven State**: Files in repository are truth, not conversation history
3. **Role-Based Specialization**: Each role has specific responsibilities and triggers
4. **Formal Review Gates**: Separation of writing and reviewing prevents blind spots
5. **Test-Driven Development**: Specs → Tests (red) → Implementation (green)
6. **Learning from History**: BUG_LEDGER + sentinel tests prevent regression
7. **Human-as-Manager**: Human approves gates and makes decisions; agents execute

## Workflow Structure Being Designed

The workflow has these phases:

**1. Foundation** (pre-workflow)
- VISION.md - The aspirational "why"

**2. Planning**
- Scope Writer → SCOPE.md (what's in/out)
- Roadmap Planner → ROADMAP.md (feature sequence)
- Planning Reviewer → approves both

**3. Design/Contract**
- Specification Writer → feature specs
- Skeleton Interface Writer → code stubs
- Reviews at each step

**4. Testing**
- Test Writer → comprehensive test suites (TDD red)
- Test Reviewer → verifies coverage

**5. Implementation**
- Feature Implementer → makes tests pass (TDD green)
- Implementation Reviewer → approves production code
- Implementation Advisor → helps when stuck

**6. Documentation**
- Platform Lead → maintains living docs continuously

## Success Indicators for This Meta-Project

The workflow design is working when:

✅ Role definitions are clear and actionable
✅ Roles don't overlap or leave gaps
✅ Workflow sequence is logical and efficient
✅ Examples demonstrate real usage patterns
✅ Principles are consistently applied
✅ Documentation is concise and scannable
✅ Roles follow Skills framework inspiration

## Red Flags in Workflow Design

❌ Role definitions that are vague or abstract
❌ Overlapping responsibilities between roles
❌ Missing steps in workflow sequence
❌ Verbose documentation that wastes tokens
❌ Roles that don't match Skills framework patterns
❌ Lack of concrete examples
❌ Inconsistent structure across role definitions

## Working in This Project

### Creating New Role Definitions

**Before starting**:
1. Read `/mnt/skills/examples/skill-creator/SKILL.md`
2. Review 2-3 existing role definitions for patterns
3. Understand where new role fits in workflow

**Structure to follow**:
```markdown
---
role: Role Name
trigger: When this role activates
typical_scope: What one invocation covers
---

# Role Name

## Responsibilities
[Concise - what does this role do?]

## Collaboration Pattern
[Collaborative/Autonomous/Independent + who works with whom]

## Inputs
[What artifacts/docs does role need?]

## Process
[Step-by-step workflow]

## Outputs
[What artifacts does role produce?]

## Best Practices
[Concrete dos and don'ts]

## Common Pitfalls
[What goes wrong and how to avoid]

## Examples
[2-4 concrete examples showing role in action]

## When to Deviate
[When to adjust rigor]

## Critical Reminders
[DO/DON'T summary]
```

### Refining Existing Roles

**Conciseness improvements**:
- Remove redundant explanations
- Replace verbose text with examples
- Move detailed references to separate files if needed
- Challenge every paragraph: "Does Claude need this?"

**Consistency improvements**:
- Match structure of other role definitions
- Use consistent terminology
- Align with Skills framework patterns
- Update cross-references to other roles

### Updating Workflow Documentation

Keep workflow-*.md files aligned with role definitions:
- workflow-roles-index.md: Overview and principles
- workflow-diagram.md: Visual representation
- Any other workflow-* files as needed


## Important Distinctions

### This Is NOT a Concrete Project
- We're not writing specs for features
- We're not writing tests or implementation
- We're not maintaining SYSTEM_MAP/PATTERNS for a codebase
- We're designing the process that would do those things

### Role Definitions Are Instructions, Not Scripts
- Roles guide human/AI collaboration
- Not step-by-step automation
- Allow for judgment and adaptation
- Provide patterns and principles

### Skills Framework Inspiration, Not Implementation
- We're inspired by Skills structure
- Role definitions aren't literal Claude Skills
- We adapt the principles to workflow documentation
- Focus on conciseness and procedural knowledge

## Questions?

When working in this meta-project:
- Reference the skill-creator skill for design patterns
- Look at existing role definitions for consistency
- Remember we're designing FOR concrete projects, not running one
- Focus on making roles clear, concise, and actionable
- Think about the solo developer + AI agent collaboration model

The goal is workflow documentation that prevents architecture amnesia and maintains quality as concrete projects grow.