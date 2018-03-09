class AddStateToGoldencobraArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :goldencobra_articles, :state, :integer, default: 0
  end
end
