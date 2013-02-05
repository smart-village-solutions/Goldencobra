$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "goldencobra/version"
# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "goldencobra"
  s.version     = Goldencobra::VERSION
  s.authors     = ["Marco Metz", "Holger Frohloff"]
  s.email       = ["metz@ikusei.de"]
  s.homepage    = "https://github.com/ikusei/Goldencobra"
  s.summary     = "Basic CMS based on Rails engines"
  s.description = "This is the Basic Module of Goldencobra. It Offers Devise, ActiveAdmin, an Article-Module, a Menu-Module, and global Settings for an CMS"
  s.licenses    = "Lizenz CC BY-NC-SA 3.0"
  s.files = Dir["{app,config,db,lib}/**/*"] + ["CC-LICENSE", "Rakefile", "README.markdown"]
  s.test_files = Dir["test/**/*"]

  if File.exists?('UPGRADING')
    s.post_install_message = File.read("UPGRADING")
  end

  s.requirements << "ImageMagick"
  s.required_ruby_version = ">= 1.9.2"

  s.add_dependency "capistrano"
  s.add_dependency "rvm-capistrano"
  s.add_dependency "rails", "~> 3.2.11"
  s.add_dependency "jquery-rails", "2.1.4"
  s.add_dependency "jqueryui_rails"
  s.add_dependency 'devise'
  s.add_dependency 'activeadmin-cancan'
  s.add_dependency "activeadmin"
  s.add_dependency 'sunspot_rails'
  s.add_dependency 'sunspot_solr'
  #s.add_dependency 'meta_search', '~> 1.1.3'
  s.add_dependency 'sprockets'
  #s.add_dependency "sass-rails", "~> 3.2.1"
  s.add_dependency "sass"
  s.add_dependency "sass-rails"
  s.add_dependency "coffee-rails"
  s.add_dependency "compass-rails"
  s.add_dependency 'compass-960-plugin'
  s.add_dependency 'progress_bar'
  s.add_dependency "execjs"
  s.add_dependency "therubyracer", "~> 0.10.2"
  s.add_dependency "friendly_id"#, ">= 4.0.6"
  s.add_dependency "omniauth"
  s.add_dependency "omniauth-openid"
  s.add_dependency 'oa-oauth'
  s.add_dependency 'oa-openid'
  s.add_dependency "cancan"
  s.add_dependency "ancestry"
  s.add_dependency 'meta-tags'
  s.add_dependency 'paperclip'
  s.add_dependency 'uglifier'
  s.add_dependency 'exception_notification'
  s.add_dependency 'acts-as-taggable-on'
  s.add_dependency 'liquid'
  s.add_dependency 'rubyzip'
  s.add_dependency 'geocoder'
  s.add_dependency 'paper_trail'
  s.add_dependency 'sidekiq'
  s.add_dependency 'sinatra'
  s.add_dependency 'slim'
  s.add_dependency 'whenever'
  s.add_dependency 'inherited_resources'
  s.add_dependency 'geokit'
  # s.add_dependency "pdfkit"
  # s.add_dependency 'wkhtmltopdf-binary'
  # s.add_dependency "wicked_pdf"
  s.add_development_dependency "mysql2"
  s.add_development_dependency 'annotate'
  s.add_development_dependency 'guard-annotate'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'better_errors'
  s.add_development_dependency 'binding_of_caller'
end
