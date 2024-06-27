require 'rspec'
require_relative '../lib/task_manager/task'

RSpec.describe Task do
  before(:each) do
    @task = Task.new(title: 'Test Task', description: 'This is a test task')
  end

  it 'should be valid with a title' do
    expect(@task).to be_valid
  end

  it 'should not be valid without a title' do
    @task.title = nil
    expect(@task).not_to be_valid
  end

  it 'should have a default completed status of false' do
    expect(@task.completed).to be false
  end
end
