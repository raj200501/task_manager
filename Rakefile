require 'rake'
require 'active_record'
require 'yaml'

namespace :db do
  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Base.establish_connection(YAML.load_file('config/database.yml'))
    ActiveRecord::Migrator.migrations_paths = ['db/migrate']
    ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths)
  end

  desc "Create the database"
  task :create do
    ActiveRecord::Base.establish_connection(YAML.load_file('config/database.yml'))
    ActiveRecord::Base.connection.create_database('db/tasks.db')
  end
end
