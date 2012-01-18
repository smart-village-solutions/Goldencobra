# This migration comes from goldencobra (originally 20120112172723)
class AddIndexToArticles < ActiveRecord::Migration
  def up
    add_index :goldencobra_articles, :ancestry
  end
  
  def down
    remove_index :goldencobra_articles, :ancestry
  end
end
