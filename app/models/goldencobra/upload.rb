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
      has_attached_file :image, 
                        :styles => { :large => "900x900>",:big => "600x600>", :medium => "300x300>", :thumb => "100x100>", :mini => "50x50>" },
                        :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                        :url => "/system/:attachment/:id/:style/:filename"
      before_post_process :image_file?
    end
    
    has_many :article_images, :class_name => Goldencobra::ArticleImage
    has_many :articles, :through => :article_images
    
    acts_as_taggable_on :tags
    
    def complete_list_name 
      result = ""
      result << "#{self.image_file_name} " if self.image_file_name.present?
      result << "(#{self.source}, #{self.rights}) " if self.source.present? || self.rights.present?
      result << "- #{self.created_at}"
    end
    
    def unzip_files
      if self.image_file_name.include?(".zip") && File.exists?(self.image.path)
        logger.info("===============   is a zip")
        require 'zip/zip'
        zipped_files = Zip::ZipFile.open(self.image.path)
        zipped_files.each do |zipped_file|
          if zipped_file.file? 
            zipped_file.extract("tmp/#{self.id}_#{zipped_file.name}")
            Goldencobra::Upload.create(:image => File.open("tmp/#{self.id}_#{zipped_file.name}"), 
                        :source => self.source, 
                        :rights => self.rights, 
                        :description => self.description, 
                        :tag_list => self.tag_list.join(", ") )
            File.delete("tmp/#{self.id}_#{zipped_file.name}")
          end
        end 
        self.destroy
      end   
    end
    
    def image_file?
      !(self.image_content_type =~ /^image.*/).nil?
    end
    
  end
end


