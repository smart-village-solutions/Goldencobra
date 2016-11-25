# encoding: utf-8

module Goldencobra
  class ApplicationController < ::ApplicationController
    before_filter :set_locale

    def set_locale
      if Rails.env == "test"
        I18n.locale = :de
      else
        I18n.locale = params[:locale] || session[:locale]
      end
    end

    def after_sign_out_path_for(resource_or_scope)
      request.referrer
    end

    def after_sign_in_path_for(resource_or_scope)
      request.referrer
    end

    def access_denied(exception)
      redirect_to root_path, alert: exception.message
    end

    rescue_from CanCan::AccessDenied do |exception|
      if can?(:read, Goldencobra::Article)
        redirect_to root_url, alert: exception.message
      else
        redirect_to "/admin", alert: exception.message
      end
    end

    def s(name)
      return unless name.present?
      Goldencobra::Setting.for_key(name)
    end

    def initialize_article(current_article)
      Goldencobra::Article::LiquidParser["current_article"] = current_article
      set_meta_tags current_article.combined_meta_tags
    end

    private

    # Catcher for undefined Goldencobra Callback Hooks
    def method_missing(meth, *args)
      unless [:before_init, :before_render, :after_init, :after_index].include?(meth.to_sym)
        super
      end
    end
  end
end
