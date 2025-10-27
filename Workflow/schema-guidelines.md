# GUIDELINES Ontology

## Purpose

This document defines the canonical structure, content, and semantics of the GUIDELINES.md file. GUIDELINES.md is a living document that codifies coding conventions, architectural patterns, and development standards that emerge as a project evolves.

This schema serves as the authoritative reference for:
- **platform-lead** (producer/maintainer): What to include in guidelines
- **skeleton-writer** (consumer): Patterns to follow when creating interfaces
- **test-writer** (consumer): Testing standards and conventions
- **implementer** (consumer): Coding patterns and constraints to respect
- **All reviewers** (consumers): Standards to enforce during reviews
- **spec-writer** (consumer): Architectural patterns to reference in specs

## Document Type

**Format:** Markdown (.md)
**Producer:** platform-lead (creates initial version)
**Maintainers:** platform-lead (approves updates), implementer (proposes patterns)
**Primary Consumers:** skeleton-writer, test-writer, implementer
**Secondary Consumers:** All reviewer roles, spec-writer, stakeholders

## File Location

**Path:** `/GUIDELINES.md` (project root)

**Rationale:** Root location makes it easy to find and reference from any part of codebase

**Single file:** Unlike specs (many files), guidelines are one living document

## Document Evolution

**Lifecycle:**
- **Initial creation**: platform-lead creates stub during living documentation setup
- **Continuous evolution**: Updated as patterns emerge during implementation
- **Version tracking**: Track major changes in Git commit history

**Update triggers:**
- Pattern emerges after 3rd occurrence (Rule of Three)
- Bug reveals anti-pattern worth documenting
- Architectural constraint established
- Performance requirement identified
- Security vulnerability pattern discovered
- Team agrees on new convention

**Update approval:**
- platform-lead must approve all GUIDELINES.md changes
- Changes proposed via feature branch (like code changes)
- Living doc updates reviewed before merge

---

## Required Structure

### Document Header

```markdown
# Development Guidelines: [Project Name]

**Purpose:** Codify conventions, patterns, and constraints for [Project Name]

**Last Updated:** [ISO 8601 date]
**Version:** [Semantic version]
```

**Field Definitions:**

#### Project Name
- Matches VISION.md project name
- Provides context for guidelines

#### Last Updated
- ISO 8601 date (e.g., `2025-10-23`)
- Tracks currency of guidelines

#### Version
- Semantic versioning (1.0, 1.1, 2.0)
- Increment minor version for new patterns
- Increment major version for breaking convention changes

---

## Section 1: Code Organization

```markdown
## Code Organization

### Directory Structure

```
[project-specific directory tree]
```

### Module Responsibilities

**[Module 1]:**
- [Responsibility 1]
- [Responsibility 2]

**[Module 2]:**
- [Responsibility 1]
- [Responsibility 2]
```

**Purpose:** Define where code lives and what each module does

**Content Requirements:**
- Visual directory tree showing key directories
- Description of each major module's responsibilities
- Clear boundaries between modules
- Examples of what belongs where

**Example:**

```markdown
## Code Organization

### Directory Structure

```
src/
├── routes/          # API endpoint definitions (Express routes)
├── controllers/     # Request/response handling (thin layer)
├── services/        # Business logic (core application logic)
├── models/          # Data models (domain entities)
├── repositories/    # Data access layer (database queries)
├── middleware/      # Express middleware (auth, logging, error handling)
└── utils/           # Shared utilities (helpers, formatters, validators)

tests/
├── unit/           # Isolated unit tests (mocked dependencies)
├── integration/    # API integration tests (full request/response cycle)
└── regression/     # Bug sentinel tests (prevent recurrence)
```

### Module Responsibilities

**routes/:**
- Define API endpoints and HTTP methods
- Wire controllers to routes
- Apply route-level middleware
- NO business logic

**controllers/:**
- Parse request data
- Call service layer
- Format responses
- Handle HTTP-level errors
- NO direct database access

**services/:**
- Implement business logic
- Orchestrate data operations via repositories
- Enforce business rules
- NO HTTP concerns (req/res objects)

**repositories/:**
- Execute database queries
- Map between database and domain models
- Handle transactions
- NO business logic

**middleware/:**
- Authentication/authorization
- Request logging
- Error handling
- Input validation
- NO business logic

**utils/:**
- Pure functions (no side effects when possible)
- Shared helpers used across modules
- Validators, formatters, calculators
```

---

## Section 2: Naming Conventions

