---
name: scope-reviewer
description: Review SCOPE.md for completeness, clarity, and alignment with VISION.md. Validates scope documents against SCOPE-ontology.md before proceeding to roadmap planning. Use after scope-writer produces draft SCOPE.md.
---

# Scope Reviewer

Review scope documents to ensure they're complete, clear, and ready for roadmap planning.

## When to Use

**Use when:**
- SCOPE.md drafted and needs validation
- Before proceeding to roadmap-planner

**Prerequisites:**
- VISION.md exists and approved
- Draft SCOPE.md exists

**Produces:** Review decision (APPROVED / NEEDS-CHANGES) with specific feedback

## Review Principles

### 1. Ontology Compliance
- All required sections present (8 sections)
- Sections in correct order
- Fields have correct format

### 2. Completeness
- MVP features specified concretely
- Out of scope items identified
- Success criteria measurable
- Constraints documented

### 3. Clarity
- Features specific (not vague)
- Examples provided
- Technical terms defined
- No ambiguous language

### 4. Alignment
- Serves VISION.md purpose
- Success criteria match vision metrics
- No contradictions with vision

### 5. Feasibility
- MVP scope achievable
- Timeline realistic
- Constraints acknowledged

## Review Workflow

### Step 1: Load References
- Read SCOPE-ontology.md (structure reference)
- Read VISION.md (alignment check)

### Step 2: Check Structure

**Required sections (8 total):**
- [ ] 1. Scope Overview
- [ ] 2. In Scope - MVP
- [ ] 3. In Scope - Future Phases
- [ ] 4. Explicitly Out of Scope
- [ ] 5. Success Criteria
- [ ] 6. Constraints
- [ ] 7. Assumptions
- [ ] 8. Document Control

**Section ordering:**
- [ ] Sections in correct order (as listed above)

### Step 3: Review "In Scope - MVP"

**Check feature specificity:**

```
❌ Bad (vague):
- User management
- Backend APIs
- Frontend stuff

✅ Good (specific):
- User registration via email/password
- Basic profile editing (name, avatar, bio)
- Create/edit/delete notes with markdown support
```

**Checklist:**
- [ ] 5-15 features listed (not too few, not too many)
- [ ] Each feature is concrete and specific
- [ ] Features are user-facing or technical requirements
- [ ] No implementation details (behaviors not technologies)
- [ ] Can visualize what to build from descriptions

**Common issues:**
```
Issue: "Authentication system"
Fix: "User login/logout via email and password with session management"

Issue: "Database"
Fix: "Persistent storage for user data and notes"

Issue: "APIs"
Fix: "REST API for user CRUD and note operations"
```

### Step 4: Review "In Scope - Future Phases"

**Check phasing clarity:**

```
❌ Bad:
- Phase 2: More features
- Phase 3: Advanced stuff

✅ Good:
Phase 2 (Post-MVP):
- Real-time collaboration on notes
- Rich text editor with formatting toolbar
- File attachments (images, PDFs)

Phase 3 (Growth):
- Team workspaces
- Permission management
- Activity feeds
```

**Checklist:**
- [ ] Phases clearly labeled
- [ ] Features specific (same standard as MVP)
- [ ] Logical progression from MVP
- [ ] Reasonable scope per phase

### Step 5: Review "Explicitly Out of Scope"

**Check exclusion clarity:**

```
❌ Bad:
- Mobile apps
- Advanced features
- Integrations

✅ Good:
- Native mobile apps (web-only for MVP, native apps in Year 2)
- OAuth/SSO authentication (email/password only for MVP)
- Third-party integrations (Slack, Google Drive - Phase 3)
- Offline mode (online-only for MVP)
```

**Checklist:**
- [ ] 5-10 items explicitly excluded
- [ ] Each item explains WHY excluded or WHEN deferred
- [ ] Covers common scope creep areas
- [ ] Distinguishes "never" from "later"

