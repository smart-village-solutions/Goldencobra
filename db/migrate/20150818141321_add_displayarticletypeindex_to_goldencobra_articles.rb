class AddDisplayarticletypeindexToGoldencobraArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :goldencobra_articles, :display_index_articletypes, :string, :default => "all"
  end
end
