class AddNameToGoldencobraWidgets < ActiveRecord::Migration
  def change
    add_column :goldencobra_widgets, :id_name, :string

  end
end
