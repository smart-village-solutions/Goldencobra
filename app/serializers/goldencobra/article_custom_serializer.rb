module Goldencobra
  class ArticleCustomSerializer < ActiveModel::Serializer
    root false

    # Includes all defined methods
    def attributes
      data = super
      if scope
        scope.split(",").each do |field|
          next unless whitelist_attributes.include?(field.to_sym)
          data[field.to_sym] = object.send(field.to_sym)
        end
      end
      data[:child_ids] = object.send(:child_ids)
      data
    end

    has_many :metatags
    has_many :images
    has_many :widgets

    def metatags
      object.metatags.select([:id, :name, :value])
    end

    def images
      object.images.pluck(:id)
    end

    def widgets
      object.widgets.pluck(:id)
    end

    private

    def whitelist_attributes
      Goldencobra::Article.attribute_names.map(&:to_sym)
    end
  end
end
