module Goldencobra
  class Permission < ActiveRecord::Base
    belongs_to :role
    
    scope :by_role, lambda{|rid| where(:role_id => rid)}
  end
end
