# encoding: utf-8

require 'spec_helper'

describe Goldencobra::Article do

  describe 'moving article in articles-tree' do
    before(:each) do
      @attr = { :title  => "Testartikel", :article_type => "Default Show", :breadcrumb => 'bc_testarticle' }
    end

    it "should have a valid public_url before saving" do
      a = Goldencobra::Article.new(@attr)
      a.breadcrumb = "article1"
      expect(a.public_url).to eql("/")
      a.save
    end

    it "should have a valid public_url after saving" do
      a = Goldencobra::Article.new(@attr)
      a.breadcrumb = "article1"
      a.save
      expect(a.public_url).to eql("/article1")
    end

    it "should have a valid public_url after saving and reloading from db" do
      a = Goldencobra::Article.new(@attr)
      a.breadcrumb = "article1"
      a.save
      expect(Goldencobra::Article.find_by_id(a.id).public_url).to eql("/article1")
    end

    it "should have a valid url_path before saving" do
      a = Goldencobra::Article.new(@attr)
      a.breadcrumb = "article1"
      expect(a.url_path).to eql(nil)
      a.save
    end

    it "should have a valid url_path after saving" do
      a = Goldencobra::Article.new(@attr)
      a.url_name = "article1"
      a.save
      expect(a.url_path).to eql("/article1")
    end

    it "should have a valid url_path after saving and reloading from db" do
      a = Goldencobra::Article.new(@attr)
      a.url_name = "article1"
      a.save
      expect(Goldencobra::Article.find_by_id(a.id).url_path).to eql("/article1")
    end

  end

  describe 'creating an article' do
    before(:each) do
      @attr = { :title  => "Testartikel", :url_name  => "testartikel", :article_type => "Default Show", :breadcrumb => 'bc_testarticle' }
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
      expect(Goldencobra::Article.find_by_id(a.id).external_url_redirect).to eq "http://www.google.de"
    end

    it "should have a valid redirect url by inserting an url with https" do
      a = Goldencobra::Article.create!(@attr)
      a.external_url_redirect = "https://www.google.de"
      a.save
      expect(Goldencobra::Article.find_by_id(a.id).external_url_redirect).to eq "https://www.google.de"
    end

    it "should have no redirection if redirect url is empty" do
      a = Goldencobra::Article.create!(@attr)
      a.external_url_redirect = ""
      a.save
      Goldencobra::Article.find_by_id(a.id).external_url_redirect.should == ""
    end


    it "should create a new article given valid attributes" do
      Goldencobra::Article.create!(@attr)
    end

    it "should set active_since to the created_at datetime" do
      article = create :article
      article.active_since.should eql(article.created_at)
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
      1.upto(5) { |i|
        Goldencobra::Article.create!(@attr)
      }
      Goldencobra::Article.recent(5).collect.count.should == 5
    end
  end

  describe 'open graph' do
    it 'should have some metatags' do
      article = create :article
      article.metatags.count.should > 0
    end

    it "should set a default open graph title" do
      article = create :article
      Goldencobra::Metatag.where(name: 'OpenGraph Title', article_id: article.id).count.should == 1
    end

    it "should match the article's title" do
      article = create :article
      Goldencobra::Metatag.where(name: 'OpenGraph Title',
                                 article_id: article.id).first.value.should == article.title
    end

    it "should set a default OG url if none exists" do
      article = create :article
      Goldencobra::Metatag.where(name: 'OpenGraph URL', article_id: article.id).count.should == 1
    end

    it "should match the artices url" do
      article = create :article
      Goldencobra::Metatag.where(name: 'OpenGraph URL',
                                 article_id: article.id).first.value.should == article.absolute_public_url
    end

    it "should should set a default OG description" do
      article = create :article
      Goldencobra::Metatag.where(name: 'OpenGraph Description',
                                 article_id: article.id).count.should == 1
    end

    it "should match the article's teaser text" do
      article = create :article, teaser: 'Das ist ein kurzer Teaser Text.'
      Goldencobra::Metatag.where(name: 'OpenGraph Description',
                                 article_id: article.id).first.value.should == article.teaser
    end

    it "should match the article's content text if teaser is empty" do
      article = create :article, content: 'Sed ut perspiciatis unde omnis iste natus' +
      'error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ' +
      'ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.'
      Goldencobra::Metatag.where(name: 'OpenGraph Description',
                                 article_id: article.id).first.value.should == article.content.truncate(200)
    end

    it "should match the article's title if neither teaser nor content present" do
      article = create :article
      Goldencobra::Metatag.where(name: 'OpenGraph Description',
                                 article_id: article.id).first.value.should == article.title
    end
  end


  describe 'updating an article' do

    it "should have a new url_path" do
      article = create :article, :url_name => "seite1"
      sub_article = create :article, :url_name => "sub_seite", :parent => article

      expect(article.public_url.include?("seite1")).to eq true
      expect(sub_article.public_url.include?("seite1/sub_seite")).to eq true

      article.url_name = "seite2"
      article.save

      expect(article.public_url.include?("seite2")).to eq true
      expect(sub_article.public_url.include?("seite2/sub_seite")).to eq true
    end

  end

end
