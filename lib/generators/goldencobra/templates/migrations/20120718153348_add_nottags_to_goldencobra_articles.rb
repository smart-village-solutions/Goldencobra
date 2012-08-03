class AddNottagsToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :not_tagged_with, :string
  end
end
