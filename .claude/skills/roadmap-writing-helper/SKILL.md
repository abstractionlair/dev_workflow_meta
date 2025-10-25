---
name: roadmap-writing-helper
description: Guide users through sequencing features into phased roadmap via collaborative conversation, then use roadmap-writer to create ROADMAP.md. Use when users have VISION.md and SCOPE.md but need help deciding feature sequence, understanding dependencies, and planning phases through dialogue.
---

# Roadmap Writing Helper

## Overview

Help users transform their concrete scope into sequenced roadmap through guided Socratic conversation, exploring dependencies, derisking strategy, and phase structure. Once sequencing is crystallized, use roadmap-writer skill to produce ROADMAP.md document.

## When to Use This Skill

**Trigger scenarios:**
- User has VISION.md and SCOPE.md and wants to create ROADMAP.md but needs help
- User says "I have my features but don't know what order to build them"
- User unsure about sequencing: "What should I build first?"
- User wants collaborative exploration of dependencies and risks

**Do NOT use for:**
- User has clear sequencing and just needs document written (use roadmap-writer directly)
- User wants to review existing roadmap (use roadmap-reviewer)
- User doesn't have scope yet (use scope-writing-helper first)
- User wants detailed spec (use spec-writer)

**How to recognize need:**
- User has scope but says "Now how do I sequence this?"
- User uncertain about dependencies: "What depends on what?"
- User paralyzed by choice: "Everything seems important"
- User hasn't thought through risk or sequencing strategy

## Conversation Philosophy

**Principles:**
1. **Derisk first, polish later** - Validate scary assumptions early
2. **Value ladder** - Each phase delivers complete user value
3. **Learning loops** - Build to learn, then decide next
4. **Dependencies drive sequence** - Can't build B before A
5. **Phase boundaries are learning gates** - Pause to assess and pivot
6. **Realistic scoping** - Challenge overambitious phasing
7. **Strategy over tactics** - Focus on "why this order" not "how to build"

**Conversational style:**
- Start by reviewing vision and scope together
- Use "what's the riskiest assumption?" to find derisking strategy
- Ask "what depends on what?" to map dependencies
- Reality check: "Can you build 10 features in Phase 1?"
- Acknowledge hard choices: "Deferring that is smart - you'll learn first"

## Conversation Framework

### Phase 0: Vision and Scope Review

**Goal:** Ensure shared understanding before sequencing.

**Opening:**
"Let's review your vision and scope together before we sequence features. I want to understand your goals and constraints."

**Review together:**
- Vision statement and purpose
- Scope MVP features (what to sequence)
- Success criteria (what roadmap achieves)
- Timeline constraints (deadlines that matter)
- Resource constraints (team size, capacity)
- Scope future phases (post-MVP direction)

**Questions:**
- "What's your timeline? Any hard deadlines?"
- "What's your biggest worry or uncertainty?"
- "Are all these MVP features equally important?"
- "What could kill this project if wrong?"

**Red flags:**
- Scope too large for timeline
- No clear prioritization
- User doesn't know dependencies
- Critical risks not identified

**Transition:**
"Okay, so we have [N] MVP features to sequence across [timeline]. Let's figure out what order makes sense."

### Phase 1: Identify Risky Assumptions

**Goal:** Find what to validate early (derisking strategy).

**Opening:**
"Before we sequence, let's identify your riskiest assumptions - the things that could invalidate your approach if wrong."

**Questions to surface risks:**
- "What's the scariest technical assumption?"
- "What are you least certain will work?"
- "What would kill the project if you're wrong?"
- "Where do you have least experience or expertise?"
- "What depends on external factors you don't control?"

**For each feature in scope:**
- "How confident are you this is technically feasible? (1-10)"
- "What could go wrong?"
- "Have you built something like this before?"
- "Does this depend on unproven technology?"

**Example dialogue:**

**Helper:** "Looking at your MVP features - automated spec linking, spec management, CLI. Which feels riskiest?"

