# Architecture Overview

This document explains how the Task Manager application is structured, how data flows through the system, and how the CLI interacts with the storage layer.

## High-Level Components

| Component | Responsibility | Key Files |
| --- | --- | --- |
| CLI | Parse user input and invoke domain logic | `lib/task_manager/cli.rb`, `bin/task_manager` |
| Task Manager | Orchestrate repository calls | `lib/task_manager/task_manager.rb` |
| Repository | CRUD operations for tasks | `lib/task_manager/repository.rb` |
| Storage | Persist tasks to JSON | `lib/task_manager/storage.rb`, `config/task_manager.yml` |
| Formatter | Human-readable output tables | `lib/task_manager/formatter.rb` |
| Model | Data validations and formatting | `lib/task_manager/task.rb` |
| Exporter | Write tasks to JSON/CSV | `lib/task_manager/exporter.rb` |
| Importer | Load tasks from JSON/CSV | `lib/task_manager/importer.rb` |
| Report | Build detailed task summaries | `lib/task_manager/report.rb` |

## Data Flow (Command Execution)

When you run a command like `task_manager add --title "Fix bug"`:

1. **CLI** parses the command.
2. **CLI** loads configuration and instantiates the Task Manager.
3. **Task Manager** delegates to the **Repository**.
4. **Repository** loads tasks from **Storage**.
5. **Repository** creates a new **Task** and validates it.
6. **Storage** writes the updated task list back to JSON.
7. **Formatter** prints a confirmation message.

## Sequence Diagram (Add Command)

```
User -> CLI: task_manager add --title "Fix bug"
CLI -> Configuration: load
CLI -> TaskManager: add_task
TaskManager -> Repository: create
Repository -> Storage: load_tasks
Repository -> Task: validate!
Repository -> Storage: save_tasks
Repository -> TaskManager: Task
TaskManager -> CLI: Task
CLI -> Formatter: print_message
Formatter -> User: "Created task #1: Fix bug"
```

## Domain Model

### Task

A task represents a unit of work. The model has the following fields:

| Field | Type | Description |
| --- | --- | --- |
| `id` | Integer | Primary identifier |
| `title` | String | Required, max 200 chars |
| `description` | String | Optional, max 2000 chars |
| `completed` | Boolean | Defaults to `false` |
| `created_at` | String (ISO-8601) | Timestamp |
| `updated_at` | String (ISO-8601) | Timestamp |

The model enforces the title validation and exposes a status label for display.

### Repository

The repository layer abstracts storage behavior to keep the CLI and task manager class clean. It provides:

- `create` with strict validation.
- `list` with filters (`:all`, `:pending`, `:completed`).
- `find` for explicit lookup.
- `update` for partial updates with error handling.
- `delete` for cleanup.
- `stats` to summarize counts.

The repository ensures ordering by `id` to make CLI output deterministic, which is crucial for integration tests.

### Storage

Storage is file-based and uses JSON. The design goals are:

- **Human-readable data** for easy debugging.
- **Deterministic ordering** through repository sorting.
- **No external dependencies** beyond Ruby's standard library.

The JSON file is an array of task objects. Example:

```json
[
  {
    "id": 1,
    "title": "Fix bug",
    "description": "Update README",
    "completed": false,
    "created_at": "2024-01-15T10:00:00Z",
    "updated_at": "2024-01-15T10:00:00Z"
  }
]
```

### Exporter

The exporter writes tasks to JSON or CSV. It uses the same schema as storage for JSON, and a simple header row for CSV.

### Importer

The importer reads tasks from JSON or CSV. It normalizes input fields, validates entries with the input validator, and creates new tasks via the repository, assigning new IDs.

### Report

The report module builds a multi-line summary containing totals and a list of recent tasks. The CLI `report` command uses this output to present a quick overview.

## Configuration and Environments

The configuration system is minimal. It reads `config/task_manager.yml` using ERB so that environment variables can be interpolated.

### Environment Selection

The environment is resolved in this order:

1. `TASK_MANAGER_ENV`
2. `APP_ENV`
3. default `development`

### Storage Path Resolution

The configuration file uses env vars to allow overrides:

- `TASK_MANAGER_DATA_PATH` affects the development storage path.
- `TASK_MANAGER_TEST_DATA_PATH` affects the test storage path.

This makes it easy to isolate environments without touching code.

## Output Formatting

The formatter prints output in a table for readability. It calculates column widths dynamically based on task contents. The key design goal is deterministic output so tests can assert on the output while still keeping it human-friendly.

### Example Table

```
ID | Title         | Description      | Status   | Created_At
---+---------------+------------------+----------+-------------------
1  | Fix bug       | Update README    | Pending  | 2024-01-15 10:00:00
2  | Release 1.0   | Tag and publish  | Completed| 2024-01-15 11:00:00
```

## Error Handling

The CLI catches repository and validation errors so the user receives clear error messages instead of stack traces. Unexpected errors are intentionally surfaced to simplify debugging.

## Testing Strategy

Testing is split into:

1. **Unit tests**: verify individual components like repository, formatter, configuration, storage, importer, and exporter.
2. **Integration tests**: run CLI workflows via the smoke test in `scripts/smoke_test.sh`.

The test suite uses a dedicated JSON file under `tmp/` to avoid polluting development data. The test data file is deleted before each test.

## Extensibility

The current architecture keeps classes small and readable. Here are common extension points:

- Add additional commands in the CLI.
- Add new task fields (due dates, tags, priorities).
- Replace or wrap the formatter to support JSON output for automation.
- Introduce a `TaskService` layer for complex business rules.

## Design Principles

- **Deterministic output** for easy testing and reproducibility.
- **Minimal dependencies** to keep the project lightweight.
- **Explicit configuration** so behavior is predictable across environments.
- **Small classes** with single responsibilities.

## FAQ for Maintainers

### Why not use a database?

The project is designed to be lightweight and self-contained. A JSON file is sufficient for small task lists and avoids external dependencies.

### Why does the CLI create directories automatically?

Because many CLI users expect commands to “just work.” The CLI ensures the storage directory exists before writing.

### Where should new commands go?

Add a new handler method in `CLI`, update the help text, and add a new method in `TaskManager` or `Repository` as needed. Ensure you add unit tests and update the README with new usage examples.

## Appendix: Storage Notes

- Storage files are plain JSON and can be edited manually for recovery.
- If the JSON is corrupted, delete the file and recreate tasks via the CLI.
- Avoid editing the file while the CLI is running.

## Maintainer Checklist (Architectural)

When adding features, ensure:

- The CLI command has a corresponding help entry.
- The TaskManager class has a method that orchestrates the feature.
- The repository abstracts storage operations.
- Formatter output remains deterministic.
- Tests cover the new behavior.
- README and docs are updated.

## Glossary

- **CLI**: Command-Line Interface, the primary way to interact with the app.
- **Repository**: A layer that encapsulates storage access.
- **Storage**: The JSON file where tasks are persisted.
- **Environment**: A named configuration profile (development, test).

## End Notes

The architecture is intentionally simple. This makes the project approachable for maintainers and contributors while still being robust enough for reliable use.
