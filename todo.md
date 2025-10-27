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

* ✓ COMPLETE: Subdirectories of /reviews and /review-requests aligned with schema and role files

  Fixed alignment issues between directory layouts and schemas:
  - Added review-requests/ directory tree to LayoutAndState.md and ConcreteProjectSetup.md
  - Added archived/ subdirectory for completed review requests
  - Fixed trailing slash inconsistency (bug-fixes → bug-fixes/)
  - Added explanatory comments distinguishing review-requests/ (inputs) vs reviews/ (outputs)
  - Updated "Recording State" section to mention review-requests/

  Verified alignment:
  - All 8 review subdirectories consistent: vision/, scope/, roadmap/, specs/,
    skeletons/, tests/, implementations/, bug-fixes/
  - Matches schema-review-request.md and schema-review.md
  - Matches all 7 reviewer role files (bug-fix reviews use implementation-reviewer)

* ✓ RESOLVED: Test directory structure (unit/integration/regression)

  Evaluated alternative (contract/sentinel) but decided to keep current structure.
  Rationale: Performance-based organization (unit=fast, integration=slow) provides
  clear value for developers and CI/CD pipelines. Industry-standard terminology
  reduces onboarding friction. Source artifact can be documented in file headers.

* ✓ COMPLETE: State transition consistency audit across all documentation

  Audited state transitions across LayoutAndState.md, Workflow.md ownership matrix,
  and all individual role files. Fixed inconsistencies found:

  **Workflow.md ownership matrix updates:**
  - Added bug lifecycle: to_fix/ → fixing/ → fixed/ with ownership
  - Expanded review entries to show review-requests/ and archived/ lifecycle
  - Added explicit gatekeeper markers for bug transitions

  **LayoutAndState.md updates:**
  - Added explicit Spec State Transitions section (6 transitions)
  - Added explicit Bug State Transitions section (3 transitions)
  - Added Review Lifecycle section (3 actions)
  - Added State Transition Summary table for quick reference

  **Verification:**
  - ✓ Spec transitions consistent: Spec Writer → Spec Reviewer → Skeleton Writer → Implementation Reviewer
  - ✓ Bug transitions consistent: Bug Recorder → Implementer → Implementation Reviewer
  - ✓ Review lifecycle consistent: Writers create requests → Reviewers create reviews → Reviewers archive
  - ✓ All gatekeeper roles clearly identified (Spec Reviewer, Implementation Reviewer)
  - ✓ Branching strategy aligned (feature branch created by Skeleton Writer)
  - ✓ All role files match the documented transitions

* ✓ COMPLETE: Redundancy optimization across Workflow/ directory

  Consolidated ~650-700 lines of redundant content across 30+ files:

  **Phase 1: Critical Bug Fix**
  - Fixed bugs/reported/ → bugs/to_fix/ in state-transitions.md (5 instances)
  - Now consistent with rest of project

  **Phase 2: Helper Role Pattern (~400 lines reduction)**
  - Created Workflow/patterns/helper-role-pattern.md (~350 lines)
  - Documents common structure for all helper roles (activation, collaboration,
    conversation philosophy, user adaptation, transitions, exits, integration)
  - Updated 4 helper roles to reference pattern: vision-writing-helper,
    scope-writing-helper, roadmap-writing-helper, spec-writing-helper
  - Each file reduced by ~150-165 lines of boilerplate

  **Phase 3: Workflow Overview Cross-References (~50-100 lines reduction)**
  - Enhanced Workflow.md with link to state-transitions.md after ownership matrix
  - Enhanced LayoutAndState.md with link to state-transitions.md after summary table
  - Enhanced state-transitions.md header establishing it as single source of truth
  - Clear documentation hierarchy with bidirectional references

  **Phase 4: Role File Structure Pattern (~200-250 lines reduction)**
  - Created Workflow/patterns/role-file-structure.md (~300 lines)
  - Documents standard structure for all role files
  - Updated 16 non-helper roles (6 writers, 7 reviewers, 3 implementers)
  - Integration sections simplified from 15-30 lines to 4-7 lines + link
  - Preserved all role-specific content (process, examples, critical reminders)

  **Phase 5: Schema Cross-References (0 line reduction, improved navigation)**
  - Added cross-references in 5 schema files pointing to LayoutAndState.md:
    * schema-spec.md (specs/ directory structure)
    * schema-bug-report.md (bugs/ directory structure)
    * schema-review.md (reviews/ directory structure)
    * schema-review-request.md (review-requests/ directory structure)
    * schema-interface-skeleton-code.md (src/ directory structure)
  - LayoutAndState.md established as canonical source for directory structure

  **Results:**
  - Files modified: 32 (9 in Part 1, 23 in Part 2)
  - Pattern files created: 2 (helper-role-pattern.md, role-file-structure.md)
  - Lines reduced: ~650-700 lines of redundancy eliminated
  - Maintainability: Changes to common patterns now update in one place
  - Consistency: All role files follow standard structure
  - Navigation: Clear documentation hierarchy with cross-references

