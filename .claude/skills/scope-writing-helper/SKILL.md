---
name: scope-writing-helper
description: Guide users through defining concrete project scope via collaborative conversation, then use scope-writer to create SCOPE.md. Use when users have a vision and need help translating it into specific boundaries, deliverables, and constraints through dialogue.
---

# Scope Writing Helper

## Overview

Help users translate their product vision into concrete scope through guided Socratic conversation, making features tangible, setting clear boundaries, and reality-checking constraints. Once scope is crystallized, use scope-writer skill to produce SCOPE.md document.

## When to Use This Skill

**Trigger scenarios:**
- User has VISION.md and wants to create SCOPE.md but needs help
- User says they need to define scope but isn't sure where to start
- User provides vague scope ideas that need concretization
- User wants collaborative exploration before defining deliverables

**Do NOT use for:**
- User has clear scope and just needs document written (use scope-writer directly)
- User wants to review existing scope (use scope-reviewer)
- User doesn't have vision yet (use vision-writing-helper first)
- User wants to create roadmap (use roadmap-planner)

**How to recognize need:**
- User has vision but says "Now what?"
- User provides vague MVP: "Something to manage specifications"
- User unsure about boundaries: "I don't know what's too much"
- User hasn't thought through constraints

## Conversation Philosophy

**Principles:**
1. **Concrete over abstract** - Make everything tangible and demonstrable
2. **Ground in vision** - Constantly reference back to VISION.md
3. **Reality check constantly** - Test against actual resources and constraints
4. **Boundaries are features** - Saying "no" is as important as saying "yes"
5. **User capabilities, not system features** - Focus on what users can DO
6. **Iterate through examples** - Use specific scenarios to clarify
7. **Challenge scope creep gently** - Help users stay minimal

**Conversational style:**
- Start by reviewing vision together
- Use "walk me through" to get concrete scenarios
- Ask "what specifically" to combat vagueness
- Reality check: "With [constraint], can you actually build [scope]?"
- Acknowledge hard trade-offs: "Leaving that out is tough, but keeps you focused"

## Conversation Framework

### Phase 0: Vision Review

**Goal:** Ensure shared understanding of vision before defining scope.

**Opening:**
"Let's start by reviewing your vision together. I want to make sure we're aligned before defining scope."

**Review together:**
- Vision statement
- Target users
- Core value proposition
- Vision's "In Scope (MVP)" section
- Success criteria
- Resource constraints

**Questions:**
- "Does this vision still feel right to you?"
- "Any changes since writing this?"
- "What's the timeline you're working with?"
- "Remind me: what resources do you have?"

**Red flags:**
- User no longer aligned with vision (may need vision update)
- Vision is too vague for scope definition
- Resource constraints have changed significantly

**Transition:**
"Great, so we're building [vision summary] for [users] with [resources]. Now let's get concrete about what specifically we're delivering."

### Phase 1: Making Features Concrete

**Goal:** Transform vision's high-level scope into specific deliverables.

**Opening:**
"Your vision mentions [vision feature]. Let's make that concrete - what exactly does that mean? What can users actually do?"

**Concretization questions:**
- "What specific commands, buttons, or actions does that include?"
- "Walk me through a user doing [feature] from start to finish"
- "What's the input? What's the output?"
- "How would you demo this to someone?"

**For each vision feature:**
1. Identify core capability
2. Break into 2-5 specific deliverables
3. Describe in concrete terms
4. Test with scenario: "So a user could...?"

**Example dialogue:**

**User vision says:** "Lightweight specification format"

**Helper:** "Let's make 'specification format' concrete. What specifically can users do with specs?"

**User:** "Create them, view them, validate them..."

**Helper:** "Okay, so 'create' - walk me through that. I'm a user who wants a new spec. What do I do?"

**User:** "Run a command like `create-spec` and it generates a template"

**Helper:** "Good. And what's in that template? What sections?"

**User:** "Overview, interface, behavior, testing..."

**Helper:** "Perfect. So one deliverable is: CLI command to create spec from template with those sections. What about 'validate'?"

**Looking for:**
- Specific, demonstrable deliverables
- 2-5 concrete items per vision feature
- Observable actions (can demo or test)
- Appropriate level (not too detailed, not too vague)

**Red flags:**
- Still vague: "Better user experience"
- Too detailed: Button labels, CSS classes
- Too many deliverables (expanding beyond vision)
- System internals, not user capabilities

