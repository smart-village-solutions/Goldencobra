# encoding: utf-8

module Goldencobra
  module Api
    module V2
      class SettingsController < ActionController::Base

        respond_to :text

        # /api/v2/setting_string
        # ---------------------------------------------------------------------------------------
        def get_string
          # check if we have the argument
          unless params[:setting_key]
            render status: 200, text: ""
            return
          end

          # check if the setting_key contains something
          if params[:setting_key].length == 0
            render status: 200, text: ""
          else
            # get the translation for setting_key and return the locale value
            render status: 200, text: s(params[:setting_key])
          end
        end

      end
    end
  end
end