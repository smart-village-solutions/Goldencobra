module Goldencobra
  module LoginHelper

    def render_login_widget(usermodel_name)
      render :partial => "/goldencobra/sessions/login", :locals => {:usermodel => usermodel_name}
    end

    def render_registration_widget(usermodel_name)
      render :partial => "/goldencobra/sessions/register", :locals => {:usermodel => usermodel_name}
    end

  end
end