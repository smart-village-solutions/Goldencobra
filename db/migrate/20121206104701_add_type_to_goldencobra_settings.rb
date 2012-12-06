class AddTypeToGoldencobraSettings < ActiveRecord::Migration
  def change
    add_column :goldencobra_settings, :data_type, :string, :default => "string"
  end
end
