class AddLinkcheckerToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :link_checker, :text
  end
end
