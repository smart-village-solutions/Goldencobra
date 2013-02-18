module Goldencobra
  module Api
    module V1
      class TokensController < ActionController::Base

        respond_to :json, :xml

        def create
          email = params[:email]
          password = params[:password]

          if email.nil? || password.nil?
            render status: 400, json: { error: 'The request must contain ' +
                                            'the user email and password.' }
            return
          end

          @visitor = Visitor.find_by_email(email)

          if @visitor == nil
            render status: 401, json: { error: "Invalid email or password." }
            return
          end

          @visitor.ensure_authentication_token!

          if @visitor.valid_password?(password)
            render status: 200, json: { token: @visitor.authentication_token }
          else
            render status: 401, json: { error: "Invalid email or password." }
          end
        end
      end
    end
  end
end
