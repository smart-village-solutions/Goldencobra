class Visitors::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  #protect_from_forgery :except => [:google, :yahoo, :open_id, :facebook]

  def facebook
    callback("Facebook", :find_for_facebook_oauth)
  end

  def google
    callback("Google")
  end

  def yahoo
    callback("Yahoo")
  end

  def open_id
    callback("OpenID")
  end

  def passthru
    render :file => "#{Rails.root}/public/404", :status => 404, :layout => false
  end

  def failure
    render :file => "#{Rails.root}/public/404", :status => 404, :layout => false
  end


  protected

  def callback(kind, find_method = :find_for_open_id)
    @visitor = Visitor.send find_method, env["omniauth.auth"], current_visitor
    if @visitor.persisted?
      #flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => kind
      sign_in_and_redirect @visitor, :event => :authentication
    else
      session["devise.user_data"] = env["omniauth.auth"]
      redirect_to new_visitor_registration_url
    end
  end
end