class AddFieldsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :active, :boolean, :default => true
    add_column :articles, :subtitle, :string
    add_column :articles, :summary, :text
    add_column :articles, :context_info, :text
    add_column :articles, :canonical_url, :string
  end
end
