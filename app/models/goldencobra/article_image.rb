module Goldencobra
  class ArticleImage < ActiveRecord::Base
    belongs_to :article
    belongs_to :image, :class_name => Goldencobra::Upload, :foreign_key => "image_id"
  end
end
