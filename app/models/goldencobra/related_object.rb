module Goldencobra
  class RelatedObject

    def self.for_article(article)
      return article.send(Goldencobra::ArticleType.new(article).form_file.downcase)
    end
  end
end
