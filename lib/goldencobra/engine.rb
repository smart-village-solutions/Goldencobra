#require "activeadmin"
require "friendly_id"
require 'ancestry'
require 'devise'
require 'cancan'
require 'meta_tags'
require 'sass'
require 'sprockets'
require 'sprockets/railtie'
require 'sass-rails'
require 'acts-as-taggable-on'
require 'paperclip'
require 'goldencobra/acts_as_setting'
require 'liquid'
require 'geocoder'
require "paper_trail"


module Goldencobra
  class Engine < ::Rails::Engine
    isolate_namespace Goldencobra
    config.to_prepare do
      ApplicationController.helper(Goldencobra::ApplicationHelper)
      ActionController::Base.helper(Goldencobra::ApplicationHelper)      
      DeviseController.helper(Goldencobra::ApplicationHelper)           
      Devise::SessionsController.helper(Goldencobra::ApplicationHelper)           
      Devise::PasswordsController.helper(Goldencobra::ApplicationHelper)      
      
      ApplicationController.helper(Goldencobra::ArticlesHelper)
      ActionController::Base.helper(Goldencobra::ArticlesHelper)  
      DeviseController.helper(Goldencobra::ArticlesHelper)               
      Devise::SessionsController.helper(Goldencobra::ArticlesHelper)  
      Devise::PasswordsController.helper(Goldencobra::ArticlesHelper)        
    end
  end
end
