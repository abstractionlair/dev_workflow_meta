# Workflow Walkthrough Example

## Purpose

This document shows a complete example of the workflow from initial project idea through first merged feature. Follow along to see how artifacts, roles, and state transitions work in practice.

## Scenario

**Project idea**: Build a REST API for task management that multiple client applications can use.

**Starting point**: Empty directory, fresh git repository

## Phase 1: Strategic Planning

### Step 1: Create VISION.md

**Command:**
```
"Act as vision-writing-helper to help me create a VISION.md"
```

**Process**: Interactive dialogue with the agent to articulate the vision. The helper asks questions, you answer, it synthesizes into a vision document.

**Resulting artifact** (abbreviated):

```markdown
# Vision: TaskFlow API

## Why This Exists

Current task management tools lock users into specific interfaces. We're building
a flexible API that enables multiple client applications (web, mobile, CLI) to
share the same task data.

## Who Benefits

- Developers building task management UIs
- Teams wanting custom task workflows
- Users who want to switch between interfaces seamlessly

## Success Looks Like

**6 months:**
- Core API operational (tasks, projects, users)
- 2+ client applications built by community
- 50+ teams using the API

**1 year:**
- Advanced features (webhooks, real-time sync, search)
- 500+ teams, 99.9% uptime
- Extension ecosystem emerging

**3 years:**
- Industry-standard task management backend
- Thousands of client applications
- Self-sustaining open source community

## Version

v1.0
```

**File location**: `/VISION.md` on main branch

---

### Step 2: Review VISION.md

**Command:**
```
"Act as vision-reviewer to review VISION.md"
```

**Process**: Agent reads vision against schema, provides feedback or approval.

**Resulting artifact** (review approval):

```markdown
# Vision Review: TaskFlow API

**Artifact**: VISION.md v1.0
**Reviewer**: [AI agent name/human name]
**Date**: 2024-01-15
**Decision**: APPROVED

## Evaluation

✓ Clear problem statement and target audience
✓ Measurable success criteria at 6mo/1yr/3yr milestones
✓ Aligned with feasibility constraints
✓ Compelling value proposition

## Recommendations

Consider adding security/privacy goals in future versions.

## Approval

VISION.md v1.0 is approved. Proceed to scope definition.
```

**File location**: `/reviews/vision/vision-v1.0-review.md` on main branch

---

### Step 3: Create SCOPE.md

**Command:**
```
"Act as scope-writer to create SCOPE.md based on VISION.md"
```

**Resulting artifact** (abbreviated):

```markdown
# Scope: TaskFlow API

## In Scope

**Core Functionality:**
- RESTful API for task CRUD operations
- User authentication and authorization
- Project/workspace organization
- Task metadata (due dates, priorities, tags)

**Technical Requirements:**
- JSON API following REST conventions
- Token-based authentication
- SQLite/PostgreSQL data storage
- Comprehensive API documentation

## Out of Scope

**Explicitly excluded:**
- Client applications (web/mobile UIs) - third-party responsibility
- Real-time collaboration features - future phase
- Email/calendar integrations - future phase
- Self-hosted deployment tooling - community contribution

## Constraints

**Technical:**
- Must support 1000+ concurrent users
- Response time <200ms for 95th percentile
- Data at rest encryption required

**Resource:**
- 6-month timeline to v1.0
- 2-person development team
- Cloud hosting budget $500/month

## Non-Functional Requirements

- API uptime 99.5%+ (measured monthly)
- Comprehensive test coverage (>80% line coverage)
- Automated CI/CD pipeline
- Security audit before v1.0 launch

## Version

v1.0
```

**File location**: `/SCOPE.md` on main branch

---

### Step 4: Review SCOPE.md

**Command:**
```
"Act as scope-reviewer to review SCOPE.md"
```

**Outcome**: Approved (similar review document created in `/reviews/scope/`)

---

### Step 5: Create ROADMAP.md

**Command:**
```
"Act as roadmap-writer to create ROADMAP.md based on VISION.md and SCOPE.md"
```

**Resulting artifact** (abbreviated):

