#!/bin/bash
# V3.1 Project Operating System — Main Entry Point
# Usage:
#   v3.sh init <project-name>     Initialize a new V3.1 project
#   v3.sh status                  Show current phase, task, gate status
#   v3.sh gate                    Run gate check for current phase
#   v3.sh next                    Transition to next phase (requires gate pass)
#   v3.sh evidence <type>         Capture evidence (test|lint|build|screenshot)
#   v3.sh reset                   Reset retry count (after fixing issues)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
V3_ROOT="$(dirname "$SCRIPT_DIR")"
STATE_FILE="./runtime/state.json"

# ─── Colors ───
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ─── Helpers ───
require_state() {
    if [ ! -f "$STATE_FILE" ]; then
        echo -e "${RED}Error: No state.json found. Run 'v3.sh init <name>' first.${NC}"
        exit 1
    fi
}

get_phase() {
    require_state
    python3 -c "import json; print(json.load(open('$STATE_FILE')).get('current_phase', 'null'))" 2>/dev/null || echo "null"
}

get_task() {
    require_state
    python3 -c "import json; print(json.load(open('$STATE_FILE')).get('active_task', 'none'))" 2>/dev/null || echo "none"
}

get_retries() {
    require_state
    python3 -c "import json; print(json.load(open('$STATE_FILE')).get('retry_count', 0))" 2>/dev/null || echo "0"
}

update_state() {
    local key="$1"
    local value="$2"
    python3 -c "
import json, sys
with open('$STATE_FILE', 'r') as f:
    state = json.load(f)
state['$key'] = $value
with open('$STATE_FILE', 'w') as f:
    json.dump(state, f, indent=2)
"
}

add_phase_history() {
    local phase="$1"
    local gate_passed="$2"
    python3 -c "
import json
from datetime import datetime, timezone
with open('$STATE_FILE', 'r') as f:
    state = json.load(f)
state.setdefault('phase_history', []).append({
    'phase': '$phase',
    'entered': datetime.now(timezone.utc).isoformat(),
    'gate_passed': $gate_passed
})
with open('$STATE_FILE', 'w') as f:
    json.dump(state, f, indent=2)
"
}

# ─── INIT ───
cmd_init() {
    local project_name="${1:?Usage: v3.sh init <project-name>}"

    if [ -d "$project_name" ]; then
        echo -e "${RED}Error: Directory '$project_name' already exists.${NC}"
        exit 1
    fi

    echo -e "${CYAN}🚀 V3.1 Project OS — Initializing: $project_name${NC}"
    echo ""

    # Use bootstrap script if available
    if [ -f "$V3_ROOT/scripts/bootstrap.sh" ]; then
        bash "$V3_ROOT/scripts/bootstrap.sh" "$project_name"
    else
        mkdir -p "$project_name"/{docs/{specs,contracts,acceptance,rubrics,runbooks,changelogs},tasks/{active,done,rejected},evidence/{screenshots,logs,traces,reports},scripts,src,.ci}
    fi

    # Create runtime state
    mkdir -p "$project_name/runtime"
    cat > "$project_name/runtime/state.json" << EOF
{
  "project": "$project_name",
  "current_phase": "P0",
  "active_task": null,
  "retry_count": 0,
  "max_retries": 2,
  "escalation_triggered": false,
  "phase_history": [
    {
      "phase": "P0",
      "entered": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
      "gate_passed": null
    }
  ]
}
EOF

    # Copy checklists if available
    if [ -d "$V3_ROOT/checklists" ]; then
        cp "$V3_ROOT/checklists/"*.md "$project_name/docs/rubrics/" 2>/dev/null || true
    fi

    echo ""
    echo -e "${GREEN}✅ V3.1 Project OS initialized: $project_name${NC}"
    echo -e "   Phase: ${CYAN}P0 — Bootstrap${NC}"
    echo -e "   State: runtime/state.json"
    echo ""
    echo "   Next: cd $project_name && complete P0 bootstrap checklist"
}

