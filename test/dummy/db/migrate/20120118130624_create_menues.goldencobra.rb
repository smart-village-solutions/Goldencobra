# This migration comes from goldencobra (originally 20120113100243)
class CreateMenues < ActiveRecord::Migration
  def change
    create_table :menues do |t|
      t.string :title
      t.string :target
      t.string :css_class
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
