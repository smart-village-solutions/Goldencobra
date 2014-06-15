# encoding: utf-8

class ResizeLinkCheckfield < ActiveRecord::Migration
  def up
    change_column :goldencobra_articles, :link_checker, :text, :limit => 4294967295
    change_column :versions, :object, :text, :limit => 4294967295
  end

  def down
    change_column :goldencobra_articles, :link_checker, :text
    change_column :versions, :object, :text
  end
end
