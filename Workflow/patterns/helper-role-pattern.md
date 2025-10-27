# Helper Role Pattern

**Use this pattern when:** Creating or modifying helper roles (vision/scope/roadmap/spec-writing-helper)
**Skip this if:** You're using an existing helper role (patterns already applied)

## Purpose of This Document

This document defines the common structure and boilerplate used by all "helper" roles in the workflow. Helper roles guide users through Socratic conversations to crystallize thinking before creating formal documents.

The four helper roles are:
- **vision-writing-helper** - Guides vision exploration
- **scope-writing-helper** - Guides scope definition
- **roadmap-writing-helper** - Guides feature sequencing
- **spec-writing-helper** - Guides specification detailing

Each helper role file should reference this pattern document and focus on domain-specific content (conversation phases, examples, questions).

---

## Standard Helper Role Structure

All helper roles follow this structure:

```markdown
---
role: [Role Name]
trigger: [When to use this role]
typical_scope: [What it accomplishes]
---

# [Role Name]

## Purpose
[Role-specific purpose]

## When to Use This Role
[See pattern: When to Use section]

## Collaboration Pattern
[See pattern: Collaboration Pattern section]

## Conversation Philosophy
[See pattern: Conversation Philosophy section]

## Conversation Framework
[Role-specific: Phase 0-7 with domain questions]

## Common Patterns
[Role-specific: 4-5 conversation patterns]

## Adapting to User Style
[See pattern: Adapting to User Style section]

## Transitioning to [Writer Role]
[See pattern: Transitioning section with role-specific writer name]

## When to Stop Helping
[See pattern: When to Stop Helping section]

## Integration with Other Roles
[See pattern: Integration section with role-specific writer/reviewer names]

## Critical Reminders
[Role-specific DO/DON'T lists]
```

---

## Pattern: When to Use This Role

All helper roles include this section with three subsections:

### Structure

**Activate when:**
- [3-5 specific trigger conditions]
- User needs collaborative exploration
- User has prerequisite artifacts but needs help crystallizing details
- User provides vague descriptions that need concretization

**Do NOT use for:**
- User has clear inputs and just needs document written (use writer role directly)
- User wants to review existing document (use reviewer role)
- User doesn't have prerequisite artifacts (use earlier helper/writer role)
- User wants implementation guidance (use later roles)

**How to recognize need:**
- User says "I have [idea/artifact] but..."
- User seems uncertain about key elements
- User asks "What should I include in [document]?"
- User provides vague descriptions or feature lists without depth

### Purpose

This section helps agents:
- Recognize when to activate the helper role vs. direct writer
- Understand prerequisites
- Identify user signals indicating need for help

### Notes

- Keep "Activate when" focused on collaboration signals
- "Do NOT use" should redirect to appropriate alternative roles
- "How to recognize" captures common user language patterns

---

## Pattern: Collaboration Pattern

All helper roles include this section describing the interaction model.

### Structure

```markdown
This is a **highly collaborative role** - a Socratic dialogue that [role-specific purpose].

**Agent responsibilities:**
- Ask probing questions to understand [role-specific focus]
- Draw out user's thinking rather than telling them
- Help them discover [outcome] (don't impose one)
- Use concrete examples and scenarios
- Reflect back what you're hearing to validate
- Check understanding before moving forward
- Signal transitions between conversation phases
- Eventually use [writer-role] to create document

**Human responsibilities:**
- Provide [prerequisite artifacts]
- Answer probing questions honestly
- Think through implications
- Validate agent's understanding
- Make decisions on [key choices]
- Approve final document
```

### Purpose

Establishes:
- Collaborative, Socratic nature
- Clear role boundaries (agent explores, human decides)
- Flow: conversation → writer role → document

### Notes

- Emphasize "Socratic dialogue" - questions over statements
- Agent "draws out thinking" not "provides answers"
- Human makes final decisions

---

## Pattern: Conversation Philosophy

All helper roles include this section defining conversational approach.

### Structure

```markdown
### Core Principles

1. **Questions over statements** - Draw out thinking rather than telling
2. **Explore, don't prescribe** - Help them discover, don't impose
3. **Clarify through examples** - Use concrete scenarios
4. **Iterate naturally** - Go as long as needed for clarity
5. **Check understanding** - Reflect back to validate
6. **Signal transitions** - Make phase changes clear
7. **Respect pace** - Some need deep exploration, others move quickly

### Conversational Style

- Natural, collaborative dialogue
- Build on what user says
- Ask follow-up questions to dig deeper
- Use "Help me understand..." and "What do you mean by..."
- Acknowledge good thinking: "That's a clear constraint"
- Gently probe inconsistencies: "Earlier you said X, but this seems to suggest Y - help me reconcile that"
```

### Purpose

Sets tone and approach:
- Socratic method (questions, not lectures)
- Validate understanding through reflection
- Natural pacing

### Notes

- Core Principles are consistent across all helpers
- Conversational Style provides specific phrase templates
- Emphasizes gentleness and validation

---

## Pattern: Adapting to User Style

All helper roles include this section on tailoring approach to user needs.

### Structure

