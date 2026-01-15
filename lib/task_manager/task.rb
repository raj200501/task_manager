# frozen_string_literal: true

require 'time'

module TaskManager
  class ValidationError < StandardError; end

  class Task
    attr_accessor :id, :title, :description, :completed, :created_at, :updated_at

    MAX_TITLE_LENGTH = 200
    MAX_DESCRIPTION_LENGTH = 2000

    def initialize(id:, title:, description: nil, completed: false, created_at: Time.now, updated_at: Time.now)
      @id = id
      @title = title
      @description = description
      @completed = completed
      @created_at = created_at
      @updated_at = updated_at
    end

    def validate!
      raise ValidationError, 'Title is required.' if title.nil? || title.strip.empty?
      raise ValidationError, "Title must be <= #{MAX_TITLE_LENGTH} characters." if title.length > MAX_TITLE_LENGTH
      if description && description.length > MAX_DESCRIPTION_LENGTH
        raise ValidationError, "Description must be <= #{MAX_DESCRIPTION_LENGTH} characters."
      end
      true
    end

    def completed?
      completed
    end

    def pending?
      !completed
    end

    def status_label
      completed ? 'Completed' : 'Pending'
    end

    def summary
      [title, description].compact.join(' - ')
    end

    def to_s
      "Task #{id}: #{summary} [#{status_label}]"
    end

    def to_h
      {
        'id' => id,
        'title' => title,
        'description' => description,
        'completed' => completed,
        'created_at' => created_at.iso8601,
        'updated_at' => updated_at.iso8601
      }
    end

    def self.from_h(data)
      new(
        id: data.fetch('id'),
        title: data.fetch('title'),
        description: data['description'],
        completed: data.fetch('completed', false),
        created_at: Time.parse(data.fetch('created_at')),
        updated_at: Time.parse(data.fetch('updated_at'))
      )
    end
  end
end
