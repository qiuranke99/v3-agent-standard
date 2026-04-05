#!/bin/bash
# V3.1 Project Bootstrap Script
# Usage: ./bootstrap.sh <project-name> [target-dir]
#
# Scaffolds a new project with the full V3.1 directory structure and templates.

set -euo pipefail

PROJECT_NAME="${1:?Usage: ./bootstrap.sh <project-name> [target-dir]}"
TARGET_DIR="${2:-.}"
PROJECT_DIR="$TARGET_DIR/$PROJECT_NAME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$REPO_ROOT/templates"

if [ -d "$PROJECT_DIR" ]; then
    echo "Error: Directory '$PROJECT_DIR' already exists."
    exit 1
fi

echo "🚀 Bootstrapping V3.1 project: $PROJECT_NAME"
echo "   Location: $PROJECT_DIR"
echo ""

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p "$PROJECT_DIR"/{docs/{specs,contracts,acceptance,rubrics,runbooks,changelogs},tasks/{active,done,rejected},evidence/{screenshots,logs,traces,reports},scripts,src,.ci}

# Copy templates
echo "📄 Installing templates..."
cp "$TEMPLATES_DIR/AGENTS.md" "$PROJECT_DIR/AGENTS.md"
cp "$TEMPLATES_DIR/WORKFLOW.md" "$PROJECT_DIR/WORKFLOW.md"
cp "$TEMPLATES_DIR/TASK_CONTRACT.md" "$PROJECT_DIR/tasks/active/TASK_CONTRACT_TEMPLATE.md"
cp "$TEMPLATES_DIR/HANDOFF.md" "$PROJECT_DIR/tasks/active/HANDOFF_TEMPLATE.md"
cp "$TEMPLATES_DIR/PROOF_OF_WORK.md" "$PROJECT_DIR/tasks/active/PROOF_OF_WORK_TEMPLATE.md"
cp "$TEMPLATES_DIR/SPEC.md" "$PROJECT_DIR/docs/specs/SPEC_TEMPLATE.md"
cp "$TEMPLATES_DIR/SPRINT_PLAN.md" "$PROJECT_DIR/docs/specs/SPRINT_PLAN_TEMPLATE.md"

# Create starter files
cat > "$PROJECT_DIR/README.md" << EOF
# $PROJECT_NAME

> Built with [V3.1 — Layered Agent Engineering Standard](https://github.com/qiuranke99/v3-agent-standard)

## Overview
<!-- What does this project do? -->

## Quick Start
<!-- How to get running -->

## Architecture
See [ARCHITECTURE.md](ARCHITECTURE.md) for system design.
EOF

cat > "$PROJECT_DIR/ARCHITECTURE.md" << 'EOF'
# Architecture

## System Overview
<!-- High-level system diagram and description -->

## Module Boundaries
<!-- What are the main modules and their responsibilities? -->

## Key Decisions
See [DECISIONS.md](DECISIONS.md) for architectural decision records.

## Constraints
<!-- Non-negotiable technical constraints -->
EOF

cat > "$PROJECT_DIR/DECISIONS.md" << 'EOF'
# Architectural Decision Records

## Template

### ADR-NNN: [Title]
- **Date:** YYYY-MM-DD
- **Status:** proposed | accepted | deprecated | superseded
- **Context:** Why is this decision needed?
- **Decision:** What was decided?
- **Consequences:** What are the trade-offs?
EOF

cat > "$PROJECT_DIR/GLOSSARY.md" << 'EOF'
# Glossary

| Term | Definition |
|------|-----------|
|      |           |
EOF

# Create placeholder scripts
for script in bootstrap.sh run_eval.sh make_pow.sh janitor.sh release_snapshot.sh; do
    cat > "$PROJECT_DIR/scripts/$script" << EOF
#!/bin/bash
# $script — TODO: implement
set -euo pipefail
echo "$script not yet implemented"
EOF
    chmod +x "$PROJECT_DIR/scripts/$script"
done

# Create .gitkeep files for empty directories
for dir in evidence/screenshots evidence/logs evidence/traces evidence/reports tasks/done tasks/rejected docs/contracts docs/acceptance docs/rubrics docs/runbooks docs/changelogs .ci; do
    touch "$PROJECT_DIR/$dir/.gitkeep"
done

# Summary
echo ""
echo "✅ V3.1 project '$PROJECT_NAME' bootstrapped successfully!"
echo ""
echo "   Structure:"
find "$PROJECT_DIR" -maxdepth 2 -not -path '*/\.*' | sort | sed "s|$TARGET_DIR/||" | head -40
echo ""
echo "   Next steps:"
echo "   1. cd $PROJECT_DIR"
echo "   2. git init && git add -A && git commit -m 'P0: repo bootstrap'"
echo "   3. Update README.md and ARCHITECTURE.md"
echo "   4. Start your first task: cp tasks/active/TASK_CONTRACT_TEMPLATE.md tasks/active/TASK-001.md"
echo ""
