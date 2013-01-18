module Goldencobra
  class RoleUser < ActiveRecord::Base
    self.table_name = 'goldencobra.goldencobra_roles_users'
    belongs_to :operator, :polymorphic => true
    belongs_to :role, :class_name => Goldencobra::Role
  end
end
