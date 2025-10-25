# Repo Layout

When using this workflow in actual projects:

```
project/
├── VISION.md              # Why this project exists
├── SCOPE.md               # What's in/out
├── ROADMAP.md             # Feature sequence
├── SYSTEM_MAP.md          # Architecture reference
├── GUIDELINES.md          # Coding conventions
├── bugs/                  # Bug reports and status
│   ├── to_fix/                # Pending
│   ├── fixing/                # In progress
│   ├── fixed/                 # Done
├── specs/
│   ├── proposed/          # Awaiting review
│   ├── todo/              # Approved, not started
│   ├── doing/             # In progress (on feature branch)
│   └── done/              # Completed (merged to main)
├── reviews/
│   ├── vision/
│   ├── scope/
│   ├── specs/
│   ├── roadmap/
│   ├── skeletons/
│   ├── tests/
│   └── implementations/
├── tests/
│   ├── unit/              # Tests for contract correctness and completeness for isolated units
│   ├── integration/       # Tests for contract correctness and completeness across units
│   └── regression         # Test that would have caught bugs we needed to fix
└── src/                   # Implementation code
```

### Branching Strategy

- **Main branch**: Planning docs, living docs, specs in `proposed/` and `todo/` states
- **Feature branches**: Created when spec moves to `doing/`, contains tests and implementation
- **Merge trigger**: Implementation reviewer approves, spec moves to `done/`
