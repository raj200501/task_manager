# frozen_string_literal: true

require 'csv'
require 'json'
require_relative 'input_validator'

module TaskManager
  class ImportError < StandardError; end

  class Importer
    SUPPORTED_FORMATS = %w[csv json].freeze

    def initialize(validator: InputValidator.new)
      @validator = validator
    end

    def import(path:, repository:, format: nil)
      raise ImportError, "Import file not found: #{path}" unless File.exist?(path)

      format = format ? normalize_format(format) : infer_format(path)
      raise ImportError, "Unsupported import format: #{format}" unless SUPPORTED_FORMATS.include?(format)

      tasks_data = case format
                   when 'json'
                     import_json(path)
                   when 'csv'
                     import_csv(path)
                   end

      tasks_data.map do |attributes|
        validate_entry!(attributes)
        repository.create(
          title: attributes.fetch('title'),
          description: attributes['description']
        ).tap do |task|
          repository.update(task.id, completed: attributes.fetch('completed', false))
        end
      end
    end

    private

    attr_reader :validator

    def normalize_format(format)
      format.to_s.downcase.strip
    end

    def infer_format(path)
      ext = File.extname(path).delete('.')
      normalize_format(ext)
    end

    def import_json(path)
      data = JSON.parse(File.read(path))
      unless data.is_a?(Array)
        raise ImportError, 'JSON import expects an array of tasks.'
      end
      data.map { |entry| normalize_entry(entry) }
    rescue JSON::ParserError => e
      raise ImportError, "Invalid JSON: #{e.message}"
    end

    def import_csv(path)
      rows = CSV.read(path, headers: true)
      rows.map do |row|
        normalize_entry(row.to_h)
      end
    rescue CSV::MalformedCSVError => e
      raise ImportError, "Invalid CSV: #{e.message}"
    end

    def normalize_entry(entry)
      {
        'title' => entry['title'] || entry[:title],
        'description' => entry['description'] || entry[:description],
        'completed' => validator.coerce_boolean(entry['completed'] || entry[:completed])
      }
    end

    def validate_entry!(entry)
      errors = validator.validate_import_entry(entry)
      return if errors.empty?

      raise ImportError, errors.join(' ')
    end
  end
end
