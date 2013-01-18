class AddPolyToGoldencobraRoleUsers < ActiveRecord::Migration
  def change
    add_column :goldencobra_roles_users, :operator_type, :string, :default => "User"
    rename_column :goldencobra_roles_users, :user_id, :operator_id
  end
end
