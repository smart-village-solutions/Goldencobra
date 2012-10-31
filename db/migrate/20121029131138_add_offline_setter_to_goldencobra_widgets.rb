class AddOfflineSetterToGoldencobraWidgets < ActiveRecord::Migration
  def change
    add_column :goldencobra_widgets, :offline_days, :string
    add_column :goldencobra_widgets, :offline_time_start, :datetime
    add_column :goldencobra_widgets, :offline_time_end, :datetime
  end
end
