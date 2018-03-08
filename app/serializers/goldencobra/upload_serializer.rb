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

# == Schema Information
#
# Table name: goldencobra_uploads
#
#  id                 :integer          not null, primary key
#  source             :string(255)
#  rights             :string(255)
#  description        :text(65535)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  attachable_id      :integer
#  attachable_type    :string(255)
#  alt_text           :string(255)
#  sorter_number      :integer
#  image_remote_url   :string(255)
#
