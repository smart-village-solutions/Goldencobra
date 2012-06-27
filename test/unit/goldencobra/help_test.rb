# == Schema Information
#
# Table name: goldencobra_helps
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  description :text
#  url         :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'test_helper'

module Goldencobra
  class HelpTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