```markdown
# Roadmap: TaskFlow API

## Phase 1: Foundation (Weeks 1-8)

**Goal**: Core API operational with essential features

**Features:**
1. User authentication (registration, login, token management)
2. Basic task CRUD (create, read, update, delete tasks)
3. Project organization (create projects, assign tasks)
4. Task metadata (due dates, priorities, simple tags)

**Success criteria:**
- All features tested and documented
- API deployed to staging environment
- Load testing validates 1000 concurrent users

## Phase 2: Enhancement (Weeks 9-16)

**Goal**: Production-ready with advanced features

**Features:**
1. Advanced search and filtering
2. Task relationships (subtasks, dependencies)
3. User permissions and sharing
4. Webhook notifications

**Success criteria:**
- Security audit completed
- API documentation published
- v1.0 deployed to production

## Phase 3: Growth (Weeks 17-24)

**Goal**: Ecosystem development

**Features:**
1. Rate limiting and API keys
2. Batch operations
3. Export/import functionality
4. Analytics endpoints

**Success criteria:**
- 50+ teams using the API
- 2+ community-built client applications

## Feature Details

### User Authentication
**Priority**: P0 (blocks other features)
**Estimated effort**: 2 weeks
**Dependencies**: None
**Acceptance criteria**:
- Users can register with email/password
- Users can log in and receive JWT token
- Token-based authentication for protected endpoints
- Password reset functionality

### Basic Task CRUD
**Priority**: P0 (core functionality)
**Estimated effort**: 2 weeks
**Dependencies**: User authentication
**Acceptance criteria**:
- Authenticated users can create tasks
- Tasks have title, description, status fields
- Users can list, update, and delete their tasks
- Proper authorization (users only access their own tasks)

[Additional features detailed similarly...]

## Version

v1.0
```

**File location**: `/ROADMAP.md` on main branch

---

### Step 6: Review ROADMAP.md

**Command:**
```
"Act as roadmap-reviewer to review ROADMAP.md"
```

**Outcome**: Approved

**Repository state after strategic planning:**
```
project/
├── VISION.md           (approved v1.0)
├── SCOPE.md            (approved v1.0)
├── ROADMAP.md          (approved v1.0)
└── reviews/
    ├── vision/
    │   └── vision-v1.0-review.md
    ├── scope/
    │   └── scope-v1.0-review.md
    └── roadmap/
        └── roadmap-v1.0-review.md
```

---

## Phase 2: Living Documentation Setup

### Step 7: Create Initial SYSTEM_MAP.md

**Command:**
```
"Act as platform-lead to create initial SYSTEM_MAP.md based on our planning documents"
```

**Resulting artifact** (abbreviated):

```markdown
# System Map: TaskFlow API

## Architecture Overview

```
┌─────────────┐
│   Clients   │  (web, mobile, CLI - external)
└──────┬──────┘
       │ HTTPS/JSON
       ↓
┌─────────────────────────────────────────┐
│         API Gateway Layer               │
│  - Authentication middleware            │
│  - Rate limiting                        │
│  - Request validation                   │
└──────┬──────────────────────────────────┘
       │
       ↓
┌─────────────────────────────────────────┐
│       Application Layer                 │
│  - Task management logic                │
│  - User management                      │
│  - Project management                   │
└──────┬──────────────────────────────────┘
       │
       ↓
┌─────────────────────────────────────────┐
│        Data Layer                       │
│  - PostgreSQL database                  │
│  - Data access layer                    │
└─────────────────────────────────────────┘
```

## Component Responsibilities

### API Gateway Layer
- JWT token validation
- Request/response transformation
- Error handling and standardization
- CORS handling

### Application Layer
- Business logic enforcement
- Authorization checks
- Data validation
- Service orchestration

### Data Layer
- Database queries
- Transaction management
- Data integrity enforcement

## Key Design Decisions

**Authentication**: JWT tokens with 24-hour expiration, refresh tokens stored in database

**API Style**: RESTful with standard HTTP methods, JSON payloads

**Database**: PostgreSQL for relational data, designed for horizontal scaling

**Error Handling**: Standard HTTP status codes, structured error responses

## Technology Stack

- **Runtime**: Node.js 20 LTS
- **Framework**: Express.js 4.x
- **Database**: PostgreSQL 15
- **Testing**: Jest, Supertest
- **Documentation**: OpenAPI 3.0

## Version

v1.0 (updated as architecture evolves)
```

**File location**: `/SYSTEM_MAP.md` on main branch

---

### Step 8: Create Initial GUIDELINES.md

**Command:**
```
"Act as platform-lead to create initial GUIDELINES.md"
```

**Resulting artifact** (abbreviated):

```markdown
# Development Guidelines: TaskFlow API

## Code Organization

```
src/
├── routes/          # API endpoint definitions
├── controllers/     # Request handlers
├── services/        # Business logic
├── models/          # Data models
├── middleware/      # Express middleware
└── utils/           # Shared utilities

