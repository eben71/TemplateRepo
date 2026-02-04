# Agent Quality Gates (Non-Negotiable)

These rules apply to all work performed in this repository and any derived repositories. They are mandatory quality gates.

## Security & Privacy

- **No secrets or PII** may be stored in code, logs, or committed files.
- Use placeholders or environment variables for all credentials.
- Follow security best practices for handling sensitive data.

## Testing & Coverage

- All changes must pass the full CI suite.
- Test coverage must be **≥ 80%** for applicable code paths.
- If coverage drops below 80%, the change must be updated or rejected.

## Documentation

- Documentation **must be updated** when behavior, public interfaces, or APIs change.
- README updates are required when setup or usage changes.

## Dependencies

- Adding dependencies requires **explicit justification** in the change request or documentation.
- Avoid unnecessary or redundant dependencies.

## CI/CD Compliance

- Changes must pass all CI checks before merge.
- Quality scripts (coverage and documentation checks) must be maintained and updated to match project needs.

## General Expectations

- Follow least-privilege and secure-by-default practices.
- Keep changes minimal, focused, and well-explained.
