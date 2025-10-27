# Where Things Live on the Filesystem and How They Record Project State

## Where things Live

This shows where things live when using this workflow in concrete projects.

```
project/
├── VISION.md              # Why this project exists
├── SCOPE.md               # What's in/out
├── ROADMAP.md             # Feature sequence
├── SYSTEM_MAP.md          # Architecture reference
├── GUIDELINES.md          # Coding conventions
├── Workflow/              # Documents about the workflow copied from this, meta, project
├── bugs/                  # Bug reports
│   ├── to_fix/                # Pending
│   ├── fixing/                # In progress
│   ├── fixed/                 # Done
├── specs/
│   ├── proposed/          # Awaiting review
│   ├── todo/              # Approved, not started
│   ├── doing/             # In progress (on feature branch)
│   └── done/              # Completed (merged to main)
├── review-requests/        # Review requests (inputs to reviewers)
│   ├── vision/
│   ├── scope/
│   ├── roadmap/
│   ├── specs/
│   ├── skeletons/
│   ├── tests/
│   ├── implementations/
│   ├── bug-fixes/
│   └── archived/           # Completed review requests
├── reviews/                # Review outputs (created by reviewers)
│   ├── vision/
│   ├── scope/
│   ├── roadmap/
│   ├── specs/
│   ├── skeletons/
│   ├── tests/
│   ├── implementations/
│   └── bug-fixes/
├── tests/
│   ├── unit/              # Tests for contract correctness and completeness for isolated units
│   ├── integration/       # Tests for contract correctness and completeness across units
│   └── regression         # Test that would have caught bugs we needed to fix
└── src/                   # Implementation code
```

## Recording State

The locations of files under `bugs/`, `specs/`, `review-requests/`, `reviews/`, and `tests/` tell us about their states.
As does the branch they are in.

As a general principle, we adopt the following strategy for transitions.
- If there is a reviewer acting as gatekeeper, the reviewer moves things to the next state on approval.
- - E.g. the Spec Reviewer moves specs from proposed/ to todo/ upon approval.
- - And the Implementation Reviewer merges a feature branch upon approval.
- When there is no such gatekeeper, the first role whose work requires a file to be in a new location or implies it ought to be in a new location moves it.
- - E.g. As the first role that writes code for a spec, the Skeleton Writer moves the spec from `todo/` to `doing/`
- - It also needs a feature branch to start writing code to, so it creates the branch and switches to it.

### Spec State Transitions

- Spec Writer creates in `specs/proposed/`
- Spec Reviewer moves from `proposed/` to `todo/` on approval (gatekeeper)
- Skeleton Writer moves from `todo/` to `doing/` when starting implementation
- Skeleton Writer creates feature branch when moving to `doing/`
- Implementation Reviewer moves from `doing/` to `done/` on approval (gatekeeper)
- Implementation Reviewer merges feature branch to main

### Bug State Transitions

- Bug Recorder creates in `bugs/to_fix/`
- Implementer moves from `to_fix/` to `fixing/` when starting work
- Implementation Reviewer moves from `fixing/` to `fixed/` on approval (gatekeeper)

### Review Lifecycle

- Writers create review-requests in `review-requests/[type]/`
- Reviewers create review outputs in `reviews/[type]/`
- Reviewers move review-requests to `review-requests/archived/` after creating review

### State Transition Summary

| Artifact Type | Transition | Who Moves | Gatekeeper? |
|---------------|------------|-----------|-------------|
| Specs | proposed → todo | Spec Reviewer | ✓ |
| Specs | todo → doing | Skeleton Writer | |
| Specs | doing → done | Implementation Reviewer | ✓ |
| Bugs | to_fix → fixing | Implementer | |
| Bugs | fixing → fixed | Implementation Reviewer | ✓ |
| Review requests | active → archived | Reviewer | |

**For detailed state transition rules, preconditions, postconditions, and git commands,** see [state-transitions.md](state-transitions.md).

## Branching Strategy

- **Main branch**: Planning docs, living docs, specs in `proposed/` and `todo/` states can be worked on directly in Main.
- **Feature branches**: Created when spec moves to `doing/`, contains tests and implementation.
- **Merge trigger**: Implementation reviewer approves, spec moves to `done/`
