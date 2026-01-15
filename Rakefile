# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.warning = false
end

task default: :test

namespace :storage do
  desc 'Remove the development data file'
  task :reset do
    require_relative 'lib/task_manager/configuration'
    config = TaskManager::Configuration.load
    path = config.storage_path
    File.delete(path) if File.exist?(path)
  end
end