**Purpose:** Prevent scope creep and set expectations

### Step 6: Review Success Criteria

**Check measurability:**

```
❌ Bad (unmeasurable):
- System is fast and reliable
- Users are happy
- Product is successful

✅ Good (measurable):
- 100 active users within 6 months
- System uptime >99.5%
- API response time <200ms (p95)
- 60% user retention after 3 months
```

**Checklist:**
- [ ] 3-7 criteria present
- [ ] Each criterion specific and measurable
- [ ] Mix of user and technical metrics
- [ ] Aligned with VISION.md success criteria
- [ ] Timeframes specified

**Verify alignment:**
Compare to VISION.md success criteria - should match or be subset

### Step 7: Review Constraints

**Check constraint completeness:**

**Required constraint categories:**
- [ ] Timeline constraints (deadlines, milestones)
- [ ] Resource constraints (team size, budget)
- [ ] Technical constraints (languages, platforms, compatibility)
- [ ] Business constraints (legal, regulatory, policy)

```
✅ Good example:
**Timeline:**
- MVP launch by June 1, 2025 (investor demo - hard deadline)
- 3-month development window

**Resources:**
- Solo developer (~20 hours/week)
- $100/month infrastructure budget

**Technical:**
- Python backend (developer expertise)
- Web-only (no mobile native)
- Must support modern browsers (Chrome, Firefox, Safari)

**Business:**
- GDPR compliance required (EU users)
- No payment processing in MVP (reduces regulatory burden)
```

**Checklist:**
- [ ] All 4 constraint categories addressed
- [ ] Constraints specific (not vague)
- [ ] Impact explained where relevant
- [ ] Constraints realistic

### Step 8: Review Assumptions

**Check assumption explicitness:**

```
❌ Bad (implicit):
- We can build this
- Users will like it

✅ Good (explicit):
- Solo developer can commit 20 hours/week consistently
- Target users have stable internet (>5 Mbps)
- Markdown is sufficient for note formatting (no WYSIWYG needed)
- Email/password auth is acceptable (users don't require OAuth)
```

**Checklist:**
- [ ] 5-10 assumptions stated
- [ ] Assumptions are testable/verifiable
- [ ] Critical assumptions identified
- [ ] Risks if assumptions wrong considered

### Step 9: Verify Alignment with Vision

**Check consistency:**
- [ ] Scope serves vision purpose
- [ ] Success criteria match or subset vision metrics
- [ ] Target users consistent
- [ ] Timeline consistent
- [ ] No contradictions

**Example alignment check:**

**VISION.md says:** "Help solo developers maintain context"
**SCOPE.md should:** Include features for context management, exclude features unrelated to this purpose

**If misaligned:** Feedback should explain contradiction and suggest fix

### Step 10: Assess Feasibility

**Reality check:**
- [ ] MVP scope achievable in timeline
- [ ] Constraints don't make scope impossible
- [ ] Resource constraints realistic
- [ ] Success criteria achievable

