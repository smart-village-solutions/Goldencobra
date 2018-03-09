# encoding: utf-8

module Goldencobra
  module Api
    module V2
      class SettingsController < ActionController::Base
        respond_to :html, :json, :text

        # /api/v2/setting_string
        # ---------------------------------------------------------------------------------------
        def get_string

          # get the translation for setting_key and return the locale value
          if params[:setting_key].present?
            setting = Goldencobra::Setting.for_key(params[:setting_key])
          else
            setting = ""
          end
          render inline: setting, status: 200
        end
      end
    end
  end
end
