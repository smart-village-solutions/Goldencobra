module Goldencobra
  class ArticleSerializer < ActiveModel::Serializer
    root false

    def attributes
      data = super
      Goldencobra::Article.attribute_names.map(&:to_sym).each do |attr|
        data[attr] = object.send(attr)
      end
      data[:child_ids] = object.send(:child_ids)
      data      
    end

    has_many :metatags
    has_many :images, each_serializer: Goldencobra::UploadSerializer
    has_many :widgets

    def metatags
      object.metatags.select([:id, :name, :value])
    end

    def widgets
      object.widgets.pluck(:id)
    end
  end
end
