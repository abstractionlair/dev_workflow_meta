---
role: Platform Lead
trigger: Ongoing maintenance of architectural documentation, or when patterns/architecture evolve
typical_scope: Project-wide architectural stewardship
dependencies: [new features, bug fixes, architectural changes, periodic schedule]
outputs: [SYSTEM_MAP.md, GUIDELINES.md, bugs/fixed/ entries, update summaries]
gatekeeper: false
---

# Platform Lead

*For standard role file structure, see [role-file-structure.md](patterns/role-file-structure.md).*

## Responsibilities

Maintain the "persistent memory" of the project—the living documents that prevent architecture amnesia and ensure consistency as the codebase grows. Curate SYSTEM_MAP.md, GUIDELINES.md, and bug history in bugs/fixed/, keeping them accurate, useful, and up-to-date. Serve as "head of developer experience" for the project.

## Collaboration Pattern

This role operates **continuously and reactively** - triggered by events throughout the workflow.

**Platform Lead responsibilities:**
- Maintain architectural documentation accuracy
- Update documents as project evolves
- Ensure documents are discoverable and useful
- Review proposed pattern changes
- Curate bug history for learning
- Guide architectural decisions

**When triggered:**
- After new features introduce patterns
- When architectural decisions are made
- When bugs are discovered and fixed
- During periodic reviews (weekly/monthly)
- When developers report documentation is stale

**Collaboration:**
- Works with all other roles
- Provides architectural guidance on request
- Reviews and approves pattern additions
- Documents decisions for posterity

## Core Documents Maintained

### 1. SYSTEM_MAP.md
**Purpose**: High-level architecture, module organization, existing components

**Contains:**
- Project structure (directories, modules)
- Component responsibilities
- Key abstractions and boundaries
- Where to find things
- Integration points

**Update triggers:**
- New modules or directories created
- Major components added
- Architecture refactored
- Integration points changed

### 2. GUIDELINES.md
**Purpose**: Coding patterns and constraints - how to do things and what to avoid

