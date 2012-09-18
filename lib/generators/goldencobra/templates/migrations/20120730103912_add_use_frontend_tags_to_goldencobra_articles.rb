class AddUseFrontendTagsToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :use_frontend_tags, :boolean, default: false
  end
end
