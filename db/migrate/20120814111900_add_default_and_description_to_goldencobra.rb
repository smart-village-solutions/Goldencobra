class AddDefaultAndDescriptionToGoldencobra < ActiveRecord::Migration
  def change
    add_column :goldencobra_widgets, :default, :string
    add_column :goldencobra_widgets, :description, :text
  end
end