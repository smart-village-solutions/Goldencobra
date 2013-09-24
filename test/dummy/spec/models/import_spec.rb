require 'spec_helper'
require "csv"

describe Goldencobra::Import do

  describe "Upload CSV file" do
    it "should be successful" do
      csv_file = File.open("test/test_import.csv", "r")
      new_upload = Goldencobra::Upload.create(:image => csv_file, :description => "CSV Datei")
      importer = Goldencobra::Import.new(:target_model => "Goldencobra::Article", :separator => ";", :upload_id => new_upload.id, :encoding_type => "UTF-8")
      #importer.article_type = "Default Show"
      #importer.assignment = {"title" => "0", "content" => "1", "teaser" => "2"}
      importer.assignment = {"Goldencobra::ImportMetadata"=>{"database_owner"=>{"data_function"=>"Default", "option"=>"", "csv"=>"0"},
                                "database_admin_first_name"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "database_admin_last_name"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "database_admin_email"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "database_admin_phone"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "exported_at"=>{"data_function"=>"Default", "option"=>"", "csv"=>"1"}
                              },
                             "Goldencobra::Article"=>{
                                "article_type" => {"data_function"=>"Static Value", "option"=>"Default Show", "csv"=>""},
                                "breadcrumb" => {"data_function"=>"Default", "option"=>"", "csv"=>"0"},
                                "title"=>{"data_function"=>"Default", "option"=>"", "csv"=>"0"},
                                "content"=>{"data_function"=>"Default", "option"=>"", "csv"=>"38"},
                                "teaser"=>{"data_function"=>"Default", "option"=>"", "csv"=>"37"},
                                "ancestry"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "startpage"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "active"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "subtitle"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "summary"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "context_info"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "canonical_url"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "robots_no_index"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "template_file"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "article_for_index_id"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "article_for_index_levels"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "article_for_index_count"=>{"data_function"=>"Default", "option"=>"", "csv"=>""}
                              },
                              "Goldencobra::Widget_widgets"=>{
                                "title"=>{"data_function"=>"Default", "option"=>"", "csv"=>"8"},
                                "content"=>{"data_function"=>"Static Value", "option"=>"Test", "csv"=>""},
                                "css_name"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "active"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "id_name"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "sorter"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "mobile_content"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "teaser"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "default"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "description"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "offline_days"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "offline_time_active"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "alternative_content"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "offline_date_start"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "offline_date_end"=>{"data_function"=>"Default", "option"=>"", "csv"=>""},
                                "offline_time_week_start_end"=>{"data_function"=>"Default", "option"=>"", "csv"=>""}
                              },
                              "Goldencobra::Widget"=>{
                                  "ActsAsTaggableOn::Tag" => {
                                    "tags"=>{"name"=>{"data_function"=>"Static Value", "option"=>"test", "csv"=>""}}
                                  }
                              }
                            }
      importer.assignment_groups = {"Goldencobra::Article"=>"create", "Goldencobra::Metatag"=>"create", "Goldencobra::Metatag_Goldencobra::Article_article"=>"create",
                                    "Goldencobra::Widget"=>"update", "Goldencobra::Widget_Goldencobra::Article_articles"=>"create",
                                    "Goldencobra::Widget_ActsAsTaggableOn::Tagging_taggings"=>"create", "Goldencobra::Widget_ActsAsTaggableOn::Tag_base_tags"=>"update",
                                    "Goldencobra::Widget_ActsAsTaggableOn::Tagging_tag_taggings"=>"create", "Goldencobra::Widget_ActsAsTaggableOn::Tag_tags"=>"create",
                                    "Goldencobra::Vita"=>"create", "Goldencobra::Vita_ActsAsTaggableOn::Tagging_taggings"=>"create",
                                    "Goldencobra::Vita_ActsAsTaggableOn::Tag_base_tags"=>"create", "Goldencobra::Vita_ActsAsTaggableOn::Tagging_tag_taggings"=>"create",
                                    "Goldencobra::Vita_ActsAsTaggableOn::Tag_tags"=>"create", "Goldencobra::Comment"=>"create",
                                    "Goldencobra::Comment_Goldencobra::Article_article"=>"create", "Goldencobra::Author"=>"create",
                                    "Goldencobra::Author_Goldencobra::Article_article"=>"create", "ActsAsTaggableOn::Tagging"=>"create",
                                    "ActsAsTaggableOn::Tagging_ActsAsTaggableOn::Tag_tag"=>"create", "ActsAsTaggableOn::Tag"=>"create",
                                    "ActsAsTaggableOn::Tag_ActsAsTaggableOn::Tagging_taggings"=>"create"}
      importer.save
      importer.run!
      article = Goldencobra::Article.find_by_title("Landessportbund Berlin")
      article.present?.should be_true
      article.should be_valid
      article.content.should == "Salewski"
      article.teaser.should == "Herr"
      article.widgets.count.should == 1
      puts ActsAsTaggableOn::Tag.all.inspect
      article.widgets.first.content.should == "Test"
      article.widgets.first.tag_list.should == ["test"]
      #importer.result.should == []
    end
  end


end
