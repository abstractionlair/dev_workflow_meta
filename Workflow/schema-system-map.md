# SYSTEM_MAP Ontology

## Purpose

This document defines the canonical structure, content, and semantics of the SYSTEM_MAP.md file. SYSTEM_MAP.md is a living document that captures the high-level architecture, component relationships, and key design decisions of a project.

This schema serves as the authoritative reference for:
- **platform-lead** (producer/maintainer): What to include in system map
- **spec-writer** (consumer): Architectural context when designing features
- **skeleton-writer** (consumer): Component structure and module organization
- **test-writer** (consumer): Integration points to test
- **implementer** (consumer): Where code fits in architecture
- **All reviewers** (consumers): Architectural compliance checking

## Document Type

**Format:** Markdown (.md)
**Producer:** platform-lead (creates initial version)
**Maintainers:** platform-lead (approves updates), implementer (proposes architecture changes)
**Primary Consumers:** spec-writer, skeleton-writer, implementer
**Secondary Consumers:** All reviewer roles, stakeholders, new team members

## File Location

**Path:** `/SYSTEM_MAP.md` (project root)

**Rationale:** Root location makes it discoverable and accessible from anywhere in codebase

**Single file:** Unlike specs (many files), system map is one living document

## Document Evolution

**Lifecycle:**
- **Initial creation**: platform-lead creates during living documentation setup (after VISION/SCOPE/ROADMAP approved)
- **Continuous evolution**: Updated after features that change architecture
- **Version tracking**: Track major changes in Git commit history

**Update triggers:**
- New component added
- Component relationships change
- Integration pattern established
- Technology choice made
- Architectural decision recorded
- Module structure refactored

**Update approval:**
- platform-lead must approve all SYSTEM_MAP.md changes
- Changes proposed via feature branch (like code changes)
- Living doc updates reviewed before merge

---

## Required Structure

### Document Header

```markdown
# System Map: [Project Name]

**Purpose:** Document high-level architecture and key design decisions for [Project Name]

**Last Updated:** [ISO 8601 date]
**Version:** [Semantic version]
```

**Field Definitions:**

#### Project Name
- Matches VISION.md project name
- Provides context for architecture

#### Last Updated
- ISO 8601 date (e.g., `2025-10-23`)
- Tracks currency of architecture documentation

#### Version
- Semantic versioning (1.0, 1.1, 2.0)
- Increment minor version for new components/integrations
- Increment major version for architectural redesigns

---

## Section 1: Architecture Overview

```markdown
## Architecture Overview

[2-4 paragraphs describing overall system design and philosophy]

### High-Level Diagram

```
[ASCII art or reference to diagram file]
```
```

**Purpose:** Provide 10,000-foot view of system

**Content Requirements:**
- 2-4 paragraphs explaining architectural approach
- High-level diagram showing major components
- Architectural style (monolith, microservices, layered, etc.)
- Key design philosophy
- External dependencies shown

**Diagram Guidelines:**
- ASCII art for simplicity (easily version-controlled)
- Or reference to .svg/.png in repo
- Show components as boxes
- Show relationships as arrows
- Include external systems
- Keep high-level (details come later)

**Example:**

```markdown
## Architecture Overview

TaskFlow API follows a layered architecture pattern with clear separation between HTTP, business logic, and data layers. This enables the core business logic to be reused across multiple interfaces (REST API, CLI tools, background jobs) without modification.

The system is designed as a modular monolith - single deployable unit with well-defined internal module boundaries. This provides simplicity of deployment while maintaining flexibility to extract modules into microservices if scaling demands emerge.

External dependencies are minimized and abstracted behind interfaces. The only hard external dependency is PostgreSQL for persistence; all other integrations (email, analytics) use abstract interfaces allowing easy replacement.

### High-Level Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                      External Clients                        │
│           (Web App, Mobile App, CLI, Integrations)           │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTPS/JSON
                         ↓
┌─────────────────────────────────────────────────────────────┐
│                      API Gateway Layer                       │
│  - Authentication (JWT)                                      │
│  - Rate Limiting                                             │
│  - Request Validation                                        │
│  - CORS                                                      │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ↓
┌─────────────────────────────────────────────────────────────┐
│                    Business Logic Layer                      │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌─────────────────┐  │
│  │     User     │  │     Task     │  │     Project     │  │
│  │   Service    │  │   Service    │  │    Service      │  │
│  └──────────────┘  └──────────────┘  └─────────────────┘  │
│                                                              │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ↓
┌─────────────────────────────────────────────────────────────┐
│                    Data Access Layer                         │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌─────────────────┐  │
│  │     User     │  │     Task     │  │     Project     │  │
│  │  Repository  │  │  Repository  │  │   Repository    │  │
│  └──────────────┘  └──────────────┘  └─────────────────┘  │
│                                                              │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ↓
                  ┌─────────────┐
                  │  PostgreSQL │
                  │   Database  │
                  └─────────────┘

External Integrations (via Service Layer):
  ┌──────────────┐       ┌──────────────┐
  │ Email Service│       │  Analytics   │
  │  (SendGrid)  │       │  (Optional)  │
  └──────────────┘       └──────────────┘
```
```

---

## Section 2: Component Catalog

```markdown
## Component Catalog

