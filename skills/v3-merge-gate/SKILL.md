---
name: v3-merge-gate
description: "V3.1 Phase P5 — Merge / Release Gate. Use when state.json shows phase P5. Produces Proof of Work, runs final assurance checks, and makes merge/release decision."
---

# P5 — Merge / Release Gate

## Objective
Produce Proof of Work, run final assurance checks, decide merge/release.

## Process Steps

```
Step 1: Run full assurance suite
  - Lint → save output
  - Type check → save output
  - Full test suite → save output
  - Build → save output
  - Security check (if auth/API involved)

Step 2: Compile Proof of Work
  - Fill PROOF_OF_WORK.md template
  - Link all evidence from evidence/

Step 3: Review acceptance checklist
  - Go through every item in TASK_CONTRACT.md acceptance
  - Check each one against evidence
  - Any unchecked item = FAIL

Step 4: Make merge recommendation
  ✅ MERGE: all checks green, acceptance complete, no caveats
  ⚠️ MERGE WITH CAVEATS: all checks green, minor caveats documented
  ❌ DO NOT MERGE: checks fail or acceptance incomplete → back to P3
```

## Output: `evidence/reports/POW-NNN.md`

```md
# Proof of Work — TASK-NNN

## Build status: ✅ pass / ❌ fail
## Type check: ✅ pass / ❌ fail
## Lint: ✅ pass / ❌ fail
## Test status: ✅ pass / ❌ fail (link to output)
## Security review: ✅ pass / ❌ fail / ⏭️ n/a

## Acceptance checklist
- [x] [criterion from contract]
- [x] [criterion from contract]

## Demo evidence
- [link to screenshots]
- [link to API responses]

## Known limitations
- [what doesn't work yet]

## Merge recommendation
✅ MERGE / ⚠️ MERGE WITH CAVEATS / ❌ DO NOT MERGE
```

## Verification Gate
- [ ] Lint green
- [ ] Type check green
- [ ] Tests green
- [ ] Build green
- [ ] Acceptance checklist 100% checked
- [ ] PoW document complete with evidence links
- [ ] Merge recommendation stated

## Gate Pass → Transition
MERGE → update state.json to `P6` → load `v3-janitor`
DO NOT MERGE → back to `P3`, increment retry
