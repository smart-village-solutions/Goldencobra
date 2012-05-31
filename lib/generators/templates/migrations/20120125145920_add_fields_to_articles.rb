class AddFieldsToArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :active, :boolean, :default => true
    add_column :goldencobra_articles, :subtitle, :string
    add_column :goldencobra_articles, :summary, :text
    add_column :goldencobra_articles, :context_info, :text
    add_column :goldencobra_articles, :canonical_url, :string
  end
end