**Red flags:**
- Timeline very short + scope very large
- Resource constraints severe (1 hour/week) + scope large
- Success criteria unrealistic (1M users in 1 month)
- Technical constraints conflict (must use X but X can't do Y)

## Review Output Format

```markdown
# Scope Review: [Project Name]

**Reviewer:** [Your name/Claude]
**Date:** [YYYY-MM-DD]
**Document:** SCOPE.md
**Version:** [version if tracked]
**Status:** APPROVED | NEEDS-CHANGES

## Summary
[Overall assessment - 1-2 paragraphs]

## Ontology Compliance
- ✅/❌ All 8 sections present
- ✅/❌ Sections in correct order
- ✅/❌ Format matches ontology

## Completeness Check
- ✅/❌ MVP features specific (5-15 items)
- ✅/❌ Future phases defined
- ✅/❌ Out of scope explicit (5-10 items)
- ✅/❌ Success criteria measurable (3-7 items)
- ✅/❌ All 4 constraint categories addressed
- ✅/❌ Assumptions stated (5-10 items)

## Clarity Assessment
- ✅/❌ Features concrete and specific
- ✅/❌ No vague language
- ✅/❌ Examples provided where needed
- ✅/❌ Technical terms defined

## Alignment Check
- ✅/❌ Serves vision purpose
- ✅/❌ Success criteria match vision
- ✅/❌ No contradictions

## Feasibility Assessment
- ✅/❌ MVP scope achievable in timeline
- ✅/❌ Constraints realistic
- ✅/❌ Success criteria attainable

## Critical Issues (if NEEDS-CHANGES)
1. **[Issue Title]**
   - Section: [which section]
   - Problem: [what's wrong]
   - Impact: [why this matters]
   - Fix: [how to resolve]

2. **[Next Issue]**

## Minor Issues
[Non-blocking improvements]

## Strengths
[What the scope does well]

## Decision
[APPROVED - ready for roadmap-planner]
[NEEDS-CHANGES - address critical issues above]
```

## Common Issues

### Issue 1: Vague MVP Features
```
Problem: "User management" or "Backend APIs"
Impact: Can't plan roadmap without knowing what to build
Fix: "User registration via email/password, profile editing (name, avatar)"
```

### Issue 2: Missing "Out of Scope"
```
Problem: Only lists included features
Impact: Scope creep likely, unclear boundaries
Fix: Add 5-10 explicitly excluded items with rationale
```

### Issue 3: Unmeasurable Success Criteria
```
Problem: "System is reliable and fast"
Impact: Can't verify if MVP succeeded
Fix: "Uptime >99.5%, API response <200ms p95"
```

### Issue 4: Timeline Without Constraints
```
Problem: "6 month timeline" with no context
Impact: Unclear if this is aspirational or firm deadline
Fix: "6 months (hard deadline: investor demo June 1, 2025)"
```

### Issue 5: Implicit Assumptions
```
Problem: No assumptions section or very brief
Impact: Risks not identified, surprises likely
Fix: List 5-10 explicit assumptions (user behavior, technical feasibility, resource availability)
```

### Issue 6: Future Phases Too Vague
```
Problem: "Phase 2: More features"
Impact: No visibility into product direction
Fix: "Phase 2: Real-time collaboration, rich text editor, file attachments"
```

## Best Practices

**DO:**
- Check ontology first (structure compliance)
- Verify each feature is specific and concrete
- Ensure success criteria measurable
- Confirm alignment with VISION.md
- Approve when quality bar met (don't nitpick)

**DON'T:**
- Accept vague features ("user management")
- Allow missing "out of scope" section
- Permit unmeasurable success criteria
- Skip feasibility check
- Block on style preferences

## Integration

**Consumes:**
- SCOPE.md (draft to review)
- SCOPE-ontology.md (validation reference)
- VISION.md (alignment check)

**Produces:**
- Review document with decision
- Specific feedback for scope-writer

**Workflow Position:**
```
vision-writer → VISION.md ✓
  ↓
scope-writer → SCOPE.md (draft)
  ↓
scope-reviewer → Review SCOPE.md ⬅ YOU ARE HERE
  ↓ (if APPROVED)
roadmap-planner → ROADMAP.md
```

## Critical Reminders

- MVP features must be specific (not vague)
- Out of scope must be explicit (5-10 items)
- Success criteria must be measurable (3-7 items)
- All 4 constraint categories required (Timeline, Resource, Technical, Business)
- Check alignment with VISION.md obsessively

**Most critical:** Vague scope → vague roadmap → vague specs → vague implementation. Ensure clarity!

## Related Skills

- **scope-writer**: Produces SCOPE.md to review
- **roadmap-planner**: Consumes approved SCOPE.md
- **SCOPE-ontology.md**: Validation reference
- **VISION.md**: Alignment reference
