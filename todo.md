# Workflow Meta-Project TODO

* ✓ COMPLETE: Expand minimal schemas to comprehensive format (commits 5c0aa0a, fd962cb)

  Priority 1 (most referenced):
    - schema-review.md: 27 → 1175 lines ✓
    - schema-guidelines.md: 24 → 1625 lines ✓
    - schema-system-map.md: 21 → 1460 lines ✓
    Subtotal: 4260 lines

  Priority 2 (code artifacts):
    - schema-interface-skeleton-code.md: 23 → 1173 lines ✓
    - schema-test-code.md: 27 → 1050 lines ✓
    - schema-implementation-code.md: 20 → 1029 lines ✓
    Subtotal: 3252 lines

  Grand total: 7512 lines of comprehensive schema documentation


* ✓ COMPLETE: Feedback loops and change management (commit 620d54e)

  1. FeedbackLoops.md - Strategic feedback (Checkpoint Review)
     - Triggers: phase completion, >50% RFC rate, core assumption invalid
     - Process: assemble findings, review session, update VISION/SCOPE/ROADMAP
     - Version bumping, re-review, communication

  2. RFC.md - Tactical feedback (Request for Change)
     - Spec changes (discovered during skeleton/test/implementation)
     - Test changes (implementer requests - extra scrutiny)
     - Skeleton changes (discovered during test writing)
     - RFC template, decision criteria, anti-patterns
     - Created rfcs/open/, rfcs/approved/, rfcs/rejected/ directories


* ✓ COMPLETE: Clarifications for strategic planning (commit 81300f5)

  1. Milestone-to-phase mapping guidance (role-roadmap-writer.md)
     - 4 options when milestones don't align (negotiate, reduce scope, accept mismatch, interim checkpoints)
     - Red flags requiring adjustment, reality check questions

  2. Just-in-time planning guidance (role-roadmap-writer.md)
     - Phase 1: high detail upfront, Phase 2: medium detail initially
     - Detail Phase 2 during late Phase 1 (~60-80% done)
     - Checkpoint Review triggers replanning between phases
     - Example showing roadmap evolution based on learnings


* ✓ COMPLETE: Quality assurance enhancements (commit 6cdda3b)

  1. Test coverage requirements (role-test-reviewer.md)
     - Coverage thresholds: >80% line, >70% branch
     - Verification commands for Python (pytest-cov) and TypeScript (Jest)
     - Edge case completeness checklists by data type
     - Exception coverage verification pattern
     - ~260 lines added

  2. Sentinel test verification (role-implementation-reviewer.md)
     - Git-based verification (test FAILS on old code, PASSES on new code)
     - Complete bash command sequences
     - Automated verification script
     - Good vs bad examples
     - 5 common issues with fixes
     - ~290 lines added


* ✓ COMPLETE: Review request schema (commit 426b8d8)

  Created schema-review-request.md (~1324 lines):
  - Document structure and naming conventions
  - Required context sections (related docs, dependencies, key decisions)
  - Templates for all 8 review types (vision, scope, roadmap, spec, skeleton, test, implementation, bug-fix)
  - Best practices with good/bad examples
  - Anti-patterns (drive-by requests, everything urgent, scope creep, no-show reviewer, passive-aggressive)
  - Integration with review lifecycle and directory structure

* Are subdirectories of /reviews aligned with schema and role files?
  Check: vision/, scope/, roadmap/, specs/, skeletons/, tests/, implementations/
  vs role files and workflow stages

* Is the unit/integration/regression test directory division best?
  Alternative: contract/ (acceptance criteria tests) and sentinel/ (regression tests)
  Evaluate: Does current structure match how tests are actually written/used?

* Is who moves what and when consistent across all role files?
  Audit: Ensure state transitions match between:
  - LayoutAndState.md
  - Workflow.md ownership matrix
  - Individual role files

* Is there redundancy? Can we make this more concise?
  General optimization pass
  Look for duplicated information across files
  Opportunities to simplify without losing value

* Document living-docs strategies for parallel feature branches:
  Conflict mitigation patterns, sequencing guidance, and PR coordination

* Enhance existing graphical workflow diagram (workflow-diagram.svg exists):
  Current: Basic happy path flowchart
  Add: More detailed roles, artifacts, state transitions, and feedback loops
  Add: Legend explaining symbols and conventions
  Consider: Separate diagrams for different workflow phases

* Define an "Onboarding" guide for new contributors:
  Practical companion to abstract schemas/roles, explaining how to start,
  find key docs, and follow core principles

* How do we orchestrate handoffs between roles?
  Currently: Manual - user switches CLI tools
  Options: Scripts? Workflow automation? Git hooks?
  Document current approach and future automation plans

* Should writers/implementers call reviewers automatically?
  I have an MCP server example from previous project (Claude → Codex reviews)
  Expand to: Auto-trigger reviews when work complete?
  Referenced conversation with Claude chat - review and possibly incorporate

