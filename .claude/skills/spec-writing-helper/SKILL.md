---
name: spec-writing-helper
description: Guide users through translating roadmap features into detailed behavioral specifications via collaborative conversation, then use spec-writer to create SPEC.md. Use when users have a roadmap feature but need help defining acceptance criteria, interface contracts, and scenarios through dialogue.
---

# Specification Writing Helper

## Overview

Help users transform roadmap features into detailed, testable specifications through guided Socratic conversation, exploring acceptance criteria, interface contracts, edge cases, and scenarios. Once specification is crystallized, use spec-writer skill to produce SPEC.md document.

## When to Use This Skill

**Trigger scenarios:**
- User has ROADMAP.md feature and wants to create SPEC.md but needs help
- User says "I know what to build but need to specify it in detail"
- User unsure about acceptance criteria: "How do I know when it's done?"
- User wants collaborative exploration of edge cases and error handling

**Do NOT use for:**
- User has clear specification and just needs document written (use spec-writer directly)
- User wants to review existing spec (use spec-reviewer)
- User doesn't have roadmap yet (use roadmap-writing-helper first)
- User wants implementation guidance (use skeleton-writer or tdd skill)

**How to recognize need:**
- User has feature but says "Now how do I specify this in detail?"
- User uncertain about edge cases: "What could go wrong?"
- User struggles with testability: "How do I test this?"
- User hasn't thought through error conditions or boundaries

## Conversation Philosophy

**Principles:**
1. **Behavior, not implementation** - Focus on WHAT, not HOW
2. **Testability first** - Every requirement must be verifiable
3. **Scenarios ground abstractions** - Use concrete examples
4. **Error cases equal importance** - Failures matter as much as success
5. **Boundaries reveal edge cases** - Explore min/max/null/empty
6. **Observable outcomes** - Specify what you can see/measure
7. **Interface contracts enable TDD** - Clear signatures drive skeleton creation

**Conversational style:**
- Start by reviewing roadmap feature together
- Use "walk me through" to get concrete scenarios
- Ask "what could go wrong?" to find error cases
- Challenge vagueness: "What specifically do you mean by [term]?"
- Test observability: "How would you demo this?"
- Reality check: "Can you write a test for that?"

## Conversation Framework

### Phase 0: Feature Review

**Goal:** Ensure shared understanding of roadmap feature.

**Opening:**
"Let's review the roadmap feature together before we write the spec. I want to make sure we understand what we're building."

**Review together:**
- Feature name
- Feature description from roadmap
- Why now (sequencing rationale)
- Delivers (value/learning)
- Depends on (prerequisites)
- Effort estimate

**Questions:**
- "Does this feature description still feel right?"
- "Any new insights since planning the roadmap?"
- "What's the core capability this enables?"
- "Who uses this feature and why?"

**Red flags:**
- User no longer aligned with feature goal
- Feature description too vague to specify
- Missing dependencies discovered
- Scope changed significantly

**Transition:**
"Okay, so we're building [feature summary] to [deliver value]. Let's get concrete about exactly what this looks like."

### Phase 1: Define Observable Behavior

**Goal:** Articulate what the feature does from external perspective.

**Opening:**
"Let's describe what this feature DOES - the observable behavior. Not how it works inside, but what someone sees happening."

**Questions to surface behavior:**
- "From a user's perspective, what changes after this feature exists?"
- "If I'm using this, what can I do that I couldn't before?"
- "What's the input? What's the output?"
- "How would you demonstrate this is working?"

**Example dialogue:**

**Helper:** "Your feature is 'Context Linking Engine'. What does that DO for users?"

**User:** "It automatically finds relationships between specs and code."

**Helper:** "Good start. Let's get more specific - what does 'find relationships' mean? What does a user observe?"

**User:** "They can ask 'which code files implement spec X' and get a list."

**Helper:** "Perfect. That's observable. What else can they observe?"

**User:** "The relationships are stored somewhere they can query them."

**Helper:** "Where stored? How do they query?"

**User:** "In SYSTEM_MAP.md. They can read that file or use a CLI command."

**Helper:** "Excellent. So observable behaviors: (1) CLI query returns code files for a spec, (2) SYSTEM_MAP.md contains the mapping. Anything else?"

**Looking for:**
- External, observable behaviors
- User-facing capabilities
- Measurable outcomes
- No implementation details (algorithms, data structures)

**Red flags:**
- Implementation leaking: "Uses HashMap" or "Scans with regex"
- Vague: "Better experience" or "Improved performance"
- Internal state: "Builds a graph" (unless graph is observable)

