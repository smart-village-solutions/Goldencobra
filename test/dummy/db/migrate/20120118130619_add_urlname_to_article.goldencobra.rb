# This migration comes from goldencobra (originally 20120110112157)
class AddUrlnameToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :url_name, :string
    add_column :articles, :slug, :string
    add_index :articles, :slug
  end
end
