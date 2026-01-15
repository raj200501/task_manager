# Contributing Guide

Thank you for considering contributions to Task Manager! This guide explains local setup, development workflow, and expectations for pull requests.

## Development Setup

1. Run the test suite:

```bash
./scripts/verify.sh
```

2. Run the CLI:

```bash
./scripts/run.sh help
```

No external gems are required; the project uses Ruby's standard library.

## Project Conventions

### Code Style

- Ruby code should be idiomatic and use frozen string literals.
- Prefer small classes with clear responsibilities.
- Avoid try/catch around imports (per repository guidelines).

### Documentation

- Update `README.md` when behavior changes.
- Update docs under `docs/` when adding new commands.

### Tests

- Add or update Minitest cases for every behavior change.
- Ensure the smoke test in `scripts/smoke_test.sh` still passes.

## Workflow

1. Create a feature branch.
2. Make changes with tests.
3. Run `./scripts/verify.sh` locally.
4. Submit a pull request.

## Adding New CLI Commands

When adding a new command:

1. Update `lib/task_manager/cli.rb` with a new handler method.
2. Update `TaskManager` and `Repository` as needed.
3. Add unit tests under `test/`.
4. Update `docs/cli_reference.md` with examples.
5. Update README if the command is part of the public contract.

## Example: Adding a Tag Feature

High-level steps:

1. Add a `tags` field to the task model and storage serialization.
2. Update `TaskManager::Task` validations.
3. Update the formatter to display tags.
4. Add CLI flags for `add` and `update`.
5. Update tests and documentation.

## Release Notes

All changes should include a brief summary in the pull request description. For significant changes, update `docs/release.md` with a checklist.

## Code Review Checklist

- [ ] Code is readable and consistent.
- [ ] Tests cover new logic.
- [ ] Documentation reflects behavior.
- [ ] `./scripts/verify.sh` passes.

## Getting Help

If you are unsure about a change, open an issue or discuss with a maintainer. Provide:

- Steps to reproduce the issue.
- Expected vs actual behavior.
- Any relevant logs or output.

## Repository Scripts

| Script | Purpose |
| --- | --- |
| `scripts/run.sh` | Run the CLI |
| `scripts/verify.sh` | Full verification (tests + smoke) |
| `scripts/smoke_test.sh` | CLI smoke test only |

## Testing Tips

- Use `TASK_MANAGER_TEST_DATA_PATH` to isolate test data.
- Use `rake test` to run specific test files.

## Branch Naming

Suggested branch naming conventions:

- `feature/<short-description>`
- `fix/<short-description>`
- `docs/<short-description>`

## Commit Messages

Write clear, imperative commit messages, e.g.:

- `Add CLI stats command`
- `Fix storage serialization`

## Summary

We aim for clarity, deterministic behavior, and thorough documentation. Contributions that improve reliability and usability are especially welcome.