### Phase 2: User Capabilities

**Goal:** Define what users can DO after MVP from user perspective.

**Opening:**
"Now let's describe this from the user's perspective. After MVP, what can they do? Let's use the format: 'Users can [action] by [method] resulting in [outcome]'"

**Capability crafting questions:**
- "What's a complete task a user accomplishes?"
- "How do they accomplish it? What's the method?"
- "What's the result or outcome?"
- "Is this observable? Could you demo it?"

**For each major feature area:**
- Identify 2-3 user capabilities
- Use consistent format
- Ensure complete user journey covered
- Verify capabilities are valuable

**Example dialogue:**

**Helper:** "For the specification feature, what can users do?"

**User:** "Create specs, I guess?"

**Helper:** "Let's be more complete. 'Users can... what exactly?'"

**User:** "Users can create new feature specs"

**Helper:** "Good start. By doing what? And what's the result?"

**User:** "Users can create new feature specs by running `ctx spec create <name>` resulting in a pre-filled spec template"

**Helper:** "Perfect! That's concrete and demonstrable. What else can they do with specs?"

**Looking for:**
- Minimum 5 capabilities for MVP
- Complete user journeys represented
- Observable and demonstrable
- Focused on user value, not system features
- Format: "Users can [action] by [method] resulting in [outcome]"

**Red flags:**
- Too few capabilities (<3)
- Vague capabilities without method or outcome
- System capabilities, not user capabilities
- Incomplete journeys (can create but not edit)

### Phase 3: Technical Requirements

**Goal:** Identify infrastructure, integrations, and technical constraints.

**Opening:**
"What technical foundation does this need? Think infrastructure, integrations, platforms, constraints."

**Infrastructure questions:**
- "Where does this run? (CLI, web, mobile)"
- "What language/framework?"
- "Does it need a database or is it file-based?"
- "Does it need a server or is it client-only?"

**Integration questions:**
- "What existing systems does this integrate with?"
- "What third-party services do you need?"
- "What APIs do you depend on?"

**Constraint questions:**
- "What platform limitations exist?"
- "What performance requirements?"
- "Any security or compliance needs?"
- "Cross-platform requirements?"

**Looking for:**
- Clear technical foundation
- Integration points identified
- Performance/quality baselines
- Constraints documented
- NOT implementation details

**Red flags:**
- Too detailed (class names, algorithms)
- Missing obvious requirements
- Unrealistic requirements (infinite scale)
- Conflicting requirements

**Example dialogue:**

**Helper:** "So this is a CLI tool. What language?"

**User:** "Python"

**Helper:** "Good. Does it need a database or will files work?"

**User:** "Files are fine - actually, it should work with Git repos"

**Helper:** "Okay, so: Works with existing Git repos, no separate database. File-based storage. Any other technical requirements?"

**User:** "Needs to work on Mac and Linux"

**Helper:** "Cross-platform. What about Windows?"

**User:** "WSL is fine for MVP"

**Helper:** "Good constraint. So: Python CLI, Git-based storage, macOS/Linux/WSL. Any performance requirements?"

**User:** "Should feel instant - like under 1 second for queries"

**Helper:** "Great. That's a clear quality bar."

### Phase 4: Acceptance Criteria

**Goal:** Define observable, testable criteria for MVP completion.

**Opening:**
"How will you know the MVP is done? Let's define specific, testable criteria."

**Criteria questions:**
- "What must work for MVP to be complete?"
- "How would you verify that?"
- "Can you test this objectively?"
- "What's the minimum quality bar?"

**For each core feature:**
- What observable behavior?
- How to verify?
- What quality threshold?

**Format guidance:**
"Let's write these as checkboxes - specific things you can verify. Like: 'Running `ctx spec create` generates file with all template sections'"

**Looking for:**
- Minimum 5-8 criteria
- Observable and testable
- Covers core features
- Specific, not vague
- Realistic quality bars

**Red flags:**
- Vague: "System works well"
- Unmeasurable: "Users are happy"
- Too many (>20) or too few (<3)
- Subjective without measurement

**Example dialogue:**

**Helper:** "So for spec creation, what must work?"

**User:** "Specs get created"

**Helper:** "Let's be more specific. What exactly happens when you run the create command?"

**User:** "It generates a Markdown file with the template sections filled in"

**Helper:** "Perfect. So: 'Running `ctx spec create <name>` generates Markdown file with all template sections.' What else?"

