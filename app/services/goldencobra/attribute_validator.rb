module Goldencobra
  class AttributeValidator

    require "addressable/uri"

    def self.validate_url(model_name, attribute_name)
      return "Not a valid model name" unless is_class?(model_name)
      return "Not a valid attribute on #{model_name}" unless is_attribute?(model_name, attribute_name)

      klass = "#{model_name}".constantize
      results = []
      klass.all.each do |k|
        unless single_scheme_occurence(k.send(attribute_name.to_sym))
          results << {
            class: model_name,
            id: k.id,
            value: k.send(attribute_name.to_sym)
          }
        end
      end

      results
    end

    private

    def self.single_scheme_occurence(url)
      return true unless url.present?

      parsed_uri = Addressable::URI.parse(url).normalize!
      (parsed_uri.scheme == "http" || parsed_uri.scheme == "https") &&
        parsed_uri.host.start_with?("http", "https") == false
    end

    def self.is_class?(model_name)
      begin
        return "#{model_name}".constantize.is_a?(Class)
      rescue NameError
        return false
      end
    end

    def self.is_attribute?(model_name, attribute_name)
      "#{model_name}".constantize.new.respond_to?(attribute_name)
    end
  end
end
