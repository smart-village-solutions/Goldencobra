class AddBreadcrumbToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :breadcrumb, :string

  end
end
