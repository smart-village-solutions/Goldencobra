# == Schema Information
#
# Table name: goldencobra_article_images
#
#  id         :integer          not null, primary key
#  article_id :integer
#  image_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

module Goldencobra
  class ArticleImageTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
