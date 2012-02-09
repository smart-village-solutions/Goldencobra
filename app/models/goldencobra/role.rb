module Goldencobra
  class Role < ActiveRecord::Base
      has_and_belongs_to_many :users
  end
end
# == Schema Information
#
# Table name: goldencobra_roles
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

