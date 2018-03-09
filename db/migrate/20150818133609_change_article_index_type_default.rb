class ChangeArticleIndexTypeDefault < ActiveRecord::Migration[4.2]
  def change
    change_column :goldencobra_articles, :display_index_types, :string, :default => "all"
  end
end
