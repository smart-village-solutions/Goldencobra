# == Schema Information
#
# Table name: goldencobra_widgets
#
#  id             :integer(4)      not null, primary key
#  title          :string(255)
#  content        :text
#  css_name       :string(255)
#  active         :boolean(1)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  id_name        :string(255)
#  sorter         :integer(4)
#  mobile_content :text
#  teaser         :string(255)
#  default        :boolean(1)
#  description    :text
#

module Goldencobra
  class Widget < ActiveRecord::Base
    acts_as_taggable_on :tags

    has_many :article_widgets
    has_many :articles, :through => :article_widgets

    scope :active, where(:active => true).order(:sorter)
    scope :inactive, where(:active => false).order(:sorter)
    scope :default, where(:default => true).order(:sorter)

    if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
      if Goldencobra::Setting.for_key("goldencobra.widgets.recreate_cache") == "true"
        after_save 'Goldencobra::Article.recreate_cache'
      end
    end
    if ActiveRecord::Base.connection.table_exists?("versions")
      has_paper_trail
    end

    before_save :set_default_tag

    def set_default_tag
      self.tag_list = "sidebar" if self.tag_list.blank?
    end

  end
end
