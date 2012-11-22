# == Schema Information
#
# Table name: goldencobra_settings
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  value      :string(255)
#  ancestry   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

module Goldencobra
  class SettingTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
