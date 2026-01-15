# CLI Reference

This document provides an exhaustive reference for the Task Manager CLI. Every command includes examples and expected output patterns. The CLI is designed to be deterministic and human-readable.

## Global Usage

```bash
ruby bin/task_manager help
```

You can also use the helper script:

```bash
./scripts/run.sh help
```

### Environment Variables

| Variable | Purpose | Default |
| --- | --- | --- |
| `TASK_MANAGER_ENV` | Environment name | `development` |
| `TASK_MANAGER_DATA_PATH` | Data path for development | `data/tasks_development.json` |
| `TASK_MANAGER_TEST_DATA_PATH` | Data path for tests | `tmp/tasks_test.json` |

## Command: `add`

### Description

Creates a new task with a required title and optional description.

### Usage

```bash
ruby bin/task_manager add --title "Plan sprint" --description "Prepare task list"
```

### Output

```
Created task #1: Plan sprint
```

### Notes

- Titles are required and must be 200 characters or fewer.
- Descriptions are optional but capped at 2000 characters.

### Example Session

```bash
./scripts/run.sh add --title "Write tests" --description "Add CLI coverage"
./scripts/run.sh list
```

Expected output includes the new task in the list.

## Command: `list`

### Description

Lists all tasks in a table format.

### Usage

```bash
ruby bin/task_manager list
```

### Output

```
ID | Title       | Description       | Status  | Created_At
---+-------------+-------------------+---------+-------------------
1  | Write tests | Add CLI coverage  | Pending | 2024-01-15 10:30:00
```

### Filtering

Use `--filter` to limit the output:

```bash
ruby bin/task_manager list --filter pending
ruby bin/task_manager list --filter completed
```

Filters supported:

- `all`
- `pending`
- `completed`

### Notes

The list output is ordered by task ID. This makes output deterministic and helps with scripting.

## Command: `update`

### Description

Updates a task by ID. You can modify the title, description, or completion status.

### Usage

```bash
ruby bin/task_manager update --id 1 --title "Write more tests"
```

### Output

```
Updated task #1
```

### Completing a Task

```bash
ruby bin/task_manager update --id 1 --completed true
```

### Notes

- The command fails if the task does not exist.
- The completion flag expects `true` or `false`.

## Command: `delete`

### Description

Deletes a task by ID.

### Usage

```bash
ruby bin/task_manager delete --id 1
```

### Output

```
Deleted task #1
```

### Notes

Deletion is permanent. For safety, ensure you are pointing at the correct storage path.

## Command: `stats`

### Description

Shows basic task statistics.

### Usage

```bash
ruby bin/task_manager stats
```

### Output

```
Total: 3
Pending: 2
Completed: 1
```

### Notes

The statistics are calculated from the stored JSON file.

## Command: `export`

### Description

Exports tasks to a JSON or CSV file.

### Usage

```bash
ruby bin/task_manager export --output tmp/tasks.json --format json
ruby bin/task_manager export --output tmp/tasks.csv --format csv
```

### Output

```
Exported 3 tasks to tmp/tasks.json
```

### Notes

- The `--format` flag defaults to `json`.
- Exported JSON uses the same schema as the internal storage file.

## Command: `import`

### Description

Imports tasks from a JSON or CSV file. Imported tasks are assigned new IDs.

### Usage

```bash
ruby bin/task_manager import --input tmp/tasks.json --format json
ruby bin/task_manager import --input tmp/tasks.csv --format csv
```

### Output

```
Imported 3 tasks from tmp/tasks.json
```

### Notes

- JSON imports expect an array of objects with `title` and optional `description`.
- CSV imports expect headers: `title`, `description`, `completed`.

## Command: `report`

### Description

Prints a detailed report with counts and recent tasks.

### Usage

```bash
ruby bin/task_manager report
```

### Output

