require "activeadmin"
require "friendly_id"
require 'ancestry'
require 'devise'
require 'cancan'
require 'meta-tags'

module Goldencobra
  class Engine < ::Rails::Engine
    isolate_namespace Goldencobra
  end
end
