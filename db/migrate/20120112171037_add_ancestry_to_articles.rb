class AddAncestryToArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :ancestry, :string

  end
end
