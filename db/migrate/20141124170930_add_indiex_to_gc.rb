# encoding: utf-8

class AddIndiexToGc < ActiveRecord::Migration
  def change
    add_index "goldencobra_articles", ["title"], :name => "index_goldencobra_articles_on_title", :quiet => true
    add_index "goldencobra_articles", ["url_name"], :name => "index_goldencobra_articles_on_url_name", :quiet => true
    add_index "goldencobra_articles", ["active"], :name => "index_goldencobra_articles_on_active", :quiet => true
    add_index "goldencobra_articles", ["breadcrumb"], :name => "index_goldencobra_articles_on_breadcrumb", :quiet => true
    add_index "goldencobra_articles", ["url_path"], :name => "index_goldencobra_articles_on_url_path", :length => 200, :quiet => true

    add_index "goldencobra_menues", ["target"], :name => "index_goldencobra_articles_on_target", :quiet => true
    add_index "goldencobra_menues", ["active"], :name => "index_goldencobra_articles_on_active", :quiet => true

    add_index "goldencobra_redirectors", ["active"], :name => "index_goldencobra_articles_on_active", :quiet => true
    add_index "goldencobra_redirectors", ["source_url"], :name => "index_goldencobra_articles_on_source_url", :length => 200, :quiet => true
    add_index "goldencobra_redirectors", ["target_url"], :name => "index_goldencobra_articles_on_target_url", :length => 200, :quiet => true

    add_index "goldencobra_settings", ["title", "ancestry"], :name => "index_goldencobra_articles_on_title_and_ancestry", :quiet => true
    add_index "goldencobra_settings", ["title"], :name => "index_goldencobra_articles_on_title", :quiet => true
    add_index "goldencobra_settings", ["ancestry"], :name => "index_goldencobra_articles_on_ancestry", :quiet => true

    add_index "goldencobra_widgets", ["active"], :name => "index_goldencobra_articles_on_active", :quiet => true
    add_index "goldencobra_widgets", ["title", "active"], :name => "index_goldencobra_articles_on_title_and_active", :quiet => true
  end
end