**Output:**
- 3-5 observable behaviors stated clearly
- User perspective maintained
- No HOW, only WHAT

### Phase 2: Define Feature Scope Boundaries

**Goal:** Establish what's included, excluded, and deferred.

**Opening:**
"Now let's set clear boundaries. What's definitely IN this feature, what's explicitly OUT, and what might be deferred?"

**Questions:**
- "What's the minimal core capability?"
- "What related things are NOT in this feature?"
- "Are there nice-to-haves we might defer?"
- "Where do you draw the line?"

**Example dialogue:**

**Helper:** "For Context Linking Engine - what's definitely included in this feature?"

**User:** "Detecting links from code to specs, storing in SYSTEM_MAP.md, CLI to query."

**Helper:** "Good. What about the reverse - specs to tests? Included?"

**User:** "Yes, that's in scope."

**Helper:** "What's explicitly OUT of scope for this feature?"

**User:** "Hmm... maybe real-time monitoring? Like watching for file changes?"

**Helper:** "Good exclusion. What else?"

**User:** "GUI visualization of links. That's Phase 2."

**Helper:** "And nice-to-haves that might be deferred?"

**User:** "Maybe confidence scoring on detected links? Like 'this link is 95% certain'."

**Looking for:**
- Core included (3-5 items)
- Explicit exclusions (3-5 items with rationale)
- Deferred enhancements (2-3 items)
- Clear boundaries

### Phase 3: Define Interface Contracts

**Goal:** Specify exact function/class signatures with types.

**Opening:**
"Let's define the interface - the functions or classes and their exact signatures. This is what skeleton-writer will create and tests will verify."

**Questions for each interface:**
- "What functions or classes does this feature provide?"
- "For each function - what are the parameters and types?"
- "What does it return?"
- "What exceptions can it raise?"
- "What must be true before calling? (preconditions)"
- "What's guaranteed after? (postconditions)"

**Example dialogue:**

**Helper:** "What's the main interface for Context Linking Engine?"

**User:** "A class called LinkingEngine."

**Helper:** "What methods does it have?"

**User:** "A scan() method to find links, and a find_code_for_spec() to query them."

**Helper:** "Let's specify scan(). What parameters?"

**User:** "None? It scans the current project."

**Helper:** "Wait - how does it know which project? Needs project_path parameter?"

**User:** "Oh right, yeah. project_path as a string."

**Helper:** "So: scan(project_path: str). What does it return?"

**User:** "The link mapping."

**Helper:** "What type is that? Dictionary? Custom class?"

**User:** "Dictionary mapping spec IDs to lists of file paths."

**Helper:** "Let's call that type LinkMap. So: scan(project_path: str) -> LinkMap. What exceptions?"

**User:** "If path doesn't exist, InvalidPathError. If no permissions, PermissionError."

**Helper:** "Good. What must be true before calling scan()?"

**User:** "Project path must exist and have a /specs directory."

**Helper:** "That's a precondition. And what's guaranteed after?"

**User:** "Returns complete map of all links, doesn't modify any files."

**Helper:** "Perfect postcondition. Let's do find_code_for_spec() next..."

**Looking for:**
- Complete function signatures with types
- All parameters documented
- Return types specified
- All exceptions documented with trigger conditions
- Preconditions stated
- Postconditions stated
- Example usage for complex interfaces

**Red flags:**
- Missing types (def process(data))
- Vague return type (returns "result")
- Undocumented exceptions
- No preconditions/postconditions

**Output:**
- Complete interface specification per function/class
- Types for all parameters and returns
- All exceptions with conditions
- Pre/postconditions

### Phase 4: Enumerate Acceptance Criteria

**Goal:** Define testable conditions that determine "done".

**Opening:**
"Now let's define acceptance criteria - specific, testable conditions that must be true for this feature to be complete. Each criterion becomes a test."

**Categories to explore:**

**Happy Path (2-5 criteria):**
- "What must work in normal operation?"
- "What's the primary use case?"
- "What would you demo first?"

**Error Handling (3-7 criteria):**
- "What could go wrong?"
- "What errors must be handled gracefully?"
- "What invalid inputs exist?"

**Edge Cases (3-7 criteria):**
- "What about empty input?"
- "What about very large input?"
- "What about special characters?"
- "What are the boundaries?"

**Performance (if applicable):**
- "How fast must it be?"
- "What's acceptable latency?"
- "Resource limits?"

**Example dialogue:**

**Helper:** "Let's start with happy path. What must work for normal usage?"

**User:** "Scanning a project with specs and code files should find the links."