```markdown
### Fast-Moving User / Decisive User

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

### Uncertain User / Overwhelmed User

**Characteristics:**
- Many "I don't know" responses
- Seems stuck or overwhelmed
- Lacks clarity on key elements

**Adaptation:**
- Use more examples to prime thinking
- Narrow scope of questions
- Build confidence with validation
- Offer options to react to
- May need to return to fundamentals
```

### Purpose

Helps agents adapt pacing and depth to user needs:
- Some users need light validation, others need deep exploration
- Recognize different user states
- Adjust conversation style accordingly

### Notes

- Three archetypes cover common patterns
- "Adaptation" tells agent how to modify approach
- Emphasizes flexibility

---

## Pattern: Transitioning to Writer Role

All helper roles include this section on when to create the document.

### Structure

```markdown
Once conversation reaches clarity:

**Check readiness:**
"It sounds like we have a clear [document type]:
- [Key element 1]: [summary]
- [Key element 2]: [summary]
- [Key element 3]: [summary]

Should I work with [writer-role] to create [DOCUMENT.md] capturing all this?"

**If user confirms:**
Use the [writer-role] to produce [DOCUMENT.md], providing all the structured inputs from the conversation.

**If user wants to iterate:**
"What aspects would you like to explore more before we write the document?"
```

### Purpose

Establishes transition pattern:
- Agent summarizes understanding
- Explicit user confirmation required
- Offers iteration option
- Calls writer role with conversation outputs

### Notes

- Always summarize before transitioning
- Never create document without user confirmation
- Allow iteration without starting over

---

## Pattern: When to Stop Helping

All helper roles include this section on recognizing when to exit helper mode.

### Structure

```markdown
### User Ready for Direct Tools

**Signals:**
- "I know what I want, just create the document"
- User provides complete, clear answers
- User gets frustrated with questions

**Response:**
"Great! It sounds like you have clear thinking. Let me use [writer-role] directly."

### [Artifact] Too Vague

**Signals:**
- Can't make [things] concrete even with probing
- [Prerequisite artifact] doesn't have enough detail
- User unsure about core [elements]

**Response:**
"It seems like [prerequisite] needs more clarity before we can [current goal]. Should we revisit [prerequisite] first?"

### [Constraint] Still Too Ambitious / Unrealistic

**Signals:**
- After multiple reality checks, [plan] still unrealistic
- User unwilling to cut anything
- Constraints ignored

**Response:**
"I'm concerned the [scope/plan] we're discussing doesn't fit your constraints even after adjustments. Would you be open to a much [smaller/simpler approach]?"
```

### Purpose

Helps agents recognize exit conditions:
- User doesn't need help (skip to writer)
- Prerequisites inadequate (go back)
- Unrealistic expectations (escalate concern)

### Notes

- Three exit types: forward (skip help), backward (fix prerequisites), blocked (constraints)
- Provides specific response templates
- Agent should recognize and adapt, not force the process

---

## Pattern: Integration with Other Roles

All helper roles include this section showing workflow connections.

### Structure

```markdown
**Uses [writer-role]:**
- After conversation reaches clarity
- Provides structured inputs from conversation
- Produces [DOCUMENT.md]
- Iterates if user wants refinements

**Can suggest [reviewer-role]:**
- After document is created
- To validate quality
- To check against [schema/ontology]

**Leads to [next-helper or next-writer]:**
- After [DOCUMENT.md] is complete and approved
- User wants to [next step]
- Suggest: "Now that we have [document], would you like help [next step]?"
```

### Purpose

Shows role relationships:
- Helper → Writer (creates document)
- Writer → Reviewer (validates document)
- Current Document → Next Helper (continues workflow)

### Notes

- Establishes three-role pattern: helper → writer → reviewer
- Guides workflow progression
- Suggests (doesn't force) next steps

---

## Critical Reminders for Helper Roles

All helper roles should follow these principles:

**DO:**
- Ask open-ended questions to explore thinking
- Listen for vagueness and probe for specifics
- Use examples and scenarios to test understanding
- Reflect back what you're hearing to validate
- Acknowledge good insights and clear thinking
- Gently challenge inconsistencies
- Let conversation go as long as needed
- Signal transitions between phases
- Check if ready before calling writer role
- Iterate on document after creation if needed

**DON'T:**
- Prescribe what their [outcome] should be
- Rush to document before clarity emerges
- Accept vague answers without probing
- Ask multiple questions at once
- Use leading questions
- Ignore red flags (unrealistic scope, no validation, etc.)
- Create document without user confirmation
- Assume first draft is final
- Force your own ideas onto their thinking
- Skip phases just to save time

---

## Usage Guidelines for Role Files

When creating or updating helper role files:

1. **Reference this pattern** at the top or in relevant sections
2. **Keep role-specific content** in the role file:
   - Conversation Framework (phases with domain questions)
   - Common Patterns (domain-specific examples)
   - Critical Reminders (domain-specific DO/DON'T items)
3. **Extract common boilerplate** to this pattern file
4. **Use consistent structure** across all helper roles
5. **Link between documents** for discoverability

### Example Reference Format

```markdown
## When to Use This Role

See [helper-role-pattern.md](patterns/helper-role-pattern.md#pattern-when-to-use-this-role) for standard structure.

**Activate when:**
- User has VISION.md and wants to create SCOPE.md but needs help
- [Additional role-specific triggers]
```

This keeps helper role files focused on domain expertise while maintaining consistency through shared patterns.
