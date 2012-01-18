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
    
  end
end