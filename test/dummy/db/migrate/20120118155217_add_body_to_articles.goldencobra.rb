# This migration comes from goldencobra (originally 20120112163045)
class AddBodyToArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :content, :text
    add_column :goldencobra_articles, :teaser, :text
  end
end
