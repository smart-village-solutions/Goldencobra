# encoding: utf-8

# == Schema Information
#
# Table name: goldencobra_article_widgets
#
#  id         :integer          not null, primary key
#  article_id :integer
#  widget_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Goldencobra
  class ArticleWidget < ActiveRecord::Base
    belongs_to :article
    belongs_to :widget
  end
end
