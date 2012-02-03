# == Schema Information
#
# Table name: menues
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  target     :string(255)
#  css_class  :string(255)
#  active     :boolean(1)      default(TRUE)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  ancestry   :string(255)
#
module Goldencobra
  class Menue < ActiveRecord::Base
    has_ancestry :orphan_strategy => :rootify
    validates_presence_of :title    
    
    scope :active, where(:active => true)
    
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
    
  end
end