class ChangeDefaultTypeToGoldencobraWidgets < ActiveRecord::Migration
  def change
    remove_column :goldencobra_widgets, :default
    add_column :goldencobra_widgets, :default, :boolean
  end
end