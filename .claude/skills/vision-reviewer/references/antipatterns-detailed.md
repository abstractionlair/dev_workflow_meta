# Vision Anti-Patterns - Detailed Reference

This file provides extended coverage of vision anti-patterns for reviewers.

For the complete anti-pattern catalog with examples and recovery patterns, see the vision-writer skill's antipatterns reference. This document focuses on detection during review.

## Quick Detection Guide

### Feature List Syndrome
**Detection signals:**
- Vision contains bullet lists of capabilities
- Words like "features," "includes," "provides," "supports"
- Can remove feature names and value disappears
- Reads like product spec, not strategic direction

**Severity:** P0 - Blocks effective planning

### Mission Confusion
**Detection signals:**
- Vision is 2+ paragraphs of broad aspirations
- Timeless language (no 2-5 year horizon)
- Could apply to entire company, not specific product
- No specific users or measurable outcomes

**Severity:** P0 - Provides no strategic direction

### Solution Lock-In
**Detection signals:**
- Vision specifies technology/platform
- "Build mobile app" vs. "enable access anywhere"
- "Blockchain-based" or "AI-powered" in vision statement
- Technology choice constrains strategic flexibility

**Severity:** P1 - Prevents beneficial pivots

### Vague Aspirations
**Detection signals:**
- Buzzwords without concrete meaning
- "Revolutionize," "transform," "empower," "innovate"
- Could apply to any competitor
- No measurable success criteria

**Severity:** P0 - Provides no decision guidance

### Competitor Obsession
**Detection signals:**
- Vision defined as "better than X"
- "The Uber of Y" or "#1 in market"
- More focus on beating competitors than serving customers
- No unique value articulated

**Severity:** P1 - Reactive strategy, not proactive value creation

### Scope Creep Spiral
**Detection signals:**
- Vision keeps expanding without boundaries
- "And also..." pattern throughout document
- No "never in scope" section
- Everything marked "in scope" with no priorities

**Severity:** P1 - Prevents focus and execution

### Premature Abandonment Setup
**Detection signals:**
- 6-12 month timeline for complex vision
- No acknowledgment of pivots or hard problems
- Unrealistic expectations for speed of validation
- No long-term commitment indicated

**Severity:** P1 - Sets up likely abandonment

### Metric Mirage
**Detection signals:**
- Vanity metrics (downloads, press mentions)
- No measurement of value delivered
- Metrics easily gamed
- No counter-metrics as guardrails

**Severity:** P0 - Can't track actual progress

### Technical Architecture as Vision
**Detection signals:**
- Vision describes implementation not outcomes
- "Microservices architecture" or "ML platform"
- Only meaningful to engineers
- No explanation of customer benefit

**Severity:** P1 - Misses the "why"

### Solo Developer Sustainability Trap
**Detection signals:**
- Multiple platforms (web + iOS + Android)
- 24/7 support requirements
- Enterprise features requiring team
- Timeline/scope impossible for stated resources

**Severity:** P0 - Guaranteed burnout or failure

## Detection Workflow

When reviewing a vision document:

1. **Quick scan for obvious patterns** (5 min)
   - Read vision statement - feature list or vague?
   - Check scope section - realistic or sprawling?
   - Look for buzzwords vs. concrete language
   - Note any immediate red flags

2. **Systematic pattern check** (10 min)
   - Go through each anti-pattern
   - Mark any detected with evidence
   - Note severity (P0/P1/P2)

3. **Impact assessment** (5 min)
   - How do detected patterns affect effectiveness?
   - Which are blocking vs. reducing effectiveness?
   - What's the priority order for fixes?

4. **Provide fixes** (included in review output)
   - For each detected pattern, show concrete fix
   - Provide before/after examples
   - Explain why fix addresses issue

## Severity Guidelines

**P0 - Blocks Planning:**
- Feature list syndrome
- Mission confusion  
- Vague aspirations
- Metric mirage
- Solo sustainability trap (when detected)

**P1 - Reduces Effectiveness:**
- Solution lock-in
- Competitor obsession
- Scope creep spiral
- Premature abandonment setup
- Technical architecture as vision

**P2 - Polish Issues:**
- Minor vagueness in specific sections
- Missing examples or details
- Format/structure improvements

## Common Combinations

Some anti-patterns often appear together:

**"Buzzword Vision" combo:**
- Vague aspirations
- Mission confusion
- Competitor obsession
- Example: "Revolutionize industry by disrupting traditional approaches to become market leader"

**"Overambitious Solo Developer" combo:**
- Solo sustainability trap
- Scope creep spiral
- Feature list syndrome
- Example: Solo dev planning web + iOS + Android + AI + blockchain in 6 months

**"Tech-Focused" combo:**
- Solution lock-in
- Technical architecture as vision
- Feature list syndrome
- Example: Vision describes microservices and ML pipeline instead of customer outcomes

## For Complete Anti-Pattern Coverage

See the vision-writer skill's antipatterns reference for:
- Extended examples of each pattern
- Real-world case studies
- Recovery patterns and fixes
- Prevention through good habits

This review-focused guide provides quick detection; the writer's guide provides comprehensive understanding.
