class AddOptionsToGoldencobraTrackings < ActiveRecord::Migration
  def change
    add_column :goldencobra_trackings, :user_agent, :string
    add_column :goldencobra_trackings, :language, :string
  end
end
