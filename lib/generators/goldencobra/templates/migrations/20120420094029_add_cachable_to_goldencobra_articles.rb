class AddCachableToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :cacheable, :boolean, :default => true
  end
end