tests/
├── unit/           # Isolated unit tests
├── integration/    # API integration tests
└── regression/     # Bug regression tests
```

## Coding Conventions

### JavaScript Style
- Use ES6+ features (async/await, destructuring, arrow functions)
- Semicolons required
- Single quotes for strings
- 2-space indentation

### Naming
- Routes: kebab-case (`/api/task-lists`)
- Files: kebab-case (`task-service.js`)
- Functions: camelCase (`createTask()`)
- Classes: PascalCase (`TaskService`)
- Constants: UPPER_SNAKE_CASE (`MAX_RETRY_ATTEMPTS`)

### Error Handling
- All async functions use try/catch
- Controller errors propagated to error middleware
- Structured error responses:
  ```json
  {
    "error": {
      "code": "VALIDATION_ERROR",
      "message": "Task title is required",
      "field": "title"
    }
  }
  ```

## Testing Standards

### Coverage Requirements
- Line coverage: >80%
- Branch coverage: >70%
- All public APIs must have integration tests

### Test Structure
```javascript
describe('TaskService', () => {
  describe('createTask', () => {
    it('creates task with valid data', async () => {
      // Arrange
      const taskData = { title: 'Test task' };

      // Act
      const result = await taskService.createTask(taskData);

      // Assert
      expect(result).toHaveProperty('id');
      expect(result.title).toBe('Test task');
    });
  });
});
```

## API Conventions

### Endpoints
- Use plural nouns: `/api/tasks`, `/api/projects`
- Resource nesting max 2 levels: `/api/projects/:id/tasks`
- Actions as verbs only when necessary: `/api/auth/login`

### HTTP Methods
- GET: Retrieve resources
- POST: Create resources
- PUT: Full update (replace)
- PATCH: Partial update
- DELETE: Remove resources

### Response Formats
- Success (200): `{ "data": { ... } }`
- Created (201): `{ "data": { ... }, "id": "..." }` with Location header
- No content (204): Empty body
- Error (4xx/5xx): `{ "error": { ... } }`

## Version

v1.0 (updated as patterns emerge)
```

**File location**: `/GUIDELINES.md` on main branch

**Repository state after living docs:**
```
project/
├── VISION.md
├── SCOPE.md
├── ROADMAP.md
├── SYSTEM_MAP.md
├── GUIDELINES.md
└── reviews/
    └── [previous reviews...]
```

---

## Phase 3: First Feature Implementation

From ROADMAP.md, the first feature is **User Authentication**.

### Step 9: Write Feature Specification

**Command:**
```
"Act as spec-writer to create a specification for the User Authentication feature from ROADMAP.md"
```

**Resulting artifact** (abbreviated):

```markdown
# Specification: User Authentication

## Overview

Implement secure user registration and authentication using JWT tokens.

## Functional Requirements

### User Registration
**Endpoint**: `POST /api/auth/register`

**Request:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123",
  "name": "John Doe"
}
```

**Success Response (201):**
```json
{
  "data": {
    "id": "user_123",
    "email": "user@example.com",
    "name": "John Doe",
    "createdAt": "2024-01-15T10:30:00Z"
  }
}
```

**Validation:**
- Email must be valid format and unique
- Password minimum 8 characters, must contain letter and number
- Name required, 1-100 characters

### User Login
**Endpoint**: `POST /api/auth/login`

**Request:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**Success Response (200):**
```json
{
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 86400,
    "user": {
      "id": "user_123",
      "email": "user@example.com",
      "name": "John Doe"
    }
  }
}
```

### Token Validation
**Middleware**: `authenticateToken`

**Usage**: Protect routes requiring authentication

**Behavior**:
- Read token from `Authorization: Bearer <token>` header
- Validate token signature and expiration
- Attach user info to request object
- Return 401 if invalid/missing

## Non-Functional Requirements

- Passwords hashed with bcrypt (cost factor 10)
- JWT tokens expire after 24 hours
- Rate limit: 5 failed login attempts per email per 15 minutes
- HTTPS required in production

## Error Cases

| Scenario | Status | Error Code |
|----------|--------|------------|
| Invalid email format | 400 | INVALID_EMAIL |
| Email already registered | 409 | EMAIL_EXISTS |
| Password too weak | 400 | WEAK_PASSWORD |
| Invalid credentials | 401 | INVALID_CREDENTIALS |
| Missing token | 401 | TOKEN_REQUIRED |
| Expired token | 401 | TOKEN_EXPIRED |
| Invalid token | 401 | INVALID_TOKEN |

## Implementation Notes

- Store users in `users` table: id, email, password_hash, name, created_at
- Use `jsonwebtoken` library for JWT operations
- Use `bcrypt` library for password hashing
- Token secret stored in environment variable `JWT_SECRET`

## Acceptance Criteria

