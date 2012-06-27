class AddAuthorToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :author, :string
  end
end