**Helper:** "More specific - make it measurable. How many specs/files? How fast?"

**User:** "Okay: Scanning 10 specs and 20 code files completes in under 5 seconds."

**Helper:** "Perfect - that's testable. What else for happy path?"

**User:** "It detects naming convention links, like spec_001.py linking to feature_001_*.py."

**Helper:** "Good. And decorator detection?"

**User:** "Detects @spec('feature_001') decorators in test files."

**Helper:** "Excellent. Now error handling - what could go wrong?"

**User:** "Project path doesn't exist."

**Helper:** "How should it handle that?"

**User:** "Raise InvalidPathError with a clear message."

**Helper:** "Specific message format?"

**User:** "Something like 'Project path does not exist: /given/path'."

**Helper:** "Perfect. That's testable - we can verify both exception type and message. What other errors?"

**Looking for:**
- Specific, measurable criteria
- Each criterion can become a test
- Grouped by category (Happy/Error/Edge/Performance)
- 10-20 total criteria typically
- No vague language ("works well", "is fast")

**Common issues:**
```
❌ Vague: "System handles input appropriately"
✅ Specific: "Trims whitespace, converts to lowercase, rejects special chars"

❌ Coupled: "Creates user AND sends email AND logs event"
✅ Independent:
  1. Creates user record in database
  2. Sends welcome email
  3. Logs registration event
```

**Output:**
- 10-20 acceptance criteria
- Grouped by category
- Each specific and testable
- Each independent

### Phase 5: Create Concrete Scenarios

**Goal:** Provide Given-When-Then examples that show criteria in action.

**Opening:**
"Let's create concrete scenarios in Given-When-Then format. These show specific examples of the acceptance criteria and become test cases."

**Questions for each scenario:**
- "What's the initial state? (Given)"
- "What action occurs? (When)"
- "What's the outcome? (Then)"
- "Use actual values, not variables"

**Example dialogue:**

**Helper:** "Let's create a scenario for basic link detection. What's the initial state?"

**User:** "Project with a spec file and some code files."

**Helper:** "Be specific - exact filenames and content. What's in the project?"

**User:** "Okay: /specs/feature_001_login.md exists, /src/auth/login.py has comment '# Implements: feature_001', and /tests/test_login.py has decorator @spec('feature_001')."

**Helper:** "Perfect. That's Given. Now When - what action?"

**User:** "Call scan() on the project."

**Helper:** "And Then - what's the exact outcome?"

**User:** "LinkMap contains entry: 'feature_001' → {code: ['src/auth/login.py'], tests: ['tests/test_login.py']}."

**Helper:** "Excellent. Let's write that as a scenario:

**Scenario 1: Basic Link Detection**

**Given:**
- /specs/feature_001_login.md exists
- /src/auth/login.py contains '# Implements: feature_001'
- /tests/test_login.py contains @spec('feature_001')

**When:**
- LinkingEngine('/project').scan() is called

**Then:**
- LinkMap contains 'feature_001' → {code: ['src/auth/login.py'], tests: ['tests/test_login.py']}
- Scan completes in <5 seconds
- No errors or warnings

Sound right?"

**User:** "Perfect."

**Helper:** "Now let's do an error scenario - project path doesn't exist..."

**Looking for:**
- 3-7 scenarios minimum
- Cover happy path, errors, edge cases
- Concrete values (not "user exists", but "alice@example.com exists")
- Given-When-Then format strictly
- Each scenario maps to 1-3 acceptance criteria

**Red flags:**
- Abstract values: "Given user exists"
- Multiple actions in When: "User logs in and creates post"
- Vague outcomes: "Then it works"

**Output:**
- 3-7 concrete scenarios
- Strict Given-When-Then format
- Specific values throughout
- Representative examples

### Phase 6: Define Data Structures

**Goal:** Specify custom types, data models, and structures.

**Opening:**
"Let's define any custom data structures this feature uses - types, classes, or data shapes that need to exist."

**Questions:**
- "What custom types does this feature need?"
- "What's the structure of each type?"
- "What invariants must hold?"
- "What's a concrete example?"

**Example dialogue:**

**Helper:** "We keep mentioning LinkMap. What is that exactly?"

**User:** "A dictionary mapping spec IDs to links."

**Helper:** "What's a link? What fields does it have?"

**User:** "Code files and test files."

**Helper:** "So each spec ID maps to... an object with 'code' and 'tests' fields?"

**User:** "Right. Both are lists of file paths."

**Helper:** "Let's specify that:

**LinkMap: Dictionary[str, LinkEntry]**

