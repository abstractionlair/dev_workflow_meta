# Performance Patterns

Common performance anti-patterns to detect during implementation review. Focus on algorithmic complexity and obvious inefficiencies, not premature micro-optimizations.

## Guiding Principles

1. **Don't prematurely optimize** - Profile first, optimize what matters
2. **Algorithmic complexity matters** - O(n²) vs O(n) can be huge
3. **I/O is expensive** - Minimize database queries, network calls, disk operations
4. **Memory is finite** - Don't load entire datasets into memory
5. **Only fix obvious problems** - Don't over-engineer

## Database Anti-Patterns

### N+1 Query Problem

**Problem:** Query executed N+1 times (1 + N in loop).

**Example:**
```python
# ❌ 1 + N queries
def get_posts_with_authors():
    posts = db.query(Post).all()  # 1 query
    for post in posts:
        post.author = db.query(User).get(post.user_id)  # N queries
    return posts
```

**Fix:**
```python
# ✅ Single query with join
def get_posts_with_authors():
    return db.query(Post).options(
        joinedload(Post.author)
    ).all()  # 1 query with JOIN
```

**TypeScript/Prisma:**
```typescript
// ❌ N+1 queries
const posts = await prisma.post.findMany();
for (const post of posts) {
  post.author = await prisma.user.findUnique({
    where: { id: post.userId }
  });
}

// ✅ Include relation
const posts = await prisma.post.findMany({
  include: { author: true }
});
```

**Detection:** Look for database queries inside loops.

### SELECT * Instead of Specific Columns

**Problem:** Fetching unnecessary data.

**Example:**
```python
# ❌ Fetches all columns
def get_user_emails():
    users = db.query("SELECT * FROM users")
    return [user['email'] for user in users]
```

**Fix:**
```python
# ✅ Only fetch needed columns
def get_user_emails():
    users = db.query("SELECT email FROM users")
    return [user['email'] for user in users]
```

**Impact:** Reduced network transfer, faster query, less memory.

### Missing Indexes

**Problem:** Full table scan instead of index lookup.

**Example:**
```python
# ❌ No index on email (assuming frequent lookups)
class User(Base):
    email = Column(String)

def find_by_email(email):
    return db.query(User).filter_by(email=email).first()
    # Full table scan O(n)
```

**Fix:**
```python
# ✅ Add index
class User(Base):
    email = Column(String, index=True)

# Or migration:
# CREATE INDEX idx_users_email ON users(email);

def find_by_email(email):
    return db.query(User).filter_by(email=email).first()
    # Index lookup O(log n)
```

**Detection:** Review queries on large tables without indexes.

### Loading All Records

**Problem:** Loading millions of records into memory.

**Example:**
```python
# ❌ Loads all users into memory
def export_users():
    users = db.query(User).all()  # Could be millions
    for user in users:
        export_user(user)
```

**Fix:**
```python
# ✅ Use pagination or streaming
def export_users():
    page_size = 1000
    offset = 0
    
    while True:
        users = db.query(User).limit(page_size).offset(offset).all()
        if not users:
            break
        
        for user in users:
            export_user(user)
        
        offset += page_size

# Or use yield_per for streaming
def export_users():
    for user in db.query(User).yield_per(1000):
        export_user(user)
```

## Algorithmic Complexity Issues

### Nested Loop When Hash Could Be Used

**Problem:** O(n²) when O(n) is possible.

**Example:**
```python
# ❌ O(n²) - nested loops
def find_common_elements(list1, list2):
    common = []
    for item1 in list1:  # n iterations
        for item2 in list2:  # m iterations
            if item1 == item2:
                common.append(item1)
    return common  # O(n*m)
```

**Fix:**
```python
# ✅ O(n) - use set
def find_common_elements(list1, list2):
    set2 = set(list2)  # O(m)
    common = [item for item in list1 if item in set2]  # O(n)
    return common  # O(n+m)
```

**Performance difference:**
- Lists of 10,000 items each: 100,000,000 vs 20,000 operations
- 5000x faster!

### Repeated Expensive Computation

**Problem:** Calculating same value multiple times.

**Example:**
```python
# ❌ Recalculates tax_rate in every iteration
def calculate_totals(orders: list[Order]):
    for order in orders:
        tax_rate = get_tax_rate_from_api()  # Expensive!
        order.total = order.subtotal * (1 + tax_rate)
```

**Fix:**
```python
# ✅ Calculate once
def calculate_totals(orders: list[Order]):
    tax_rate = get_tax_rate_from_api()  # Once
    for order in orders:
        order.total = order.subtotal * (1 + tax_rate)
```

### Inefficient Search

**Problem:** Linear search when binary search or hash lookup available.

