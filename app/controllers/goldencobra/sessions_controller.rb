# encoding: utf-8

module Goldencobra
  class SessionsController < Goldencobra::ApplicationController
    layout "application"

    def login
      @errors = []
      if params[:usermodel] && params[:usermodel].constantize && params[:usermodel].constantize.present? && params[:usermodel].constantize.attribute_method?(:email)
        @usermodel = params[:usermodel].constantize.find_by_email(params[:loginmodel][:email])
        unless @usermodel && params[:usermodel].constantize.attribute_method?(:username)
          @usermodel = params[:usermodel].constantize.find_by_username(params[:loginmodel][:email])
        end
      end

      if @usermodel.present?
        if ::BCrypt::Password.new(@usermodel.encrypted_password) == "#{params[:loginmodel][:password]}#{Devise.pepper}"
          sign_in @usermodel
          @usermodel.failed_attempts = 0
          @usermodel.sign_in_count = @usermodel.sign_in_count.to_i + 1
          @usermodel.last_sign_in_at = Time.now
          @usermodel.save
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
      if params[:usermodel] && params[:usermodel].constantize && params[:usermodel].constantize.present? && params[:usermodel].constantize.attribute_method?(:email)
        sign_out
        reset_session
      end
      render :js => "window.location.href = '/';"
    end


    def register

    end


  end
end
