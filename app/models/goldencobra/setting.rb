module Goldencobra
  class Setting < ActiveRecord::Base
    has_ancestry :orphan_strategy => :restrict
    
    
    def self.import_default_settings(path_file_name)
      require 'yaml'
      raise "Settings File '#{path_file_name}' does not exist" if !File.exists?(path_file_name)
      imports = open(path_file_name) {|f| YAML.load(f) }
    end
    
  end
end
