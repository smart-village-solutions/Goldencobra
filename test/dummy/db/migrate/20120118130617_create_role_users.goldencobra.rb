# This migration comes from goldencobra (originally 20120109141338)
class CreateRoleUsers < ActiveRecord::Migration
  def change
    create_table :roles_users, :id => false do |t|
      t.integer :user_id
      t.integer :role_id

      t.timestamps
    end
  end
end
