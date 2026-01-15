# frozen_string_literal: true

require_relative 'test_helper'

class RepositoryTest < Minitest::Test
  def test_create_task
    task = repository.create(title: 'Repo Task', description: 'Details')
    assert_equal 1, task.id
    assert_equal 'Repo Task', task.title
  end

  def test_list_tasks
    repository.create(title: 'Task 1')
    repository.create(title: 'Task 2')

    tasks = repository.list

    assert_equal 2, tasks.size
    assert_equal ['Task 1', 'Task 2'], tasks.map(&:title)
  end

  def test_filters_pending_tasks
    repository.create(title: 'Pending Task')
    completed = repository.create(title: 'Completed Task')
    repository.update(completed.id, completed: true)

    tasks = repository.list(filter: :pending)

    assert_equal ['Pending Task'], tasks.map(&:title)
  end

  def test_filters_completed_tasks
    repository.create(title: 'Pending Task')
    completed = repository.create(title: 'Completed Task')
    repository.update(completed.id, completed: true)

    tasks = repository.list(filter: :completed)

    assert_equal ['Completed Task'], tasks.map(&:title)
  end

  def test_update_task
    task = repository.create(title: 'Original Task')

    updated = repository.update(task.id, title: 'Updated Task', completed: true)

    assert_equal 'Updated Task', updated.title
    assert updated.completed
  end

  def test_delete_task
    task = repository.create(title: 'Delete Task')

    repository.delete(task.id)

    assert_raises(TaskManager::NotFoundError) { repository.find(task.id) }
  end

  def test_stats
    repository.create(title: 'Task A')
    repository.create(title: 'Task B')
    repository.update(2, completed: true)

    stats = repository.stats

    assert_equal 2, stats[:total]
    assert_equal 1, stats[:completed]
    assert_equal 1, stats[:pending]
  end

  def test_sanitizes_title_and_description
    task = repository.create(title: "  Trim  title\n", description: " Desc\nline ")
    assert_equal 'Trim title', task.title
    assert_equal 'Desc line', task.description
  end
end
