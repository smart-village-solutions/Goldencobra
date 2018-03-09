class RenameUserTitleToUserPosition < ActiveRecord::Migration[4.2]
  def change
    rename_column :users, :title, :position
  end
end
