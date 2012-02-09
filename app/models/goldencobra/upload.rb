module Goldencobra
  class Upload < ActiveRecord::Base
    if ActiveRecord::Base.connection.table_exists?("goldencobra_uploads")
      has_attached_file :image, :styles => { :large => "900x900>",:big => "600x600>", :medium => "300x300>", :thumb => "100x100>", :mini => "50x50>" }
    end
    
    def complete_list_name 
      result = ""
      result << "#{self.image_file_name} " if self.image_file_name.present?
      result << "(#{self.source}, #{self.rights}) " if self.source.present? || self.rights.present?
      result << "- #{self.created_at}"
    end
  end
end
