require 'spec_helper'

describe Goldencobra::Article do
  
  before(:each) do
    @attr = { :title  => "Testartikel", :url_name  => "testartikel" }
  end
  
  it "should have a valid redirect url by inserting an url without http" do
    a = Goldencobra::Article.create!(@attr)
    a.external_url_redirect = "www.google.de"
    a.save
    Goldencobra::Article.find_by_id(a.id).external_url_redirect.should == "http://www.google.de"
  end

  it "should have a valid redirect url by inserting an url with http" do
    a = Goldencobra::Article.create!(@attr)
    a.external_url_redirect = "http://www.google.de"
    a.save
    Goldencobra::Article.find_by_id(a.id).external_url_redirect.should == "http://www.google.de"
  end

  it "should create a new article given valid attributes" do
    Goldencobra::Article.create!(@attr)
  end

  it "should require a title" do
    no_name_article = Goldencobra::Article.new(@attr.merge(:title => ""))
    no_name_article.should_not be_valid
  end
  
  it "should not require a url_name because it is filled automatically" do
    no_url_name_article = Goldencobra::Article.new(@attr.merge(:url_name => ""))
    no_url_name_article.should be_valid
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
  
  it "should return a list of 5 last modified articles" do
    Goldencobra::Article.create(title: "Blah")
    Goldencobra::Article.create(title: "Blah2")
    Goldencobra::Article.create(title: "Blah3")
    Goldencobra::Article.create(title: "Blah4")
    Goldencobra::Article.create(title: "Blah5")
    Goldencobra::Article.recent(5).collect.count.should == 5
  end
end
