# Schema Relationship Map

**Use this pattern when:** Understanding how schemas relate and depend on each other in the workflow
**Skip this if:** You only need details about a specific schema (read that schema file directly)

## Purpose

This document provides a central map of how all workflow schemas relate to each other. It replaces individual "Related Ontologies" sections in each schema file with a single authoritative reference.

## Schema Categories

### Planning Documents (Strategic → Tactical)
1. **schema-vision.md** → defines strategic foundation
2. **schema-scope.md** → defines tactical boundaries
3. **schema-roadmap.md** → defines operational sequencing

### Feature Development Artifacts
4. **schema-spec.md** → behavioral contracts (from roadmap features)
5. **schema-interface-skeleton-code.md** → code structure (from specs)
6. **schema-test-code.md** → test contracts (from specs)
7. **schema-implementation-code.md** → production code (satisfies tests)

### Living Documentation
8. **schema-system-map.md** → architectural blueprint
9. **schema-guidelines.md** → coding patterns and constraints

### Quality Gates
10. **schema-review.md** → review outputs (gatekeeping)
11. **schema-review-request.md** → review inputs (context)

### Bug Workflow
12. **schema-bug-report.md** → defect documentation

---

## Relationship Matrix

### Planning Document Relationships

**schema-vision.md**
- **Consumed by:**
  - schema-scope.md (scope derives from vision)
  - schema-roadmap.md (roadmap aligns with vision)
  - schema-spec.md (specs align with vision)
- **Consumes:** none (foundation document)

**schema-scope.md**
- **Consumed by:**
  - schema-roadmap.md (roadmap sequences scope features)
  - schema-spec.md (specs implement scope features)
- **Consumes:**
  - schema-vision.md (derives from vision)

**schema-roadmap.md**
- **Consumed by:**
  - schema-spec.md (specs derive from roadmap features)
- **Consumes:**
  - schema-vision.md (aligns with vision)
  - schema-scope.md (sequences scope features)

---

### Feature Development Relationships

**schema-spec.md**
- **Consumed by:**
  - schema-interface-skeleton-code.md (skeleton implements spec interfaces)
  - schema-test-code.md (tests verify spec behavior)
  - schema-implementation-code.md (implementation satisfies spec)
  - schema-review.md (reviewers validate against spec)
- **Consumes:**
  - schema-roadmap.md (derives from roadmap features)
  - schema-vision.md (aligns with vision)
  - schema-scope.md (implements scope features)
  - schema-system-map.md (references architectural context)

**schema-interface-skeleton-code.md**
- **Consumed by:**
  - schema-test-code.md (tests import skeleton interfaces)
  - schema-implementation-code.md (implementation completes skeleton)
  - schema-review.md (skeleton reviewers validate)
- **Consumes:**
  - schema-spec.md (implements spec interfaces)
  - schema-system-map.md (follows architectural structure)
  - schema-guidelines.md (follows coding patterns)

**schema-test-code.md**
- **Consumed by:**
  - schema-implementation-code.md (implementation makes tests pass)
  - schema-review.md (test reviewers validate)
- **Consumes:**
  - schema-spec.md (tests verify spec behavior)
  - schema-interface-skeleton-code.md (tests import skeleton interfaces)
  - schema-guidelines.md (follows testing standards)

**schema-implementation-code.md**
- **Consumed by:**
  - schema-review.md (implementation reviewers validate)
- **Consumes:**
  - schema-spec.md (satisfies spec requirements)
  - schema-interface-skeleton-code.md (completes skeleton)
  - schema-test-code.md (makes tests pass)
  - schema-system-map.md (follows architecture)
  - schema-guidelines.md (follows standards)

---

### Living Documentation Relationships

**schema-system-map.md**
- **Consumed by:**
  - schema-spec.md (specs reference architectural context)
  - schema-interface-skeleton-code.md (skeletons follow structure)
  - schema-implementation-code.md (implementations follow architecture)
  - schema-review.md (reviewers check architectural compliance)
  - schema-guidelines.md (guidelines reference structure)
- **Consumes:**
  - schema-guidelines.md (complementary: SYSTEM_MAP shows structure, GUIDELINES shows conventions)

