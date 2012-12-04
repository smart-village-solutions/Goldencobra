class AddUsernameToVisitors < ActiveRecord::Migration
  def change
    add_column :visitors, :username, :string
  end
end
