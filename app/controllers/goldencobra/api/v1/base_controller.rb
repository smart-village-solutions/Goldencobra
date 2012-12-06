module Goldencobra
  class Api::V1::BaseController < ActionController::Base
    respond_to :json, :xml

    before_filter :authenticate_user

    private
      def authenticate_user
        @current_visitor = Visitor.find_by_authentication_token(params[:token])
        unless @current_visitor
          error = { error: "The token is invalid" }
          respond_with(error, status: 401)
        end
      end
  end
end