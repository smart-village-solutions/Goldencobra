# encoding: utf-8

class CreateGoldencobraArticletypeFields < ActiveRecord::Migration
  def change
    create_table :goldencobra_articletype_fields do |t|
      t.integer :articletype_group_id
      t.string :fieldname
      t.integer :sorter, :default => 0
      t.string :class_name

      t.timestamps
    end
  end
end