* ✓ COMPLETE: Role file optimization using validated principles

  Applied 8 optimization principles systematically to 20 role files:

  **Batch A (Reviewers) - 7 files:**
  - 4260 → 3158 lines (-1102, -26%)
  - Heavy reduction due to consolidating duplicate review sections
  - Common pattern: Best Practices + Critical Reminders → single section

  **Batch B (Writers) - 6 files:**
  - 3329 → 3227 lines (-102, -3.1%)
  - Already lean with straightforward process sections
  - Smaller reduction reflects less duplication

  **Batch C (Helpers) - 4 files:**
  - 2056 → 2025 lines (-31, -1.5%)
  - Already optimized with helper-role-pattern.md references
  - Minimal reduction expected and achieved

  **Batch D (Implementation) - 3 files:**
  - 2250 → 2180 lines (-70, -3.1%)
  - role-implementer.md (1137→1119, -1.6%): Extensive refactoring guidance preserved
  - role-platform-lead.md (674→659, -2.2%): Removed redundant Critical Reminders
  - role-bug-recorder.md (439→402, -8.4%): Removed duplicate Integration section

  **Total Results:**
  - 20 files optimized: 11895 → 10590 lines (-1305, -11.0%)
  - Zero information loss (all essential procedural knowledge preserved)
  - All examples fully preserved (most valuable learning signal)
  - Enhanced frontmatter added (dependencies, outputs, gatekeeper flags)

  **8 Validated Principles:**
  1. Enhanced frontmatter (dependencies, outputs, gatekeeper, state_transition)
  2. Imperative form ("Create..." not "Your job is to create...")
  3. Preserve essential procedural context (Collaboration Pattern sections)
  4. Consolidate duplicate guidance (merge overlapping sections)
  5. Aggressive schema reference (link instead of inline duplication)
  6. Better terminology ("Common Issues" not "Common Pitfalls")
  7. Keep all examples (most valuable learning signal)
  8. Target lean but complete (no arbitrary percentage targets)

  Documentation: Workflow/patterns/role-optimization-pattern.md (~390 lines)

* ✓ COMPLETE: Schema optimization with relationship map

  Applied optimization principles to 12 schema files (13,007 lines total):

  **Created:**
  - `Workflow/patterns/schema-relationship-map.md` (269 lines)
  - Central map of all schema relationships
  - Workflow flow visualization
  - Dependency levels documentation

  **Optimization Results:**
  - Batch A (Planning): vision, scope, roadmap → 2668→2670 lines (+2, +0.07%)
  - Batch B (Spec & Review): spec, review, review-request → 3515→3514 lines (-1, -0.03%)
  - Batch C (Code Artifacts): skeleton, test, implementation → No relationship sections (0 change)
  - Batch D (Living Docs): guidelines, system-map, bug-report → 3573→3574 lines (+1, +0.03%)
  - **Total schemas:** 13,007 → 13,009 lines (+2, +0.02%)
  - **Plus relationship map:** +269 lines
  - **Net change:** +271 lines (+2.1%)

  **Key Findings:**
  1. Schemas are structural templates, not procedural guides
  2. "Related Ontologies" sections already concise (3-6 lines each)
  3. Anti-patterns are schema-specific, not duplicative
  4. Value is qualitative: central navigation map + maintainability
  5. Different optimization profile than roles (which had 11% reduction)

  **Lessons Learned:**
  - Anti-patterns appeared similar ("vague", "stale") but were contextual to each schema
  - Replacing 3-6 line sections with 4-5 line standard format = minimal line savings
  - Central relationship map (269 lines) improves navigation despite adding lines
  - Schema optimization focus: navigation and consistency > line reduction

