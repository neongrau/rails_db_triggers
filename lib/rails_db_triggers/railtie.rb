class Railtie < Rails::Railtie
  railtie_name :rails_db_triggers

  config.rails_db_triggers = ActiveSupport::OrderedHash.new

  initializer "rails_db_triggers.initialize" do |app|
    app.config.rails_db_triggers[:triggers_path] = %w( db/triggers )
    app.config.rails_db_triggers[:triggers_ext] = "*.sql"
    app.config.rails_db_triggers[:triggers_dbschema] = ['dbo']
  end

  rake_tasks do
    load "tasks/rails_db_triggers_tasks.rake"
  end
end
