module Goldencobra
  class ArticlesController < Goldencobra::ApplicationController
    load_and_authorize_resource

    layout "application"
    before_filter :check_format
    before_filter :get_article, :only => [:show, :convert_to_pdf]
    before_filter :geocode_ip_address, only: [:show]

    caches_action :show, :cache_path => :show_cache_path.to_proc, :if => proc {@article && @article.present? && is_cachable?  }

    def show_cache_path
      if session[:user_location].present? && session[:user_location].latitude.present? && session[:user_location].longitude.present?
        loc = Goldencobra::Location.near([session[:user_location].latitude,session[:user_location].longitude], 500).limit(1).first
        if loc && loc.city.present?
          "goldencobra/#{params[:article_id]}/#{@article.cache_key if @article }_#{loc.city.downcase.parameterize}"
        else
          "goldencobra/#{params[:article_id]}/#{@article.cache_key if @article }"
        end
      else
        "goldencobra/#{params[:article_id]}/#{@article.cache_key if @article }"
      end
    end


    def show
      if @article && @article.external_url_redirect.blank?
        initialize_article(@article)
        Goldencobra::Article.load_liquid_methods(:location => session[:user_location], :article => @article, :params => params)
        if @article.article_type.present? && @article.article_type_form_file != "Default" && @article_type = @article.send(@article.article_type_form_file.downcase.to_sym)
          Goldencobra::Article::LiquidParser["#{@article.article_type_form_file.downcase}"] = @article_type
        elsif @article.article_type.present? && @article.kind_of_article_type.downcase == "index"
          @list_of_articles = Goldencobra::Article.active.articletype("#{@article.article_type_form_file} Show")
          @list_of_articles = @list_of_articles.includes("#{@article.article_type_form_file.downcase}") if @article.respond_to?(@article.article_type_form_file.downcase)
          @list_of_articles = @list_of_articles.tagged_with(@article.index_of_articles_tagged_with.split(","), on: :tags) if @article.index_of_articles_tagged_with.present?
          @list_of_articles = @list_of_articles.tagged_with(@article.not_tagged_with.split(","), :exclude => true, on: :tags) if @article.not_tagged_with.present?
          @list_of_articles = @list_of_articles.tagged_with(params[:frontend_tags], on: :frontend_tags, any: true) if params[:frontend_tags].present?
          # Sortierung
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
              #@list_of_articles = @list_of_articles.flatten.sort_by{|article| sort_order.inject(article){|result, message| result.send(message) if result.present? && a=result.send(message) && a.present?  } }
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

        # If the request is stale according to the given timestamp and etag value
        # (i.e. it needs to be processed again) then execute this block
        #
        # If the request is fresh (i.e. it's not modified) then you don't need to do
        # anything. The default render checks for this using the parameters
        # used in the previous call to stale? and will automatically send a
        # :not_modified.  So that's it, you're done.
        #
        if stale?(:last_modified => @article.date_of_last_modified_child, :etag => @article.id)
          expires_in 30.seconds, :public => true
          response.last_modified = @article.date_of_last_modified_child
          if params[:pdf] && params[:pdf].present? && params[:pdf] == "1"
            layout_to_render = "for_pdf"
          else
            layout_to_render = @article.selected_layout
          end
          respond_to do |format|

            format.html {render :layout => layout_to_render }
            format.rss
          end
        end
      elsif @article && @article.external_url_redirect.present?
        #redirect to external website
        redirect_to @article.external_url_redirect, :target => "_blank"
      else
        @article = Goldencobra::Article.find_by_url_name("404")
        if @article
          respond_to do |format|
            format.html {render :layout => @article.selected_layout, :status => 404}
          end
        else
          render :text => "404", :status => 404
        end
      end

    end

    def convert_to_pdf
      if @article
        require 'net/http'
        require "uri"
        uid = Goldencobra::Setting.for_key("goldencobra.html2pdf_uid")
        uri = URI.parse("http://html2pdf.ikusei.de/converter/new.xml?&uid=#{uid}&url=#{@article.absolute_public_url}#{CGI::escape('?pdf=1')}")
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
      @domain_name = Goldencobra::Setting.for_key("goldencobra.url")
      @articles = Goldencobra::Article.active.robots_index.select([:id, :url_name, :updated_at, :startpage])
      respond_to do |format|
        format.xml
      end
    end

    def get_article
      if params[:startpage] && (params[:startpage] == true || params[:startpage] == "true")
        @article = Goldencobra::Article.active.startpage.first
      else
        begin
          articles = Goldencobra::Article.active.where(:url_name => params[:article_id].split("/").last.to_s.split(".").first)
          if articles.count == 1
            @article = articles.first
          elsif articles.count > 1
            @article = articles.select{|a| a.public_url == "/#{params[:article_id].split('.').first}"}.first
          else
            @article = nil
          end
          if params[:article_id].present? && params[:article_id].include?(".")
            params[:format] = params[:article_id].split('.').last
          end
        rescue
          @article = nil
        end
      end
    end



    private

    def check_format
      if request.format == "image/jpeg"  || request.format == "image/png"
        render :text => "404", :status => 404
      end
    end

    def geocode_ip_address
      Goldencobra::Article::LiquidParser["user_location"] = "Test"
      if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
        if Goldencobra::Setting.for_key("goldencobra.geocode_ip_address") == "true"
          @ip_result = request.location
          session[:user_location] = request.location if session[:user_location].blank?
          if @ip_result && @ip_result.city.present?
            Goldencobra::Article::LiquidParser["user_location"] = @ip_result.city
          else
            Goldencobra::Article::LiquidParser["user_location"] = "berlin"
          end
        end
      end
    end

    def is_cachable?
      if @article.cacheable
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
