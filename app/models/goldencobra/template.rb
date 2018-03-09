module Goldencobra
  class Template < ActiveRecord::Base
    attr_accessible :title, :layout_file_name

    # List all layout files found in folder /app/views/layouts
    #
    # @return [Array] List of file names
    def self.layouts_for_select
      Dir.glob(File.join(::Rails.root, "app", "views", "layouts", "*.html.erb"))
         .map { |a| File.basename(a, ".html.erb") }
         .delete_if { |a| a =~ /^_/ }
    end
  end
end

# == Schema Information
#
# Table name: goldencobra_templates
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  layout_file_name :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
