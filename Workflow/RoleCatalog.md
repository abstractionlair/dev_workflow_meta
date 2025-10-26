# Role Catalog

## Purpose

This document catalogs all available roles in the workflow and explains their interactions.

**Roles** define what an AI agent (or human) should do at each workflow stage. Each role has specific responsibilities, inputs, and outputs.

## Role Layers

Roles are organized by workflow stage. Most features flow through these layers sequentially:

**Strategic/Planning Layer** → **Design/Contract Layer** → **Test Layer** → **Implementation Layer**

### Strategic/Planning Layer

Establish project foundation (done once, versions evolve):

- [role-vision-writer.md](role-vision-writer.md) - Creates VISION.md from project ideas
- [role-vision-reviewer.md](role-vision-reviewer.md) - Reviews and approves vision
- [role-vision-writing-helper.md](role-vision-writing-helper.md) - Helps human articulate vision through dialogue
- [role-scope-writer.md](role-scope-writer.md) - Defines boundaries in SCOPE.md
- [role-scope-reviewer.md](role-scope-reviewer.md) - Reviews and approves scope
- [role-scope-writing-helper.md](role-scope-writing-helper.md) - Helps human determine scope boundaries
- [role-roadmap-writer.md](role-roadmap-writer.md) - Sequences features in ROADMAP.md
- [role-roadmap-reviewer.md](role-roadmap-reviewer.md) - Reviews and approves roadmap
- [role-roadmap-writing-helper.md](role-roadmap-writing-helper.md) - Helps human prioritize features

### Design/Contract Layer

Define what to build (per-feature):

- [role-spec-writer.md](role-spec-writer.md) - Writes detailed feature specification
- [role-spec-reviewer.md](role-spec-reviewer.md) - Reviews spec, gates proposed→todo transition
- [role-spec-writing-helper.md](role-spec-writing-helper.md) - Helps human draft specification
- [role-skeleton-writer.md](role-skeleton-writer.md) - Creates interface scaffolding (types, signatures, stubs)
- [role-skeleton-reviewer.md](role-skeleton-reviewer.md) - Reviews interfaces before tests

### Test Layer

Define how to verify (per-feature):

- [role-test-writer.md](role-test-writer.md) - Writes TDD test suite (RED first)
- [role-test-reviewer.md](role-test-reviewer.md) - Reviews test coverage and quality

### Implementation Layer

Build and verify (per-feature):

- [role-implementer.md](role-implementer.md) - Implements features (GREEN), fixes bugs, refactors
- [role-implementation-reviewer.md](role-implementation-reviewer.md) - Reviews code, gates doing→done transition

### Bug Fixing

Handle defects:

- [role-bug-recorder.md](role-bug-recorder.md) - Converts unstructured bug reports to schema-compliant documents

### Support/Meta Roles

Maintain project health:

- [role-platform-lead.md](role-platform-lead.md) - Maintains SYSTEM_MAP.md and GUIDELINES.md, approves living doc changes

## Role Interactions

### Typical Feature Flow

```
1. spec-writer        → creates spec in specs/proposed/
2. spec-reviewer      → approves, moves to specs/todo/
3. skeleton-writer    → creates interfaces, moves spec to specs/doing/, creates feature branch
4. skeleton-reviewer  → approves interfaces
5. test-writer        → writes tests (RED)
6. test-reviewer      → approves tests
7. implementer        → makes tests GREEN
8. implementation-reviewer → approves, merges to main, moves spec to specs/done/
```

### Helper Roles

Roles ending in `-helper` assist humans through interactive dialogue rather than writing artifacts directly. Use when you need to:
- Explore ideas before committing to an artifact
- Clarify requirements through Q&A
- Make decisions about content

## When to Use Which Role

| Situation | Use this role |
|-----------|---------------|
| Starting a new project | vision-writing-helper |
| Have clear vision, need formal doc | vision-writer |
| Vision ready for review | vision-reviewer |
| Need to define project boundaries | scope-writer (or scope-writing-helper) |
| Need to prioritize features | roadmap-writer (or roadmap-writing-helper) |
| Ready to specify a feature | spec-writer (or spec-writing-helper) |
| Spec needs approval | spec-reviewer |
| Approved spec needs code structure | skeleton-writer |
| Ready to write tests | test-writer |
| Ready to implement | implementer |
| Code ready for review | implementation-reviewer |
| Found a bug | bug-recorder → implementer |
| Architecture changed | platform-lead |
