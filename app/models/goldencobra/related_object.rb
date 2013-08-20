module Goldencobra
  class RelatedObject

    def self.for_article(article)
      related_object = Goldencobra::ArticleType.new(article).form_file.downcase
      if article.respond_to?(related_object)
        return article.send(related_object)
      else
        return Goldencobra::RelatedObject.new(article)
      end
    end

    def initialize(article)
      @article = article
    end

    def fulltext_searchable_text
      return ' '
    end

    def custom_rss_fields
      return ' '
    end
  end
end
