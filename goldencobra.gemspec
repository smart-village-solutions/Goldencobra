$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "goldencobra/version"
# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "goldencobra"
  s.version     = Goldencobra::VERSION
  s.authors     = ["Marco Metz"]
  s.email       = ["metz@ikusei.de"]
  s.homepage    = "http://www.ikusei.de"
  s.summary     = "Basic CMS based on Rails engines"
  s.description = "This is the Basic Module of Goldencobra. It Offers Devise, ActiveAdmin, an Article-Module, a Menu-Module, and global Settings for an CMS"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["CC-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.1"
  s.add_dependency "jquery-rails"
  s.add_dependency "jqueryui_rails"

  s.add_dependency 'devise', '~> 2.0.0.rc'
  s.add_dependency "activeadmin"
  s.add_dependency 'meta_search', '~> 1.1.2'
  s.add_dependency 'sprockets'
  s.add_dependency "sass-rails", "~> 3.2.1"
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
  s.add_dependency 'meta-tags'
  s.add_dependency 'paperclip'
  s.add_development_dependency "mysql2"
  s.add_development_dependency 'annotate'
  s.add_development_dependency 'guard-annotate'
  s.add_development_dependency 'pry'
  
  
end
