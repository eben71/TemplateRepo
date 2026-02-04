#!/usr/bin/env bash
set -euo pipefail

# Agent script: agent-fix-ci
# Parses CI workflow, executes check steps locally, applies formatting fixes, and stops on other failures.

WORKFLOW_FILE=".github/workflows/ci.yml"
MAX_ITERATIONS=3
MAX_FILES_CHANGED=10
MAX_LINES_CHANGED=300

if [ ! -f "$WORKFLOW_FILE" ]; then
  echo "CI workflow not found: $WORKFLOW_FILE" >&2
  exit 1
fi

if rg -n "^\s*-\s*name:\s*(Lint|Format check|Typecheck|Test|Build|Check docs)" "$WORKFLOW_FILE" > /dev/null; then
  echo "Detected CI steps in $WORKFLOW_FILE"
else
  echo "No recognizable CI steps found; update the workflow or this script." >&2
  exit 1
fi

iteration=1
while [ "$iteration" -le "$MAX_ITERATIONS" ]; do
  echo "Iteration $iteration/$MAX_ITERATIONS"

  echo "Running lint"
  make lint

  echo "Running format check"
  if ! make format-check; then
    echo "Formatting issues detected. Running formatter."
    make format
  fi

  echo "Running typecheck"
  make typecheck

  echo "Running tests"
  make test

  echo "Running docs check"
  scripts/check-docs

  echo "Running coverage check"
  scripts/check-coverage

  echo "Running build"
  make build

  if git status --porcelain | rg -n "^..*\.github/workflows/" > /dev/null; then
    echo "Guardrail violation: changes to .github/workflows are not allowed." >&2
    exit 1
  fi

  changed_files=$(git status --porcelain | wc -l | tr -d ' ')
  if [ "$changed_files" -gt "$MAX_FILES_CHANGED" ]; then
    echo "Guardrail violation: too many files changed ($changed_files)." >&2
    exit 1
  fi

  changed_lines=$(git diff --numstat | awk '{sum += $1 + $2} END {print sum + 0}')
  if [ "$changed_lines" -gt "$MAX_LINES_CHANGED" ]; then
    echo "Guardrail violation: too many lines changed ($changed_lines)." >&2
    exit 1
  fi

  echo "CI checks passed within guardrails."
  exit 0

done

echo "Reached max iterations without resolving issues." >&2
exit 1
