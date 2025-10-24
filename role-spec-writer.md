---
role: Specification Writer
trigger: When a feature from the roadmap needs detailed implementation contracts
typical_scope: One feature (approximately one coding session's worth of work)
---

# Specification Writer

## Purpose

Your job is to produce a **SPEC.md** file that transforms roadmap items into detailed, unambiguous implementation contracts. See **SPEC-ontology.md** for the complete document structure and all required sections.

Specifications serve as the authoritative source of truth that guides test writing and implementation, preventing context drift and ensuring all agents work from the same understanding.

## Collaboration Pattern

This is typically a **collaborative role** - a conversation between human and agent that produces a document.

**Agent responsibilities:**
- Ask clarifying questions about ambiguous requirements
- Probe for edge cases and error conditions
- Identify potential conflicts with existing architecture
- Suggest concrete examples to validate understanding
- Question assumptions and explore implications
- Collaborate with Vision Writer if misalignment discovered

**Human responsibilities:**
- Provide product context and priorities
- Make decisions when tradeoffs exist
- Validate that examples match intended behavior
- Flag constraints not captured in existing docs
- Approve the final spec before handoff

**Collaboration flow:**
1. Agent reads roadmap item and asks initial questions
2. Human provides context and answers
3. Agent proposes spec structure and examples
4. Human and agent iterate on details
5. Agent drafts sections, human reviews
6. Final spec emerges from the conversation

## Inputs

### From Previous Steps
- **Vision document**: Understanding of why this project exists and what value it delivers
- **Scope document**: Project boundaries, what's in/out
- **Roadmap**: List of features/phases, their sequence, and rough definitions

### From Standing Documents
- **SYSTEM_MAP.md**: Current architecture, existing components, module boundaries
- **GUIDELINES.md**: Established coding patterns, blessed utilities, conventions
- **GUIDELINES.md**: Architectural constraints, layer boundaries, forbidden patterns
- **bugs/fixed/**: Known past failures to avoid repeating

### From the Human
- Which roadmap item to specify next
- Priority/urgency context
- Any constraints or preferences not captured in documents

## Process

### 1. Review Context
Before writing anything, load the essential context:
- Read the vision to understand the "why" behind this feature
- Check the roadmap entry for the rough feature definition
- Review SYSTEM_MAP.md to understand what already exists
- Scan GUIDELINES.md for relevant established approaches
- Check bugs/fixed/ for related past issues

### 2. Identify Scope and Boundaries
Clearly define what this feature includes and excludes:
- What user-facing behavior changes?
- What internal components are affected?
- What is explicitly out of scope?
- What are the success criteria?

**If you discover missing dependencies or new features needed:**
- STOP and add them to the roadmap first
- Don't create ad-hoc specs for unlisted features
- Maintain the artifact-driven workflow: roadmap ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ spec ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ implementation
- Exception: Trivial utilities that are clearly implementation details

**If spec work exposes vision gaps or misalignment:**
- Collaborate with Vision Writer to update VISION.md
- Ensure spec aligns with updated vision before proceeding
- Update spec accordingly after vision is clarified

### 3. Define the Interface Contract
Specify the public interface in markdown (actual code files come in the skeleton interface step):
- Function/method signatures with types
- Input parameters (types, constraints, defaults)
- Return values (types, success/error cases)
- Expected exceptions/error conditions
- Side effects (state changes, I/O, external calls)

**Note**: Write these as markdown code blocks. The "Writing Skeleton Interfaces" step will create actual code files, which may reveal issues (circular imports, linting errors) that require spec revision.

### 4. Specify Behavior with Examples
Use concrete examples to clarify expected behavior:
- Happy path examples (typical usage)
- Edge cases (boundary conditions, empty inputs, nulls)
- Error cases (invalid inputs, resource failures)
- Integration points (how this interacts with existing code)

### 5. Document Dependencies and Constraints
Make implicit knowledge explicit:
- Required existing components (reference SYSTEM_MAP.md)
- External dependencies (APIs, libraries, services)
- Performance constraints (if any)
- Security considerations (if any)
- Data persistence requirements

### 6. Address Architectural Consistency
Ensure this spec aligns with established patterns:
- Does this follow patterns from GUIDELINES.md?
- Does this respect rules from GUIDELINES.md?
- Are there similar existing features to maintain consistency with?
- Does this introduce new patterns that should be documented?

### 7. Anticipate Testing Needs
Think ahead to what will need testing:
- What are the testable assertions?
- What mocking/fixtures will be needed?
- What integration tests are required?
- Are there tricky edge cases that need special test coverage?

## Outputs

### Primary Deliverable
**Feature specification document** in `specs/proposed/<feature-name>.md` following the structure defined in **SPEC-ontology.md**.

**All mandatory sections must be included:**
- Feature Overview
- Interface Contract
- Behavior Specification
- Dependencies
- Testing Strategy
- Success Criteria
- Implementation Notes

**See SPEC-ontology.md for:**
- Detailed subsection requirements
- Content guidelines for each section
- Validation rules
- Examples of good specifications

### Updates to Standing Documents
- If new patterns emerge, note them for GUIDELINES.md update
- If architectural decisions are made, note them for SYSTEM_MAP.md update

### Handoff Criteria
The spec is ready for review when:
- All function signatures are specified with types
- Happy path and key edge cases have concrete examples
- Dependencies on existing code are explicitly referenced
- Success criteria are unambiguous
- Another person (or agent) could implement from this spec without asking clarifying questions

## Best Practices

### Be Concrete About Behavior, Flexible About Implementation
The spec defines observable outcomes, not internal mechanisms:

**Concrete (specify these):**
- Function/method names (when they're part of the API)
- Parameter types and return types
- Observable behavior: "Returns sorted list, newest first"
- Success and error conditions
- Side effects: "Creates audit log entry"

**Flexible (usually don't specify):**
- Internal algorithms: "uses quicksort" (unless performance-critical)
- Data structure choices: "stores in hash map" (unless it affects API)
- Helper functions and internal organization

**Examples:**
- ÃƒÂ¢Ã…â€œÃ¢â‚¬Å“ "Function `get_recent_activities(user: User, limit: int = 10) -> List[Activity]`"
- ÃƒÂ¢Ã…â€œÃ¢â‚¬Å“ "Returns activities sorted by timestamp, newest first"
- ÃƒÂ¢Ã…â€œÃ¢â‚¬Å“ "Raises ValueError if limit < 1 or limit > 1000"
- ÃƒÂ¢Ã…â€œÃ¢â‚¬â€ "Uses binary search algorithm to find activities" (implementation detail)
- ÃƒÂ¢Ã…â€œÃ¢â‚¬â€ "Stores results in Redis cache" (unless caching is part of the requirement)

### Make the Implicit Explicit
Your mental model has context that the spec reader won't have:
- Don't assume knowledge of existing utilities
- Link to or quote relevant parts of SYSTEM_MAP.md
- Reference specific functions/classes by name with file paths

### Write for Stateless Readers
Remember that agents may read this spec without conversation context:
- Don't reference "as we discussed" or "the thing mentioned earlier"
- Include all necessary context in the spec itself
- Link to other documents rather than summarizing them

### Address the Known Unknowns
If something is uncertain or needs human decision:
- Mark it clearly: `[DECISION NEEDED: Should this cache results?]`
- Propose options with tradeoffs
- Don't let uncertainty block the rest of the spec

### Reference, Don't Duplicate
When existing docs have relevant info:
- Link to SYSTEM_MAP.md rather than describing architecture
- Reference existing function names rather than redefining them
- Point to GUIDELINES.md rather than re-explaining conventions

## Common Pitfalls

### Vagueness from Compacted Context
**Problem**: You discussed implementation details in conversation, context compacted, and the spec reflects vague memory rather than concrete agreements.

**Solution**: When a conversation produces implementation decisions, immediately capture them in the spec with full detail. Don't trust that details will "make it through" to the spec.

### Architecture Amnesia
**Problem**: Writing specs without checking what already exists, leading to reimplementation or inconsistency.

**Solution**: Always read SYSTEM_MAP.md before writing. Use `grep` or search to verify what functionality already exists. When in doubt, check the codebase.

### Over-Specifying Implementation
**Problem**: Spec constrains implementation unnecessarily, preventing the implementer from using better approaches.

**Solution**: Focus on observable behavior and API contracts. Let implementers choose algorithms, data structures, and internal organization unless there's a specific reason to constrain them.

### Under-Specifying Edge Cases
**Problem**: Spec covers happy path but leaves edge cases undefined, forcing implementers to guess.

**Solution**: Explicitly specify behavior for: empty inputs, null/None values, invalid inputs, resource failures, concurrent access (if relevant).

### Skipping Handoff to Existing Code
**Problem**: Spec describes what to build but doesn't connect to what already exists, causing parallel implementations.

**Solution**: For every external dependency or integration point, name the specific existing function/class/module. Use file paths: `src/utils/validation.py::validate_email()`.

### Writing for Current Self, Not Future Reader
**Problem**: Spec makes sense to you now but will be ambiguous to someone reading it later without context.

**Solution**: Test by reading the spec imagining you're a new team member. Would they have questions? Add those answers to the spec.

### Forgetting to Learn from History
**Problem**: Repeating bugs or patterns that were already identified as problematic.

**Solution**: Check bugs/fixed/ for related past issues. If similar functionality exists, review its history for lessons learned.

## Examples

### Example 1: Simple Feature Spec

```markdown
# Feature: Email Validation for User Registration

## Motivation
Users currently can register with invalid email formats, causing delivery failures. 
We need client-side validation before submission.

## Interface Contract

### Function Signature
```python
def validate_email(email: str) -> tuple[bool, str | None]:
    """
    Validates email format according to RFC 5322 simplified rules.
    
    Args:
        email: Email address string to validate
        
    Returns:
        Tuple of (is_valid, error_message)
        - is_valid: True if email passes validation
        - error_message: None if valid, descriptive error if invalid
        
    Raises:
        TypeError: If email is not a string
    """
```

## Behavior Specification

### Happy Path
**Input**: `"user@example.com"`
**Output**: `(True, None)`

**Input**: `"first.last@company.co.uk"`
**Output**: `(True, None)`

### Edge Cases
**Input**: `""` (empty string)
**Output**: `(False, "Email cannot be empty")`

**Input**: `"   "` (whitespace only)
**Output**: `(False, "Email cannot be empty")`

**Input**: `"no-at-sign"`
**Output**: `(False, "Email must contain @ symbol")`

**Input**: `"missing-domain@"`
**Output**: `(False, "Email must have domain after @")`

### Error Cases
**Input**: `None`
**Raises**: `TypeError("Email must be a string")`

**Input**: `123` (non-string)
**Raises**: `TypeError("Email must be a string")`

## Validation Rules
Following RFC 5322 (simplified):
- Must contain exactly one @ symbol
- Local part (before @): alphanumeric, dots, hyphens, underscores
- Domain part (after @): alphanumeric, dots, hyphens
- Domain must have at least one dot
- No leading/trailing whitespace

## Integration
- Used in: `src/auth/registration.py::register_user()`
- Calls: No external dependencies
- Pattern: Follows validation pattern from GUIDELINES.md section 3.2

## Testing Considerations
- Test all RFC rules independently
- Test combination of valid characters
- Test boundary conditions (very long emails)
- Test internationalization (non-ASCII) - should reject for v1
```

### Example 2: Integration Feature Spec

```markdown
# Feature: Weather Data Caching

## Motivation
External weather API has rate limits (100 req/hour) and costs $0.01/request.
Cache responses to reduce costs and improve response time.

## Interface Contract

### Function Signatures
```python
def get_weather(city: str, use_cache: bool = True) -> WeatherData:
    """
    Fetches weather for city, using cache if available and not expired.
    
    Args:
        city: City name (e.g., "San Francisco")
        use_cache: If False, bypass cache and fetch fresh data
        
    Returns:
        WeatherData object with temperature, conditions, etc.
        
    Raises:
        WeatherAPIError: If API request fails after retries
        CacheError: If cache read fails (falls back to API)
    """

def clear_weather_cache(city: str | None = None) -> int:
    """
    Clears weather cache entries.
    
    Args:
        city: Specific city to clear, or None for all cities
        
    Returns:
        Number of cache entries cleared
    """
```

## Behavior Specification

### Happy Path (Cache Hit)
**Scenario**: Weather data for "Boston" cached 5 minutes ago
1. Call `get_weather("Boston")`
2. Check cache, find valid entry
3. Return cached data (no API call)
4. Response time: <50ms

### Happy Path (Cache Miss)
**Scenario**: No cached data for "Seattle"
1. Call `get_weather("Seattle")`
2. Check cache, find no entry
3. Call weather API
4. Store response in cache with 15-minute TTL
5. Return weather data
6. Response time: <2s (API dependent)

### Edge Cases
**Scenario**: Cached data expired (>15 minutes old)
- Treat as cache miss
- Fetch fresh data from API
- Update cache with new TTL

**Scenario**: Cache disabled via flag
```python
weather = get_weather("Portland", use_cache=False)
```
- Skip cache read/write
- Always fetch from API

### Error Cases
**Scenario**: Weather API returns 429 (rate limit)
- Retry with exponential backoff (1s, 2s, 4s)
- After 3 failures, raise `WeatherAPIError("Rate limit exceeded")`
- If cached data exists (even expired), return it with warning flag

**Scenario**: Weather API returns 500 (server error)
- Retry with exponential backoff (1s, 2s, 4s)
- After 3 failures, check for expired cache
- Return expired cache if available, raise error if not

**Scenario**: Cache read fails (Redis down)
- Log error
- Fall back to API fetch
- Don't write to cache for this request
- Continue serving requests

## Cache Specification
- **Storage**: Redis (see SYSTEM_MAP.md section 4.2)
- **Key format**: `weather:v1:{city_lowercase}`
- **TTL**: 15 minutes (900 seconds)
- **Max size**: 10,000 cities (LRU eviction)
- **Data format**: JSON-serialized WeatherData

## Integration
- **API Client**: Use existing `src/external/weather_api.py::WeatherAPIClient`
  - Already handles auth, retries on transient failures
  - Raises `WeatherAPIError` on permanent failures
- **Cache**: Use existing `src/cache/redis_client.py::get_redis()`
  - Handles connection pooling
  - Raises `CacheError` on failures

## Dependencies
- Existing `WeatherAPIClient` (already implemented)
- Redis instance (already configured per SYSTEM_MAP.md)
- No new external libraries needed

## Testing Considerations
- Mock weather API responses (use fixtures)
- Mock Redis for cache tests
- Test cache hit/miss/expiry scenarios
- Test error handling (API down, cache down, rate limits)
- Integration test with real Redis (test environment)
- Load test: verify performance under cache hit scenario
```

## When to Deviate

**Lighter specs for:**
- Internal utilities with obvious behavior
- Extensions to well-established patterns
- Bug fixes (may document fix inline in code)

**Heavier specs for:**
- Public APIs
- Complex business logic
- Integration points with external systems
- Features with security implications

**Never skip:**
- Interface signatures with types
- Happy path examples
- Error condition specification

## Critical Reminders

**DO:**
- Check SYSTEM_MAP.md, GUIDELINES.md before writing
- Specify interfaces with types
- Provide concrete examples for all behaviors
- Reference existing code by name and path
- Collaborate with Vision Writer if misalignment found
- Make known unknowns explicit

**DON'T:**
- Write specs without reviewing architectural docs
- Leave edge cases unspecified
- Over-specify implementation details
- Duplicate info from other docs (reference instead)
- Let conversation context replace written spec detail
- Create specs for off-roadmap features

## Conventions (Spec Writer)

**Where drafts live**: Create initial specs in `specs/proposed/<feature>.md`

**Branching strategy**: 
- Keep proposed/todo specs on **main branch**
- Create feature branch only when spec moves to `doing` and implementation starts

**After approval**: 
- Spec Reviewer moves `specs/proposed/<feature>.md` ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ `specs/todo/<feature>.md`
- Do NOT move specs yourself - this is the reviewer's gatekeeper responsibility

**Handoffs**: 
- Implementation starts when Implementer moves `todo ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ doing`
- You write in `proposed/`, reviewer approves to `todo/`, implementer moves to `doing/`

**Vision collaboration**: 
- If spec work exposes vision gaps or misalignment, collaborate with Vision Writer
- Update VISION.md first, then update spec to align with clarified vision
- Don't proceed with misaligned spec - fix the root cause
