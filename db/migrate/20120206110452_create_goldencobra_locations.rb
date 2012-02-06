class CreateGoldencobraLocations < ActiveRecord::Migration
  def change
    create_table :goldencobra_locations do |t|
      t.string :lat
      t.string :lng
      t.string :street
      t.string :city
      t.string :zip
      t.string :region
      t.string :country

      t.timestamps
    end
  end
end
