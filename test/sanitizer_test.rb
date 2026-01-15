# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/task_manager/sanitizer'

class SanitizerTest < Minitest::Test
  def test_normalize_title_strips_whitespace
    sanitizer = TaskManager::Sanitizer.new
    result = sanitizer.normalize_title("  Title   with  spaces \n")
    assert_equal 'Title with spaces', result
  end

  def test_normalize_description_handles_nil
    sanitizer = TaskManager::Sanitizer.new
    assert_nil sanitizer.normalize_description(nil)
  end

  def test_normalize_description_truncates
    sanitizer = TaskManager::Sanitizer.new
    long_description = 'a' * (TaskManager::Task::MAX_DESCRIPTION_LENGTH + 10)
    result = sanitizer.normalize_description(long_description)
    assert_equal TaskManager::Task::MAX_DESCRIPTION_LENGTH, result.length
  end
end
