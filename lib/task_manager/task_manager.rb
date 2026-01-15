# frozen_string_literal: true

require_relative 'configuration'
require_relative 'exporter'
require_relative 'importer'
require_relative 'report'
require_relative 'repository'
require_relative 'storage'
require_relative 'task'

module TaskManager
  class TaskManager
    def initialize(config: Configuration.load)
      @config = config
      @storage = Storage.new(path: config.storage_path)
      @repository = Repository.new(storage: @storage)
    end

    def add_task(title, description)
      repository.create(title: title, description: description)
    end

    def list_tasks(filter: :all)
      repository.list(filter: filter)
    end

    def update_task(id, title: nil, description: nil, completed: nil)
      repository.update(id, title: title, description: description, completed: completed)
    end

    def delete_task(id)
      repository.delete(id)
    end

    def stats
      repository.stats
    end

    def export_tasks(format:, path:)
      tasks = repository.list(filter: :all)
      Exporter.new.export(tasks: tasks, format: format, path: path)
      tasks.count
    end

    def import_tasks(path:, format: nil)
      Importer.new.import(path: path, repository: repository, format: format)
    end

    def report
      Report.new(tasks: repository.list(filter: :all)).generate
    end

    def repository
      @repository
    end
  end
end
