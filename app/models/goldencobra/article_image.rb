# == Schema Information
#
# Table name: goldencobra_article_images
#
#  id         :integer(4)      not null, primary key
#  article_id :integer(4)
#  image_id   :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  position :string
#

module Goldencobra
  class ArticleImage < ActiveRecord::Base
    belongs_to :article
    belongs_to :image, :class_name => Goldencobra::Upload, :foreign_key => "image_id"

  end
end
