# frozen_string_literal: true

require 'json'
require 'fileutils'
require_relative 'task'

module TaskManager
  class StorageError < StandardError; end

  class Storage
    def initialize(path:)
      @path = path
    end

    def load_tasks
      return [] unless File.exist?(@path)

      with_lock(File::LOCK_SH) do |file|
        data = JSON.parse(file.read)
        data.map { |task_data| Task.from_h(task_data) }
      end
    rescue JSON::ParserError => e
      raise StorageError, "Invalid data in #{@path}: #{e.message}"
    end

    def save_tasks(tasks)
      FileUtils.mkdir_p(File.dirname(@path))
      payload = JSON.pretty_generate(tasks.map(&:to_h))

      with_lock(File::LOCK_EX, mode: 'w') do |file|
        file.write(payload)
      end
    end

    def path
      @path
    end

    private

    def with_lock(lock_type, mode: 'r')
      File.open(@path, mode) do |file|
        file.flock(lock_type)
        yield file
      ensure
        file.flock(File::LOCK_UN)
      end
    end
  end
end
