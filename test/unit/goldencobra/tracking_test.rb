# == Schema Information
#
# Table name: goldencobra_trackings
#
#  id             :integer          not null, primary key
#  request        :text
#  session_id     :string(255)
#  referer        :string(255)
#  url            :string(255)
#  ip             :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_agent     :string(255)
#  language       :string(255)
#  path           :string(255)
#  page_duration  :string(255)
#  view_duration  :string(255)
#  db_duration    :string(255)
#  url_paremeters :string(255)
#  utm_source     :string(255)
#  utm_medium     :string(255)
#  utm_term       :string(255)
#  utm_content    :string(255)
#  utm_campaign   :string(255)
#  location       :string(255)
#

require 'test_helper'

module Goldencobra
  class TrackingTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
