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
      if @article && @article.external_url_redirect.blank?
        Goldencobra::Article::LiquidParser["current_article"] = @article
        if @article.article_type.present? && @article_type = @article.send(@article.article_type_form_file.downcase.to_sym)
          Goldencobra::Article::LiquidParser["#{@article.article_type_form_file.downcase}"] = @article_type
        elsif @article.article_type.present? && @article.kind_of_article_type.downcase == "index"
          @list_of_articles = Goldencobra::Article.where(:article_type => "#{@article.article_type_form_file} Show")
          @list_of_articles = @list_of_articles.tagged_with(@article.index_of_articles_tagged_with.split(",")) if @article.index_of_articles_tagged_with.present?

          # Sortierung
          if @article.sort_order.present?
            if @article.sort_order == "Random"
              @list_of_articles = @list_of_articles.flatten.shuffle!
            elsif @article.sort_order == "Alphabetical"
              @list_of_articles = @list_of_articles.flatten.sort_by!{|article| article.title }
            else
              sort_order = @article.sort_order.downcase
              @list_of_articles = @list_of_articles.flatten.sort_by!{|article| article.send(sort_order) ? article.send(sort_order) : article }
            end
            if @article.reverse_sort
              @list_of_articles = @list_of_articles.reverse
            end
          end
        end

        set_meta_tags :site => s("goldencobra.page.default_title_tag"),
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
      elsif @article && @article.external_url_redirect.present?
        #redirect to external website
        redirect_to @article.external_url_redirect, :target => "_blank"
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
