class CreateGoldencobraAuthors < ActiveRecord::Migration
  def change
    create_table :goldencobra_authors do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :googleplus

      t.timestamps
    end
  end
end
