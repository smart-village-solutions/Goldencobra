# encoding: utf-8

require 'spec_helper'

describe Goldencobra::Redirector do

  # it "should have a latitude and longitude" do
  #   location = Goldencobra::Location.create(:street => "Zossener Str. 55", :city => "Berlin", :zip => "10961")
  #   location.lat.should_not == nil
  #   location.lng.should_not == nil
  #   Goldencobra::Location.find_by_zip("10961").street.should == "Zossener Str. 55"
  # end

  #source_url
  #target_url
  it "should do nothing if no redirection is set" do
    redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/not_to_redirect")
    redirector.should == nil
  end

  describe 'if ignore_url_params is true without url params' do
    before(:each) do
      Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
    end

    #no url params given or set
    #ignore_url_params = true
    it "should not redirect on different url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/not_to_redirect")
      redirector.should == nil
    end

    it "should not redirect on similar but different url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiter")
      redirector.should == nil
    end

    it "should not redirect on similar but different url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitungen")
      redirector.should == nil
    end

    it "should redirect on same url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung")
      redirector.should == ["http://www.google.de", 301]
    end

    it "should not redirect on same url with and a given subdir" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung/test")
      redirector.should == nil
    end
  end


  describe 'if ignore_url_params is true with url params' do
    before(:each) do
      Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung?test=1", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
    end

    #ignore_url_params = true with given url params in redirection
    it "should not redirect on different url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/not_to_redirect")
      redirector.should == nil
    end

    it "should not redirect on similar but different url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiter")
      redirector.should == nil
    end

    it "should not redirect on similar but different url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitungen")
      redirector.should == nil
    end

    it "should redirect on same url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung")
      redirector.should == ["http://www.google.de", 301]
    end

    it "should not redirect on same url with and a given subdir" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung/test")
      redirector.should == nil
    end

    it "should redirect on same url with url params" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?test=1&foo=bar")
      redirector.should == ["http://www.google.de?test=1&foo=bar", 301]
    end
  end

  describe 'more URL variants' do

    #no url params given or set
    #ignore_url_params = true
    it "should not redirect on different url" do
      Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/not_to_redirect?test=2")
      redirector.should == nil
    end

    it "should not redirect on similar but different url" do
      Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiter?test=2")
      redirector.should == nil
    end

    it "should not redirect on similar but different url" do
      Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitungen?test=2")
      redirector.should == nil
    end

    it "should redirect on same url" do
      Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?test=2")
      redirector.should == ["http://www.google.de?test=2", 301]
    end

    it "should not redirect on same url with and a given subdir" do
      Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung/test?test=2")
      redirector.should == nil
    end

    it "should redirect on same url with url params" do
      Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung?test=1", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?test=1&foo=bar")
      redirector.should == ["http://www.google.de?test=1&foo=bar", 301]
    end



    it "should redirect on same url with url params" do
      Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung?test=1", :target_url => "www.google.de", :ignore_url_params => false, :active => true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?test=1")
      redirector.should == ["http://www.google.de?test=1", 301]
    end

    it "should not redirect on same url with url params" do
      Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung?test=1", :target_url => "www.google.de", :ignore_url_params => false, :active => true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?test=2")
      redirector.should == nil
    end

    it "should not redirect on same url with url params" do
      Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung?test=1", :target_url => "www.google.de", :ignore_url_params => false, :active => true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?foo=1")
      redirector.should == nil
    end

    it "should redirect on same url with url params" do
      Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung?test=1", :target_url => "www.google.de", :ignore_url_params => false, :active => true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?test=1&foo=bar")
      redirector.should == ["http://www.google.de?test=1&foo=bar", 301]
    end

    it "should redirect on same url with url params" do
      Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung?test=1", :target_url => "www.google.de", :ignore_url_params => false, :active => true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung")
      redirector.should == nil
    end

    it "should not redirect on same url with url params" do
      Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung?test=1&foo=1", :target_url => "www.google.de", :ignore_url_params => false, :active => true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?foo=1")
      redirector.should == nil
    end
  end


  describe 'if an article is modified, a redirection should be created' do
    before(:each) do
      Goldencobra::Setting.set_value_for_key("www.goldencobra.de", "goldencobra.url")
      @root = Goldencobra::Article.create(url_name: "startseite", breadcrumb: "Startseite", title: "Startseite", article_type: "Default Show")
      @root.mark_as_startpage!
      @seite1 = Goldencobra::Article.create(url_name: "seite1", breadcrumb: "Seite1", title: "Seite1", article_type: "Default Show", :parent => @root)
      @seite2 = Goldencobra::Article.create(url_name: "seite2", breadcrumb: "Seite2", title: "Seite2", article_type: "Default Show", :parent => @seite1)
      @seite3 = Goldencobra::Article.create(url_name: "seite3", breadcrumb: "Seite3", title: "Seite3", article_type: "Default Show", :parent => @seite1)
    end

    it "not on normal article editing" do
      @seite1.title = "Neue Seite1"
      @seite1.save
      Goldencobra::Redirector.all.count.should == 0
    end

    it "if url_name changed" do
      @seite3.absolute_public_url.should == "http://www.goldencobra.de/seite1/seite3"
      @seite3.url_name = "neue_seite3"
      @seite3.save
      @seite3.absolute_public_url.should == "http://www.goldencobra.de/seite1/neue_seite3"
      Goldencobra::Redirector.where(:source_url => "http://www.goldencobra.de/seite1/seite3", :target_url => "http://www.goldencobra.de/seite1/neue_seite3", :active => true).count.should == 1
    end

    it "if parent/ancestry changed for self" do
      @seite3.absolute_public_url.should == "http://www.goldencobra.de/seite1/seite3"
      @seite3.parent = @seite2
      @seite3.save
      @seite3.absolute_public_url.should == "http://www.goldencobra.de/seite1/seite2/seite3"
      puts Goldencobra::Redirector.all.inspect
      Goldencobra::Redirector.where(:source_url => "http://www.goldencobra.de/seite1/seite3", :target_url => "http://www.goldencobra.de/seite1/seite2/seite3", :active => true).count.should == 1
    end

    it "if parent/ancestry changed for childrens" do
      @seite1.absolute_public_url.should == "http://www.goldencobra.de/seite1"
      @seite1.url_name = "neue_seite1"
      @seite1.save
      @seite1.absolute_public_url.should == "http://www.goldencobra.de/neue_seite1"
      @seite3.absolute_public_url.should == "http://www.goldencobra.de/neue_seite1/seite3"
      Goldencobra::Redirector.where(:source_url => "http://www.goldencobra.de/seite1", :target_url => "http://www.goldencobra.de/neue_seite1", :active => true).count.should == 1
      Goldencobra::Redirector.where(:source_url => "http://www.goldencobra.de/seite1/seite3", :target_url => "http://www.goldencobra.de/neue_seite1/seite3", :active => true).count.should == 1
    end

    it "not if new article is created on existing redirection source_url" do
      Goldencobra::Redirector.create(:source_url => "http://www.goldencobra.de/neue_seite1", :target_url => "http://www.goldencobra.de/neue_seite2")
      Goldencobra::Article.create(url_name: "neue_seite1", breadcrumb: "Neue Seite1", title: "Neue Seite1", article_type: "Default Show", :parent => @root)
      Goldencobra::Redirector.where(:source_url => "http://www.goldencobra.de/neue_seite1", :active => true).count.should == 0
    end


  end


end
