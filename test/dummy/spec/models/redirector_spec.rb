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

  it "should not redirect on different url" do
    redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/not_to_redirect")
    redirector.should == nil
  end

  #no url params given or set
  #ignore_url_params = true
  it "should not redirect on different url" do
    Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
    redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/not_to_redirect")
    redirector.should == nil
  end

  it "should not redirect on similar but different url" do
    Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
    redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiter")
    redirector.should == nil
  end

  it "should not redirect on similar but different url" do
    Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
    redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitungen")
    redirector.should == nil
  end

  it "should redirect on same url" do
    Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
    redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung")
    redirector.should == ["http://www.google.de", 301]
  end

  it "should not redirect on same url with and a given subdir" do
    Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
    redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung/test")
    redirector.should == nil
  end





  #ignore_url_params = true with given url params in redirection
  it "should not redirect on different url" do
    Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung?test=1", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
    redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/not_to_redirect")
    redirector.should == nil
  end

  it "should not redirect on similar but different url" do
    Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung?test=1", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
    redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiter")
    redirector.should == nil
  end

  it "should not redirect on similar but different url" do
    Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung?test=1", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
    redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitungen")
    redirector.should == nil
  end

  it "should redirect on same url" do
    Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung?test=1", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
    redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung")
    redirector.should == ["http://www.google.de", 301]
  end

  it "should not redirect on same url with and a given subdir" do
    Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung?test=1", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
    redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung/test")
    redirector.should == nil
  end

  it "should redirect on same url with url params" do
    Goldencobra::Redirector.create(:source_url => "www.yourdomain.de/weiterleitung?test=1", :target_url => "www.google.de", :ignore_url_params => true, :active => true)
    redirector = Goldencobra::Redirector.get_by_request("http://www.yourdomain.de/weiterleitung?test=1&foo=bar")
    redirector.should == ["http://www.google.de?test=1&foo=bar", 301]
  end




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
