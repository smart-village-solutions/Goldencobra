# encoding: utf-8

require "spec_helper"

describe Goldencobra::Upload do
  it "can upload a zip file" do
     zip = Goldencobra::Upload.create(image: File.open(File.join(Rails.root, "spec/fixtures/files/test_archive.zip")))
     zip.unzip_files
  end

  it "creates an Goldencobra::Upload for each file contained" do
    zip = Goldencobra::Upload.create(image: File.open(File.join(Rails.root, "spec/fixtures/files/test_archive.zip")))
    zip2 = Goldencobra::Upload.create(image: File.open(File.join(Rails.root, "spec/fixtures/files/test_archive_severals.zip")))

    expect { zip.unzip_files }.to change(Goldencobra::Upload, :count).by(1)
    expect { zip2.unzip_files }.to change(Goldencobra::Upload, :count).by(3)
  end

  it "keeps the original name of the file" do
    zip = Goldencobra::Upload.create(image: File.open(File.join(Rails.root, "spec/fixtures/files/test_archive.zip")))
    zip.unzip_files
    last_record = Goldencobra::Upload.last.image_file_name

    expect(last_record).to eq("test.png")
  end

  it "also extracts images in subfolders" do
    zip = Goldencobra::Upload.create(image: File.open(File.join(Rails.root, "spec/fixtures/files/test_archive_subfolders.zip")))

    expect { zip.unzip_files }.to change(Goldencobra::Upload, :count).by(5)
  end
end
