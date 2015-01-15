# encoding: utf-8

# == Schema Information
#
# Table name: goldencobra_article_authors
#
#  id         :integer          not null, primary key
#  article_id :integer
#  author_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Goldencobra
  class ArticleAuthor < ActiveRecord::Base
    belongs_to :article
    belongs_to :author
  end
end