**User:** "The validation should work"

**Helper:** "What does validation do specifically?"

**User:** "Checks if required sections are present"

**Helper:** "So: 'Running `ctx spec check` identifies missing required sections with specific error messages.' Right?"

### Phase 5: Setting Boundaries

**Goal:** Define what's explicitly OUT of scope to prevent creep.

**Opening:**
"Now the hard part - what are you NOT doing? What will people ask for that you'll say no to?"

**"Never in this project" questions:**
- "What adjacent problems are you NOT solving?"
- "What features would dilute your focus?"
- "What user segments are you NOT targeting?"
- "What would be scope creep?"

**"Not in this version" questions:**
- "What's desirable but can wait?"
- "What requires MVP validation first?"
- "What would overload your timeline?"

**Probing questions:**
- "People will ask for [common expansion]. Why say no?"
- "What about [adjacent feature]?"
- "Some users will want [broader capability]. Your answer?"

**Looking for:**
- Minimum 3-5 "never" exclusions
- Specific, not vague
- Addresses likely scope creep
- Clear reasoning why excluded

**Red flags:**
- No exclusions
- Vague: "Bad features"
- Everything is "maybe later"
- No conviction about boundaries

**Example dialogue:**

**Helper:** "What are you definitely NOT doing in this project?"

**User:** "Hmm, not sure..."

**Helper:** "Let me try some common expansions. What about general project management - time tracking, resource allocation, Gantt charts?"

**User:** "Oh no, definitely not. That's not what this is for."

**Helper:** "Good. Why not?"

**User:** "This is about context management, not project management. That would dilute the focus."

**Helper:** "Perfect exclusion. What about team collaboration - real-time editing, chat?"

**User:** "Not now at least. MVP is for solo developers."

**Helper:** "So that goes in 'Not in this version' because you might do it later, but 'Never' if it would require rethinking the core approach. Which feels right?"

**User:** "Not this version. If MVP works for solo devs, maybe team features later."

**Helper:** "Got it. What else?"

### Phase 6: Reality Check

**Goal:** Validate scope fits within actual constraints.

**Opening:**
"Let's reality check this against your constraints. You said you have [resources]. Does this MVP fit?"

**Resource validation:**
- "You have [hours/week] for [duration]. Total: [hours]."
- "We've defined [X] features. Can you build that in [hours]?"
- "What's your experience level with [tech]? Learning curve?"
- "Any other time commitments?"

**Scope adjustment questions:**
- "If this feels tight, what could you defer?"
- "What's truly minimal vs. nice-to-have?"
- "Which feature delivers most value with least effort?"
- "Could you reduce platforms? (Web only, not mobile)"

**Buffer discussion:**
- "Have you included buffer time? (20% recommended)"
- "What if something is harder than expected?"
- "What's your contingency plan?"

**Looking for:**
- Realistic assessment
- Willingness to cut if needed
- Buffer time included
- Honest about skills/experience

**Red flags:**
- Optimistic planning (no buffer)
- Unwilling to cut anything
- Ignoring learning curves
- "I'll just work more hours"

**Example dialogue:**

**Helper:** "You said 15 hours/week for 3 months - that's about 180 hours. You've defined: spec management, linking engine, living docs, project initialization. Can you build that in 180 hours?"

**User:** "I think so?"

**Helper:** "Let's break it down. Linking engine is new and complex - maybe 40 hours? Spec management - 30 hours? Living docs - 30? Initialization - 10? That's 110, plus testing, docs..."

**User:** "When you add it up, it's tight."

**Helper:** "Do you have buffer time? What if linking is harder than expected?"

**User:** "I could cut living docs from MVP if needed."

**Helper:** "Good contingency. So MVP is linking + specs, living docs is Phase 2 if time allows or you validate MVP first. That feel better?"

**User:** "Yeah, more realistic."

### Phase 7: Future Phases

**Goal:** Acknowledge what comes after MVP without over-planning.

**Opening:**
"What comes after MVP? Let's sketch future phases at a high level."

**Phase 2 questions:**
- "What's the logical next addition after MVP?"
- "What requires MVP validation first?"
- "What features did users request we deferred?"

**Longer term questions:**
- "What's your 1-year vision?"
- "What might Phase 3 include?"
- "Any blue-sky features?"

**Flexibility reminder:**
"Remember, these plans will change based on what you learn from MVP. Keep them light."

