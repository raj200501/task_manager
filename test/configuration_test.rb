# frozen_string_literal: true

require_relative 'test_helper'

class ConfigurationTest < Minitest::Test
  def test_loads_configuration
    config = TaskManager::Configuration.load(env: 'test')
    assert_match(/tasks_test.json/, config.storage_path)
  end

  def test_missing_environment_raises
    error = assert_raises(RuntimeError) { TaskManager::Configuration.load(env: 'missing') }
    assert_match(/Missing configuration/, error.message)
  end
end
