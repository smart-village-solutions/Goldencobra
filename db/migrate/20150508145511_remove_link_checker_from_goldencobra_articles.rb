class RemoveLinkCheckerFromGoldencobraArticles < ActiveRecord::Migration
  def up
    remove_column :goldencobra_articles ,:link_checker
  end

  def down
    add_column :goldencobra_articles, :link_checker, :text
  end
end
