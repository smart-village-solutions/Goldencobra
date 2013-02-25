class AddRedirectToGoldencobraRoles < ActiveRecord::Migration
  def change
    add_column :goldencobra_roles, :redirect_after_login, :string, :default => "reload"
  end
end
