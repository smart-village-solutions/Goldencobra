require 'spec_helper'

describe Goldencobra::AttributeValidator do

  describe "#self.validate_url" do

    subject { Goldencobra::AttributeValidator }

    it "requires a model name and an attribute name" do
      expect{subject.validate_url}.to raise_error(ArgumentError)
    end

    it "raises an error without a model name" do
      expect{subject.validate_url(:public_url)}.to raise_error(ArgumentError)
    end

    it "raises an error without an attribute name" do
      expect{subject.validate_url(Goldencobra::Article)}.to raise_error(ArgumentError)
    end

    it "returns 'Not a valid model name' unless model_name is a real class" do
      expect(subject.validate_url("Goldencobra::NoArticle", :url_name)).to eq("Not a valid model name")
    end

    it "returns 'Not a valid attribute on Goldencobra::Article' unless it's a real attribute" do
      expect(subject.validate_url(Goldencobra::Article, :no_real_attribute)).to eq("Not a valid attribute on Goldencobra::Article")
    end

    it "should catch duplicate 'http' entries" do
      create(:article, canonical_url: "http://http://example.com")

      expect(subject.validate_url(Goldencobra::Article, :canonical_url)).to eq([{
                                                                             class: Goldencobra::Article,
                                                                             id: Goldencobra::Article.last.id,
                                                                             value: Goldencobra::Article.last.canonical_url
                                                                           }])
    end

    it "returns an empty array if all entities have correct values" do
      5.times do |i|
        create(:article, canonical_url: "http://www.example.com/#{i}-foo")
      end

      expect(subject.validate_url(Goldencobra::Article, :canonical_url)).to eq([])
    end
  end
end
