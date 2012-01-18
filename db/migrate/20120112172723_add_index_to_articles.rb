class AddIndexToArticles < ActiveRecord::Migration
  def up
    add_index :articles, :ancestry
  end
  
  def down
    remove_index :articles, :ancestry
  end
end
