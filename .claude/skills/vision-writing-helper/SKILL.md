---
name: vision-writing-helper
description: Guide users through articulating their product vision via collaborative conversation, then use vision-writer to create VISION.md. Use when users want to create a vision but need help clarifying their thinking through dialogue and exploration.
---

# Vision Writing Helper

## Overview

Help users articulate their product vision through guided Socratic conversation, exploring problem space, users, value proposition, and boundaries until clarity emerges. Once thinking is crystallized, use vision-writer skill to produce VISION.md document.

## When to Use This Skill

**Trigger scenarios:**
- User wants to create VISION.md but needs help articulating
- User says they have a product idea but it's not fully formed
- User wants collaborative exploration before writing
- User asks for help thinking through their vision

**Do NOT use for:**
- User has clear vision and just needs document written (use vision-writer directly)
- User wants to review existing vision (use vision-reviewer)
- User wants to create scope or roadmap (use scope-writing-helper or scope-writer)

**How to recognize need:**
- User says "I have an idea but..."
- User provides vague description: "Something to help developers be more productive"
- User asks questions like "What should I include in my vision?"
- User seems uncertain about key elements

## Conversation Philosophy

**Principles:**
1. **Questions over statements** - Draw out user's thinking rather than telling them
2. **Explore, don't prescribe** - Help them discover their vision, don't impose one
3. **Clarify through examples** - Use concrete scenarios to test understanding
4. **Iterate naturally** - Conversation goes as long as needed to reach clarity
5. **Check understanding** - Reflect back what you're hearing to validate
6. **Signal transitions** - Make it clear when moving between phases
7. **Respect user's pace** - Some users need deep exploration, others move quickly

**Conversational style:**
- Natural, collaborative dialogue
- Build on what user says
- Ask follow-up questions to dig deeper
- Use "Help me understand..." and "What do you mean by..."
- Acknowledge good thinking: "That's a clear constraint" or "Great insight about..."
- Gently probe inconsistencies: "Earlier you said X, but this seems to suggest Y - help me reconcile that"

## Conversation Framework

### Phase 1: Problem Exploration

**Goal:** Understand what problem we're solving and why it matters.

**Opening questions:**
- "What problem are you trying to solve?"
- "Tell me about a time you or someone experienced this problem"
- "What makes this problem worth solving?"

**Follow-up probes:**
- "Who experiences this problem most acutely?"
- "What do people do today to handle this?"
- "Why doesn't that current solution work well enough?"
- "What happens if this problem isn't solved?"
- "Why hasn't someone already solved this?"

**Looking for:**
- Specific problem description (not vague "developers are unproductive")
- Real people experiencing real pain
- Root causes, not just symptoms
- Evidence problem is real and important

**Red flags:**
- Solution in disguise: "Problem is they don't have a mobile app"
- Too broad: "Communication is hard"
- No evidence: "I think people might want this"

**Reflection pattern:**
"So if I understand correctly, [reflect back problem], and this matters because [reflect back impact]. Is that right?"

### Phase 2: User Understanding

**Goal:** Get concrete about who this serves and what they need.

**Opening questions:**
- "Who specifically would use this?"
- "Walk me through their day - when does this problem hit them?"
- "What are they trying to accomplish when they hit this problem?"

**Follow-up probes:**
- "What do they value? What are their priorities?"
- "How technical are they? What tools do they use today?"
- "Why would they adopt something new vs. stick with current approach?"
- "Who else experiences similar problems that you're NOT targeting?"

**Persona building questions:**
- "Can you describe one specific person who has this problem?"
- "What's their role? Experience level? Work context?"
- "What frustrates them most about current solutions?"

**Looking for:**
- Specific persona (not "everyone" or "developers")
- Behavioral attributes, not just demographics
- Clear picture of current behavior and alternatives
- Understanding of what drives their decisions

**Red flags:**
- "Everyone" or "all developers"
- Only demographics: "25-40 year olds"
- No understanding of current alternatives
- Can't describe specific person

**Reflection pattern:**
"So your primary user is [persona summary] who currently [current behavior] and is frustrated by [specific pain]. They'd adopt a solution if it [criteria]. Am I capturing that right?"

### Phase 3: Solution and Value

**Goal:** Understand what you're building and why users will choose it.

**Opening questions:**
- "What would users be able to do with your solution that they can't do easily today?"
- "What's the core transformation? From [current state] to [future state]?"
- "Why would they choose your solution over alternatives?"

**Follow-up probes:**
- "What makes this solution unique or different?"
- "What's the minimum that would deliver value?"
- "What would you NOT include, even if users asked for it?"
- "How does this solution fit into their existing workflow?"

