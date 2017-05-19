module Goldencobra
  # This class offers methods for helping to clean up Golden Cobra settings. They
  # can be used all over the project and in some included gems. Some of them are
  # not used anymore but still appear in the backend to edit. This produces overhead
  # because they suggest to be important and one will fill them.
  # If we remove the unused settings, nobody needs to care about them.
  class SettingsCleanup
    # Checks every single Goldencobra::Setting for presence or if it is still used.
    #
    # @param settings_path [string] the path of the settings.yml
    #        Examples: Goldencobra::Engine.root + "config/settings.yml"
    #                  GoldencobraEvents::Engine.root + "config/settings.yml"
    def self.remove_unused_setting_keys(settings_path)
      raise "Settings file '#{path_file_name}' does not exist" unless File.exist?(settings_path)

      settings = open(settings_path) { |f| YAML.safe_load(f) }
      settings_root = settings.each_key.first if settings.present?

      return if settings_root.blank?

      p "*" * 100
      Goldencobra::Setting.roots.where(title: settings_root).first.descendants.each do |setting|
        settings_to_fetch = settings
        setting.path.pluck(:title).each do |key|
          p "Setting key: #{key} - Setting path: #{setting.path.pluck(:title).join(".")}"
          begin
            # Traverse the setting path hierarchically from the outside into the deep.
            #
            # Example:
            #   setting path = goldencobra.locations.geocoding
            #
            #   1. settings_to_fetch = {"goldencobra"=>{"locations"=>{"geocoding"=>"false"}}}
            #   2. settings_to_fetch = {"locations"=>{"geocoding"=>"false"}}
            #   3. settings_to_fetch = {"geocoding"=>"false"}
            settings_to_fetch = settings_to_fetch.fetch(key)
          rescue KeyError
            begin
              # If a 'KeyError' is thrown, the key is not present and the setting can be
              # removed from the database.
              p "Not present!"
              p "Destroy setting: #{setting.title}"
              p "-" * 100
              setting.destroy
            rescue Ancestry::AncestryException
              # If a `Ancestry::AncestryException` is thrown, than do not quit the
              # process because there could be some more settings to check in the loop.
              # Return true and go on with the next iteration step.
              true
            end
          end
        end
      end
      p "*" * 100
    end

    # Searches for usages of settings in a Golden Cobra app source code.
    #
    # (!) only complete formats like "root.key1.key2.key3" will be recognized
    #
    # The log output in the console is formatted a bit for better readability.
    # The results has to be checked manually. Reported non-usages in one app
    # needs to be checked in other included golden cobra engines (gems).
    #
    # Example:
    #   "foo.bar" is not used in Goldencobra::Engine
    #
    #   1. check for usages in the app itself
    #   2. check for usages in golden cobra events, if the gem is included
    #
    # @param settings_path [string] the path of the settings.yml
    #        Examples: Goldencobra::Engine.root + "config/settings.yml"
    #                  GoldencobraEvents::Engine.root + "config/settings.yml"
    # @param search_path [string] the root path of the app to search in
    #        Example: "../goldencobra-events"
    def self.search_in_files(settings_path, search_path)
      raise "Settings file '#{path_file_name}' does not exist" unless File.exist?(settings_path)

      settings = open(settings_path) { |f| YAML.safe_load(f) }
      settings_root = settings.each_key.first

      return if settings_root.blank?

      Goldencobra::Setting.roots.where(title: settings_root).first.descendants.each do |setting|
        complete_setting = setting.path.pluck(:title).join(".")
        p "*" * 100
        p "Searching for #{complete_setting} in #{search_path}"
        p "-" * 100
        unless system "grep -Rl '#{complete_setting}' #{search_path}"
          p "#{complete_setting} not found in #{search_path}"
        end
        p "*" * 100
      end
    end
  end
end
