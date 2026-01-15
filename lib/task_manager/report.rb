# frozen_string_literal: true

module TaskManager
  class Report
    def initialize(tasks:)
      @tasks = tasks
    end

    def generate
      summary_lines = [
        'Task Report',
        "Total: #{tasks.count}",
        "Pending: #{pending.count}",
        "Completed: #{completed.count}",
        ''
      ]

      summary_lines + recent_task_lines
    end

    private

    attr_reader :tasks

    def pending
      tasks.reject(&:completed)
    end

    def completed
      tasks.select(&:completed)
    end

    def recent_task_lines
      lines = ['Recent tasks:']
      tasks.sort_by(&:created_at).reverse.first(5).each do |task|
        lines << "- [#{task.status_label}] ##{task.id} #{task.title} (#{task.created_at.strftime('%Y-%m-%d %H:%M:%S')})"
      end
      lines << 'No tasks available.' if tasks.empty?
      lines
    end
  end
end
