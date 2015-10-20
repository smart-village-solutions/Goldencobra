# encoding: utf-8

# == Schema Information
#
# Table name: goldencobra_roles
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  description          :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  redirect_after_login :string(255)      default("reload")
#

module Goldencobra
  class Role < ActiveRecord::Base
      attr_accessible :name, :description, :redirect_after_login

      validates_presence_of :name

      has_many :role_users
      has_many :permissions
  end
end