- [ ] Users can register with valid email/password
- [ ] Registration rejects duplicate emails
- [ ] Registration validates password strength
- [ ] Users can login with correct credentials
- [ ] Login returns valid JWT token
- [ ] Login rejects incorrect credentials
- [ ] Protected routes require valid token
- [ ] Protected routes reject missing/invalid/expired tokens
- [ ] Passwords are never stored in plain text
- [ ] All endpoints have integration tests

## Dependencies

None (first feature)

## Version

v1.0
```

**File location**: `/specs/proposed/user-authentication.md` on main branch

---

### Step 10: Review Specification

**Command:**
```
"Act as spec-reviewer to review the user authentication spec at specs/proposed/user-authentication.md"
```

**Outcome**: Approved

**Action taken by reviewer**:
- Creates review document in `/reviews/specs/user-authentication-v1.0-review.md`
- **Moves spec** from `specs/proposed/` to `specs/todo/`

**Repository state:**
```
project/
├── [planning docs...]
├── specs/
│   └── todo/
│       └── user-authentication.md
└── reviews/
    └── specs/
        └── user-authentication-v1.0-review.md
```

---

### Step 11: Create Interface Skeleton

**Command:**
```
"Act as skeleton-writer for the spec at specs/todo/user-authentication.md"
```

**Actions taken by skeleton-writer**:
1. **Moves spec** from `specs/todo/` to `specs/doing/`
2. **Creates feature branch**: `git checkout -b feature/user-authentication`
3. **Creates skeleton code**

**Resulting artifacts**:

`src/routes/auth.js`:
```javascript
const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth-controller');

/**
 * POST /api/auth/register
 * Register a new user
 */
router.post('/register', authController.register);

/**
 * POST /api/auth/login
 * Authenticate user and return JWT token
 */
router.post('/login', authController.login);

module.exports = router;
```

`src/controllers/auth-controller.js`:
```javascript
/**
 * Register a new user
 * @param {Request} req - Express request
 * @param {Response} res - Express response
 */
async function register(req, res) {
  // TODO: Implementation
  throw new Error('Not implemented');
}

/**
 * Authenticate user and return JWT token
 * @param {Request} req - Express request
 * @param {Response} res - Express response
 */
async function login(req, res) {
  // TODO: Implementation
  throw new Error('Not implemented');
}

module.exports = {
  register,
  login
};
```

`src/middleware/authenticate.js`:
```javascript
/**
 * Middleware to validate JWT token and attach user to request
 * @param {Request} req - Express request
 * @param {Response} res - Express response
 * @param {Function} next - Next middleware
 */
async function authenticateToken(req, res, next) {
  // TODO: Implementation
  throw new Error('Not implemented');
}

module.exports = {
  authenticateToken
};
```

`src/services/auth-service.js`:
```javascript
/**
 * Register a new user
 * @param {Object} userData - User registration data
 * @returns {Promise<Object>} Created user (without password)
 */
async function registerUser(userData) {
  // TODO: Implementation
  throw new Error('Not implemented');
}

/**
 * Authenticate user credentials
 * @param {string} email - User email
 * @param {string} password - User password
 * @returns {Promise<Object>} User object and JWT token
 */
async function authenticateUser(email, password) {
  // TODO: Implementation
  throw new Error('Not implemented');
}

/**
 * Validate JWT token
 * @param {string} token - JWT token
 * @returns {Promise<Object>} Decoded user data
 */
async function validateToken(token) {
  // TODO: Implementation
  throw new Error('Not implemented');
}

module.exports = {
  registerUser,
  authenticateUser,
  validateToken
};
```

**Git status:**
```
On branch feature/user-authentication
Changes to be committed:
  modified:   specs/todo/user-authentication.md → specs/doing/user-authentication.md
  new file:   src/routes/auth.js
  new file:   src/controllers/auth-controller.js
  new file:   src/middleware/authenticate.js
  new file:   src/services/auth-service.js
```

---

### Step 12: Review Skeleton

**Command:**
```
"Act as skeleton-reviewer for the user authentication feature"
```

**Outcome**: Approved (creates review in `/reviews/skeletons/`)

---

### Step 13: Write Tests (TDD RED)

**Command:**
```
"Act as test-writer for the spec at specs/doing/user-authentication.md"
```

**Resulting artifacts**:

`tests/integration/auth.test.js`:
```javascript
const request = require('supertest');
const app = require('../../src/app');
const db = require('../../src/db');

