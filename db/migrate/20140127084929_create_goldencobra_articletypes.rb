# encoding: utf-8

class CreateGoldencobraArticletypes < ActiveRecord::Migration
  def up
    create_table :goldencobra_articletypes do |t|
      t.string :name
      t.string :default_template_file

      t.timestamps
    end
  end

  def down
  	drop_table :goldencobra_articletypes
  end
end