```markdown
## Naming Conventions

### Files
[Language-specific file naming patterns]

### Functions/Methods
[Language-specific function naming patterns]

### Classes
[Language-specific class naming patterns]

### Variables
[Language-specific variable naming patterns]

### Constants
[Language-specific constant naming patterns]
```

**Purpose:** Ensure consistent naming across codebase

**Content Requirements:**
- Naming pattern for each code element type
- Language-specific conventions (camelCase, snake_case, etc.)
- Examples of good names
- Counter-examples of bad names
- Rationale for conventions

**Example:**

```markdown
## Naming Conventions

### Files
- **Pattern:** `kebab-case.{ext}`
- **Examples:**
  - `user-service.js`
  - `email-validator.js`
  - `payment-gateway-client.js`
- **Why:** Consistent with Unix/Linux conventions, avoids case-sensitivity issues

### Functions/Methods
- **Pattern:** `camelCase` verbs describing actions
- **Examples:**
  - `createUser()`
  - `validateEmail()`
  - `calculateTotalPrice()`
- **Avoid:**
  - `user()` - not a verb
  - `process()` - too generic
  - `doStuff()` - unclear intent

### Classes
- **Pattern:** `PascalCase` nouns
- **Examples:**
  - `UserService`
  - `EmailValidator`
  - `PaymentGatewayClient`
- **Avoid:**
  - `userservice` - wrong case
  - `Manager` - too generic
  - `Helper` - vague purpose

### Variables
- **Pattern:** `camelCase` nouns
- **Examples:**
  - `userName`
  - `totalPrice`
  - `isAuthenticated` - boolean (is/has prefix)
- **Avoid:**
  - `u` - too short
  - `theUserName` - unnecessary article
  - `user_name` - wrong convention for JavaScript

### Constants
- **Pattern:** `UPPER_SNAKE_CASE`
- **Examples:**
  - `MAX_LOGIN_ATTEMPTS`
  - `DEFAULT_TIMEOUT_MS`
  - `API_BASE_URL`
- **Why:** Visually distinct from variables, indicates immutability

### Test Names
- **Pattern:** Descriptive sentence in snake_case or spaces
- **Examples:**
  - `test_create_user_with_valid_data_succeeds()`
  - `"should reject duplicate emails with error"`
- **Why:** Tests are documentation; name should explain what's being tested
```

---

## Section 3: Coding Patterns

```markdown
## Coding Patterns

### Pattern 1: [Pattern Name]

✓ **Do:** [Description]
```[language]
[Good example]
```

❌ **Don't:** [Description]
```[language]
[Bad example]
```

**Why:** [Rationale]

**Related bugs:** [Links to bugs that motivated this pattern]
```

**Purpose:** Document proven patterns and anti-patterns

**Content Requirements:**
- Pattern name (clear, memorable)
- Do example (correct way)
- Don't example (incorrect way)
- Rationale explaining why
- Link to related bugs if pattern emerged from bug fix

**Quality Standard:**
- Rule of Three: Don't add pattern until seen 3 times
- Concrete examples, not abstract descriptions
- Clear rationale tied to project context

**Example:**

```markdown
## Coding Patterns

### Pattern 1: Validate Empty/Null First

✓ **Do:** Check for empty/null before other validations
```javascript
function validateEmail(email) {
    if (!email || email.trim() === '') {
        throw new ValidationError('Email cannot be empty');
    }

    if (!email.includes('@')) {
        throw new ValidationError('Email must contain @ symbol');
    }

    return true;
}
```

❌ **Don't:** Check format before checking empty
```javascript
function validateEmail(email) {
    if (!email.includes('@')) {  // Throws if email is null/undefined
        throw new ValidationError('Email must contain @ symbol');
    }

    if (!email || email.trim() === '') {
        throw new ValidationError('Email cannot be empty');
    }

    return true;
}
```

**Why:** Empty/null checks prevent cryptic errors. Format validation on null/undefined throws confusing errors or behaves unexpectedly.

**Related bugs:** bugs/fixed/validation-empty-email.md

---

### Pattern 2: Dependency Injection via Constructor

✓ **Do:** Inject dependencies through constructor
```javascript
class UserService {
    constructor(userRepository, emailService, passwordHasher) {
        this.userRepository = userRepository;
        this.emailService = emailService;
        this.passwordHasher = passwordHasher;
    }

