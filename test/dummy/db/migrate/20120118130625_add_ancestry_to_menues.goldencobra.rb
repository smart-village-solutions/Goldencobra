# This migration comes from goldencobra (originally 20120113101714)
class AddAncestryToMenues < ActiveRecord::Migration
  def change
    add_column :menues, :ancestry, :string
    add_index :menues, :ancestry
  end
end
