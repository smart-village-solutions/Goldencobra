module Goldencobra
  class ImportMetadata < ActiveRecord::Base
  	ImportDataFunctions = []
    attr_accessible :database_admin_email, :database_admin_first_name, :database_admin_last_name, :database_admin_phone, :database_owner, :exported_at, :importmetatagable_id, :importmetatagable_type
    belongs_to :importmetatagable, polymorphic: true
  end
end
