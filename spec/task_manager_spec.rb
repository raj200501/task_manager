require 'rspec'
require_relative '../lib/task_manager/task_manager'

RSpec.describe TaskManager do
  before(:each) do
    @task_manager = TaskManager.new
  end

  it 'should add a new task' do
    @task_manager.add_task('New Task', 'Task description')
    expect(Task.last.title).to eq('New Task')
  end

  it 'should list all tasks' do
    @task_manager.add_task('Task 1', 'First task description')
    @task_manager.add_task('Task 2', 'Second task description')
    expect { @task_manager.list_tasks }.to output(/Task 1/).to_stdout
  end

  it 'should update a task' do
    task = @task_manager.add_task('Task to Update', 'Description')
    @task_manager.update_task(task.id, title: 'Updated Task')
    expect(Task.find(task.id).title).to eq('Updated Task')
  end

  it 'should delete a task' do
    task = @task_manager.add_task('Task to Delete', 'Description')
    @task_manager.delete_task(task.id)
    expect(Task.exists?(task.id)).to be false
  end
end
