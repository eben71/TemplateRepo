#!/usr/bin/env bash
set -euo pipefail

# Agent script: agent-fix-lint-plus
# Runs lint steps, applies deterministic fixes, and stops after two attempts.

WORKFLOW_FILE=".github/workflows/ci.yml"
MAX_ATTEMPTS=2
MAX_FILES_CHANGED=10
MAX_LINES_CHANGED=300

if [ ! -f "$WORKFLOW_FILE" ]; then
  echo "CI workflow not found: $WORKFLOW_FILE" >&2
  exit 1
fi

attempt=1
while [ "$attempt" -le "$MAX_ATTEMPTS" ]; do
  echo "Attempt $attempt/$MAX_ATTEMPTS"

  if make lint; then
    echo "Lint passed."
    exit 0
  fi

  echo "Lint failed. Attempting deterministic fixes."
  <lint-command> --fix || true

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

  attempt=$((attempt + 1))
done

echo "Lint still failing after ${MAX_ATTEMPTS} attempts." >&2
exit 1
