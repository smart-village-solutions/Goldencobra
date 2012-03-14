class AddTemplateToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :template_file, :string

  end
end
