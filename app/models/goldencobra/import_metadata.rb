# encoding: utf-8

module Goldencobra
  class ImportMetadata < ActiveRecord::Base
  	ImportDataFunctions = []
    attr_accessible :database_admin_email, :database_admin_first_name,
                    :database_admin_last_name, :database_admin_phone,
                    :database_owner, :exported_at, :importmetatagable_id,
                    :importmetatagable_type

    belongs_to :importmetatagable, polymorphic: true
  end
end

# == Schema Information
#
# Table name: goldencobra_import_metadata
#
#  id                        :integer          not null, primary key
#  database_owner            :string(255)
#  exported_at               :datetime
#  database_admin_first_name :string(255)
#  database_admin_last_name  :string(255)
#  database_admin_phone      :string(255)
#  database_admin_email      :string(255)
#  importmetatagable_id      :integer
#  importmetatagable_type    :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
