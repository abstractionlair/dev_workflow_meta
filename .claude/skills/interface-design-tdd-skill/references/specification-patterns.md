# Specification Patterns

Comprehensive examples of good and bad specifications, showing how specification quality affects testability and implementation clarity.

## Pattern: User-Focused Behavior

**Anti-pattern: Technical Implementation Details**

```
❌ Bad Specification:
"The registration form shall use POST method to send data to /api/register endpoint 
which validates the JSON payload using JSON Schema validator and inserts record into 
users table using prepared statement with parameterized query to prevent SQL injection."
```

**Problems:**
- Prescribes HTTP method (POST) - implementation detail
- Specifies endpoint path - might change
- Mandates JSON Schema - constrains implementation
- Dictates SQL approach - not behavior

**Pattern: Observable User Behavior**

```
✅ Good Specification:
"User Registration

Behavior:
- User provides email and password
- System validates input format
- System creates unique user account
- System returns success confirmation

Acceptance Criteria:
1. Email must be valid format (user@domain.tld)
2. Password must be 8+ characters
3. Email must be unique (not already registered)
4. System generates unique user ID
5. Response includes user ID and email

Success Response:
- user_id: unique identifier
- email: registered email address
- created_at: registration timestamp

Error Conditions:
- DuplicateEmailError: Email already registered
- ValidationError: Invalid email format
- ValidationError: Password too short
- ValidationError: Missing required fields

Performance:
- Complete within 200ms (95th percentile)

Security:
- Password stored securely (not plaintext)
- Rate limit: 5 attempts per minute per IP
"
```

**Why better:**
- Focuses on what user experiences
- Lists observable outcomes
- Specifies errors explicitly
- Can be tested at API level (any protocol)
- Implementation flexible (SQL, NoSQL, whatever)

---

## From Bad to Good: Shopping Cart Example

**Original (Bad):**
```
"Build a shopping cart that lets users add products and checkout."
```

**Improved:**

```
Shopping Cart - Add Product Feature

Behavior:
- User selects product and quantity
- System adds product to cart
- Cart total updates

Acceptance Criteria:
1. User can add product by product ID
2. User specifies quantity (default: 1)
3. If product already in cart, increase quantity
4. Cart total recalculates after each addition

Validation:
- Product must exist
- Quantity must be positive integer
- Quantity must not exceed available stock

Error Conditions:
- ProductNotFoundError: product doesn't exist
- ValidationError: quantity ≤ 0
- ValidationError: quantity > available stock

Examples:
- Add product (ID: 123, qty: 2, price: $10) → Total: $20
- Add same product (qty: 1) → Total: $30, qty now 3
- Add out-of-stock product → ProductNotFoundError
"
```

**Why testable:**
- Each criterion = test case
- Error conditions explicit
- Examples become test data
- Measurable outcomes
