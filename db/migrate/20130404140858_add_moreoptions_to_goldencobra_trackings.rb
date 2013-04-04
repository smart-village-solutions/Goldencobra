class AddMoreoptionsToGoldencobraTrackings < ActiveRecord::Migration
  def change
    add_column :goldencobra_trackings, :path, :string
    add_column :goldencobra_trackings, :page_duration, :string
    add_column :goldencobra_trackings, :view_duration, :string
    add_column :goldencobra_trackings, :db_duration, :string
  end
end
