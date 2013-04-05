class AddLocationToTracking < ActiveRecord::Migration
  def change
    add_column :goldencobra_trackings, :location, :string
  end
end
