require "rubygems"
require "bundler/setup"
require 'em-synchrony/activerecord'
require 'yaml'
require 'erb'

namespace :db do

  desc "creates and migrates your database"
  task :recreate => [:drop, :create, :migrate]

  desc "migrate your database"
  task :migrate do
    ActiveRecord::Base.establish_connection db_conf
    ActiveRecord::Migrator.migrate(
      ActiveRecord::Migrator.migrations_paths, 
      ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )
  end
  
  desc 'Drops the database'
  task :drop do
    ActiveRecord::Base.establish_connection db_conf
    ActiveRecord::Base.connection.drop_database db_conf['database']
  end
  
  desc 'Creates the database'
  task :create do
    ActiveRecord::Base.establish_connection db_conf.merge({"database" => ""})
    ActiveRecord::Base.connection.create_database db_conf['database']
  end
  
end

def db_conf
  config = YAML.load(ERB.new(File.read('config/settings.yml')).result)['db']
end