**LinkEntry structure:**
```python
{
    'code': List[str],   # Implementing code files
    'tests': List[str]   # Test files
}
```

**Invariants:**
- Spec IDs are non-empty strings
- Lists may be empty but never null
- No duplicate paths within lists

**Example:**
```python
{
    'feature_001': {'code': ['src/auth.py'], 'tests': ['test_auth.py']},
    'feature_002': {'code': [], 'tests': ['test_user.py']}
}
```

Does that capture it?"

**User:** "Exactly."

**Looking for:**
- Every custom type defined
- Structure shown clearly
- Invariants stated explicitly
- Concrete example provided

### Phase 7: Map Dependencies

**Goal:** Identify what this feature depends on.

**Opening:**
"What does this feature depend on - external libraries, internal modules, or assumptions about the environment?"

**Categories:**

**External dependencies:**
- Libraries/frameworks (with versions)
- System requirements

**Internal dependencies:**
- Other features that must exist first
- Configuration or data requirements

**Assumptions:**
- Environment assumptions
- Input assumptions
- Usage assumptions

**Example dialogue:**

**Helper:** "Does Context Linking Engine depend on any external libraries?"

**User:** "No, just Python standard library."

**Helper:** "What about internal dependencies? Other features?"

**User:** "Needs SYSTEM_MAP.md to exist and be writable."

**Helper:** "Any assumptions about project structure?"

**User:** "Yeah - assumes /specs directory exists and uses our naming conventions."

**Helper:** "What conventions specifically?"

**User:** "Specs are named feature_NNN_description.md, code references them with 'feature_NNN'."

**Output:**
- External dependencies listed with versions
- Internal dependencies noted
- Assumptions made explicit

### Phase 8: Identify Constraints and Limitations

**Goal:** Be explicit about what the feature doesn't do or handle.

**Opening:**
"Let's identify constraints and limitations - technical boundaries, known limitations, or things this feature explicitly doesn't handle."

**Questions:**
- "What are the technical limits? (size, performance, scale)"
- "What doesn't this handle that might seem related?"
- "What requires manual intervention?"
- "What could fail under certain conditions?"

**Example dialogue:**

**Helper:** "Are there size or performance limits for the linking engine?"

**User:** "Yeah, probably doesn't scale to huge projects. Maybe limit to 10,000 files?"

**Helper:** "What happens if project has more?"

**User:** "Might be slow or run out of memory."

**Helper:** "That's a limitation. What else doesn't it handle?"

**User:** "It won't detect implicit links - like if code uses a variable name that matches a spec but doesn't explicitly reference it."

**Helper:** "Good. What about accuracy - does it validate links are correct?"

**User:** "No, it just finds references. Doesn't verify the code actually implements what the spec says."

**Output:**
- Technical constraints documented
- Known limitations stated
- Out-of-scope behaviors clarified

### Phase 9: Reality Check Testability

**Goal:** Ensure every requirement can actually be tested.

**Opening:**
"Let's verify everything we've specified is testable. For each acceptance criterion, can you write a test?"

**Check each criterion:**
- "How would you test this?"
- "What's the assertion?"
- "Can you measure/observe this?"
- "Is this independent or coupled?"

**Example dialogue:**

**Helper:** "We have criterion: 'Scans 10 specs + 20 files in <5 seconds'. How do you test that?"

**User:** "Create a test project with 10 specs and 20 files, call scan(), measure elapsed time."

**Helper:** "Good. And the assertion?"

**User:** "Assert elapsed time < 5.0 seconds."

**Helper:** "Perfect - testable. What about: 'Returns complete map'?"

**User:** "Hmm, that's vague."

**Helper:** "Right. What does 'complete' mean specifically?"

**User:** "Every spec that has links is in the map."

**Helper:** "Better. So test by: create project with known links, verify all expected entries in returned map?"

**User:** "Yes."

**Red flags:**
- Vague criteria that can't be measured
- Coupled criteria that can't be tested independently
- Ambiguous success conditions

## Transition to spec-writer

**When conversation complete:**
"Excellent! We have a complete specification outlined. Now I'll use the spec-writer skill to create your formal SPEC.md document with all this captured."

**Then invoke spec-writer with:**
- ROADMAP.md feature entry
- Conversation insights:
  - Observable behaviors
  - Feature scope boundaries
  - Interface contracts
  - Acceptance criteria (grouped)
  - Concrete scenarios
  - Data structures
  - Dependencies
  - Constraints and limitations

## Common Conversation Patterns

### Pattern 1: User describes implementation

**User:** "It uses a HashMap with LRU eviction..."

