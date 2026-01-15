# frozen_string_literal: true

module TaskManager
  class Sanitizer
    def normalize_title(title)
      normalize_string(title, max_length: Task::MAX_TITLE_LENGTH)
    end

    def normalize_description(description)
      return nil if description.nil?

      normalize_string(description, max_length: Task::MAX_DESCRIPTION_LENGTH)
    end

    private

    def normalize_string(value, max_length:)
      return '' if value.nil?

      sanitized = value.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
      sanitized = sanitized.tr("\r\n", ' ')
      sanitized = sanitized.gsub(/\s+/, ' ').strip
      sanitized = sanitized[0...max_length]
      sanitized
    end
  end
end
