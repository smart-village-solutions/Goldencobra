$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "goldencobra/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "goldencobra"
  s.version     = Goldencobra::VERSION
  s.authors     = ["Marco Metz", "Holger Frohloff", "Daniel Molnar"]
  s.email       = ["it@ikusei.de"]
  s.homepage    = "https://github.com/ikusei/Goldencobra"
  s.summary     = "Basic CMS based on Rails engines"
  s.description = "This is the basic module of Golden Cobra. It offers Devise, ActiveAdmin, an article module, a menu module and global settings for an CMS"
  s.licenses    = "Lizenz CC BY-NC-SA 3.0"
  s.files       = Dir["{app,config,db,lib}/**/*"] + ["CC-LICENSE", "Rakefile", "README.markdown"]
  s.metadata    = { "changelog_uri" => "https://github.com/ikuseiGmbH/Goldencobra/blob/master/doc/versionhistory" }
  # s.test_files = Dir["test/**/*"]

  # Post Install Message
  # if File.exists?('UPGRADING')
  #   s.post_install_message = File.read("UPGRADING")
  # end

  s.requirements << "ImageMagick"
  s.required_ruby_version = ">= 2.2.0"

  s.add_dependency "rails", "~> 4.2.8"
  s.add_dependency "jquery-rails"
  s.add_dependency "jquery-ui-rails"
  s.add_dependency "devise"
  s.add_dependency "devise-token_authenticatable"
  # TODO: new token authentication
  s.add_dependency "cancancan"
  s.add_dependency "activeadmin", "~> 1.0.0"
  s.add_dependency "remove_accents"
  s.add_dependency "sprockets"
  s.add_dependency "sprockets-rails"
  s.add_dependency "tilt"
  s.add_dependency "compass-rails", "~> 3.0.2"
  s.add_dependency "sass"
  s.add_dependency "sass-rails"
  s.add_dependency "compass"
  s.add_dependency "sidekiq"
  s.add_dependency "sinatra"
  s.add_dependency "omniauth"
  s.add_dependency "omniauth-openid"
  s.add_dependency "cancan"
  s.add_dependency "ancestry"
  s.add_dependency "acts-as-taggable-on"
  s.add_dependency "meta-tags"
  s.add_dependency "paperclip"
  s.add_dependency "uglifier"
  s.add_dependency "exception_notification"
  s.add_dependency "liquid", "3.0.6"
  s.add_dependency "rubyzip"
  s.add_dependency "geocoder"
  s.add_dependency "paper_trail", "~> 4.1.0"
  s.add_dependency "whenever"
  s.add_dependency "inherited_resources"
  s.add_dependency "geokit"
  s.add_dependency "json"
  s.add_dependency "i18n"
  s.add_dependency "i18n-active_record"
  s.add_dependency "rmagick"
  s.add_dependency "iconv"
  s.add_dependency "rack-utf8_sanitizer" # handles invalid url encodings
  s.add_dependency "simple_enum"
  s.add_dependency "addressable"
  s.add_dependency "protected_attributes"
  s.add_dependency "active_model_serializers", "~> 0.9.5"
  s.add_dependency "actionpack-action_caching"
  s.add_dependency "react-rails", "~> 1.0"
  s.add_dependency "oj" # faster json rendering
  s.add_dependency "bootstrap-sass", "~> 3.3" # frontend template framework
  s.add_dependency "font-awesome-sass"
  s.add_dependency "autoprefixer-rails" # to provide easy automatic css prefixing

  # outsourced functions in Rails 4.x
  s.add_dependency "responders", "~> 2.0"

  s.add_development_dependency "mysql2"
  s.add_development_dependency "annotate"
  s.add_development_dependency "guard-annotate"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-nav"
  s.add_development_dependency "better_errors"
  s.add_development_dependency "binding_of_caller"
  s.add_development_dependency "yard"
  s.add_development_dependency "redcarpet"
end
