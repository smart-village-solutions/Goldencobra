module Goldencobra
  class Upload < ActiveRecord::Base
    if Goldencobra::Upload.table_exists?("goldencobra_uploads")
      has_attached_file :image, :styles => { :large => "900x900>",:big => "600x600>", :medium => "300x300>", :thumb => "100x100>", :mini => "50x50>" }
    end
  end
end
