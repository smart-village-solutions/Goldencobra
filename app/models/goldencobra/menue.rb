# == Schema Information
#
# Table name: goldencobra_menues
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  target     :string(255)
#  css_class  :string(255)
#  active     :boolean(1)      default(TRUE)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  ancestry   :string(255)
#  sorter     :integer(4)      default(0)
#

module Goldencobra
  class Menue < ActiveRecord::Base
    has_ancestry :orphan_strategy => :rootify
    validates_presence_of :title   
    after_save :recreate_article_cache 
    
    scope :active, where(:active => true).order(:sorter)
    
    scope :parent_ids_in_eq, lambda { |art_id| subtree_of(art_id) }
    search_methods :parent_ids_in_eq
    
    scope :parent_ids_in, lambda { |art_id| subtree_of(art_id) }
    search_methods :parent_ids_in
    
    
    def is_active?(request)
      request.path.squeeze("/").split("?")[0] == self.target.gsub("\"",'')
    end
    
    def has_active_child?(request)
      result = []
      self.descendants.each do |desc|
        result << request.path.squeeze("/").split("?")[0] == desc.target.gsub("\"",'')
      end
      return result.include?(true)
    end
    
    def recreate_article_cache
      Goldencobra::Article.all.each do |article|
        article.updated_at = Time.now
        article.save
      end
    end
    
  end
end