describe('POST /api/auth/register', () => {
  beforeEach(async () => {
    await db.clearUsers();
  });

  it('registers user with valid data', async () => {
    const response = await request(app)
      .post('/api/auth/register')
      .send({
        email: 'test@example.com',
        password: 'SecurePass123',
        name: 'Test User'
      });

    expect(response.status).toBe(201);
    expect(response.body.data).toHaveProperty('id');
    expect(response.body.data.email).toBe('test@example.com');
    expect(response.body.data.name).toBe('Test User');
    expect(response.body.data).not.toHaveProperty('password');
  });

  it('rejects duplicate email', async () => {
    await request(app)
      .post('/api/auth/register')
      .send({
        email: 'test@example.com',
        password: 'SecurePass123',
        name: 'First User'
      });

    const response = await request(app)
      .post('/api/auth/register')
      .send({
        email: 'test@example.com',
        password: 'DifferentPass123',
        name: 'Second User'
      });

    expect(response.status).toBe(409);
    expect(response.body.error.code).toBe('EMAIL_EXISTS');
  });

  it('rejects weak password', async () => {
    const response = await request(app)
      .post('/api/auth/register')
      .send({
        email: 'test@example.com',
        password: 'weak',
        name: 'Test User'
      });

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe('WEAK_PASSWORD');
  });

  it('rejects invalid email format', async () => {
    const response = await request(app)
      .post('/api/auth/register')
      .send({
        email: 'not-an-email',
        password: 'SecurePass123',
        name: 'Test User'
      });

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe('INVALID_EMAIL');
  });
});

describe('POST /api/auth/login', () => {
  beforeEach(async () => {
    await db.clearUsers();
    await request(app)
      .post('/api/auth/register')
      .send({
        email: 'existing@example.com',
        password: 'SecurePass123',
        name: 'Existing User'
      });
  });

  it('authenticates with valid credentials', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'existing@example.com',
        password: 'SecurePass123'
      });

    expect(response.status).toBe(200);
    expect(response.body.data).toHaveProperty('token');
    expect(response.body.data.expiresIn).toBe(86400);
    expect(response.body.data.user.email).toBe('existing@example.com');
  });

  it('rejects invalid credentials', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'existing@example.com',
        password: 'WrongPassword'
      });

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe('INVALID_CREDENTIALS');
  });

  it('rejects non-existent user', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'nonexistent@example.com',
        password: 'SomePassword123'
      });

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe('INVALID_CREDENTIALS');
  });
});

describe('Authentication Middleware', () => {
  let validToken;

  beforeEach(async () => {
    await db.clearUsers();
    const registerResponse = await request(app)
      .post('/api/auth/register')
      .send({
        email: 'test@example.com',
        password: 'SecurePass123',
        name: 'Test User'
      });

    const loginResponse = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'test@example.com',
        password: 'SecurePass123'
      });

    validToken = loginResponse.body.data.token;
  });

  it('allows access with valid token', async () => {
    const response = await request(app)
      .get('/api/tasks')  // Protected endpoint
      .set('Authorization', `Bearer ${validToken}`);

    expect(response.status).not.toBe(401);
  });

  it('rejects request without token', async () => {
    const response = await request(app)
      .get('/api/tasks');

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe('TOKEN_REQUIRED');
  });

  it('rejects request with invalid token', async () => {
    const response = await request(app)
      .get('/api/tasks')
      .set('Authorization', 'Bearer invalid.token.here');

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe('INVALID_TOKEN');
  });

  it('rejects expired token', async () => {
    const expiredToken = generateExpiredToken();
    const response = await request(app)
      .get('/api/tasks')
      .set('Authorization', `Bearer ${expiredToken}`);

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe('TOKEN_EXPIRED');
  });
});
```

`tests/unit/auth-service.test.js`:
```javascript
const authService = require('../../src/services/auth-service');
const db = require('../../src/db');

describe('AuthService.registerUser', () => {
  beforeEach(async () => {
    await db.clearUsers();
  });

  it('hashes password before storing', async () => {
    const userData = {
      email: 'test@example.com',
      password: 'PlainTextPassword123',
      name: 'Test User'
    };

    await authService.registerUser(userData);

    const storedUser = await db.getUserByEmail('test@example.com');
    expect(storedUser.password_hash).not.toBe('PlainTextPassword123');
    expect(storedUser.password_hash).toMatch(/^\$2[aby]\$\d+\$/);  // bcrypt format
  });

  it('returns user without password hash', async () => {
    const userData = {
      email: 'test@example.com',
      password: 'SecurePass123',
      name: 'Test User'
    };

    const result = await authService.registerUser(userData);

    expect(result).not.toHaveProperty('password');
    expect(result).not.toHaveProperty('password_hash');
    expect(result.email).toBe('test@example.com');
  });
});

