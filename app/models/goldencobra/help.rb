# encoding: utf-8

# == Schema Information
#
# Table name: goldencobra_helps
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  url         :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Goldencobra
  class Help < ApplicationRecord
  end
end