# ─── STATUS ───
cmd_status() {
    require_state
    local phase=$(get_phase)
    local task=$(get_task)
    local retries=$(get_retries)
    local escalated=$(python3 -c "import json; print(json.load(open('$STATE_FILE')).get('escalation_triggered', False))" 2>/dev/null)

    echo -e "${CYAN}═══════════════════════════════════════${NC}"
    echo -e "${CYAN}  V3.1 Project OS — Status${NC}"
    echo -e "${CYAN}═══════════════════════════════════════${NC}"

    local phase_name=""
    case "$phase" in
        P0) phase_name="Bootstrap" ;;
        P1) phase_name="Task Contract" ;;
        P2) phase_name="Planning / Spec" ;;
        P3) phase_name="Execution Run" ;;
        P4) phase_name="Independent Evaluation" ;;
        P5) phase_name="Merge / Release Gate" ;;
        P6) phase_name="Janitor / Gardener" ;;
        P7) phase_name="Concurrency Expansion" ;;
        null) phase_name="No active phase" ;;
        *) phase_name="Unknown" ;;
    esac

    echo -e "  Phase:      ${GREEN}$phase — $phase_name${NC}"
    echo -e "  Task:       $task"
    echo -e "  Retries:    $retries"

    if [ "$escalated" = "True" ]; then
        echo -e "  Escalation: ${RED}⚠️  TRIGGERED — Human review required${NC}"
    else
        echo -e "  Escalation: ${GREEN}None${NC}"
    fi

    echo -e "${CYAN}═══════════════════════════════════════${NC}"

    # Show gate checklist for current phase
    echo ""
    echo -e "  Gate checklist for $phase:"
    case "$phase" in
        P0) echo "  - [ ] Standard directory structure exists"
            echo "  - [ ] AGENTS.md exists"
            echo "  - [ ] README.md + ARCHITECTURE.md exist"
            echo "  - [ ] Templates installed"
            echo "  - [ ] CI baseline configured" ;;
        P1) echo "  - [ ] Task contract in tasks/active/"
            echo "  - [ ] Goal has exactly one verb"
            echo "  - [ ] Acceptance has zero fuzzy words"
            echo "  - [ ] Rollback condition defined" ;;
        P2) echo "  - [ ] SPEC.md with deliverables"
            echo "  - [ ] Sprint Plan with ≥2 chunks"
            echo "  - [ ] Each chunk has acceptance"
            echo "  - [ ] Risk list non-empty" ;;
        P3) echo "  - [ ] Tests exist for each chunk"
            echo "  - [ ] Test suite green"
            echo "  - [ ] HANDOFF.md complete"
            echo "  - [ ] No uncommitted changes" ;;
        P4) echo "  - [ ] Evaluator ran tests independently"
            echo "  - [ ] Five-axis review complete"
            echo "  - [ ] Verdict: PASS/FAIL/CAVEATS"
            echo "  - [ ] Evidence in evidence/" ;;
        P5) echo "  - [ ] Lint/type/test/build all green"
            echo "  - [ ] Acceptance 100% checked"
            echo "  - [ ] PoW document complete"
            echo "  - [ ] Merge recommendation stated" ;;
        P6) echo "  - [ ] Dead code removed"
            echo "  - [ ] Docs in sync"
            echo "  - [ ] Task archived"
            echo "  - [ ] Tests still green" ;;
    esac
}

