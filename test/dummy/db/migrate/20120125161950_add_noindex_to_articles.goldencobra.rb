# This migration comes from goldencobra (originally 20120125161800)
class AddNoindexToArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :robots_no_index, :boolean, :default => false
  end
end
