# frozen_string_literal: true

require_relative 'test_helper'
require 'stringio'

class FormatterTest < Minitest::Test
  def test_prints_message
    output = StringIO.new
    formatter = TaskManager::Formatter.new(output: output)

    formatter.print_message('Hello')

    assert_includes output.string, 'Hello'
  end

  def test_prints_tasks_table
    output = StringIO.new
    formatter = TaskManager::Formatter.new(output: output)

    task = TaskManager::Task.new(id: 1, title: 'Format Task', description: 'Details')
    formatter.print_tasks([task])

    assert_includes output.string, 'Format Task'
    assert_includes output.string, 'Pending'
  end

  def test_prints_empty_message
    output = StringIO.new
    formatter = TaskManager::Formatter.new(output: output)

    formatter.print_tasks([])

    assert_equal "No tasks found.\n", output.string
  end
end
