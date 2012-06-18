class AddTeaserToGoldencobraWidgets < ActiveRecord::Migration
  def change
    add_column :goldencobra_widgets, :teaser, :string
  end
end
