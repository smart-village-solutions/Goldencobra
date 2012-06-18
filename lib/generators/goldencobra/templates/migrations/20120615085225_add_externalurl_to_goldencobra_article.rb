class AddExternalurlToGoldencobraArticle < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :external_url_redirect, :string
  end
end
