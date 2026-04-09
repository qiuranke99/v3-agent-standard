# V3.1 — Layered Agent Engineering Standard

**The operating system for AI-driven software development.**

V3.1 is not a template. Not a skill. Not a prompt.  
V3.1 is a **Project Operating System** — complete with protocol, runtime, skills, state machine, and evidence system — that makes AI agents build production-grade software instead of demo-grade prototypes.

---

## Why V3.1?

| Approach | What happens | Result |
|----------|-------------|--------|
| Vibe coding | "Build me a thing" → agent dumps code | Works for demos. Breaks in production. |
| Chat-driven development | Human micro-manages every step | Doesn't scale. Human becomes bottleneck. |
| Prompt engineering | Better prompts → slightly better code | Lipstick on a pig. No structural guarantees. |
| Semi-automated TDD | Agent writes tests → writes code | Better, but no planning, no evaluation, no gates. |
| **V3.1** | **Agent operates INSIDE a structured runtime** | **Planning → Building → Independent Evaluation → Evidence-gated Merge** |

The difference: V3.1 agents don't "try to follow rules."  
They **run inside the rules.** The runtime enforces the state machine. Gates block transitions without evidence. Roles are separated structurally, not by suggestion.

---

## Five-Layer Architecture

```
┌─────────────────────────────────────────────────┐
│  L1  V3.1 STANDARD (Protocol / Constitution)   │  ← Rules
├─────────────────────────────────────────────────┤
│  L2  PROJECT TEMPLATE (Repo Skeleton)           │  ← Structure
├─────────────────────────────────────────────────┤
│  L3  ORCHESTRATOR (Runtime Kernel)              │  ← Control
├─────────────────────────────────────────────────┤
│  L4  PHASE SKILLS (Execution Modules)           │  ← Capability
├─────────────────────────────────────────────────┤
│  L5  RUNTIME STATE (Project Instance)           │  ← Data
└─────────────────────────────────────────────────┘
```

### L1 — Standard (Constitution)

The specification. Defines the five-layer system architecture, P0→P7 state machine, role boundaries (Planner / Builder / Evaluator / Janitor), Proof of Work requirements, escalation policy, and concurrency conditions.

**File:** `STANDARD.md`

### L2 — Project Template (Skeleton)

Turns the standard into physical repo structure. Directory layout, document templates (AGENTS.md, TASK_CONTRACT, HANDOFF, PROOF_OF_WORK, SPEC, SPRINT_PLAN), and checklist references.

**Directory:** `templates/`

### L3 — Orchestrator (Kernel)

The most critical layer. Reads project state, determines current phase, loads the right skills, enforces session hooks, manages phase transitions, handles escalation decisions, and controls concurrency policy.

**File:** `skills/v3-orchestrator/SKILL.md`

### L4 — Phase Skills (Execution Modules)

Capability modules dispatched by the orchestrator. Each phase has its own skill with: process steps, verification gates, anti-rationalization tables, red flags, and transition conditions. Skills don't know about each other — the orchestrator manages sequencing.

**Directory:** `skills/`

| Skill | Phase | Core Function |
|-------|-------|---------------|
| `v3-bootstrap` | P0 | Repo initialization + CI baseline |
| `v3-contract` | P1 | Requirement → executable task contract |
| `v3-planning` | P2 | Contract → spec + sprint plan |
| `v3-execution` | P3 | Spec → code + tests + handoff |
| `v3-evaluation` | P4 | Independent verification (five-axis review) |
| `v3-merge-gate` | P5 | Proof of Work + merge decision |
| `v3-janitor` | P6 | Dead code cleanup + pattern promotion |

### L5 — Runtime State (Instance Data)

Project-specific state stored in the repo (not in chat context). Tracks current phase, active task, retry count, gate results, and phase history.

**File:** `runtime/state.json`

---

## State Machine

```
P0 Bootstrap ──gate──→ P1 Contract ──gate──→ P2 Planning ──gate──→ P3 Execution
                                                                        │
                                                                   ──gate──→ P4 Evaluation
                                                                        │
                                                              pass ←────┤────→ fail (→ P3, retry++)
                                                                        │
                                                                        ↓ retry > max
                                                                    ESCALATE → Human
                                                                        │
                                                                   P5 Merge Gate ──gate──→ P6 Janitor ──→ Close / P1
```

**Gates are structural constraints, not suggestions.** A gate check runs verification scripts. If it fails, the transition is blocked. The agent must fix the issues and re-check.

---

## Quick Start

### Install

```bash
git clone https://github.com/qiuranke99/v3-agent-standard.git ~/.v3
```

### Initialize a new project

```bash
~/.v3/runtime/v3.sh init my-project
cd my-project
```

This creates:
- Standard directory structure
- Document templates
- `runtime/state.json` (starts at P0)
- Checklists in `docs/rubrics/`

### Check status

```bash
~/.v3/runtime/v3.sh status
```

### Run gate check

```bash
~/.v3/runtime/v3.sh gate      # Check if current phase gates pass
~/.v3/runtime/v3.sh next      # Transition to next phase (requires gate pass)
```

### Capture evidence

```bash
~/.v3/runtime/v3.sh evidence test   # Run tests, save output to evidence/
~/.v3/runtime/v3.sh evidence lint   # Run linter, save output
~/.v3/runtime/v3.sh evidence build  # Run build, save output
```

---

## Using with AI Agents

### With OpenAI Codex

Install skills globally:
```bash
cp -r ~/.v3/skills/* ~/.codex/skills/
```

Or per-project (done automatically by `v3.sh init`):
```bash
cp -r ~/.v3/skills/* .agents/skills/
```

### With Claude Code / Anthropic

Place skills in `.claude/skills/` or reference in `CLAUDE.md`.

### With Antigravity / Gemini

Reference in `.agents/workflows/v3.md` or knowledge items.

### With any agent

The orchestrator skill (`v3-orchestrator/SKILL.md`) is agent-agnostic. Any agent that reads markdown files can operate within V3.1.

---

## Relationship to agent-skills

[agent-skills](https://github.com/addyosmani/agent-skills) by Addy Osmani provides **task-level execution skills** (how to do incremental implementation, how to do code review, etc.).

V3.1 provides **project-level orchestration** (when to plan, when to build, when to evaluate, what evidence is required).

They are complementary:

```
V3.1 OS (orchestration layer)
  └── P3 Execution
        └── agent-skills: incremental-implementation
        └── agent-skills: test-driven-development
  └── P4 Evaluation
        └── agent-skills: code-review-and-quality
  └── P5 Merge Gate
        └── agent-skills: security-and-hardening
```

V3.1 is the **operating system**. agent-skills are **apps** that run inside it.

---

## Anti-Rationalization

V3.1 includes built-in anti-rationalization tables in every phase skill. These counter the systematic pattern of AI agents self-rationalizing to skip steps.

Every phase has:
- **Anti-Rationalization Table**: common excuses + rebuttals
- **Red Flags**: observable signals that the phase is going off track
- **Verification Gate**: hard evidence required before proceeding

> **Core principle: Don't trust the agent's judgment. Only trust the agent's evidence.**

---

## Design Credits

| Source | Contribution |
|--------|-------------|
| OpenAI | Harness engineering, repo as system of record |
| Anthropic | Planner-generator-evaluator, sprint contracts |
| Cursor | Recursive planner-worker, constraints > instructions |
| Symphony | Ticket → workspace → run → proof-of-work → PR |
| agent-skills (Addy Osmani) | Anti-rationalization, progressive disclosure, skill-per-phase |

---

## License

MIT
