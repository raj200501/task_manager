# frozen_string_literal: true

require 'erb'
require 'yaml'

module TaskManager
  class Configuration
    DEFAULT_ENV = 'development'

    attr_reader :env, :config, :root

    def self.load(root: Dir.pwd, env: ENV['TASK_MANAGER_ENV'] || ENV['APP_ENV'] || DEFAULT_ENV)
      new(root: root, env: env).tap(&:load!)
    end

    def initialize(root:, env:)
      @root = root
      @env = env
      @config = {}
    end

    def load!
      @config = load_config
      self
    end

    def storage_path
      config.fetch('storage_path')
    end

    def to_h
      { env: env, storage_path: storage_path }
    end

    private

    def config_path
      File.join(root, 'config', 'task_manager.yml')
    end

    def load_config
      raise "Missing configuration at #{config_path}" unless File.exist?(config_path)

      template = ERB.new(File.read(config_path))
      config = YAML.safe_load(template.result, aliases: true) || {}
      config.fetch(env) do
        raise "Missing configuration for '#{env}' environment"
      end
    end
  end
end
