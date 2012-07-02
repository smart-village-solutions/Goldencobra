class AddExtendableToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :expandable_id, :integer
    add_column :goldencobra_articles, :expandable_type, :string
  end
end
