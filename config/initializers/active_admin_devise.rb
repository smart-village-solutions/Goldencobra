require "activeadmin"

ApplicationController.class_eval do
    layout :layout_by_resource_for_user_model

    def current_ability
        @current_ability ||= Ability.new(current_user)
    end

    rescue_from CanCan::AccessDenied do |exception|
        redirect_to "/admin", :alert => exception.message
    end

    protected
    def layout_by_resource_for_user_model
      if devise_controller? && resource_name == :user
        "goldencobra/active_admin_resque" # we emulate the active_admin layout for consistancy
      else
        "application"
      end
    end
end
