#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

export TASK_MANAGER_ENV=development
export TASK_MANAGER_DATA_PATH="${TASK_MANAGER_DATA_PATH:-$ROOT_DIR/tmp/smoke_tasks.json}"

rm -f "$TASK_MANAGER_DATA_PATH"

ruby bin/task_manager add --title "Smoke Task" --description "Smoke description" | tee /tmp/smoke_add_output.txt
ruby bin/task_manager list | tee /tmp/smoke_list_output.txt
ruby bin/task_manager update --id 1 --completed true | tee /tmp/smoke_update_output.txt
ruby bin/task_manager delete --id 1 | tee /tmp/smoke_delete_output.txt

if ! grep -q "Created task" /tmp/smoke_add_output.txt; then
  echo "Smoke test failed: add output missing"
  exit 1
fi

if ! grep -q "Smoke Task" /tmp/smoke_list_output.txt; then
  echo "Smoke test failed: list output missing"
  exit 1
fi

if ! grep -q "Updated task" /tmp/smoke_update_output.txt; then
  echo "Smoke test failed: update output missing"
  exit 1
fi

if ! grep -q "Deleted task" /tmp/smoke_delete_output.txt; then
  echo "Smoke test failed: delete output missing"
  exit 1
fi

rm -f /tmp/smoke_add_output.txt /tmp/smoke_list_output.txt /tmp/smoke_update_output.txt /tmp/smoke_delete_output.txt
