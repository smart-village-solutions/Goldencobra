class AddStartpageToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :startpage, :boolean, :default => false
  end
end
