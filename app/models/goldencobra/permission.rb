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
#  domain_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  sorter_id     :integer          default(0)
#

module Goldencobra
  class Permission < ActiveRecord::Base
    attr_accessible :role_id, :action, :subject_class, :subject_id, :sorter_id, :operator_id, :domain_id
    belongs_to :role
    belongs_to :domain
    PossibleSubjectClasses = [":all"] + ActiveRecord::Base.descendants.map(&:name)
    PossibleActions = ["read", "not_read", "manage", "not_manage", "update", "not_update", "destroy", "not_destroy"]

    validates_presence_of :action
    validates_presence_of :subject_class

    default_scope { order("sorter_id ASC, id") }
    scope :by_role, lambda{ |rid| where(:role_id => rid) }
    before_create :set_min_sorter_id
    after_commit :set_cache_key

    def self.restricted?(item)
      @@last_permission ||= Goldencobra::Permission.reorder(:updated_at).last
      cache_key = "#{@@last_permission.try(:cache_key)}-#{item.try(:cache_key)}"
      return Rails.cache.fetch(cache_key) do
        Goldencobra::Permission.where(subject_class: item.class, subject_id: item.id).count > 0
      end
    end

    def set_min_sorter_id
      last_permission = Permission.order(:created_at).last
      if last_permission.present? && ( self.sorter_id.blank? || self.sorter_id == 0 )
        self.sorter_id = last_permission.id + 1
      else
        self.sorter_id = 0
      end
    end

    private

    def set_cache_key
      @@last_permission = Goldencobra::Permission.reorder(:updated_at).last
      return true
    end
  end
end
