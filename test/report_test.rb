# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/task_manager/report'

class ReportTest < Minitest::Test
  def test_report_includes_counts
    repository.create(title: 'Report Task')
    report = TaskManager::Report.new(tasks: repository.list).generate

    assert_includes report.join("\n"), 'Task Report'
    assert_includes report.join("\n"), 'Total: 1'
  end

  def test_report_handles_no_tasks
    report = TaskManager::Report.new(tasks: []).generate
    assert_includes report.join("\n"), 'No tasks available.'
  end
end
