class AddReverseSortToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :reverse_sort, :boolean
  end
end
