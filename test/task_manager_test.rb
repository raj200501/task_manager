# frozen_string_literal: true

require_relative 'test_helper'
require 'json'

class TaskManagerTest < Minitest::Test
  def test_add_task
    task = task_manager.add_task('New Task', 'Task description')
    assert_equal 'New Task', task.title
  end

  def test_list_tasks
    task_manager.add_task('Task 1', 'First task')
    task_manager.add_task('Task 2', 'Second task')

    tasks = task_manager.list_tasks

    assert_equal 2, tasks.size
    assert_equal ['Task 1', 'Task 2'], tasks.map(&:title)
  end

  def test_update_task
    task = task_manager.add_task('Task to Update', 'Description')
    task_manager.update_task(task.id, title: 'Updated Task')

    updated = task_manager.repository.find(task.id)
    assert_equal 'Updated Task', updated.title
  end

  def test_delete_task
    task = task_manager.add_task('Task to Delete', 'Description')
    task_manager.delete_task(task.id)

    assert_raises(TaskManager::NotFoundError) { task_manager.repository.find(task.id) }
  end

  def test_stats
    task_manager.add_task('Task A', 'One')
    task = task_manager.add_task('Task B', 'Two')
    task_manager.update_task(task.id, completed: true)

    stats = task_manager.stats
    assert_equal 2, stats[:total]
    assert_equal 1, stats[:completed]
    assert_equal 1, stats[:pending]
  end

  def test_export_tasks
    task_manager.add_task('Exported Task', 'Data')
    output_path = File.join(Dir.pwd, 'tmp', 'manager_export.json')

    count = task_manager.export_tasks(format: 'json', path: output_path)

    assert_equal 1, count
    data = JSON.parse(File.read(output_path))
    assert_equal 'Exported Task', data.first['title']
  ensure
    File.delete(output_path) if File.exist?(output_path)
  end

  def test_report
    task_manager.add_task('Report Task', 'Report data')
    report = task_manager.report

    assert_includes report.join("\n"), 'Task Report'
    assert_includes report.join("\n"), 'Report Task'
  end
end
