class AddOperatorToGoldencobraPermissions < ActiveRecord::Migration
  def change
    add_column :goldencobra_permissions, :operator_id, :integer
  end
end
