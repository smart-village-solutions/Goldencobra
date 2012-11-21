class AddDatumToWidgets < ActiveRecord::Migration
  def change
    add_column :goldencobra_widgets, :offline_date_start, :date
    add_column :goldencobra_widgets, :offline_date_end, :date
  end
end
