require 'spec_helper'

# has_many :role_users, :as => :operator
# has_many :roles, :through => :role_users

describe User do
  it {should have_many(:roles).through(:role_users)}
end