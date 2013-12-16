# encoding: utf-8

class AddMainToGoldencobraDomains < ActiveRecord::Migration
  def change
    add_column :goldencobra_domains, :main, :boolean, :default => false
  end
end
