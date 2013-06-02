class AddIndextypesToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :display_index_types, :string, :default => "show"
  end
end
