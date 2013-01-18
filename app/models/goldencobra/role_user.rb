# == Schema Information
#
# Table name: goldencobra.goldencobra_roles_users
#
#  operator_id   :integer
#  role_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  operator_type :string(255)      default("User")
#

module Goldencobra
  class RoleUser < ActiveRecord::Base
    self.table_name = 'goldencobra.goldencobra_roles_users'
    belongs_to :operator, :polymorphic => true
    belongs_to :role, :class_name => Goldencobra::Role
  end
end
