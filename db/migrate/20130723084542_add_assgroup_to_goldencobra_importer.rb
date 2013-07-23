class AddAssgroupToGoldencobraImporter < ActiveRecord::Migration
  def change
    add_column :goldencobra_imports, :assignment_groups, :text
  end
end
