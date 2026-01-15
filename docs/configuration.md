# Configuration Reference

This guide covers how Task Manager is configured, which environment variables affect behavior, and how to customize storage paths.

## Configuration Sources

Task Manager uses the following sources for configuration:

1. `config/task_manager.yml` (primary source)
2. Environment variables for overrides
3. Default values embedded in the YAML file

The YAML file is evaluated via ERB, so environment variable interpolation is supported.

## Environment Selection

The active environment is selected in this order:

1. `TASK_MANAGER_ENV`
2. `APP_ENV`
3. `development`

For example:

```bash
export TASK_MANAGER_ENV=test
```

This will make Task Manager load the `test` entry from `config/task_manager.yml`.

## Storage Configuration

The default `config/task_manager.yml` looks like this:

```yaml
default: &default
  storage_path: <%= ENV.fetch('TASK_MANAGER_DATA_PATH', "data/tasks_#{ENV.fetch('TASK_MANAGER_ENV', 'development')}.json") %>

development:
  <<: *default

test:
  storage_path: <%= ENV.fetch('TASK_MANAGER_TEST_DATA_PATH', 'tmp/tasks_test.json') %>
```

### Key Fields

| Field | Purpose |
| --- | --- |
| `storage_path` | File path to the JSON data file. |

### Overriding the Storage Path

Use `TASK_MANAGER_DATA_PATH` for development data:

```bash
export TASK_MANAGER_DATA_PATH=/tmp/task_manager_dev.json
```

Use `TASK_MANAGER_TEST_DATA_PATH` for test runs:

```bash
export TASK_MANAGER_TEST_DATA_PATH=/tmp/task_manager_test.json
```

This is useful in CI or when running multiple instances of the CLI.

## Example Configurations

### Development (default)

```bash
export TASK_MANAGER_ENV=development
export TASK_MANAGER_DATA_PATH=data/tasks_development.json
```

### Test Environment

```bash
export TASK_MANAGER_ENV=test
export TASK_MANAGER_TEST_DATA_PATH=tmp/tasks_test.json
```

### Isolated Local Data for Experiments

```bash
export TASK_MANAGER_ENV=development
export TASK_MANAGER_DATA_PATH=tmp/sandbox_tasks.json
```

## .env Files

The project does not depend on `dotenv`, but you can still maintain a `.env` file for convenience.

Example `.env` file (see `.env.example`):

```
TASK_MANAGER_ENV=development
TASK_MANAGER_DATA_PATH=data/tasks_development.json
```

To use it locally, you can load it manually:

```bash
export $(cat .env | xargs)
```

## Storage Locations

All storage paths should be relative to the repository root or absolute paths. The scripts default to storing data files in `data/` or `tmp/` directories. We avoid `/tmp` in the default config to keep data in-repo for local work.

## Safety Notes

- Do not point `TASK_MANAGER_DATA_PATH` at a file you care about; the CLI will overwrite it.
- Always set `TASK_MANAGER_ENV=test` for test runs to avoid polluting development data.
- If you run multiple instances of the CLI concurrently, configure distinct paths to avoid race conditions.

## Frequently Asked Questions

### Why use environment variables instead of CLI flags?

Environment variables keep the CLI simple and allow consistent configuration across scripts, tests, and CI workflows.

### Can I use a database?

The project is intentionally file-based to avoid external dependencies. If you want a database-backed version, you can create a new storage adapter.

### Where should I store the production data file?

If you plan to run this in production-like scenarios, use a safe path outside the repo and ensure proper backups. For this repository, development and test data files are sufficient.

## Advanced: Multiple Environments

You can add additional environments to `config/task_manager.yml` as needed. Example:

```yaml
staging:
  storage_path: /var/lib/task_manager/staging.json
```

Then use:

```bash
TASK_MANAGER_ENV=staging ./scripts/run.sh list
```

## Advanced: JSON Format

The storage file contains a JSON array of tasks. Each task record includes:

- `id`
- `title`
- `description`
- `completed`
- `created_at`
- `updated_at`

Editing the file manually is possible but should be done carefully to avoid invalid JSON.

## Configuration Checklist

Before running the CLI or tests, ensure:

- `config/task_manager.yml` exists.
- `TASK_MANAGER_ENV` is set correctly.
- `TASK_MANAGER_DATA_PATH`/`TASK_MANAGER_TEST_DATA_PATH` point to writable paths.
- The storage path directory exists or can be created.

## Example: Running in a Separate Directory

If you want to store data files outside the repo:

```bash
export TASK_MANAGER_DATA_PATH="$HOME/.task_manager/tasks.json"
./scripts/run.sh list
```

This keeps your repo clean while preserving task data across runs.

## Example: Using a CI-Specific Path

CI environments can store data files in the workspace:

```bash
export TASK_MANAGER_ENV=test
export TASK_MANAGER_TEST_DATA_PATH="$GITHUB_WORKSPACE/tmp/ci_tasks.json"
./scripts/verify.sh
```

## Notes on YAML and ERB

The config file is processed through ERB before YAML parsing. This means you can embed Ruby expressions if needed. Keep it minimal to avoid confusion.

## Known Pitfalls

- Forgetting to set `TASK_MANAGER_ENV` when running tests will point to development data.
- Deleting the data file while the CLI is running will cause errors.
- Invalid JSON will cause storage errors.

## Summary

Configuration is intentionally straightforward. The combination of a YAML file and environment variables keeps the project easy to run locally while still allowing advanced setups.
