module Goldencobra
  class AttributeRepairService

    def self.fix_duplicate_http(model_name, id, attribute_name)
      return "Not a valid model name" unless is_class?(model_name)
      return "Not a valid attribute on #{model_name}" unless is_attribute?(model_name, attribute_name)
      return "Record not found" unless record_exists?(model_name, id)

      record = "#{model_name}".constantize.where(id: id).first
      record.update_attribute(attribute_name.to_sym, repaired_url_value(record.send(attribute_name.to_sym)))
    end

    private

    def self.is_class?(model_name)
      begin
        return "#{model_name}".constantize.is_a?(Class)
      rescue NameError
        return false
      end
    end

    def self.is_attribute?(model_name, attribute_name)
      return "Not a valid model name" unless is_class?(model_name)

      "#{model_name}".constantize.new.respond_to?(attribute_name)
    end

    def self.record_exists?(model_name, id)
      return "Not a valid model name" unless is_class?(model_name)

      "#{model_name}".constantize.where(id: id).any?
    end

    def self.repaired_url_value(value)
      value = value.downcase

      if value.scan("http://").length > 1
        value = value.sub("http://", "")
      elsif value.scan("https://").length > 1
        value = value.sub("https://", "")
      end

      value
    end
  end
end
