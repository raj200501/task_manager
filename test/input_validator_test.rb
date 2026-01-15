# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/task_manager/input_validator'

class InputValidatorTest < Minitest::Test
  def test_validate_import_entry_requires_title
    validator = TaskManager::InputValidator.new
    errors = validator.validate_import_entry({ 'title' => '' })

    refute_empty errors
    assert_includes errors.join(' '), 'Title is required.'
  end

  def test_validate_import_entry_detects_invalid_completed
    validator = TaskManager::InputValidator.new
    errors = validator.validate_import_entry({ 'title' => 'Title', 'completed' => 'yes' })

    assert_includes errors.join(' '), 'Completed must be true or false.'
  end

  def test_coerce_boolean
    validator = TaskManager::InputValidator.new

    assert_equal true, validator.coerce_boolean('true')
    assert_equal false, validator.coerce_boolean('false')
    assert_nil validator.coerce_boolean(nil)
  end
end
