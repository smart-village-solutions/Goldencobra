class CreateGoldencobraUploads < ActiveRecord::Migration
  def change
    create_table :goldencobra_uploads do |t|
      t.string :source
      t.string :rights
      t.text :description
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size

      t.timestamps
    end
  end
end