* ✓ COMPLETE: Documentation improvements (checklists + trigger pattern)

  **Created checklists (3 files, ~200 lines each):**
  - `Workflow/checklists/checklist-SPEC.md` - Spec creation verification
  - `Workflow/checklists/checklist-REVIEW.md` - Review quality verification
  - `Workflow/checklists/checklist-ROADMAP.md` - Roadmap completeness verification

  **Created linking strategy pattern (~600 lines):**
  - `Workflow/patterns/documentation-linking-strategy.md`
  - Defines when/how to create links with clear triggers
  - 5 successful trigger patterns (need-based, authority, scope-expansion, action, conditional)
  - 3 failed patterns to avoid (forward-refs, lateral alternatives, optional enrichment)
  - Decision framework and maintenance guidelines

  **Key insight:** Links without clear triggers create cognitive overhead
  - Readers (human/AI) must know WHEN to follow link
  - Successful triggers answer: "Under what circumstance should I follow this link?"
  - Inline examples work better than external when trigger is ambiguous

* IN PROGRESS: Apply trigger improvements across documentation

  **Identified 7 categories of improvements (~54 files):**

  1. **Related Schemas sections** (7 schemas) - Replace informational with action-based
  2. **Helper pattern references** (4 roles) - Add conditional triggers
  3. **External example references** (3 schemas) - Clarify location and when to consult
  4. **Workflow context references** (~20 roles) - Replace vague with need-based
  5. **Checklist integration** (~10 files) - Reference new checklists with clear triggers
  6. **Schema-to-role cross-refs** (6 roles) - Strengthen action context
  7. **Pattern file headers** (4 patterns) - Add "when to use" triggers

  **Plan:** Systematic improvement in fresh context with full trigger pattern as guide

  **Reference:** See `Workflow/patterns/documentation-linking-strategy.md` for trigger patterns

* Document living-docs strategies for parallel feature branches:
  Conflict mitigation patterns, sequencing guidance, and PR coordination

* ✓ COMPLETE: Workflow diagram enhancement (hybrid approach)

  Created three complementary diagram files:
  1. workflow-overview.md - Simple Mermaid diagrams showing main workflow path,
     parallel workflows (bugs, feedback), role patterns, and quick reference tables
  2. state-transitions.md - Detailed tables showing directory movements, ownership
     matrix, state machines, and who-moves-what for all artifact types
  3. feedback-loops-diagram.md - Mermaid diagrams for RFC and Checkpoint Review
     processes, triggers, comparisons, and integration with main workflow

  Kept existing workflow-diagram.svg as comprehensive reference (not actively maintained).
  Hybrid approach: text-based for maintainability, visual for clarity.

* ✓ RESOLVED: Onboarding guide for new contributors

  Existing files provide sufficient onboarding coverage:
  - WorkflowExample.md - Complete scenario walkthrough (vision → first feature)
  - ConcreteProjectSetup.md - How to set up a new project with workflow
  - ContributingTemplate.md - Template for project CONTRIBUTING.md
  - workflow-overview.md - High-level overview with diagrams and quick reference

  Together these explain how to start, find key docs, and follow core principles.

* ✓ COMPLETE: Role orchestration scripts (commits 7d269be, 47516ef)

  Created Workflow/scripts/ with two key scripts:

  1. run-role.sh - Launch any role with proper initialization
     - Config-driven role → tool/model mapping (role-config.json, tool-config.json)
     - Interactive (-i flag) or one-shot mode for any role
     - Auto-initialization for all tools (no copy-paste):
       * Claude: --append-system-prompt to inject role
       * Codex: Positional argument preserves TTY for interactive mode
       * Gemini: -i/--prompt-interactive flag
       * OpenCode: -p/--prompt flag
     - Proper entry point routing (CLAUDE.md, AGENTS.md, GEMINI.md)
     - ~270 lines

  2. workflow-status.sh - Scan project state and suggest next actions
     - Checks planning docs, specs (proposed/todo/doing/done), bugs, implementation progress
     - Detects skeleton code, tests, review status, implementation completeness
     - Color-coded status indicators (✓ ✗ ⊙ →)
     - Prioritized suggestions with exact commands to run
     - --verbose flag for detailed output
     - ~390 lines

  Total: ~660 lines of workflow automation

* ✓ RESOLVED: Auto-trigger reviews decision

  Discussed and decided NOT to pursue automatic review triggering. Rationale:
  - Manual orchestration with good scripts provides sufficient efficiency (~12 min per feature)
  - Human oversight prevents "test modification" problem (ImpossibleBench concern)
  - workflow-status.sh scanner provides "what's next?" guidance without automation complexity
  - MCP integration would add significant complexity for uncertain benefit
  - Can revisit if real pain points emerge after using manual approach

