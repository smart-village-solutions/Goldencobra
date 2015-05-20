# encoding: utf-8

require 'spec_helper'

class DummyClass
  # http://yehudakatz.com/2010/01/10/activemodel-make-any-ruby-object-feel-like-activerecord/
  # http://api.rubyonrails.org/classes/ActiveModel/AttributeMethods/ClassMethods.html#method-i-define_attribute_method
  include ActiveModel::AttributeMethods
  define_attribute_method :url_attr
  attr_accessor :url_attr

  def attributes
    { 'url_attr' => @url_attr }
  end

  # http://jeffgardner.org/2011/05/26/adding-activerecord-style-callbacks-to-activeresource-models/
  extend ActiveModel::Callbacks
  define_model_callbacks :save, only: [:before]
  def save
    run_callbacks :save do
      # Your save action methods here
    end
  end

  extend HttpValidator
  web_url :url_attr
end

describe HttpValidator do
  context "without protocol" do
    subject { DummyClass.new }

    it "adds 'http://' if missing" do
      subject.url_attr = "www.google.de"

      subject.save

      expect(subject.url_attr).to eq("http://www.google.de")
    end

    it "adds nothing if nothing is present" do
      subject.url_attr = ""

      subject.save

      expect(subject.url_attr).to eq("")
    end
  end

  context "with http" do
    subject { DummyClass.new }

      it "adds nothing if 'http://' is present" do
      subject.url_attr = "http://www.google.de"

      subject.save

      expect(subject.url_attr).to eq("http://www.google.de")
    end
  end

  context "with https" do
    subject { DummyClass.new }

      it "adds nothing if 'https://' is present" do
      subject.url_attr = "https://www.google.de"

      subject.save

      expect(subject.url_attr).to eq("https://www.google.de")
    end
  end
end
