class ChangeDefaultTypeToGoldencobraWidgets < ActiveRecord::Migration
  def change
    change_column :goldencobra_widgets, :default, :boolean
    
  end
end