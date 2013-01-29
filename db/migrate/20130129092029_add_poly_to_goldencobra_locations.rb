class AddPolyToGoldencobraLocations < ActiveRecord::Migration
  def change
    add_column :goldencobra_locations, :locateable_type, :string
    add_column :goldencobra_locations, :locateable_id, :integer
  end
end
