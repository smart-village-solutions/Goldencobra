class AddAncestryToMenues < ActiveRecord::Migration
  def change
    add_column :goldencobra_menues, :ancestry, :string
    add_index :goldencobra_menues, :ancestry
  end
end
