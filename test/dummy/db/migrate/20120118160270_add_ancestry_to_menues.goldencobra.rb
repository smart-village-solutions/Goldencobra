# This migration comes from goldencobra (originally 20120113101714)
class AddAncestryToMenues < ActiveRecord::Migration
  def change
    add_column :goldencobra_menues, :ancestry, :string
    add_index :goldencobra_menues, :ancestry
  end
end
