---
name: v3-janitor
description: "V3.1 Phase P6 — Janitor / Gardener. Use when state.json shows phase P6. Post-merge cleanup: remove dead code, fix AI slop, update docs, promote patterns to rules, archive completed tasks."
---

# P6 — Janitor / Gardener

## Objective
Suppress entropy. Prevent AI slop accumulation. Keep the repo healthy.

## Process Steps

```
Step 1: Dead code scan
  - Identify unused imports, functions, variables
  - Identify unreachable code paths
  - List findings before deleting → confirm

Step 2: AI slop cleanup
  - Remove over-abstraction (factories with 1 implementation, bases with 1 child)
  - Remove commented-out code
  - Remove placeholder/TODO comments that will never be addressed
  - Simplify unnecessarily complex logic

Step 3: Documentation sync
  - Verify ARCHITECTURE.md matches current code
  - Verify GLOSSARY.md terms are current
  - Verify README.md instructions still work
  - Archive completed task: move from tasks/active/ → tasks/done/

Step 4: Pattern promotion
  - If a pattern emerged during execution that should be a rule → add to AGENTS.md
  - If a new anti-rationalization was discovered → add to relevant phase skill
  - If a checklist item was missing → add to relevant checklist

Step 5: Verify cleanup doesn't break anything
  - Run full test suite
  - Run build
  - If anything breaks → revert cleanup, investigate

Step 6: Update state.json
  - Mark task as complete
  - Evaluate P7 eligibility (see below)
```

## Janitor Rules
✅ Does: clean dead code, fix slop, promote patterns, update docs, archive tasks
❌ Does NOT: add new features, expand scope, refactor working code "for fun"

## Verification Gate
- [ ] Dead code removed (list documented)
- [ ] No commented-out code remains
- [ ] Docs are in sync with code
- [ ] Task moved to tasks/done/
- [ ] Tests still green after cleanup
- [ ] No new functionality added

## P7 Concurrency Evaluation

Check ALL conditions:
- [ ] Module boundaries are clear per ARCHITECTURE.md
- [ ] At least 1 complete P1→P6 cycle has been done successfully
- [ ] Handoff template has been validated as reusable
- [ ] Assurance can cover concurrent changes

If ALL true → eligible for P7 (concurrent expansion)
If ANY false → skip P7 → CLOSE task

## Gate Pass → Transition
Cleanup complete + P7 not needed → CLOSE (update state.json: phase = null, task = null)
Cleanup complete + P7 eligible → update state.json to `P1` for next task
