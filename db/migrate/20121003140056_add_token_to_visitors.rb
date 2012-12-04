class AddTokenToVisitors < ActiveRecord::Migration
  def change
    add_column :visitors, :confirmation_token, :string
    add_column :visitors, :confirmed_at, :datetime
    add_column :visitors, :confirmation_sent_at, :datetime
    add_column :visitors, :unconfirmed_email, :string
    add_column :visitors, :failed_attempts, :integer
    add_column :visitors, :unlock_token, :string
    add_column :visitors, :locked_at, :datetime
    add_column :visitors, :authentication_token, :string
  end
end
