---
name: v3-evaluation
description: "V3.1 Phase P4 — Independent Evaluation. Use when state.json shows phase P4. Evaluator independently verifies builder's work. Does NOT trust builder's self-report. Runs tests independently, reviews code across five axes, produces structured verdict."
---

# P4 — Independent Evaluation

## Objective
Evaluator independently verifies results. Does NOT trust builder's handoff narrative.

## Process Steps

```
Step 1: Build independent expectation FIRST
  - Read TASK_CONTRACT.md (what was promised)
  - Read SPEC.md (how it should work)
  - Form your own expectation of what "done" looks like
  - THEN read HANDOFF.md (compare against your expectation)

Step 2: Review tests first
  - Do tests exist for the change?
  - Do they test behavior (not implementation details)?
  - Are edge cases covered?
  - Would these tests catch a regression?

Step 3: Run independently
  - Run test suite yourself (save output → evidence/logs/)
  - Run build yourself (save output)
  - UI changes → operate the UI yourself, screenshot → evidence/screenshots/
  - API changes → call endpoints yourself, save responses

Step 4: Five-axis code review
  Correctness: does code match spec? Edge cases handled?
  Readability: understandable without author explanation?
  Architecture: follows existing patterns? If new, justified?
  Security: input validated? Secrets safe? Queries parameterized?
  Performance: N+1? Unbounded loops? Missing pagination?

Step 5: Categorize findings
  Critical: blocks merge (security vuln, data loss, broken functionality)
  Important: should fix before merge (missing test, wrong abstraction)
  Suggestion: optional improvement (naming, style)
  FYI: informational only

Step 6: Produce verdict
  PASS → proceed to P5
  PASS WITH CAVEATS → proceed to P5, caveats recorded in PoW
  FAIL → return to P3 with specific rework instructions, increment retry_count
```

## Evaluator Rules
✅ Must: verify against contract, try real execution, use hard thresholds, give structured failure reasons
❌ Must NOT: repeat builder's self-report, use vague language, pass without evidence, skip running tests

## Evaluator Personas (activate based on content)

**Code Reviewer** (default at P4): five-axis review
**Test Engineer** (when test quality is questionable): coverage + test quality deep-dive
**Security Auditor** (when auth/API/secrets involved): security-focused review

## Verification Gate
- [ ] Evaluator ran tests independently (output saved)
- [ ] Five-axis review has specific findings per axis
- [ ] Verdict is one of: PASS / PASS WITH CAVEATS / FAIL
- [ ] If FAIL: specific rework instructions provided
- [ ] Evaluator did NOT copy builder's handoff language

## Anti-Rationalization
| Excuse | Rebuttal |
|--------|----------|
| "Builder already ran tests" | Evaluator's value IS independent verification. Copying = evaluator doesn't exist |
| "Core works, edge cases don't matter" | Edge cases are production incident source #1 |
| "Code looks good, pass" | "Looks good" is not evidence. Must have runnable verification |
| "Only one small issue, not worth failing" | All deviations from acceptance must be recorded. Pass with caveat, but caveat goes into PoW |

## Red Flags
- ⚠️ Verdict has no supporting evidence
- ⚠️ Evaluator uses builder's exact phrasing (copied, not independently verified)
- ⚠️ All acceptance items pass (low probability, likely rubber stamp)
- ⚠️ No test output saved to evidence/

## On FAIL
- Increment `retry_count` in state.json
- If `retry_count >= max_retries` → ESCALATE to human
- Otherwise → transition back to P3 with rework instructions

## Gate Pass → Transition
PASS or PASS WITH CAVEATS → update state.json to `P5` → load `v3-merge-gate`
