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

require 'test_helper'

module Goldencobra
  class CommentTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
