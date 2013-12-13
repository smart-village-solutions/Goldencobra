# encoding: utf-8

namespace :i18n do
  desc "Find and create db translation"
  task :missing_keys => :environment do

    def collect_keys(scope, translations)
      full_keys = []
      translations.to_a.each do |key, translations|
        new_scope = scope.dup << key
        if translations.is_a?(Hash)
          full_keys += collect_keys(new_scope, translations)
        else
          full_keys << new_scope.join('.')
        end
      end
      return full_keys
    end

    # Make sure we've loaded the translations
    #I18n.backend.send(:init_translations)
    I18n.backend.load_translations
    #puts "#{I18n.available_locales.size} #{I18n.available_locales.size == 1 ? 'locale' : 'locales'} available: #{I18n.available_locales.to_sentence}"

    # Get all keys from all locales
    all_keys = I18n.backend.backends[0].send(:translations).collect do |check_locale, translations|
      collect_keys([], translations).sort
    end.flatten.uniq
    puts "#{all_keys.size} #{all_keys.size == 1 ? 'unique key' : 'unique keys'} found."

    missing_keys = {}
    all_keys.each do |key|

      [:de, :en].each do |locale|
        I18n.locale = locale
        t = Translation.find_by_key_and_locale(key,locale.to_s)
        if t
          if t.value.blank?
            begin
              a = I18n.translate(key, :raise => true)
              t.value = a
              t.save
            rescue I18n::MissingTranslationData
              #noop
            end
          end
        else
          begin
            I18n.translate(key, :raise => true)
            Translation.create(:key => key, :value => I18n.translate(key), :locale => locale )
          rescue I18n::MissingTranslationData
            Translation.create(:key => key, :locale => locale )
          end
        end
      end
    end
    puts "#{missing_keys.size} #{missing_keys.size == 1 ? 'key is missing' : 'keys are missing'} from one or more locales:"
    # missing_keys.keys.sort.each do |key|
    #   puts "'#{key}': Missing from #{missing_keys[key].join(', ')}"
    # end
  end
end