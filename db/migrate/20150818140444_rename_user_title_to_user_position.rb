class RenameUserTitleToUserPosition < ActiveRecord::Migration
  def change
    rename_column :users, :title, :position
  end
end
