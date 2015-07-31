module Goldencobra
  class UploadSerializer < ActiveModel::Serializer
    # Includes all defined methods
    def attributes
      data = {}
      if scope
        scope.split(",").each do |field|
          next unless whitelist_attributes.include?(field.to_sym)
          data[field.to_sym] = object.send(field.to_sym)
        end
      end
      data[:upload_url] = object.send(:image_url)
      data
    end

    private

      def whitelist_attributes
        Goldencobra::Upload.attribute_names.map(&:to_sym)
      end
  end
end
