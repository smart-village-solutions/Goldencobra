# encoding: utf-8

class AddPositionToGoldencobraArticletypeGroup < ActiveRecord::Migration
  def change
    add_column :goldencobra_articletype_groups, :position, :string, :default => "first_block"
  end
end