    async createUser(email, password) {
        const hashedPassword = this.passwordHasher.hash(password);
        const user = await this.userRepository.save({email, hashedPassword});
        await this.emailService.sendWelcome(user);
        return user;
    }
}
```

❌ **Don't:** Create dependencies inside class or use globals
```javascript
class UserService {
    async createUser(email, password) {
        const hashedPassword = bcrypt.hash(password);  // Direct import, hard to test
        const user = await db.users.insert({email, hashedPassword});  // Global db
        await sendEmail(user);  // Global function
        return user;
    }
}
```

**Why:**
- Testability: Can inject mocks during testing
- Flexibility: Can swap implementations (e.g., in-memory vs PostgreSQL)
- Explicitness: Dependencies visible in constructor signature

**Example test:**
```javascript
// Easy to test with dependency injection
const mockRepo = { save: jest.fn() };
const mockEmail = { sendWelcome: jest.fn() };
const mockHasher = { hash: jest.fn(() => 'hashed') };

const service = new UserService(mockRepo, mockEmail, mockHasher);
await service.createUser('test@example.com', 'password');

expect(mockRepo.save).toHaveBeenCalled();
```

---

### Pattern 3: Error Response Structure

✓ **Do:** Use consistent error response format
```javascript
function createErrorResponse(code, message, details = {}) {
    return {
        error: {
            code,
            message,
            details,
            timestamp: new Date().toISOString()
        }
    };
}

// Usage
res.status(400).json(createErrorResponse(
    'INVALID_EMAIL',
    'Email format is invalid',
    { field: 'email', value: userInput }
));
```

❌ **Don't:** Inconsistent error formats
```javascript
// Inconsistent formats across different endpoints
return { error: 'Invalid email' };  // Just string
return { message: 'Invalid email' };  // Different key
return { err: { msg: 'Invalid email' } };  // Different structure
```

**Why:** Consistent error format makes client error handling predictable and reliable

**Standard error codes:**
- `VALIDATION_ERROR` - Input validation failed
- `NOT_FOUND` - Resource doesn't exist
- `UNAUTHORIZED` - Authentication required
- `FORBIDDEN` - Authenticated but insufficient permissions
- `CONFLICT` - Resource already exists
- `INTERNAL_ERROR` - Server error
```

---

## Section 4: Testing Standards

```markdown
## Testing Standards

### Coverage Requirements
[Coverage thresholds and measurement]

### Test Structure
[Arrange-Act-Assert or Given-When-Then patterns]

### Naming Conventions
[Test naming patterns]

### Test Independence
[Rules for test isolation]

### Assertion Style
[Preferred assertion patterns]
```

**Purpose:** Define quality bar for tests

**Content Requirements:**
- Coverage thresholds (line, branch, function)
- Test structure patterns (AAA, GWT)
- Naming conventions for test files and test cases
- Independence requirements
- Assertion best practices
- Mock/stub guidelines

**Example:**

```markdown
## Testing Standards

### Coverage Requirements
- **Minimum line coverage:** 80%
- **Minimum branch coverage:** 70%
- **Measurement:** `npm run test:coverage`

```bash
$ npm run test:coverage
PASS  tests/services/user-service.test.js
  UserService
    ✓ creates user with valid data (23ms)
    ✓ rejects duplicate email (15ms)

Coverage summary:
  Lines      : 87.5% (70/80)
  Branches   : 75% (30/40)
  Functions  : 90% (18/20)
```

**Below threshold:** Fix before merging

---

### Test Structure

**Pattern:** Arrange-Act-Assert (AAA)

```javascript
describe('UserService.createUser', () => {
    it('should create user with hashed password', async () => {
        // Arrange: Set up test data and mocks
        const userRepo = { save: jest.fn(user => ({ ...user, id: 123 })) };
        const emailService = { sendWelcome: jest.fn() };
        const hasher = { hash: jest.fn(() => 'hashed_password') };
        const service = new UserService(userRepo, emailService, hasher);

        // Act: Execute the code being tested
        const result = await service.createUser('test@example.com', 'plain_password');

        // Assert: Verify expected outcomes
        expect(result.id).toBe(123);
        expect(hasher.hash).toHaveBeenCalledWith('plain_password');
        expect(userRepo.save).toHaveBeenCalledWith(
            expect.objectContaining({ password: 'hashed_password' })
        );
    });
});
```

---

### Test Independence

**Rules:**
- ✓ Each test can run in isolation
- ✓ Tests can run in any order
- ✓ No shared mutable state between tests
- ✗ Don't depend on execution order
- ✗ Don't modify shared fixtures

**Example:**

```javascript
// ✓ Good: Each test creates its own data
describe('UserRepository', () => {
    beforeEach(async () => {
        await db.users.deleteAll();  // Clean slate each test
    });

    it('saves user to database', async () => {
        const user = { email: 'test@example.com' };  // Test-specific data
        const saved = await repo.save(user);
        expect(saved).toHaveProperty('id');
    });

    it('finds user by email', async () => {
        const user = { email: 'find@example.com' };  // Different data
        await repo.save(user);
        const found = await repo.findByEmail('find@example.com');
        expect(found.email).toBe('find@example.com');
    });
});

