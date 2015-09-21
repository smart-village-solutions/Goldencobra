class ChangeArticleIndexTypeDefault < ActiveRecord::Migration
  def change
    change_column :goldencobra_articles, :display_index_types, :string, :default => "all"
  end
end
