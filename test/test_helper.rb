# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'
require_relative '../lib/task_manager/configuration'
require_relative '../lib/task_manager/task_manager'
require_relative '../lib/task_manager/storage'
require_relative '../lib/task_manager/repository'
require_relative '../lib/task_manager/formatter'
require_relative '../lib/task_manager/task'

ENV['TASK_MANAGER_ENV'] = 'test'
ENV['TASK_MANAGER_TEST_DATA_PATH'] ||= File.join(Dir.pwd, 'tmp', 'tasks_test.json')

module TestHelpers
  def setup_test_storage
    FileUtils.mkdir_p(File.dirname(test_data_path))
    File.delete(test_data_path) if File.exist?(test_data_path)
  end

  def test_data_path
    ENV.fetch('TASK_MANAGER_TEST_DATA_PATH')
  end

  def storage
    TaskManager::Storage.new(path: test_data_path)
  end

  def repository
    TaskManager::Repository.new(storage: storage)
  end

  def task_manager
    TaskManager::TaskManager.new(config: TaskManager::Configuration.load(env: 'test'))
  end
end

class Minitest::Test
  include TestHelpers

  def setup
    setup_test_storage
  end
end
