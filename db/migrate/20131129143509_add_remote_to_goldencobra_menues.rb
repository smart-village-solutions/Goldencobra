class AddRemoteToGoldencobraMenues < ActiveRecord::Migration
  def change
    add_column :goldencobra_menues, :remote, :boolean, :default => false
  end
end
