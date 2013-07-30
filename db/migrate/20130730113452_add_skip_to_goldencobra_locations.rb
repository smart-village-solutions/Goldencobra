class AddSkipToGoldencobraLocations < ActiveRecord::Migration
  def change
    add_column :goldencobra_locations, :manual_geocoding, :boolean, :default => false
  end
end
