---
name: roadmap-reviewer
description: Review ROADMAP.md for completeness, sequencing logic, and alignment with SCOPE.md. Validates roadmap documents against ROADMAP-ontology.md before proceeding to specification. Use after roadmap-planner produces draft ROADMAP.md.
---

# Roadmap Reviewer

Review roadmap documents to ensure they're complete, logical, and ready for spec writing.

## When to Use

**Use when:**
- ROADMAP.md drafted and needs validation
- Before proceeding to spec-writer

**Prerequisites:**
- VISION.md exists and approved
- SCOPE.md exists and approved
- Draft ROADMAP.md exists

**Produces:** Review decision (APPROVED / NEEDS-CHANGES) with specific feedback

## Review Principles

### 1. Ontology Compliance
- All required sections present (10 sections)
- Feature entries complete (all 6 fields)
- Phase structure correct

### 2. Completeness
- All features from SCOPE.md included
- Feature entries have all 6 fields
- Dependencies mapped
- Validation checkpoints present

### 3. Sequencing Logic
- Dependencies respected (no circular)
- Derisking strategy clear
- Value delivery incremental
- Phases build on each other

### 4. Alignment
- Vision statement matches VISION.md
- Scope summary matches SCOPE.md
- All SCOPE features accounted for
- No out-of-scope features

### 5. Feasibility
- Phase sizes reasonable (3-7 features)
- Effort estimates present
- Dependencies achievable
- Timeline realistic

## Review Workflow

### Step 1: Load References
- Read ROADMAP-ontology.md (structure reference)
- Read SCOPE.md (feature list to verify)
- Read VISION.md (alignment check)

### Step 2: Check Structure

**Required sections (10 total):**
- [ ] 1. Roadmap Overview
- [ ] 2. Alignment
- [ ] 3. Sequencing Strategy
- [ ] 4. Phase 1 (at minimum)
- [ ] 5. Phase 2+ (if multi-phase)
- [ ] 6. Dependencies and Sequencing
- [ ] 7. Assumptions and Risks
- [ ] 8. Flexibility and Change
- [ ] 9. Document Control

### Step 3: Review Feature Entries (CRITICAL)

**Each feature must have ALL 6 fields:**

```markdown
1. **Feature Name**
   - **Description:** ✅ [1-2 sentences what it is]
   - **Why now:** ✅ [Sequencing rationale]
   - **Delivers:** ✅ [User value/learning]
   - **Derisks:** ✅ [Assumptions validated or "None"]
   - **Depends on:** ✅ [Prerequisites or "Nothing"]
   - **Effort:** ✅ [Small/Medium/Large]
```

**This is THE MOST CRITICAL CHECK** - spec-writer needs all 6 fields!

**Common issues:**

```
❌ Missing Description:
1. **User Authentication**
   - **Why now:** Foundation feature
   - **Delivers:** User accounts

✅ Has Description:
1. **User Authentication**
   - **Description:** Email/password login with session management
   - **Why now:** Foundation feature
   - **Delivers:** User accounts
```

**Check each feature:**
- [ ] Description present (1-2 sentences, clear)
- [ ] Why now explains sequencing
- [ ] Delivers states value/learning
- [ ] Derisks identifies assumptions (or "None")
- [ ] Depends on lists prerequisites (or "Nothing")
- [ ] Effort is Small/Medium/Large

**Description quality:**
```
❌ Vague: "API work" or "Backend stuff"
✅ Clear: "REST API endpoints for user CRUD operations"

❌ Too detailed: "Uses Express.js with JWT middleware and PostgreSQL connection pooling..."
✅ Right level: "User authentication API with token-based sessions"
```

### Step 4: Check Phase Structure

**For each phase:**

- [ ] Phase name descriptive
- [ ] Phase goals clear (what phase achieves)
- [ ] 3-7 features (not too few, not too many)
- [ ] Success criteria measurable
- [ ] Learning goals identified
- [ ] Validation checkpoint defined

**Phase goals check:**
```
❌ Vague: "Build core features"
✅ Clear: "Validate that static analysis can reliably detect spec/test/code relationships"
```

**Success criteria check:**
```
❌ Unmeasurable: "Phase 1 complete when done"
✅ Measurable:
- Can detect spec references (>90% accuracy)
- Build relationship graph for 1000-file codebase in <5 seconds
- Links are validated correctly
```

**Validation checkpoint check:**
- [ ] Date specified (end of phase)
- [ ] Review questions listed
- [ ] Decision criteria clear (Continue/Pivot/Stop)

