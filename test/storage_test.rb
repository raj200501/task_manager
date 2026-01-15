# frozen_string_literal: true

require_relative 'test_helper'

class StorageTest < Minitest::Test
  def test_saves_and_loads_tasks
    task = TaskManager::Task.new(id: 1, title: 'Stored Task', description: 'Details')

    storage.save_tasks([task])
    tasks = storage.load_tasks

    assert_equal 1, tasks.length
    assert_equal 'Stored Task', tasks.first.title
  end

  def test_invalid_json_raises
    FileUtils.mkdir_p(File.dirname(test_data_path))
    File.write(test_data_path, '{invalid json')

    error = assert_raises(TaskManager::StorageError) { storage.load_tasks }
    assert_match(/Invalid data/, error.message)
  end
end
