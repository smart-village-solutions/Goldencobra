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
#  sorter_id     :integer          default(0)
#

module Goldencobra
  class Permission < ActiveRecord::Base
    attr_accessible :role_id, :action, :subject_class, :subject_id, :sorter_id
    belongs_to :role
    PossibleSubjectClasses = [":all"] + ActiveRecord::Base.descendants.map(&:name)
    PossibleActions = ["read", "not_read", "manage", "not_manage", "update", "not_update", "destroy", "not_destroy"]

    default_scope order("sorter_id ASC, id")
    scope :by_role, lambda{|rid| where(:role_id => rid)}
  end
end
