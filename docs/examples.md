# Usage Examples

This document provides extended examples showing how to use Task Manager in different scenarios.

## Example 1: Daily Planning

```bash
./scripts/run.sh add --title "Review calendar" --description "Check meetings for today"
./scripts/run.sh add --title "Plan sprint tasks" --description "Identify top priorities"
./scripts/run.sh add --title "Write status update" --description "Send update to the team"
./scripts/run.sh list
./scripts/run.sh stats
```

Expected outcome:

- The list shows three tasks.
- Stats reports `Total: 3`, `Pending: 3`.

## Example 2: Completing Tasks

```bash
./scripts/run.sh add --title "Fix bug #123" --description "Resolve login issue"
./scripts/run.sh add --title "Write tests" --description "Cover bug fix"
./scripts/run.sh list
./scripts/run.sh update --id 1 --completed true
./scripts/run.sh list --filter completed
./scripts/run.sh list --filter pending
./scripts/run.sh stats
```

Expected outcome:

- The completed list contains the first task.
- The pending list contains the second task.

## Example 3: Updating Task Details

```bash
./scripts/run.sh add --title "Draft release notes" --description "Initial outline"
./scripts/run.sh update --id 1 --title "Draft release notes v2" --description "Add fixed bugs section"
./scripts/run.sh list
```

Expected outcome:

- The task shows the updated title and description.

## Example 4: Cleaning Up Tasks

```bash
./scripts/run.sh add --title "Clean up old tasks"
./scripts/run.sh list
./scripts/run.sh delete --id 1
./scripts/run.sh list
```

Expected outcome:

- The second list shows no tasks.

## Example 5: Isolated Data for Experimentation

```bash
TASK_MANAGER_DATA_PATH=tmp/experiment_tasks.json ./scripts/run.sh add --title "Experiment task"
TASK_MANAGER_DATA_PATH=tmp/experiment_tasks.json ./scripts/run.sh list
```

Expected outcome:

- The task only appears in the experiment data file.

## Example 6: Checking Stats

```bash
./scripts/run.sh add --title "Task A"
./scripts/run.sh add --title "Task B"
./scripts/run.sh add --title "Task C"
./scripts/run.sh update --id 2 --completed true
./scripts/run.sh stats
```

Expected outcome:

- Total: 3
- Pending: 2
- Completed: 1

## Example 7: Using a Separate Environment

```bash
TASK_MANAGER_ENV=development ./scripts/run.sh add --title "Dev task"
TASK_MANAGER_ENV=development ./scripts/run.sh list
```

Expected outcome:

- Tasks are stored in `data/tasks_development.json` unless overridden.

## Example 8: Running in CI or Automation

```bash
export TASK_MANAGER_ENV=test
export TASK_MANAGER_TEST_DATA_PATH=tmp/ci_tasks.json
rake test
```

Expected outcome:

- Tests run using the CI data file.

## Example 9: Resetting the Data File

```bash
rake storage:reset
./scripts/run.sh list
```

Expected outcome:

- The list reports no tasks.

## Example 10: Multi-Step Workflow

```bash
./scripts/run.sh add --title "Design API" --description "Outline endpoints"
./scripts/run.sh add --title "Implement API" --description "Build routes"
./scripts/run.sh add --title "Write tests" --description "Cover endpoints"
./scripts/run.sh update --id 2 --completed true
./scripts/run.sh stats
./scripts/run.sh list --filter pending
```

Expected outcome:

- Stats show 3 total, 2 pending, 1 completed.
- Pending list shows the tasks not yet completed.

## Example 11: Batch Creation via Shell

```bash
for title in "Task 1" "Task 2" "Task 3"; do
  ./scripts/run.sh add --title "$title"
done
./scripts/run.sh list
```

Expected outcome:

- All three tasks appear in the list.

## Example 12: Validating Input

```bash
./scripts/run.sh add --title "" || echo "Failed as expected"
```

Expected outcome:

