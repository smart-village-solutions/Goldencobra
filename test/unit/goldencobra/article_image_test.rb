# == Schema Information
#
# Table name: goldencobra_article_images
#
#  id         :integer(4)      not null, primary key
#  article_id :integer(4)
#  image_id   :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'test_helper'

module Goldencobra
  class ArticleImageTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