### [Component 1 Name]

**Purpose:** [What this component does]

**Responsibilities:**
- [Responsibility 1]
- [Responsibility 2]

**Dependencies:**
- [Dependency 1]
- [Dependency 2]

**Exposes:**
- [Interface/API 1]
- [Interface/API 2]

**Technology:** [Languages, frameworks, libraries]

---

### [Component 2 Name]
...
```

**Purpose:** Document each major component in detail

**Content Requirements:**
- One subsection per major component
- Purpose: One-sentence description
- Responsibilities: Bullet list of what component owns
- Dependencies: What this component depends on
- Exposes: What interfaces/APIs this provides to other components
- Technology: Tech stack for this component

**Example:**

```markdown
## Component Catalog

### API Gateway Layer

**Purpose:** Handle HTTP concerns (authentication, validation, routing) and translate between HTTP and business logic

**Responsibilities:**
- JWT token validation
- Rate limiting per user/IP
- Request body validation
- CORS header management
- Error response formatting
- Request logging

**Dependencies:**
- Business Logic Layer (UserService, TaskService, ProjectService)
- JWT library for token validation
- Express.js middleware framework

**Exposes:**
- REST API endpoints (documented in OpenAPI spec)
- Health check endpoint `/health`

**Technology:** Node.js, Express.js, express-jwt, express-rate-limit

---

### User Service

**Purpose:** Implement user management business logic (registration, authentication, profile management)

**Responsibilities:**
- User registration with validation
- User authentication (password verification)
- JWT token generation
- Profile updates
- User deletion
- NO HTTP concerns (no req/res handling)

**Dependencies:**
- UserRepository (data access)
- EmailService (welcome emails)
- PasswordHasher utility (bcrypt)

**Exposes:**
- `createUser(email, password, name): Promise<User>`
- `authenticateUser(email, password): Promise<{user, token}>`
- `getUser(userId): Promise<User>`
- `updateUser(userId, updates): Promise<User>`
- `deleteUser(userId): Promise<void>`

**Technology:** JavaScript (ES6+), bcrypt for password hashing

---

### UserRepository

**Purpose:** Abstract data access for User entities, translate between domain models and database schema

**Responsibilities:**
- Execute database queries for users table
- Map database rows to User domain objects
- Transaction management for multi-step operations
- NO business logic (no validation, no password hashing)

**Dependencies:**
- PostgreSQL database
- Database connection pool

**Exposes:**
- `save(user): Promise<User>`
- `findById(userId): Promise<User | null>`
- `findByEmail(email): Promise<User | null>`
- `update(userId, data): Promise<User>`
- `delete(userId): Promise<void>`

**Technology:** Node.js, pg (PostgreSQL client), SQL

---

### PostgreSQL Database

**Purpose:** Persistent storage for all application data

**Responsibilities:**
- Store users, tasks, projects data
- Enforce referential integrity
- Execute queries efficiently (indexes)
- Handle concurrent access (transactions)

**Dependencies:**
- None (external system)

**Exposes:**
- SQL interface via TCP connection
- Tables: users, tasks, projects, tags

**Technology:** PostgreSQL 15

---

### Email Service

**Purpose:** Send transactional emails (welcome, password reset, notifications)

