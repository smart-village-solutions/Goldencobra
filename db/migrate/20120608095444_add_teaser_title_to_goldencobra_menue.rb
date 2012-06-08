class AddTeaserTitleToGoldencobraMenue < ActiveRecord::Migration
  def change
    add_column :goldencobra_menues, :description_title, :string
  end
end