**User:** "Probably the automated linking. Not sure if static analysis will be accurate enough."

**Helper:** "Good insight. What's 'accurate enough'? What threshold?"

**User:** "I'd say >85% detection rate. Below that, too much manual cleanup."

**Helper:** "And if you get to Phase 2, build all the spec management, then discover linking only hits 60% - what happens?"

**User:** "Ugh, yeah, I'd have to redesign the whole approach."

**Helper:** "Exactly. So that's your Phase 1 validation target. Build the risky thing first."

**Looking for:**
- Technical assumptions (will X technology work?)
- User assumptions (will users adopt this workflow?)
- Performance assumptions (can this scale?)
- Integration assumptions (will external APIs cooperate?)

**Output:**
- List of risky assumptions ranked by risk
- Features that test those assumptions
- Validation criteria (how to know if assumption holds)

### Phase 2: Map Dependencies

**Goal:** Understand what must be built before what.

**Opening:**
"Now let's map dependencies. What features require other features to exist first?"

**Questions for each feature:**
- "Can you build this standalone, or does it need something else first?"
- "What other features does this depend on?"
- "What features can't be built until this exists?"
- "Are there external dependencies? (APIs, services, data)"

**Dependency patterns to explore:**

**Technical dependencies:**
- "User Dashboard needs User Authentication first"
- "File Upload needs Storage Configuration first"
- "API needs Database Schema first"

**Learning dependencies:**
- "Advanced Search needs to validate Simple Search usage patterns first"
- "Collaboration needs to confirm users work in teams"
- "Premium Features need to validate payment model works"

**Example dialogue:**

**Helper:** "Can you build the CLI commands independently, or do some depend on others?"

**User:** "Well, `find-spec` needs the linking engine to exist first. And `validate-spec` needs the spec format defined."

**Helper:** "Good. So linking engine is foundational - other things build on it. What about the spec management features?"

**User:** "Those are mostly independent - create, edit, delete specs. Just need the format."

**Helper:** "So format definition is another foundation piece. And the linking engine - can that work without the format?"

**User:** "Actually no, it needs to know what it's looking for in specs."

**Helper:** "So: spec format → linking engine → CLI commands. That's your dependency chain."

