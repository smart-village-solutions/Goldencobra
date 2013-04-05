class AddGoogleparamsToGoldencobraTrackings < ActiveRecord::Migration
  def change
    add_column :goldencobra_trackings, :utm_source, :string
    add_column :goldencobra_trackings, :utm_medium, :string
    add_column :goldencobra_trackings, :utm_term, :string
    add_column :goldencobra_trackings, :utm_content, :string
    add_column :goldencobra_trackings, :utm_campaign, :string
  end
end
