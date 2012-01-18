$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "goldencobra/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "goldencobra"
  s.version     = Goldencobra::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Goldencobra."
  s.description = "TODO: Description of Goldencobra."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.0.rc2"
  # s.add_dependency "jquery-rails"
  s.add_dependency 'devise', '~> 2.0.0.rc'
  s.add_dependency "activeadmin"
  s.add_dependency 'meta_search'
  s.add_dependency "compass"
  s.add_dependency "execjs"
  s.add_dependency "therubyracer"
  s.add_dependency "friendly_id", "~> 4.0.0.beta14"
  s.add_dependency "omniauth"
  s.add_dependency "omniauth-openid"
  s.add_dependency 'oa-oauth'
  s.add_dependency 'oa-openid'
  s.add_dependency "cancan"
  s.add_dependency "ancestry"
  s.add_development_dependency "mysql2"
  s.add_development_dependency 'annotate'
  s.add_development_dependency 'guard-annotate'
  s.add_development_dependency 'pry'
  
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'cucumber-rails'
  s.add_development_dependency 'factory_girl', '~> 2.3.2'
  s.add_development_dependency "factory_girl_rails", "~> 1.4.0"
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-webkit'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-cucumber'
  s.add_development_dependency 'guard-livereload'
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'growl'
  
  
end
