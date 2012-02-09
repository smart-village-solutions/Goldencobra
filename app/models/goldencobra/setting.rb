module Goldencobra
  class Setting < ActiveRecord::Base
    has_ancestry :orphan_strategy => :restrict
    
    
    def self.import_default_settings(path_file_name)
      require 'yaml'
      raise "Settings File '#{path_file_name}' does not exist" if !File.exists?(path_file_name)
      imports = open(path_file_name) {|f| YAML.load(f) }
      imports.each_key do |key|
        generate_default_setting(key, imports)
      end      
    end
    
    
    private
    def self.generate_default_setting(key, yml_data, parent_id=nil)
      puts "KEY: #{key}, YMLDATA: #{yml_data}, PARENT_ID: #{parent_id}"
      if yml_data[key].class == Hash
        parent = Setting.find_by_ancestry_and_title(parent_id, key)
        unless parent
          parent = Setting.create(:ancestry => parent_id, :title => key)
        end
        yml_data[key].each_key do |name|
          generate_default_setting(name, yml_data[key], [parent.ancestry,parent.id].compact.join('/'))
        end
      elsif yml_data[key].class == String
        set = Setting.find_by_title_and_ancestry(yml_data[key], parent_id)
        unless set
          set = Setting.create(:title => key , :value => yml_data[key], :ancestry => parent_id)
        end
      else
        raise "invalid yml File at: #{key}  -  #{yml_data}"
      end
    end
    
  end
end