// ❌ Bad: Tests depend on execution order
describe('UserRepository', () => {
    let savedUser;

    it('saves user to database', async () => {
        savedUser = await repo.save({ email: 'test@example.com' });
    });

    it('finds saved user', async () => {
        // Fails if previous test didn't run or failed
        const found = await repo.findByEmail(savedUser.email);
        expect(found.id).toBe(savedUser.id);
    });
});
```

---

### Assertion Quality

**Best practices:**
- ✓ Specific assertions (exact values when possible)
- ✓ Clear failure messages
- ✓ Test one concept per test
- ✗ Avoid vague assertions (`toBeTruthy`, `toBeDefined` when more specific available)

```javascript
// ✓ Good: Specific assertion
expect(user.status).toBe('active');

// ❌ Bad: Vague assertion
expect(user.status).toBeTruthy();  // Could be 'active', 'pending', 1, 'yes', etc.

// ✓ Good: Custom failure message
expect(response.statusCode).toBe(201, 'User creation should return 201 Created');

// ✓ Good: Test one concept
it('should reject empty email', () => {
    expect(() => validateEmail('')).toThrow('Email cannot be empty');
});

it('should reject email without @ symbol', () => {
    expect(() => validateEmail('notanemail')).toThrow('Email must contain @');
});

// ❌ Bad: Testing multiple concepts
it('should validate email', () => {
    expect(() => validateEmail('')).toThrow();
    expect(() => validateEmail('notanemail')).toThrow();
    expect(() => validateEmail('test@example.com')).not.toThrow();
    // If first assertion fails, others don't run - harder to debug
});
```
```

---

## Section 5: Architectural Constraints

```markdown
## Architectural Constraints

### Layer Boundaries

**Rule:** [Constraint description]

✓ **Allowed:**
```[language]
[Allowed import example]
```

❌ **Forbidden:**
```[language]
[Forbidden import example]
```

**Why:** [Rationale]

---

### Dependency Rules

[Import restrictions, module boundaries]

---

### Data Flow

[How data should flow through layers]
```

**Purpose:** Enforce architectural decisions

**Content Requirements:**
- Clear layer definitions
- Import restrictions
- Data flow patterns
- Rationale for each constraint
- Examples of violations

**Example:**

```markdown
## Architectural Constraints

### Layer Boundaries

**Rule:** Services cannot import from controllers

✓ **Allowed:**
```javascript
// services/user-service.js
import { UserRepository } from '../repositories/user-repository.js';
import { EmailService } from './email-service.js';
import { PasswordHasher } from '../utils/password-hasher.js';

class UserService {
    constructor(userRepo, emailService, hasher) {
        // Dependencies injected
    }
}
```

❌ **Forbidden:**
```javascript
// services/user-service.js
import { UserController } from '../controllers/user-controller.js';  // ✗ WRONG

// Services should not know about HTTP layer
```

**Why:** Services contain business logic that should be reusable across different interfaces (HTTP API, CLI, background jobs). Importing controllers couples services to HTTP concerns.

---

**Rule:** Repositories cannot contain business logic

✓ **Allowed:**
```javascript
// repositories/user-repository.js
class UserRepository {
    async save(user) {
        return await db.users.insert(user);  // Pure data access
    }

    async findByEmail(email) {
        return await db.users.findOne({ email });  // Query execution
    }
}
```

❌ **Forbidden:**
```javascript
// repositories/user-repository.js
class UserRepository {
    async save(user) {
        // ✗ Business logic doesn't belong here
        if (await this.findByEmail(user.email)) {
            throw new Error('Email already exists');
        }

        // ✗ Password hashing is business logic
        user.password = await bcrypt.hash(user.password, 10);

        return await db.users.insert(user);
    }
}
```

**Why:** Repositories should be thin data access layer. Business rules (duplicate checks, validation, hashing) belong in services. Keeps repositories reusable and testable.

---

### Dependency Rules

**Rule:** No circular dependencies

```javascript
// ✗ FORBIDDEN
// user-service.js imports auth-service.js
// auth-service.js imports user-service.js
// Creates circular dependency
```

**Detection:**
```bash
$ npm run lint:deps
Error: Circular dependency detected
  user-service.js → auth-service.js → user-service.js
