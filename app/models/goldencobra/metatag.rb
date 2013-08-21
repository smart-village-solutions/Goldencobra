# == Schema Information
#
# Table name: goldencobra_metatags
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  value            :string(255)
#  article_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  metatagable_id   :integer
#  metatagable_type :string(255)
#

module Goldencobra
  class Metatag < ActiveRecord::Base
    attr_accessible :name, :value, :article_id
    belongs_to :article
    belongs_to :metatagable, polymorphic: true

    def self.set_default_opengraph_values(article)
      if Goldencobra::Metatag.where(article_id: article.id, name: 'OpenGraph Title').none?
        create_tag('OpenGraph Title', article.id, article.title)
      end

      if Goldencobra::Metatag.where(article_id: article.id, name: 'OpenGraph URL').none?
        create_tag('OpenGraph URL', article.id, article.absolute_public_url)
      end

      if Goldencobra::Metatag.where(article_id: article.id, name: 'OpenGraph Description').none?
        if article.teaser.present?
          value = article.teaser
        else
          value = article.content.present? ? article.content.truncate(200) : article.title
        end
        create_tag('OpenGraph Description', article.id, value)
      end
    end

    def self.verify_existence_of_opengraph_image(article)
      if Goldencobra::Metatag.where("article_id = ? AND name = 'OpenGraph Image'", article.id).count == 0
        if article.article_images.any? && article.article_images.first.image.present? && article.article_images.first.image.image.present?
          meta_tag = Goldencobra::Metatag.where(article_id: article.id, name: "OpenGraph Image").first
          meta_tag.value = "http://#{Goldencobra::Setting.for_key('goldencobra.url')}#{article.article_images.first.image.image.url}"
          meta_tag.save
        else
          create_tag("OpenGraph Image", article.id, Goldencobra::Setting.for_key("goldencobra.facebook.opengraph_default_image"))
        end
      end
    end

    private
    def self.create_tag(name, id, value)
      Goldencobra::Metatag.create(name: name, article_id: id, value: value)
    end
  end
end
