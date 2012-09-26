class AddPositionToGoldencobraArticleImages < ActiveRecord::Migration
  def change
    add_column :goldencobra_article_images, :position, :string
  end
end
