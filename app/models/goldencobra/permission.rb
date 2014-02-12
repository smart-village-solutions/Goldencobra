# encoding: utf-8

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
    attr_accessible :role_id, :action, :subject_class, :subject_id, :sorter_id, :operator_id
    belongs_to :role
    PossibleSubjectClasses = [":all"] + ActiveRecord::Base.descendants.map(&:name)
    PossibleActions = ["read", "not_read", "manage", "not_manage", "update", "not_update", "destroy", "not_destroy"]

    validates_presence_of :action
    validates_presence_of :subject_class

    default_scope order("sorter_id ASC, id")
    scope :by_role, lambda{|rid| where(:role_id => rid)}
    before_create :set_min_sorter_id

    def self.restricted?(item)
      where(:subject_class => item.class, :subject_id => item.id).count > 0
    end

    def set_min_sorter_id
      last_permission = Permission.order(:created_at).last
      if last_permission.present? && ( self.sorter_id.blank? || self.sorter_id == 0 )
        self.sorter_id = last_permission.id + 1
      else
        self.sorter_id = 0
      end
    end
  end
end
