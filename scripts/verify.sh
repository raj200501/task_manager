#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

export TASK_MANAGER_ENV=test
export TASK_MANAGER_TEST_DATA_PATH="${TASK_MANAGER_TEST_DATA_PATH:-$ROOT_DIR/tmp/tasks_test.json}"

rm -f "$TASK_MANAGER_TEST_DATA_PATH"

ruby -S rake test

./scripts/smoke_test.sh
