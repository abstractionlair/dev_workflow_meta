# Feedback Loops

This document visualizes the feedback processes that allow the workflow to adapt based on learnings. For detailed processes, see [FeedbackLoops.md](FeedbackLoops.md) and [RFC.md](RFC.md). For main workflow, see [workflow-overview.md](workflow-overview.md).

## Overview

The workflow has two feedback mechanisms:

1. **RFC (Request for Change)** - Tactical feedback for amending artifacts during implementation
2. **Checkpoint Review** - Strategic feedback for updating planning documents between phases

```mermaid
graph LR
    Planning[Planning Docs<br/>VISION/SCOPE/ROADMAP]
    Features[Feature Development<br/>Spec → Tests → Impl]

    Planning --> Features
    Features -.RFC<br/>Tactical.-> Planning
    Features -.Checkpoint<br/>Strategic.-> Planning

    style Planning fill:#E6F3FF
    style Features fill:#FFF9E6
```

---

## RFC (Request for Change) - Tactical Feedback

### Purpose

RFCs handle **tactical issues discovered during implementation**:
- Spec missing details needed for skeleton
- Test writer finds missing acceptance criteria
- Implementer finds conflicting requirements
- Implementation reveals spec impractical

### When to Use

```mermaid
graph TD
    Working[Working on Artifact] --> Issue{Found Issue<br/>with Upstream<br/>Artifact?}
    Issue -->|No| Continue[Continue Work]
    Issue -->|Yes| CheckType{Can Continue<br/>Without Fix?}
    CheckType -->|Yes| Note[Note in Comments]
    CheckType -->|No - Blocked| RFC[File RFC]
    Note --> Continue
    RFC --> Wait[Wait for Decision]

    style Working fill:#E6F3FF
    style RFC fill:#FFE6CC
    style Wait fill:#FFB6C1
```

### RFC Process Flow

```mermaid
sequenceDiagram
    participant W as Writer/Implementer<br/>(Discovers Issue)
    participant RFC as RFC Document
    participant A as Original Author<br/>(Decides)
    participant Artifact as Affected Artifact

    W->>RFC: Create RFC in rfcs/open/
    Note over RFC: Document problem,<br/>evidence, solution
    RFC->>A: Notify original author
    A->>RFC: Review RFC

    alt Approved
        A->>Artifact: Update artifact
        A->>RFC: Move to rfcs/approved/
        RFC-->>W: Continue with updated artifact
    else Rejected
        A->>RFC: Add rejection rationale
        A->>RFC: Move to rfcs/rejected/
        RFC-->>W: Work within constraints
    end
```

### RFC Lifecycle

```mermaid
stateDiagram-v2
    [*] --> IssueFound: Discover problem<br/>during work

    IssueFound --> CreatingRFC: Document issue,<br/>evidence, solution

    CreatingRFC --> Open: File in<br/>rfcs/open/

    Open --> AuthorReview: Original author<br/>reviews

    AuthorReview --> Approved: Accept change
    AuthorReview --> Rejected: Reject change

    Approved --> UpdateArtifact: Update affected<br/>artifact
    UpdateArtifact --> ApprovedArchive: Move to<br/>rfcs/approved/

    Rejected --> AddRationale: Add rejection<br/>reason
    AddRationale --> RejectedArchive: Move to<br/>rfcs/rejected/

    ApprovedArchive --> [*]: Continue work<br/>(updated artifact)
    RejectedArchive --> [*]: Continue work<br/>(unchanged artifact)

    state Open {
        [*] --> Pending
        Pending --> UnderReview: Author claimed
        UnderReview --> Pending: Need clarification
    }
```

### RFC Scenarios

#### Scenario 1: Spec Change During Skeleton Writing

```mermaid
graph TD
    SW[Skeleton Writer] --> ReadSpec[Read Spec]
    ReadSpec --> Missing{Missing Interface<br/>Details?}
    Missing -->|Yes| CreateRFC[Create RFC:<br/>Add interface signature]
    CreateRFC --> RFCOpen[rfcs/open/rfc-...-interface.md]
    RFCOpen --> SpecWriter[Spec Writer Reviews]
    SpecWriter --> Approve{Approve?}
    Approve -->|Yes| UpdateSpec[Update SPEC.md]
    UpdateSpec --> RFCApproved[rfcs/approved/]
    Approve -->|No| RFCRejected[rfcs/rejected/<br/>with rationale]
    RFCApproved --> ContinueSkeleton[Continue Skeleton<br/>with updated spec]
    RFCRejected --> WorkAround[Work within<br/>existing spec]

    style Missing fill:#FFE6CC
    style CreateRFC fill:#FFB6C1
    style RFCApproved fill:#90EE90
```

