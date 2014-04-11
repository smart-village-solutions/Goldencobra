class AddCreatorIdToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :creator_id, :integer
  end
end
