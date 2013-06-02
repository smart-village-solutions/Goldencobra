# == Schema Information
#
# Table name: goldencobra_metatags
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  value            :string(255)
#  article_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  metatagable_id   :integer
#  metatagable_type :string(255)
#

require 'test_helper'

module Goldencobra
  class MetatagTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
