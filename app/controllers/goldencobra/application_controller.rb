module Goldencobra
  class ApplicationController < ActionController::Base    

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, :alert => exception.message
    end  
      
    def s(name)
      if name.present?
        Goldencobra::Setting.for_key(name)
      end
    end
    
  end
end
