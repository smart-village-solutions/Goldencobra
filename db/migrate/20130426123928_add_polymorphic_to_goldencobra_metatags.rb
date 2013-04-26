class AddPolymorphicToGoldencobraMetatags < ActiveRecord::Migration
  def change
    add_column :goldencobra_metatags, :metatagable_id, :integer
    add_column :goldencobra_metatags, :metatagable_type, :string
  end
end
