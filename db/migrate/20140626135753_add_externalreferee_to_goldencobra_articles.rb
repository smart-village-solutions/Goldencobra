class AddExternalrefereeToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :external_referee_id, :string
    add_column :goldencobra_articles, :external_referee_ip, :string
  end
end