**Looking for:**
- Logical evolution from MVP
- Brief descriptions (1 sentence each)
- Not overly detailed
- Acknowledges uncertainty

**Red flags:**
- Too detailed (treating like specs)
- Everything planned through Phase 5
- No flexibility acknowledged
- Forgetting Phase 1 will change everything

## Synthesis and Document Creation

### When Ready to Write

**Signals we're ready:**
- Vision reviewed and aligned
- Features concrete with deliverables
- User capabilities defined (5+)
- Technical requirements clear
- Acceptance criteria defined
- Boundaries set ("out of scope")
- Reality checked against constraints
- Future phases sketched

**Check with user:**
"I think we have all the pieces for your scope document. We've defined:
- Core features: [list]
- User capabilities: [count]
- Technical requirements: [summary]
- Acceptance criteria: [count]
- Boundaries: [out of scope items]
- Future phases: [Phase 2 summary]

Ready for me to use scope-writer to create SCOPE.md, or want to explore anything more?"

**If user wants more:**
- Identify which area needs more depth
- Return to that phase
- Continue until clarity emerges

**If user is ready:**
"Perfect! I'll use scope-writer to create SCOPE.md from our conversation and your VISION.md."

### Using scope-writer Skill

**Prepare inputs:**
From conversation:
- Scope overview (2-3 sentence summary)
- Project objectives (3-5 measurable objectives)
- Core features (list with descriptions)
- User capabilities (list in proper format)
- Technical requirements (infrastructure, integrations, constraints)
- Acceptance criteria (observable, testable criteria)
- Future phases (Phase 2, 3+, deferred)
- Explicitly out of scope (never + not this version)
- Constraints and assumptions (resource, technical, business)
- Success criteria (MVP complete when, quality standards)

From VISION.md:
- Vision statement
- Success criteria
- Assumptions and constraints

**Call scope-writer:**
Provide VISION.md path and structured inputs from conversation.

**Present result:**
"I've created your SCOPE.md document. Let me show it to you..."

[Present document]

"Does this capture our discussion? Any sections to refine?"

### Iterating on Document

**Common refinement needs:**
- MVP scope still too ambitious (reality check failed)
- User capabilities not concrete enough
- Acceptance criteria too vague
- Missing "out of scope" items
- Technical requirements too detailed or too vague

**Iteration approach:**
- Identify specific section
- Ask targeted questions
- Update with scope-writer
- Review again

**When done:**
"Excellent! You now have a complete SCOPE.md that:
- Defines concrete MVP deliverables
- Sets clear boundaries
- Aligns with your vision
- Fits your constraints

This is ready for roadmap-planner to create your feature sequence. Want to move to that next, or want me to review this scope with scope-reviewer first?"

## Question Techniques

### Concretization Probes

**Moving abstract to concrete:**
- "What specifically does that mean?"
- "Walk me through a user doing that"
- "What's the input and output?"
- "How would you demo that?"

### Reality Checks

**Testing against constraints:**
- "With [constraint], can you actually build this?"
- "How long would [feature] take to build?"
- "What's your contingency if this takes longer?"
- "If you had to cut one thing, what would it be?"

### Boundary Setting

**Forcing exclusions:**
- "What will people ask for that you'll say no to?"
- "What about [adjacent feature]?"
- "Why is [exclusion] not in scope?"
- "That's a lot - what could you defer?"

### User Capability Framing

**Getting to user perspective:**
- "From the user's view, what can they do?"
- "Users can [action] by doing what?"
- "What's the result or outcome?"
- "Is that a complete capability or partial?"

## Common Conversation Patterns

### Pattern 1: Vague Feature to Concrete Deliverables

**User says:** "I want specification management"

**Response:**
"Let's make that concrete. What specific actions can users take with specs? Creating, editing, deleting, validating...?"

**User:** "All of those"

**Response:**
"Okay, let's take 'creating' - walk me through it. I'm a user. What do I do?"

**User:** "Run a command"

**Response:**
"What command? What happens?"

**User:** "`create-spec` and it makes a template"

**Response:**
"Perfect. So one deliverable is: 'CLI command `create-spec` generates spec template.' What's in the template? What sections?"

**Goal:** Transform "spec management" into 4-5 concrete deliverables

### Pattern 2: Feature Expansion to Reality Check

**User says:** "And I want web app, mobile app, desktop app..."

**Response:**
"That's three platforms. You mentioned 15 hours/week for 3 months - that's 180 hours total. Can you realistically build all three platforms in that time?"

