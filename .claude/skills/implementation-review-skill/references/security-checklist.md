# Security Checklist

Comprehensive security review checklist for implementation review. Focus on common vulnerabilities that can be caught through code review.

## OWASP Top 10 Considerations

### 1. Injection Attacks

#### SQL Injection

**Vulnerability:**
```python
# ❌ CRITICAL: SQL Injection
def get_user(self, email: str):
    query = f"SELECT * FROM users WHERE email = '{email}'"
    return self.db.execute(query)
    # Attacker input: "' OR '1'='1" returns all users
```

**Fix:**
```python
# ✅ Parameterized query
def get_user(self, email: str):
    query = "SELECT * FROM users WHERE email = ?"
    return self.db.execute(query, (email,))
```

#### Command Injection

**Vulnerability:**
```python
# ❌ CRITICAL: Command injection
def convert_image(self, filename: str):
    os.system(f"convert {filename} output.png")
    # Attacker: "image.jpg; rm -rf /"
```

**Fix:**
```python
# ✅ Use subprocess with list arguments
def convert_image(self, filename: str):
    subprocess.run(["convert", filename, "output.png"], check=True)
```

#### NoSQL Injection

**Vulnerability:**
```python
# ❌ MongoDB injection
def find_user(self, username: str):
    return db.users.find_one({"username": username})
    # Attacker: {"$ne": null} matches all users
```

**Fix:**
```python
# ✅ Validate input type
def find_user(self, username: str):
    if not isinstance(username, str):
        raise TypeError("Username must be string")
    return db.users.find_one({"username": username})
```

### 2. Authentication & Session Management

#### Weak Password Storage

**Vulnerability:**
```python
# ❌ CRITICAL: Plaintext password
user = User(email=email, password=password)
db.save(user)

# ❌ CRITICAL: Weak hash (MD5/SHA1)
import hashlib
password_hash = hashlib.md5(password.encode()).hexdigest()
```

**Fix:**
```python
# ✅ Use bcrypt/argon2
import bcrypt

password_hash = bcrypt.hashpw(password.encode(), bcrypt.gensalt())
user = User(email=email, password_hash=password_hash)
```

#### Session Fixation

**Vulnerability:**
```python
# ❌ Session not regenerated after login
def login(self, username, password):
    if self._verify(username, password):
        session['user_id'] = user.id
        # Keeps same session ID - vulnerable to fixation
```

**Fix:**
```python
# ✅ Regenerate session on privilege change
def login(self, username, password):
    if self._verify(username, password):
        session.regenerate()  # New session ID
        session['user_id'] = user.id
```

#### Insecure Session Storage

**Vulnerability:**
```python
# ❌ JWT with sensitive data, no expiration
token = jwt.encode({
    'user_id': 123,
    'password': 'secret',  # ❌ Never in token
    'credit_card': '1234'  # ❌ Never in token
}, SECRET_KEY)
```

**Fix:**
```python
# ✅ Minimal data, expiration
token = jwt.encode({
    'user_id': 123,
    'exp': datetime.utcnow() + timedelta(hours=1)
}, SECRET_KEY, algorithm='HS256')
```

### 3. Cross-Site Scripting (XSS)

#### Reflected XSS

**Vulnerability:**
```python
# ❌ User input directly in HTML
@app.route('/search')
def search():
    query = request.args.get('q')
    return f"<h1>Results for: {query}</h1>"
    # Attacker: ?q=<script>alert('XSS')</script>
```

**Fix:**
```python
# ✅ Escape HTML
from html import escape

@app.route('/search')
def search():
    query = request.args.get('q')
    return f"<h1>Results for: {escape(query)}</h1>"
```

#### Stored XSS

**Vulnerability:**
```python
# ❌ Storing unescaped user content
def save_comment(self, text: str):
    comment = Comment(text=text)  # Raw HTML stored
    db.save(comment)

def display_comment(self, comment_id):
    comment = db.get(comment_id)
    return f"<div>{comment.text}</div>"  # XSS if text contains <script>
```

