# == Schema Information
#
# Table name: goldencobra_vita
#
#  id            :integer          not null, primary key
#  loggable_id   :integer
#  loggable_type :string(255)
#  user_id       :integer
#  title         :string(255)
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

module Goldencobra
  class VitaTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