**User:** "Well, maybe..."

**Response:**
"Let's prioritize. Which platform delivers the most value? Which one do your target users primarily use?"

**User:** "Probably web"

**Response:**
"So web for MVP, mobile/desktop as future phases? That keeps you focused and realistic."

**Goal:** Reality check scope against actual constraints

### Pattern 3: System Feature to User Capability

**User says:** "It has a validation engine"

**Response:**
"Okay, so from a user's perspective, what can they do with that validation?"

**User:** "Check if their spec is complete"

**Response:**
"Good. Let's make it more concrete: 'Users can [action] by [method] resulting in [outcome]'"

**User:** "Users can validate spec completeness by running `check-spec` resulting in a list of missing required sections"

**Response:**
"Perfect! That's a clear user capability."

**Goal:** Reframe system features as user capabilities

### Pattern 4: Everything In to Boundaries Out

**User says:** "It should have all these features..."

**Response:**
"That's a lot for MVP. Let's try this: What are you definitely NOT doing? What adjacent problems are you NOT solving?"

**User:** "Um..."

**Response:**
"Let me try some. General project management - time tracking, Gantt charts?"

**User:** "No, that's not this."

**Response:**
"Good! That's your first 'Never in scope' item. What else?"

**Goal:** Force articulation of boundaries and exclusions

## Adapting to User Style

### Vision-Grounded User

**Characteristics:**
- Keeps referring to vision
- Worried about alignment
- Wants to ensure scope serves vision

**Adaptation:**
- Frequently validate against vision
- Reference vision statement regularly
- Show explicit connections
- Reassure about alignment

### Expansive User

**Characteristics:**
- Keeps adding features
- "And also..." pattern
- Struggles with "no"

**Adaptation:**
- Reality check constantly
- Force prioritization
- Emphasize MVP = minimal
- Help see cost of additions
- Celebrate good exclusions

### Detail-Oriented User

**Characteristics:**
- Wants to specify everything
- Gets into implementation details
- Worried about missing things

**Adaptation:**
- Remind about appropriate level
- "That's spec-level, we're at scope-level"
- Validate concerns without over-detailing
- Reassure that specs come next

### Uncertain User

**Characteristics:**
- Not sure what's realistic
- Seeks validation constantly
- Worried about making mistakes

**Adaptation:**
- Provide examples from similar projects
- Reality check supportively
- Validate good decisions
- Offer options to react to
- Build confidence with concrete progress

## Critical Reminders

**DO:**
- Start by reviewing VISION.md together
- Make everything concrete and demonstrable
- Use "walk me through" to get specifics
- Reality check scope against actual constraints
- Force articulation of boundaries (out of scope)
- Frame as user capabilities, not system features
- Test scenarios to validate concreteness
- Acknowledge hard trade-offs positively
- Use scope-writer after clarity emerges
- Iterate if document needs refinement

**DON'T:**
- Skip vision review at start
- Accept vague deliverables
- Allow scope creep without reality check
- Let user avoid "out of scope" decisions
- Get into implementation details (too granular)
- Rush to document before clarity
- Assume first draft is final
- Forget to validate against vision

## Integration with Other Skills

**Requires VISION.md:**
- Must exist before starting
- Reviews it at beginning
- References throughout
- Uses as input to scope-writer

**Uses scope-writer skill:**
- After conversation reaches clarity
- Provides structured inputs from conversation
- Provides VISION.md path
- Produces SCOPE.md document
- Iterates if needed

**Can suggest scope-reviewer:**
- After document created
- To validate quality
- To check readiness for roadmap

**Leads to roadmap-planner:**
- After SCOPE.md complete and approved
- Suggest: "Ready to sequence these features into a roadmap?"

## When to Stop Helping

**User is ready for direct tool:**
- "I know exactly what's in scope, just use scope-writer"
- User provides complete, clear inputs
- User frustrated with questions

**Response:** "Sounds like you have clear thinking. Let me use scope-writer directly."

**Vision isn't solid enough:**
- Vision is too vague for scope definition
- Vision missing critical elements
- Vision recently changed

**Response:** "I think we need to refine the vision before defining scope. Should we revisit VISION.md?"

**User won't make hard choices:**
- Won't set boundaries
- Won't reality check
- Everything must be in MVP
- No exclusions acceptable

**Response:** "I'm concerned we're heading toward scope creep. Would it help to talk through what minimal really means for your constraints?"