**Fix:**
```python
# ✅ Sanitize on input or escape on output
import bleach

def save_comment(self, text: str):
    cleaned = bleach.clean(text, tags=['p', 'b', 'i'], strip=True)
    comment = Comment(text=cleaned)
    db.save(comment)
```

### 4. Broken Access Control

#### Missing Authorization Checks

**Vulnerability:**
```python
# ❌ No authorization check
@app.route('/admin/users/<user_id>/delete')
def delete_user(user_id):
    db.delete_user(user_id)
    # Any logged-in user can delete any user!
```

**Fix:**
```python
# ✅ Check authorization
@app.route('/admin/users/<user_id>/delete')
@require_admin  # Decorator checks user is admin
def delete_user(user_id):
    db.delete_user(user_id)

# Or manually:
def delete_user(user_id, requesting_user):
    if not requesting_user.is_admin:
        raise UnauthorizedError("Admin access required")
    db.delete_user(user_id)
```

#### Insecure Direct Object Reference (IDOR)

**Vulnerability:**
```python
# ❌ No ownership check
@app.route('/orders/<order_id>')
def get_order(order_id):
    order = db.get_order(order_id)
    return jsonify(order)
    # User can view anyone's orders by changing ID
```

**Fix:**
```python
# ✅ Verify ownership
@app.route('/orders/<order_id>')
@login_required
def get_order(order_id):
    order = db.get_order(order_id)
    if order.user_id != current_user.id:
        raise ForbiddenError("Not your order")
    return jsonify(order)
```

### 5. Security Misconfiguration

#### Hardcoded Secrets

**Vulnerability:**
```python
# ❌ CRITICAL: Hardcoded credentials
DATABASE_URL = "postgresql://admin:P@ssw0rd123@db.example.com/prod"
API_KEY = "sk-1234567890abcdef"
SECRET_KEY = "my-secret-key-123"
```

**Fix:**
```python
# ✅ Environment variables
import os

DATABASE_URL = os.environ.get('DATABASE_URL')
API_KEY = os.environ.get('API_KEY')
SECRET_KEY = os.environ.get('SECRET_KEY')

if not all([DATABASE_URL, API_KEY, SECRET_KEY]):
    raise ValueError("Missing required environment variables")
```

#### Debug Mode in Production

**Vulnerability:**
```python
# ❌ Debug mode exposes stack traces, variables
app.run(debug=True)
```

**Fix:**
```python
# ✅ Debug only in development
DEBUG = os.environ.get('ENVIRONMENT') == 'development'
app.run(debug=DEBUG)
```

#### Verbose Error Messages

**Vulnerability:**
```python
# ❌ Exposes system details
@app.errorhandler(500)
def internal_error(error):
    return f"Database error: {str(error)}, SQL: {error.sql}"
    # Reveals database structure
```

**Fix:**
```python
# ✅ Generic message, log details
@app.errorhandler(500)
def internal_error(error):
    logger.error(f"Internal error: {error}", exc_info=True)
    return "An internal error occurred", 500
```

### 6. Sensitive Data Exposure

#### Logging Sensitive Data

**Vulnerability:**
```python
# ❌ Logs contain sensitive data
def process_payment(self, card_number: str, cvv: str):
    logger.info(f"Processing payment: card={card_number}, cvv={cvv}")
    # Sensitive data in logs!
```

**Fix:**
```python
# ✅ Redact sensitive data
def process_payment(self, card_number: str, cvv: str):
    logger.info(f"Processing payment: card=****{card_number[-4:]}")
    # Only log last 4 digits
```

#### Unencrypted Communication

**Vulnerability:**
```python
# ❌ HTTP for sensitive operations
response = requests.post('http://api.example.com/payment', data=payment_data)
```

**Fix:**
```python
# ✅ HTTPS only
response = requests.post('https://api.example.com/payment', data=payment_data)

# Better: Enforce HTTPS
if not url.startswith('https://'):
    raise ValueError("HTTPS required for sensitive operations")
```

### 7. Path Traversal

