module Goldencobra
  class ArticlesController < ApplicationController
    load_and_authorize_resource
    def show
      if params[:startpage] && (params[:startpage] == true || params[:startpage] == "true")
        @article = Goldencobra::Article.startpage.first
      else
        @article = Goldencobra::Article.find(params[:article_id].split("/").last)
      end
      if @article
        set_meta_tags :site => "Goldencobra",
                    :title => @article.metatag("Title Tag"),
                    :description => @article.metatag("Meta Description"), 
                    :keywords => @article.metatag("Keywords"),
                    :open_graph => {:title => @article.metatag("OpenGraph Title"), 
                                    :type => @article.metatag("OpenGraph Type"),
                                    :url => @article.metatag("OpenGraph URL"), 
                                    :image => @article.metatag("OpenGraph Image")}
      end
      
    end
  end
end