# frozen_string_literal: true

require_relative 'sanitizer'
require_relative 'storage'

module TaskManager
  class NotFoundError < StandardError; end

  class Repository
    def initialize(storage:)
      @storage = storage
      @sanitizer = Sanitizer.new
    end

    def create(title:, description: nil)
      tasks = storage.load_tasks
      new_id = next_id(tasks)
      now = Time.now
      task = Task.new(
        id: new_id,
        title: sanitizer.normalize_title(title),
        description: sanitizer.normalize_description(description),
        completed: false,
        created_at: now,
        updated_at: now
      )
      task.validate!
      tasks << task
      storage.save_tasks(tasks)
      task
    end

    def list(filter: :all)
      tasks = storage.load_tasks
      filtered = case filter
                 when :pending
                   tasks.select(&:pending?)
                 when :completed
                   tasks.select(&:completed?)
                 else
                   tasks
                 end
      filtered.sort_by(&:id)
    end

    def find(id)
      task = storage.load_tasks.find { |candidate| candidate.id == id }
      raise NotFoundError, "Task #{id} not found." unless task

      task
    end

    def update(id, title: nil, description: nil, completed: nil)
      tasks = storage.load_tasks
      task = tasks.find { |candidate| candidate.id == id }
      raise NotFoundError, "Task #{id} not found." unless task

      task.title = sanitizer.normalize_title(title) if title
      task.description = sanitizer.normalize_description(description) if description
      task.completed = completed unless completed.nil?
      task.updated_at = Time.now
      task.validate!

      storage.save_tasks(tasks)
      task
    end

    def delete(id)
      tasks = storage.load_tasks
      removed = tasks.reject! { |candidate| candidate.id == id }
      raise NotFoundError, "Task #{id} not found." unless removed

      storage.save_tasks(tasks)
      true
    end

    def stats
      tasks = storage.load_tasks
      {
        total: tasks.count,
        pending: tasks.count(&:pending?),
        completed: tasks.count(&:completed?)
      }
    end

    private

    attr_reader :storage, :sanitizer

    def next_id(tasks)
      tasks.map(&:id).max.to_i + 1
    end
  end
end
