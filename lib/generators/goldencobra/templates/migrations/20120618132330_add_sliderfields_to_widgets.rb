class AddSliderfieldsToWidgets < ActiveRecord::Migration
  def change
    add_column :goldencobra_widgets, :mobile_content, :text
  end
end
