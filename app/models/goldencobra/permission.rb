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
#

module Goldencobra
  class Permission < ActiveRecord::Base
    attr_accessible :role_id, :action, :subject_class, :subject_id, :sorter_id
    belongs_to :role

    default_scope order("sorter_id DESC")
    scope :by_role, lambda{|rid| where(:role_id => rid)}
  end
end
