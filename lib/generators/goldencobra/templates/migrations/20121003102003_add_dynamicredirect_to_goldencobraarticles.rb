class AddDynamicredirectToGoldencobraarticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :dynamic_redirection, :string, :default => "false"
    add_column :goldencobra_articles, :redirection_target_in_new_window, :boolean, :default => false
  end
end
