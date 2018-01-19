class AddShowindexarticlesToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :display_index_articles, :boolean, default: false
  end
end