```

**Solution:** Extract shared logic to separate module or use dependency injection

---

**Rule:** No direct database imports in non-repository modules

✓ **Allowed:**
```javascript
// repositories/user-repository.js
import db from '../db.js';  // Repository layer only
```

❌ **Forbidden:**
```javascript
// services/user-service.js
import db from '../db.js';  // ✗ Services use repositories, not db directly

// controllers/user-controller.js
import db from '../db.js';  // ✗ Controllers use services, not db directly
```

**Why:** Centralize data access in repository layer for consistency, testability, and migration ease
```

---

## Section 6: Security Requirements

```markdown
## Security Requirements

### Authentication/Authorization
[Auth patterns and requirements]

### Input Validation
[Validation requirements]

### Data Sanitization
[Sanitization patterns]

### Sensitive Data Handling
[How to handle secrets, PII, etc.]

### Security Headers
[Required HTTP headers]
```

**Purpose:** Document security standards

**Content Requirements:**
- Authentication patterns
- Authorization checks
- Input validation requirements
- Output sanitization
- Sensitive data handling
- Security headers
- Common vulnerabilities to avoid

**Example:**

```markdown
## Security Requirements

### Input Validation

**Rule:** Validate and sanitize ALL user input

✓ **Do:** Validate before processing
```javascript
function createUser(req, res) {
    const { email, password, name } = req.body;

    // Validate email format
    if (!isValidEmail(email)) {
        return res.status(400).json({ error: 'Invalid email format' });
    }

    // Validate password strength
    if (password.length < 8) {
        return res.status(400).json({ error: 'Password too short' });
    }

    // Sanitize name (strip HTML tags)
    const sanitizedName = sanitizeHTML(name);

    // Proceed with validated input
    userService.createUser(email, password, sanitizedName);
}
```

❌ **Don't:** Trust user input directly
```javascript
function createUser(req, res) {
    // ✗ No validation - accepting any input
    userService.createUser(req.body.email, req.body.password, req.body.name);
}
```

**Required validations:**
- Email: Format check, length limit (254 chars)
- Passwords: Minimum 8 characters, complexity requirements
- User input strings: Sanitize HTML, length limits
- IDs: Format validation (UUID, integer, etc.)

---

### Sensitive Data Handling

**Rule:** Never log passwords or tokens

❌ **Forbidden:**
```javascript
logger.info('User login:', { email, password });  // ✗ Password in logs
logger.debug('Auth token:', token);  // ✗ Token in logs
```

✓ **Allowed:**
```javascript
logger.info('User login attempt:', { email });  // Password omitted
logger.debug('Auth token validated');  // Token omitted, just result
```

---

**Rule:** Hash passwords with bcrypt (cost factor 10)

✓ **Required:**
```javascript
const bcrypt = require('bcrypt');
const SALT_ROUNDS = 10;

async function hashPassword(plaintext) {
    return await bcrypt.hash(plaintext, SALT_ROUNDS);
}

async function verifyPassword(plaintext, hash) {
    return await bcrypt.compare(plaintext, hash);
}
```

❌ **Forbidden:**
```javascript
// ✗ Don't use weak hashing
const hash = crypto.createHash('md5').update(password).digest('hex');

// ✗ Don't store passwords in plain text
user.password = password;
```

---

### Authorization Checks

**Rule:** Check authorization on every protected endpoint

✓ **Required:**
```javascript
app.get('/api/users/:id', authenticateToken, async (req, res) => {
    const userId = req.params.id;

    // Check user can only access their own data
    if (req.user.id !== userId && !req.user.isAdmin) {
        return res.status(403).json({ error: 'Forbidden' });
    }

    const user = await userService.getUser(userId);
    res.json(user);
});
```

❌ **Forbidden:**
```javascript
app.get('/api/users/:id', authenticateToken, async (req, res) => {
    // ✗ No authorization check - any authenticated user can access any user's data
    const user = await userService.getUser(req.params.id);
    res.json(user);
});
```
```

---

## Section 7: Performance Guidelines

```markdown
## Performance Guidelines

### Response Time Requirements
[Latency targets]

### Optimization Patterns
[Caching, indexing, lazy loading]

### Resource Limits
[Memory, connections, file size]

### Profiling
[How to measure and optimize]
```

