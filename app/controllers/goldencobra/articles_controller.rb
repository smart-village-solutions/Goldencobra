module Goldencobra
  class ArticlesController < ApplicationController
    load_and_authorize_resource

    layout "application"
    before_filter :get_article, :only => [:show]

    caches_action :show, :cache_path => :show_cache_path.to_proc, :if => proc {@article && @article.present? && @article.cacheable ? true : false }

    def show_cache_path
      "goldencobra/#{params[:article_id]}/#{@article.cache_key if @article }"
    end


    def show
      if @article
        Goldencobra::Article::LiquidParser["current_article"] = @article
        if @article.article_type.present? && @sym = @article.send(@article.article_type_form_file.downcase.to_sym)
          Goldencobra::Article::LiquidParser["#{@article.article_type_form_file.downcase}"] = @sym
        end

        set_meta_tags :site => Goldencobra::Setting.for_key("goldencobra.page.default_title_tag"),
                      :title => @article.metatag("Title Tag"),
                      :description => @article.metatag("Meta Description"), 
                      :keywords => @article.metatag("Keywords"),
                      :canonical => @article.canonical_url,
                      :noindex => @article.robots_no_index,
                      :open_graph => {:title => @article.metatag("OpenGraph Title"), 
                                    :type => @article.metatag("OpenGraph Type"),
                                    :url => @article.metatag("OpenGraph URL"), 
                                    :image => @article.metatag("OpenGraph Image")}
        respond_to do |format|
          format.html {render :layout => @article.selected_layout}
        end
      else
        @article = Goldencobra::Article.find_by_url_name("404")
        if @article
          respond_to do |format|
            format.html {render :layout => @article.selected_layout}
          end
        else
          render :text => "404", :status => 404
        end
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
          articles = Goldencobra::Article.active.where(:url_name => params[:article_id].split("/").last)
          if articles.count == 1
            @article = articles.first
          elsif articles.count > 1
            @article = articles.select{|a| a.public_url == "/#{params[:article_id]}"}.first
          else
            @article = nil
          end
        rescue
          @article = nil
        end
      end
    end

  end
end