describe('AuthService.authenticateUser', () => {
  beforeEach(async () => {
    await db.clearUsers();
    await authService.registerUser({
      email: 'test@example.com',
      password: 'SecurePass123',
      name: 'Test User'
    });
  });

  it('returns user and token for valid credentials', async () => {
    const result = await authService.authenticateUser(
      'test@example.com',
      'SecurePass123'
    );

    expect(result).toHaveProperty('user');
    expect(result).toHaveProperty('token');
    expect(result.user.email).toBe('test@example.com');
  });

  it('throws error for invalid password', async () => {
    await expect(
      authService.authenticateUser('test@example.com', 'WrongPassword')
    ).rejects.toThrow('Invalid credentials');
  });
});

describe('AuthService.validateToken', () => {
  it('decodes valid token', async () => {
    const token = generateValidToken({ userId: 'user_123' });
    const result = await authService.validateToken(token);

    expect(result.userId).toBe('user_123');
  });

  it('throws error for expired token', async () => {
    const token = generateExpiredToken();

    await expect(
      authService.validateToken(token)
    ).rejects.toThrow('Token expired');
  });

  it('throws error for invalid signature', async () => {
    const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.invalid.signature';

    await expect(
      authService.validateToken(token)
    ).rejects.toThrow('Invalid token');
  });
});
```

**Running tests**:
```bash
npm test
```

**Expected output**:
```
FAIL tests/integration/auth.test.js
  ✕ All tests fail (RED state - implementation not done)

FAIL tests/unit/auth-service.test.js
  ✕ All tests fail (RED state - implementation not done)

Test Suites: 2 failed, 2 total
Tests:       15 failed, 15 total
```

✅ **RED state achieved** - Tests written and failing as expected.

---

### Step 14: Review Tests

**Command:**
```
"Act as test-reviewer for the user authentication feature"
```

**Outcome**: Approved (creates review in `/reviews/tests/user-authentication-v1.0-review.md`)

---

### Step 15: Implement Feature (GREEN)

**Command:**
```
"Act as implementer for the spec at specs/doing/user-authentication.md"
```

**Implementation**: The implementer fills in the skeleton code to make tests pass.

`src/services/auth-service.js` (implemented):
```javascript
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../db');

const SALT_ROUNDS = 10;
const TOKEN_EXPIRY = '24h';

async function registerUser(userData) {
  const { email, password, name } = userData;

  // Hash password
  const passwordHash = await bcrypt.hash(password, SALT_ROUNDS);

  // Store user
  const user = await db.createUser({
    email,
    password_hash: passwordHash,
    name
  });

  // Return user without password
  const { password_hash, ...userWithoutPassword } = user;
  return userWithoutPassword;
}

async function authenticateUser(email, password) {
  const user = await db.getUserByEmail(email);

  if (!user) {
    throw new Error('Invalid credentials');
  }

  const isValid = await bcrypt.compare(password, user.password_hash);

  if (!isValid) {
    throw new Error('Invalid credentials');
  }

  const token = jwt.sign(
    { userId: user.id, email: user.email },
    process.env.JWT_SECRET,
    { expiresIn: TOKEN_EXPIRY }
  );

  const { password_hash, ...userWithoutPassword } = user;

  return {
    token,
    user: userWithoutPassword
  };
}

async function validateToken(token) {
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    return decoded;
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      throw new Error('Token expired');
    }
    throw new Error('Invalid token');
  }
}

module.exports = {
  registerUser,
  authenticateUser,
  validateToken
};
```

`src/controllers/auth-controller.js` (implemented):
```javascript
const authService = require('../services/auth-service');
const { validateEmail, validatePassword } = require('../utils/validation');

async function register(req, res) {
  try {
    const { email, password, name } = req.body;

    // Validate input
    if (!validateEmail(email)) {
      return res.status(400).json({
        error: {
          code: 'INVALID_EMAIL',
          message: 'Invalid email format'
        }
      });
    }

    if (!validatePassword(password)) {
      return res.status(400).json({
        error: {
          code: 'WEAK_PASSWORD',
          message: 'Password must be at least 8 characters with letter and number'
        }
      });
    }

    // Check for duplicate email
    const existingUser = await db.getUserByEmail(email);
    if (existingUser) {
      return res.status(409).json({
        error: {
          code: 'EMAIL_EXISTS',
          message: 'Email already registered'
        }
      });
    }

    // Register user
    const user = await authService.registerUser({ email, password, name });

    res.status(201).json({ data: user });
  } catch (error) {
    res.status(500).json({
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Registration failed'
      }
    });
  }
}

