class AddTitleToGoldencobraLocations < ActiveRecord::Migration
  def change
    add_column :goldencobra_locations, :title, :string
  end
end
