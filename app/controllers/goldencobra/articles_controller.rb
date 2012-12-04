module Goldencobra
  class ArticlesController < Goldencobra::ApplicationController
    load_and_authorize_resource

    layout "application"
    before_filter :check_format
    before_filter :get_article, :only => [:show, :convert_to_pdf]
    before_filter :geocode_ip_address, only: [:show]

    if Goldencobra::Setting.for_key("goldencobra.article.cache_articles") == "true"
      caches_action :show, :cache_path => :show_cache_path.to_proc, :if => proc {@article && @article.present? && is_cachable?  }
    end

    def show_cache_path
      geo_cache = Goldencobra::Setting.for_key("goldencobra.geocode_ip_address") == "true" && session[:user_location].present? && session[:user_location].city.present? ? session[:user_location].city.parameterize.underscore : "no_geo"
      date_cache = Goldencobra::Setting.for_key("goldencobra.article.max_cache_24h") == "true" ? Date.today.strftime("%Y%m%d") : "no_date"
      art_cache = @article ? @article.cache_key : "no_art"
      user_cache = current_user.present? ? current_user.id : "no_user"

      "g/#{geo_cache}/#{user_cache}/#{date_cache}/#{params[:article_id]}/#{art_cache}_#{params[:pdf]}_#{params[:frontend_tags]}__#{params[:iframe]}"
    end

    def show
      before_init() if Goldencobra::ArticlesController.method_defined?(:before_init) #Goldencobra Callback Hook
      if serve_iframe?
        respond_to do |format|
          format.html { render layout: "/goldencobra/bare_layout" }
        end
      elsif serve_basic_article?
        initialize_article(@article)
        Goldencobra::Article.load_liquid_methods(location: session[:user_location], article: @article, params: params)

        load_associated_model_into_liquid() if can_load_associated_model?
        after_init() if Goldencobra::ArticlesController.method_defined?(:after_init) #Goldencobra Callback Hook

        if generate_index_list?
          @list_of_articles = get_articles_by_article_type
          include_related_models()
          get_articles_with_tags() if @article.index_of_articles_tagged_with.present?
          get_articles_without_tags() if @article.not_tagged_with.present?
          get_articles_by_frontend_tags() if params[:frontend_tags].present?
          sort_response()
          after_index() if Goldencobra::ArticlesController.method_defined?(:after_index) #Goldencobra Callback Hook
        end

        if serve_fresh_page?
          set_expires_in()
          layout_to_render = choose_layout()
          before_render() if Goldencobra::ArticlesController.method_defined?(:before_render) #Goldencobra Callback Hook
          respond_to do |format|
            format.html { render layout: layout_to_render }
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
        # Render 404 Article if no Article else is found
        redirect_to_404()
      end
    end

    def convert_to_pdf
      if @article
        require 'net/http'
        require "uri"
        uid = Goldencobra::Setting.for_key("goldencobra.html2pdf_uid")
        uri = URI.parse("http://html2pdf.ikusei.de/converter/new.xml?&print_layout=true&uid=#{uid}&url=#{@article.absolute_public_url}#{CGI::escape('?pdf=1')}")
        logger.debug(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        doc = Nokogiri::HTML(response.body)
        file = doc.at_xpath("//file-name").text
        redirect_to "http://html2pdf.ikusei.de#{file}"
      else
        render :text => "404", :status => 404
      end
    end


    def sitemap
      if Goldencobra::Setting.for_key("goldencobra.use_ssl") == "true"
        @use_ssl = "s"
      else
        @use_ssl = ""
      end
      @domain_name = Goldencobra::Setting.for_key("goldencobra.url")
      @articles = Goldencobra::Article.for_sitemap
      respond_to do |format|
        format.xml
      end
    end

    def get_article
      if is_startpage?
        @article = Goldencobra::Article.active.startpage.first
      else
        begin
          article_by_role
          set_format
        rescue
          @article = nil
        end
      end
    end

    private

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
      @article = Goldencobra::Article.find_by_url_name("404")
      if @article
        respond_to do |format|
          format.html { render :layout => @article.selected_layout, :status => 404 }
        end
      else
        render :text => "404", :status => 404
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

    def include_related_models
      @list_of_articles = @list_of_articles.includes("#{@article.article_type_form_file.downcase}") if @article.respond_to?(@article.article_type_form_file.downcase)
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
      !is_cachable? || stale?(last_modified: @article.date_of_last_modified_child, etag: @article.id)
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
    def sort_response
      if @article.sort_order.present?
        if @article.sort_order == "Random"
          @list_of_articles = @list_of_articles.flatten.shuffle
        elsif @article.sort_order == "Alphabetical"
          @list_of_articles = @list_of_articles.flatten.sort_by{|article| article.title }
        elsif @article.respond_to?(@article.sort_order)
          sort_order = @article.sort_order.downcase
          @list_of_articles = @list_of_articles.flatten.sort_by{|article| article.respond_to?(sort_order) ? article.send(sort_order) : article }
        elsif @article.sort_order.include?(".")
          sort_order = @article.sort_order.downcase.split(".")
          @list_of_articles = @list_of_articles.flatten.sort_by{|a| eval("a.#{@article.sort_order}") if a.respond_to_all?(@article.sort_order) }
        end
        if @article.reverse_sort
          @list_of_articles = @list_of_articles.reverse
        end
      end

      if @article.sorter_limit && @article.sorter_limit > 0
        @list_of_articles = @list_of_articles[0..@article.sorter_limit-1]
      end
    end

    def get_articles_with_tags
      @list_of_articles = @list_of_articles.tagged_with(@article.index_of_articles_tagged_with.split(",").map{|t| t.strip}, on: :tags)
    end

    def get_articles_without_tags
      @list_of_articles = @list_of_articles.tagged_with(@article.not_tagged_with.split(",").map{|t| t.strip}, :exclude => true, on: :tags)
    end

    def get_articles_by_frontend_tags
      @list_of_articles = @list_of_articles.tagged_with(params[:frontend_tags], on: :frontend_tags, any: true)
    end

    def get_articles_by_article_type
      @list_of_articles = Goldencobra::Article.active.articletype("#{@article.article_type_form_file} Show")
    end

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

    def article_by_role
      # Admins should get preview of article even if it's offline
      if current_user && current_user.has_role?('Admin')
        @article = Goldencobra::Article.search_by_url(params[:article_id])
      else
        @article = Goldencobra::Article.active.search_by_url(params[:article_id])
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
      if Goldencobra::Setting.for_key("goldencobra.article.cache_articles") == "true" && @article.cacheable
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
  end
end
