# encoding: utf-8

class AddDomainToGoldencobraPermissions < ActiveRecord::Migration
  def change
    add_column :goldencobra_permissions, :domain_id, :integer
  end
end
