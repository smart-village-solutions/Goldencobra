# encoding: utf-8

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
#  data_type  :string(255)      default("string")
#

module Goldencobra
  class Setting < ActiveRecord::Base
    require 'fileutils'
    # TODO cache invalidate über touch /temp/settings_updated.txt


    @@key_value = {}
    attr_accessible :title, :value, :ancestry, :parent_id, :data_type
    SettingsDataTypes = ["string","date","datetime","boolean","array"]
    has_ancestry orphan_strategy: :restrict
    if ActiveRecord::Base.connection.table_exists?("versions")
      has_paper_trail
    end
    before_save :parse_title
    after_update :update_cache

    scope :parent_ids_in_eq, lambda { |art_id| subtree_of(art_id) }
    scope :parent_ids_in, lambda { |art_id| subtree_of(art_id) } if ActiveRecord::Base.connection.table_exists?("goldencobra_settings") && Goldencobra::Setting.all.any?
    scope :with_values, -> { where("value IS NOT NULL") }


    def self.absolute_base_url
      Goldencobra::Url.to_s
    end

    def self.regenerate_active_admin
      if defined?(ActiveAdmin) and ActiveAdmin.application
        ActiveAdmin.application.unload!
        ActiveSupport::Dependencies.clear
        ActiveAdmin.application.load!
      end
    end

    # Goldencobra::Setting.for_key("test.foo.bar")
    def self.for_key(name, cacheable=true)
      @@mtime_setting ||= {}
      mtime = get_cache_modification_time(name)

      if cacheable && @@mtime_setting[name].present? && @@mtime_setting[name] >= mtime
        @@key_value ||= {}
        @@key_value[name] ||= for_key_helper(name)
      else
        @@mtime_setting[name] = mtime
        for_key_helper(name)
      end

    end

    def self.for_key_helper(name)
    if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
      setting_title = name.split(".").last
      settings = Goldencobra::Setting.where(title: setting_title)
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
      @@key_value = nil
      if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
        setting_title = name.split(".").last
        settings = Goldencobra::Setting.where(title: setting_title)
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
        imports = open(path_file_name) { |f| YAML.load(f) }
        imports.each_key do |key|
          generate_default_setting(key, imports)
        end
      end
    end

    def parent_names
      self.ancestors.map(&:title).join(".")
    end

    def path_name
      self.path.map(&:title).join(".")
    end

    def has_children
      self.has_children?
    end

    private

    def self.generate_default_setting(key, yml_data, parent_id = nil)
      if yml_data[key].class == Hash
        # check if childen keys are value and type or not
        if yml_data[key].keys.count == 2 && yml_data[key].keys.sort == ["type", "value"]
          # new way of defining settings by additional value and type params
          create_setting_by_key_and_parent_and_type_and_value(key, parent_id, yml_data[key]["type"], yml_data[key]["value"])
        else
          # old way of defining Settings
          parent = Setting.find_by_ancestry_and_title(parent_id, key)
          parent = Setting.create(ancestry: parent_id, title: key) unless parent
          yml_data[key].each_key do |name|
            generate_default_setting(name, yml_data[key], [parent.ancestry, parent.id].compact.join('/'))
          end
        end
      elsif yml_data[key].class == String
        create_setting_by_key_and_parent_and_type_and_value(key, parent_id, "string", yml_data[key])
      else
        raise "invalid yml File at: #{key}  -  #{yml_data}"
      end
    end

    def self.create_setting_by_key_and_parent_and_type_and_value(key,parent, data_type_name, value_name)
      set = Goldencobra::Setting.find_by_title_and_ancestry(key, parent)
      unless set
        if Goldencobra::Setting.new.respond_to?(:data_type)
          Goldencobra::Setting.create(title: key , value: value_name, ancestry: parent, data_type: data_type_name )
        else
          if data_type_name == "string"
            Goldencobra::Setting.create(title: key , value: value_name, ancestry: parent)
          end
        end
      end
    end


    def parse_title
      if self.title.present?
        self.title = self.title.downcase
        self.title = self.title.gsub(".", "_")
      end
    end

    def update_cache
      @@key_value ||= {}
      @@key_value[self.path_name] = nil
      FileUtils.mkdir_p(Goldencobra::Setting.absolute_tmp_path)
      FileUtils.touch(Goldencobra::Setting.absolute_tmp_path("updated_#{self.path_name}.txt"))
    end

    def self.get_cache_modification_time(name)
      if File.exists?(absolute_tmp_path("updated_#{name}.txt"))
        File.mtime(absolute_tmp_path("updated_#{name}.txt"))
      else
        FileUtils.mkdir_p(absolute_tmp_path)
        FileUtils.touch(absolute_tmp_path("updated_#{name}.txt"))
        return Time.now
      end
    rescue
      Airbrake.notify(error_message: "Rescued Error 'FileUtils mkdir_p' with '#{Goldencobra::Setting.absolute_tmp_path}' ")
      return Time.now
    end

    def self.absolute_tmp_path(file_name = nil)
      File.join([Rails.root, "tmp", "settings", file_name].compact)
    end


    # **************************
    # **************************
    # Private Methods
    # **************************
    # **************************

    private

    # Allow Scopes and Methods to search for in ransack (n.a. metasearch)
    # @param auth_object = nil [self] "if auth_object.try(:admin?)"
    #
    # @return [Array] Array of Symbols representing scopes and class methods
    def self.ransackable_scopes(auth_object = nil)
      [
       :parent_ids_in
      ]
    end

  end
end
