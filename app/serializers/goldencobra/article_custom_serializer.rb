module Goldencobra
  class ArticleCustomSerializer < ActiveModel::Serializer
    # root "article" # would otherwise be "article_custom"
    root false

    # Includes all defined methods
    def attributes
      data = super
      if scope
        scope.split(",").each do |field|
          data[field.to_sym] = object.send(field.to_sym)
        end
      end
      data
    end

    has_many :metatags
    has_many :images
    has_many :widgets
    has_many :children

    def metatags
      object.metatags.select([:id, :name, :value])
    end

    def images
      object.images.pluck(:id)
    end

    def widgets
      object.widgets.pluck(:id)
    end

    def children
      object.children.active.pluck(:id)
    end
  end
end
