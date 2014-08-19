class AddUrlpathToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :url_path, :text
  end
end
