class AddShowindexarticlesToGoldencobraArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :goldencobra_articles, :display_index_articles, :boolean, default: false
  end
end