**Vulnerability:**
```python
# ❌ CRITICAL: Path traversal
def read_file(self, filename: str):
    with open(f"/uploads/{filename}") as f:
        return f.read()
    # Attacker: filename="../../etc/passwd"
```

**Fix:**
```python
# ✅ Validate and normalize path
from pathlib import Path

def read_file(self, filename: str):
    base_dir = Path("/uploads").resolve()
    file_path = (base_dir / filename).resolve()
    
    # Ensure path is within base directory
    if not file_path.is_relative_to(base_dir):
        raise ValueError("Invalid file path")
    
    return file_path.read_text()
```

### 8. Insecure Deserialization

**Vulnerability:**
```python
# ❌ CRITICAL: Pickle arbitrary data
import pickle

def load_session(self, session_data: bytes):
    session = pickle.loads(session_data)
    # Attacker can execute arbitrary code via pickle
    return session
```

**Fix:**
```python
# ✅ Use safe serialization (JSON)
import json

def load_session(self, session_data: str):
    session = json.loads(session_data)
    return session
```

### 9. Insufficient Logging & Monitoring

**Missing Security Event Logging:**
```python
# ❌ No audit trail
def delete_user(self, user_id: int):
    db.delete(user_id)
    # No log of who deleted what
```

**Fix:**
```python
# ✅ Log security events
def delete_user(self, user_id: int, requesting_user: User):
    self._check_authorization(requesting_user)
    
    logger.warning(
        "User deletion",
        extra={
            'action': 'delete_user',
            'target_user_id': user_id,
            'requesting_user_id': requesting_user.id,
            'ip_address': request.remote_addr,
            'timestamp': datetime.utcnow()
        }
    )
    
    db.delete(user_id)
```

### 10. Using Components with Known Vulnerabilities

**Outdated Dependencies:**
```python
# ❌ Old versions with known CVEs
# requirements.txt
django==2.0.0  # Has known security issues
requests==2.18.0  # Vulnerable to CVE-2018-18074
```

**Fix:**
```bash
# ✅ Keep dependencies updated
pip install --upgrade django requests

# Use tools to check for vulnerabilities
pip install safety
safety check
```

## Additional Security Checks

### Timing Attacks

**Vulnerability:**
```python
# ❌ Vulnerable to timing attack
def verify_api_key(self, provided_key: str) -> bool:
    correct_key = self.get_api_key()
    return provided_key == correct_key
    # Different time for each wrong character position
```

**Fix:**
```python
# ✅ Constant-time comparison
import secrets

def verify_api_key(self, provided_key: str) -> bool:
    correct_key = self.get_api_key()
    return secrets.compare_digest(provided_key, correct_key)
```

### Race Conditions

**Vulnerability:**
```python
# ❌ Race condition in check-then-act
def withdraw(self, amount: float):
    if self.balance >= amount:  # Check
        time.sleep(0.1)  # Simulates processing time
        self.balance -= amount  # Act
    # Two concurrent withdrawals can both pass check
```

**Fix:**
```python
# ✅ Atomic operation or locking
def withdraw(self, amount: float):
    with self.lock:  # Exclusive lock
        if self.balance >= amount:
            self.balance -= amount
```

### Weak Random Number Generation

**Vulnerability:**
```python
# ❌ Predictable random for security
import random

def generate_token() -> str:
    return ''.join(random.choices(string.ascii_letters, k=32))
    # Predictable seed
```

**Fix:**
```python
# ✅ Cryptographically secure random
import secrets

def generate_token() -> str:
    return secrets.token_urlsafe(32)
```

### XML External Entity (XXE)

**Vulnerability:**
```python
# ❌ Vulnerable XML parsing
import xml.etree.ElementTree as ET

def parse_xml(self, xml_data: str):
    tree = ET.fromstring(xml_data)
    # Can be exploited to read files, SSRF, DOS
```

**Fix:**
```python
# ✅ Disable external entities
import defusedxml.ElementTree as ET

def parse_xml(self, xml_data: str):
    tree = ET.fromstring(xml_data)
```

### Server-Side Request Forgery (SSRF)

