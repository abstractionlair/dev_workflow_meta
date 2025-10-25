### Review Files Schema

All reviews use timestamped filenames with status.

| Review Type | Directory | Creator Role | Gates |
|-------------|-----------|--------------|-------|
| Planning reviews | `reviews/planning/` | Vision/Scope/Roadmap Reviewers | Quality check |
| Spec reviews | `reviews/specs/` | Spec Reviewer | `proposed/` → `todo/` |
| Skeleton reviews | `reviews/skeletons/` | Skeleton Reviewer | Approves for test writing |
| Test reviews | `reviews/tests/` | Test Reviewer | RED → GREEN transition |
| Implementation reviews | `reviews/implementations/` | Implementation Reviewer | `doing/` → `done/` |
| Bug fix reviews | `reviews/bug-fixes/` | Implementation Reviewer | `fixing/` → `fixed/` |

**Naming pattern:** `YYYY-MM-DDTHH-MM-SS-<feature>-<STATUS>.md`

**Status values:**
- `APPROVED` - Ready to proceed to next stage
- `NEEDS-CHANGES` - Requires revision before proceeding

**Examples:**
- `2025-10-23T14-30-47-user-registration-APPROVED.md`
- `2025-10-23T15-22-13-payment-gateway-NEEDS-CHANGES.md`

**Use seconds precision** to avoid filename collisions.
