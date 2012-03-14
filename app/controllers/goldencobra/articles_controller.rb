module Goldencobra
  class ArticlesController < ApplicationController
    load_and_authorize_resource
    
    layout "osterlayout"
    
    def show
      if params[:startpage] && (params[:startpage] == true || params[:startpage] == "true")
        @article = Goldencobra::Article.active.startpage.first
      else
        begin
          @article = Goldencobra::Article.active.find(params[:article_id].split("/").last)
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
        render :text => "404", :status => 404
      end
      
    end
  end
end