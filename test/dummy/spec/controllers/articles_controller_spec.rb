require 'spec_helper'

describe Goldencobra::ArticlesController do
  describe "render an rss feed" do
    before(:each) do
      @article = Goldencobra::Article.create(title: "Mein Artikel", url_name: "mein-artikel")
    end
    it "returns an RSS feed" do
      get :sitemap, format: "xml" #:show, :article_id => @article.url_name#, format: "rss"
      #response.should be_success
    end
  end
end
