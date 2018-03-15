# encoding: utf-8

module Goldencobra
  class ArticletypeField < ActiveRecord::Base
    attr_accessible :articletype_group_id, :class_name, :fieldname, :sorter

    belongs_to :group, class_name: Goldencobra::ArticletypeGroup,
                      foreign_key: :articletype_group_id

    default_scope { order(:sorter) }
  end
end

# == Schema Information
#
# Table name: goldencobra_articletype_fields
#
#  id                   :integer          not null, primary key
#  articletype_group_id :integer
#  fieldname            :string(255)
#  sorter               :integer          default(0)
#  class_name           :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
