class AddOptionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender, :boolean
    add_column :users, :title, :string
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :function, :string
    add_column :users, :phone, :string
    add_column :users, :fax, :string
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
    add_column :users, :linkedin, :string
    add_column :users, :xing, :string
    add_column :users, :googleplus, :string
  end
end
