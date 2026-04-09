---
name: v3-planning
description: "V3.1 Phase P2 — Planning / Spec. Use when state.json shows phase P2. Planner expands the task contract into a spec with chunk breakdown, risk analysis, and evaluator verification plan. No implementation code."
---

# P2 — Planning / Spec

## Objective
Planner expands the contract into a deliverable spec. NO implementation code in this phase.

## Process Steps

```
Step 1: Read the Task Contract (tasks/active/TASK-NNN.md)
Step 2: Expand into SPEC.md
  - Technical approach
  - Concrete deliverables list
  - Integration points and interfaces
Step 3: Break into chunks (SPRINT_PLAN.md)
  - Each chunk independently deliverable
  - Each chunk has own acceptance criteria
  - Each chunk has clear input → output
  - Target: 2-5 chunks
Step 4: Define evaluator verification per chunk
Step 5: Risk analysis (likelihood × impact + mitigation)
Step 6: Self-review against Anti-Rationalization table
```

## Outputs
- `docs/specs/SPEC-NNN.md`
- `docs/specs/SPRINT_PLAN-NNN.md`

## Planner Rules
✅ Does: expand scope, clarify deliverables, identify risks, design chunks, specify evaluator verification
❌ Does NOT: write implementation code (>10 lines = violation), make low-level tech decisions for builder

## Verification Gate
- [ ] SPEC.md has explicit deliverables list
- [ ] Sprint Plan has ≥2 chunks
- [ ] Each chunk has acceptance criteria
- [ ] Each chunk has evaluator verification method
- [ ] Risk list is non-empty

## Anti-Rationalization
| Excuse | Rebuttal |
|--------|----------|
| "Simple enough, skip spec" | If simple, spec takes 10 min. Skipping = transferring planning cost to execution |
| "One big chunk is more efficient" | No intermediate verification point. On failure, can't locate rollback |
| "Risk assessment is overkill" | "See how it goes" = no rollback strategy |
| "Planner needs to write code to validate" | Role contamination. Pseudocode for interfaces OK, implementation code NOT OK |

## Red Flags
- ⚠️ Spec contains >10 lines of implementation code
- ⚠️ Sprint plan has only 1 chunk
- ⚠️ No evaluator verification described
- ⚠️ Risk list empty

## Gate Pass → Transition
All checks pass → update state.json to `P3` → load `v3-execution`
