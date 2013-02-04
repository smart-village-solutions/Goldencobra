class AddLocationoptionToGoldencobraLocations < ActiveRecord::Migration
  def change
    add_column :goldencobra_locations, :street_number, :string
  end
end
