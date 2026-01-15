# frozen_string_literal: true

require_relative 'test_helper'
require 'stringio'
require 'json'
require 'csv'
require_relative '../lib/task_manager/cli'

class CLITest < Minitest::Test
  def test_help
    output = StringIO.new
    cli = TaskManager::CLI.new(argv: [], output: output)

    cli.run

    assert_includes output.string, 'Task Manager Commands'
  end

  def test_add_command
    output = StringIO.new
    cli = TaskManager::CLI.new(argv: ['add', '--title', 'CLI Task', '--description', 'CLI Desc'], output: output)

    cli.run

    assert_includes output.string, 'Created task'
    tasks = repository.list
    assert_equal 1, tasks.length
    assert_equal 'CLI Task', tasks.first.title
  end

  def test_list_command
    repository.create(title: 'List task', description: 'List desc')
    output = StringIO.new
    cli = TaskManager::CLI.new(argv: ['list'], output: output)

    cli.run

    assert_includes output.string, 'List task'
  end

  def test_update_command
    task = repository.create(title: 'Update task', description: 'Before')
    output = StringIO.new
    cli = TaskManager::CLI.new(argv: ['update', '--id', task.id.to_s, '--title', 'Updated'], output: output)

    cli.run

    assert_includes output.string, 'Updated task'
    assert_equal 'Updated', repository.find(task.id).title
  end

  def test_delete_command
    task = repository.create(title: 'Delete task', description: 'Bye')
    output = StringIO.new
    cli = TaskManager::CLI.new(argv: ['delete', '--id', task.id.to_s], output: output)

    cli.run

    assert_includes output.string, 'Deleted task'
    assert_raises(TaskManager::NotFoundError) { repository.find(task.id) }
  end

  def test_stats_command
    repository.create(title: 'Stats task')
    output = StringIO.new
    cli = TaskManager::CLI.new(argv: ['stats'], output: output)

    cli.run

    assert_includes output.string, 'Total: 1'
  end

  def test_export_command
    repository.create(title: 'Export task')
    output_path = File.join(Dir.pwd, 'tmp', 'cli_export.json')
    output = StringIO.new
    cli = TaskManager::CLI.new(argv: ['export', '--output', output_path, '--format', 'json'], output: output)

    cli.run

    assert_includes output.string, 'Exported 1 tasks'
    data = JSON.parse(File.read(output_path))
    assert_equal 'Export task', data.first['title']
  ensure
    File.delete(output_path) if File.exist?(output_path)
  end

  def test_import_command
    input_path = File.join(Dir.pwd, 'tmp', 'cli_import.json')
    FileUtils.mkdir_p(File.dirname(input_path))
    File.write(input_path, JSON.pretty_generate([{ 'title' => 'Imported CLI Task', 'description' => 'From file' }]))
    output = StringIO.new
    cli = TaskManager::CLI.new(argv: ['import', '--input', input_path, '--format', 'json'], output: output)

    cli.run

    assert_includes output.string, 'Imported 1 tasks'
    assert_equal 'Imported CLI Task', repository.list.first.title
  ensure
    File.delete(input_path) if File.exist?(input_path)
  end

  def test_report_command
    repository.create(title: 'Report task')
    output = StringIO.new
    cli = TaskManager::CLI.new(argv: ['report'], output: output)

    cli.run

    assert_includes output.string, 'Task Report'
    assert_includes output.string, 'Report task'
  end
end
