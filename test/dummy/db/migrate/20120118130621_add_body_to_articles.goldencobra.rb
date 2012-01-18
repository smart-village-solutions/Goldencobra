# This migration comes from goldencobra (originally 20120112163045)
class AddBodyToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :content, :text
    add_column :articles, :teaser, :text
  end
end
