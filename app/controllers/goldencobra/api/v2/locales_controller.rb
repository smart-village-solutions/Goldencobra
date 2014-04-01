# encoding: utf-8

module Goldencobra
  module Api
    module V2
      class LocalesController < ActionController::Base

        respond_to :text

        # /api/v3/locale_string
        # ---------------------------------------------------------------------------------------
        def get_string
          # check if we have the argument
          unless params[:locale_key]
            render status: 200, text: ""
            return
          end

          # check if the locale_key contains something
          if params[:locale_key].length == 0
            render status: 200, text: ""
          else
            # get the translation for locale_key and return the locale value
            render status: 200, text: t(params[:locale_key])
          end
        end

      end
    end
  end
end