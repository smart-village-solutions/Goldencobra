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
        redirect_to root_url, :alert => exception.message
      else
        redirect_to "/admin", :alert => exception.message
      end
    end

    def s(name)
      if name.present?
        Goldencobra::Setting.for_key(name)
      end
    end

    def initialize_article(current_article)
      Goldencobra::Article::LiquidParser["current_article"] = current_article

      meta_tags = {
        :site => s('goldencobra.page.default_title_tag'),
        :title => current_article.metatag_title_tag.present? ? current_article.metatag_title_tag : current_article.title,
        :reverse => true,
        :description => current_article.metatag_meta_description,
        :open_graph => {
          :title => current_article.metatag_open_graph_title,
          :description => current_article.metatag_open_graph_description,
          :type => current_article.metatag_open_graph_type,
          :url => current_article.metatag_open_graph_url,
          :image => current_article.metatag_open_graph_mage
        }
      }

      if current_article.robots_no_index
        # with noindex for meta name="robots"
        meta_tags[:noindex] = current_article.robots_no_index
      end

      if current_article.canonical_url.present?
        # with an canonical_url for rel="canonical"
        meta_tags[:canonical] = current_article.canonical_url
      else
        d = Goldencobra::Domain.main
        if d.present? && @current_client.present? && @current_client.id != d.id
          meta_tags[:canonical] = "http://#{d.hostname}#{d.url_prefix}#{current_article.public_url(false)}"
        end
      end

      set_meta_tags meta_tags
    end

    private
    #Catcher for undefined Goldencobra Callback Hooks
    def method_missing(meth, *args)
      unless [:before_init, :before_render, :after_init, :after_index].include?(meth.to_sym)
        super
      end
    end

  end
end