async function login(req, res) {
  try {
    const { email, password } = req.body;

    const { token, user } = await authService.authenticateUser(email, password);

    res.status(200).json({
      data: {
        token,
        expiresIn: 86400,  // 24 hours in seconds
        user
      }
    });
  } catch (error) {
    if (error.message === 'Invalid credentials') {
      return res.status(401).json({
        error: {
          code: 'INVALID_CREDENTIALS',
          message: 'Invalid email or password'
        }
      });
    }

    res.status(500).json({
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Login failed'
      }
    });
  }
}

module.exports = {
  register,
  login
};
```

`src/middleware/authenticate.js` (implemented):
```javascript
const authService = require('../services/auth-service');

async function authenticateToken(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      error: {
        code: 'TOKEN_REQUIRED',
        message: 'Authentication token required'
      }
    });
  }

  const token = authHeader.substring(7);  // Remove 'Bearer ' prefix

  try {
    const decoded = await authService.validateToken(token);
    req.user = decoded;
    next();
  } catch (error) {
    if (error.message === 'Token expired') {
      return res.status(401).json({
        error: {
          code: 'TOKEN_EXPIRED',
          message: 'Authentication token has expired'
        }
      });
    }

    return res.status(401).json({
      error: {
        code: 'INVALID_TOKEN',
        message: 'Invalid authentication token'
      }
    });
  }
}

module.exports = {
  authenticateToken
};
```

**Running tests**:
```bash
npm test
```

**Expected output**:
```
PASS tests/integration/auth.test.js
  ✓ All integration tests pass

PASS tests/unit/auth-service.test.js
  ✓ All unit tests pass

Test Suites: 2 passed, 2 total
Tests:       15 passed, 15 total
Coverage:    87% lines, 82% branches
```

✅ **GREEN state achieved** - All tests passing!

---

### Step 16: Refactor (TDD REFACTOR)

**Now that tests are passing, the implementer reviews the code for improvement opportunities.**

**Observation**: The error response formatting is duplicated across controllers. Let's extract this into a utility.

**Refactoring**: Create error response helper

`src/utils/error-response.js` (new file):
```javascript
/**
 * Create standardized error response
 * @param {string} code - Error code
 * @param {string} message - Error message
 * @param {number} status - HTTP status code
 * @returns {Object} Response object with status and json methods
 */
function createErrorResponse(code, message, status) {
  return {
    status,
    body: {
      error: { code, message }
    }
  };
}

/**
 * Common error responses
 */
const ErrorResponses = {
  INVALID_EMAIL: createErrorResponse(
    'INVALID_EMAIL',
    'Invalid email format',
    400
  ),
  WEAK_PASSWORD: createErrorResponse(
    'WEAK_PASSWORD',
    'Password must be at least 8 characters with letter and number',
    400
  ),
  EMAIL_EXISTS: createErrorResponse(
    'EMAIL_EXISTS',
    'Email already registered',
    409
  ),
  INVALID_CREDENTIALS: createErrorResponse(
    'INVALID_CREDENTIALS',
    'Invalid email or password',
    401
  ),
  TOKEN_REQUIRED: createErrorResponse(
    'TOKEN_REQUIRED',
    'Authentication token required',
    401
  ),
  TOKEN_EXPIRED: createErrorResponse(
    'TOKEN_EXPIRED',
    'Authentication token has expired',
    401
  ),
  INVALID_TOKEN: createErrorResponse(
    'INVALID_TOKEN',
    'Invalid authentication token',
    401
  ),
  INTERNAL_ERROR: (context) => createErrorResponse(
    'INTERNAL_ERROR',
    `${context} failed`,
    500
  )
};

/**
 * Send error response
 */
function sendError(res, errorResponse) {
  res.status(errorResponse.status).json(errorResponse.body);
}

module.exports = {
  ErrorResponses,
  sendError
};
```

**Updated controller** (refactored):

`src/controllers/auth-controller.js`:
```javascript
const authService = require('../services/auth-service');
const { validateEmail, validatePassword } = require('../utils/validation');
const { ErrorResponses, sendError } = require('../utils/error-response');

async function register(req, res) {
  try {
    const { email, password, name } = req.body;

    // Validate input
    if (!validateEmail(email)) {
      return sendError(res, ErrorResponses.INVALID_EMAIL);
    }

    if (!validatePassword(password)) {
      return sendError(res, ErrorResponses.WEAK_PASSWORD);
    }

    // Check for duplicate email
    const existingUser = await db.getUserByEmail(email);
    if (existingUser) {
      return sendError(res, ErrorResponses.EMAIL_EXISTS);
    }

    // Register user
    const user = await authService.registerUser({ email, password, name });

    res.status(201).json({ data: user });
  } catch (error) {
    sendError(res, ErrorResponses.INTERNAL_ERROR('Registration'));
  }
}

