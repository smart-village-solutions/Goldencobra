class AddImagegalleryToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :image_gallery_tags, :string
  end
end
