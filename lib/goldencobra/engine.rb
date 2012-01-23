require "activeadmin"
require "friendly_id"
require 'ancestry'
require 'devise'

module Goldencobra
  class Engine < ::Rails::Engine
    isolate_namespace Goldencobra
  end
end
