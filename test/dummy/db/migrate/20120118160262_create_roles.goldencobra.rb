# This migration comes from goldencobra (originally 20120109140423)
class CreateRoles < ActiveRecord::Migration
  def change
    create_table :goldencobra_roles do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
