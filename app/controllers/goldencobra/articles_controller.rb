module Goldencobra
  class ArticlesController < Goldencobra::ApplicationController
    layout "application"
    before_filter :check_format
    before_filter :get_article, :only => [:show, :convert_to_pdf]
    before_filter :verify_token, :only => [:show]
    before_filter :geocode_ip_address, only: [:show]
    after_filter :analytics, :only => [:show]

    if Goldencobra::Setting.for_key("goldencobra.article.cache_articles") == "true"
      caches_action :show, :cache_path => :show_cache_path.to_proc, :if => proc {@article && @article.present? && is_cachable?  }
    end

    def show_cache_path
      geo_cache = Goldencobra::Setting.for_key("goldencobra.geocode_ip_address") == "true" && session[:user_location].present? && session[:user_location].city.present? ? session[:user_location].city.parameterize.underscore : "no_geo"
      date_cache = Goldencobra::Setting.for_key("goldencobra.article.max_cache_24h") == "true" ? Date.today.strftime("%Y%m%d") : "no_date"
      art_cache = @article ? @article.cache_key : "no_art"
      user_cache = current_user.present? ? current_user.id : "no_user"
      flash_message = session.present? && session['flash'].present? ? Time.now.to_i : ""
      auth_code = params[:auth_token].present? ? 'with_auth' : ''
      "g/#{I18n.locale.to_s}/#{geo_cache}/#{user_cache}/#{date_cache}/#{params[:article_id]}/#{art_cache}_#{params[:pdf]}_#{params[:frontend_tags]}__#{params[:iframe]}#{flash_message}_#{auth_code}"
    end


    def show
      #flash[:confirmation] = "test"
      ActiveSupport::Notifications.instrument("goldencobra.article.show", :params => params)  #Possible Callbacks on start
      before_init() #Possible Callbacks on start
      if serve_iframe?
        respond_to do |format|
          format.html { render layout: "/goldencobra/bare_layout" }
        end
      elsif serve_basic_article?
        initialize_article(@article)
        Goldencobra::Article.load_liquid_methods(location: session[:user_location], article: @article, params: params)
        Goldencobra::Article::LiquidParser["url_params"] = params
        load_associated_model_into_liquid() if can_load_associated_model?
        after_init()

        if generate_index_list?
          current_operator = current_user || current_visitor
          @list_of_articles = @article.index_articles(current_operator,params[:frontend_tags])
          after_index()
        end

        if serve_fresh_page?
          set_expires_in()
          ActiveSupport::Notifications.instrument("goldencobra.article.render", :params => params)
          before_render()
          respond_to do |format|
            format.html { render layout: choose_layout() }
            format.rss
            format.json do
              @article["list_of_articles"] = @list_of_articles
              render json: @article.to_json
            end
          end
        end
      elsif should_statically_redirect?
        redirect_to @article.external_url_redirect
      elsif should_dynamically_redirect?
        redirect_dynamically()
      else
        if @unauthorized
          redirect_to_401()
        else
          redirect_to_404()
        end
      end
    end

    def switch_language
      I18n.locale = params[:locale] || session[:locale]
      session[:locale] = I18n.locale
      if params[:redirect_to].present?
        redirect_to params[:redirect_to]
      else
        redirect_to "/"
      end
    end

    # def convert_to_pdf
    #   if @article
    #     require 'net/http'
    #     require "uri"
    #     uid = Goldencobra::Setting.for_key("goldencobra.html2pdf_uid")
    #     uri = URI.parse("http://html2pdf.ikusei.de/converter/new.xml?&print_layout=true&uid=#{uid}&url=#{@article.absolute_public_url}#{CGI::escape('?pdf=1')}")
    #     logger.debug(uri)
    #     http = Net::HTTP.new(uri.host, uri.port)
    #     request = Net::HTTP::Get.new(uri.request_uri)
    #     response = http.request(request)
    #     doc = Nokogiri::HTML(response.body)
    #     file = doc.at_xpath("//file-name").text
    #     redirect_to "http://html2pdf.ikusei.de#{file}"
    #   else
    #     render :text => "404", :status => 404
    #   end
    # end


    def sitemap
      if Goldencobra::Setting.for_key("goldencobra.use_ssl") == "true"
        @use_ssl = "s"
      else
        @use_ssl = ""
      end
      @domain_name = Goldencobra::Setting.for_key("goldencobra.url")
      @articles = Goldencobra::Article.for_sitemap
      #TODO: authorize! :read, @article
      respond_to do |format|
        format.xml
      end
    end

    private

    def verify_token
      if params[:auth_token].present?
        unless current_visitor || current_user
          render :text => "Nicht authorisiert", :status => 401
        end
      end
    end

    def get_article
      if is_startpage?
        I18n.locale = :de
        @article = Goldencobra::Article.active.startpage.first
      else
        begin
          set_locale_by_url
          article_by_role
          set_format
        rescue
          @article = nil
        end
      end
    end


    # ------------------ Redirection ------------------------------------------
    def redirect_dynamically
      target_article = @article.find_related_subarticle
      if target_article.present?
        redirect_to target_article.public_url
      else
        redirect_to_404
      end
    end

    def should_statically_redirect?
      @article && @article.external_url_redirect.present?
    end

    def should_dynamically_redirect?
      @article && !(@article.dynamic_redirection == "false")
    end

    def redirect_to_404
      ActiveSupport::Notifications.instrument("goldencobra.article.not_found", :params => params)
      @article = Goldencobra::Article.find_by_url_name("404")
      if @article
        respond_to do |format|
          format.html { render :layout => @article.selected_layout, :status => 404 }
        end
      else
        render :text => "404", :status => 404
      end
    end

    def redirect_to_401
      ActiveSupport::Notifications.instrument("goldencobra.article.not_authorized", :params => params)
      @article = Goldencobra::Article.find_by_url_name("401")
      if @article
        respond_to do |format|
          format.html { render :layout => @article.selected_layout, :status => 401 }
        end
      else
        render :text => "401: Nicht authorisiert", :status => 401
      end
    end
    # ------------------ /Redirection -----------------------------------------


    # ------------------ associated models ------------------------------------
    def can_load_associated_model?
      @article.article_type.present? && @article.article_type_form_file != "Default" && @article_type = @article.send(@article.article_type_form_file.downcase.to_sym)
    end

    def load_associated_model_into_liquid
      Goldencobra::Article::LiquidParser["#{@article.article_type_form_file.downcase}"] = @article_type
    end

    # ------------------ /associated models -----------------------------------

    # ------------------ choose article to render -----------------------------
    def generate_index_list?
      @article.article_type.present? && @article.kind_of_article_type.downcase == "index"
    end

    def serve_iframe?
      @article && params["iframe"].present? && params["iframe"] == "true"
    end

    def serve_basic_article?
      @article && @article.external_url_redirect.blank? && @article.dynamic_redirection == "false"
    end

    def serve_fresh_page?
      if request.format == 'application/rss+xml'
        stale?(last_modified: @article.date_of_last_modified_child, etag: @article)
      else
        !is_cachable? || stale?(last_modified: @article.date_of_last_modified_child, etag: @article)
      end
      # If the request is stale according to the given timestamp and etag value
      # (i.e. it needs to be processed again) then execute this block
      #
      # If the request is fresh (i.e. it's not modified) then you don't need to do
      # anything. The default render checks for this using the parameters
      # used in the previous call to stale? and will automatically send a
      # :not_modified.  So that's it, you're done.
      #
    end

    def choose_layout
      if params[:pdf] && params[:pdf].present? && params[:pdf] == "1"
        "for_pdf"
      else
        @article.selected_layout
      end
    end
    # ------------------ /choose article to render ----------------------------

    # ------------------ adjust response --------------------------------------

    def set_expires_in
      if is_cachable?
        expires_in 30.seconds, :public => true
        response.last_modified = @article.date_of_last_modified_child
      else
        expires_in 1.seconds, :public => true
        response.last_modified = Time.now
      end
    end


    def set_format
      if params[:article_id].present? && params[:article_id].include?(".")
        params[:format] = params[:article_id].split('.').last
      end
    end
    # ------------------ /adjust response -------------------------------------

    def set_locale_by_url
      locale_article = params[:article_id].split("/").first
      if I18n.available_locales.include?(locale_article.to_sym)
        I18n.locale = locale_article
        session[:locale] = I18n.locale
      else
        if session[:locale].present?
          I18n.locale = session[:locale]
        end
      end
    end


    def article_by_role
      # Admin should get preview of article even if it's offline
      if current_user && current_user.has_role?(Goldencobra::Setting.for_key("goldencobra.article.preview.roles").split(",").map{|a| a.strip})
        @article = Goldencobra::Article.search_by_url(params[:article_id])
      else
        article = Goldencobra::Article.active.search_by_url(params[:article_id])
        if article
          operator = current_user || current_visitor
          a = Ability.new(operator)
          if a.can?(:read, article)
            @article = article
          else
            @unauthorized = true
          end
        end
      end
    end


    def is_startpage?
      startpage = params[:startpage]
      startpage && (startpage == true || startpage == "true")
    end


    def check_format
      if request.format == "image/jpeg"  || request.format == "image/png"
        render :text => "404", :status => 404
      end
    end

    def geocode_ip_address
      if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
        if Goldencobra::Setting.for_key("goldencobra.geocode_ip_address") == "true"
          if session[:user_location].blank?
            #Geokit::Geocoders::MultiGeocoder.geocode("194.39.218.11") schlägt fehl (Completed 500 Internal Server Error) daher...
            begin
                @ip_result = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
                session[:user_location] = @ip_result
            rescue Exception => e
              logger.error("***********")
              logger.error(e)
              @ip_result = nil
            end
            if @ip_result.present? && @ip_result.city.present?
              Goldencobra::Article::LiquidParser["user_location"] = @ip_result.city
            else
              Goldencobra::Article::LiquidParser["user_location"] = "Berlin"
            end
          else
            Goldencobra::Article::LiquidParser["user_location"] = session[:user_location].city
          end
        end
      end
    end

    def is_cachable?
      if session.present? && session['flash'].present?
        return false
      end
      if Goldencobra::Setting.for_key("goldencobra.article.cache_articles") == "true" && @article.cacheable
        #Wenn es einen current_user gibt, dann kein caching
        Devise.mappings.keys.each do |key|
          if eval("current_#{key.to_s}.present?")
            return false
          end
        end
        return true
      else
        return false
      end
    end

    def analytics
      Goldencobra::Tracking.analytics(request, session[:user_location])
    end


  end
end
