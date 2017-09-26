# encoding: utf-8

require 'spec_helper'

# has_many :role_users, :as => :operator
# has_many :roles, :through => :role_users

describe Visitor, type: :model do
  it { should have_many(:role_users).class_name("Goldencobra::RoleUser") }
  it { should have_many(:roles).through(:role_users).class_name("Goldencobra::Role") }
end