async function login(req, res) {
  try {
    const { email, password } = req.body;

    const { token, user } = await authService.authenticateUser(email, password);

    res.status(200).json({
      data: {
        token,
        expiresIn: 86400,
        user
      }
    });
  } catch (error) {
    if (error.message === 'Invalid credentials') {
      return sendError(res, ErrorResponses.INVALID_CREDENTIALS);
    }
    sendError(res, ErrorResponses.INTERNAL_ERROR('Login'));
  }
}

module.exports = {
  register,
  login
};
```

**Updated middleware** (refactored):

`src/middleware/authenticate.js`:
```javascript
const authService = require('../services/auth-service');
const { ErrorResponses, sendError } = require('../utils/error-response');

async function authenticateToken(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return sendError(res, ErrorResponses.TOKEN_REQUIRED);
  }

  const token = authHeader.substring(7);

  try {
    const decoded = await authService.validateToken(token);
    req.user = decoded;
    next();
  } catch (error) {
    if (error.message === 'Token expired') {
      return sendError(res, ErrorResponses.TOKEN_EXPIRED);
    }
    return sendError(res, ErrorResponses.INVALID_TOKEN);
  }
}

module.exports = {
  authenticateToken
};
```

**Run tests again to ensure refactoring didn't break anything**:
```bash
npm test
```

**Expected output**:
```
PASS tests/integration/auth.test.js
  ✓ All integration tests still pass

PASS tests/unit/auth-service.test.js
  ✓ All unit tests still pass

Test Suites: 2 passed, 2 total
Tests:       15 passed, 15 total
Coverage:    87% lines, 82% branches
```

✅ **REFACTOR complete** - Code improved, tests still passing!

**Benefits of refactoring**:
- Eliminated duplicated error response formatting
- Centralized error definitions (easier to maintain consistency)
- More readable controller code
- Easier to add new error types in the future

---

### Step 17: Review Implementation

**Command:**
```
"Act as implementation-reviewer for the user authentication feature"
```

**Review process**:
1. Verify all tests pass
2. Check code quality and adherence to GUIDELINES.md
3. Verify spec requirements met
4. Check test coverage meets requirements (>80% line coverage ✓)

**Outcome**: Approved

**Actions taken by implementation-reviewer**:
1. Creates review document in `/reviews/implementations/user-authentication-v1.0-review.md`
2. **Merges feature branch** to main:
   ```bash
   git checkout main
   git merge feature/user-authentication
   git branch -d feature/user-authentication
   ```
3. **Moves spec** from `specs/doing/` to `specs/done/`

**Final repository state:**
```
project/
├── VISION.md
├── SCOPE.md
├── ROADMAP.md
├── SYSTEM_MAP.md
├── GUIDELINES.md
├── specs/
│   └── done/
│       └── user-authentication.md
├── reviews/
│   ├── vision/
│   ├── scope/
│   ├── roadmap/
│   ├── specs/
│   ├── skeletons/
│   ├── tests/
│   └── implementations/
│       └── user-authentication-v1.0-review.md
├── src/
│   ├── routes/
│   │   └── auth.js
│   ├── controllers/
│   │   └── auth-controller.js
│   ├── services/
│   │   └── auth-service.js
│   └── middleware/
│       └── authenticate.js
└── tests/
    ├── integration/
    │   └── auth.test.js
    └── unit/
        └── auth-service.test.js
```

**Git branch**: `main` (feature merged)

---

## Summary

This walkthrough demonstrated the complete workflow:

1. **Strategic Planning** (once per project):
   - Created VISION.md, SCOPE.md, ROADMAP.md
   - Each reviewed and approved
   - Established project foundation

2. **Living Documentation** (continuous):
   - Created initial SYSTEM_MAP.md and GUIDELINES.md
   - Updated as architecture and patterns emerge

3. **Feature Development** (per feature):
   - Spec written and reviewed (proposed → todo)
   - Skeleton created, moved to doing, feature branch created
   - Tests written (RED)
   - Implementation completed (GREEN)
   - Code refactored for quality (REFACTOR)
   - Implementation reviewed and merged (doing → done)

4. **State Tracking**:
   - Directory locations indicate artifact states
   - Git branches separate in-progress work from completed work
   - Reviews gate transitions between states

**Next feature**: Follow steps 9-16 for "Basic Task CRUD" from the roadmap, building on the authentication foundation.
