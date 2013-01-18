require 'spec_helper'

describe Goldencobra::ArticlesController do
  before(:each) { @routes = Goldencobra::Engine.routes }
  describe ".rss" do
    before(:each) do
      @routes = Goldencobra::Engine.routes
      @article = Goldencobra::Article.create(title: "Mein Artikel", url_name: "mein-artikel")
    end
    it "should return an RSS feed" do
      get :sitemap, format: "xml" #:show, :article_id => @article.url_name#, format: "rss"
      response.should be_success
    end
  end

  describe  "permissions" do
    render_views
    before(:each) do
      @routes = Goldencobra::Engine.routes
      @parent_article = create :article
      @child_article = create :article
      @user = create :user
      @visitor = create :visitor
      @admin_role = create :role, :name => "Admin"
      @guest_role = create :role, :name => "Guest"
      @user.roles << @admin_role
      @visitor.roles << @guest_role
    end
    it "should be possible to read an article if not logged in" do
      visit @parent_article.public_url
      page.should have_content(@parent_article.title)
    end
    it "should be possible to read an article if not logged in" do
      visit @parent_article.public_url
      page.should have_content(@parent_article.title)
    end
    it "should be possible to read an article as a visitor" do
      sign_in(:visitor, @visitor)
      create :permission, :action => "read", :subject_class => "Goldencobra::Article", :subject_id => @parent_article.id.to_s, :role_id => @guest_role.id, :sorter_id => 10
      visit @parent_article.public_url
      page.should have_content(@parent_article.title)
    end
    it "should be possible to read an article as an admin" do
      sign_in(:user, @user)
      create :permission, :action => "read", :subject_class => "Goldencobra::Article", :subject_id => @parent_article.id.to_s, :role_id => @admin_role.id, :sorter_id => 10
      visit @parent_article.public_url
      page.should have_content(@parent_article.title)
    end
    it "should not be possible to read an secured article as an admin" do
      sign_in(:user, @user)
      create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :subject_id => @parent_article.id.to_s, :role_id => @admin_role.id, :sorter_id => 10
      visit @parent_article.public_url
      Goldencobra::Permission.all.count.should == 1
      page.should have_content("You need to sign in or sign up before continuing")
    end
    it "should not be possible to read an secured article as an visitor" do
      sign_in(:visitor, @visitor)
      create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :subject_id => @parent_article.id.to_s, :role_id => @guest_role.id, :sorter_id => 10
      visit @parent_article.public_url
      page.should have_content("You need to sign in or sign up before continuing")
    end
    it "should not be possible to read an article with secured parent article as an visitor" do
      sign_in(:visitor, @visitor)
      create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :subject_id => @parent_article.id.to_s, :role_id => @guest_role.id, :sorter_id => 10
      visit @parent_article.public_url
      page.should have_content("You need to sign in or sign up before continuing")
    end
    it "should not be possible to read secured an article if not logged in" do
      # create :permission, :action => "read", :subject_class => "Goldencobra::Article", :sorter_id => 10
      # create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :subject_id => @parent_article.id.to_s, :sorter_id => 9
      visit @parent_article.public_url
      page.should have_content("You need to sign in or sign up before continuing")
    end

  end

end
