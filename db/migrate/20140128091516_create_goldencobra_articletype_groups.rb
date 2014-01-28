# encoding: utf-8

class CreateGoldencobraArticletypeGroups < ActiveRecord::Migration
  def change
    create_table :goldencobra_articletype_groups do |t|
      t.string :title
      t.boolean :expert, :default => false
      t.boolean :foldable, :default => true
      t.boolean :closed, :default => true
      t.integer :sorter, :default => 0
      t.integer :articletype_id

      t.timestamps
    end
  end
end
