# frozen_string_literal: true

module TaskManager
  class InputValidator
    def validate_import_entry(entry)
      errors = []
      title = entry['title']
      if title.nil? || title.to_s.strip.empty?
        errors << 'Title is required.'
      elsif title.length > Task::MAX_TITLE_LENGTH
        errors << "Title must be <= #{Task::MAX_TITLE_LENGTH} characters."
      end

      description = entry['description']
      if description && description.length > Task::MAX_DESCRIPTION_LENGTH
        errors << "Description must be <= #{Task::MAX_DESCRIPTION_LENGTH} characters."
      end

      completed = entry['completed']
      if !completed.nil? && ![true, false].include?(completed)
        errors << 'Completed must be true or false.'
      end

      errors
    end

    def coerce_boolean(value)
      return nil if value.nil?
      return value if value == true || value == false

      value.to_s.strip.downcase == 'true'
    end
  end
end
