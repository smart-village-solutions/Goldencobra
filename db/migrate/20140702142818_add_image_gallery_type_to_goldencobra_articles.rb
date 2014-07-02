class AddImageGalleryTypeToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :image_gallery_type, :string, default: "lightbox"
  end
end