**Looking for:**
- Foundation features (nothing depends on them)
- Blocked features (can't start until X done)
- Independent features (can be built in any order)
- Circular dependencies (need to break)

**Red flags:**
- Circular dependencies (A needs B needs C needs A)
- Too many dependencies (everything depends on everything)
- Unrealistic external dependencies (3-month API approval)

**Output:**
- Dependency graph (what depends on what)
- Foundation features identified
- Blocked features noted
- Independent features flagged

### Phase 3: Define Phases

**Goal:** Group features into coherent phases with clear goals.

**Opening:**
"Let's organize features into phases. Each phase should deliver something usable and teach you something valuable."

**Phase structuring principles:**

**Phase 1 (MVP Core):**
- Foundation features (things others depend on)
- Highest-risk features (validate scary assumptions)
- Complete user journey (end-to-end capability)
- 3-7 features typically

**Phase 2 (Enhancement):**
- Build on Phase 1 validation
- Add user value
- Address Phase 1 learnings
- 3-7 features typically

**Phase 3+ (Growth):**
- Features from SCOPE future phases
- Optional enhancements
- Market expansion

**Questions for phase structure:**
- "After Phase 1, what can users actually do?"
- "What will you learn from Phase 1?"
- "If Phase 1 validation fails, what would you pivot to?"
- "Is Phase 1 small enough to build quickly? (<8 weeks ideal)"

**Example dialogue:**

**Helper:** "You have spec format, linking engine, CLI commands, and spec management. How should we phase these?"

**User:** "Maybe all in Phase 1?"

**Helper:** "That's... 8 major features. How long to build?"

**User:** "Probably 3-4 months."

**Helper:** "And you said linking engine is riskiest. If you spend 2 months on format and management, then discover linking doesn't work, how do you feel?"

**User:** "Terrible. I'd have wasted time."

**Helper:** "Right. What if Phase 1 is just: spec format + linking engine + one CLI command to demo it? Build the risk, validate the approach, then decide Phase 2."

**User:** "That's maybe 4-6 weeks. Then I know if the core works."

**Helper:** "Exactly. Phase 2 adds management and more commands if Phase 1 validates. If linking fails, you pivot without wasting months."

**Looking for:**
- Coherent phase goals
- 3-7 features per phase
- Complete user value per phase
- Learning captured between phases
- Realistic timeline per phase

**Red flags:**
- Phase 1 too large (>8 weeks)
- Phases don't deliver user value
- No learning goals between phases
- Phases ignore dependencies

**Output:**
- Phase structure (how many phases)
- Features per phase
- Phase goals (what each achieves)
- Learning goals (what you'll learn)

### Phase 4: Sequence Within Phases

**Goal:** Order features within each phase.

**Opening:**
"Within each phase, what order should we build features?"

**Sequencing considerations:**
- Dependencies first (foundation before dependent)
- Risk first (if derisking strategy)
- Value first (if value delivery strategy)
- Learning first (if validation strategy)

**Questions:**
- "Within Phase 1, what absolutely must be built first?"
- "What can be built in parallel?"
- "What's the last thing you'd build in this phase?"
- "What's the first thing you'd demo?"

**Example dialogue:**

**Helper:** "Phase 1 has spec format, linking engine, and CLI demo command. What order?"

**User:** "Format first, since linking needs to know what to look for."

**Helper:** "Good. Then?"

**User:** "Linking engine. That's the risky validation."

**Helper:** "And CLI command last - to demonstrate the linking works?"

**User:** "Exactly. Format → Engine → Demo."

**Looking for:**
- Clear build order within phase
- Dependencies respected
- Logical progression
- Early validation of risk

### Phase 5: Define Success Criteria and Checkpoints

**Goal:** Know what "done" looks like and when to reassess.

**Opening:**
"For each phase, let's define success criteria - how you'll know it's complete. And validation checkpoints - where you pause to decide what's next."

**Success criteria questions:**
- "How do you know Phase 1 is done?"
- "What must work? What's measurable?"
- "What would you demo to prove it's ready?"
- "What tests would pass?"

**Validation checkpoint questions:**
- "After Phase 1, what will you assess?"
- "What would make you continue as planned?"
- "What would make you pivot?"
- "What would make you stop the project?"

**Example dialogue:**

**Helper:** "How do you know Phase 1 - linking engine - is successful?"

**User:** "If detection accuracy is >85%, I guess."

**Helper:** "More specific - how would you test that?"

**User:** "Run it on a sample codebase with known links, measure how many it finds."

**Helper:** "Good. What else must work?"

**User:** "Performance - should scan 1000-file codebase in <5 seconds."

**Helper:** "Perfect. So Phase 1 success: >85% detection accuracy, <5 second scan time, and what else?"

**User:** "CLI command returns results correctly, no crashes on edge cases."

**Helper:** "Now, at end of Phase 1, you review results. What would make you continue to Phase 2?"

**User:** "If accuracy is >85% and performance acceptable."

**Helper:** "What if accuracy is 70%?"

**User:** "I'd need to improve the algorithm or add manual linking as fallback."

**Helper:** "That's a pivot. And what if accuracy is 40%?"

**User:** "I'd probably abandon this approach entirely."

**Helper:** "Good - that's your stop condition. Let's document these as your validation checkpoint."

**Looking for:**
- Specific, measurable success criteria per phase
- 3-7 criteria per phase
- Validation checkpoint with decision framework
- Continue/Pivot/Stop conditions clear

### Phase 6: Reality Check

**Goal:** Ensure roadmap is actually achievable.

**Opening:**
"Let's reality check this roadmap against your constraints."

**Questions:**
- "With [X hours/week], can you build Phase 1 in [Y weeks]?"
- "Have you built similar features before? How long did they take?"
- "What could go wrong? Where's padding needed?"
- "Are external dependencies realistic? (API approvals, design assets)"
- "Is there scope creep hidden anywhere?"

**Example dialogue:**

**Helper:** "You said Phase 1 is 4-6 weeks. That's spec format, linking engine, CLI command. You have 20 hours/week. That's 80-120 hours total. Does that feel right?"

**User:** "Maybe tight. Linking engine is complex."

**Helper:** "What if we drop the CLI command from Phase 1? Just prove linking works programmatically. Add CLI in Phase 2."

**User:** "That's safer. Linking engine alone might be 80-100 hours."

**Helper:** "So Phase 1 is really just: format + linking. 6-8 weeks more realistic?"

**User:** "Yeah, with buffer for surprises."

**Looking for:**
- Effort estimates match capacity
- Buffer for unknowns (add 25-50%)
- External dependencies realistic
- Scope isn't creeping

**Red flags:**
- Phase 1 >8 weeks (too long)
- No buffer (assuming perfection)
- Overly optimistic estimates
- Ignoring external blockers

### Phase 7: Finalize Sequencing Strategy

**Goal:** Articulate the "why" behind this sequence.

**Opening:**
"Let's articulate why you're sequencing features this way - your strategy."

**Strategy dimensions:**

**Derisking:**
"Build scariest thing first to validate early"

**Value delivery:**
"Deliver user value as quickly as possible"

**Learning:**
"Build to learn, then decide what's next"

**Dependencies:**
"Build foundation before dependents"

**Questions:**
- "What's your primary sequencing driver?"
- "How does this roadmap serve your vision?"
- "Why this phase structure specifically?"
- "What principles guided your choices?"

**Example dialogue:**

**Helper:** "So why are you building linking engine first, before management features?"

**User:** "Because linking is the riskiest part - if it doesn't work, the whole approach fails."

**Helper:** "That's a derisking strategy. And why complete user journey in each phase?"

**User:** "So I can get feedback from real usage, not just theoretical validation."

**Helper:** "That's a learning strategy. Let's call your overall approach: 'Derisk core technology first, then layer user value based on validated approach.' Sound right?"

**User:** "Perfect."

**Output:**
- Sequencing strategy articulated
- Key principles stated (3-5 principles)
- Risk mitigation approach clear
- Value delivery pattern defined

## Transition to roadmap-writer

**When conversation complete:**
"Great! We have your sequencing strategy and phase structure clear. Now I'll use the roadmap-writer skill to create your ROADMAP.md document with all this captured formally."

**Then invoke roadmap-writer with:**
- VISION.md (for alignment)
- SCOPE.md (for features)
- Conversation insights:
  - Sequencing strategy
  - Phase structure
  - Dependencies
  - Risk mitigation approach
  - Success criteria per phase
  - Validation checkpoints

## Common Conversation Patterns

### Pattern 1: User wants everything in Phase 1

**User:** "Can't we just build it all at once?"

**Helper:** "Let's think through that. You have [N] features, [X] hours/week, each feature maybe [Y] hours. That's [total] hours or [weeks] weeks. What's your deadline?"

**User:** "6 months."

**Helper:** "That's [Z] weeks. With buffer, you might hit it. But what if linking engine - your riskiest feature - doesn't work? You've spent 4 months on other stuff first."

**User:** "Yeah, that would suck."

**Helper:** "What if we build linking first - 6 weeks - and validate it works before committing 4 more months?"

### Pattern 2: User unsure about dependencies

**User:** "I think they're all kind of independent?"

**Helper:** "Let's test that. Can you build [Feature A] without [Feature B] existing?"

**User:** "Hmm, actually no, A needs B's data model."

**Helper:** "So B is a dependency of A. What about [Feature C]?"

**User:** "C is really independent."

**Helper:** "Great, so B is foundation, A depends on it, C is independent. Now we know sequence."

### Pattern 3: User wants polish before validation

**User:** "Should we build the nice UI in Phase 1?"

**Helper:** "What's Phase 1's goal?"

**User:** "Validate the linking works."

**Helper:** "Can you validate that with a command-line tool, or does it need pretty UI?"

**User:** "Command line is fine for testing."

**Helper:** "Then save the UI for Phase 2 - after you know the core works. Build ugly first, pretty later."

### Pattern 4: User paralyzed by choices

**User:** "Everything seems important. I don't know what to prioritize."

**Helper:** "Let's use a forcing function. If you could only build ONE feature and had to demo it to users, which would it be?"

**User:** "Probably the linking engine - that's the magic."

**Helper:** "There's your Phase 1. Everything else is Phase 2+."

## Red Flags and Interventions

### Red Flag: Scope creep during sequencing

**Symptom:** User adds features not in SCOPE.md

**Intervention:**
"Hold on - [feature] isn't in your approved scope. If it's important, we should update SCOPE.md first. Otherwise, let's stay focused on what you committed to."

### Red Flag: Unrealistic phases

**Symptom:** Phase 1 has 12 features, 4-month estimate

**Intervention:**
"Phase 1 feels too large. Ideal is 3-7 features, 4-8 weeks. What's the smallest thing you could build that would validate your core assumption?"

### Red Flag: No derisking strategy

**Symptom:** Risky features in Phase 3

**Intervention:**
"I notice your riskiest assumption - [X] - is in Phase 3. What happens if you build Phase 1 and 2, then discover [X] doesn't work? Would you want to know that earlier?"

### Red Flag: Phases don't deliver value

**Symptom:** Phase 1 is "infrastructure", Phase 2 is "more infrastructure"

**Intervention:**
"After Phase 1, what can a user actually DO? What would you demo? If answer is 'nothing yet', we need to rethink the phase - each should deliver some user value."

### Red Flag: No learning goals

**Symptom:** User can't articulate what they'll learn from Phase 1

**Intervention:**
"At the end of Phase 1, what will you know that you don't know now? What decision will you make based on Phase 1 results?"

## Output Quality Checklist

Before transitioning to roadmap-planner, verify:

**Sequencing strategy:**
- [ ] Primary driver clear (derisk/value/learning/dependencies)
- [ ] Key principles articulated (3-5)
- [ ] User can explain "why this order"

**Phase structure:**
- [ ] 2-4 phases defined (MVP + future)
- [ ] 3-7 features per phase
- [ ] Each phase has clear goal
- [ ] Phase sizes realistic for timeline

**Dependencies:**
- [ ] Foundation features identified
- [ ] Blocked features noted
- [ ] No circular dependencies
- [ ] Build order respects dependencies

**Risk mitigation:**
- [ ] Riskiest assumptions identified
- [ ] High-risk features in early phases (if derisking strategy)
- [ ] Validation criteria defined

**Success criteria:**
- [ ] Each phase has 3-7 measurable criteria
- [ ] Criteria are specific and testable
- [ ] User knows what "done" looks like

**Validation checkpoints:**
- [ ] End-of-phase decision points defined
- [ ] Continue/Pivot/Stop conditions clear
- [ ] Review questions articulated

**Feasibility:**
- [ ] Timeline realistic given constraints
- [ ] Effort estimates grounded
- [ ] Buffer included for unknowns
- [ ] No hidden scope creep

## Related Skills

**Prerequisites:**
- vision-writer or vision-writing-helper (need VISION.md)
- scope-writer or scope-writing-helper (need SCOPE.md)

**Next steps:**
- roadmap-writer (actually writes ROADMAP.md) ← INVOKE THIS AFTER CONVERSATION
- roadmap-reviewer (validates completed ROADMAP.md)

**Related:**
- spec-writer (detailed feature specifications - after roadmap)

## Notes on Naming

**Consistent naming pattern:**
- vision-writer, scope-writer, roadmap-writer, spec-writer, skeleton-writer

All document producers use "-writer" suffix for uniformity.
