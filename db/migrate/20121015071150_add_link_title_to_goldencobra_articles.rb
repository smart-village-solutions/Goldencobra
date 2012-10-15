class AddLinkTitleToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :redirect_link_title, :string
  end
end