### Step 5: Verify Sequencing Logic

**Check dependency order:**

- [ ] No circular dependencies (A→B→C→A)
- [ ] Foundation features first
- [ ] Features build on predecessors
- [ ] Dependencies explicitly mapped

**Example dependency check:**

If Feature 5 depends on Feature 3:
- ✅ Feature 3 is in earlier phase or same phase before Feature 5
- ❌ Feature 3 is in later phase or after Feature 5

**Check derisking strategy:**

- [ ] High-risk features early (if derisking approach)
- [ ] Critical assumptions validated early
- [ ] Learning dependencies clear

```
✅ Good derisking:
Phase 1: Static analysis (highest risk - validate first)
Phase 2: Spec management (builds on proven Phase 1)

❌ Bad derisking:
Phase 1: UI polish (low risk)
Phase 2: Core algorithm (high risk - too late!)
```

### Step 6: Verify Feature Coverage

**Create checklist:**

From SCOPE.md "In Scope - MVP", list all features:
- [ ] Feature from scope item 1
- [ ] Feature from scope item 2
- [ ] Feature from scope item 3
...

**Then verify:**
- [ ] Every SCOPE.md MVP feature appears in roadmap
- [ ] No features outside SCOPE.md (check exclusions)
- [ ] Future phase features match SCOPE.md future phases

**If features missing:** Critical issue - SCOPE features must be in ROADMAP

**If extra features:** Check if in SCOPE.md "Out of Scope" - if yes, remove from roadmap

### Step 7: Check Dependencies Section

**Required subsections:**
- [ ] Technical Dependencies mapped
- [ ] Learning Dependencies noted
- [ ] External Dependencies flagged

**Technical dependency check:**
```
✅ Good:
- User Dashboard requires User Authentication (must build auth first)
- File Upload requires Storage Configuration (storage must exist)

❌ Missing:
[No technical dependencies listed but features clearly depend on each other]
```

**Learning dependency check:**
```
✅ Good:
- Collaborative Editing depends on validating "Users work in teams" assumption from Phase 1

❌ Missing:
[Phase 2 assumes Phase 1 validated approach but doesn't state this]
```

### Step 8: Verify Alignment

**Vision statement check:**
- [ ] Roadmap includes vision statement
- [ ] Vision statement matches VISION.md exactly (word-for-word)

**Scope summary check:**
- [ ] Roadmap includes scope summary
- [ ] Summary accurately reflects SCOPE.md

**Success criteria check:**
- [ ] Roadmap references VISION.md success criteria
- [ ] Roadmap shows how phases achieve criteria

**If mismatched:**
```
Problem: Vision statement differs from VISION.md
Fix: Copy exact text from VISION.md
```

### Step 9: Check Assumptions and Risks

**Assumptions check:**
- [ ] Key assumptions stated (3-7 items)
- [ ] Assumptions specific (not vague)
- [ ] Critical assumptions identified

**Sequencing risks check:**
- [ ] Risks if sequence wrong noted
- [ ] Impact of failures considered

**Mitigation plans check:**
- [ ] For each major assumption, mitigation stated
- [ ] Pivot strategies clear

```
✅ Good mitigation:
Assumption: Static analysis achieves >85% accuracy
Mitigation: If <85% → Add manual linking support as fallback

❌ Missing mitigation:
Assumption: Static analysis works
[No plan if it doesn't]
```

### Step 10: Check Flexibility Provisions

**Adaptation triggers:**
- [ ] Events that would trigger roadmap change listed
- [ ] Specific, not vague

**Review cadence:**
- [ ] Frequency specified (e.g., "after each phase", "monthly")

**Change process:**
- [ ] Process for updating roadmap defined
- [ ] Version control mentioned

## Review Output Format

