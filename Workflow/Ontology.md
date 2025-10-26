# Artifact Types and Documentation Map

## Purpose

This document catalogs the **types of artifacts** in this workflow and explains how they relate.

**Artifacts** are documents and code that capture decisions, contracts, and implementations. Each has a defined schema, purpose, and dependencies.

## Artifact Relationships

```
VISION.md ──────────────────┐
    ↓                       │
SCOPE.md ←─────────────┐    │  (referenced by all downstream work)
    ↓                  │    │
ROADMAP.md             │    │
    ↓                  │    │
Feature Specs ←────────┴────┴── SYSTEM_MAP.md, GUIDELINES.md
    ↓
Skeletons
    ↓
Tests ←──────────────────────── bugs/fixed/ (regression tests)
    ↓
Implementation
```

## Schema Reference

Read in workflow order:

**Strategic (create once):**
1. [schema-vision.md](schema-vision.md) - Why we're building this
2. [schema-scope.md](schema-scope.md) - What's in/out
3. [schema-roadmap.md](schema-roadmap.md) - Feature sequence

**Living (continuous updates):**
4. [schema-system-map.md](schema-system-map.md) - Architecture reference
5. [schema-guidelines.md](schema-guidelines.md) - Coding conventions

**Per-feature (flow through states):**
6. [schema-spec.md](schema-spec.md) - Feature contracts
7. [schema-interface-skeleton-code.md](schema-interface-skeleton-code.md) - Code structure
8. [schema-test-code.md](schema-test-code.md) - Contract verification
9. [schema-implementation-code.md](schema-implementation-code.md) - Working code

**Quality assurance:**
10. [schema-review.md](schema-review.md) - Approval gates
11. [schema-bug-report.md](schema-bug-report.md) - Defect tracking

## State Tracking

Artifacts track state via **directory location** and **git branch**. See [LayoutAndState.md](LayoutAndState.md) for details.
