require "spec_helper"

describe Goldencobra::AttributeRepairService do

  describe "#fix_duplicate_http" do

    subject { Goldencobra::AttributeRepairService }

    context "with missing or too little arguments" do
      it "requires a model name, an id and an attribute name" do
        expect{subject.fix_duplicate_http}.to raise_error(ArgumentError)
      end

      it "raises an error without a model name" do
        expect{subject.fix_duplicate_http(1, :public_url)}.to raise_error(ArgumentError)
      end

      it "raises an error without an attribute name" do
        expect{subject.fix_duplicate_http("Goldencobra::Article", 1)}.to raise_error(ArgumentError)
      end

      it "raises an error without an id" do
        expect{subject.fix_duplicate_http("Goldencobra::Article", :canonical_url)}.to raise_error(ArgumentError)
      end
    end

    context "with wrong attributes" do
      it "returns 'Not a valid model name' unless model_name is a real class" do
        expect(subject.fix_duplicate_http("Goldencobra::NoArticle", 1, :url_name)).to eq("Not a valid model name")
      end

      it "returns 'Not a valid attribute on Goldencobra::Article' unless it's a real attribute" do
        expect(subject.fix_duplicate_http(Goldencobra::Article, 1, :no_real_attribute)).to eq("Not a valid attribute on Goldencobra::Article")
      end

      it "returns 'Record not found' unless record exists" do
        expect(subject.fix_duplicate_http(Goldencobra::Article, 1, :canonical_url)).to eq("Record not found")
      end
    end

    it "repairs faulty url values and saves them" do
      create(:article, canonical_url: "http://http://example.com")

      expect(Goldencobra::Article.last.canonical_url).to eq("http://http://example.com")

      subject.fix_duplicate_http(Goldencobra::Article, Goldencobra::Article.last.id, :canonical_url)

      expect(Goldencobra::Article.last.canonical_url).to eq("http://example.com")


      create(:article, canonical_url: "https://https://example.com")

      expect(Goldencobra::Article.last.canonical_url).to eq("https://https://example.com")

      subject.fix_duplicate_http(Goldencobra::Article, Goldencobra::Article.last.id, :canonical_url)

      expect(Goldencobra::Article.last.canonical_url).to eq("https://example.com")
    end
  end
end
