# Task Manager

A command-line task manager built with Ruby. The app stores tasks in a local JSON file and exposes a CLI for adding, listing, updating, deleting, reporting, and importing/exporting tasks.

## Features

- Add new tasks with a title and optional description.
- List all tasks or filter by completion status.
- Update existing tasks (title, description, completion status).
- Delete tasks.
- View task statistics (total, pending, completed).
- Export tasks to JSON or CSV.
- Import tasks from JSON or CSV.
- Generate a detailed task report.

## Prerequisites

- Ruby 3.1+ (CI uses Ruby 3.2).

No external gems are required; the project uses Ruby's standard library only.

## Configuration

The CLI reads configuration from `config/task_manager.yml`. You can override the defaults with environment variables:

- `TASK_MANAGER_ENV` (default: `development`)
- `TASK_MANAGER_DATA_PATH` (overrides the JSON storage path for development)
- `TASK_MANAGER_TEST_DATA_PATH` (overrides the JSON storage path for tests)

An example `.env` file is available at `.env.example`.

## Usage

### Run the CLI directly

```bash
ruby bin/task_manager help
```

### Run the CLI via the helper script

`./scripts/run.sh` sets the working directory and forwards arguments to the CLI.

```bash
./scripts/run.sh add --title "Write documentation" --description "Draft the README"
./scripts/run.sh list
./scripts/run.sh update --id 1 --completed true
./scripts/run.sh delete --id 1
./scripts/run.sh stats
./scripts/run.sh report
```

### Import/Export Examples

```bash
./scripts/run.sh export --output tmp/tasks_export.json --format json
./scripts/run.sh export --output tmp/tasks_export.csv --format csv
./scripts/run.sh import --input tmp/tasks_export.json --format json
```

### CLI Reference

```bash
ruby bin/task_manager help
```

Commands:

- `add --title TITLE [--description DESCRIPTION]`
- `list [--filter all|pending|completed]`
- `update --id ID [--title TITLE] [--description DESCRIPTION] [--completed true|false]`
- `delete --id ID`
- `stats`
- `export --output PATH [--format json|csv]`
- `import --input PATH [--format json|csv]`
- `report`
- `help`

## Verified Quickstart (Executed)

The following commands were executed successfully in this environment:

```bash
ruby bin/task_manager help
./scripts/run.sh add --title "Quickstart Task" --description "Created from README"
./scripts/run.sh list
./scripts/run.sh stats
```

Expected output highlights:

- `Created task #...` after adding.
- The task appears in the list output.
- `Total: 1` appears in the stats output.

## Verification

A deterministic verification script is provided. It runs the test suite and executes a CLI smoke test.

```bash
./scripts/verify.sh
```

## Project Structure

```
bin/                 # CLI entrypoint
config/              # Configuration
lib/task_manager/    # Application logic
scripts/             # Run and verification scripts
test/                # Minitest unit/integration tests
```

## Troubleshooting

- **Missing configuration**: ensure `config/task_manager.yml` exists and the `TASK_MANAGER_ENV` value has a matching key.
- **File permissions**: ensure the storage path is writable.
- **Invalid JSON**: delete the data file and rerun the CLI.

## Additional Documentation

- [Configuration reference](docs/configuration.md)
- [CLI walkthrough](docs/cli_reference.md)
- [Architecture overview](docs/architecture.md)
- [Verification details](docs/verification.md)
- [Troubleshooting guide](docs/troubleshooting.md)
- [Contributing guide](docs/contributing.md)
- [Release checklist](docs/release.md)
- [Usage examples](docs/examples.md)
