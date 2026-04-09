---
name: v3-execution
description: "V3.1 Phase P3 — Execution Run. Use when state.json shows phase P3. Builder implements spec chunk by chunk, producing code, tests, docs, and handoff. Each chunk follows implement → test → verify → commit cycle."
---

# P3 — Execution Run

## Objective
Builder implements the spec chunk by chunk, producing handoff artifacts.

## Process Steps

```
Step 1: Load context
  - Read TASK_CONTRACT, SPEC, SPRINT_PLAN
  - Identify current chunk from sprint plan

Step 2: Implement (smallest complete slice)
  - One complete path through the stack
  - Run tests every ~100 lines of change
  - DO NOT touch code outside scope

Step 3: Test
  - Write tests WITH implementation (not "later")
  - Run full test suite
  - Verify build succeeds

Step 4: Verify
  - Confirm slice works independently
  - Confirm existing functionality not broken
  - UI → screenshot to evidence/screenshots/
  - API → request/response to evidence/logs/

Step 5: Commit
  - Descriptive message (not "fix" / "update" / "wip")
  - Code + docs in same commit

Step 6: Repeat Steps 2-5 for remaining slices in chunk

Step 7: Produce HANDOFF.md
  - What was done
  - What remains
  - Evidence produced (with links)
  - Auto-triggered skills (if any)
  - Suggested next step
```

## Builder Rules
✅ Must: work per contract, process only current chunk, make recoverable commits, update docs, produce handoff
❌ Must NOT: expand scope, self-approve, merge chunks without justification, change code without updating docs

## Content-Triggered Skills
| Trigger | Additional check |
|---------|-----------------|
| Modifying API routes | → security checklist |
| Modifying UI components | → accessibility checklist |
| Modifying DB schema | → performance checklist + rollback |
| Adding dependency | → dependency review |
| Modifying auth logic | → security audit (mandatory) |
| Deleting >50 lines | → deprecation impact check |

Record triggers in HANDOFF.md: `## Auto-triggered skills`

## Verification Gate
- [ ] Each chunk has corresponding tests
- [ ] Test suite green (output in evidence/logs/)
- [ ] Build succeeds
- [ ] HANDOFF.md complete
- [ ] No uncommitted changes

## Anti-Rationalization
| Excuse | Rebuttal |
|--------|----------|
| "I'll add tests later" | Later = never. Tests ship with implementation |
| "Too simple to test" | "Too simple" is regression bug source #1 |
| "Handoff unnecessary, code is docs" | Code = what. Handoff = why + what remains |
| "Merged chunks for efficiency" | Canceled intermediate verification points |
| "Need to slightly expand scope" | Update contract first, then expand |
| "Docs can wait until feature complete" | Async docs = permanently stale docs |

## Red Flags
- ⚠️ >500 lines changed, no tests
- ⚠️ "What remains" empty but task incomplete
- ⚠️ Two handoffs nearly identical (no progress)
- ⚠️ Commit messages: "fix" / "update" / "wip"
- ⚠️ Builder says "already verified" (swallowed evaluator role)

## Gate Pass → Transition
All checks pass → update state.json to `P4` → load `v3-evaluation`
