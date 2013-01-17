class CreateGoldencobraHelps < ActiveRecord::Migration
  def change
    create_table :goldencobra_helps do |t|
      t.string :title
      t.text :description
      t.string :url

      t.timestamps
    end
  end
end
