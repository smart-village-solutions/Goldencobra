# == Schema Information
#
# Table name: goldencobra_imports
#
#  id           :integer(4)      not null, primary key
#  assignment   :text
#  target_model :string(255)
#  successful   :boolean(1)
#  upload_id    :integer(4)
#  separator    :string(255)     default(",")
#  result       :text
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

require 'test_helper'

module Goldencobra
  class ImportTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
