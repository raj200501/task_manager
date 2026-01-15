# frozen_string_literal: true

require_relative 'test_helper'

class TaskTest < Minitest::Test
  def test_valid_task
    task = TaskManager::Task.new(id: 1, title: 'Test Task', description: 'Details')
    assert task.validate!
  end

  def test_missing_title_raises
    task = TaskManager::Task.new(id: 1, title: '', description: 'Missing title')
    error = assert_raises(TaskManager::ValidationError) { task.validate! }
    assert_match(/Title is required/, error.message)
  end

  def test_title_length_validation
    long_title = 'a' * 201
    task = TaskManager::Task.new(id: 1, title: long_title)
    error = assert_raises(TaskManager::ValidationError) { task.validate! }
    assert_match(/Title must be <=/, error.message)
  end

  def test_description_length_validation
    long_description = 'b' * 2001
    task = TaskManager::Task.new(id: 1, title: 'Title', description: long_description)
    error = assert_raises(TaskManager::ValidationError) { task.validate! }
    assert_match(/Description must be <=/, error.message)
  end

  def test_status_label
    task = TaskManager::Task.new(id: 1, title: 'Task', completed: true)
    assert_equal 'Completed', task.status_label
  end

  def test_pending_predicate
    task = TaskManager::Task.new(id: 1, title: 'Task', completed: false)
    assert task.pending?
    refute task.completed?
  end

  def test_to_h_round_trip
    task = TaskManager::Task.new(id: 1, title: 'Task', description: 'Desc')
    copy = TaskManager::Task.from_h(task.to_h)
    assert_equal task.title, copy.title
    assert_equal task.description, copy.description
  end
end
