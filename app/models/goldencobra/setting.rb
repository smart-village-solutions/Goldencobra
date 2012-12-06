# == Schema Information
#
# Table name: goldencobra_settings
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  value      :string(255)
#  ancestry   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  data_type  :string(255)
#

module Goldencobra
  class Setting < ActiveRecord::Base
    @key_value = {}
    attr_accessible :title, :value, :ancestry, :parent_id, :data_type
    SettingsDataTypes = ["string","date","datetime","checkbox","array"]
    has_ancestry :orphan_strategy => :restrict
    if ActiveRecord::Base.connection.table_exists?("versions")
      has_paper_trail
    end
    before_save :parse_title

    scope :parent_ids_in_eq, lambda { |art_id| subtree_of(art_id) }
    search_methods :parent_ids_in_eq

    scope :parent_ids_in, lambda { |art_id| subtree_of(art_id) }
    search_methods :parent_ids_in

    scope :with_values, where("value IS NOT NULL")


    def self.regenerate_active_admin
      if defined?(ActiveAdmin) and ActiveAdmin.application
        ActiveAdmin.application.unload!
        ActiveSupport::Dependencies.clear
        ActiveAdmin.application.load!
      end
    end


    def self.for_key(name, cacheable=true)
      if cacheable
        @@key_value ||= {}
        @@key_value[name] ||= for_key_helper(name)
      else
        for_key_helper(name)
      end
    end

    def self.for_key_helper(name)
    if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
      setting_title = name.split(".").last
      settings = Goldencobra::Setting.where(:title => setting_title)
      if settings.count == 1
        return settings.first.value
      elsif settings.count > 1
        settings.each do |set|
          if [set.ancestors.map(&:title).join("."),setting_title].compact.join('.') == name
            return set.value
          end
        end
      else
        return setting_title
      end
    end
    end

    def self.set_value_for_key(value, name, data_type_name="string")
    if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
      setting_title = name.split(".").last
      settings = Goldencobra::Setting.where(:title => setting_title)
      if settings.count == 1
        settings.first.update_attributes(value: value, data_type: data_type_name)
        true
      elsif settings.count > 1
        settings.each do |set|
          if [set.ancestors.map(&:title).join("."),setting_title].compact.join('.') == name
            set.update_attributes(value: value, data_type: data_type_name)
            true
          end
        end
      else
        false
      end
    end
    end

    def self.import_default_settings(path_file_name)
      if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
        require 'yaml'
        raise "Settings File '#{path_file_name}' does not exist" if !File.exists?(path_file_name)
        imports = open(path_file_name) {|f| YAML.load(f) }
        imports.each_key do |key|
          generate_default_setting(key, imports)
        end
      end
    end

    def parent_names
      self.ancestors.map(&:title).join(".")
    end


    private
    def self.generate_default_setting(key, yml_data, parent_id=nil)
      if yml_data[key].class == Hash
        #check if childen keys are value and type or not
        if yml_data[key].keys.count == 2 && yml_data[key].keys.sort == ["type","value"]
          #new way of defining settings by additional value and type params
          create_setting_by_key_and_parent_and_type_and_value(key,parent_id, yml_data[key]["type"], yml_data[key]["value"])
        else
          #old way of defining Settings
          parent = Setting.find_by_ancestry_and_title(parent_id, key)
          unless parent
            parent = Setting.create(:ancestry => parent_id, :title => key)
          end
          yml_data[key].each_key do |name|
            generate_default_setting(name, yml_data[key], [parent.ancestry,parent.id].compact.join('/'))
          end
        end
      elsif yml_data[key].class == String
        create_setting_by_key_and_parent_and_type_and_value(key,parent_id, "string", yml_data[key])
      else
        raise "invalid yml File at: #{key}  -  #{yml_data}"
      end
    end


    def self.create_setting_by_key_and_parent_and_type_and_value(key,parent, data_type, value_name)
      set = Goldencobra::Setting.find_by_title_and_ancestry(key, parent)
      unless set
        if Goldencobra::Setting.new.respond_to?(:data_type)
          Goldencobra::Setting.create(:title => key , :value => value_name, :ancestry => parent, :data_type => data_type )
        else
          Goldencobra::Setting.create(:title => key , :value => value_name, :ancestry => parent)
        end
      end
    end


    def parse_title
      if self.title.present?
        self.title = self.title.downcase
        self.title = self.title.gsub(".", "_")
      end
    end

  end
end
