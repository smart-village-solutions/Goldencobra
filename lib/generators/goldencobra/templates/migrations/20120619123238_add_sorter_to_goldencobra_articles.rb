class AddSorterToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :sort_order, :string
  end
end
