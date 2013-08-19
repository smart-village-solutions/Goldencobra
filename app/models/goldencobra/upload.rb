# == Schema Information
#
# Table name: goldencobra_uploads
#
#  id                 :integer          not null, primary key
#  source             :string(255)
#  rights             :string(255)
#  description        :text
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  attachable_id      :integer
#  attachable_type    :string(255)
#  alt_text           :string(255)
#  sorter_number      :integer
#

module Goldencobra
  class Upload < ActiveRecord::Base
    if ActiveRecord::Base.connection.table_exists?("goldencobra_uploads") &&
      ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
      has_attached_file :image,
                        :styles => { :large => ["900x900>", :jpg], :big => ["600x600>",:jpg], :medium => ["300x300>",:jpg], :px250 => ["250x250>",:jpg], :px200 => ["200x200>",:jpg], :px150 => ["150x150>",:jpg], :thumb => ["100x100>", :jpg], :mini => ["50x50>",:jpg] },
                        :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                        :url => "/system/:attachment/:id/:style/:filename",
                        :convert_options => { :all => "#{Goldencobra::Setting.for_key('goldencobra.upload.convert_options')}" },
                        :default_url => "missing_:style.png"
      before_post_process :image_file?
    end

    has_many :article_images, :class_name => Goldencobra::ArticleImage
    has_many :articles, :through => :article_images
    has_many :imports, :class_name => Goldencobra::Import
    belongs_to :attachable, polymorphic: true

    def title
      "#{self.image_file_name} (#{self.image_content_type})"
    end

    acts_as_taggable_on :tags

    def complete_list_name
      result = ""
      result << "#{self.image_file_name} " if self.image_file_name.present?
      result << "(#{self.source}, #{self.rights}) " if self.source.present? || self.rights.present?
      result << "- #{self.created_at}"
    end

    def unzip_files
      if self.image_file_name.include?(".zip") && File.exists?(self.image.path)
        require 'zip/zip'
        zipped_files = Zip::ZipFile.open(self.image.path)
        int = 0
        zipped_files.each do |zipped_file|
          int = int + 1
          if zipped_file.file?
            zipped_file.extract("tmp/#{self.id}_unzipped_#{int}.jpg")
            Goldencobra::Upload.create(:image => File.open("tmp/#{self.id}_unzipped_#{int}.jpg"),
                        :source => self.source,
                        :rights => self.rights,
                        :description => self.description,
                        :tag_list => self.tag_list.join(", ") )
            File.delete("tmp/#{self.id}_unzipped_#{int}.jpg")
          end
        end
      end
    end

    # Internal: Makes sure to only post-process files which are either pdf
    # or image files. Word documents would break file upload.
    #
    # No params
    #
    # Returns true for image or pdf files and false for everything else
    def image_file?
      !(self.image_content_type =~ /^image.*/).nil? || !(self.image_content_type =~ /pdf/).nil?
    end

  end
end


