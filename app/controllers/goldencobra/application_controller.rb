module Goldencobra
  class ApplicationController < ActionController::Base
    
    
    def s(name)
      if name.present?
        Goldencobra::Setting.for_key(name)
      end
    end
    
    
    
  end
end
