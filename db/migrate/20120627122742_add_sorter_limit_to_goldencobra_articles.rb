class AddSorterLimitToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :sorter_limit, :integer
  end
end
