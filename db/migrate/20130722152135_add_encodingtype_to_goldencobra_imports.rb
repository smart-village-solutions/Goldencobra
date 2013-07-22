class AddEncodingtypeToGoldencobraImports < ActiveRecord::Migration
  def change
    add_column :goldencobra_imports, :encoding_type, :string
  end
end
