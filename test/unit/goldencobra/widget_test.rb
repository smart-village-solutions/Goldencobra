# == Schema Information
#
# Table name: goldencobra_widgets
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  content             :text
#  css_name            :string(255)
#  active              :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  id_name             :string(255)
#  sorter              :integer
#  mobile_content      :text
#  teaser              :string(255)
#  default             :boolean
#  description         :text
#  offline_days        :string(255)
#  offline_time_start  :datetime
#  offline_time_end    :datetime
#  offline_time_active :boolean
#  alternative_content :text
#  offline_date_start  :date
#  offline_date_end    :date
#

require 'test_helper'

module Goldencobra
  class WidgetTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