**Responsibilities:**
- Format emails using templates
- Send via external email provider
- Handle send failures gracefully
- NO user data persistence

**Dependencies:**
- SendGrid API (external service)
- Email templates (HTML/text)

**Exposes:**
- `sendWelcome(user): Promise<void>`
- `sendPasswordReset(user, resetToken): Promise<void>`
- `sendTaskNotification(user, task): Promise<void>`

**Technology:** Node.js, @sendgrid/mail, Handlebars templates
```

---

## Section 3: Data Flow

```markdown
## Data Flow

### [Use Case 1]

```
[ASCII diagram showing data flow through components]
```

**Steps:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

---

### [Use Case 2]
...
```

**Purpose:** Show how data moves through system for key use cases

**Content Requirements:**
- 2-5 critical use cases
- ASCII diagram showing component interactions
- Numbered steps describing flow
- Highlight any transforms or validations

**Example:**

```markdown
## Data Flow

### User Registration

```
Client
  │
  │ POST /api/auth/register
  │ { email, password, name }
  ↓
API Gateway
  │ (validate JWT format, rate limit check)
  ↓
UserService
  │ 1. Validate email format
  │ 2. Check for duplicate email (via UserRepository)
  │ 3. Hash password (via PasswordHasher)
  │ 4. Create user (via UserRepository)
  │ 5. Send welcome email (via EmailService)
  ↓
UserRepository
  │ INSERT INTO users ...
  ↓
PostgreSQL
  │ Store user record
  ↓
UserRepository
  │ Return created user
  ↓
UserService
  │ Return user (without password hash)
  ↓
API Gateway
  │ Format JSON response
  │ Set 201 Created status
  ↓
Client
  │ Receive user data
```

**Steps:**
1. Client sends registration request to API Gateway
2. API Gateway validates request format and checks rate limits
3. UserService validates email format
4. UserService checks for duplicate email via UserRepository
5. UserService hashes password via PasswordHasher
6. UserService saves user via UserRepository
7. UserRepository executes SQL INSERT and returns created user
8. UserService triggers welcome email via EmailService (async, non-blocking)
9. UserService returns user data (password hash removed) to API Gateway
10. API Gateway formats JSON response and returns 201 Created to client

**Data transforms:**
- Password: plaintext → bcrypt hash (UserService → PasswordHasher)
- User object: domain model → database row (UserRepository)
- User object: database row → domain model (UserRepository)
- User object: includes password hash → excludes password hash (UserService before return)

---

### Task Query

```
Client
  │ GET /api/tasks?projectId=123
  ↓
API Gateway
  │ (authenticate JWT, authorize user)
  ↓
TaskService
  │ 1. Verify user has access to project (via ProjectService)
  │ 2. Fetch tasks (via TaskRepository)
  │ 3. Apply filtering/sorting
  ↓
TaskRepository
  │ SELECT * FROM tasks WHERE project_id = 123 ...
  ↓
PostgreSQL
  │ Execute query, return rows
  ↓
TaskRepository
  │ Map rows to Task domain objects
  ↓
TaskService
  │ Return tasks
  ↓
API Gateway
  │ Format JSON response
  ↓
Client
  │ Receive task list
```

**Steps:**
1. Client requests tasks for specific project
2. API Gateway validates JWT token and extracts user ID
3. TaskService verifies user has access to requested project (via ProjectService)
4. TaskService requests tasks from TaskRepository with filters
5. TaskRepository executes SQL query with WHERE clause
6. PostgreSQL returns matching rows
7. TaskRepository maps database rows to Task domain objects
8. TaskService returns tasks to API Gateway
9. API Gateway formats JSON response
10. Client receives task list

**Caching:** Tasks for a project cached for 60 seconds (see Performance Optimizations)
```

---

## Section 4: Integration Points

```markdown
## Integration Points

### [Integration 1]

**Type:** [REST API, GraphQL, Message Queue, Database, etc.]

**Direction:** [Inbound | Outbound | Bidirectional]

**Purpose:** [Why this integration exists]

**Protocol:** [HTTP, gRPC, AMQP, etc.]

**Authentication:** [How authentication works]

**Error Handling:** [How failures are handled]

**Fallback Strategy:** [What happens if integration unavailable]

