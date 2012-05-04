require "activeadmin"
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
require 'radius'

module Goldencobra
  class Engine < ::Rails::Engine
    isolate_namespace Goldencobra
    config.to_prepare do
      ApplicationController.helper(Goldencobra::ApplicationHelper)
      ActionController::Base.helper(Goldencobra::ApplicationHelper)      
      
      ApplicationController.helper(Goldencobra::ArticlesHelper)
      ActionController::Base.helper(Goldencobra::ArticlesHelper)      
    end
  end
end