**Vulnerability:**
```python
# ❌ Unvalidated URL fetch
def fetch_url(self, url: str):
    response = requests.get(url)
    # Attacker: url="http://localhost/admin"
    return response.text
```

**Fix:**
```python
# ✅ Whitelist allowed domains
ALLOWED_DOMAINS = ['api.trusted.com', 'cdn.trusted.com']

def fetch_url(self, url: str):
    from urllib.parse import urlparse
    
    parsed = urlparse(url)
    if parsed.hostname not in ALLOWED_DOMAINS:
        raise ValueError("Domain not allowed")
    
    response = requests.get(url)
    return response.text
```

## Security Review Checklist

Use this during every implementation review:

### Input Validation
- [ ] All user input validated
- [ ] Whitelisting used where possible (not blacklisting)
- [ ] Type checking enforced
- [ ] Length limits on strings
- [ ] Range checks on numbers

### Authentication
- [ ] Passwords hashed with bcrypt/argon2
- [ ] No credentials in code
- [ ] Session regenerated on login
- [ ] Logout clears session completely
- [ ] Account lockout after failed attempts

### Authorization
- [ ] Every privileged operation checks authorization
- [ ] Ownership verified for user resources
- [ ] Role-based access control implemented
- [ ] Principle of least privilege followed

### Data Protection
- [ ] Sensitive data encrypted at rest
- [ ] HTTPS enforced for sensitive operations
- [ ] No sensitive data in logs
- [ ] No sensitive data in URLs
- [ ] Sensitive data redacted in errors

### Injection Prevention
- [ ] Parameterized queries used (SQL)
- [ ] Input validated before command execution
- [ ] HTML escaped before rendering
- [ ] NoSQL queries validated

### Error Handling
- [ ] Generic error messages to users
- [ ] Detailed errors logged server-side
- [ ] No stack traces exposed
- [ ] No system info leaked

### Cryptography
- [ ] Strong algorithms (AES-256, RSA-2048+)
- [ ] Secrets.token_urlsafe() for tokens
- [ ] No deprecated algorithms (MD5, SHA1)
- [ ] Proper key management

### File Operations
- [ ] Path traversal prevented
- [ ] File type validated
- [ ] File size limited
- [ ] Uploaded files scanned

### Dependencies
- [ ] Dependencies up to date
- [ ] No known vulnerabilities
- [ ] Safety/audit run regularly

### Logging & Monitoring
- [ ] Security events logged
- [ ] Failed auth attempts logged
- [ ] Privilege escalation logged
- [ ] User actions audited

## Language-Specific Notes

### Python

```python
# Use type hints to prevent type confusion
def process_amount(amount: Decimal) -> Decimal:
    # Type checker prevents passing string
    return amount * Decimal('1.1')

# Use context managers for resources
with open('file.txt') as f:
    # Automatically closed, even on exception
    data = f.read()
```

### TypeScript

```typescript
// Use strict type checking
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true
  }
}

// Validate at runtime too (type guards)
function isValidUser(data: unknown): data is User {
  return (
    typeof data === 'object' &&
    data !== null &&
    'email' in data &&
    'id' in data
  );
}
```

## Red Flags to Watch For

During review, these patterns should trigger security investigation:

- ❌ String concatenation in SQL queries
- ❌ `eval()` or `exec()` calls
- ❌ User input in system commands
- ❌ Hardcoded strings that look like secrets
- ❌ Bare `except:` or `catch` clauses
- ❌ HTTP instead of HTTPS
- ❌ `pickle` for untrusted data
- ❌ No authorization checks
- ❌ Logging sensitive data
- ❌ Weak random (random.* for security)

If you see any of these, investigate thoroughly!

## When to Escalate

Some issues require security expert review:

- Custom cryptographic implementations
- Payment processing
- Authentication systems
- Authorization frameworks
- Data handling with regulatory requirements (HIPAA, PCI-DSS)
- Multi-tenant isolation
- Privilege escalation possibilities

Don't try to fix critical security issues alone - get expert help.
