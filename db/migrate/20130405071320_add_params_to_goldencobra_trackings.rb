class AddParamsToGoldencobraTrackings < ActiveRecord::Migration
  def change
    add_column :goldencobra_trackings, :url_paremeters, :string
  end
end