**schema-guidelines.md**
- **Consumed by:**
  - schema-interface-skeleton-code.md (skeletons follow patterns)
  - schema-test-code.md (tests follow testing standards)
  - schema-implementation-code.md (implementations follow standards)
  - schema-review.md (reviewers check guideline compliance)
  - schema-system-map.md (complementary: shows conventions for structure)
- **Consumes:**
  - schema-system-map.md (complementary: GUIDELINES documents constraints, SYSTEM_MAP documents structure)

---

### Quality Gate Relationships

**schema-review.md**
- **Consumed by:**
  - All workflow participants (understand review format)
  - All reviewer roles (what to produce)
- **Consumes:**
  - All other schemas (defines what to review for each artifact type)
  - schema-review-request.md (reviews respond to requests)

**schema-review-request.md**
- **Consumed by:**
  - All reviewer roles (what context they'll receive)
  - All writer roles (how to request reviews)
- **Consumes:**
  - schema-review.md (requests lead to reviews)
  - All other schemas (requests provide context for any artifact type)

---

### Bug Workflow Relationships

**schema-bug-report.md**
- **Consumed by:**
  - schema-implementation-code.md (bug fixes are implementation work)
  - schema-review.md (bug fix reviews)
- **Consumes:**
  - schema-system-map.md (bug reports categorize by component)
  - schema-guidelines.md (bug patterns may update guidelines)

---

## Dependency Levels (Bottom-Up)

**Level 0 (Foundation):**
- schema-vision.md

**Level 1 (Strategic Planning):**
- schema-scope.md (depends on: vision)
- schema-system-map.md (depends on: none - describes actual code)
- schema-guidelines.md (depends on: none - describes actual patterns)

**Level 2 (Tactical Planning):**
- schema-roadmap.md (depends on: vision, scope)

**Level 3 (Feature Specification):**
- schema-spec.md (depends on: vision, scope, roadmap, system-map)

**Level 4 (Development Artifacts):**
- schema-interface-skeleton-code.md (depends on: spec, system-map, guidelines)
- schema-test-code.md (depends on: spec, skeleton, guidelines)

**Level 5 (Implementation):**
- schema-implementation-code.md (depends on: spec, skeleton, tests, system-map, guidelines)

**Level X (Cross-Cutting):**
- schema-review.md (depends on: ALL schemas - reviews any artifact)
- schema-review-request.md (depends on: ALL schemas - requests for any artifact)
- schema-bug-report.md (depends on: system-map, guidelines)

---

## Workflow Flow

```
VISION.md (schema-vision)
    ↓
SCOPE.md (schema-scope)
    ↓
ROADMAP.md (schema-roadmap)
    ↓
SPEC.md (schema-spec) ← references SYSTEM_MAP.md, GUIDELINES.md
    ↓
    ├→ skeleton code (schema-interface-skeleton-code)
    ├→ test code (schema-test-code)
    └→ implementation code (schema-implementation-code)

    At each stage: reviews (schema-review, schema-review-request)

Parallel: bug reports (schema-bug-report) → fixes → reviews

Living docs continuously updated:
- SYSTEM_MAP.md (schema-system-map)
- GUIDELINES.md (schema-guidelines)
```

---

## Key Patterns

### Hierarchical Planning
vision → scope → roadmap → spec
*Each level adds detail and derives from previous*

### Parallel Development Artifacts
spec → {skeleton, tests, implementation}
*All three derive from spec in coordinated way*

### Living Documentation (Continuous)
system-map + guidelines evolve with codebase
*Referenced by all development artifacts*

### Quality Gates (Cross-Cutting)
reviews apply to any artifact at any stage
*Universal quality mechanism*

### Bug Workflow (Alternative Path)
bug-report → implementation-code (fix) → review
*Lighter weight than full feature workflow*

---

## Usage Notes

**For schema authors:**
- When updating a schema, check this map for downstream impacts
- If schema relationships change, update this map

**For role file authors:**
- Reference this map to understand which schemas your role consumes/produces
- Link to specific sections for dependencies

**For workflow participants:**
- Use this map to understand where artifacts fit in the bigger picture
- Follow arrows to understand information flow

---

## Maintenance

**Update this map when:**
- New schema added
- Schema relationships change
- Workflow structure evolves

**Owner:** Platform Lead

**Related:**
- LayoutAndState.md (directory structure)
- state-transitions.md (artifact lifecycle)
- workflow-overview.md (process flow)
