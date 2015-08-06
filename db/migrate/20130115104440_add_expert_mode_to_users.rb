class AddExpertModeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :enable_expert_mode, :boolean, default: 1
  end
end
