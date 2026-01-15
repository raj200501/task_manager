# frozen_string_literal: true

require_relative 'test_helper'
require 'json'
require 'csv'
require_relative '../lib/task_manager/importer'

class ImporterTest < Minitest::Test
  def test_import_json
    importer = TaskManager::Importer.new
    input_path = File.join(Dir.pwd, 'tmp', 'import_tasks.json')
    data = [
      { 'title' => 'Imported Task', 'description' => 'From JSON', 'completed' => false }
    ]
    FileUtils.mkdir_p(File.dirname(input_path))
    File.write(input_path, JSON.pretty_generate(data))

    imported = importer.import(path: input_path, repository: repository)

    assert_equal 1, imported.length
    assert_equal 'Imported Task', repository.list.first.title
  ensure
    File.delete(input_path) if File.exist?(input_path)
  end

  def test_import_csv
    importer = TaskManager::Importer.new
    input_path = File.join(Dir.pwd, 'tmp', 'import_tasks.csv')
    FileUtils.mkdir_p(File.dirname(input_path))
    CSV.open(input_path, 'w') do |csv|
      csv << %w[title description completed]
      csv << ['CSV Import', 'From CSV', 'true']
    end

    imported = importer.import(path: input_path, repository: repository)

    assert_equal 1, imported.length
    assert_equal 'CSV Import', repository.list.first.title
    assert repository.list.first.completed
  ensure
    File.delete(input_path) if File.exist?(input_path)
  end

  def test_missing_file
    importer = TaskManager::Importer.new
    error = assert_raises(TaskManager::ImportError) do
      importer.import(path: 'missing.json', repository: repository)
    end
    assert_match(/Import file not found/, error.message)
  end

  def test_invalid_entry
    importer = TaskManager::Importer.new
    input_path = File.join(Dir.pwd, 'tmp', 'import_invalid.json')
    FileUtils.mkdir_p(File.dirname(input_path))
    File.write(input_path, JSON.pretty_generate([{ 'title' => '' }]))

    error = assert_raises(TaskManager::ImportError) do
      importer.import(path: input_path, repository: repository)
    end
    assert_match(/Title is required/, error.message)
  ensure
    File.delete(input_path) if File.exist?(input_path)
  end
end
