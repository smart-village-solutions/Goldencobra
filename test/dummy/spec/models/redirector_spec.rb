# encoding: utf-8

require 'spec_helper'

describe Goldencobra::Redirector do

  #source_url
  #target_url
  it "should do nothing if no redirection is set" do
    redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/not_to_redirect")
    expect(redirector).to eq nil
  end

  describe 'if url includes üöä' do
    before(:each) do
      Goldencobra::Setting.set_value_for_key("http://www.google.de", 
                                             "goldencobra.url", 
                                             data_type_name="string")
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiteröleitung", 
                                     target_url: "www.google.de", 
                                     ignore_url_params: true, 
                                     active: true)
    end

    it "should not break" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiteröleitung")
      expect(redirector).to eq ["http://www.google.de", 301]
    end
  end

  describe 'if ignore_url_params is true without url params' do
    before(:each) do
      Goldencobra::Setting.set_value_for_key("http://www.google.de", "goldencobra.url", data_type_name="string")
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung", 
                                     target_url: "www.google.de", 
                                     ignore_url_params: true, 
                                     active: true)
    end

    #no url params given or set
    #ignore_url_params = true
    it "should not redirect on different url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/not_to_redirect")
      expect(redirector).to eq nil
    end

    it "should not redirect on similar but different url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiter")
      expect(redirector).to eq nil
    end

    it "should not redirect on similar but different url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitungen")
      expect(redirector).to eq nil
    end

    it "should redirect on same url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung")
      expect(redirector).to eq ["http://www.google.de", 301]
    end

    it "should not redirect on same url with and a given subdir" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung/test")
      expect(redirector).to eq nil
    end
  end

  describe 'if ignore_url_params is true with url params on target' do
    before(:each) do
      Goldencobra::Setting.set_value_for_key("http://www.google.de", 
                                             "goldencobra.url", 
                                             data_type_name="string")
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung", 
                                     target_url: "www.yourdomain.de/weiterleitung?test=123", 
                                     ignore_url_params: true, 
                                     active: true)
    end

    it "should redirect on same url with url params" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung")
      expect(redirector).to eq ["http://www.yourdomain.de/weiterleitung?test=123", 301]
    end

    it "should redirect on same url with url params" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?foo=bar")
      expect(redirector).to eq ["http://www.yourdomain.de/weiterleitung?foo=bar&test=123", 301]
    end

    it "should redirect on same url with url params" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?test=1234")
      expect(redirector).to eq ["http://www.yourdomain.de/weiterleitung?test=1234", 301]
    end

  end

  describe 'if ignore_url_params is true with url params on source' do
    before(:each) do
      Goldencobra::Setting.set_value_for_key("http://www.google.de", 
                                             "goldencobra.url",
                                             data_type_name="string")
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung?test=1", 
                                     target_url: "www.google.de", 
                                     ignore_url_params: true, 
                                     active: true)
    end

    #ignore_url_params = true with given url params in redirection
    it "should not redirect on different url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/not_to_redirect")
      expect(redirector).to eq nil
    end

    it "should not redirect on similar but different url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiter")
      expect(redirector).to eq nil
    end

    it "should not redirect on similar but different url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitungen")
      expect(redirector).to eq nil
    end

    it "should redirect on same url" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung")
      expect(redirector).to eq ["http://www.google.de", 301]
    end

    it "should not redirect on same url with and a given subdir" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung/test")
      expect(redirector).to eq nil
    end

    it "should redirect on same url with url params" do
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?test=1&foo=bar")
      expect(redirector).to eq ["http://www.google.de?foo=bar&test=1", 301]
    end
  end

  describe 'more URL variants' do

    before do
      Goldencobra::Setting.set_value_for_key("http://www.google.de", 
                                             "goldencobra.url", 
                                             data_type_name="string")
    end
    #no url params given or set
    #ignore_url_params = true
    it "should not redirect on different url" do
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung", 
                                     target_url: "www.google.de", 
                                     ignore_url_params: true, 
                                     active: true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/not_to_redirect?test=2")
      expect(redirector).to eq nil
    end

    it "should not redirect on similar but different url" do
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung", 
                                     target_url: "www.google.de", 
                                     ignore_url_params: true, 
                                     active: true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiter?test=2")
      expect(redirector).to eq nil
    end

    it "should not redirect on similar but different url" do
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung", 
                                     target_url: "www.google.de", 
                                     ignore_url_params: true, 
                                     active: true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitungen?test=2")
      expect(redirector).to eq nil
    end

    it "should redirect on same url" do
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung", 
                                     target_url: "www.google.de", 
                                     ignore_url_params: true, 
                                     active: true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?test=2")
      expect(redirector).to eq ["http://www.google.de?test=2", 301]
    end

    it "should not redirect on same url with and a given subdir" do
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung", 
                                     target_url: "www.google.de", 
                                     ignore_url_params: true, 
                                     active: true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung/test?test=2")
      expect(redirector).to eq nil
    end

    it "should redirect on same url with url params" do
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung?test=1", 
                                     target_url: "www.google.de", 
                                     ignore_url_params: true, 
                                     active: true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?test=1&foo=bar")
      expect(redirector).to eq ["http://www.google.de?foo=bar&test=1", 301]
    end


    it "should redirect on same url with url params" do
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung?test=1", 
                                     target_url: "www.google.de", 
                                     ignore_url_params: false, 
                                     active: true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?test=1")
      expect(redirector).to eq ["http://www.google.de?test=1", 301]
    end

    it "should not redirect on same url with url params" do
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung?test=1", 
                                     target_url: "www.google.de", 
                                     ignore_url_params: false, 
                                     active: true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?test=2")
      expect(redirector).to eq nil
    end

    it "should not redirect on same url with url params" do
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung?test=1", 
                                     target_url: "www.google.de", 
                                     ignore_url_params: false, 
                                     active: true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?foo=1")
      expect(redirector).to eq nil
    end

    it "should redirect on same url with url params" do
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung?test=1",
                                     target_url: "www.google.de",
                                     ignore_url_params: false,
                                     active: true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?test=1&foo=bar")
      expect(redirector).to eq ["http://www.google.de?foo=bar&test=1", 301]
    end

    it "should redirect on same url with url params" do
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung?test=1", 
                                     target_url: "www.google.de",
                                     ignore_url_params: false,
                                     active: true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung")
      expect(redirector).to eq nil
    end

    it "should not redirect on same url with url params" do
      Goldencobra::Redirector.create(source_url: "www.yourdomain.de/weiterleitung?test=1&foo=1",
                                     target_url: "www.google.de",
                                     ignore_url_params: false,
                                     active: true)
      redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?foo=1")
      expect(redirector).to eq nil
    end
  end


  describe 'if an article is modified, a redirection should be created' do
    before(:each) do
      Goldencobra::Setting.set_value_for_key("http://www.goldencobra.de", "goldencobra.url")
      @root = Goldencobra::Article.create(url_name: "startseite", 
                                          breadcrumb: "Startseite", 
                                          title: "Startseite", 
                                          article_type: "Default Show")
      @root.mark_as_startpage!
      @seite1 = Goldencobra::Article.create(url_name: "seite1", 
                                            breadcrumb: "Seite1",
                                            title: "Seite1", 
                                            article_type: "Default Show", 
                                            parent: @root, 
                                            created_at: (Time.now - 25.hours))
      @seite2 = Goldencobra::Article.create(url_name: "seite2", 
                                            breadcrumb: "Seite2",
                                            title: "Seite2", 
                                            article_type: "Default Show", 
                                            parent: @seite1, 
                                            created_at: (Time.now - 25.hours))
      @seite3 = Goldencobra::Article.create(url_name: "seite3", 
                                            breadcrumb: "Seite3",
                                            title: "Seite3", 
                                            article_type: "Default Show", 
                                            parent: @seite1, 
                                            created_at: (Time.now - 25.hours))
      @seite4 = Goldencobra::Article.create(url_name: "seite4", 
                                            breadcrumb: "Seite4",
                                            title: "Seite4", 
                                            article_type: "Default Show", 
                                            parent: @seite3, 
                                            created_at: (Time.now - 25.hours))
    end

    it "not on normal article editing" do
      @seite1.title = "Neue Seite1"
      @seite1.save
      expect(Goldencobra::Redirector.all.count).to eq 0
    end

    it "if url_name changed" do
      expect(@seite3.absolute_public_url).to eq "http://www.goldencobra.de/seite1/seite3"
      @seite3.url_name = "neue_seite3"
      @seite3.save
      expect(@seite3.absolute_public_url).to eq "http://www.goldencobra.de/seite1/neue_seite3"
      expect(Goldencobra::Redirector.where(source_url: "http://www.goldencobra.de/seite1/seite3", target_url: "http://www.goldencobra.de/seite1/neue_seite3", active: true).count).to eq 1
    end

    it "if parent/ancestry changed for self" do
      expect(@seite3.absolute_public_url).to eq "http://www.goldencobra.de/seite1/seite3"
      @seite3.parent = @seite2
      @seite3.save
      expect(@seite3.absolute_public_url).to eq "http://www.goldencobra.de/seite1/seite2/seite3"
      expect(Goldencobra::Redirector.where(source_url: "http://www.goldencobra.de/seite1/seite3", target_url: "http://www.goldencobra.de/seite1/seite2/seite3", active: true).count).to eq 1
    end

    it "if parent/ancestry changed for self and url_name changed" do
      expect(@seite3.absolute_public_url).to eq "http://www.goldencobra.de/seite1/seite3"
      @seite3.url_name = "neue_seite3"
      @seite3.parent = @seite2
      @seite3.save
      expect(@seite3.absolute_public_url).to eq "http://www.goldencobra.de/seite1/seite2/neue_seite3"
      expect(Goldencobra::Redirector.where(source_url: "http://www.goldencobra.de/seite1/seite3", target_url: "http://www.goldencobra.de/seite1/seite2/neue_seite3", active: true).count).to eq 1
    end

    it "if parent/ancestry changed and url_name for childrens" do
      expect(@seite3.absolute_public_url).to eq "http://www.goldencobra.de/seite1/seite3"
      @seite3.parent = @seite2
      @seite3.url_name = "neue_seite3"
      @seite3.save
      expect(@seite3.absolute_public_url).to eq "http://www.goldencobra.de/seite1/seite2/neue_seite3"

      expect(Goldencobra::Redirector.where(source_url: "http://www.goldencobra.de/seite1/seite3", target_url: "http://www.goldencobra.de/seite1/seite2/neue_seite3", active: true).count).to eq 1
      
      #folgendes wäre ideal:
      #expect(Goldencobra::Redirector.where(:source_url => "http://www.goldencobra.de/seite1/seite3/seite4", :target_url => "http://www.goldencobra.de/seite1/seite2/neue_seite3/seite4", :active => true).count).to eq 1
      
      #Geht auch ist aber nicht ganz so schön:
      expect(Goldencobra::Redirector.where(source_url: "http://www.goldencobra.de/seite1/seite3/seite4", target_url: "http://www.goldencobra.de/seite1/seite2/seite3/seite4", active: true).count).to eq 1
      expect(Goldencobra::Redirector.where(source_url: "http://www.goldencobra.de/seite1/seite2/seite3/seite4", target_url: "http://www.goldencobra.de/seite1/seite2/neue_seite3/seite4", active: true).count).to eq 1
      
      expect(Goldencobra::Article.find_by_id(@seite3.id).absolute_public_url).to eq "http://www.goldencobra.de/seite1/seite2/neue_seite3"
      expect(Goldencobra::Article.find_by_id(@seite4.id).absolute_public_url).to eq "http://www.goldencobra.de/seite1/seite2/neue_seite3/seite4"
    end


    it "if parent changed for childrens" do
      expect(@seite1.absolute_public_url).to eq "http://www.goldencobra.de/seite1"
      @seite1.url_name = "neue_seite1"
      @seite1.save
      expect(@seite1.absolute_public_url).to eq "http://www.goldencobra.de/neue_seite1"
      expect(Goldencobra::Redirector.where(source_url: "http://www.goldencobra.de/seite1",
                                           target_url: "http://www.goldencobra.de/neue_seite1",
                                           active: true).count).to eq 1
      expect(Goldencobra::Redirector.where(source_url: "http://www.goldencobra.de/seite1/seite3",
                                           target_url: "http://www.goldencobra.de/neue_seite1/seite3",
                                           active: true).count).to eq 1
      expect(Goldencobra::Redirector.where(source_url: "http://www.goldencobra.de/seite1/seite3/seite4",
                                           target_url: "http://www.goldencobra.de/neue_seite1/seite3/seite4",
                                           active: true).count).to eq 1
      expect(Goldencobra::Article.find_by_id(@seite3.id).absolute_public_url).to eq "http://www.goldencobra.de/neue_seite1/seite3"
      expect(Goldencobra::Article.find_by_id(@seite4.id).absolute_public_url).to eq "http://www.goldencobra.de/neue_seite1/seite3/seite4"
    end

    it "not if new article is created on existing redirection source_url" do
      Goldencobra::Redirector.create(source_url: "http://www.goldencobra.de/neue_seite1",
                                     target_url: "http://www.goldencobra.de/neue_seite2")
      Goldencobra::Article.create(url_name: "neue_seite1",
                                  breadcrumb: "Neue Seite1",
                                  title: "Neue Seite1",
                                  article_type: "Default Show",
                                  parent: @root)
      expect(Goldencobra::Redirector.where(source_url: "http://www.goldencobra.de/neue_seite1",
                                           active: true).count).to eq 0
    end


  end


end
