class AddDescendentsdepthToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :index_of_articles_descendents_depth, :string, :default => "all"
    add_column :goldencobra_articles, :ancestry_depth, :integer, :default => 0
  end
end
