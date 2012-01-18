class CreateRoles < ActiveRecord::Migration
  def change
    create_table :goldencobra_roles do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
