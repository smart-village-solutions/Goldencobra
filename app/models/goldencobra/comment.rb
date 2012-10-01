module Goldencobra
  class Comment < ActiveRecord::Base
    belongs_to :article, :class_name => Goldencobra::Article, :foreign_key => "article_id"
    belongs_to :commentator, polymorphic: true
    has_ancestry :orphan_strategy => :rootify

    def title
      [self.article.title,self.content[0..20]].join(" - ")
    end

    def commentator_title
      if self.commentator.respond_to?(:title)
        self.commentator.title
      end
    end

  end
end
