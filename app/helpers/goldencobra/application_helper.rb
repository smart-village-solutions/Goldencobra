module Goldencobra
  module ApplicationHelper    
    include Goldencobra::ArticlesHelper
    
    def s(name)
      if name.present?
        Goldencobra::Setting.for_key(name)
      end
    end
    
    
  end
end
