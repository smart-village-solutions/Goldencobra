require 'spec_helper'
require "csv"

describe Goldencobra::Import do

  describe "Upload CSV file" do
    it "should be successful" do
      CSV.open("test_import.csv", "wb") do |csv|
        csv << ["Titel der Seite", "haupttext", "teaser text"]
        csv << ["erster titel", "ein text", "ein teaser"]
      end
      csv_file = File.open("test_import.csv", "r")
      new_upload = Goldencobra::Upload.create(:image => csv_file, :description => "CSV Datei")
      importer = Goldencobra::Import.new(:target_model => "Goldencobra::Article", :separator => ",", :upload_id => new_upload.id)
      importer.assignment = {"title" => "0", "content" => "1", "teaser" => "2"}
      importer.save
      importer.run!
      a = Goldencobra::Article.find_by_title("erster titel")
      a.should be_valid
      a.content.should == "ein text"
      a.teaser.should == "ein teaser"
      importer.result.should == []
    end
  end

  describe "Upload CSV file with wron entries" do
    it "should be successful" do
      CSV.open("test_import.csv", "wb") do |csv|
        csv << ["Titel der Seite", "haupttext", "teaser text"]
        csv << ["erster titel", "ein text", "ein teaser"]
        csv << ["", "ein leerer text", "ein doofer teaser"]
        csv << ["noch erster titel", "ein weiterer text", "ein anderer teaser"]
      end
      csv_file = File.open("test_import.csv", "r")
      new_upload = Goldencobra::Upload.create(:image => csv_file, :description => "CSV Datei")
      importer = Goldencobra::Import.new(:target_model => "Goldencobra::Article", :separator => ",", :upload_id => new_upload.id)
      importer.assignment = {"title" => "0", "content" => "1", "teaser" => "2"}
      importer.save
      importer.run!
      Goldencobra::Article.find_by_title("erster titel").should be_valid
      Goldencobra::Article.find_by_title("noch erster titel").should be_valid
      importer.result.first.should == "2 - {:title=>[\"can't be blank\"]}"
    end
  end



end
