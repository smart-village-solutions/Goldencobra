class AddExternaldateToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :external_updated_at, :datetime
  end
end
