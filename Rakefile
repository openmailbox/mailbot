$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'mailbot'


unless Mailbot.env == 'production'
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)
end

desc 'Load a console with the environment'
task :console do
  require 'pry'
  binding.pry
end

namespace :db do
  db_config       = YAML.load_file(Mailbot.root + '/config/database.yml')[Mailbot.env]
  db_config_admin = db_config.dup

  db_config_admin.delete('database')

  desc 'Create the database'
  task :create do
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.create_database(db_config['database'])
    puts 'Database created.'
  end

  desc 'Drop the database'
  task :drop do
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.drop_database(db_config['database'])
    puts 'Database deleted.'
  end

  desc 'Migrate the database'
  task :migrate do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::Migrator.migrate(Mailbot.root + '/db/migrate')

    Rake::Task['db:schema'].invoke

    puts 'Database migrated.'
  end

  desc 'Rollback the latest migration'
  task :rollback do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::Migrator.rollback(Mailbot.root + '/db/migrate')

    Rake::Task['db:schema'].invoke

    puts 'Database rolled back.'
  end

  desc 'Create a db/schema.rb file that is portable against any AR DB.'
  task :schema do
    ActiveRecord::Base.establish_connection(db_config)

    require 'active_record/schema_dumper'

    File.open(Mailbot.root + '/db/schema.rb', 'w:utf-8') do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end

  desc 'Seed the database from db/seeds.rb'
  task :seed do
    load 'db/seeds.rb'
  end
end

namespace :generate do
  desc 'Generate a new migration file.'
  task :migration do
    name            = ARGV[1] || raise('Specify name: rake generate:migration your_migration')
    timestamp       = Time.now.strftime('%Y%m%d%H%M%S')
    path            = File.expand_path(Mailbot.root + "/db/migrate/#{timestamp}_#{name}.rb", __FILE__)
    migration_class = name.split('_').map(&:capitalize).join

    File.open(path, 'w') do |file|
      file.write <<-EOF
class #{migration_class} < ActiveRecord::Migration[5.0]
  def self.up
  end

  def self.down
  end
end
      EOF
    end

    puts "Migration #{path} created"
    abort # needed stop other tasks
  end
end

task default: [:spec]
