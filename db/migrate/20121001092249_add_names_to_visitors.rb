class AddNamesToVisitors < ActiveRecord::Migration
  def change
    add_column :visitors, :first_name, :string
    add_column :visitors, :last_name, :string
  end
end
