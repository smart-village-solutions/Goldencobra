# == Schema Information
#
# Table name: goldencobra_menues
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  target              :string(255)
#  css_class           :string(255)
#  active              :boolean          default(TRUE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  ancestry            :string(255)
#  sorter              :integer          default(0)
#  description         :text
#  call_to_action_name :string(255)
#  description_title   :string(255)
#

module Goldencobra
  class Menue < ActiveRecord::Base
    has_ancestry :orphan_strategy => :rootify
    validates_presence_of :title   
    after_save 'Goldencobra::Article.recreate_cache'
    has_paper_trail
    scope :active, where(:active => true).order(:sorter)
    
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
        
  end
end
