module Goldencobra
  class ApplicationController < ActionController::Base    

    rescue_from CanCan::AccessDenied do |exception|
      if can?(:read, Goldencobra::Article)
        redirect_to root_url, :alert => exception.message
      else
        redirect_to admin_dashboard_path, :alert => exception.message
      end
    end  
      
    def s(name)
      if name.present?
        Goldencobra::Setting.for_key(name)
      end
    end
    
  end
end