**Helper:** "Hold on - that's HOW it works internally. Let's focus on WHAT it does externally. From a user's view, what do they observe?"

**User:** "They can store and retrieve session data quickly."

**Helper:** "Good - that's behavior. How quickly?"

**User:** "Sub-millisecond retrieval."

**Helper:** "Perfect. So specification is: 'Retrieves session data in <1ms'. The HashMap is an implementation choice, not a spec."

### Pattern 2: User has vague acceptance criteria

**User:** "System handles errors gracefully."

**Helper:** "What does 'gracefully' mean specifically? What do you observe?"

**User:** "Doesn't crash?"

**Helper:** "Okay, so one criterion: 'Never raises uncaught exceptions'. What else?"

**User:** "Shows helpful error messages."

**Helper:** "Give me an example - what's a helpful message for invalid input?"

**User:** "'Invalid email format: must contain @' for bad emails."

**Helper:** "Perfect. So criterion: 'Returns ValidationError with format guidance for invalid inputs'."

### Pattern 3: User struggles with edge cases

**User:** "I don't know what edge cases to test."

**Helper:** "Let's think boundaries. What's the smallest valid input?"

**User:** "Empty string? No wait, that's invalid."

**Helper:** "Right - so empty string is an edge case to reject. What about single character?"

**User:** "Valid if it's a digit."

**Helper:** "And longest input?"

**User:** "Probably 255 characters max."

**Helper:** "So edge cases: empty (reject), single char (validate type), 255 chars (max valid), 256 chars (reject). What about special characters?"

### Pattern 4: User omits error handling

**User:** "Here's the happy path: user enters email, system validates, creates account."

**Helper:** "Good. Now what goes wrong? What if email already exists?"

**User:** "Oh, should return error."

**Helper:** "What error specifically? Type and message?"

**User:** "DuplicateEmailError with message 'Email already registered: [email]'."

**Helper:** "Perfect. What other errors? Invalid format? Server down? Rate limiting?"

## Red Flags and Interventions

### Red Flag: Implementation details in spec

**Symptom:** User describes algorithms, data structures, libraries

**Intervention:**
"That's implementation - it belongs in code, not specification. Let's focus on observable behavior. From outside the system, what does a user see happening?"

### Red Flag: Untestable criteria

**Symptom:** "System is performant" or "Code is clean"

**Intervention:**
"How would you test that? What's the assertion? Let's make it measurable: 'Response time <200ms' or 'Complexity <10 per function'."

### Red Flag: Missing error cases

**Symptom:** Only happy path specified

**Intervention:**
"What could go wrong? Let's explore error cases: invalid input, missing resources, permission failures, timeouts, rate limits..."

### Red Flag: Vague data structures

**Symptom:** "Returns a result" or "Takes config object"

**Intervention:**
"Let's define that precisely. What fields does the result have? What types? Show me an example with actual values."

### Red Flag: Coupled acceptance criteria

**Symptom:** "System creates user AND sends email AND logs event"

**Intervention:**
"That's three separate criteria that should be tested independently. Let's split them: (1) Creates user, (2) Sends email, (3) Logs event."

## Output Quality Checklist

Before transitioning to spec-writer, verify:

**Behavioral focus:**
- [ ] Describes WHAT, not HOW
- [ ] Observable behaviors specified
- [ ] No implementation details

**Interface contracts:**
- [ ] All functions/classes defined
- [ ] All parameters have types
- [ ] All returns have types
- [ ] All exceptions documented
- [ ] Pre/postconditions stated

**Acceptance criteria:**
- [ ] 10-20 criteria defined
- [ ] Grouped by category
- [ ] Each specific and testable
- [ ] Each independent

**Scenarios:**
- [ ] 3-7 scenarios created
- [ ] Given-When-Then format
- [ ] Concrete values used
- [ ] Cover happy/error/edge

**Data structures:**
- [ ] All custom types defined
- [ ] Structure shown with examples
- [ ] Invariants documented

**Dependencies:**
- [ ] External dependencies listed
- [ ] Internal dependencies noted
- [ ] Assumptions stated

**Completeness:**
- [ ] Happy path covered
- [ ] Error cases covered
- [ ] Edge cases covered
- [ ] Performance criteria (if applicable)

## Related Skills

**Prerequisites:**
- roadmap-writer or roadmap-writing-helper (need ROADMAP.md)

**Next steps:**
- spec-writer (actually writes SPEC.md) ← INVOKE THIS AFTER CONVERSATION
- spec-reviewer (validates completed SPEC.md)

**Downstream:**
- skeleton-writer (creates code structure from spec)
- test-writer (creates tests from spec)
