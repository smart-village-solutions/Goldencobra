class AddSorterToGoldencobraWidgets < ActiveRecord::Migration
  def change
    add_column :goldencobra_widgets, :sorter, :integer

  end
end