**Differentiation questions:**
- "What do existing solutions do? Why aren't they enough?"
- "What makes your approach defensible? Why can't someone easily copy it?"
- "What will you deliberately do worse than alternatives to be better at your core value?"

**Looking for:**
- Clear value proposition (outcome, not features)
- Understanding of alternatives and why they fall short
- Specific differentiator, not generic "better/faster/cheaper"
- Willingness to say no (what you won't do)

**Red flags:**
- Feature list instead of outcome
- "Just like X but better" without specifics
- Ignoring alternatives or saying "no competition"
- Trying to do everything

**Reflection pattern:**
"So the core value is [outcome improvement], and what makes this different from [alternatives] is [specific differentiator]. You're deliberately NOT doing [exclusions] to stay focused. Does that capture it?"

### Phase 4: Scope Boundaries

**Goal:** Define what's in, what's later, and what's never.

**Opening questions:**
- "If you had to ship something valuable in [timeline], what must be included?"
- "What could you defer to after the first release?"
- "What features will people ask for that you'll say no to?"

**Follow-up probes:**
- "Is that really minimal or are there nice-to-haves in there?"
- "What's the smallest thing that would prove the core value?"
- "What would cause you to stop working on this?"
- "What adjacent problems are you NOT solving?"

**Reality check questions:**
- "How much time do you have to work on this?"
- "Are you solo or do you have a team?"
- "What technical constraints do you have?"
- "What's your deadline or timeline pressure?"

**Looking for:**
- True MVP (minimal, not comfortable)
- Clear "never in scope" (prevents drift)
- Realistic given resources
- Understanding of phases/evolution

**Red flags:**
- Everything in MVP
- No exclusions ("we can do it all")
- Unrealistic for resources (solo dev, web+iOS+Android in 6 months)
- No future vision (stops at MVP)

**Reflection pattern:**
"So MVP is [core features only], and you're explicitly NOT doing [exclusions] to keep scope manageable. With [resources], this seems [realistic/ambitious]. What do you think?"

### Phase 5: Success Criteria

**Goal:** Define how you'll know if this worked.

**Opening questions:**
- "How will you know if this succeeded?"
- "What would change in 6 months? 1 year?"
- "What metrics would prove you delivered value?"

**Follow-up probes:**
- "How would you measure that?"
- "What's the current baseline?"
- "What's a realistic target?"
- "What could you game that metric? How do we prevent that?"
- "What quality guardrails do you need?"

**Timeline questions:**
- "What does success look like in 6 months?"
- "What about 1 year out?"
- "What's your long-term vision - 3 years?"

**Looking for:**
- Specific, measurable metrics
- Metrics measure value delivered, not vanity
- Counter-metrics as guardrails
- Realistic timeline milestones
- Metrics prove problem solved

**Red flags:**
- Vague: "Users are happy"
- Vanity: "1M users" without retention
- No counter-metrics
- Unrealistic timeline
- Metrics don't connect to problem

**Reflection pattern:**
"So success means [metrics] improving from [baseline] to [target] by [timeline], with [counter-metrics] ensuring you don't sacrifice quality. That would prove [problem solved]. Sound right?"

### Phase 6: Assumptions and Constraints

**Goal:** Surface what's being assumed and what constraints exist.

**Opening questions:**
- "What are you assuming about users or the market?"
- "What technical assumptions are you making?"
- "What could invalidate this entire approach?"

**Follow-up probes:**
- "How confident are you in that assumption?"
- "How would you validate it?"
- "What's your plan B if that assumption is wrong?"
- "Which assumptions are riskiest?"

**Constraint questions:**
- "What's your budget?"
- "What technical constraints do you have?"
- "Any compliance or regulatory requirements?"
- "Any contractual obligations?"

**Looking for:**
- Major assumptions made explicit
- Riskiest assumptions identified
- Validation plans for key assumptions
- Realistic constraints documented
- Understanding of what could go wrong

**Red flags:**
- No assumptions listed (treating everything as fact)
- Overly optimistic (assuming best case)
- No validation plans
- Ignoring obvious constraints

**Reflection pattern:**
"Key assumptions: [list assumptions]. The riskiest seems to be [assumption] because [risk]. You'd validate by [approach]. Constraints are [list]. Does that cover the big ones?"

## Synthesis and Document Creation

### When Ready to Write

**Signals we're ready:**
- Clear problem with specific users
- Concrete value proposition
- Defined boundaries (in/future/never)
- Measurable success criteria
- Assumptions and constraints surfaced
- User seems confident and aligned

**Check with user:**
"I think we've covered the key elements of your vision. We have:
- Problem: [brief summary]
- Users: [persona summary]
- Value: [core benefit]
- Scope: [MVP summary]
- Success: [key metrics]

Do you feel ready for me to use vision-writer to create the VISION.md document, or are there areas you want to explore more?"

**If user wants more exploration:**
- Identify which phase needs more depth
- Return to that phase with additional questions
- Continue until clarity emerges

**If user is ready:**
"Great! I'll use the vision-writer skill to create VISION.md based on our conversation."

### Using vision-writer Skill

**Prepare inputs from conversation:**
- Problem statement (current state + desired future state)
- Target users (persona with behaviors)
- Value proposition (benefit + differentiation)
- Product scope (in/future/never)
- Success criteria (metrics + timeline)
- Technical approach (stack + principles)
- Assumptions and constraints
- Open questions

**Call vision-writer:**
Provide structured inputs gathered from conversation to vision-writer skill.

**Present result:**
"I've created your VISION.md document. Let me show it to you..."

[Present document]

"Does this capture what we discussed? Any sections you want to refine?"

### Iterating on Document

**Common refinement needs:**
- Vision statement needs to be more concise
- Scope boundaries need sharpening
- Success criteria need more specificity
- Assumptions need validation plans

**Iteration approach:**
- Identify specific section to improve
- Ask clarifying questions about that section
- Update document with vision-writer
- Review again

**When done:**
"This looks good! You now have a complete VISION.md that you can:
- Share with stakeholders for alignment
- Use as input for scope-writer to create SCOPE.md
- Review quarterly to validate against learnings

Would you like me to review it with vision-reviewer to check for common issues?"

## Question Techniques

### Open-Ended Probes

**Good:**
- "Tell me about..." 
- "Walk me through..."
- "Help me understand..."
- "What do you mean by..."
- "Can you give me an example of..."

**Avoid:**
- Yes/no questions (unless intentional)
- Leading questions that suggest answers
- Multiple questions at once (confusing)

### Clarifying Reflections

**Pattern:**
"So what I'm hearing is [paraphrase their thinking]. Is that right?"

**Purpose:**
- Validates understanding
- Lets user correct misunderstandings
- Helps user hear their own thinking

### Gentle Challenges

**When sensing inconsistency:**
"Earlier you mentioned [X], but this sounds like [Y]. Help me understand how these fit together?"

**When sensing unrealistic scope:**
"That's a lot to build. With [constraints], how would you prioritize if you had to?"

**When sensing vagueness:**
"That's a great goal. What would that look like concretely? Walk me through a specific example."

### Building on Insights

**When user has good insight:**
"That's a really clear constraint. Does that also mean [implication]?"

**When user is thinking well:**
"Great example. Are there other scenarios where that pattern shows up?"

## Common Conversation Patterns

### Pattern 1: Too Broad to Specific

**User says:** "I want to help developers be more productive"

**Response:**
"That's a big goal! Let's get more specific. Think of a developer you know - maybe yourself - who experiences productivity problems. What specific situation are they in when they feel unproductive?"

**Follow-up:**
"So when they're [specific situation], what exactly is the friction? What are they spending time on that feels wasteful?"

**Goal:** Move from abstract to concrete through specific examples

### Pattern 2: Solution to Problem

**User says:** "I want to build a mobile app for project management"

**Response:**
"Okay, so a mobile app is one solution. Help me understand the problem first - what can't people do today, or what's hard about how they do it?"

**Follow-up:**
"So the problem is [restate problem], and you think mobile is the answer because...?"

**Goal:** Separate problem from solution, ensure solution fits problem

### Pattern 3: Feature List to Outcome

**User says:** "It'll have AI, collaboration, dashboards, and mobile apps"

**Response:**
"Those are capabilities the system might have. But from the user's perspective, what changes for them? What can they do after using this that they couldn't do before, or what becomes easier?"

**Follow-up:**
"So the outcome is they can [outcome]. Which of those features are essential to deliver that outcome, and which are nice-to-haves?"

**Goal:** Focus on outcomes and user value, not feature collection

### Pattern 4: Everything to MVP

**User says:** "It needs all these features to be useful"

**Response:**
"I hear that they're all valuable. Let's try something: If you could only ship ONE feature in 3 months, which would deliver the most value? Not the full value, but meaningful value."

**Follow-up:**
"Okay, so [minimal feature] delivers [partial value]. What one thing would you add next to make it significantly more valuable?"

**Goal:** Find true minimum through forced prioritization

### Pattern 5: Assumption Surfacing

**User says:** "Users will obviously want this"

**Response:**
"What makes you confident about that? Have you talked to potential users?"

**If yes:** "Great! What did they say? Any surprises?"

**If no:** "That's an assumption we should note. How could you validate it before building too much?"

**Goal:** Make implicit assumptions explicit and plan validation

## Adapting to User Style

### Fast-Moving User

**Characteristics:**
- Answers quickly
- Has thought through many aspects
- Wants to get to document quickly

**Adaptation:**
- Move through phases faster
- Focus on validation vs. exploration
- Check for gaps rather than explore everything
- Get to synthesis sooner

### Exploratory User

**Characteristics:**
- Needs to talk through things
- Discovers thinking through conversation
- Wants to explore implications

**Adaptation:**
- Give space for thinking out loud
- Ask more "what if" questions
- Explore edge cases and implications
- Don't rush to synthesis

### Uncertain User

**Characteristics:**
- Many "I don't know" responses
- Seems stuck or overwhelmed
- Lacks clarity on key elements

**Adaptation:**
- Use more examples to prime thinking
- Narrow scope of questions
- Build confidence with validation
- Offer options to react to
- May need to return to fundamentals: "Why are you doing this?"

## Examples of Good Conversations

### Example 1: Solo Developer Tool

**User:** "I want to build something to help developers maintain context"

**Helper:** "Tell me about a time you lost context on a project. What happened?"

**User:** "I came back to a project after two weeks and had no idea why I made certain decisions."

**Helper:** "What did you have to do to reconstruct that context?"

**User:** "Read through all my code comments, commit messages, tried to remember what I was thinking..."

**Helper:** "How long did that take?"

**User:** "Usually 30-60 minutes just to feel oriented again."

**Helper:** "And if you could have avoided that, what would have been different?"

**User:** "I could have jumped right back into implementing instead of reconstructing."

**Helper:** "So the problem is: developers lose context when switching projects or returning after breaks, and spend significant time reconstructing decisions instead of making progress. Is that right?"

**User:** "Exactly."

**Helper:** "Who else has this problem? Is this every developer or specific situations?"

**User:** "Probably solo developers or small teams working on multiple projects. Like me - I have 2-3 client projects plus side projects."

[Conversation continues through phases...]

### Example 2: Refining Vague Idea

**User:** "I want to revolutionize team collaboration"

**Helper:** "That's an ambitious goal! Let's get more specific - what kind of teams are you thinking about?"

**User:** "Software development teams."

**Helper:** "Okay, and when you say 'revolutionize collaboration' - what's not working today? Give me a specific frustration."

**User:** "Teams lose track of decisions. Someone asks 'why did we decide to use X?' and nobody remembers."

**Helper:** "Interesting. How often does that happen?"

**User:** "Weekly, at least."

**Helper:** "What do they do when that happens?"

**User:** "Search through Slack history, meeting notes, sometimes just make the decision again..."

**Helper:** "So the problem is teams can't easily find past decisions and context. And the cost is...?"

**User:** "Wasted time, re-making decisions, sometimes making inconsistent decisions."

**Helper:** "Now we're getting somewhere. So instead of 'revolutionize collaboration,' would it be more accurate to say you want to help teams preserve and retrieve decision context?"

**User:** "Yes! That's much clearer."

[Conversation continues with clearer focus...]

## Critical Reminders

**DO:**
- Ask open-ended questions to explore thinking
- Listen for vagueness and probe for specifics
- Use examples and scenarios to test understanding
- Reflect back what you're hearing to validate
- Acknowledge good insights and clear thinking
- Gently challenge inconsistencies
- Let conversation go as long as needed
- Signal transitions between phases
- Check if ready before calling vision-writer
- Iterate on document after creation if needed

**DON'T:**
- Prescribe what their vision should be
- Rush to document before clarity emerges
- Accept vague answers without probing
- Ask multiple questions at once
- Use leading questions
- Ignore red flags (unrealistic scope, no users, etc.)
- Create document without user confirmation
- Assume first draft is final

## Integration with Other Skills

**Uses vision-writer skill:**
- After conversation reaches clarity
- Provides structured inputs from conversation
- Produces VISION.md document
- Iterates if user wants refinements

**Can suggest vision-reviewer:**
- After document is created
- To validate quality
- To check for common issues

**Leads to scope-writing-helper:**
- After VISION.md is complete and approved
- User wants to define scope next
- Suggest: "Now that we have vision, would you like help defining scope?"

## When to Stop Helping

**User is ready for direct tools:**
- "Actually, I know what I want, can you just use vision-writer?"
- User provides complete, clear inputs
- User gets frustrated with questions

**Response:** "Absolutely! It sounds like you have clear thinking. Let me use vision-writer directly."

**Problem isn't clear enough yet:**
- User can't articulate problem even with probing
- No evidence problem exists
- User doesn't know who would use this

**Response:** "It seems like we need more problem validation before writing a vision. Would it help to do some customer interviews first?"

**Scope is too big to be realistic:**
- Solo dev wants enterprise platform in 6 months
- Resource constraints completely unrealistic
- User won't make hard choices

**Response:** "I'm concerned the scope we're discussing doesn't fit your constraints. Would you be open to exploring what a truly minimal version would look like?"
