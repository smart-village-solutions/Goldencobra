# This migration comes from goldencobra (originally 20120113170904)
class AddStartpageToArticle < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :startpage, :boolean, :default => false
  end
end
