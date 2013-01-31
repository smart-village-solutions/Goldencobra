require 'spec_helper'

describe Goldencobra::ArticlesController do
  before(:each) { @routes = Goldencobra::Engine.routes }
  describe ".rss" do
    before(:each) do
      @article = Goldencobra::Article.create(title: "Mein Artikel", url_name: "mein-artikel")
    end
    it "should return an RSS feed" do
      get :sitemap, format: "xml"
      response.should be_success
    end
  end

  describe  "permissions" do
    render_views
    before(:each) do
      Goldencobra::Setting.import_default_settings(::Rails.root + "../../config/settings.yml")
      Goldencobra::Permission.delete_all
      @parent_article = create :article
      @child_article = create :article, :parent_id => @parent_article.id
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

    it "should be possible to read an article as a visitor" do
      sign_in(:visitor, @visitor)
      visit @parent_article.public_url
      page.should have_content(@parent_article.title)
    end

    it "should be possible to read an article as an admin" do
      visit "/admin/logout"
      visit "/admin/login"
      fill_in "user[email]", :with => @user.email
      fill_in "user[password]", :with => @user.password
      click_button "Login"
      sign_in(:user, @user)
      visit "#{@parent_article.public_url}?auth_token=#{@user.authentication_token}"
      page.should have_content(@parent_article.title)
    end

    it "should be possible to read a secured article as an admin as a preview function" do
      create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :subject_id => @parent_article.id.to_s, :role_id => @admin_role.id, :sorter_id => 200
      sign_in(:user, @user)
      visit "#{@parent_article.public_url}?auth_token=#{@user.authentication_token}"
      page.should have_content(@parent_article.title)
    end

    it "should not be possible to read a secured article as a visitor" do
      create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => @parent_article.id
      sign_in(:visitor, @visitor)
      visit @parent_article.public_url
      page.should have_content("404")
    end

    it "should not be possible to read a secured article as a visitor for role guest" do
      create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => @parent_article.id, :role_id => @guest_role.id
      Goldencobra::Permission.last.subject_class.include?(":all").should == false
      a = Ability.new(@visitor)
      a.can?(:read, @parent_article).should == false
      a.cannot?(:read, @parent_article).should == true
      visit "#{@parent_article.public_url}?auth_token=#{@visitor.authentication_token}"
      page.should have_content("404")
    end

    it "should not be possible to read a secured article if not logged in" do
      create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => @parent_article.id
      visit @parent_article.public_url
      page.should have_content("404")
    end

    it "should not be possible to read an article with secured parent article as an visitor" do
      sign_in(:visitor, @visitor)
      create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :role_id => @guest_role.id, :sorter_id => 200, :subject_id => @parent_article.id
      visit "#{@child_article.public_url}?auth_token=#{@visitor.authentication_token}"
      page.should have_content("404")
    end

    it "should not be possible to read an article with secured parent article as a guest" do
      create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => @parent_article.id
      visit "#{@child_article.public_url}"
      page.should have_content("404")
    end

    it "should not be possible to read all articles if not logged in" do
      create :permission, :action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200
      visit @parent_article.public_url
      page.should have_content("404")
    end

  end

end
