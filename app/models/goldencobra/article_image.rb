# == Schema Information
#
# Table name: goldencobra_article_images
#
#  id         :integer          not null, primary key
#  article_id :integer
#  image_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  position   :string(255)
#

module Goldencobra
  class ArticleImage < ActiveRecord::Base
    belongs_to :article
    belongs_to :image, :class_name => Goldencobra::Upload, :foreign_key => "image_id"

  end
end