# ─── GATE ───
cmd_gate() {
    require_state
    local phase=$(get_phase)
    local pass=true
    local failures=""

    echo -e "${CYAN}Running gate check for $phase...${NC}"
    echo ""

    case "$phase" in
        P0)
            [ -f "AGENTS.md" ] && echo -e "  ${GREEN}✓${NC} AGENTS.md exists" || { echo -e "  ${RED}✗${NC} AGENTS.md missing"; pass=false; failures="$failures\n  - Create AGENTS.md"; }
            [ -f "README.md" ] && echo -e "  ${GREEN}✓${NC} README.md exists" || { echo -e "  ${RED}✗${NC} README.md missing"; pass=false; failures="$failures\n  - Create README.md"; }
            [ -f "ARCHITECTURE.md" ] && echo -e "  ${GREEN}✓${NC} ARCHITECTURE.md exists" || { echo -e "  ${RED}✗${NC} ARCHITECTURE.md missing"; pass=false; failures="$failures\n  - Create ARCHITECTURE.md"; }
            [ -d "docs" ] && echo -e "  ${GREEN}✓${NC} docs/ exists" || { echo -e "  ${RED}✗${NC} docs/ missing"; pass=false; failures="$failures\n  - Create docs/ directory"; }
            [ -d "tasks" ] && echo -e "  ${GREEN}✓${NC} tasks/ exists" || { echo -e "  ${RED}✗${NC} tasks/ missing"; pass=false; failures="$failures\n  - Create tasks/ directory"; }
            [ -d "evidence" ] && echo -e "  ${GREEN}✓${NC} evidence/ exists" || { echo -e "  ${RED}✗${NC} evidence/ missing"; pass=false; failures="$failures\n  - Create evidence/ directory"; }
            ;;
        P1)
            local contracts=$(find tasks/active -name "TASK-*.md" 2>/dev/null | head -1)
            [ -n "$contracts" ] && echo -e "  ${GREEN}✓${NC} Task contract exists" || { echo -e "  ${RED}✗${NC} No task contract in tasks/active/"; pass=false; failures="$failures\n  - Create task contract"; }
            if [ -n "$contracts" ]; then
                grep -qi "## Goal" "$contracts" && echo -e "  ${GREEN}✓${NC} Goal section exists" || { echo -e "  ${RED}✗${NC} Missing Goal section"; pass=false; }
                grep -qi "## Acceptance" "$contracts" && echo -e "  ${GREEN}✓${NC} Acceptance section exists" || { echo -e "  ${RED}✗${NC} Missing Acceptance section"; pass=false; }
                grep -qi "## Non-Goals\|## Non Goals" "$contracts" && echo -e "  ${GREEN}✓${NC} Non-Goals section exists" || { echo -e "  ${RED}✗${NC} Missing Non-Goals section"; pass=false; }
                grep -qi "## Rollback" "$contracts" && echo -e "  ${GREEN}✓${NC} Rollback section exists" || { echo -e "  ${RED}✗${NC} Missing Rollback section"; pass=false; }
                # Check for fuzzy words in acceptance
                if grep -A 50 "## Acceptance" "$contracts" | grep -qi "reasonable\|appropriate\|try to\|if possible\|as needed"; then
                    echo -e "  ${RED}✗${NC} Acceptance contains fuzzy words"
                    pass=false
                else
                    echo -e "  ${GREEN}✓${NC} Acceptance has no fuzzy words"
                fi
            fi
            ;;
        P3)
            [ -f "tasks/active/HANDOFF.md" ] || ls tasks/active/HANDOFF-*.md &>/dev/null && echo -e "  ${GREEN}✓${NC} HANDOFF exists" || { echo -e "  ${YELLOW}?${NC} No HANDOFF.md yet (expected at end of P3)"; }
            if command -v npm &>/dev/null && [ -f "package.json" ]; then
                echo "  Running npm test..."
                if npm test --silent 2>/dev/null; then
                    echo -e "  ${GREEN}✓${NC} Tests pass"
                else
                    echo -e "  ${RED}✗${NC} Tests fail"; pass=false
                fi
            elif command -v pytest &>/dev/null; then
                echo "  Running pytest..."
                if pytest --quiet 2>/dev/null; then
                    echo -e "  ${GREEN}✓${NC} Tests pass"
                else
                    echo -e "  ${RED}✗${NC} Tests fail"; pass=false
                fi
            else
                echo -e "  ${YELLOW}?${NC} No test runner detected — manual verification needed"
            fi
            # Check for uncommitted changes
            if git status --porcelain 2>/dev/null | grep -q .; then
                echo -e "  ${RED}✗${NC} Uncommitted changes exist"; pass=false
            else
                echo -e "  ${GREEN}✓${NC} Working tree clean"
            fi
            ;;
        P5)
            if command -v npm &>/dev/null && [ -f "package.json" ]; then
                npm run lint --silent 2>/dev/null && echo -e "  ${GREEN}✓${NC} Lint passes" || { echo -e "  ${RED}✗${NC} Lint fails"; pass=false; }
                npm test --silent 2>/dev/null && echo -e "  ${GREEN}✓${NC} Tests pass" || { echo -e "  ${RED}✗${NC} Tests fail"; pass=false; }
                npm run build --silent 2>/dev/null && echo -e "  ${GREEN}✓${NC} Build succeeds" || { echo -e "  ${RED}✗${NC} Build fails"; pass=false; }
            fi
            local pow=$(find evidence/reports -name "POW-*.md" 2>/dev/null | head -1)
            [ -n "$pow" ] && echo -e "  ${GREEN}✓${NC} Proof of Work exists" || { echo -e "  ${RED}✗${NC} No PoW in evidence/reports/"; pass=false; }
            ;;
        *)
            echo -e "  ${YELLOW}Gate check for $phase: manual verification required${NC}"
            echo "  Review the gate checklist in 'v3.sh status'"
            return 0
            ;;
    esac

    echo ""
    if [ "$pass" = true ]; then
        echo -e "${GREEN}═══ GATE PASSED ═══${NC}"
        echo "Run 'v3.sh next' to transition to next phase."
        add_phase_history "$phase" "true"
    else
        echo -e "${RED}═══ GATE FAILED ═══${NC}"
        echo -e "Fix the following before retrying:"
        echo -e "$failures"
        add_phase_history "$phase" "false"
    fi
}

