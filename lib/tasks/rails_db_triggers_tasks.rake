namespace :db do

  desc "Generate all the database triggers of the current project"
  task :create_triggers => :environment do
    creator = RailsDbTriggers::DbTriggersCreator.new

    triggers_path, triggers_ext = Rails.configuration.rails_db_triggers[:triggers_path], Rails.configuration.rails_db_triggers[:triggers_ext]

    triggers_path.each do |path|
      creator.register_files Dir[File.join(path, triggers_ext)].map{|x| File.expand_path(x)}
    end

    creator.create_triggers
  end

  desc "Drop all the database triggers of the current project"
  task :drop_triggers => :environment do
    creator = RailsDbTriggers::DbTriggersCreator.new

    triggers_path, triggers_ext = Rails.configuration.rails_db_triggers[:triggers_path], Rails.configuration.rails_db_triggers[:triggers_ext]

    triggers_path.each do |path|
      creator.register_files Dir[File.join(path, triggers_ext)].map{|x| File.expand_path(x)}
    end

    creator.drop_triggers
  end
end

require 'rake/hooks'

before "db:migrate" do
  Rake::Task['db:drop_triggers'].invoke
end
before "db:rollback" do
  Rake::Task['db:drop_triggers'].invoke
end

after "db:migrate" do
  Rake::Task['db:create_triggers'].invoke
end
after "db:rollback" do
  Rake::Task['db:create_triggers'].invoke
end