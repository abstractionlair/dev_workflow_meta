# Overview of Complete Workflow

## Diagram

<img src="./AI Agent Dev Workflow.svg" alt="Happy Path Flowchart" width=600>

[Workflow .drawio](./AI%20Agent%20Dev%20Workflow.drawio)

## Interactions

### Artifact Ownership Matrix

| Artifact | Created By | Approved By | Moved By | Lives On |
|----------|------------|-------------|----------|----------|
| VISION.md | Vision Writer | Vision Reviewer | - | Main |
| SCOPE.md | Scope Writer | Scope Reviewer | - | Main |
| ROADMAP.md | Roadmap Writer | Roadmap Reviewer | - | Main |
| specs/proposed/ | Spec Writer | - | - | Main |
| specs/todo/ | - | Spec Reviewer | Spec Reviewer ★ | Main |
| specs/doing/ | - | Skeleton Reviewer | Skeleton Writer | Feature branch |
| specs/done/ | - | Implementation Reviewer | Implementation Reviewer ★ | Main (after merge) |
| Skeleton code | Skeleton Writer | Skeleton Reviewer | - | Feature branch |
| Tests | Test Writer | Test Reviewer | - | Feature branch |
| Implementation | Implementer | Implementation Reviewer | - | Feature branch |
| Living docs | Platform Lead | - | - | Main |
| Reviews | Various Reviewers | - | - | Main |

★ = Gatekeeper role (controls state transitions)

### Artifact Consumers

| Artifact | Primary Consumers | Usage |
|----------|-------------------|-------|
| VISION.md | Scope Writer, Roadmap Writer, Spec Writer | Strategic context, alignment |
| SCOPE.md | Roadmap Writer, Spec Writer | Boundaries, constraints |
| ROADMAP.md | Spec Writer | Feature prioritization |
| SPEC files | Skeleton Writer, Test Writer, Implementer | Implementation contract |
| Skeleton code | Test Writer, Implementer | Interface definitions |
| Tests | Implementer, Implementation Reviewer | Contract verification |
| Implementation | Implementation Reviewer, Platform Lead | Quality check, doc updates |
| SYSTEM_MAP.md | All roles | Architecture reference |
| GUIDELINES.md | Skeleton Writer, Implementer, Spec Writer, Implementer, Reviewers | Coding conventions |
| bug reports in bugs/fixed/ | Test Writer, Implementer, Reviewers | Regression prevention |



### Living Documentation (Continuous)

Living docs are continuously updated.
They can be updated by any code writing role in a feature branch but if they are modified then branch requires an additional approval by the Platform Lead role before merging.

- **SYSTEM_MAP.md** - After architecture changes
- **GUIDELINES.md** - When patterns emerge or constraints added
