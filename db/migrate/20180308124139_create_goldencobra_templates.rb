class CreateGoldencobraTemplates < ActiveRecord::Migration
  def change
    create_table :goldencobra_templates do |t|
      t.string :title
      t.string :layout_file_name

      t.timestamps null: false
    end
  end
end
