class AddArticleindeximagesToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :article_for_index_images, :boolean, :default => false

  end
end
