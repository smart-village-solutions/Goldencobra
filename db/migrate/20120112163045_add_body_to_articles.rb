class AddBodyToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :content, :text
    add_column :articles, :teaser, :text
  end
end
