module Goldencobra
  class ArticleWidget < ActiveRecord::Base
    belongs_to :article
    belongs_to :widget
  end
end
