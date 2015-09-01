# encoding: utf-8

require 'spec_helper'

# has_many :role_users, :as => :operator
# has_many :roles, :through => :role_users

describe User do
  it { should have_many(:roles).through(:role_users) }

  describe "ensure_authentication_token" do
    it "makes sure an auth token is present for the user" do
      u = User.create(firstname: "Tim", lastname: "Test", email: "tim@example.com",
                      password: "12345678", password_confirmation: "12345678")

      expect(u.authentication_token).to_not eq(nil)
    end
  end
end
