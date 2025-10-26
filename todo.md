# Workflow Meta-Project TODO

* Properly write 6 minimal schemas to comprehensive format:
  Priority 1 (most referenced):
  - schema-review.md (gates all workflow stages)
  - schema-guidelines.md (consumed by all code-writing roles)
  - schema-system-map.md (architectural reference for all roles)
  Priority 2 (code artifacts):
  - schema-implementation-code.md
  - schema-interface-skeleton-code.md
  - schema-test-code.md
  Target: Match depth of vision/scope/roadmap/spec/bug-report schemas (500-1100 lines)
  Include for each: purpose, structure, quality standards, examples, anti-patterns, downstream usage

* Flesh out stub documentation files:
  - ConcreteProjectSetup.md ✓ DONE
    Completed: Setup guide for fork/copy options and basic usage
    Note: Simplified from original vision - focuses on setup, not full tutorial
  - Ontology.md
    Currently: Just list of schema files
    Add: Introduction explaining artifact types, relationships between docs, reading order, purpose
  - RoleCatalog.md
    Currently: Just list of role files
    Add: Title, intro explaining layered structure, role interaction patterns, when to use which role
  - ContributingTemplate.md (renamed from ConcreteWorkflow.md) ✓ DONE
    Serves as template CONTRIBUTING.md for concrete projects
  - Workflow walkthrough example (NEW - different from ContributingTemplate.md)
    Needed: Complete worked example of full workflow execution from Vision to merged implementation
    Include: Concrete artifacts at each stage, exact commands, decision points
    Location: Could be new doc like WorkflowExample.md or expanded section in Workflow.md

* Enhance REFACTOR documentation in role-implementer.md
  REFACTOR step exists (lines 94-100) but could be more detailed
  Add: Refactoring checklist, when to refactor, when to skip
  Add: Refactoring patterns and anti-patterns
  Add: How to validate refactoring doesn't break tests

* Document feedback loop: Implementation → Planning
  Add "Checkpoint Review" process to workflow documentation
  Triggers: After Phase 1 complete, >50% features need spec changes, core assumption invalidated
  Process: Platform Lead identifies need, assemble findings, update Vision/Scope/Roadmap with version bump

* Spell out procedure when implementer requests test changes
  Tests are contract, but what if tests are wrong?
  Who approves test modifications?
  How to validate proposed changes don't weaken contract?

* Spell out how to update spec if issues discovered during:
  - Skeleton writing (structural problems)
  - Test writing (missing acceptance criteria)
  - Implementation (behavioral ambiguities)
  Process: Who can request changes? Who approves? Does spec need re-review?

* Design and document a formal "Request for Change" (RFC) process:
  Create a lightweight, artifact-driven process for amending approved
  artifacts (like specs or tests) when downstream discoveries necessitate changes.

* Add test coverage requirements to role-test-reviewer.md
  Coverage thresholds: >80% line, >70% branch
  Verification commands
  Edge case completeness checklist
  Exception coverage requirements

* Strengthen bug fix sentinel test verification
  Add to Implementation Reviewer checklist:
  - Verify sentinel test FAILS on old code
  - Verify sentinel test PASSES on new code
  - Test is specific to bug (not generic)
  Include verification commands

* Should we have schema for review requests?
  Currently: Reviews have schema, but not review requests
  Would formalize what reviewers need to do their job

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

* Clarify milestone-to-phase mapping
  Vision has milestones (6mo/1yr/3yr)
  Roadmap has phases and weeks
  Add guidance: How do phases map to milestones? What if they don't fit?

* When do we flesh out roadmap items that were sketched?
  Just-in-time planning: When do Phase 2 features get detailed?
  Before Phase 1 done? During Phase 1? Only when starting Phase 2?

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

* Create simple status script to infer project state from filesystem
  Workflow captures state via directory structure
  Simple script can show: What's proposed/todo/doing/done, what's next, what's blocked
  Example: ./bin/workflow-status.sh
  Output:
    VISION: APPROVED (v1.0)
    SCOPE: APPROVED (v1.0)
    ROADMAP: APPROVED (v1.0)
    SPECS: 3 proposed, 2 todo, 1 doing, 5 done
    CURRENT: Implementing "User Authentication" (specs/doing/user-auth.md)
    NEXT: 2 specs in todo/ ready to start
  This is a quick win that dramatically improves workflow visibility

* Create "bootstrap" script for new projects (quick win after ConcreteProjectSetup.md done):
  Tool to auto-create directory structure and stub artifacts
  Example: ./bin/workflow-init.sh <project-name>
  Creates:
    - Directory structure (specs/, bugs/, reviews/, tests/, src/)
    - Stub VISION.md, SCOPE.md, ROADMAP.md with templates
    - Empty SYSTEM_MAP.md, GUIDELINES.md
    - README pointing to workflow docs
    - .gitignore with appropriate entries
  Dramatically lowers barrier to adoption
  Can start simple (mkdir + template copy) and enhance later
