class AddOfflineActiveToGoldencobraWidgets < ActiveRecord::Migration
  def change
    add_column :goldencobra_widgets, :offline_time_active, :boolean
  end
end
