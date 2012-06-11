class CreateGoldencobraImports < ActiveRecord::Migration
  def change
    create_table :goldencobra_imports do |t|
      t.text :assignment
      t.string :target_model
      t.boolean :successful
      t.integer :upload_id
      t.string :separator, :default => ","
      t.text :result
      t.timestamps
    end
  end
end
