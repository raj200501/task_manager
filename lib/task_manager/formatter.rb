# frozen_string_literal: true

module TaskManager
  class Formatter
    HEADER = %w[ID Title Description Status Created_At].freeze

    def initialize(output: $stdout)
      @output = output
    end

    def print_tasks(tasks)
      return @output.puts('No tasks found.') if tasks.empty?

      widths = column_widths(tasks)
      @output.puts(row_line(HEADER, widths))
      @output.puts(separator(widths))
      tasks.each do |task|
        @output.puts(row_line(task_row(task), widths))
      end
    end

    def print_message(message)
      @output.puts(message)
    end

    private

    def task_row(task)
      [
        task.id.to_s,
        task.title.to_s,
        task.description.to_s,
        task.status_label,
        task.created_at&.strftime('%Y-%m-%d %H:%M:%S') || ''
      ]
    end

    def column_widths(tasks)
      columns = HEADER.map.with_index do |header, index|
        values = tasks.map { |task| task_row(task)[index] }
        ([header] + values).map(&:to_s).map(&:length).max
      end
      columns
    end

    def row_line(values, widths)
      values.map.with_index { |value, index| value.to_s.ljust(widths[index]) }.join(' | ')
    end

    def separator(widths)
      widths.map { |width| '-' * width }.join('-+-')
    end
  end
end
