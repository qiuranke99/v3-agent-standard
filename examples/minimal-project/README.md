# Minimal V3.1 Project Example

This is a barebones project skeleton that follows the V3.1 Layered Agent Engineering Standard.

It demonstrates:
- Required directory structure
- Where each document type lives
- How templates connect to each other

## Directory Map

```
minimal-project/
├── AGENTS.md              → Agent behavior rules (L1)
├── WORKFLOW.md            → State machine & run config (L4)
├── README.md              → This file
├── ARCHITECTURE.md        → System design (L1)
├── DECISIONS.md           → ADRs (L1)
├── GLOSSARY.md            → Term definitions (L1)
├── docs/
│   ├── specs/             → Planner output (P2)
│   ├── contracts/         → Task contracts (P1)
│   ├── acceptance/        → Acceptance criteria
│   ├── rubrics/           → Evaluation rubrics
│   ├── runbooks/          → Operational procedures
│   └── changelogs/        → Release history
├── tasks/
│   ├── active/            → Current tickets
│   ├── done/              → Completed & archived
│   └── rejected/          → Rejected tasks
├── evidence/
│   ├── screenshots/       → Visual proof
│   ├── logs/              → Build/test logs
│   ├── traces/            → Observability data
│   └── reports/           → PoW reports (P5)
├── scripts/               → Automation (P0)
├── .ci/                   → CI configuration (L5)
└── src/                   → Source code (P3)
```

## How to Use

1. Copy this directory as your project starting point
2. Fill in `ARCHITECTURE.md` and `GLOSSARY.md`
3. Create your first task contract in `tasks/active/`
4. Start building