---

### [Integration 2]
...
```

**Purpose:** Document all external integrations

**Content Requirements:**
- One subsection per external integration
- Type of integration
- Direction (who initiates)
- Purpose (why it exists)
- Protocol details
- Authentication mechanism
- Error handling strategy
- Fallback/degradation plan

**Example:**

```markdown
## Integration Points

### SendGrid Email API

**Type:** REST API (external SaaS)

**Direction:** Outbound (we call SendGrid)

**Purpose:** Send transactional emails (welcome, password reset, notifications)

**Protocol:** HTTPS REST API

**Authentication:** API key in Authorization header

**Error Handling:**
- Network failures: Retry 3 times with exponential backoff
- 4xx errors: Log and alert (indicates misconfiguration)
- 5xx errors: Retry 3 times, then log and continue (email is non-critical)

**Fallback Strategy:**
- Email failures do not block user operations
- Failed emails logged for manual retry
- Consider fallback to secondary provider if SendGrid unavailable >1 hour

**Configuration:**
- API key stored in environment variable `SENDGRID_API_KEY`
- Base URL: `https://api.sendgrid.com/v3`

**Rate Limits:** 100 emails/second (well below our expected load)

---

### PostgreSQL Database

**Type:** Relational database

**Direction:** Bidirectional (we read/write)

**Purpose:** Persistent storage for all application data

**Protocol:** PostgreSQL wire protocol over TCP

**Authentication:** Username/password (stored in environment)

**Error Handling:**
- Connection failures: Application fails to start (database required)
- Query errors: Return 500 to client, log error
- Transaction deadlocks: Automatic retry up to 3 times

**Fallback Strategy:**
- No fallback - database is required dependency
- Read replicas planned for future (horizontal scaling)

**Configuration:**
- Connection string in `DATABASE_URL` environment variable
- Connection pool: 20 connections max

**Backup Strategy:** Daily automated backups retained 30 days

---

### Client Applications (Inbound)

**Type:** REST API consumers

**Direction:** Inbound (clients call our API)

**Purpose:** Provide task management functionality to external applications

**Protocol:** HTTPS REST API (JSON payloads)

**Authentication:** JWT tokens (issued after login)

**Rate Limiting:**
- 100 requests/minute per user
- 1000 requests/minute per API key (for service accounts)

**Error Handling:**
- Invalid requests: Return 400 with detailed error message
- Unauthenticated: Return 401 with WWW-Authenticate header
- Rate limit exceeded: Return 429 with Retry-After header

**API Documentation:** OpenAPI 3.0 spec at `/api/docs`
```

---

## Section 5: Key Design Decisions

```markdown
## Key Design Decisions

### [Decision 1]

**Decision:** [What was decided]

**Rationale:** [Why this decision was made]

**Alternatives Considered:**
- [Alternative 1]: [Why rejected]
- [Alternative 2]: [Why rejected]

**Trade-offs:**
- **Pros:** [Advantages]
- **Cons:** [Disadvantages]

**Date:** [When decided]

**Status:** [Active | Deprecated | Under Review]

---

### [Decision 2]
...
```

**Purpose:** Document important architectural choices

**Content Requirements:**
- Decision statement (what was chosen)
- Rationale (why)
- Alternatives considered (what was rejected and why)
- Trade-offs (pros/cons)
- Date (when decided)
- Status (is this still current?)

**When to document:**
- Technology choices (framework, database, library)
- Architectural patterns (layered vs microservices, etc.)
- Integration approaches
- Performance/security trade-offs
- Major refactoring decisions

**Example:**

```markdown
## Key Design Decisions

### Decision 1: Layered Architecture (Not Microservices)

**Decision:** Build as modular monolith with layered architecture, not microservices

**Rationale:**
- Team size (2 people) makes operating multiple services expensive
- Expected load (1000 concurrent users) comfortably handled by monolith
- Deployment simplicity critical for small team
- Internal module boundaries allow future extraction if needed

**Alternatives Considered:**
- **Microservices:** Rejected due to operational overhead (deployment, monitoring, debugging) and team size
- **Serverless functions:** Rejected due to cold start latency and PostgreSQL connection pooling challenges

