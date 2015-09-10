$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_db_triggers/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_db_triggers"
  s.version     = RailsDbTriggers::VERSION
  s.authors     = ["Yacine Petitprez", "Ralf Vitasek"]
  s.email       = ["anykeyh@gmail.com", "neongrau@gmail.com"]
  s.homepage    = "https://github.com/neongrau/rails_db_triggers"
  s.summary     = "Provide tools to create and manage database triggers through Rails project. Based on Yacine Petitprez's rails_db_views gem."
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.require_paths = ["lib"]
  s.licenses = ["MIT"]

  s.add_dependency "rails", ">= 4.0"
  s.add_runtime_dependency "rake-hooks", "~> 1.2.3"

  s.add_development_dependency "sqlite3"
end