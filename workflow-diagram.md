# Workflow Diagram: Feature Development Flow

Visual representation of the AI-augmented software development workflow, showing the role of the Spec Reviewer gate, gatekeeper movements, and branching strategy.

## Complete Feature Flow with Spec Review Gate

```mermaid
flowchart LR
    A[Write Spec<br/>specs/proposed/] --> B{Spec Review<br/>reviews/specs/...}
    B -- APPROVED --> C[Move to specs/todo/<br/>Gatekeeper: Spec Reviewer]
    B -- NEEDS-CHANGES --> A
    
    C --> D[Start Implementation<br/>move todo to doing by Implementer<br/>CREATE FEATURE BRANCH]
    
    D --> E[Write Tests<br/>tests/unit/test_feature.py]
    E --> F{Test Review all-in<br/>reviews/tests/...}
    F -- NEEDS-CHANGES --> E
    F -- APPROVED --> G[Implementation]
    
    G --> H{Implementation Review<br/>reviews/implementations/...}
    H -- NEEDS-CHANGES --> G
    H -- APPROVED --> I[Move to specs/done/<br/>Gatekeeper: Implementation Reviewer<br/>MERGE TO MAIN]
    
    style A fill:#fff4e6,stroke:#ff9800,stroke-width:2px
    style C fill:#e1f5ff,stroke:#0066cc,stroke-width:2px
    style D fill:#ffe6f0,stroke:#d32f2f,stroke-width:2px
    style E fill:#fff4e6,stroke:#ff9800,stroke-width:2px
    style G fill:#fff4e6,stroke:#ff9800,stroke-width:2px
    style I fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px
    
    style B fill:#f0e6ff,stroke:#7c3aed,stroke-width:3px
    style F fill:#f0e6ff,stroke:#7c3aed,stroke-width:3px
    style H fill:#f0e6ff,stroke:#7c3aed,stroke-width:3px
```

### Flow Explanation

1. **Spec Writer** creates spec in `specs/proposed/`
2. **Spec Reviewer** reviews and creates a timestamped review
   - If APPROVED: **Gatekeeper moves** `proposed/` to `todo/`
   - If NEEDS-CHANGES: Returns to Spec Writer
3. **Implementer** moves `todo/` to `doing/` and creates feature branch
4. **Test Writer** creates comprehensive test suite
5. **Test Reviewer** reviews entire suite (all-in)
   - If APPROVED: Proceed to implementation
   - If NEEDS-CHANGES: Returns to Test Writer
6. **Implementer** makes tests pass
7. **Implementation Reviewer** reviews code
   - If APPROVED: **Gatekeeper moves** `doing/` to `done/`, merges to main
   - If NEEDS-CHANGES: Returns to Implementer

## Branching Strategy

```mermaid
flowchart TB
    subgraph MainBranch["Main Branch"]
        M[Main Branch] --> PROP[specs/proposed/]
        M --> TODO[specs/todo/]
        M --> PLAN[VISION, SCOPE, ROADMAP]
        M --> LIVING[SYSTEM_MAP, PATTERNS, RULES, BUG_LEDGER]
        M --> REV[reviews/*]
    end
    
    subgraph Transition["When Implementation Starts"]
        TODO -->|Implementer moves<br/>todo to doing| BRANCH[Create feature/<feature> branch]
    end
    
    subgraph FeatureBranch["Feature Branch"]
        BRANCH --> DOING[specs/doing/feature.md]
        BRANCH --> TESTS[tests/unit/test_feature.py]
        BRANCH --> CODE[src/**/*.py]
    end
    
    subgraph AfterApproval["After Implementation Review APPROVED"]
        CODE -->|Implementation Reviewer<br/>moves doing to done| DONE[specs/done/feature.md]
        DONE --> MERGE[Merge to Main]
    end
    
    style MainBranch fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    style FeatureBranch fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    style AfterApproval fill:#e8f5e9,stroke:#388e3c,stroke-width:2px
    style Transition fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    
    style BRANCH fill:#ffebee,stroke:#d32f2f,stroke-width:3px
    style MERGE fill:#c8e6c9,stroke:#2e7d32,stroke-width:3px
```

