class AddLoginableToVisitors < ActiveRecord::Migration
  def change
    add_column :visitors, :loginable_type, :string
    add_column :visitors, :loginable_id, :integer
  end
end
