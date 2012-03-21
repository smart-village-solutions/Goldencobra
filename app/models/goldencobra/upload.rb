# == Schema Information
#
# Table name: goldencobra_uploads
#
#  id                 :integer(4)      not null, primary key
#  source             :string(255)
#  rights             :string(255)
#  description        :text
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer(4)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

module Goldencobra
  class Upload < ActiveRecord::Base
    if ActiveRecord::Base.connection.table_exists?("goldencobra_uploads")
      has_attached_file :image, :styles => { :large => "900x900>",:big => "600x600>", :medium => "300x300>", :thumb => "100x100>", :mini => "50x50>" }
    end
    
    has_many :article_images, :class_name => Goldencobra::ArticleImage
    has_many :articles, :through => :article_images
    
    def complete_list_name 
      result = ""
      result << "#{self.image_file_name} " if self.image_file_name.present?
      result << "(#{self.source}, #{self.rights}) " if self.source.present? || self.rights.present?
      result << "- #{self.created_at}"
    end
  end
end