**Purpose:** Document performance standards

**Content Requirements:**
- Response time targets
- Optimization patterns
- Resource constraints
- When to optimize
- Profiling tools and techniques

**Example:**

```markdown
## Performance Guidelines

### Response Time Requirements

**Target latencies:**
- API endpoints: <200ms (p95), <500ms (p99)
- Database queries: <50ms (p95)
- External API calls: <1000ms (p95)

**Measurement:**
```bash
$ npm run perf:test
GET /api/users/:id
  p50: 45ms
  p95: 120ms ✓
  p99: 380ms ✓
```

---

### Optimization Patterns

**Pattern: Cache expensive queries**

✓ **Do:** Cache frequently accessed, rarely changing data
```javascript
const cache = new NodeCache({ stdTTL: 300 });  // 5-minute TTL

async function getUser(userId) {
    const cacheKey = `user:${userId}`;

    // Check cache first
    const cached = cache.get(cacheKey);
    if (cached) return cached;

    // Cache miss - fetch from database
    const user = await db.users.findById(userId);

    // Store in cache
    cache.set(cacheKey, user);

    return user;
}
```

**When to cache:**
- Data read frequently (>10x more reads than writes)
- Data changes infrequently
- Query is expensive (>50ms)

**When NOT to cache:**
- Data changes frequently
- Data is user-specific and not shared
- Cache complexity outweighs benefit

---

**Pattern: Batch database queries**

✓ **Do:** Load related data in single query
```javascript
// ✓ Single query with join
async function getUsersWithProjects() {
    return await db.query(`
        SELECT users.*, projects.*
        FROM users
        LEFT JOIN projects ON projects.user_id = users.id
    `);
}
```

❌ **Don't:** N+1 queries
```javascript
// ✗ N+1 problem: 1 query for users + N queries for projects
async function getUsersWithProjects() {
    const users = await db.users.findAll();

    for (const user of users) {
        user.projects = await db.projects.findByUserId(user.id);  // Separate query!
    }

    return users;
}
```

---

**Pattern: Lazy load large data**

✓ **Do:** Load expensive data on-demand
```javascript
class User {
    constructor(data) {
        this.id = data.id;
        this.email = data.email;
        this._projects = null;  // Not loaded yet
    }

    async getProjects() {
        if (!this._projects) {
            this._projects = await db.projects.findByUserId(this.id);
        }
        return this._projects;
    }
}
```
```

---

## Section 8: Error Handling

```markdown
## Error Handling

### Error Types
[Custom error classes]

### Error Propagation
[Try/catch patterns]

### Error Logging
[What to log, how to log]

### User-Facing Errors
[Error message standards]
```

**Purpose:** Standardize error handling

**Content Requirements:**
- Custom error classes
- Error propagation patterns
- Logging standards
- User-facing error messages
- Error recovery patterns

**Example:**

```markdown
## Error Handling

### Error Types

**Define custom errors for different failure modes:**

```javascript
class ValidationError extends Error {
    constructor(message, field) {
        super(message);
        this.name = 'ValidationError';
        this.statusCode = 400;
        this.field = field;
    }
}

class NotFoundError extends Error {
    constructor(resource, id) {
        super(`${resource} not found: ${id}`);
        this.name = 'NotFoundError';
        this.statusCode = 404;
        this.resource = resource;
        this.id = id;
    }
}

class UnauthorizedError extends Error {
    constructor(message = 'Authentication required') {
        super(message);
        this.name = 'UnauthorizedError';
        this.statusCode = 401;
    }
}
```

---

### Error Propagation

**Pattern: Let errors bubble up to error handler**

✓ **Do:** Throw errors from services, catch in middleware
```javascript
// Service layer - throw errors
class UserService {
    async getUser(userId) {
        const user = await userRepo.findById(userId);
        if (!user) {
            throw new NotFoundError('User', userId);
        }
        return user;
    }
}

// Controller layer - let errors propagate
async function getUser(req, res, next) {
    try {
        const user = await userService.getUser(req.params.id);
        res.json(user);
    } catch (error) {
        next(error);  // Pass to error handler
    }
}

