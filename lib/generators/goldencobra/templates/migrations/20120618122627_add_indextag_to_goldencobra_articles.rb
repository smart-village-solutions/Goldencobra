class AddIndextagToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :index_of_articles_tagged_with, :string
  end
end
