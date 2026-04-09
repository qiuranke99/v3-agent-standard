---
name: v3-bootstrap
description: "V3.1 Phase P0 — Repo Bootstrap. Use when initializing a new project or when state.json shows phase P0. Creates directory structure, templates, CI baseline, and initializes state.json."
---

# P0 — Repo Bootstrap

## Objective
Build the minimum viable Context Infrastructure + Assurance baseline.

## Process Steps

```
Step 1: Create directory structure
  docs/{specs, contracts, acceptance, rubrics, runbooks, changelogs}
  tasks/{active, done, rejected}
  evidence/{screenshots, logs, traces, reports}
  scripts/ · src/ · .ci/

Step 2: Create AGENTS.md (navigation map)
Step 3: Create README.md (project overview)
Step 4: Create ARCHITECTURE.md (system design)
Step 5: Create DECISIONS.md (ADR log)
Step 6: Create GLOSSARY.md (terms)
Step 7: Set up minimal CI (lint + type check + test runner)
Step 8: Create WORKFLOW.md (state machine config)
Step 9: Install templates: TASK_CONTRACT, HANDOFF, PROOF_OF_WORK, SPEC, SPRINT_PLAN
Step 10: Initialize runtime/state.json → { current_phase: "P0" }
Step 11: git init && git add -A && git commit -m "P0: repo bootstrap"
```

## Verification Gate

- [ ] `tree -L 2` matches standard V3.1 structure
- [ ] AGENTS.md exists with correct navigation links
- [ ] Basic CI/lint/formatter can run without errors
- [ ] All templates exist
- [ ] runtime/state.json exists with `current_phase: "P0"`

## Anti-Rationalization

| Excuse | Rebuttal |
|--------|----------|
| "Start coding first, structure later" | Code without L1 = no context recovery across sessions |
| "AGENTS.md is overkill for small projects" | Small projects grow. 5-min setup saves hours of drift |
| "CI can wait until real code exists" | CI validates the harness. Set up the runner even with empty tests |

## Gate Pass → Transition

All checks pass → update state.json to `P1` → load `v3-contract`
