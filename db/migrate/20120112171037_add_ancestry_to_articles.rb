class AddAncestryToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :ancestry, :string

  end
end
