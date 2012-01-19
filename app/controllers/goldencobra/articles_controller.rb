module Goldencobra
  class ArticlesController < ApplicationController
    load_and_authorize_resource
    def show
      if params[:startpage] && params[:startpage] == true
        @article = Article.startpage.first
      else
        @article = Article.find(params[:id])
      end
      set_meta_tags :title => 'Member Login', :description => 'Member login page.', :keywords => 'Site, Login, Members'
    end
  end
end