```markdown
# Roadmap Review: [Project Name]

**Reviewer:** [Your name/Claude]
**Date:** [YYYY-MM-DD]
**Document:** ROADMAP.md
**Version:** [version if tracked]
**Status:** APPROVED | NEEDS-CHANGES

## Summary
[Overall assessment - sequencing logic, completeness, alignment]

## Ontology Compliance
- ✅/❌ All 10 sections present
- ✅/❌ Feature entries complete (6 fields each)
- ✅/❌ Phase structure correct

## Feature Entry Compliance ⚠️ CRITICAL
- ✅/❌ All features have Description field
- ✅/❌ All features have Why now
- ✅/❌ All features have Delivers
- ✅/❌ All features have Derisks
- ✅/❌ All features have Depends on
- ✅/❌ All features have Effort

**Features missing fields:** [List them]

## Sequencing Logic
- ✅/❌ No circular dependencies
- ✅/❌ Dependencies respected
- ✅/❌ Derisking strategy clear
- ✅/❌ Value delivery incremental

## Feature Coverage
- ✅/❌ All SCOPE MVP features included
- ✅/❌ No out-of-scope features
- ✅/❌ Future phases match SCOPE

**Missing SCOPE features:** [List them]
**Extra features not in SCOPE:** [List them]

## Alignment Check
- ✅/❌ Vision statement matches VISION.md
- ✅/❌ Scope summary matches SCOPE.md
- ✅/❌ Success criteria referenced

## Phase Quality
- ✅/❌ Phase goals clear
- ✅/❌ Phase sizes reasonable (3-7 features)
- ✅/❌ Success criteria measurable
- ✅/❌ Validation checkpoints defined

## Critical Issues (if NEEDS-CHANGES)
1. **[Issue Title]**
   - Location: [Phase X, Feature Y]
   - Problem: [what's wrong]
   - Impact: [blocks spec-writer / unclear sequence / etc]
   - Fix: [specific fix needed]

## Minor Issues
[Non-blocking improvements]

## Decision
[APPROVED - ready for spec-writer]
[NEEDS-CHANGES - address critical issues above]
```

## Common Issues

### Issue 1: Missing Feature Descriptions (CRITICAL)
```
Problem: Features lack Description field
Impact: spec-writer can't understand what to spec
Fix: Add Description to every feature (1-2 sentences)
```

### Issue 2: Circular Dependencies
```
Problem: Feature A depends on B, B depends on C, C depends on A
Impact: Can't sequence implementation
Fix: Break cycle - identify true foundation feature
```

### Issue 3: Missing SCOPE Features
```
Problem: SCOPE lists 10 MVP features, roadmap has 7
Impact: Incomplete product, doesn't match scope commitment
Fix: Add 3 missing features to roadmap phases
```

### Issue 4: Phase Too Large
```
Problem: Phase 1 has 15 features
Impact: Phase too long, no early validation
Fix: Split into Phase 1 (5 features) and Phase 2 (10 features)
```

### Issue 5: No Validation Checkpoints
```
Problem: Phases have no review/decision points
Impact: No opportunity to pivot based on learning
Fix: Add checkpoint at end of each phase with review questions and decision criteria
```

### Issue 6: Vague Feature Descriptions
```
Problem: Description says "API work" or "Backend"
Impact: spec-writer can't create meaningful spec
Fix: "REST API endpoints for user authentication and profile management"
```

### Issue 7: Risky Features Late
```
Problem: Highest-risk feature in Phase 3
Impact: Late failure wastes Phase 1-2 effort
Fix: Move to Phase 1 for early validation (if derisking strategy)
```

## Best Practices

**DO:**
- Check feature entries obsessively (all 6 fields)
- Verify every SCOPE feature appears
- Check dependency logic carefully
- Ensure alignment with VISION/SCOPE
- Approve when quality bar met

**DON'T:**
- Skip Description field check (critical for spec-writer)
- Allow circular dependencies
- Permit missing SCOPE features
- Accept vague descriptions
- Block on minor sequencing preferences

## Integration

**Consumes:**
- ROADMAP.md (draft to review)
- ROADMAP-ontology.md (validation reference)
- SCOPE.md (feature coverage check)
- VISION.md (alignment check)

**Produces:**
- Review document with decision
- Specific feedback for roadmap-planner

**Workflow Position:**
```
scope-writer → SCOPE.md ✓
  ↓
scope-reviewer → Review SCOPE ✓
  ↓
roadmap-planner → ROADMAP.md (draft)
  ↓
roadmap-reviewer → Review ROADMAP ⬅ YOU ARE HERE
  ↓ (if APPROVED)
spec-writer → SPEC.md
```

## Critical Reminders

- **Feature Description field is CRITICAL** - spec-writer needs it!
- Check all 6 fields in every feature entry
- Verify every SCOPE feature appears in roadmap
- Check dependency logic (no circular)
- Ensure validation checkpoints exist

**Most critical:** Missing Description field breaks the workflow - spec-writer can't function without it!

## Related Skills

- **roadmap-planner**: Produces ROADMAP.md to review
- **spec-writer**: Consumes approved roadmap (needs Description field!)
- **ROADMAP-ontology.md**: Validation reference
- **SCOPE.md**: Feature coverage reference
