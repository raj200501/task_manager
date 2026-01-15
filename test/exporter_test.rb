# frozen_string_literal: true

require_relative 'test_helper'
require 'json'
require 'csv'
require_relative '../lib/task_manager/exporter'

class ExporterTest < Minitest::Test
  def test_export_json
    repository.create(title: 'Export Task', description: 'Details')
    exporter = TaskManager::Exporter.new
    output_path = File.join(Dir.pwd, 'tmp', 'export_tasks.json')

    exporter.export(tasks: repository.list, format: 'json', path: output_path)

    data = JSON.parse(File.read(output_path))
    assert_equal 1, data.length
    assert_equal 'Export Task', data.first['title']
  ensure
    File.delete(output_path) if File.exist?(output_path)
  end

  def test_export_csv
    repository.create(title: 'CSV Task', description: 'Details')
    exporter = TaskManager::Exporter.new
    output_path = File.join(Dir.pwd, 'tmp', 'export_tasks.csv')

    exporter.export(tasks: repository.list, format: 'csv', path: output_path)

    rows = CSV.read(output_path, headers: true)
    assert_equal 1, rows.length
    assert_equal 'CSV Task', rows.first['title']
  ensure
    File.delete(output_path) if File.exist?(output_path)
  end

  def test_unsupported_format
    exporter = TaskManager::Exporter.new
    error = assert_raises(TaskManager::ExportError) do
      exporter.export(tasks: [], format: 'xml', path: 'tmp/bad.xml')
    end
    assert_match(/Unsupported export format/, error.message)
  end
end
