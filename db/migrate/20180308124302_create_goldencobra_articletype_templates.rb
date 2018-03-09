class CreateGoldencobraArticletypeTemplates < ActiveRecord::Migration
  def change
    create_table :goldencobra_articletype_templates do |t|
      t.integer :articletype_id
      t.integer :template_id

      t.timestamps null: false
    end
  end
end