#### Scenario 2: Test Change Request (Extra Scrutiny)

```mermaid
graph TD
    Impl[Implementer] --> Failing{Tests Failing?}
    Failing -->|Yes| Investigate[Investigate Why]
    Investigate --> RootCause{Root Cause?}
    RootCause -->|Bug in Code| FixCode[Fix Implementation]
    RootCause -->|Test Wrong| CreateRFC[Create RFC:<br/>Fix test]
    CreateRFC --> Scrutiny[⚠️ EXTRA SCRUTINY]
    Scrutiny --> TestWriter[Test Writer Reviews]
    TestWriter --> Analyze{Test Correct?}
    Analyze -->|Test has bug| Approve[Approve RFC]
    Analyze -->|Implementation wrong| Reject[Reject RFC:<br/>Fix your code]
    Approve --> UpdateTest[Update test]
    Reject --> FixCode

    style Scrutiny fill:#FFB6C1
    style Reject fill:#FFE6CC
```

**Why extra scrutiny for test changes?**
- Tests are the spec's executable form
- Weakening tests defeats TDD
- 90% of time, implementation is wrong, not test
- Test changes require strong justification

---

## Checkpoint Review - Strategic Feedback

### Purpose

Checkpoint Reviews handle **strategic updates to planning documents**:
- Phase completion reveals new priorities
- High RFC rate indicates planning issues
- Core assumptions invalidated (technical or market changes)
- Implementation learnings require replanning

### Triggers

```mermaid
graph TD
    Monitor[Platform Lead<br/>Monitors Progress]

    Monitor --> T1{Phase<br/>Complete?}
    Monitor --> T2{>50% Features<br/>Need RFCs?}
    Monitor --> T3{Core Assumption<br/>Invalid?}

    T1 -->|Yes| Trigger[Trigger Checkpoint<br/>Review]
    T2 -->|Yes| Trigger
    T3 -->|Yes| Trigger

    T1 -->|No| Continue[Continue Work]
    T2 -->|No| Continue
    T3 -->|No| Continue

    Trigger --> Process[Checkpoint Review<br/>Process]

    style Trigger fill:#FFE6CC
    style Process fill:#FFB6C1
```

### Checkpoint Review Process

```mermaid
graph TD
    Start([Trigger]) --> Identify[Platform Lead:<br/>Identify Need]
    Identify --> Gather[Assemble Findings]

    Gather --> Examples[Collect Examples:<br/>- RFCs filed<br/>- Features changed<br/>- Assumptions broken]

    Examples --> Session[Review Session]

    Session --> Decide{Changes<br/>Needed?}

    Decide -->|No| Document[Document:<br/>No changes needed]
    Decide -->|Yes| Update[Update Strategic Docs]

    Update --> Vision{Update<br/>VISION?}
    Vision -->|Yes| VisionUpdate[Update VISION.md<br/>Increment version]
    Vision -->|No| Scope

    VisionUpdate --> Scope{Update<br/>SCOPE?}
    Scope -->|Yes| ScopeUpdate[Update SCOPE.md<br/>Increment version]
    Scope -->|No| Roadmap

    ScopeUpdate --> Roadmap{Update<br/>ROADMAP?}
    Roadmap -->|Yes| RoadmapUpdate[Update ROADMAP.md<br/>Increment version]

    RoadmapUpdate --> ReReview[Re-review<br/>Updated Docs]
    Document --> Communicate

    ReReview --> Approved{Approved?}
    Approved -->|No| Update
    Approved -->|Yes| Communicate[Communicate Changes]

    Communicate --> Continue([Continue<br/>Development])

    style Session fill:#FFE6CC
    style Update fill:#FFB6C1
    style Continue fill:#90EE90
```

### Checkpoint Review Example

#### Trigger: High RFC Rate

