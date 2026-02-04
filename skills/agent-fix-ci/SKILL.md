# Skill: agent-fix-ci

This skill provides a guardrailed workflow to repair CI failures locally.

## Purpose

- Parse `.github/workflows/ci.yml` to identify the standard checks.
- Run checks locally using the `Makefile` targets.
- Auto-fix **formatting only** by invoking `make format` when `make format-check` fails.
- Stop on any other failure and report the error.

## Guardrails

- Maximum iterations: **3**.
- Maximum files changed: **10**.
- Maximum lines changed: **300**.
- **Forbidden**: changes to `.github/workflows/**`.

If any guardrail is violated, the script exits with an error.

## Usage

```bash
skills/agent-fix-ci/agent-fix-ci.sh
```

## Repair Capsules

When a fix is applied, emit a repair capsule summarizing:

- The checks that ran.
- The exact files changed.
- Whether formatting was applied.
- Any remaining failures or manual follow-ups required.
