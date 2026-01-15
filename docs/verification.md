# Verification Guide

This guide explains how the repository verifies that the CLI behaves as documented. The verification script is deterministic and designed to run in CI.

## Canonical Verification Command

```bash
./scripts/verify.sh
```

### What It Does

1. Configures a test data path.
2. Runs the Minitest suite via `rake test`.
3. Executes a smoke test against the CLI.

Every step must succeed for the script to exit with code `0`.

## Minitest Suite

The unit tests cover:

- Model validations and defaults.
- Repository CRUD behavior.
- Configuration loading.
- Storage serialization.
- CLI command wiring.
- Formatter output formatting.
- Statistics calculations.

The tests are deterministic and use a dedicated JSON file stored in `tmp/tasks_test.json` (or the path provided by `TASK_MANAGER_TEST_DATA_PATH`). The test data file is deleted before each test.

### Running Tests Directly

```bash
rake test
```

## Smoke Test

The smoke test is defined in `scripts/smoke_test.sh`. It performs these actions:

1. Creates a temporary data file.
2. Adds a task with the CLI.
3. Lists tasks and confirms the new task appears.
4. Updates the task to mark it complete.
5. Deletes the task.

Each step checks the output for expected strings to ensure the CLI behavior matches the README contract.

### Running the Smoke Test Directly

```bash
./scripts/smoke_test.sh
```

## Deterministic Outcomes

The verification scripts make several assumptions for determinism:

- Tasks are ordered by ID in the list output.
- The data file is stored in a known location (configured via env vars).
- CLI output strings are stable and tested.

If you change output formats, update both the tests and documentation.

## CI Integration

The GitHub Actions workflow runs `./scripts/verify.sh` on every push and pull request. This ensures that:

- The app runs cleanly in a fresh environment.
- The test suite passes.
- The CLI is verified end-to-end.

## Debugging Failures

If verification fails:

1. Re-run the failing command locally with verbose output.
2. Inspect `tmp/` for leftover data files.
3. Ensure all environment variables are set correctly.

### Common Issues

- **Missing config**: ensure `config/task_manager.yml` exists.
- **Permission errors**: ensure the data file path is writable.
- **Invalid JSON**: delete the data file and rerun tests.

## Extending Verification

When adding new features:

- Add unit tests under `test/`.
- Extend `scripts/smoke_test.sh` if the README contract changes.
- Update the README and CLI reference docs.

## Verification Checklist

- [ ] `rake test` succeeds.
- [ ] `./scripts/verify.sh` returns exit code 0.
- [ ] New commands are covered by tests.
- [ ] Documentation reflects the latest CLI behavior.

## Example Verification Output

Typical `rake test` output:

```
7 runs, 25 assertions, 0 failures, 0 errors, 0 skips
```

Smoke test output:

```
Created task #1: Smoke Task
...
Deleted task #1
```

## Summary

The verification script is the single source of truth for CI. If it passes, the CLI should behave as documented.