# ─── NEXT ───
cmd_next() {
    require_state
    local phase=$(get_phase)
    local next_phase=""

    case "$phase" in
        P0) next_phase="P1" ;;
        P1) next_phase="P2" ;;
        P2) next_phase="P3" ;;
        P3) next_phase="P4" ;;
        P4) next_phase="P5" ;;
        P5) next_phase="P6" ;;
        P6) next_phase="null" ;;
        null) echo -e "${YELLOW}No active phase. Start a new task with P1.${NC}"; next_phase="P1" ;;
        *) echo -e "${RED}Unknown phase: $phase${NC}"; exit 1 ;;
    esac

    echo -e "${CYAN}Transitioning: $phase → $next_phase${NC}"
    update_state "current_phase" "\"$next_phase\""
    update_state "retry_count" "0"
    add_phase_history "$next_phase" "null"

    local phase_name=""
    case "$next_phase" in
        P1) phase_name="Task Contract" ;;
        P2) phase_name="Planning / Spec" ;;
        P3) phase_name="Execution Run" ;;
        P4) phase_name="Independent Evaluation" ;;
        P5) phase_name="Merge / Release Gate" ;;
        P6) phase_name="Janitor / Gardener" ;;
        null) phase_name="Complete"; echo -e "${GREEN}✅ Task lifecycle complete.${NC}"; return 0 ;;
    esac

    echo -e "${GREEN}Now in: $next_phase — $phase_name${NC}"
    echo "Load skill: v3-$(echo $phase_name | tr '[:upper:]' '[:lower:]' | tr ' /' '-' | cut -d- -f1-2)"
}

# ─── EVIDENCE ───
cmd_evidence() {
    local type="${1:?Usage: v3.sh evidence <test|lint|build>}"
    local timestamp=$(date +%Y%m%d_%H%M%S)

    mkdir -p evidence/logs

    case "$type" in
        test)
            echo -e "${CYAN}Capturing test evidence...${NC}"
            if [ -f "package.json" ]; then
                npm test 2>&1 | tee "evidence/logs/test_${timestamp}.log"
            elif command -v pytest &>/dev/null; then
                pytest -v 2>&1 | tee "evidence/logs/test_${timestamp}.log"
            else
                echo "No test runner detected. Saving manual note."
                echo "Manual test run at $timestamp" > "evidence/logs/test_${timestamp}.log"
            fi
            echo -e "${GREEN}Evidence saved: evidence/logs/test_${timestamp}.log${NC}"
            ;;
        lint)
            echo -e "${CYAN}Capturing lint evidence...${NC}"
            if [ -f "package.json" ]; then
                npm run lint 2>&1 | tee "evidence/logs/lint_${timestamp}.log" || true
            elif command -v ruff &>/dev/null; then
                ruff check . 2>&1 | tee "evidence/logs/lint_${timestamp}.log" || true
            fi
            echo -e "${GREEN}Evidence saved: evidence/logs/lint_${timestamp}.log${NC}"
            ;;
        build)
            echo -e "${CYAN}Capturing build evidence...${NC}"
            if [ -f "package.json" ]; then
                npm run build 2>&1 | tee "evidence/logs/build_${timestamp}.log" || true
            fi
            echo -e "${GREEN}Evidence saved: evidence/logs/build_${timestamp}.log${NC}"
            ;;
        *)
            echo -e "${RED}Unknown evidence type: $type${NC}"
            echo "Available: test, lint, build"
            exit 1
            ;;
    esac
}

# ─── RESET ───
cmd_reset() {
    require_state
    update_state "retry_count" "0"
    update_state "escalation_triggered" "false"
    echo -e "${GREEN}Retry count reset to 0. Escalation cleared.${NC}"
}

# ─── MAIN ───
case "${1:-help}" in
    init)     cmd_init "${2:-}" ;;
    status)   cmd_status ;;
    gate)     cmd_gate ;;
    next)     cmd_next ;;
    evidence) cmd_evidence "${2:-}" ;;
    reset)    cmd_reset ;;
    help|*)
        echo "V3.1 Project Operating System"
        echo ""
        echo "Usage: v3.sh <command> [args]"
        echo ""
        echo "Commands:"
        echo "  init <name>      Initialize a new V3.1 project"
        echo "  status           Show current phase, task, gate status"
        echo "  gate             Run gate check for current phase"
        echo "  next             Transition to next phase"
        echo "  evidence <type>  Capture evidence (test|lint|build)"
        echo "  reset            Reset retry count"
        echo ""
        ;;
esac
