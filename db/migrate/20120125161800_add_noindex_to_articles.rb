class AddNoindexToArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :robots_no_index, :boolean, :default => false
  end
end