// Error handler middleware - centralized handling
app.use((error, req, res, next) => {
    logger.error('Request failed:', { error: error.message, stack: error.stack });

    const statusCode = error.statusCode || 500;
    res.status(statusCode).json({
        error: {
            code: error.name,
            message: error.message
        }
    });
});
```

❌ **Don't:** Swallow errors or handle inconsistently
```javascript
// ✗ Bad: Swallowing error
async function getUser(req, res) {
    try {
        const user = await userService.getUser(req.params.id);
        res.json(user);
    } catch (error) {
        // Error swallowed - user gets no response!
    }
}

// ✗ Bad: Inconsistent error responses
async function getUser(req, res) {
    try {
        const user = await userService.getUser(req.params.id);
        res.json(user);
    } catch (error) {
        res.send('Error');  // Inconsistent format
    }
}
```

---

### Error Logging

**What to log:**
- ✓ Error message and type
- ✓ Stack trace
- ✓ Request context (endpoint, user ID, request ID)
- ✗ Sensitive data (passwords, tokens)

```javascript
logger.error('Request failed:', {
    error: error.message,
    stack: error.stack,
    endpoint: req.path,
    method: req.method,
    userId: req.user?.id,
    requestId: req.id
    // NO: password, token, or other sensitive data
});
```
```

---

## Quality Standards

### Completeness

**Required sections:**
- ✓ Code Organization
- ✓ Naming Conventions
- ✓ Coding Patterns (at least 3)
- ✓ Testing Standards
- ✓ Architectural Constraints

**Optional sections** (add as needed):
- Security Requirements (if project handles sensitive data)
- Performance Guidelines (if performance-critical)
- Error Handling (if complex error scenarios)
- Deployment Standards (if deployment is complex)

### Pattern Quality

**Good patterns:**
- ✓ Concrete examples (actual code)
- ✓ Both Do and Don't examples
- ✓ Clear rationale
- ✓ Emerged from real project needs (Rule of Three)

**Poor patterns:**
- ✗ Abstract descriptions without examples
- ✗ Preferences without rationale
- ✗ Copy-pasted from other projects without adaptation
- ✗ Added before pattern emerges (premature documentation)

### Maintainability

**Keep guidelines current:**
- ✓ Document pattern changes in commit messages
- ✓ Remove outdated patterns
- ✓ Link to related bugs/PRs for context
- ✓ Review annually for relevance

**Avoid:**
- ✗ Letting guidelines drift from reality
- ✗ Accumulating contradictory patterns
- ✗ Keeping obsolete constraints

---

## Anti-Patterns

### Anti-Pattern 1: Copy-Paste from Other Projects

**Problem:**
```markdown
## Guidelines

[Entire guidelines file copied from different project without adaptation]

- Use Redux for state management (project doesn't use React)
- Follow Rails conventions (project is Node.js)
```

**Why it's bad:**
- Guidelines don't match project context
- Confuses contributors
- Wastes time following irrelevant patterns

**Fix:**
- Start with minimal guidelines
- Add patterns as they emerge in THIS project
- Adapt examples from other projects to fit this codebase

---

### Anti-Pattern 2: Premature Pattern Documentation

**Problem:**
```markdown
## Pattern: Repository Layer

[Documents complex repository pattern after implementing only 1 repository]
```

**Why it's bad:**
- Pattern hasn't proven itself yet
- Might not fit future use cases
- Over-engineering

**Fix:**
- Wait for Rule of Three: document pattern after 3rd occurrence
- Let patterns emerge naturally from code
- Document proven patterns, not theoretical ones

---

### Anti-Pattern 3: Vague Guidelines

**Problem:**
```markdown
## Naming Conventions

Write good function names.
```

**Why it's bad:**
- Not actionable
- "Good" is subjective
- No examples to learn from

**Fix:**
```markdown
## Naming Conventions

### Functions
- **Pattern:** camelCase verbs describing actions
- **Examples:**
  - `createUser()` ✓
  - `validateEmail()` ✓
  - `user()` ✗ (not a verb)
  - `process()` ✗ (too generic)
```

---

### Anti-Pattern 4: Stale Guidelines

**Problem:**
```markdown
## Database Access

Use MongoDB for all data storage.

[Project switched to PostgreSQL 6 months ago, guideline never updated]
```

**Why it's bad:**
- Misleads new contributors
- Wastes time following wrong patterns
- Erodes trust in documentation

**Fix:**
- Review guidelines when architecture changes
- Document pattern changes in commit messages
- Mark deprecated patterns clearly
- Remove obsolete guidelines

---

### Anti-Pattern 5: Guidelines Without Rationale

**Problem:**
```markdown
## Pattern: Always Use Dependency Injection

Do this:
```javascript
class Service {
    constructor(repo) { this.repo = repo; }
}
```

Don't do this:
```javascript
const repo = new Repository();
```
```

