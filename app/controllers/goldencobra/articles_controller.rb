module Goldencobra
  class ArticlesController < ApplicationController
    load_and_authorize_resource
    
    layout "application"
    
    def show
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
      if @article
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
    
  end
end