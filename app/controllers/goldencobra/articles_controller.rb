module Goldencobra
  class ArticlesController < ApplicationController
    load_and_authorize_resource
    def show
      if params[:startpage] && params[:startpage] == true && params[:article_id].blank?
        @article = Article.startpage.first
      else
        @article = Article.find(params[:article_id].split("/").last)
      end
      set_meta_tags :title => @article.metatag("Title Tag"),
                    :description => @article.metatag("Meta Description"), 
                    :keywords => @article.metatag("Keywords"),
                    :open_graph => {:title => @article.metatag("OpenGraph Title"), 
                                    :type => @article.metatag("OpenGraph Type"),
                                    :url => @article.metatag("OpenGraph URL"), 
                                    :image => @article.metatag("OpenGraph Image")}

    end
  end
end