---
name: v3-orchestrator
description: "V3.1 Project OS entry point. Use at the start of every session, when the user says /v3, or when resuming work on any V3.1 project. Reads state.json to identify current phase, loads the correct phase skill, enforces session hooks and escalation policy."
---

# V3.1 Orchestrator

You are operating inside the V3.1 Project Operating System.
V3.1 is not a suggestion — it is your runtime. You do not "try to follow" it. You execute within it.

## Session Start — MANDATORY

```
1. Read AGENTS.md
2. Read README.md + ARCHITECTURE.md
3. Read runtime/state.json → identify current phase
4. Read tasks/active/ → identify active task
5. Read latest HANDOFF.md (if any)
6. Load the skill for current phase (see Phase Router below)
7. Output: "V3.1 OS | Phase: [Pn] | Task: [ID] | Ready"
```

## Phase Router

Read `runtime/state.json` → `current_phase` → load corresponding skill:

| `current_phase` | Load skill | Condition |
|-----------------|------------|-----------|
| `null` or missing | `v3-bootstrap` | No state.json exists |
| `P0` | `v3-bootstrap` | Setting up project |
| `P1` | `v3-contract` | Defining task contract |
| `P2` | `v3-planning` | Writing spec + sprint plan |
| `P3` | `v3-execution` | Building |
| `P4` | `v3-evaluation` | Independent evaluation |
| `P5` | `v3-merge-gate` | Merge decision |
| `P6` | `v3-janitor` | Post-merge cleanup |

## Phase Transition Protocol

Before moving to next phase:
1. Run `./runtime/gate.sh` (or manually verify the gate checklist in the phase skill)
2. If gate PASSES → update `state.json` → load next phase skill → continue
3. If gate FAILS → stay in current phase → fix issues → re-check gate
4. If gate fails `max_retries` times → ESCALATE

## Autonomous Execution Contract

**Default: keep pushing forward.** Do NOT stop to ask for confirmation at plan, ticket, chunk, issue, handoff, PoW, or phase transitions.

**Escalate to human ONLY when:**
1. Requirements or scope conflict that cannot be resolved from the contract
2. Acceptance / release decision requiring human judgment
3. Spec fundamentally conflicts with architecture
4. High-risk override, irreversible operation, or boundary-exceeding tradeoff
5. Evaluator fails repeatedly and root cause is not in implementation layer

## Role Separation — ENFORCED

| Role | Does | Does NOT |
|------|------|----------|
| **Planner** | Expand spec, split sprints, flag risks | Write implementation code |
| **Builder** | Implement per contract, update docs, produce handoff | Self-approve, expand scope |
| **Evaluator** | Independent verification with hard thresholds | Repeat builder's self-report |
| **Janitor** | Clean dead code, fix AI slop, promote rules | Add new features |

## Session End — MANDATORY

```
1. Produce or update HANDOFF.md
2. Update task status in tasks/active/
3. Update state.json if phase changed
4. Commit all changes
5. Output: "V3.1 OS | Session end | Done: [items] | Remaining: [items] | Next: [suggestion]"
```

## Core Principles (always active)

1. **Repo is the single source of truth** — if you can't see it in the repo, it doesn't exist
2. **Constraints over reminders** — this skill system IS the constraint, not a reminder
3. **Completion is defined by evidence** — tests, PoW, evaluator verdicts, not self-reported status
4. **Agent will self-rationalize** — check yourself against anti-rationalization tables in each phase skill
5. **Concurrency is not the default** — start with 1 planner + 1 builder + 1 evaluator
