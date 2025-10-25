# Unit, Integration, and Regression Test Code Schema

## Note About this File.

This feels a little awkward as a schema in the ontology.
Maybe this will move later.

## Test Code Files

| Artifact | Location | Purpose | Created By |
|----------|----------|---------|------------|
| Unit tests | `tests/unit/test_<feature>.py` | Isolated component tests | Test Writer |
| Integration tests | `tests/integration/test_<feature>_integration.py` | Component interaction tests | Test Writer |

**Naming:** One coherent test file per feature preferred

**Attribution:** When multiple contributors edit same file, use inline comments:
```python
# === Tests by Claude Sonnet 4.5 (2025-10-23) ===
def test_feature_happy_path(): ...

# === Tests by Human Developer (2025-10-24) ===
def test_feature_edge_case(): ...
```

**Critical:** Test Reviewer reviews **entire suite** as single unit (all-in review)
