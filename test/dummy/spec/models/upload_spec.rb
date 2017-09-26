# encoding: utf-8

require "spec_helper"

describe Goldencobra::Upload do
  before(:all) do
    @zip = Goldencobra::Upload.create(image: File.open(File.join(Rails.root, "spec/fixtures/files/test_archive.zip")))
    @zip_severals = Goldencobra::Upload.create(image: File.open(File.join(Rails.root, "spec/fixtures/files/test_archive_severals.zip")))
    @zip_subfolders = Goldencobra::Upload.create(image: File.open(File.join(Rails.root, "spec/fixtures/files/test_archive_subfolders.zip")))
  end

  it "can upload and unzip a zip file" do
     @zip.unzip_files
  end

  it "creates an Goldencobra::Upload for each file contained" do
    expect { @zip.unzip_files }.to change(Goldencobra::Upload, :count).by(1)
    expect { @zip_severals.unzip_files }.to change(Goldencobra::Upload, :count).by(3)
  end

  it "keeps the original name of the file" do
    @zip.unzip_files
    last_record = Goldencobra::Upload.last.image_file_name

    expect(last_record).to eq("test.png")
  end

  it "also extracts images in subfolders" do
    expect { @zip_subfolders.unzip_files }.to change(Goldencobra::Upload, :count).by(5)
  end
end