```mermaid
graph TD
    Phase1[Phase 1:<br/>8 features planned] --> Impl[Implementation<br/>Starts]
    Impl --> RFC1[Feature 1:<br/>2 RFCs filed]
    RFC1 --> RFC2[Feature 2:<br/>1 RFC filed]
    RFC2 --> RFC3[Feature 3:<br/>3 RFCs filed]
    RFC3 --> RFC4[Feature 4:<br/>2 RFCs filed]

    RFC4 --> Calculate[4 features,<br/>8 RFCs = 2 per feature]
    Calculate --> HighRate{RFC Rate<br/>>50%?}

    HighRate -->|Yes: 200%| Trigger[⚠️ Checkpoint Review]

    Trigger --> Analyze[Analyze Pattern:<br/>Why so many RFCs?]
    Analyze --> Finding[Finding:<br/>All RFCs about<br/>database schema]
    Finding --> Decision[Decision:<br/>Add database design<br/>to ROADMAP Phase 0]
    Decision --> UpdateRoadmap[Update ROADMAP.md:<br/>Add Phase 0 prep work]
    UpdateRoadmap --> Future[Future features:<br/>Fewer RFCs]

    style HighRate fill:#FFE6CC
    style Trigger fill:#FFB6C1
    style UpdateRoadmap fill:#90EE90
```

### Checkpoint Review Outcomes

```mermaid
graph LR
    Checkpoint[Checkpoint<br/>Review]

    Checkpoint --> Vision[Update VISION.md<br/>v1.0 → v2.0]
    Checkpoint --> Scope[Update SCOPE.md<br/>v1.0 → v2.0]
    Checkpoint --> Roadmap[Update ROADMAP.md<br/>v1.0 → v2.0]
    Checkpoint --> NoChange[No Changes<br/>Document reasoning]

    Vision --> Example1[Example:<br/>Pivot target users<br/>based on feedback]
    Scope --> Example2[Example:<br/>Defer features<br/>too complex]
    Roadmap --> Example3[Example:<br/>Resequence phases<br/>based on learnings]
    NoChange --> Example4[Example:<br/>High RFC rate but<br/>no pattern found]

    style Checkpoint fill:#FFE6CC
    style Vision fill:#E6F3FF
    style Scope fill:#E6F3FF
    style Roadmap fill:#E6F3FF
```

---

## Feedback Loop Integration

### Normal Flow (No Feedback)

```mermaid
graph LR
    V[VISION] --> S[SCOPE]
    S --> R[ROADMAP]
    R --> Spec1[Spec 1]
    R --> Spec2[Spec 2]
    R --> Spec3[Spec 3]
    Spec1 --> I1[Impl 1]
    Spec2 --> I2[Impl 2]
    Spec3 --> I3[Impl 3]

    style V fill:#E6F3FF
    style S fill:#E6F3FF
    style R fill:#E6F3FF
```

**Clean cascade:** Each stage flows to next without changes.

### With Tactical Feedback (RFCs)

```mermaid
graph LR
    V[VISION] --> S[SCOPE]
    S --> R[ROADMAP]
    R --> Spec1[Spec 1]
    Spec1 --> I1[Impl 1]
    I1 -.RFC.-> Spec1
    Spec1 --> Updated1[Spec 1<br/>Updated]
    Updated1 --> I1

    R --> Spec2[Spec 2]
    Spec2 --> Skel2[Skeleton 2]
    Skel2 -.RFC.-> Spec2
    Spec2 --> Updated2[Spec 2<br/>Updated]
    Updated2 --> Skel2

    style V fill:#E6F3FF
    style S fill:#E6F3FF
    style R fill:#E6F3FF
```

**Tactical adjustments:** Individual specs updated during implementation.

### With Strategic Feedback (Checkpoint Review)

```mermaid
graph LR
    V1[VISION<br/>v1.0] --> S1[SCOPE<br/>v1.0]
    S1 --> R1[ROADMAP<br/>v1.0]
    R1 --> Phase1[Phase 1<br/>Implementation]

    Phase1 -.Learnings.-> CR[Checkpoint<br/>Review]
    CR --> V2[VISION<br/>v2.0]
    CR --> S2[SCOPE<br/>v2.0]
    CR --> R2[ROADMAP<br/>v2.0]

    R2 --> Phase2[Phase 2<br/>Implementation]

    style CR fill:#FFE6CC
    style V2 fill:#90EE90
    style S2 fill:#90EE90
    style R2 fill:#90EE90
```

