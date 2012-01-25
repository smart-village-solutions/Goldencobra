class AddNoindexToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :robots_no_index, :boolean, :default => false
  end
end