- CLI exits with a validation error.

## Example 13: Using the CLI Without Scripts

```bash
ruby bin/task_manager add --title "Manual run"
```

Expected outcome:

- Task is created in the development data file.

## Example 14: Listing Completed Tasks Only

```bash
./scripts/run.sh add --title "Task 1"
./scripts/run.sh add --title "Task 2"
./scripts/run.sh update --id 2 --completed true
./scripts/run.sh list --filter completed
```

Expected outcome:

- Only task 2 appears in the list.

## Example 15: Confirming Deletion

```bash
./scripts/run.sh add --title "Temp Task"
./scripts/run.sh delete --id 1
./scripts/run.sh stats
```

Expected outcome:

- Stats show total 0 after deletion.

## Example 16: Exporting Tasks

```bash
./scripts/run.sh add --title "Export Task" --description "Prepare export"
./scripts/run.sh export --output tmp/tasks_export.json --format json
./scripts/run.sh export --output tmp/tasks_export.csv --format csv
```

Expected outcome:

- Export files are created with task data.

## Example 17: Importing Tasks

```bash
./scripts/run.sh import --input tmp/tasks_export.json --format json
./scripts/run.sh list
```

Expected outcome:

- Imported tasks appear in the list with new IDs.

## Example 18: Generating a Report

```bash
./scripts/run.sh report
```

Expected outcome:

- The report shows totals and recent tasks.

## Example 19: Error Handling for Missing ID

```bash
./scripts/run.sh update --id 999 --completed true || echo "Update failed as expected"
```

Expected outcome:

- CLI prints an error and exits with non-zero status.

## Example 20: Using Stats for Automation

```bash
./scripts/run.sh add --title "Automation Task"
./scripts/run.sh stats | grep "Pending: 1"
```

Expected outcome:

- The grep command succeeds.

## Example 21: Combining Filters and Stats

```bash
./scripts/run.sh add --title "Task A"
./scripts/run.sh add --title "Task B"
./scripts/run.sh update --id 1 --completed true
./scripts/run.sh list --filter completed
./scripts/run.sh stats
```

Expected outcome:

- Completed list shows Task A.
- Stats shows 2 total, 1 completed.

## Example 22: Quick Reset and Rebuild

```bash
rake storage:reset
./scripts/run.sh add --title "Fresh task"
./scripts/run.sh list
```

Expected outcome:

- Only the fresh task appears in the list.

## Example 23: Multi-Data-File Runs

```bash
TASK_MANAGER_DATA_PATH=tmp/data_one.json ./scripts/run.sh add --title "Data One Task"
TASK_MANAGER_DATA_PATH=tmp/data_two.json ./scripts/run.sh add --title "Data Two Task"
TASK_MANAGER_DATA_PATH=tmp/data_one.json ./scripts/run.sh list
TASK_MANAGER_DATA_PATH=tmp/data_two.json ./scripts/run.sh list
```

Expected outcome:

- Each data file contains its own tasks.

## Example 24: Capturing Output for Reports

```bash
./scripts/run.sh list > tmp/task_report.txt
cat tmp/task_report.txt
```

Expected outcome:

- The report contains the tasks table.

## Example 25: Basic Scripting for Nightly Cleanup

```bash
./scripts/run.sh list --filter completed | grep -q "Completed" && echo "Completed tasks exist"
```

Expected outcome:

- The command prints the completion message if tasks are completed.

## Example 26: Debugging With Verbose Output

To troubleshoot, run commands directly and inspect output:

```bash
ruby bin/task_manager list
```

Expected outcome:

- The same list output appears.

## Example 27: Running Tests with a Custom Data Path

```bash
export TASK_MANAGER_ENV=test
export TASK_MANAGER_TEST_DATA_PATH=tmp/custom_test.json
rake test
```

Expected outcome:

- Tests pass and use the custom data path.

## Summary

These examples cover common workflows and automation scenarios. Use them as a reference when building scripts or training new team members.