**Strategic pivots:** Planning documents updated between phases.

---

## Comparison: RFC vs Checkpoint Review

| Aspect | RFC (Tactical) | Checkpoint Review (Strategic) |
|--------|----------------|-------------------------------|
| **Scope** | Single artifact (one spec, one test) | Multiple planning documents |
| **Frequency** | As needed during implementation | Between phases or when triggered |
| **Who Triggers** | Any writer/implementer | Platform Lead |
| **Who Decides** | Original artifact author | Review session with stakeholders |
| **Changes** | Targeted updates to one artifact | Broad updates to VISION/SCOPE/ROADMAP |
| **Evidence** | Specific blocker or issue | Pattern of issues, phase completion, assumption invalidation |
| **Process** | Lightweight: File RFC → Author decides → Continue | Heavyweight: Gather findings → Session → Update → Re-review |
| **Example** | "Spec missing function signature for login()" | "Phase 1 revealed users want mobile-first, not desktop-first" |
| **Version Change** | No version change to artifact | Major version increment (v1.0 → v2.0) |

---

## When to Use Which Feedback Mechanism

### Use RFC When:

✓ Specific artifact has issue blocking current work
✓ Issue is tactical (missing detail, unclear requirement)
✓ Scope limited to one artifact
✓ Quick decision needed to unblock
✓ Original author can decide independently

**Example:** "SPEC.md doesn't define return type for validate_email() function"

### Use Checkpoint Review When:

✓ Multiple artifacts affected
✓ Pattern of issues across features (high RFC rate)
✓ Phase completed, learnings need incorporation
✓ Core assumption invalidated
✓ Strategic direction needs adjustment

**Example:** "Phase 1 revealed 80% of RFCs about database design - we need database design phase before features"

### Don't Use Feedback When:

❌ Normal clarification question (just ask)
❌ Implementation detail not in spec (implement using best judgment)
❌ Preference or style issue (follow GUIDELINES.md)
❌ Small typo or formatting (just fix it)

**Example:** "Should I use snake_case or camelCase?" → Check GUIDELINES.md, don't file RFC

---

## Anti-Patterns

### ❌ Anti-Pattern 1: RFC for Everything

**Problem:** Filing RFCs for trivial issues or normal questions

```mermaid
graph TD
    W[Writer] --> Q1[Question:<br/>Should function<br/>return None or []?]
    Q1 -.❌.-> RFC1[File RFC]
    Q1 -.✓.-> Check[Check GUIDELINES.md]

    W --> Q2[Question:<br/>SPEC unclear<br/>on error handling]
    Q2 -.✓.-> RFC2[File RFC]

    style RFC1 fill:#FFB6C1
    style RFC2 fill:#90EE90
```

**Fix:** Only file RFC when actually blocked or spec fundamentally unclear.

### ❌ Anti-Pattern 2: Checkpoint Review Without Evidence

**Problem:** Calling Checkpoint Review based on feeling, not data

```
❌ "I think we should change the roadmap because..."
✓ "4 of 5 features required RFCs changing the data model, indicating..."
```

**Fix:** Gather concrete evidence (RFC rate, phase completion data, specific assumption invalidations).

### ❌ Anti-Pattern 3: Updating Docs Without Review

**Problem:** Changing planning docs directly without formal review

```mermaid
graph TD
    Writer[Writer] -.❌.-> DirectEdit[Directly edit<br/>ROADMAP.md]
    Writer -.✓.-> RFC[File RFC] --> Review[Formal Review]
    Writer -.✓.-> Checkpoint[Trigger Checkpoint<br/>Review] --> Session[Review Session]

    style DirectEdit fill:#FFB6C1
    style RFC fill:#90EE90
    style Checkpoint fill:#90EE90
```

**Fix:** Always use formal process (RFC or Checkpoint Review) for planning document changes.

---

## Navigation

- **[FeedbackLoops.md](FeedbackLoops.md)** - Detailed Checkpoint Review process
- **[RFC.md](RFC.md)** - Detailed RFC process with templates
- **[Workflow Overview](workflow-overview.md)** - Main workflow diagrams
- **[State Transitions](state-transitions.md)** - Directory movements and ownership
