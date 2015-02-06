# encoding: utf-8

class AddSorterToGoldencobraPermissions < ActiveRecord::Migration
  def change
    # das hier ist schon in der Migration CreateGoldencobraPermissions enthalten
    # add_column :goldencobra_permissions, :sorter_id, :integer, :default => 0
  end
end
