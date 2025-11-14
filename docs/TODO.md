# Active TODO Items

## High Priority

### State Transition and Workflow Issues

* **Feature branch creation timing**: Seems to be in the wrong place and/or not happening consistently
  - Need to verify when skeleton-writer creates the branch
  - Ensure it happens before implementation work starts

* **State transition discipline**: Observed work starting on implementing a spec without moving it from `todo/` to `doing/` first
  - Add checks in workflow-status.sh to detect this?
  - Email notifications when state transitions are skipped? (relates to PLAN.md)

* **Merge timing verification**: Need to recheck when merges happen
  - When does feature branch merge to main?
  - Who performs the merge?
  - State transitions on merge?

### Documentation and Schema Enhancements

* **Vision/scope enhancements**: Vision roles and/or schema should focus on:
  - Timeline and milestones
  - Tech stack decisions
  - Developer time available
  - Scope that should be deferred to later phases

* **Prompts/context in workflow**: Need to figure out how to incorporate prompts/prompt templates/context into the workflow
  - How to test prompts? (Evals/LLM Judge)
  - How to review prompts?
  - Document the TDD pattern discovered (see below)

## Medium Priority

* **Timestamp resolution in file names**: Need higher resolution timestamps (likely milliseconds)
  - This got dropped somehow - did it come back?
  - Note from GPT-5: may not have access to system clock

* **Version history cleanup**: There is still version history to remove from somewhere
  - Need to specify where this is

## Discovered Patterns to Document

### TDD for Non-Code Artifacts (Prompts/Templates)

Had a spec whose implementation was all prompts/prompt templates/context (not Python code). We discovered this TDD approach works:

**Skeleton Phase:**
- Create outline of prompt document structure
- Headers, sections, subsections with placeholders
- Each section marked: "This section needs to be written."

**Test Phase:**
- Tests become evals using LLM Judge
- Tell model how to "fail" when info is missing
- Define success criteria for each prompt section

**Implementation Phase:**
- Make tests pass by writing actual prompt content
- Iterative refinement based on eval results

**Action:** Document this pattern in:
- New schema: `schema-prompt-artifact.md`? or
- New section in existing schemas (implementation, test)?
- Update relevant role files (skeleton-writer, test-writer, implementer)

## Related Work

See `docs/PLAN.md` for email communication integration plan, which addresses some workflow handoff issues.

---

**Last Updated**: 2025-11-14
**Source**: Extracted from original todo.md during documentation reorganization