**Why it's bad:**
- Contributors don't understand WHY
- Can't make informed decisions about exceptions
- Feels arbitrary

**Fix:**
```markdown
## Pattern: Dependency Injection

[Same examples]

**Why:**
- Testability: Can inject mocks during testing
- Flexibility: Can swap implementations
- Explicitness: Dependencies visible in constructor
```

---

## Downstream Usage

### skeleton-writer Consumption

**Reads GUIDELINES.md for:**
- Code organization (where to create files)
- Naming conventions (how to name files/classes/functions)
- Architectural constraints (what imports are allowed)
- Coding patterns (how to structure code)

**Creates skeletons that:**
- Follow naming conventions
- Respect layer boundaries
- Use dependency injection patterns
- Organize code in correct directories

### test-writer Consumption

**Reads GUIDELINES.md for:**
- Testing standards (coverage, structure, naming)
- Test organization (where tests go)
- Assertion patterns
- Mock/stub guidelines

**Creates tests that:**
- Meet coverage thresholds
- Follow AAA/GWT structure
- Use approved testing patterns
- Live in correct directories

### implementer Consumption

**Reads GUIDELINES.md for:**
- All coding patterns
- Architectural constraints
- Performance guidelines
- Security requirements
- Error handling patterns

**Creates implementations that:**
- Follow all documented patterns
- Respect constraints
- Meet performance targets
- Handle errors consistently

### Reviewers Consumption

**Use GUIDELINES.md to:**
- Verify code follows conventions
- Identify pattern violations
- Enforce architectural constraints
- Check security compliance

**Review feedback references:**
- Specific guideline violations
- Pattern recommendations
- Constraint explanations

---

## Update Workflow

**When to update GUIDELINES.md:**

1. **Pattern Emerges** (Rule of Three)
   - Same pattern seen in 3 different places
   - platform-lead documents pattern
   - Add to Coding Patterns section

2. **Bug Reveals Anti-Pattern**
   - Bug fix includes pattern to prevent recurrence
   - implementer adds pattern to bug fix PR
   - platform-lead reviews and approves

3. **Architectural Decision**
   - New constraint established (e.g., "no circular dependencies")
   - platform-lead adds to Architectural Constraints

4. **Performance Requirement**
   - New latency target or optimization needed
   - platform-lead adds to Performance Guidelines

**Update process:**

1. Create feature branch
2. Update GUIDELINES.md
3. Create PR with context/rationale in description
4. platform-lead reviews and approves
5. Merge to main

**Living doc update special case:**
- If feature branch modifies GUIDELINES.md
- implementation-reviewer must request platform-lead review before merge
- See role-implementation-reviewer.md for details

---

## Related Schemas

**When creating this artifact:**
- Initial creation: Start with minimal patterns and constraints
- Reference [schema-system-map.md](schema-system-map.md) for structural context
- Document patterns as they emerge (Rule of Three)

**When using this artifact:**
- During skeleton/test/implementation: Follow documented patterns and constraints
- During reviews: Verify adherence to patterns and constraints
- When patterns emerge: Update GUIDELINES.md (living document)

**Continuous updates:**
- Add patterns after they appear 3+ times
- Document constraints from architectural decisions
- Update examples when APIs change
- Prune obsolete patterns

For complete schema workflow, see [schema-relationship-map.md](patterns/schema-relationship-map.md).

---

## Summary

GUIDELINES.md is the living codification of project conventions, patterns, and constraints.

**Key principles:**
- **Emergent**: Patterns documented after proven (Rule of Three)
- **Concrete**: Examples over abstract rules
- **Rationale-driven**: Every pattern explains WHY
- **Living**: Continuously updated as project evolves
- **Actionable**: Specific enough to follow and enforce

**Core sections:**
- Code Organization: Where code lives
- Naming Conventions: How to name things
- Coding Patterns: Proven do's and don'ts
- Testing Standards: Quality bar for tests
- Architectural Constraints: Layer boundaries and dependencies

**Consumers:**
- skeleton-writer: Follows organization, naming, patterns
- test-writer: Follows testing standards
- implementer: Follows all patterns and constraints
- Reviewers: Enforces guidelines compliance

**Maintenance:**
- platform-lead approves all updates
- Git history tracks changes
- Remove outdated patterns
- Review annually

GUIDELINES.md turns implicit team knowledge into explicit, enforceable standards that improve code quality and consistency.
