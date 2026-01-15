# frozen_string_literal: true

require 'csv'
require 'json'

module TaskManager
  class ExportError < StandardError; end

  class Exporter
    SUPPORTED_FORMATS = %w[csv json].freeze

    def export(tasks:, format:, path:)
      format = normalize_format(format)
      raise ExportError, "Unsupported export format: #{format}" unless SUPPORTED_FORMATS.include?(format)

      case format
      when 'json'
        export_json(tasks: tasks, path: path)
      when 'csv'
        export_csv(tasks: tasks, path: path)
      end
    end

    private

    def normalize_format(format)
      format.to_s.downcase.strip
    end

    def export_json(tasks:, path:)
      payload = tasks.map(&:to_h)
      File.write(path, JSON.pretty_generate(payload))
    end

    def export_csv(tasks:, path:)
      CSV.open(path, 'w') do |csv|
        csv << %w[id title description completed created_at updated_at]
        tasks.each do |task|
          csv << [
            task.id,
            task.title,
            task.description,
            task.completed,
            task.created_at.iso8601,
            task.updated_at.iso8601
          ]
        end
      end
    end
  end
end
