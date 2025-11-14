# Where Things Live on the Filesystem and How They Record Project State

## Where things Live

This shows where things live when using this workflow in concrete projects.

The root directory contains only entry points (CLAUDE.md, AGENTS.md, etc.) and navigational files (README.md, CONTRIBUTING.md).
All other content is organized into:
- **project-meta/**: Information *about* the project (planning, specs, workflow)
- **project-content/**: Deliverable *outputs* of the project (code, tests, docs)

```
project/
├── CLAUDE.md                        # Entry point for Claude Code
├── AGENTS.md                        # Entry point for Anthropic agents
├── GEMINI.md                        # Entry point for Gemini
├── CODEX.md                         # Entry point for Codex
├── OPENCODE.md                      # Entry point for OpenCode
├── README.md                        # About the project (for all audiences)
├── CONTRIBUTING.md                  # How to contribute
├── project-meta.config.json         # Path configuration (optional)
├── project-meta/                    # Meta: information ABOUT the project
│   ├── workflow/                    # Git submodule -> dev_workflow_meta
│   ├── planning/
│   │   ├── VISION.md                # Why this project exists
│   │   ├── SCOPE.md                 # What's in/out
│   │   └── ROADMAP.md               # Feature sequence
│   ├── architecture/
│   │   ├── SYSTEM_MAP.md            # Architecture reference
│   │   └── GUIDELINES.md            # Coding conventions
│   ├── specs/                       # Feature specifications
│   │   ├── proposed/                # Awaiting review
│   │   ├── todo/                    # Approved, not started
│   │   ├── doing/                   # In progress (on feature branch)
│   │   └── done/                    # Completed (merged to main)
│   ├── bugs/                        # Bug reports
│   │   ├── to_fix/                  # Pending
│   │   ├── fixing/                  # In progress
│   │   └── fixed/                   # Done
│   ├── review-requests/             # Review requests (inputs to reviewers)
│   │   ├── vision/
│   │   ├── scope/
│   │   ├── roadmap/
│   │   ├── specs/
│   │   ├── skeletons/
│   │   ├── tests/
│   │   ├── implementations/
│   │   ├── bug-fixes/
│   │   └── archived/                # Completed review requests
│   └── reviews/                     # Review outputs (created by reviewers)
│       ├── vision/
│       ├── scope/
│       ├── roadmap/
│       ├── specs/
│       ├── skeletons/
│       ├── tests/
│       ├── implementations/
│       └── bug-fixes/
└── project-content/                 # Content: deliverable OUTPUTS of the project
    ├── src/                         # Implementation code
    ├── tests/                       # Test code
    │   ├── unit/                    # Tests for isolated units
    │   ├── integration/             # Tests across units
    │   └── regression/              # Tests for fixed bugs
    └── docs/                        # User-facing documentation
```

## Recording State

The locations of files under `project-meta/` subdirectories tell us about their states.
Git branches also indicate state.

As a general principle, we adopt the following strategy for transitions:
- If there is a reviewer acting as gatekeeper, the reviewer moves things to the next state on approval.
  - E.g. the Spec Reviewer moves specs from `proposed/` to `todo/` upon approval.
  - And the Implementation Reviewer merges a feature branch upon approval.
- When there is no such gatekeeper, the first role whose work requires a file to be in a new location or implies it ought to be in a new location moves it.
  - E.g. As the first role that writes code for a spec, the Skeleton Writer moves the spec from `project-meta/specs/todo/` to `project-meta/specs/doing/`
  - It also needs a feature branch to start writing code to, so it creates the branch and switches to it.

### Spec State Transitions

- Spec Writer creates in `project-meta/specs/proposed/`
- Spec Reviewer moves from `proposed/` to `todo/` on approval (gatekeeper)
- Skeleton Writer moves from `todo/` to `doing/` when starting implementation
- Skeleton Writer creates feature branch when moving to `doing/`
- Implementation Reviewer moves from `doing/` to `done/` on approval (gatekeeper)
- Implementation Reviewer merges feature branch to main

### Bug State Transitions

- Bug Recorder creates in `project-meta/bugs/to_fix/`
- Implementer moves from `to_fix/` to `fixing/` when starting work
- Implementation Reviewer moves from `fixing/` to `fixed/` on approval (gatekeeper)

### Review Lifecycle

- Writers create review-requests in `project-meta/review-requests/[type]/`
- Reviewers create review outputs in `project-meta/reviews/[type]/`
- Reviewers move review-requests to `project-meta/review-requests/archived/` after creating review

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

- **Main branch**: All `project-meta/` content including planning docs, living docs, and specs in `proposed/` and `todo/` states can be worked on directly in main.
- **Feature branches**: Created when spec moves to `doing/`, contains code in `project-content/` (tests and implementation).
- **Merge trigger**: Implementation reviewer approves, spec moves to `done/`, code is merged to main.
