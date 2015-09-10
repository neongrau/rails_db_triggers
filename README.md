# rails_db_triggers
Manage db triggers in Rails

# Blatantly copied from https://github.com/anykeyh/rails_db_views as the basis
Exactly like Yacine's gem for managing views, this gem will handle creating and dropping triggers that
reside in /db/triggers/*.sql files.
The name part of the .sql file will serve as the trigger name.
Whenever rake db:migrate or rake db:rollback is called all triggers will be dropped and (re-)created afterwards.
To delete a trigger just save the .sql file empty and it will be deleted next time you run migrations and 
be skippedduring trigger creation.

# How to use
Just add rails_db_triggers to your Gemfile:

```Gemfile
gem 'rails_db_triggers'
```

## Configurate paths & extensions

You can add/remove new paths in the initializers of Rails:

```ruby
Rails.configure do |config|
  config.rails_db_triggers[:triggers_path] += %w( /some/view/path ) # defaults to /db/triggers
  config.rails_db_triggers[:triggers_ext] = "*.dbtrigger" #Using custom extensions to override default ".sql" extension.
  config.rails_db_triggers[:triggers_dbschema] = [] # if you don't need prefixes - defaults to ['dbo']
end
```

# Licensing
MIT


Ralf.