**Trade-offs:**
- **Pros:**
  - Simple deployment (single process)
  - Easy debugging (single codebase)
  - Lower operational overhead
  - Fast internal communication (in-process calls)
- **Cons:**
  - Harder to scale individual components
  - Single failure point (entire app down if process crashes)
  - Requires discipline to maintain module boundaries

**Date:** 2025-09-15

**Status:** Active

---

### Decision 2: PostgreSQL (Not MongoDB)

**Decision:** Use PostgreSQL for all persistent storage

**Rationale:**
- Task/project data is highly relational (tasks belong to projects, users own tasks)
- Need for referential integrity (cascade deletes when project deleted)
- Complex queries required (filter tasks by multiple dimensions)
- Team experience with SQL stronger than NoSQL

**Alternatives Considered:**
- **MongoDB:** Rejected due to lack of strong relationships and team SQL preference
- **MySQL:** Rejected due to PostgreSQL's superior JSON support (for future flexible metadata)

**Trade-offs:**
- **Pros:**
  - Strong consistency and ACID transactions
  - Rich query capabilities (joins, aggregations)
  - JSON columns for flexible metadata
  - Mature ecosystem and tooling
- **Cons:**
  - Vertical scaling limits (though ample for expected load)
  - Schema migrations require more planning than NoSQL

**Date:** 2025-09-18

**Status:** Active

---

### Decision 3: JWT Authentication (Not Session Cookies)

**Decision:** Use JWT tokens for authentication, not server-side sessions

**Rationale:**
- Stateless authentication enables horizontal scaling
- Clients (mobile, web, CLI) benefit from portable tokens
- Reduces database load (no session lookup on each request)

**Alternatives Considered:**
- **Session cookies:** Rejected due to server-side state requirement and scaling complexity
- **OAuth2:** Overkill for MVP; consider for future if third-party app integration needed

**Trade-offs:**
- **Pros:**
  - Stateless (no session storage needed)
  - Horizontally scalable
  - Works across all client types
- **Cons:**
  - Cannot revoke tokens before expiration (mitigated by short 24-hour expiration)
  - Token size larger than session cookie
  - Logout requires client-side token deletion (no server-side enforcement)

**Date:** 2025-09-20

**Status:** Active

**Future consideration:** Add token blacklist for logout if revocation becomes critical
```

---

## Section 6: Technology Stack

```markdown
## Technology Stack

### Runtime
- [Language/runtime and version]

### Frameworks
- [Framework 1]
- [Framework 2]

### Data Storage
- [Database type and version]

### External Services
- [Service 1]
- [Service 2]

### Development Tools
- [Tool 1]
- [Tool 2]

### Testing
- [Test framework]
- [Test tools]
```

**Purpose:** Centralized reference for all technology choices

**Content Requirements:**
- Runtime/language with version
- Major frameworks
- Data storage
- External services/APIs
- Development/build tools
- Testing frameworks

**Example:**

```markdown
## Technology Stack

### Runtime
- **Node.js 20 LTS** - JavaScript runtime
- **npm 10** - Package manager

### Frameworks
- **Express.js 4.x** - Web application framework
- **Jest 29** - Testing framework

### Data Storage
- **PostgreSQL 15** - Primary relational database
- **pg 8.x** - PostgreSQL client for Node.js

### External Services
- **SendGrid** - Transactional email delivery
- **Cloudflare** - DNS and DDoS protection

### Development Tools
- **ESLint** - Linting and code quality
- **Prettier** - Code formatting
- **Nodemon** - Development server with auto-reload

### Testing
- **Jest** - Test framework and test runner
- **Supertest** - HTTP integration testing
- **mock-pg** - PostgreSQL mock for unit tests

### Deployment
- **Docker** - Containerization
- **GitHub Actions** - CI/CD pipeline
- **Fly.io** - Hosting platform

### Monitoring (Planned)
- **Sentry** - Error tracking
- **Datadog** - APM and logging
```

---

## Section 7: Performance Characteristics

```markdown
## Performance Characteristics

### Latency Targets
- [Operation 1]: [Target latency]
- [Operation 2]: [Target latency]

### Throughput Targets
- [Metric]: [Target throughput]

### Resource Limits
- [Resource]: [Limit]

