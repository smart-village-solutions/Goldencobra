class CreateGoldencobraSettings < ActiveRecord::Migration
  def change
    create_table :goldencobra_settings do |t|
      t.string :title
      t.string :value
      t.string :ancestry

      t.timestamps
    end
  end
end
