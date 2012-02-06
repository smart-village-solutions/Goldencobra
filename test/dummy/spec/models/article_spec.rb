require 'spec_helper'

describe Goldencobra::Article do
  
  before(:each) do
    @attr = { :title  => "Testartikel", :url_name  => "testartikel" }
  end

  it "should create a new article given valid attributes" do
    Goldencobra::Article.create!(@attr)
  end

  it "should require a title" do
    no_name_article = Goldencobra::Article.new(@attr.merge(:title => ""))
    no_name_article.should_not be_valid
  end
  
  it "should require a url_name" do
    no_url_name_article = Goldencobra::Article.new(@attr.merge(:url_name => ""))
    no_url_name_article.should_not be_valid
  end
end