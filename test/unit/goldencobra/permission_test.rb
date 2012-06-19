# == Schema Information
#
# Table name: goldencobra_permissions
#
#  id            :integer          not null, primary key
#  action        :string(255)
#  subject_class :string(255)
#  subject_id    :string(255)
#  role_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

module Goldencobra
  class PermissionTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
