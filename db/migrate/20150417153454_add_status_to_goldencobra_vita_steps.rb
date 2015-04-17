class AddStatusToGoldencobraVitaSteps < ActiveRecord::Migration
  def change
    add_column :goldencobra_vita, :status_cd, :integer, :default => 0
  end
end
