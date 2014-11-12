# encoding: utf-8

class AddGlobalsortingToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :global_sorting_id, :integer, :default => 0
  end
end
