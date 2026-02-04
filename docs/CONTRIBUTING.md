# Contributing Guide

Thank you for contributing! This repository is a template designed to be customized in derived projects.

## Getting Started

1. Copy `.env.example` to `.env` and fill in required values.
2. Run `make setup` to install dependencies.
3. Run `make dev` to start local services.

## Standard Tasks

All commands below are placeholders that map to **stack-specific** implementations in derived repositories. Update the `Makefile` commands to match your project.

- `make setup`: install project dependencies (`<install-deps-command>`).
- `make dev`: start local services (`<start-dev-services>`).
- `make lint`: run static analysis (`<lint-command>`).
- `make format`: apply code formatting (`<format-command>`).
- `make format-check`: verify code formatting (`<format-command>`).
- `make typecheck`: run static type checks (`<typecheck-command>`).
- `make test`: run tests with coverage (`<run-tests>`).
- `make build`: build production artifacts (`<build-command>`).
- `make hooks`: install git hooks via Lefthook/Husky or equivalent.

## Updating the Template

When customizing this template:

- Replace all placeholder commands with project-specific equivalents.
- Update documentation and scripts to reflect the actual build and test outputs.
- Ensure CI workflows use the correct setup actions for your stack.
