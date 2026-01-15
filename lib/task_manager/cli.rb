# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require_relative 'configuration'
require_relative 'formatter'
require_relative 'task_manager'

module TaskManager
  class CLI
    def initialize(argv:, output: $stdout)
      @argv = argv
      @output = output
      @formatter = Formatter.new(output: output)
    end

    def run
      command = @argv.shift
      case command
      when 'add'
        handle_add
      when 'list'
        handle_list
      when 'update'
        handle_update
      when 'delete'
        handle_delete
      when 'stats'
        handle_stats
      when 'export'
        handle_export
      when 'import'
        handle_import
      when 'report'
        handle_report
      when 'help', nil
        print_help
      else
        @output.puts("Unknown command: #{command}\n")
        print_help
        exit 1
      end
    rescue NotFoundError, ValidationError, StorageError, ExportError, ImportError => e
      @output.puts("Error: #{e.message}")
      exit 1
    end

    private

    def setup_manager
      config = Configuration.load
      FileUtils.mkdir_p(File.dirname(config.storage_path))
      TaskManager.new(config: config)
    end

    def handle_add
      options = { description: nil }
      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: task_manager add --title TITLE [--description DESCRIPTION]'
        opts.on('--title TITLE', 'Title for the task (required)') { |value| options[:title] = value }
        opts.on('--description DESCRIPTION', 'Description for the task') { |value| options[:description] = value }
        opts.on('-h', '--help', 'Show help') { print_help; exit 0 }
      end

      parser.parse!(@argv)
      ensure_required(options[:title], 'title')

      manager = setup_manager
      task = manager.add_task(options[:title], options[:description])
      @formatter.print_message("Created task ##{task.id}: #{task.title}")
    end

    def handle_list
      options = { filter: :all }
      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: task_manager list [--filter all|pending|completed]'
        opts.on('--filter FILTER', 'Filter list results') { |value| options[:filter] = value.to_sym }
        opts.on('-h', '--help', 'Show help') { print_help; exit 0 }
      end

      parser.parse!(@argv)

      manager = setup_manager
      tasks = manager.list_tasks(filter: options[:filter])
      @formatter.print_tasks(tasks)
    end

    def handle_update
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: task_manager update --id ID [--title TITLE] [--description DESCRIPTION] [--completed true|false]'
        opts.on('--id ID', Integer, 'Task ID (required)') { |value| options[:id] = value }
        opts.on('--title TITLE', 'Updated title') { |value| options[:title] = value }
        opts.on('--description DESCRIPTION', 'Updated description') { |value| options[:description] = value }
        opts.on('--completed VALUE', 'Completed status true|false') { |value| options[:completed] = value == 'true' }
        opts.on('-h', '--help', 'Show help') { print_help; exit 0 }
      end

      parser.parse!(@argv)
      ensure_required(options[:id], 'id')

      manager = setup_manager
      task = manager.update_task(options[:id], title: options[:title], description: options[:description], completed: options[:completed])
      @formatter.print_message("Updated task ##{task.id}")
    end

    def handle_delete
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: task_manager delete --id ID'
        opts.on('--id ID', Integer, 'Task ID (required)') { |value| options[:id] = value }
        opts.on('-h', '--help', 'Show help') { print_help; exit 0 }
      end

      parser.parse!(@argv)
      ensure_required(options[:id], 'id')

      manager = setup_manager
      manager.delete_task(options[:id])
      @formatter.print_message("Deleted task ##{options[:id]}")
    end

    def handle_stats
      manager = setup_manager
      stats = manager.stats
      @formatter.print_message("Total: #{stats[:total]}")
      @formatter.print_message("Pending: #{stats[:pending]}")
      @formatter.print_message("Completed: #{stats[:completed]}")
    end

    def handle_export
      options = { format: 'json' }
      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: task_manager export --output PATH [--format json|csv]'
        opts.on('--output PATH', 'Export destination (required)') { |value| options[:output] = value }
        opts.on('--format FORMAT', 'Export format (json or csv)') { |value| options[:format] = value }
        opts.on('-h', '--help', 'Show help') { print_help; exit 0 }
      end

      parser.parse!(@argv)
      ensure_required(options[:output], 'output')

      manager = setup_manager
      count = manager.export_tasks(format: options[:format], path: options[:output])
      @formatter.print_message("Exported #{count} tasks to #{options[:output]}")
    end

    def handle_import
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: task_manager import --input PATH [--format json|csv]'
        opts.on('--input PATH', 'Import source (required)') { |value| options[:input] = value }
        opts.on('--format FORMAT', 'Import format (json or csv)') { |value| options[:format] = value }
        opts.on('-h', '--help', 'Show help') { print_help; exit 0 }
      end

      parser.parse!(@argv)
      ensure_required(options[:input], 'input')

      manager = setup_manager
      imported = manager.import_tasks(path: options[:input], format: options[:format])
      @formatter.print_message("Imported #{imported.length} tasks from #{options[:input]}")
    end

    def handle_report
      manager = setup_manager
      report_lines = manager.report
      report_lines.each { |line| @formatter.print_message(line) }
    end

    def ensure_required(value, name)
      return if value

      @output.puts("Missing required argument: #{name}\n")
      print_help
      exit 1
    end

    def print_help
      @output.puts <<~HELP
        Task Manager Commands:
          add --title TITLE [--description DESCRIPTION]   Add a new task
          list [--filter all|pending|completed]           List tasks
          update --id ID [--title TITLE] [--description DESCRIPTION] [--completed true|false]
                                                      Update a task
          delete --id ID                                 Delete a task
          stats                                          Show task counts
          export --output PATH [--format json|csv]        Export tasks to a file
          import --input PATH [--format json|csv]         Import tasks from a file
          report                                         Show a detailed task report
          help                                           Show this help message

        Environment variables:
          TASK_MANAGER_ENV      Environment name (default: development)
          TASK_MANAGER_DATA_PATH Override storage path (development)
          TASK_MANAGER_TEST_DATA_PATH Override storage path (test)
      HELP
    end
  end
end
