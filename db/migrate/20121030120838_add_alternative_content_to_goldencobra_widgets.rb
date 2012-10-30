class AddAlternativeContentToGoldencobraWidgets < ActiveRecord::Migration
  def change
    add_column :goldencobra_widgets, :alternative_content, :text
  end
end
