# == Schema Information
#
# Table name: goldencobra_menues
#
#  id                  :integer(4)      not null, primary key
#  title               :string(255)
#  target              :string(255)
#  css_class           :string(255)
#  active              :boolean(1)      default(TRUE)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  ancestry            :string(255)
#  sorter              :integer(4)      default(0)
#  description         :text
#  call_to_action_name :string(255)
#  description_title   :string(255)
#

module Goldencobra
  class Menue < ActiveRecord::Base
    has_ancestry :orphan_strategy => :rootify
    validates_presence_of :title   
    if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
      if Goldencobra::Setting.for_key("goldencobra.menues.recreate_cache") == "true"
        after_save 'Goldencobra::Article.recreate_cache'
      end
    end
    if ActiveRecord::Base.connection.table_exists?("versions")
      has_paper_trail
    end
    scope :active, where(:active => true).order(:sorter)
    scope :visible, where("css_class <> 'hidden'")
    
    scope :parent_ids_in_eq, lambda { |art_id| subtree_of(art_id) }
    search_methods :parent_ids_in_eq
    
    scope :parent_ids_in, lambda { |art_id| subtree_of(art_id) }
    search_methods :parent_ids_in
    
    
    def is_active?(request)
      request.path.squeeze("/").split("?")[0] == self.target.gsub("\"",'')
    end
    
    def has_active_child?(request)      
      self.descendants.map(&:target).include?(request.path.squeeze("/").split("?")[0])
    end
    
    def mapped_to_article?
      Goldencobra::Article.select([:url_name, :startpage, :ancestry, :id]).map{|a| a.public_url}.uniq.include?(self.target)
    end
        
  end
end
