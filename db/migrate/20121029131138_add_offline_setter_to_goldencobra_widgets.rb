class AddOfflineSetterToGoldencobraWidgets < ActiveRecord::Migration
  def change
    add_column :goldencobra_widgets, :offline_time, :string
  end
end
