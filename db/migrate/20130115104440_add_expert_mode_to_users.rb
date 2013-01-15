class AddExpertModeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :enable_expert_mode, :boolean, default: 0
  end
end