### Bottlenecks
- [Known bottleneck 1]
- [Known bottleneck 2]

### Optimizations
- [Optimization 1]
- [Optimization 2]
```

**Purpose:** Document performance goals and current optimizations

**Content Requirements:**
- Latency targets for key operations
- Throughput targets
- Resource constraints
- Known bottlenecks
- Current optimizations

**Example:**

```markdown
## Performance Characteristics

### Latency Targets

**API Endpoints:**
- GET requests: <100ms (p95), <200ms (p99)
- POST/PUT/DELETE: <200ms (p95), <500ms (p99)

**Database Queries:**
- Simple lookups (by ID): <10ms
- Filtered queries: <50ms (p95)
- Complex aggregations: <200ms (p95)

**External API Calls:**
- SendGrid email: <500ms (p95), non-blocking

### Throughput Targets

- **Concurrent users:** 1,000 users (current target)
- **Requests per second:** 500 req/s (peak load)
- **Database queries:** 2,000 queries/s (with connection pool of 20)

### Resource Limits

- **Memory:** 512 MB per process (container limit)
- **Database connections:** 20 (connection pool size)
- **File uploads:** 10 MB max per upload

### Bottlenecks

**Current:**
- Database queries for task lists with complex filters (addressed by indexing)
- Email sending can block if SendGrid slow (mitigated by async processing)

**Future:**
- Single PostgreSQL instance will be bottleneck beyond 5,000 concurrent users
- Read replicas planned when approaching limit

### Optimizations

**Caching:**
- Project metadata cached 300 seconds (infrequently changes)
- User profile cached 60 seconds

**Database Indexes:**
- `tasks(project_id, status, created_at)` - Composite index for filtered task queries
- `projects(user_id)` - Index for user's projects lookup

**Connection Pooling:**
- PostgreSQL connection pool (20 connections) to avoid connection overhead

**Async Operations:**
- Email sending non-blocking (fire-and-forget)
- Analytics events buffered and batch-sent every 10 seconds
```

---

## Section 8: Security Architecture

```markdown
## Security Architecture

### Authentication
[How users authenticate]

### Authorization
[How permissions are enforced]

### Data Protection
[How data is secured]

### Network Security
[Firewall, TLS, etc.]

### Secrets Management
[How secrets are stored/accessed]
```

**Purpose:** Document security approach

**Content Requirements:**
- Authentication mechanism
- Authorization model
- Data protection (encryption, etc.)
- Network security
- Secrets management

**Example:**

```markdown
## Security Architecture

### Authentication

**Mechanism:** JWT (JSON Web Tokens)

**Flow:**
1. User provides email/password to `/api/auth/login`
2. Server verifies password (bcrypt comparison)
3. Server generates JWT token (signed with secret, 24-hour expiration)
4. Client includes token in `Authorization: Bearer <token>` header on subsequent requests
5. API Gateway validates token signature and expiration on each request

**Token Structure:**
```json
{
  "userId": "user_123",
  "email": "user@example.com",
  "iat": 1698000000,
  "exp": 1698086400
}
```

### Authorization

**Model:** Role-Based Access Control (RBAC)

**Roles:**
- **User:** Can manage own tasks and projects
- **Admin:** Can access all users' data (for support)

**Enforcement:**
- API Gateway extracts user ID from JWT
- Service layer checks user owns requested resource
- Admin role bypasses ownership check

**Example:**
```javascript
// User can only access own tasks
if (req.user.id !== task.userId && !req.user.isAdmin) {
  throw new ForbiddenError();
}
```

### Data Protection

**At Rest:**
- Passwords hashed with bcrypt (cost factor 10)
- Database encryption enabled (PostgreSQL TDE)
- Backups encrypted with AES-256

**In Transit:**
- HTTPS required for all API communication (TLS 1.3)
- Database connections encrypted (SSL mode: require)

**Sensitive Data:**
- Never log passwords or tokens
- PII (email, name) scrubbed from error messages

### Network Security

**Firewall:**
- PostgreSQL port (5432) only accessible from application servers
- API only accessible via HTTPS (port 443)

**DDoS Protection:**
- Cloudflare in front of API
- Rate limiting: 100 req/min per user, 1000 req/min per IP

**CORS:**
- Whitelist known client domains
- No wildcard (*) allowed in production

