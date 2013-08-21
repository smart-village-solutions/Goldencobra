chema Information
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
      create_tag('OpenGraph Title', article.id, article.title)
      create_tag('OpenGraph URL', article.id, article.absolute_public_url)

      if article.teaser.present?
        value = article.teaser
      else
        value = article.content.present? ? article.content.truncate(200) : article.title
      end
      create_tag('OpenGraph Description', article.id, value)
    end

    def self.verify_existence_of_opengraph_image(article)
      unless tag_exists?(article.id, 'OpenGraph Image')
        if article_has_image?(article)
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
      unless tag_exists?(id, name)
        Goldencobra::Metatag.create(name: name, article_id: id, value: value)
      end
    end

    def self.article_has_image?(article)
      article.article_images.any? && article.article_images.first.image.present? && article.article_images.first.image.image.present?
    end

    def self.tag_exists?(article_id, name)
      Goldencobra::Metatag.where(article_id: article_id, name: name).any?
    end
  end
end
