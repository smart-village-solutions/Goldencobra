class CreateGoldencobraImportMetadata < ActiveRecord::Migration
  def change
    create_table :goldencobra_import_metadata do |t|
      t.string :database_owner
      t.datetime :exported_at
      t.string :database_admin_first_name
      t.string :database_admin_last_name
      t.string :database_admin_phone
      t.string :database_admin_email
      t.integer :importmetatagable_id
      t.string :importmetatagable_type

      t.timestamps
    end
  end
end
