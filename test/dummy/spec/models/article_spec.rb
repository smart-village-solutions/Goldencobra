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
  
  it "should not display partial in templatefiles" do
    File.new("#{::Rails.root}/app/views/layouts/tim_test.html.erb", "w")
    File.new("#{::Rails.root}/app/views/layouts/_partial.html.erb", "w")
    File.new("#{::Rails.root}/app/views/layouts/_partial_2.html.erb", "w")
    File.new("#{::Rails.root}/app/views/layouts/12layout.html.erb", "w")
    
    Goldencobra::Article.templates_for_select.include?("tim_test").should == true
    Goldencobra::Article.templates_for_select.include?("_partial").should == false
    Goldencobra::Article.templates_for_select.include?("_partial_2").should == false
    Goldencobra::Article.templates_for_select.include?("application").should == true
    Goldencobra::Article.templates_for_select.include?("12layout").should == true
    
    File.delete("#{::Rails.root}/app/views/layouts/tim_test.html.erb")
    File.delete("#{::Rails.root}/app/views/layouts/_partial.html.erb")
    File.delete("#{::Rails.root}/app/views/layouts/_partial_2.html.erb")    
    File.delete("#{::Rails.root}/app/views/layouts/12layout.html.erb")
  end
  
end