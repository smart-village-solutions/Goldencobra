class AddActivesinceToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :active_since, :datetime
  end
end
