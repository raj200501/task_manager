# frozen_string_literal: true

require_relative 'test_helper'
require 'json'
require_relative '../lib/task_manager/exporter'
require_relative '../lib/task_manager/importer'

class EdgeCaseTest < Minitest::Test
  def test_update_completed_false
    task = repository.create(title: 'Incomplete task')
    repository.update(task.id, completed: true)
    repository.update(task.id, completed: false)

    assert_equal false, repository.find(task.id).completed
  end

  def test_import_infers_format_from_extension
    importer = TaskManager::Importer.new
    input_path = File.join(Dir.pwd, 'tmp', 'infer_import.json')
    FileUtils.mkdir_p(File.dirname(input_path))
    File.write(input_path, JSON.pretty_generate([{ 'title' => 'Infer Task' }]))

    imported = importer.import(path: input_path, repository: repository)

    assert_equal 1, imported.length
    assert_equal 'Infer Task', repository.list.first.title
  ensure
    File.delete(input_path) if File.exist?(input_path)
  end

  def test_exporter_normalizes_format
    exporter = TaskManager::Exporter.new
    output_path = File.join(Dir.pwd, 'tmp', 'normalize_export.json')

    exporter.export(tasks: [], format: ' JSON ', path: output_path)

    assert File.exist?(output_path)
  ensure
    File.delete(output_path) if File.exist?(output_path)
  end
end
