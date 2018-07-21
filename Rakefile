require 'yaml'

ENV['MAILBOT_ENV'] ||= 'development'

$LOAD_PATH << File.expand_path('../lib', __FILE__)

unless ENV['MAILBOT_ENV'] == 'production'
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)
end

desc 'Annotate models'
task :annotate do
  exec('bundle exec annotate -i -pbefore -R./lib/mailbot.rb --model-dir lib')
end

desc 'Load a console with the environment'
task :console do
  require 'mailbot'
  require 'pry'
  binding.pry
end

namespace :db do
  db_config       = YAML.load_file(File.expand_path('../config/database.yml', __FILE__))[ENV['MAILBOT_ENV']]
  db_config_admin = db_config.dup

  db_config_admin.delete('database')

  task :environment do
    require 'active_record'
  end

  desc 'Create the database'
  task create: :environment do
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.create_database(db_config['database'])
    puts 'Database created.'
  end

  desc 'Drop the database'
  task drop: :environment do
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.drop_database(db_config['database'])
    puts 'Database deleted.'
  end

  desc 'Migrate the database'
  task migrate: :environment do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::MigrationContext.new(File.expand_path('../db/migrate', '__FILE__')).migrate

    Rake::Task['db:schema'].invoke

    puts 'Database migrated.'
  end

  desc 'Rollback the latest migration'
  task rollback: :environment do
    require 'mailbot'
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::MigrationContext.new(Mailbot.root + '/db/migrate').rollback

    Rake::Task['db:schema'].invoke

    puts 'Database rolled back.'
  end

  desc 'Create a db/schema.rb file that is portable against any AR DB.'
  task schema: :environment do
    ActiveRecord::Base.establish_connection(db_config)

    require 'active_record/schema_dumper'

    File.open(File.expand_path('../db/schema.rb', '__FILE__'), 'w:utf-8') do |file|
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
    path            = File.expand_path("../db/migrate/#{timestamp}_#{name}.rb", __FILE__)
    migration_class = name.split('_').map(&:capitalize).join

    File.open(path, 'w') do |file|
      file.write <<-EOF
class #{migration_class} < ActiveRecord::Migration[5.0]
  def change
  end
end
      EOF
    end

    puts "Migration #{path} created"
    abort # needed stop other tasks
  end
end

task default: [:spec]