**Example:**
```python
# ❌ O(n) linear search on sorted list
def find_user(users_sorted_by_id, target_id):
    for user in users_sorted_by_id:
        if user.id == target_id:
            return user
    return None
```

**Fix:**
```python
# ✅ O(log n) binary search
from bisect import bisect_left

def find_user(users_sorted_by_id, target_id):
    idx = bisect_left(users_sorted_by_id, target_id, key=lambda u: u.id)
    if idx < len(users_sorted_by_id) and users_sorted_by_id[idx].id == target_id:
        return users_sorted_by_id[idx]
    return None

# Or better: O(1) hash lookup
users_by_id = {user.id: user for user in users}

def find_user(target_id):
    return users_by_id.get(target_id)
```

### String Concatenation in Loop

**Problem:** Creating new string object each iteration.

**Example:**
```python
# ❌ O(n²) - each += creates new string
def build_html(items):
    html = ""
    for item in items:
        html += f"<li>{item}</li>"  # New string each time
    return html
```

**Fix:**
```python
# ✅ O(n) - join list
def build_html(items):
    parts = [f"<li>{item}</li>" for item in items]
    return "".join(parts)

# Or just use join directly
def build_html(items):
    return "".join(f"<li>{item}</li>" for item in items)
```

## Memory Issues

### Loading Entire File

**Problem:** Reading gigabyte file into memory.

**Example:**
```python
# ❌ Loads entire file (could be GB)
def process_log_file(filename):
    content = open(filename).read()
    lines = content.split('\n')
    for line in lines:
        process_line(line)
```

**Fix:**
```python
# ✅ Stream line by line
def process_log_file(filename):
    with open(filename) as f:
        for line in f:  # One line at a time
            process_line(line)
```

### Keeping Large Data Structures

**Problem:** Holding onto objects no longer needed.

**Example:**
```python
# ❌ Keeps all results in memory
def process_large_dataset():
    results = []
    for item in huge_dataset:
        result = expensive_process(item)
        results.append(result)
    
    # Only need final stats, but holding all results
    return sum(results) / len(results)
```

**Fix:**
```python
# ✅ Track only what's needed
def process_large_dataset():
    total = 0
    count = 0
    
    for item in huge_dataset:
        result = expensive_process(item)
        total += result
        count += 1
    
    return total / count if count > 0 else 0
```

### Memory Leak from Circular References

**Problem:** Objects referencing each other not garbage collected.

**Example:**
```python
# ❌ Circular reference
class Node:
    def __init__(self, parent=None):
        self.parent = parent
        self.children = []
        if parent:
            parent.children.append(self)  # Circular reference

# Can cause memory buildup in long-running processes
```

**Fix:**
```python
# ✅ Use weak references
import weakref

class Node:
    def __init__(self, parent=None):
        self.parent = weakref.ref(parent) if parent else None
        self.children = []
        if parent:
            parent.children.append(self)
```

## I/O Performance

### Synchronous I/O in Loop

**Problem:** Waiting for each operation to complete.

**Example:**
```python
# ❌ Sequential API calls (slow)
def fetch_user_data(user_ids):
    results = []
    for user_id in user_ids:
        data = requests.get(f'https://api.example.com/users/{user_id}')
        results.append(data.json())
    return results
    # 10 users = 10 seconds if each takes 1 second
```

**Fix (asyncio):**
```python
# ✅ Concurrent requests
import asyncio
import aiohttp

async def fetch_user_data(user_ids):
    async with aiohttp.ClientSession() as session:
        tasks = [
            fetch_user(session, user_id) 
            for user_id in user_ids
        ]
        return await asyncio.gather(*tasks)
    # 10 users = 1 second (parallel requests)

async def fetch_user(session, user_id):
    async with session.get(f'https://api.example.com/users/{user_id}') as resp:
        return await resp.json()
```

### Excessive File Operations

**Problem:** Opening/closing files repeatedly.

**Example:**
```python
# ❌ Opens file N times
def append_items(filename, items):
    for item in items:
        with open(filename, 'a') as f:
            f.write(f"{item}\n")  # Open/close each iteration
```

**Fix:**
```python
# ✅ Open once
def append_items(filename, items):
    with open(filename, 'a') as f:
        for item in items:
            f.write(f"{item}\n")  # Single open/close
```

## Caching Opportunities

### Repeated Expensive Calculation

**Problem:** Computing same value multiple times.

**Example:**
```python
# ❌ Recalculates every call
def get_tax_rate(state: str) -> float:
    # Expensive: database lookup, external API, etc.
    rate = database.query_tax_rate(state)
    return rate

# Called many times for same state
for order in orders:
    rate = get_tax_rate(order.state)  # Repeated calls
```