### Secrets Management

**Environment Variables:**
- `DATABASE_URL` - PostgreSQL connection string
- `JWT_SECRET` - JWT signing secret (64-character random string)
- `SENDGRID_API_KEY` - Email service API key

**Storage:**
- Development: `.env` file (git-ignored)
- Production: Fly.io secrets (encrypted at rest)

**Rotation:**
- JWT secret rotated every 90 days
- SendGrid API key rotated annually
```

---

## Quality Standards

### Completeness

**Required sections:**
- ✓ Architecture Overview (with diagram)
- ✓ Component Catalog (all major components)
- ✓ Data Flow (2-5 key use cases)
- ✓ Integration Points (all external dependencies)
- ✓ Key Design Decisions (major choices)
- ✓ Technology Stack

**Optional sections** (add as needed):
- Performance Characteristics (if performance-critical)
- Security Architecture (if handling sensitive data)
- Deployment Architecture (if deployment is complex)

### Diagram Quality

**Good diagrams:**
- ✓ ASCII art (version-control friendly)
- ✓ Show component boundaries clearly
- ✓ Indicate data flow direction
- ✓ Include external systems
- ✓ Appropriate level of detail

**Poor diagrams:**
- ✗ Too detailed (implementation details)
- ✗ Too vague (just box with "System")
- ✗ Missing external dependencies
- ✗ Binary image files that can't be diffed

### Accuracy

**Keep system map current:**
- ✓ Update after architectural changes
- ✓ Remove deprecated components
- ✓ Reflect actual implementation (not desired state)
- ✓ Link to code when helpful

**Avoid:**
- ✗ Documenting planned but unimplemented components
- ✗ Keeping removed components in diagrams
- ✗ Contradicting actual code structure

---

## Anti-Patterns

### Anti-Pattern 1: Implementation Details in System Map

**Problem:**
```markdown
### UserService

**Method signatures:**
```javascript
async createUser(email: string, password: string, name: string): Promise<User> {
  // Line-by-line code walkthrough...
}
```
```

**Why it's bad:**
- Too detailed for architecture document
- Duplicates code documentation
- Hard to keep in sync with code

**Fix:**
```markdown
### UserService

**Purpose:** User management business logic

**Responsibilities:**
- User registration with validation
- User authentication
- Profile management

**Exposes:**
- `createUser(email, password, name): Promise<User>`
- `authenticateUser(email, password): Promise<{user, token}>`

[High-level description, not line-by-line code]
```

---

### Anti-Pattern 2: Wishful Thinking Architecture

**Problem:**
```markdown
## Architecture Overview

