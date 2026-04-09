---
name: v3-contract
description: "V3.1 Phase P1 — Task Contract. Use when state.json shows phase P1 or when a new requirement needs to be formalized. Compresses requirements into an executable, measurable task contract."
---

# P1 — Task Contract

## Objective
Compress the requirement into a single executable, measurable task contract.

## Process Steps

```
Step 1: Understand the requirement
  - Read user input / requirement description
  - Read relevant ARCHITECTURE.md sections
  - Identify affected modules

Step 2: Compress into Goal
  - One sentence, one verb
  - If multiple verbs → split into multiple tasks

Step 3: Define Scope and Non-Goals
  - Scope: what IS included
  - Non-Goals: what is EXPLICITLY excluded
  - Verify: is the boundary unambiguous?

Step 4: Write Acceptance Criteria
  - Checklist items for each deliverable
  - ALL items must use hard criteria
  - FORBIDDEN words: "reasonable", "appropriate", "try to", "if possible"
  - Each item must be independently verifiable

Step 5: Mark Risks and Rollback
  - Top 2-3 risks
  - Rollback condition for each

Step 6: Self-review
  - Re-read contract against Anti-Rationalization table below
  - Run gate checklist
```

## Output: `tasks/active/TASK-NNN.md`

```md
# Task Contract
## Ticket ID: TASK-NNN
## Goal: [one sentence, one verb]
## Scope: [included work]
## Non-Goals: [excluded work]
## Risks: [top risks]
## Dependencies: [modules, services, conditions]
## Acceptance:
- [ ] [hard criterion]
## Required Proof:
- [ ] [evidence type]
## Rollback Condition: [when to revert]
## Status: todo
```

## Verification Gate

- [ ] Goal contains exactly ONE verb
- [ ] Scope and Non-Goals have clear boundary
- [ ] Acceptance has ZERO fuzzy words
- [ ] Rollback Condition is defined
- [ ] File saved to tasks/active/

## Anti-Rationalization

| Excuse | Rebuttal |
|--------|----------|
| "Requirement is obvious, no need for contract" | "Obvious" requirements drift most. Contract prevents implicit scope expansion |
| "Non-Goals unnecessary" | No Non-Goals = no boundary. Agent defaults to "if I can, I will" |
| "Natural language acceptance is fine" | Natural language = no standard. Must be checklist or threshold |
| "Task too small for a contract" | Small tasks without contracts are scope creep source #1. Min contract = 5 lines |

## Red Flags
- ⚠️ Goal has 2+ verbs (multiple tasks disguised as one)
- ⚠️ No clear Scope/Non-Goals boundary
- ⚠️ Acceptance contains "reasonable" / "appropriate" / "try to"
- ⚠️ No Rollback Condition

## Gate Pass → Transition
All checks pass → update state.json to `P2` → load `v3-planning`