**Fix:**
```python
# ✅ Cache results
from functools import lru_cache

@lru_cache(maxsize=128)
def get_tax_rate(state: str) -> float:
    rate = database.query_tax_rate(state)
    return rate

# First call hits database, subsequent calls return cached value
```

### Repeated Database Queries

**Problem:** Querying same data multiple times.

**Example:**
```python
# ❌ Repeated queries
def process_orders(order_ids):
    for order_id in order_ids:
        order = db.get_order(order_id)
        customer = db.get_customer(order.customer_id)  # Same customer queried multiple times
        process(order, customer)
```

**Fix:**
```python
# ✅ Batch load and cache
def process_orders(order_ids):
    orders = db.get_orders(order_ids)  # Batch load orders
    
    customer_ids = {order.customer_id for order in orders}
    customers = db.get_customers(customer_ids)  # Batch load customers
    customers_map = {c.id: c for c in customers}  # Cache
    
    for order in orders:
        customer = customers_map[order.customer_id]  # Lookup from cache
        process(order, customer)
```

## Framework-Specific Issues

### Django ORM

**N+1 with foreign keys:**
```python
# ❌ N+1 queries
posts = Post.objects.all()
for post in posts:
    print(post.author.name)  # Query for each post

# ✅ Use select_related
posts = Post.objects.select_related('author').all()
for post in posts:
    print(post.author.name)  # No extra queries
```

**N+1 with many-to-many:**
```python
# ❌ N+1 queries
posts = Post.objects.all()
for post in posts:
    print(post.tags.all())  # Query for each post

# ✅ Use prefetch_related
posts = Post.objects.prefetch_related('tags').all()
for post in posts:
    print(post.tags.all())  # No extra queries
```

### React/TypeScript

**Unnecessary re-renders:**
```typescript
// ❌ New object every render
function UserList() {
  const users = getUsers();
  return users.map(user => (
    <UserItem key={user.id} style={{color: 'blue'}} />
    // New style object every render
  ));
}

// ✅ Memoize or extract
const userStyle = {color: 'blue'};

function UserList() {
  const users = getUsers();
  return users.map(user => (
    <UserItem key={user.id} style={userStyle} />
  ));
}
```

## Performance Review Checklist

### Database
- [ ] No N+1 queries (queries in loops)
- [ ] Appropriate indexes on frequently queried columns
- [ ] Pagination for large result sets
- [ ] SELECT specific columns, not *
- [ ] Batch operations where possible

### Algorithms
- [ ] No O(n²) where O(n) or O(n log n) possible
- [ ] Use sets/dicts for lookups (O(1)) not lists (O(n))
- [ ] Expensive calculations done once, not in loops
- [ ] Appropriate data structures for operations

### Memory
- [ ] Streaming/pagination for large datasets
- [ ] Not holding entire files in memory
- [ ] Objects released when no longer needed
- [ ] No obvious memory leaks

### I/O
- [ ] Async/concurrent for multiple I/O operations
- [ ] Files opened once, not repeatedly
- [ ] Batch API calls where possible
- [ ] Appropriate caching

### Caching
- [ ] Expensive operations cached
- [ ] Cache invalidation handled
- [ ] Reasonable cache size limits

## When to Optimize

**Optimize if:**
- ✅ Profiling shows actual bottleneck
- ✅ O(n²) or worse algorithmic complexity
- ✅ Obvious N+1 query problem
- ✅ Loading gigabytes into memory
- ✅ Performance SLA at risk

**Don't optimize if:**
- ❌ "Feels" slow without measurement
- ❌ Micro-optimization (nanoseconds)
- ❌ Premature - not yet a problem
- ❌ Obscures code for minimal gain
- ❌ Edge case that rarely happens

## Measuring Performance

**Python:**
```python
import time
from functools import wraps

def timeit(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end - start:.4f} seconds")
        return result
    return wrapper

@timeit
def slow_function():
    # ...
```

**Use profiler:**
```python
import cProfile
import pstats

profiler = cProfile.Profile()
profiler.enable()

# Code to profile
expensive_operation()

profiler.disable()
stats = pstats.Stats(profiler)
stats.sort_stats('cumulative')
stats.print_stats(10)  # Top 10 functions
```

**TypeScript:**
```typescript
console.time('operation');
expensiveOperation();
console.timeEnd('operation');
```

## Key Principles (Repeated for Emphasis)

1. **Profile before optimizing** - Measure, don't guess
2. **Fix algorithmic issues first** - O(n²) → O(n) matters most
3. **Obvious inefficiencies only** - Don't micro-optimize
4. **Balance with maintainability** - Clear code > fast code in most cases
5. **Test after optimization** - Ensure correctness preserved

Remember: Premature optimization is the root of all evil, but obvious inefficiencies should be caught in review!