```
Task Report
Total: 3
Pending: 2
Completed: 1

Recent tasks:
- [Pending] #3 Write tests (2024-01-15 10:30:00)
- [Completed] #2 Fix bug (2024-01-15 10:15:00)
```

## Command: `help`

### Description

Prints the help message with available commands.

### Usage

```bash
ruby bin/task_manager help
```

## Exit Codes

| Code | Meaning |
| --- | --- |
| `0` | Success |
| `1` | Command error or validation failure |

Examples of non-zero exit codes:

- Missing required arguments.
- Task ID not found.
- Validation errors (missing title).
- Import/export errors.

## Example Workflows

### Basic Workflow

```bash
./scripts/run.sh add --title "Plan sprint" --description "Backlog tasks"
./scripts/run.sh list
./scripts/run.sh update --id 1 --completed true
./scripts/run.sh stats
```

### Creating Multiple Tasks

```bash
./scripts/run.sh add --title "Task A"
./scripts/run.sh add --title "Task B"
./scripts/run.sh add --title "Task C" --description "Optional details"
./scripts/run.sh list
```

### Listing Pending Tasks

```bash
./scripts/run.sh list --filter pending
```

### Exporting for Backup

```bash
./scripts/run.sh export --output tmp/tasks_backup.json --format json
```

### Importing from Backup

```bash
./scripts/run.sh import --input tmp/tasks_backup.json --format json
```

### Cleanup Workflow

```bash
./scripts/run.sh delete --id 1
./scripts/run.sh delete --id 2
```

## Tips for Automation

- Always set `TASK_MANAGER_DATA_PATH` when automating the CLI to avoid modifying developer data.
- Use `stats` to quickly verify task counts after automation steps.
- Prefer `list --filter pending` when checking outstanding tasks.

## Output Parsing Example

If you want to parse the output, you can use basic shell tools:

```bash
./scripts/run.sh list | awk -F'|' 'NR>2 {print $2}'
```

This extracts the title column for each task.

## Command Comparison Table

| Command | Required Flags | Optional Flags |
| --- | --- | --- |
| `add` | `--title` | `--description` |
| `list` | none | `--filter` |
| `update` | `--id` | `--title`, `--description`, `--completed` |
| `delete` | `--id` | none |
| `stats` | none | none |
| `export` | `--output` | `--format` |
| `import` | `--input` | `--format` |
| `report` | none | none |
| `help` | none | none |

## Additional Examples

### Update Title and Description

```bash
./scripts/run.sh update --id 3 --title "Refactor code" --description "Improve structure"
```

### Mark as Pending

```bash
./scripts/run.sh update --id 3 --completed false
```

### Use a Custom Data Path

```bash
TASK_MANAGER_DATA_PATH=tmp/cli_demo.json ./scripts/run.sh add --title "Custom Data"
```

### List Completed Tasks

```bash
./scripts/run.sh list --filter completed
```

### Verify After Deletion

```bash
./scripts/run.sh delete --id 3
./scripts/run.sh stats
```

## Example Output Snippets

### Stats

```
Total: 5
Pending: 4
Completed: 1
```

### List

```
ID | Title           | Description       | Status   | Created_At
---+-----------------+-------------------+----------+-------------------
1  | Add docs        | Write CLI docs    | Pending  | 2024-01-15 10:00:00
2  | Add tests       | Minitest coverage | Pending  | 2024-01-15 10:05:00
3  | Fix bug         | Resolve issue     | Completed| 2024-01-15 10:10:00
```

## Troubleshooting Output

If you see a message like:

```
Error: Title is required.
```

It means the `--title` flag was missing or empty. Re-run the command with a valid title.

If you see:

```
Error: Task 99 not found.
```

It means the specified ID does not exist in the current data file.

If you see:

```
Error: Unsupported export format: xml
```

It means the format must be `json` or `csv`.

## Summary

The CLI is intentionally compact. The commands listed above represent the canonical interface and are covered by automated tests and the smoke verification script.
