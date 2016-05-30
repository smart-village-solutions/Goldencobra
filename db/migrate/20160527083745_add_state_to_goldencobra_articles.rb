class AddStateToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :state, :integer, default: 0
  end
end
