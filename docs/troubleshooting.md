# Troubleshooting Guide

This guide documents common issues and their resolutions.

## CLI Prints "Missing configuration"

**Cause**: The `TASK_MANAGER_ENV` does not exist in `config/task_manager.yml`.

**Fix**:

- Open `config/task_manager.yml` and confirm the environment name.
- Set `TASK_MANAGER_ENV` to a valid value.

```bash
export TASK_MANAGER_ENV=development
```

## CLI Fails With "Permission denied"

**Cause**: The data path is not writable.

**Fix**:

- Choose a writable path:

```bash
export TASK_MANAGER_DATA_PATH=tmp/alternate.json
```

## Tests Fail Due to Missing Data File

**Cause**: The test data file path is incorrect or missing.

**Fix**:

```bash
export TASK_MANAGER_TEST_DATA_PATH=tmp/tasks_test.json
rake test
```

The `./scripts/verify.sh` script sets the path automatically.

## "Error: Title is required."

**Cause**: The `--title` argument was omitted or empty.

**Fix**:

```bash
./scripts/run.sh add --title "My Task"
```

## "Error: Task 99 not found."

**Cause**: The ID does not exist in the current data file.

**Fix**:

- List tasks to confirm IDs:

```bash
./scripts/run.sh list
```

- Use a valid ID:

```bash
./scripts/run.sh delete --id 2
```

## Invalid JSON Errors

**Cause**: The data file was manually edited or corrupted.

**Fix**:

- Delete the file and re-run the CLI:

```bash
rm -f data/tasks_development.json
./scripts/run.sh list
```

## CLI Hangs or Feels Slow

**Cause**: Large data files or slow disk I/O.

**Fix**:

- Archive old tasks or move the data file to faster storage.

## Output Formatting Looks Misaligned

**Cause**: Very long titles/descriptions.

**Fix**:

- Shorten titles/descriptions.
- If this is a common case, adjust the formatter to truncate values.

## Command Summary for Quick Checks

```bash
./scripts/run.sh help
./scripts/run.sh list
./scripts/run.sh stats
```

## Resetting the Data File

To reset development data:

```bash
rake storage:reset
```

## Summary

Most issues are resolved by confirming the correct environment and storage path. The helper scripts aim to make setup deterministic.
