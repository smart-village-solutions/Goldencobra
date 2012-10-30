class CreateRoleUsers < ActiveRecord::Migration
  def change
    create_table :goldencobra_roles_users, :id => false do |t|
      t.integer :user_id
      t.integer :role_id
    end
  end
end
