---
tracker:
  kind: local
workspace:
  root: ./workspaces
agent:
  max_concurrent_agents: 1
  max_turns: 12
states:
  - todo
  - in_progress
  - evaluation
  - human_review
  - rework
  - merged
  - closed
retry:
  max_attempts: 2
merge:
  requires_pow: true
  requires_green_ci: true
  requires_evaluator_pass: true
---

# Workflow

## State Machine

```mermaid
stateDiagram-v2
    [*] --> todo
    todo --> in_progress : agent picks up ticket
    in_progress --> evaluation : builder produces handoff
    evaluation --> merged : evaluator pass + PoW complete
    evaluation --> rework : evaluator fail
    rework --> in_progress : builder retries
    evaluation --> human_review : risk threshold exceeded
    human_review --> merged : human approves
    human_review --> rework : human requests changes
    merged --> closed : janitor complete
    rework --> closed : max retries exceeded
```

## Agent Instructions

You are working on ticket {{ ticket.id }}.

Follow:
1. Read AGENTS.md
2. Read the linked contract/spec
3. Execute only the current task
4. Produce HANDOFF.md
5. Produce Proof of Work
6. Stop if evidence is insufficient
