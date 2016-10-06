# encoding: utf-8

module Goldencobra
  module ApplicationHelper
    include Goldencobra::ArticlesHelper
    include Goldencobra::NavigationHelper
    include Goldencobra::LoginHelper

    def s(name)
      if name.present?
        Goldencobra::Setting.for_key(name)
      end
    end

    def bugtracker
      user_mod = Goldencobra::Setting.for_key("goldencobra.bugherd.user")
      role_mod = Goldencobra::Setting.for_key("goldencobra.bugherd.role")
      bugherd_api = Goldencobra::Setting.for_key("goldencobra.bugherd.api")
      if bugherd_api.present? && user_mod.present? && role_mod.present? && eval("!defined?(#{user_mod}).nil? && #{user_mod} && #{user_mod}.present? && #{user_mod}.has_role?('#{role_mod}')")
        render partial: "goldencobra/articles/bugherd", locals: {bugherd_api: bugherd_api}
      end
    end

    def edit_article_link
      render partial: "goldencobra/articles/edit_article_link"
    end

    def basic_goldencobra_headers(options={})
      render partial: "/goldencobra/articles/headers", locals: {options: options}
    end


    # Named routes outside mounted rails engine
    # You can call any named route defined in your railsapp
    # inside a goldencobra_view by calling:
    #
    # <%= link_to "CustomRoute", application_routes.custom_page_path() %>
    #
    # @return [UrlHelpers]
    def application_routes
      Rails.application.routes.url_helpers
    end
  end
end
