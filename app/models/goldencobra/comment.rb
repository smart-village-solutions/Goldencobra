# == Schema Information
#
# Table name: goldencobra_comments
#
#  id               :integer(4)      not null, primary key
#  article_id       :integer(4)
#  commentator_id   :integer(4)
#  commentator_type :string(255)
#  content          :text
#  active           :boolean(1)      default(TRUE)
#  approved         :boolean(1)      default(FALSE)
#  reported         :boolean(1)      default(FALSE)
#  ancestry         :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

module Goldencobra
  class Comment < ActiveRecord::Base
    belongs_to :article, :class_name => Goldencobra::Article, :foreign_key => "article_id"
    belongs_to :commentator, polymorphic: true
    has_ancestry :orphan_strategy => :rootify

    scope :approved, where(:approved => true)
    scope :not_approved, where(:approved => false)
    scope :active, where(:active => true)
    scope :reported, where(:reported => true)

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
