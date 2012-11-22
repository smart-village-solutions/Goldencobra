# == Schema Information
#
# Table name: goldencobra_comments
#
#  id               :integer          not null, primary key
#  article_id       :integer
#  commentator_id   :integer
#  commentator_type :string(255)
#  content          :text
#  active           :boolean          default(TRUE)
#  approved         :boolean          default(FALSE)
#  reported         :boolean          default(FALSE)
#  ancestry         :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
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
    scope :not_reported_and_active, where(reported: false, active: true)

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
