# Skill: agent-fix-lint-plus

This skill provides a guardrailed workflow to repair lint failures locally.

## Purpose

- Identify lint steps from `.github/workflows/ci.yml`.
- Run `make lint` locally.
- If lint fails, apply deterministic fixes using `<lint-command> --fix`.
- Stop after **two attempts** or if guardrails are violated.

## Guardrails

- Maximum attempts: **2**.
- Maximum files changed: **10**.
- Maximum lines changed: **300**.
- **Forbidden**: changes to `.github/workflows/**`.

## Usage

```bash
skills/agent-fix-lint-plus/agent-fix-lint-plus.sh
```

## Repair Capsules

When a fix is applied, emit a repair capsule summarizing:

- The lint command executed.
- The exact files changed.
- Whether deterministic fixes were applied.
- Any remaining failures or manual follow-ups required.