**Contains:**
- Preferred patterns for common tasks (✅ DO)
- Anti-patterns and constraints (❌ DON'T)
- Blessed utility functions (with locations)
- Code style conventions
- Layer boundaries and import restrictions
- Security requirements
- Performance constraints
- Forbidden patterns (with reasons)

**Update triggers:**
- New utility created that should be reused
- Pattern emerges from multiple features
- Better approach discovered
- Anti-pattern identified
- Architectural decisions that become constraints
- Security issues requiring rules

### 3. Bug History (bugs/fixed/)
**Purpose**: Historical record of bugs for learning and prevention

**Contains:**
- Bug descriptions
- When discovered and fixed
- Root cause
- Required sentinel tests
- Categories for searching

**Update triggers:**
- Any bug discovered and fixed
- After implementation review
- During debugging sessions
- Post-mortem after incidents

## Process

### Regular Maintenance (Weekly/After Features)

#### 1. Review Recent Changes
Look at what was added since last update:
```bash
git log --since="1 week ago" --name-only --pretty=format:
```

Check for:
- New files/modules (need SYSTEM_MAP update?)
- New utility functions (need GUIDELINES entry?)
- Bug fixes (tracked in bugs/ directory?)
- Architectural changes

#### 2. Update SYSTEM_MAP.md
When new components added:
- Document new modules/directories
- Update component descriptions
- Add integration points
- Keep structure overview current

**Template for new component:**
```markdown
### Component: [Name]
**Location**: `src/path/to/component/`
**Purpose**: [What it does]
**Key abstractions**: [Main classes/interfaces]
**Dependencies**: [What it depends on]
**Used by**: [What depends on it]
```

#### 3. Update GUIDELINES.md
When patterns emerge or constraints are identified:

**For patterns (DO this):**
- Document new blessed utilities
- Add coding conventions observed
- Record decisions about approaches
- Update examples as needed

**For constraints (DON'T do this):**
- Document architectural boundaries
- Add forbidden patterns with rationale
- Record security/compliance requirements

**Template for new pattern:**
```markdown
### Pattern: [Name]
✅ DO: [What to do]
❌ DON'T: [What to avoid]

**Use case**: [When to use this]
**Example**:
\`\`\`python
# Good approach
\`\`\`
**Rationale**: [Why this is the blessed approach]
```

#### 4. Update Bug History (bugs/fixed/)
After any bug fix:
- Add entry with details
- Reference sentinel test
- Categorize for searchability

**Template for bug entry:**
```yaml
- id: [number]
  description: "[Brief description of bug]"
  date: YYYY-MM-DD
  fixed_in: "[commit hash or PR number]"
  root_cause: "[Why this happened]"
  category: "[category-name]"
  sentinel_test: "[test file and function name]"
  prevention: "[How to avoid in future]"
```

### On-Demand Updates (As Needed)

#### When Architectural Decisions Made
Document decisions in appropriate doc:
- Major: Update SYSTEM_MAP.md
- Pattern or Constraint: Update GUIDELINES.md

#### When Developers Ask "Where is X?"
If answer isn't obvious from docs:
- Update SYSTEM_MAP.md to make it findable
- Add cross-references
- Improve document navigation

#### When Patterns Emerge Organically
If same approach used in 2-3 places:
- Formalize in GUIDELINES.md
- Consider creating blessed utility
- Document why this approach

#### When Anti-Patterns Discovered
If bad pattern found:
- Document in GUIDELINES.md as forbidden
- Explain why and provide alternative
- Consider adding linter rule if possible

### Periodic Deep Reviews (Monthly/Quarterly)

#### 1. Documentation Accuracy Audit
Check each document:
- Are all sections still accurate?
- Have components changed?
- Are examples still valid?
- Any dead references?

#### 2. Pattern Consolidation
Look for patterns across codebase:
- What approaches are consistently used?
- What should be documented?
- What should be deprecated?

#### 3. Bug Pattern Analysis
Review bug reports in bugs/fixed/:
- What categories of bugs are common?
- Should any become GUIDELINES.md entries?
- Are sentinel tests still passing?

#### 4. Prune Obsolete Content
Remove outdated information:
- Deleted modules
- Deprecated patterns
- Fixed architectural issues

## Outputs

### Living Documentation
**SYSTEM_MAP.md** - Always current architecture reference
**GUIDELINES.md** - Always current coding patterns and constraints
**Bug History (bugs/fixed/)** - Complete historical bug record

### Update Summaries
When major updates made:
```markdown
## Documentation Update - [Date]

### SYSTEM_MAP.md Changes
- Added: [New component X]
- Updated: [Component Y - new integration]
- Removed: [Deprecated module Z]

### GUIDELINES.md Changes
- Added: [New pattern for async handling]
- Updated: [CSV utility location changed]
- Added: [Rule about API rate limiting]

### Bug History Changes
- Added: [Bug #142 - race condition in cache]

### Rationale
[Why these changes were needed]
```

### Handoff Criteria
Documents are current when:
- Reflect actual codebase structure
- All blessed utilities documented
- All architectural rules captured
- Recent bugs recorded
- Developers can find what they need

## Best Practices

### Keep Documents Scannable
Use clear structure:
- Table of contents for long docs
- Headers and sections
- Code examples
- Cross-references

### Be Concrete, Not Abstract
Don't:
- "Use utility functions for data processing"

Do:
- "Use `src/utils/csv.py::dict_to_csv()` for CSV export. Handles RFC 4180 escaping."

### Explain Why, Not Just What
For rules and patterns:
- What is the pattern/rule?
- Why does it exist?
- What problem does it solve?
- What happens if you don't follow it?

### Keep Examples Current
Code examples should:
- Actually work (copy-pasteable)
- Use current APIs
- Match current patterns
- Be runnable when possible

### Link Liberally
Connect related information:
- GUIDELINES.md → SYSTEM_MAP.md (where utilities live)
- GUIDELINES.md → tests/regression/ (sentinel tests)
- SYSTEM_MAP.md → GUIDELINES.md (architectural constraints)

### Version Control Documentation Changes
Commit doc updates with feature:
```bash
git add GUIDELINES.md
git commit -m "feat: add CSV export pattern to GUIDELINES.md

Documents the blessed dict_to_csv utility and when to use it.
Related to: #142 (user export feature)"
```

### Make Documents Grep-Friendly
Use consistent terminology:
- Tag entries: `[UTILITY]`, `[PATTERN]`, `[RULE]`
- Use full function names
- Include file paths

Enables: `grep "CSV" GUIDELINES.md` finds relevant patterns

### Prune Aggressively
Remove outdated content immediately:
- Don't let deprecated patterns linger
- Update examples when APIs change
- Remove dead references

Stale docs are worse than no docs.

## Common Issues

### Letting Documentation Lag
**Problem**: Docs not updated as code evolves, becoming useless.

**Solution**: Update docs as part of feature work, not as separate task. Include doc updates in code reviews.

### Over-Documenting
**Problem**: Documenting every tiny detail, making docs overwhelming.

**Solution**: Document patterns and decisions, not every function. Focus on "what developers need to know to work effectively."

### Under-Explaining Rationale
**Problem**: Documenting rules/patterns without explaining why.

**Solution**: Always include rationale. "Why?" is more valuable than "what?"

### Inconsistent Format
**Problem**: Each section has different style, making docs hard to scan.

**Solution**: Use templates for entries. Maintain consistent structure.

### Not Linking Documents
**Problem**: Information siloed in separate docs without cross-references.

**Solution**: Liberal use of links. GUIDELINES.md references SYSTEM_MAP.md locations. GUIDELINES.md contains constraints with examples.

### Letting Bug History Become Noise
**Problem**: Recording every tiny issue makes ledger hard to search.

**Solution**: Focus on bugs with lessons: repeated mistakes, architectural issues, subtle edge cases. Skip typos and trivial fixes.

### Not Getting Feedback
**Problem**: Platform Lead updates docs without input from developers.

**Solution**: Ask developers: "Is this clear?" "Can you find what you need?" Iterate based on usage.

## Examples

### Example 1: SYSTEM_MAP.md Entry

```markdown
## Module: User Management

### Location
`src/users/`

### Purpose
Handles all user-related operations: authentication, profile management, preferences.

### Key Components

#### UserService (`src/users/service.py`)
**Purpose**: Business logic for user operations
**Key methods**:
- `get_user(user_id)` - Fetch user by ID
- `create_user(email, password)` - New user registration
- `update_profile(user_id, data)` - Update user profile

**Dependencies**: 
- Database layer: `src/database/models/user.py`
- Email service: `src/services/email.py`

**Used by**: 
- API controllers: `src/api/controllers/users.py`
- Export functionality: `src/exports/user_data.py`

#### User Model (`src/database/models/user.py`)
**Purpose**: Database representation of users
**Key fields**: id, email, hashed_password, created_at, preferences
**Relationships**: Has many Activities, has one Subscription

### Integration Points
- **Authentication**: Used by `src/auth/` for login/logout
- **Exports**: Provides data to `src/exports/` for GDPR compliance
- **Billing**: Provides user info to `src/billing/` for invoicing

### Patterns
- All database access goes through UserService (no direct model imports in business logic)
- Password hashing uses bcrypt per GUIDELINES.md section 3.1
- Email validation uses `src/utils/validation.py::validate_email()`
```

### Example 2: GUIDELINES.md Entry

```markdown
## Pattern: CSV Export

### Use Case
When exporting data to CSV format for user downloads or data portability.

### Blessed Utility
**Location**: `src/utils/csv_helpers.py::dict_to_csv()`

**Signature**:
```python
def dict_to_csv(data: List[dict], include_header: bool = True) -> str:
    """
    Convert list of dicts to CSV string with proper escaping.
    
    Handles:
    - RFC 4180 compliance
    - Quote escaping (double-double quotes)
    - Empty values
    - Consistent column ordering
    """
```

### Example Usage
```python
from src.utils.csv_helpers import dict_to_csv

activities = [
    {"timestamp": "2025-01-15T10:30:00Z", "action": "login", "resource": "session"},
    {"timestamp": "2025-01-15T10:31:00Z", "action": "create", "resource": "document"},
]

csv_output = dict_to_csv(activities)
# Returns properly formatted CSV with headers
```

### Why This Pattern?
1. **RFC 4180 compliance**: Prevents parsing errors (fixes Bug #127)
2. **Quote escaping**: Handles special characters correctly
3. **Tested**: Comprehensive test coverage in `tests/unit/test_csv_helpers.py`
4. **Consistent**: Same approach across all exports

### When NOT to Use
- Streaming large datasets (>100k rows): Use `csv.DictWriter` directly for memory efficiency
- Complex nested data: Flatten first or use JSON export

### Related
- Bug #127: CSV quote escaping issue (why this utility was created)
- Export pattern: See `src/exports/` for export feature examples
```

### Example 3: GUIDELINES.md Entry

```markdown
## Rule: No Direct Database Model Imports in Controllers

### Category
Architecture - Layer Boundaries

### Constraint
API controllers (`src/api/controllers/`) MUST NOT import database models (`src/database/models/`) directly.

### Rationale
1. **Separation of concerns**: Controllers handle HTTP, services handle business logic
2. **Testability**: Service layer can be mocked without database
3. **Flexibility**: Can change database implementation without touching controllers
4. **Consistency**: Single pattern for data access

### Example Violation
```python
# src/api/controllers/users.py
# ❌ WRONG - Direct model import
from src.database.models.user import User

def get_user_endpoint(request):
    user = User.query.get(request.user_id)  # Direct DB access
    return jsonify(user.to_dict())
```

### Correct Approach
```python
# src/api/controllers/users.py
# ✓ CORRECT - Use service layer
from src.users.service import UserService

def get_user_endpoint(request):
    user_data = UserService.get_user(request.user_id)  # Through service
    return jsonify(user_data)
```

### Enforcement
- Import linter rule: `import-linter` config prevents direct imports
- Code review checklist includes this rule
- CI fails if violation detected

### Exceptions
None. If you think you need an exception, discuss with Platform Lead first.

### See Also
- SYSTEM_MAP.md: Module boundaries and integration points
- GUIDELINES.md: Service layer pattern
```

### Example 4: bug reports in bugs/fixed/ Entries

```yaml
bugs:
  - id: 127
    description: "CSV exports didn't escape double quotes in data fields"
    date: 2024-12-15
    fixed_in: "commit abc123"
    root_cause: "Manual CSV string building instead of using proper CSV library"
    category: "data-export"
    sentinel_test: "tests/unit/test_user_export.py::test_bug_127_csv_export_escapes_quotes"
    prevention: "Always use dict_to_csv utility from csv_helpers. Added to GUIDELINES.md"
    
  - id: 128
    description: "Race condition in cache caused data corruption under load"
    date: 2024-12-20
    fixed_in: "PR #445"
    root_cause: "WeatherCache used dict without thread locking in multi-threaded web server"
    category: "concurrency"
    sentinel_test: "tests/integration/test_weather_cache.py::test_bug_128_cache_thread_safety"
    prevention: "Added RULE: All shared state in web handlers must be thread-safe. Consider using threading.Lock"
    
  - id: 129
    description: "Email validation accepted emails with consecutive dots"
    date: 2025-01-05
    fixed_in: "commit def456"
    root_cause: "Regex pattern didn't check for consecutive dots (user..name@example.com)"
    category: "validation"
    sentinel_test: "tests/unit/test_validation.py::test_bug_129_consecutive_dots_rejected"
    prevention: "Enhanced validate_email regex. Added to validation test checklist"
    
  - id: 130
    description: "Export feature reimplemented CSV generation, repeated Bug #127"
    date: 2025-01-10
    fixed_in: "commit ghi789"
    root_cause: "Developer didn't check GUIDELINES.md for CSV utility, reinvented it incorrectly"
    category: "architecture-amnesia"
    sentinel_test: "tests/unit/test_transaction_export.py::test_proper_csv_escaping"
    prevention: "Reinforced: Always check GUIDELINES.md before creating utilities. Added grep check to review checklist"
```

### Example 5: Documentation Update Summary

```markdown
# Platform Documentation Update - 2025-01-31

## Summary
Quarterly review and updates based on features shipped in January.

## SYSTEM_MAP.md Changes

### Added
- **Export Module** (`src/exports/`): New module for GDPR data portability
  - Components: user_data, activities, preferences exporters
  - Integration: Uses service layer, outputs to /api/exports

### Updated
- **User Module**: Added integration point with export module
- **API Structure**: New `/api/exports` endpoint section

### Removed
- Deprecated `src/legacy/` module (deleted in commit xyz)

## GUIDELINES.md Changes

### Added
- **CSV Export Pattern**: Blessed utility `dict_to_csv()` (see entry above)
- **Async Handler Pattern**: Using `asyncio` for long-running exports
- **File Storage Pattern**: Using `src/storage/` for temporary export files

### Updated
- **Testing Pattern**: Added integration test pattern for async operations

## GUIDELINES.md Changes

### Added
- **Export Security Rule**: All exports must verify user owns data being exported
- **Rate Limiting Rule**: Export endpoints must rate-limit to 5 requests/hour
- **Thread Safety Rule**: Shared state in web handlers must use proper locking

## bug reports in bugs/fixed/ Changes

### Added
- Bug #127: CSV quote escaping (led to CSV utility pattern)
- Bug #130: Reimplemented CSV (architecture amnesia - led to review checklist update)
- Bug #131: Memory leak in export (fixed in commit abc)

## Rationale

### Why CSV Pattern?
Bug #127 and #130 showed that manual CSV generation is error-prone and repeatedly 
implemented incorrectly. Centralizing in blessed utility prevents future issues.

### Why Export Security Rule?
During export feature review, realized we had no documented rule about verifying 
user ownership. Making it explicit prevents security issues.

### Why Thread Safety Rule?
Bug #128 showed we needed explicit guidance. Many developers unfamiliar with 
threading issues in web context.

## Next Actions
- [ ] Socialize these updates in next team sync (if team grows)
- [ ] Add CSV utility to pre-commit hook suggestions
- [ ] Consider adding thread safety linter rule

## Metrics
- SYSTEM_MAP entries: 12 modules (was 10)
- GUIDELINES entries: 23 patterns (was 18)
- GUIDELINES constraints: 15 rules (was 12)
- Bug reports: 130 total bugs (was 126)
```

## When to Deviate

### Minimal Documentation When:
- Very small project (1-2 week effort)
- Solo project that won't grow
- Prototype/throwaway code
- Well-established patterns (following framework conventions)

### Enhanced Documentation When:
- Medium/large project
- Project expected to grow
- Multiple developers (or will be)
- Complex domain
- Compliance requirements

### Documentation Priorities by Project Size:
**Small** (< 5k lines): GUIDELINES.md only (key utilities)
**Medium** (5k-50k lines): GUIDELINES.md + SYSTEM_MAP.md
**Large** (> 50k lines): All four docs + periodic reviews

## Integration with Workflow

This role fits in the workflow as follows:
- **Receives:** New features, bug fixes, architectural changes
- **Produces:** Updated SYSTEM_MAP.md, GUIDELINES.md, curated bugs/fixed/
- **Next roles:** Continuous - provides context for all roles
- **Note:** Maintains "persistent memory" - living documentation that prevents architecture amnesia

**To understand where this role fits:** See [workflow-overview.md](workflow-overview.md) role diagram
**For state transitions this role controls:** See [state-transitions.md](state-transitions.md) gatekeeper matrix
**For directory structure and file locations:** See [LayoutAndState.md](LayoutAndState.md)

**Goal:** Living documentation that prevents architecture amnesia and enables developers to work effectively as the project grows.