[Documents microservices architecture that doesn't exist yet]

[Shows Redis caching that hasn't been implemented]

[References components that are planned but not built]
```

**Why it's bad:**
- Misleads developers about current state
- Documentation diverges from reality
- Wastes time following non-existent patterns

**Fix:**
- Document ACTUAL architecture only
- Use separate "Future Architecture" section for plans
- Clearly mark planned vs. implemented

---

### Anti-Pattern 3: No Diagrams

**Problem:**
```markdown
## Architecture Overview

[Pages of text describing components and relationships]

[No visual diagram]
```

**Why it's bad:**
- Hard to understand system at a glance
- Text descriptions of relationships are confusing
- New developers need visual reference

**Fix:**
- Always include architecture diagram
- Use ASCII art if no diagram tool available
- Diagram should be first thing in Architecture Overview

---

### Anti-Pattern 4: Stale System Map

**Problem:**
```markdown
## Component Catalog

### Redis Cache

[Redis removed 6 months ago, still documented]
```

**Why it's bad:**
- Misleads new developers
- Wastes time looking for non-existent components
- Erodes trust in documentation

**Fix:**
- Update system map when architecture changes
- Mark deprecated components clearly
- Remove obsolete components and document in commit message

---

### Anti-Pattern 5: Missing Integration Details

**Problem:**
```markdown
## Integration Points

### SendGrid

We use SendGrid for email.
```

**Why it's bad:**
- No error handling information
- No authentication details
- No fallback strategy
- Developers don't know how to work with integration

**Fix:**
```markdown
## Integration Points

### SendGrid Email API

**Type:** REST API
**Direction:** Outbound
**Purpose:** Send transactional emails
**Protocol:** HTTPS
**Authentication:** API key in Authorization header
**Error Handling:** Retry 3x with backoff, then log and continue
**Fallback:** Non-blocking; email failures don't block user operations
```

---

## Downstream Usage

### spec-writer Consumption

**Reads SYSTEM_MAP.md for:**
- Component boundaries (where feature fits)
- Integration points (external dependencies to consider)
- Design decisions (constraints to respect)
- Technology stack (what tools are available)

**Uses to:**
- Design features that fit architecture
- Identify which components need changes
- Reference existing integration patterns

### skeleton-writer Consumption

**Reads SYSTEM_MAP.md for:**
- Component organization (where to create files)
- Module responsibilities (what belongs where)
- Naming patterns (match existing structure)
- Technology choices (what to use)

**Creates skeletons that:**
- Fit into existing component structure
- Follow architectural patterns
- Use correct technologies

### implementer Consumption

**Reads SYSTEM_MAP.md for:**
- Component boundaries (where code belongs)
- Integration patterns (how to call external services)
- Design decisions (architectural constraints)
- Performance characteristics (optimization targets)

**Creates implementations that:**
- Respect component responsibilities
- Follow integration patterns
- Meet performance targets
- Comply with security architecture

### Reviewers Consumption

**Use SYSTEM_MAP.md to:**
- Verify code fits architecture
- Check component boundaries respected
- Validate integration patterns followed
- Ensure security/performance compliance

---

## Update Workflow

**When to update SYSTEM_MAP.md:**

1. **New Component Added**
   - Feature adds new service/repository/module
   - Add to Component Catalog
   - Update architecture diagram

2. **Integration Added/Changed**
   - New external API integration
   - Changed integration pattern
   - Add/update Integration Points section

3. **Architectural Decision Made**
   - Technology choice (database, framework, etc.)
   - Pattern established (caching strategy, etc.)
   - Add to Key Design Decisions

4. **Performance Optimization**
   - New caching layer
   - Database index added
   - Update Performance Characteristics

**Update process:**

1. Create feature branch
2. Update SYSTEM_MAP.md
3. Create PR with context/rationale in description
4. platform-lead reviews and approves
5. Merge to main

**Living doc update special case:**
- If feature branch modifies SYSTEM_MAP.md
- implementation-reviewer must request platform-lead review before merge
- See role-implementation-reviewer.md for details

---

## Related Schemas

**When creating this artifact:**
- Initial creation: Document existing project structure if transitioning to workflow
- Reference [schema-guidelines.md](schema-guidelines.md) for complementary constraints
- Start minimal, expand as project grows

**When using this artifact:**
- During spec/skeleton/test/implementation: Find existing components and utilities
- During reviews: Verify architectural consistency
- When adding components: Update SYSTEM_MAP.md (living document)

**Continuous updates:**
- Add new modules/directories as created
- Update component descriptions when refactored
- Add integration points when systems connect
- Prune deleted components

For complete schema workflow, see [schema-relationship-map.md](patterns/schema-relationship-map.md).

---

## Summary

SYSTEM_MAP.md is the architectural blueprint that documents how the system is structured and why.

**Key principles:**
- **Visual**: Always include diagrams
- **Accurate**: Reflects actual implementation, not wishful thinking
- **High-level**: Architecture, not code documentation
- **Decision-focused**: Explains WHY, not just WHAT
- **Living**: Updated as architecture evolves

**Core sections:**
- Architecture Overview: 10,000-foot view with diagram
- Component Catalog: Each major component detailed
- Data Flow: How data moves through system
- Integration Points: All external dependencies
- Key Design Decisions: Why architecture is this way
- Technology Stack: What's being used

**Consumers:**
- spec-writer: Architectural context for feature design
- skeleton-writer: Component structure to follow
- implementer: Where code fits and how to integrate
- Reviewers: Architectural compliance checking

**Maintenance:**
- platform-lead approves all updates
- Update after architectural changes
- Keep diagrams in sync with code
- Document decisions, not just structure

SYSTEM_MAP.md enables developers to understand the system's structure and make changes that fit the architecture, preventing "big ball of mud" and architectural erosion.
