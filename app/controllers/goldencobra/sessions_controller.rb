require "bcrypt"

module Goldencobra
  class SessionsController < Goldencobra::ApplicationController
    layout "application"

    def login
      @errors = []
      if usermodel
        # search for user/visitor per email address
        @usermodel = usermodel.where(email: params[:loginmodel][:email]).first
        if @usermodel.blank? && usermodel.attribute_method?(:username)
          # if not found, search for visitor per email address
          # only visitor has attribute_method "username"
          @usermodel = usermodel.where(username: params[:loginmodel][:email]).first
        end
      end

      if @usermodel.present?
        if ::BCrypt::Password.new(@usermodel.encrypted_password) ==
           "#{params[:loginmodel][:password]}#{Devise.pepper}"
          sign_in @usermodel
          @usermodel.failed_attempts = 0
          @usermodel.sign_in_count = @usermodel.sign_in_count.to_i + 1
          @usermodel.last_sign_in_at = Time.now
          @usermodel.save
          flash[:notice] = I18n.translate("signed_in", scope: ["devise", "sessions"])
          @redirect_to = @usermodel.roles.try(:first).try(:redirect_after_login)
        else
          @usermodel.failed_attempts = @usermodel.failed_attempts.to_i + 1
          @usermodel.save
          @errors << "Wrong username or password"
        end
      else
        @errors << "No User found with this email"
      end
    end

    def logout
      if usermodel
        sign_out usermodel.to_s.downcase.to_sym
        reset_session
        flash[:notice] = I18n.translate("signed_out", scope: ["devise", "sessions"])
      end
      if request.format == "html"
        redirect_to "/"
      else
        render js: "window.location.href = '/';"
      end
    end

    def register
    end

    private

    def usermodel
      return false if params[:usermodel].blank?
      return false unless DEVISE_MODELS_WHITELIST.include?(params[:usermodel].to_s.downcase)

      params[:usermodel].constantize
    end
  end
end