### Branch Policy Summary

**Main branch contains:**
- All planning docs (VISION, SCOPE, ROADMAP)
- All living docs (SYSTEM_MAP, PATTERNS, RULES, BUG_LEDGER)
- All review records (reviews/*)
- Specs in `proposed/` and `todo/` states only

**Feature branch created when:**
- Implementer moves spec from `todo/` to `doing/`
- Marks the actual start of coding work
- Named: `feature/<feature-name>`

**Feature branch contains:**
- Spec in `doing/` state
- Test files (tests/*)
- Implementation code (src/*)

**Merge trigger:**
- Implementation Reviewer approves
- All tests passing (green state)
- Spec moved to `done/`
- Feature complete

## Spec State Machine

```mermaid
stateDiagram-v2
    [*] --> Proposed: Spec Writer creates
    
    Proposed --> Todo: Spec Reviewer APPROVES<br/>(Gatekeeper moves)
    Proposed --> Proposed: Spec Reviewer NEEDS-CHANGES
    
    Todo --> Doing: Skeleton Writer after approval<br/>(Creates feature branch)
    
    Doing --> Done: Implementation Reviewer APPROVES<br/>(Gatekeeper moves, merge to main)
    Doing --> Doing: Implementation Reviewer NEEDS-CHANGES
    
    Done --> [*]
    
    note right of Proposed
        specs/proposed/
        On main branch
        Awaiting review
    end note
    
    note right of Todo
        specs/todo/
        On main branch
        Ready to implement
    end note
    
    note right of Doing
        specs/doing/
        On feature branch
        Implementation in progress
    end note
    
    note right of Done
        specs/done/
        On main branch (after merge)
        Feature complete
    end note
```

## Gatekeeper Responsibilities

```mermaid
flowchart LR
    subgraph SpecReviewer["Spec Reviewer (Gatekeeper 1)"]
        SR[Reviews spec in proposed/]
        SR --> SRA{Verdict}
        SRA -->|APPROVED| SRM[Moves proposed/ to todo/]
        SRA -->|NEEDS-CHANGES| SRN[No move, returns feedback]
    end
    
    subgraph Implementer["Implementer (Marker, Not Gate)"]
        IMP[Starts implementation]
        IMP --> IMPM[Moves todo/ to doing/<br/>Creates feature branch]
    end
    
    subgraph ImplReviewer["Implementation Reviewer (Gatekeeper 2)"]
        IR[Reviews implementation]
        IR --> IRA{Verdict}
        IRA -->|APPROVED| IRM[Moves doing/ to done/<br/>Approves merge]
        IRA -->|NEEDS-CHANGES| IRN[No move, returns feedback]
    end
    
    SRM --> SKWM
    SKWM --> IRM
    
    style SRM fill:#4caf50,stroke:#2e7d32,stroke-width:2px
    style IRM fill:#4caf50,stroke:#2e7d32,stroke-width:2px
    style IMPM fill:#2196f3,stroke:#1565c0,stroke-width:2px
    
    style SRN fill:#f44336,stroke:#c62828,stroke-width:2px
    style IRN fill:#f44336,stroke:#c62828,stroke-width:2px
```

### Gatekeeper Rules

**Spec Reviewer (proposed to todo):**
- ONLY moves specs when review status is APPROVED
- Creates `reviews/specs/YYYY-MM-DDTHH-MM-SS-<feature>-APPROVED.md`
- On NEEDS-CHANGES: spec stays in `proposed/`, no movement

**Implementer (todo to doing):**
- Not a review gate, just marking start of work
- Creates feature branch at this point
- No approval needed, just starting implementation

**Implementation Reviewer (doing to done):**
- ONLY moves specs when review status is APPROVED
- Creates `reviews/implementations/YYYY-MM-DDTHH-MM-SS-<feature>-APPROVED.md`
- On NEEDS-CHANGES: spec stays in `doing/`, no movement
- Approval also gates merge to main

## Review Filename Convention

All reviews follow this pattern:
```
reviews/<type>/YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md
```

**Components:**
- `<type>`: planning | specs | skeletons | tests | implementations
- Timestamp: ISO 8601 with seconds (e.g., `2025-01-23T14-30-47`)
- `<feature>`: kebab-case feature name
- `<STATUS>`: APPROVED | NEEDS-CHANGES

**Examples:**
- `reviews/specs/2025-01-23T09-15-30-user-auth-APPROVED.md`
- `reviews/tests/2025-01-24T14-30-47-weather-cache-NEEDS-CHANGES.md`
- `reviews/implementations/2025-01-25T16-45-22-user-auth-APPROVED.md`

## Complete Workflow with All Roles

```mermaid
graph TD
    %% Foundation
    VIS[VISION.md<br/>Foundation]:::foundation
    
    %% Planning
    VIS --> SW[Scope Writer<br/>+ Human]:::collab
    VIS --> RP[Roadmap Planner<br/>+ Human]:::collab
    SW --> SCOPE[SCOPE.md]:::artifact
    SCOPE --> RP
    RP --> ROADMAP[ROADMAP.md]:::artifact
    
    SCOPE --> PR{Planning<br/>Reviewer}:::review
    ROADMAP --> PR
    
    %% Spec Phase
    PR --> SPW[Spec Writer<br/>+ Human]:::collab
    VIS --> SPW
    ROADMAP --> SPW
    SPW --> SPECPROP[specs/proposed/<br/>feature.md]:::artifact
    
    SPECPROP --> SPR{Spec<br/>Reviewer}:::review
    SPR -->|APPROVED<br/>Move to todo/| SPECTODO[specs/todo/<br/>feature.md]:::artifact
    SPR -->|NEEDS-CHANGES| SPW
    
    %% Skeleton Phase
    SPECTODO --> SKW[Skeleton<br/>Writer]:::auto
    SPECPROP --> SKW
    SKW --> SKEL[Skeleton<br/>Code]:::artifact
    SKEL --> SKR{Skeleton<br/>Reviewer}:::review
    SKR -->|NEEDS-CHANGES| SKW
    
    %% Implementation Start (After Skeleton Approval)
    SKR --> SKWMOVE[Skeleton Writer<br/>Move to doing/]:::auto
    SPECTODO --> SKWMOVE
    SKWMOVE --> SPECDOING[specs/doing/<br/>feature.md<br/>+ Feature Branch]:::artifact
    
    %% Test Phase
    SPECDOING --> TW[Test<br/>Writer]:::auto
    SKEL --> TW
    TW --> TESTS[Tests<br/>red state]:::artifact
    TESTS --> TR{Test<br/>Reviewer<br/>all-in}:::review
    TR -->|NEEDS-CHANGES| TW
    
    %% Implementation
    TR --> IMP2[Implementer]:::auto
    TESTS --> IMP2
    SKEL --> IMP2
    IMP2 --> CODE[Implementation<br/>green state]:::artifact
    
    CODE --> IR{Implementation<br/>Reviewer}:::review
    IR -->|NEEDS-CHANGES| IMP2
    IR -->|APPROVED<br/>Move to done/| SPECDONE[specs/done/<br/>feature.md<br/>Merged to Main]:::artifact
    
    %% Platform Lead (continuous)
    CODE -.updates.-> PL[Platform<br/>Lead]:::support
    SKEL -.updates.-> PL
    PL -.maintains.-> LIV[Living Docs<br/>SYSTEM_MAP<br/>PATTERNS<br/>RULES<br/>BUG_LEDGER]:::artifact
    
    %% Styles
    classDef foundation fill:#fff3e0,stroke:#e65100,stroke-width:3px
    classDef collab fill:#e1f5ff,stroke:#0066cc,stroke-width:2px
    classDef auto fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px
    classDef review fill:#f0e6ff,stroke:#7c3aed,stroke-width:3px
    classDef artifact fill:#fff4e6,stroke:#ff9800,stroke-width:2px
    classDef support fill:#f5f5f5,stroke:#757575,stroke-width:2px
```

### Role Type Legend

- **Foundation** (orange, thick border): Pre-workflow document
- **Collaborative** (blue): Human + Agent working together
- **Autonomous** (green): Agent working independently
- **Review** (purple, thick border): Independent review gates
- **Artifact** (amber): Documents and code produced
- **Support** (gray): Ongoing/on-demand roles

## Key Workflow Principles Illustrated

1. **Spec Review Gate**: Formal approval before implementation planning begins
2. **Gatekeeper Movements**: Specific roles responsible for moving specs between states
3. **Branching at Doing**: Feature branches created when implementation actually starts
4. **TDD Red-Green**: Tests written and failing before implementation
5. **All-In Test Review**: Complete suite reviewed as single unit
6. **Test Immutability**: Implementation cannot modify tests
7. **Living Docs**: Continuously maintained throughout workflow

## Common Workflow Patterns

### Happy Path (No Revisions)
```
Spec Writer -> proposed/ 
-> Spec Reviewer APPROVED -> todo/
-> Implementer -> doing/ + feature branch
-> Test Writer -> tests (red)
-> Test Reviewer APPROVED
-> Implementer -> code (green)
-> Implementation Reviewer APPROVED -> done/ + merge
```

### With Revision Cycles
```
Spec Writer -> proposed/
-> Spec Reviewer NEEDS-CHANGES
-> Spec Writer (revise) -> proposed/
-> Spec Reviewer APPROVED -> todo/
...
-> Test Writer -> tests (red)
-> Test Reviewer NEEDS-CHANGES
-> Test Writer (fix) -> tests (red)
-> Test Reviewer APPROVED
...
-> Implementation Reviewer NEEDS-CHANGES
-> Implementer (fix) -> code (green)
-> Implementation Reviewer APPROVED -> done/ + merge
```

## Tool Support

The workflow can be enforced with:
- **Git hooks**: Prevent direct pushes to certain dirs
- **CI/CD**: Verify review files exist before merges
- **Scripts**: Automate gatekeeper movements
- **Linters**: Check file naming conventions

## Quick Reference Commands

### Spec Reviewer (Gatekeeper)
```bash
# On APPROVED review
git mv specs/proposed/feature.md specs/todo/feature.md
git add reviews/specs/2025-01-23T14-30-47-feature-APPROVED.md
git commit -m "spec: approve feature specification"
```

### Skeleton Writer (After Approval)
```bash
# After skeleton approval, moving to doing state
git checkout -b feature/feature-name
git mv specs/todo/feature.md specs/doing/feature.md
git commit -m "feat: start development of feature

- Skeleton code approved and on feature branch
- Ready for test writing phase"
```

### Implementation Reviewer (Gatekeeper)
```bash
# On APPROVED review
git mv specs/doing/feature.md specs/done/feature.md
git add reviews/implementations/2025-01-25T16-45-22-feature-APPROVED.md
git commit -m "impl: approve feature implementation"
git checkout main
git merge feature/feature-name
```

## Notes

- All diagrams show forward flow only (revision loops simplified)
- Timestamps in examples use ISO 8601 format with seconds
- Feature branches created at `doing` state, not `todo` state
- Reviews accumulate (history preserved) with timestamped filenames
- Living docs (SYSTEM_MAP, etc.) updated continuously, not just at gates
