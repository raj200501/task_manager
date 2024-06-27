require 'active_record'
require_relative 'task'

class TaskManager
  def initialize
    ActiveRecord::Base.establish_connection(YAML.load_file('config/database.yml'))
  end

  def add_task(title, description)
    Task.create(title: title, description: description)
  end

  def list_tasks
    Task.all.each { |task| puts task }
  end

  def update_task(id, title: nil, description: nil, completed: nil)
    task = Task.find(id)
    task.update(title: title, description: description, completed: completed)
  end

  def delete_task(id)
    Task.find(id).destroy
  end
end
