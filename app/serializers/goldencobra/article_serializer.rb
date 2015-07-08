module Goldencobra
  class ArticleSerializer < ActiveModel::Serializer
    root false
    attributes(*Goldencobra::Article.attribute_names.map(&:to_sym))

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
