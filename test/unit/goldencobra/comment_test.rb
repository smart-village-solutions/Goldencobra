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

require 'test_helper'

module Goldencobra
  class CommentTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
