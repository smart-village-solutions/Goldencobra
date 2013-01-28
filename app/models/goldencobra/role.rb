# == Schema Information
#
# Table name: goldencobra_roles
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Goldencobra
  class Role < ActiveRecord::Base
      has_many :role_users
      has_many :permissions
  end
end
